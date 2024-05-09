1 contract ERC20():
2     def balanceOf(_owner: address) -> uint256: constant
3     def decimals() -> uint256: constant
4 
5 MIN_PRICE: constant(uint256) = 1000000 # 10**6
6 MAX_PRICE: constant(uint256) = 100000000000000000000000000 # 10**(8 + 18)
7 PRICE_MULTIPLIER: constant(uint256) = 100000000 # 10**8
8 
9 PriceUpdated: event({token_address: indexed(address), new_price: indexed(uint256)})
10 TokenAddressUpdated: event({token_address: indexed(address), token_index: indexed(int128)})
11 
12 name: public(string[16])
13 owner: public(address)
14 supported_tokens: public(address[5])
15 normalized_token_prices: public(map(address, uint256))
16 
17 @public
18 def __init__():
19     self.owner = msg.sender
20     self.name = 'PriceOracle'
21 
22 @public
23 @constant
24 def poolSize(contract_address: address) -> uint256:
25     token_address: address
26     total: uint256 = 0
27 
28     for ind in range(5):
29         token_address = self.supported_tokens[ind]
30         if token_address != ZERO_ADDRESS:
31             contract_balance: uint256 = ERC20(token_address).balanceOf(contract_address)
32             total += contract_balance * self.normalized_token_prices[token_address] / PRICE_MULTIPLIER
33 
34     return total
35 
36 @public
37 def updateTokenAddress(token_address: address, ind: int128) -> bool:
38     assert msg.sender == self.owner
39 
40     self.supported_tokens[ind] = token_address
41     log.TokenAddressUpdated(token_address, ind)
42 
43     return True
44 
45 @public
46 # Token price is as uint256:
47 # normalized_usd_price = usd_price * PRICE_MULTIPLIER * 10**(stablecoinswap.decimals - token.decimals)
48 # Example: USD price for USDC = $0.97734655, normalized_usd_price = 97734655000000000000
49 def updatePrice(token_address: address, normalized_usd_price: uint256) -> bool:
50     assert msg.sender == self.owner
51     assert MIN_PRICE <= normalized_usd_price and normalized_usd_price <= MAX_PRICE
52 
53     self.normalized_token_prices[token_address] = normalized_usd_price
54     log.PriceUpdated(token_address, normalized_usd_price)
55 
56     return True