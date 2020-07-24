defmodule ExAliyun.OpenSearch.Authorization do
  @moduledoc """
  签名机制

  [docs link](https://help.aliyun.com/document_detail/54237.html)
  """

  def make_get_header(path, query, access_key_id, access_key_secret) do
    date = DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.to_iso8601()
    {mega_sec, sec, micro_sec} = :os.timestamp()
    nonce = to_string(mega_sec * 1_000_000_000_000 + sec * 1_000_000 + micro_sec)

    data =
      "GET\n\napplication/json\n" <>
        date <>
        "\nx-opensearch-nonce:" <>
        nonce <> "\n" <> build_canonicalized_resource(path, query)

    signature =
      :crypto.hmac(:sha, access_key_secret, data)
      |> Base.encode64()

    [
      {"Date", date},
      {"Content-Type", "application/json"},
      {"Authorization", "OPENSEARCH " <> access_key_id <> ":" <> signature},
      {"X-Opensearch-Nonce", nonce}
    ]
  end

  def make_post_header(path, body, access_key_id, access_key_secret) do
    date = DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.to_iso8601()
    content_md5 = :crypto.hash(:md5, body) |> Base.encode16(case: :upper)

    data =
      "POST\n" <>
        content_md5 <>
        "\napplication/json\n" <>
        date <> "\n" <> build_path(path)

    signature =
      :crypto.hmac(:sha, access_key_secret, data)
      |> Base.encode64()

    [
      {"Date", date},
      {"Content-Type", "application/json"},
      {"Authorization", "OPENSEARCH " <> access_key_id <> ":" <> signature},
      {"Content-MD5", content_md5}
    ]
  end

  @compile {:inline, build_canonicalized_resource: 2, build_path: 1, build_query: 1}
  defp build_canonicalized_resource(path, query) do
    case Enum.count(query) do
      0 ->
        build_path(path)

      _ ->
        build_path(path) <> "?" <> build_query(query)
    end
  end

  defp build_path(path) do
    path
    |> URI.encode_www_form()
    |> String.replace("%2F", "/")
  end

  defp build_query(query) do
    query
    |> Stream.reject(&match?({_, ""}, &1))
    |> Enum.sort()
    |> Stream.map(fn {k, v} ->
      URI.encode(to_string(k), &URI.char_unreserved?/1) <>
        "=" <> URI.encode(to_string(v), &URI.char_unreserved?/1)
    end)
    |> Enum.join("&")
    |> String.replace("%26%26", "&&")
  end
end
