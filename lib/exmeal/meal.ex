defmodule Exmeal.Meal do
  use Ecto.Schema

  import Ecto.Changeset

  alias Exmeal.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:description, :date, :calories, :user_id]
  @update_params [:description, :calories, :user_id]

  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  schema "meals" do
    field :calories, :integer
    field :date, :date, virtual: true
    field :datetime, :utc_datetime
    field :description, :string

    belongs_to :user, User

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> put_meal_datetime()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, @update_params)
    |> validate_required(@update_params)
  end

  defp put_meal_datetime(
         %Ecto.Changeset{
           valid?: true,
           changes: %{date: date}
         } = changeset
       ) do
    change(changeset, convert_to_datetime(date))
  end

  defp put_meal_datetime(changeset), do: changeset

  def format_meal_date({:ok, %{datetime: datetime} = meal}) do
    %{date: date} = convert_to_date(datetime)
    {:ok, %{meal | date: date}}
  end

  def format_meal_date(result), do: result

  defp convert_to_datetime(date) do
    %{datetime: DateTime.new!(date, ~T[00:00:00])}
  end

  defp convert_to_date(datetime) do
    %{date: Date.new!(datetime.year, datetime.month, datetime.day)}
  end
end
