defmodule Sportfest.Repo do
  use Ecto.Repo,
    otp_app: :sportfest,
    adapter: Ecto.Adapters.Postgres

    @doc """
    Used to unpack the result tuple {:ok, struct} and preload some fields of the struct after transactions.

    ## Examples
        iex> preload_on_result_tuple({:ok, struct}, preloads_list)
        {:ok, struct_with_preloaded_fields}
    """
    def preload_on_result_tuple({:ok, struct}, preloads_list) do
      {:ok, preload(struct, preloads_list) }
    end
    def preload_on_result_tuple(result_tuple, _preloads_list) do
      result_tuple
    end

end
