bool priceValidation(String price) {
  for (int i = 0; i < price.length; i++)
    if (!'.0123456789'.contains(price[i])) return false;
  if (price.indexOf('.') != price.lastIndexOf('.')) return false;
  return true;
}
