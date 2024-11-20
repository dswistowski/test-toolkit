from typing import Annotated

from cachetools import TTLCache
from fastapi import FastAPI, HTTPException, Path

app = FastAPI()

cache: TTLCache = TTLCache(maxsize=256, ttl=60)


@app.post("/store/{store_id}/{value}")
async def set_store(
    store_id: Annotated[str, Path(max_length=50)],
    value: Annotated[str, Path(max_length=50)],
) -> str:
    """
    Store some value in memory for some time
    """
    cache[store_id] = value
    return value


@app.get("/store/{store_id}")
async def get_store(store_id: Annotated[str, Path(max_length=50)]) -> str:
    """
    Get some value in memory for some time
    """
    try:
        return cache[store_id]

    except KeyError:
        raise HTTPException(status_code=404, detail="Store not found")
