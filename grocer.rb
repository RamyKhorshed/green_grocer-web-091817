require 'pry'

def consolidate_cart(cart)
  # code here
  output = {}
  cart.each do |item|
    item.each do |name, details|
      if !!output[name]
        output[name] = details
        output[name][:count] += 1
      else
        output[name] = details
        output[name][:count] = 1
      end
    end
  end
  puts output
  output
end

def apply_coupons(cart, coupons)
  couponcounter = 0
  coupons.each do |coupon|
    names = coupon[:item]
    if !!cart[names] && cart[names][:count] >=  coupon[:num]
      newHash={}
      newHash[:price] = coupon[:cost]
      newHash[:clearance] = cart[names][:clearance]
      if !cart.key?("#{names} W/COUPON")
        couponcounter = 1
      else
        couponcounter = cart["#{names} W/COUPON"][:count] + 1
      end
      newHash[:count] = couponcounter
      cart[names][:count] = cart[names][:count] - coupon[:num]
      cart["#{names} W/COUPON"] = newHash
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, details|
    details[:price] = (details[:price]*0.8).round(2) if details[:clearance]
  end
end

def checkout(cart, coupons)
  total = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart.each do |item, details|
    total += details[:price] * details[:count]
  end
  total = 0.9 * total if total > 100
  total
end
