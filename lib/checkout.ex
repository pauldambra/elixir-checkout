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
      do: get_price item)
      |> Enum.sum
  end

  defp get_price({:A, amount}), do: get_special_price(%{amount: 3, price: 130}, 50, amount, 0)
  defp get_price({:B, amount}), do: get_special_price(%{amount: 2, price: 45}, 30, amount, 0)
  defp get_price({:C, amount}), do: get_price(20, amount)
  defp get_price({:D, amount}), do: get_price(15, amount)

  defp get_price(cost, amount) do
    cost * amount
  end

  defp get_special_price(offer, normal_cost, amount, current_total) do
    if amount >= offer.amount do
        get_special_price(offer, normal_cost, amount - offer.amount, current_total + offer.price)
    else # amount is now either less than the offer anmount or 0
        current_total + get_price(normal_cost, amount)
    end
  end
end
