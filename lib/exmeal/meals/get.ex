defmodule Exmeal.Meals.Get do
  alias Exmeal.{Error, Repo, Meal}

  def by_id(id) do
    case Repo.get(Meal, id) do
      nil -> {:error, Error.build_meal_not_found_error()}
      meal -> {:ok, meal} |> Meal.format_meal_date()
    end
  end
end
