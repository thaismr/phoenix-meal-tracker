defmodule Exmeal.Meals.Delete do
  alias Exmeal.{Error, Repo, Meal}

  def call(id) do
   case Repo.get(Meal, id) do
    nil -> {:error, Error.build_meal_not_found_error()}
    meal -> Repo.delete(meal) |> Meal.format_meal_date()
   end
  end
end
