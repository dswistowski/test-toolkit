FROM python:3.13 AS build
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /code

COPY ./pyproject.toml ./uv.lock /code
RUN uv sync --no-dev

FROM python:3.13 AS runtime

WORKDIR /code
COPY --from=build /code /code/
COPY . /code/
EXPOSE 8000
ENV PATH="/code/.venv/bin:$PATH"

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers=1"]
