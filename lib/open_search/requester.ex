defmodule ExAliyun.OpenSearch.Requester do
  @moduledoc false
  alias ExAliyun.OpenSearch.Authorization

  def get(path, query, config) do
    [
      {Tesla.Middleware.Headers,
       Authorization.make_get_header(
         path,
         query,
         config[:access_key_id],
         config[:access_key_secret]
       )},
      {Tesla.Middleware.BaseUrl, config[:endpoint]},
      Tesla.Middleware.DecodeJson,
      Tesla.Middleware.Logger
    ]
    |> Tesla.client(Tesla.Adapter.Hackney)
    |> Tesla.get(path, query: query)
    |> case do
      {:ok, %{status: 200, body: body}} ->
        {:ok, 200, body}

      {:ok, %{status: status, body: body}} ->
        {:error, status, body}

      error ->
        error
    end
  end

  def post(path, data, config) do
    body = Jason.encode!(data)

    [
      {Tesla.Middleware.Headers,
       Authorization.make_post_header(
         path,
         body,
         config[:access_key_id],
         config[:access_key_secret]
       )},
      {Tesla.Middleware.BaseUrl, config[:endpoint]},
      Tesla.Middleware.DecodeJson,
      Tesla.Middleware.Logger
    ]
    |> Tesla.client(Tesla.Adapter.Hackney)
    |> Tesla.post(path, body)
    |> case do
      {:ok, %{status: 200, body: body}} ->
        {:ok, 200, body}

      {:ok, %{status: status, body: body}} ->
        {:error, status, body}

      error ->
        error
    end
  end
end
