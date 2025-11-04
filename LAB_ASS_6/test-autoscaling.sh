#!/bin/bash

# Load test script to trigger autoscaling

set -e

echo "🚀 Starting load test to trigger autoscaling..."
echo "This will generate load on the ping server to test HPA"

# Check if the service is running
if ! kubectl get deployment ping-server &> /dev/null; then
    echo "❌ ping-server deployment not found. Please run ./deploy.sh first"
    exit 1
fi

echo "📊 Initial pod status:"
kubectl get pods -l app=ping-server
echo ""

echo "📈 Initial HPA status:"
kubectl get hpa ping-server-hpa
echo ""

echo "🔥 Generating load for autoscaling test..."
echo "   Method 1: High frequency ping requests"
echo "   Method 2: CPU stress endpoint calls"
echo ""

# Start monitoring in background
{
    echo "Time,Pods,CPU_Current,CPU_Target,Min_Replicas,Current_Replicas,Max_Replicas" > scaling_log.csv
    for i in {1..180}; do
        pod_count=$(kubectl get pods -l app=ping-server --no-headers | wc -l | tr -d ' ')
        hpa_info=$(kubectl get hpa ping-server-hpa --no-headers 2>/dev/null || echo "unknown unknown unknown unknown unknown unknown")
        echo "${i}s,${pod_count},${hpa_info}" | tr ' ' ',' >> scaling_log.csv
        sleep 1
    done
} &
MONITOR_PID=$!

# Method 1: High frequency requests
echo "🎯 Starting concurrent ping requests..."
for i in {1..5}; do
    kubectl run load-ping-$i --rm -i --restart=Never --image=curlimages/curl -- /bin/sh -c "
        for j in \$(seq 1 100); do
            curl -s http://ping-server-service/ping > /dev/null &
            sleep 0.1
        done
        wait
    " &
done

# Method 2: CPU stress requests
echo "💪 Starting CPU stress requests..."
for i in {1..3}; do
    kubectl run load-stress-$i --rm -i --restart=Never --image=curlimages/curl -- /bin/sh -c "
        for j in \$(seq 1 20); do
            curl -s 'http://ping-server-service/stress?duration=3000' > /dev/null &
            sleep 1
        done
        wait
    " &
done

echo ""
echo "� Monitoring autoscaling for 3 minutes..."
echo "💡 Watch the replica count increase as CPU usage rises"
echo ""

# Display real-time status
for i in {1..180}; do
    clear
    echo "� Autoscaling Test - Time: ${i}s/180s"
    echo "=================================="
    echo ""
    echo "📈 HPA Status:"
    kubectl get hpa ping-server-hpa 2>/dev/null || echo "HPA not found"
    echo ""
    echo "🎯 Pod Status:"
    kubectl get pods -l app=ping-server --no-headers | awk '{print "  " $1 " - " $3 " (Ready: " $2 ")"}'
    echo ""
    echo "📊 Pod Count: $(kubectl get pods -l app=ping-server --no-headers | wc -l | tr -d ' ')"
    echo ""
    echo "💾 Logs being saved to: scaling_log.csv"
    echo "Press Ctrl+C to stop early"
    sleep 1
done

# Clean up
echo ""
echo "🧹 Cleaning up..."
kill $MONITOR_PID 2>/dev/null || true

# Clean up load generators
for i in {1..5}; do
    kubectl delete pod load-ping-$i 2>/dev/null || true &
done

for i in {1..3}; do
    kubectl delete pod load-stress-$i 2>/dev/null || true &
done

wait

echo ""
echo "📊 Final status:"
kubectl get pods -l app=ping-server
echo ""
kubectl get hpa ping-server-hpa
echo ""
echo "📈 Scaling log saved to: scaling_log.csv"
echo "🔍 View scaling data: cat scaling_log.csv"
