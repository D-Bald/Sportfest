defmodule Sportfest.Utils.ListItems do
  @moduledoc """
    Utility Modul zum Umgang mit Items in Listen
  """

  @doc """
  Tauscht das gegeben item mit einem Item in der Liste aus, dass die gleiche id hat.
  Falls es nicht in der Liste ist, wird es der Liste hinzugefügt.

  ## Examples

      iex> replace_item_by_id_or_add(alistofscores, %Score{})
      [...,%Score{},...]

  """
  def replace_item_by_id_or_add(list, item) do
    location = Enum.find_index(list, fn i -> i.id == item.id end)
    case location do
      nil -> [item | list]
      location -> List.replace_at(list,
                                  location,
                                  item)
    end
  end
end
