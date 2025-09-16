from litestar import Litestar, get
from datetime import datetime


@get("/")
async def health_check() -> dict:
    return {"status": "healthy", "message": "Litestar API is running!", "timestamp": datetime.now().isoformat()}


@get("/hello")
async def hello() -> dict:
    return {"message": "Hello from Litestar!"}


@get("/info")
async def info() -> dict:
    return {
        "app": "Litestar Demo API",
        "version": "1.0.0",
        "description": "Simple API for CI/CD demonstration"
    }


app = Litestar(route_handlers=[health_check, hello, info])


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)