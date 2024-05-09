1 contract Exchange():
2     def setup(token_addr: address): modifying
3 
4 NewExchange: event({token: indexed(address), exchange: indexed(address)})
5 
6 exchangeTemplate: public(address)
7 tokenCount: public(uint256)
8 token_to_exchange: address[address]
9 exchange_to_token: address[address]
10 id_to_token: address[uint256]
11 
12 @public
13 def initializeFactory(template: address):
14     assert self.exchangeTemplate == ZERO_ADDRESS
15     assert template != ZERO_ADDRESS
16     self.exchangeTemplate = template
17 
18 @public
19 def createExchange(token: address) -> address:
20     assert token != ZERO_ADDRESS
21     assert self.exchangeTemplate != ZERO_ADDRESS
22     assert self.token_to_exchange[token] == ZERO_ADDRESS
23     exchange: address = create_with_code_of(self.exchangeTemplate)
24     Exchange(exchange).setup(token)
25     self.token_to_exchange[token] = exchange
26     self.exchange_to_token[exchange] = token
27     token_id: uint256 = self.tokenCount + 1
28     self.tokenCount = token_id
29     self.id_to_token[token_id] = token
30     log.NewExchange(token, exchange)
31     return exchange
32 
33 @public
34 @constant
35 def getExchange(token: address) -> address:
36     return self.token_to_exchange[token]
37 
38 @public
39 @constant
40 def getToken(exchange: address) -> address:
41     return self.exchange_to_token[exchange]
42 
43 @public
44 @constant
45 def getTokenWithId(token_id: uint256) -> address:
46     return self.id_to_token[token_id]