defmodule Checkout do

  defstruct [
    basket: %{A: 0, B: 0, C: 0, D: 0}
  ]

  def scan(checkout, code) do
    new_value = checkout.basket[code] + 1
    %{checkout | basket: Map.put(checkout.basket, code, new_value)}
  end

  def total(checkout) do
    (for item <- checkout.basket,
      do: getPrice item)
      |> Enum.sum
  end

  defp getPrice({:A, amount}), do: getSpecialPrice(%{amount: 3, price: 130}, 50, amount, 0)
  defp getPrice({:B, amount}), do: getSpecialPrice(%{amount: 2, price: 45}, 30, amount, 0)
  defp getPrice({:C, amount}), do: getPrice(20, amount)
  defp getPrice({:D, amount}), do: getPrice(15, amount)

  defp getPrice(cost, amount) do
    cost * amount
  end

  defp getSpecialPrice(offer, normal_cost, amount, current_total) do
    if amount >= offer.amount do
        getSpecialPrice(offer, normal_cost, amount - offer.amount, current_total + offer.price)
    else # amount is now either less than the offer anmount or 0
        current_total + getPrice(normal_cost, amount)
    end
  end
end
