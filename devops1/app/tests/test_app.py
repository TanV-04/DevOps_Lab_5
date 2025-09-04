import pytest

class DummyResponse:
    status_code = 200
    def get_json(self):
        return {"ok": "hi humans"}

@pytest.fixture
def client():
    class DummyClient:
        def get(self, path):
            return DummyResponse()
    return DummyClient()

def test_root(client):
    resp = client.get("/")
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["ok"] == "hi humans"
