defmodule ExAliyun.OpenSearch do
  @moduledoc """
  Documentation for `ExAliyun.OpenSearch`.
  """
  import ExAliyun.OpenSearch.Requester
  @instance :access_config

  @compile {:inline, config: 0}
  @doc false
  def config do
    Application.get_env(:ex_aliyun_opensearch, @instance)
  end

  @doc """
  获取应用列表 - [docs link](https://help.aliyun.com/document_detail/57153.html#h2-u83B7u53D6u5E94u7528u5217u88686)
  """
  def list_apps(page \\ 1, size \\ 10) do
    "/v3/openapi/apps"
    |> get(%{page: page, size: size}, config())
  end

  @doc """
  查看应用信息 - [docs link](https://help.aliyun.com/document_detail/57153.html)
  """
  def app_info(app_name) do
    "/v3/openapi/apps/#{app_name}"
    |> get(%{}, config())
  end

  @doc """
  数据处理 - [docs link](https://help.aliyun.com/document_detail/57154.html)
  """
  def push_docs(app_name, table_name, data) do
    "/v3/openapi/apps/#{app_name}/#{table_name}/actions/bulk"
    |> post(data, config())
  end

  @doc """
  搜索处理 - [docs link](https://help.aliyun.com/document_detail/57155.html)
  """
  def search(app_name, query) do
    "/v3/openapi/apps/#{app_name}/search"
    |> get(query, config())
  end

  @doc """
  下拉提示 - [docs link](https://help.aliyun.com/document_detail/57156.html)
  """
  def suggestions(suggestion_name, query) do
    "/v3/openapi/suggestions/#{suggestion_name}/actions/search"
    |> get(query, config())
  end

  @doc """
  查询热词列表 - [docs link](https://help.aliyun.com/document_detail/172878.html#h2-u67E5u8BE2u70EDu8BCDu5217u88681)
  """
  def hot_keywords(app_name, query) do
    "/v3/openapi/apps/#{app_name}/actions/hot"
    |> get(query, config())
  end

  @doc """
  查询底纹列表 - [docs link](https://help.aliyun.com/document_detail/172878.html#h2-u67E5u8BE2u5E95u7EB9u5217u88682)
  """
  def hint_keywords(app_name, query) do
    "/v3/openapi/apps/#{app_name}/actions/hint"
    |> get(query, config())
  end

  @doc """
  查询下拉提示列表 - [docs link](https://help.aliyun.com/document_detail/172880.html)
  """
  def suggest_keywords(app_name, query) do
    "/v3/openapi/apps/#{app_name}/actions/suggest"
    |> get(query, config())
  end
end
