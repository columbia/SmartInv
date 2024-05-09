1 # @version 0.3.7
2 # @notice NPC-ers Minter
3 # @author npcers.eth
4 # @license MIT
5 
6 """
7          :=+******++=-:                 
8       -+*+======------=+++=:            
9      #+========------------=++=.        
10     #+=======------------------++:      
11    *+=======--------------------:++     
12   =*=======------------------------*.   
13  .%========-------------------------*.  
14  %+=======-------------------------:-#  
15 +*========--------------------------:#  
16 %=========--------------------------:#. 
17 %=========--------------------+**=--:++ 
18 #+========-----=*#%#=--------#@@@@+-::*:
19 :%========-----+@@@@%=-------=@@@@#-::+=
20  -#======-------+@@@%=----=*=--+**=-::#:
21   :#+====---------==----===@%=------::% 
22     #+===-------------======@%=------:=+
23     .%===------------=======+@%------::#
24      #+==-----------=========+@%-------+
25      %===------------*%%%%%%%%@@#-----#.
26      %====-----------============----#: 
27      *+==#+----------+##%%%%%%%%@--=*.  
28      -#==+%=---------=+=========--*=    
29       +===+%+--------------------*-     
30        =====*#=------------------#      
31        .======*#*=------------=*+.      
32          -======+*#*+--------*+         
33           .-========+***+++=-.          
34              .-=======:           
35 
36 """
37 
38 
39 from vyper.interfaces import ERC20
40 
41 interface ERC721:
42     def mint(recipient: address): nonpayable
43     def totalSupply() -> uint256: nonpayable
44 
45 interface ThingToken:
46     def mint(recipient: address, amount: uint256): nonpayable
47 
48 # Addresses
49 owner: public(address)
50 nft_addr: public(address)
51 token_addr: public(address)
52 
53 # Mint Parameters
54 min_price: public(uint256)
55 
56 # Coupon!
57 coupon_token: public(address)
58 whitelist: public(HashMap[address, bool])
59 used_coupon: public(HashMap[address, uint256])
60 whitelist_max: public(uint256)
61 
62 # Airdrop!
63 is_erc20_drop_live: public(bool)
64 erc20_drop_quantity: public(uint256)
65 
66 # Constants
67 MAX_MINT: constant(uint256) = 6000
68 BATCH_LIMIT: constant(uint256) = 10
69 
70 WITHDRAW_LIST: constant(address[4]) = [
71     0xccBF601eB2f5AA2D5d68b069610da6F1627D485d, 
72     0xAdcB949a288ec2500c1109f9876118d064c40dA6,
73     0xc59eae56D3F0052cdDe752C10373cd0B86451EB2,
74     0x84865Bb349998D6b813DB7Cc0F722fD0A94e6e27
75 ]
76 
77 WITHDRAW_PCT: constant(uint256[4]) = [
78     25,
79     25,
80     25,
81     15
82 ]
83 
84 
85 @external
86 def __init__():
87     self.owner = msg.sender
88     self.min_price = as_wei_value(0.008, "ether")
89     self.whitelist_max = 3
90     self.erc20_drop_quantity = 1000 * 10**18
91     self.is_erc20_drop_live = True
92        
93 
94 @internal
95 @view
96 def _has_coupon(addr: address) -> bool:
97     has_coupon: bool = False
98     if self.used_coupon[addr] >= self.whitelist_max:
99         has_coupon = False
100     elif self.whitelist[addr] == True:
101         has_coupon = True
102     elif self.coupon_token == empty(address):
103         has_coupon = False
104     elif ERC20(self.coupon_token).balanceOf(addr) > 0:
105         has_coupon = True
106 
107     return has_coupon
108 
109 
110 @external
111 @view
112 def has_coupon(addr: address) -> bool:
113     """
114     @notice Check if the user is authorized for free mints
115     @param addr Address to check eligibility
116     @return bool True if eligible
117     """
118     return self._has_coupon(addr)
119 
120 
121 @internal
122 @view
123 def _mint_price(quantity: uint256, addr: address) -> uint256:
124     if self._has_coupon(addr):
125         mints_left: uint256 = self.whitelist_max - self.used_coupon[addr]
126         return self.min_price * (quantity - min(quantity, mints_left))
127     else:
128         return self.min_price * quantity
129 
130 
131 @external
132 @view
133 def mint_price(quantity: uint256, addr: address) -> uint256:
134     """
135     @notice Calculate price of minting a quantity of NFTs for a specific address
136     @param quantity Number of NFTs to mint
137     @param addr Address to mint for
138     """
139     return self._mint_price(quantity, addr)
140 
141 
142 @external
143 @payable
144 def mint(quantity: uint256):
145     """
146     @notice Mint up to MAX_MINT NFTs at a time.  Also supplies $THING if drop is live.
147     @param quantity The number of NFTs to mint
148     """
149     assert quantity <= BATCH_LIMIT  # dev: Mint batch capped
150     assert msg.value >= self._mint_price(quantity, msg.sender)
151     supply: uint256 = ERC721(self.nft_addr).totalSupply()
152 
153     assert supply + quantity < MAX_MINT  # dev: Exceed max mint cap
154 
155     for i in range(BATCH_LIMIT):
156         if i >= quantity:
157             break
158 
159         ERC721(self.nft_addr).mint(msg.sender)
160 
161     if self.is_erc20_drop_live:
162         ThingToken(self.token_addr).mint(
163             msg.sender, quantity * self.erc20_drop_quantity
164         )
165 
166     if self._has_coupon(msg.sender):
167         self.used_coupon[msg.sender] += min(
168             quantity, self.whitelist_max - self.used_coupon[msg.sender]
169         )
170 
171 
172 @external
173 def premint(target: address):
174     """
175     @notice Treasury reserves
176     @dev Revert if somebody has already minted
177     """
178     assert ERC721(self.nft_addr).totalSupply() == 0
179     for i in range(100):
180         ERC721(self.nft_addr).mint(target)
181 
182 @external
183 def admin_set_nft_addr(addr: address):
184     """
185     @notice Update NFT address
186     @param addr New contract address
187     """
188     assert msg.sender == self.owner
189     self.nft_addr = addr
190 
191 
192 @external
193 def admin_set_token_addr(addr: address):
194     """
195     @notice Update address of ERC-20 token
196     @param addr New contract address
197     """
198     assert msg.sender == self.owner
199     self.token_addr = addr
200 
201 
202 @external
203 def admin_new_owner(new_owner: address):
204     """
205     @notice Update owner of minter contract
206     @param new_owner New contract owner address
207     """
208     assert msg.sender == self.owner  # dev: "Admin Only"
209     self.owner = new_owner
210 
211 
212 @external
213 def withdraw():
214     """
215     @notice Withdraw funds to withdraw list
216     @dev Anybody can call, triggers withdraw in proportion, remainder to owner
217     """
218     init_bal : uint256 = self.balance
219 
220     for i in range(4):
221         send(WITHDRAW_LIST[i], init_bal * WITHDRAW_PCT[i] / 100)
222     
223     send(self.owner, self.balance)
224 
225 
226 @external
227 def admin_update_coupon_token(token: address):
228     """
229     @notice Holders of any ERC20 coupon token are eligible for free mint
230     @param token Address of ERC20 token
231     """
232     assert self.owner == msg.sender  # dev: "Admin Only"
233     self.coupon_token = token
234 
235 
236 @external
237 def admin_add_to_whitelist(addr: address):
238     """
239     @notice Whitelist a specific address for free mints i
240     @dev defined by whitelist_max
241     @param addr Address to add to whitelist
242     """
243     assert self.owner == msg.sender  # dev: "Admin Only"
244     self.whitelist[addr] = True
245 
246 
247 @external
248 def admin_mint_erc20(addr: address, quantity: uint256):
249     """
250     @notice Mint $THING tokens to a specific address
251     @param addr Address to mint ERC20 for
252     @param quantity Number of tokens to mint
253     """
254 
255     assert self.owner == msg.sender
256     ThingToken(self.token_addr).mint(addr, quantity)
257 
258 
259 @external
260 def admin_mint_nft(addr: address):
261     """
262     @notice Mint an NFT to a specific address
263     @param addr Address to mint to
264     """
265 
266     assert self.owner == msg.sender
267     ERC721(self.nft_addr).mint(addr)
268 
269 
270 @external
271 def admin_update_whitelist_max(max_val: uint256):
272     """
273     @notice Update number of free mints whitelisted useres get
274     @param max_val New value for whitelist cap
275     """
276 
277     assert self.owner == msg.sender
278     self.whitelist_max = max_val
279 
280 
281 @external
282 def admin_update_erc20_drop_live(status: bool):
283     """
284     @notice Update if $THING tokens also distributed on mint
285     @param status Boolean True for token distribution, False for no
286     """
287 
288     assert self.owner == msg.sender
289     self.is_erc20_drop_live = status
290 
291 
292 @external
293 def admin_update_erc20_drop_quantity(quantity: uint256):
294     """
295     @notice Update quantity of tokens disbursed on mint
296     @param quantity New number of tokens
297     """
298 
299     assert self.owner == msg.sender
300     self.erc20_drop_quantity = quantity
301 
302 
303 @external
304 def admin_update_mint_price(new_value: uint256):
305     """
306     @notice Update mint price
307     @param new_value New mint price
308     """
309 
310     assert self.owner == msg.sender
311     self.min_price = new_value