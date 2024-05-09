1 # @version ^0.3.0
2 # A "zap" to add liquidity and deposit into gauge in one transaction
3 # (c) Curve.Fi, 2022
4 
5 MAX_COINS: constant(uint256) = 5
6 ETH_ADDRESS: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
7 
8 # External Contracts
9 interface ERC20:
10     def transfer(_receiver: address, _amount: uint256): nonpayable
11     def transferFrom(_sender: address, _receiver: address, _amount: uint256): nonpayable
12     def approve(_spender: address, _amount: uint256): nonpayable
13     def decimals() -> uint256: view
14     def balanceOf(_owner: address) -> uint256: view
15     def allowance(_owner : address, _spender : address) -> uint256: view
16 
17 interface Pool2:
18     def add_liquidity(amounts: uint256[2], min_mint_amount: uint256): payable
19 
20 interface Pool3:
21     def add_liquidity(amounts: uint256[3], min_mint_amount: uint256): payable
22 
23 interface Pool4:
24     def add_liquidity(amounts: uint256[4], min_mint_amount: uint256): payable
25 
26 interface Pool5:
27     def add_liquidity(amounts: uint256[5], min_mint_amount: uint256): payable
28 
29 interface PoolUseUnderlying2:
30     def add_liquidity(amounts: uint256[2], min_mint_amount: uint256, use_underlying: bool): payable
31 
32 interface PoolUseUnderlying3:
33     def add_liquidity(amounts: uint256[3], min_mint_amount: uint256, use_underlying: bool): payable
34 
35 interface PoolUseUnderlying4:
36     def add_liquidity(amounts: uint256[4], min_mint_amount: uint256, use_underlying: bool): payable
37 
38 interface PoolUseUnderlying5:
39     def add_liquidity(amounts: uint256[5], min_mint_amount: uint256, use_underlying: bool): payable
40 
41 interface PoolFactory2:
42     def add_liquidity(pool: address, amounts: uint256[2], min_mint_amount: uint256): payable
43 
44 interface PoolFactory3:
45     def add_liquidity(pool: address, amounts: uint256[3], min_mint_amount: uint256): payable
46 
47 interface PoolFactory4:
48     def add_liquidity(pool: address, amounts: uint256[4], min_mint_amount: uint256): payable
49 
50 interface PoolFactory5:
51     def add_liquidity(pool: address, amounts: uint256[5], min_mint_amount: uint256): payable
52 
53 interface Gauge:
54     def deposit(lp_token_amount: uint256, addr: address): payable
55 
56 
57 allowance: public(HashMap[address, HashMap[address, bool]])
58 gauge_allowance: HashMap[address, bool]
59 
60 
61 @internal
62 def _add_liquidity(
63         deposit: address,
64         n_coins: uint256,
65         amounts: uint256[MAX_COINS],
66         min_mint_amount: uint256,
67         eth_value: uint256,
68         use_underlying: bool,
69         pool: address
70 ):
71     if pool != ZERO_ADDRESS:
72         if n_coins == 2:
73             PoolFactory2(deposit).add_liquidity(pool, [amounts[0], amounts[1]], min_mint_amount, value=eth_value)
74         elif n_coins == 3:
75             PoolFactory3(deposit).add_liquidity(pool, [amounts[0], amounts[1], amounts[2]], min_mint_amount, value=eth_value)
76         elif n_coins == 4:
77             PoolFactory4(deposit).add_liquidity(pool, [amounts[0], amounts[1], amounts[2], amounts[3]], min_mint_amount, value=eth_value)
78         elif n_coins == 5:
79             PoolFactory5(deposit).add_liquidity(pool, [amounts[0], amounts[1], amounts[2], amounts[3], amounts[4]], min_mint_amount, value=eth_value)
80     elif use_underlying:
81         if n_coins == 2:
82             PoolUseUnderlying2(deposit).add_liquidity([amounts[0], amounts[1]], min_mint_amount, True, value=eth_value)
83         elif n_coins == 3:
84             PoolUseUnderlying3(deposit).add_liquidity([amounts[0], amounts[1], amounts[2]], min_mint_amount, True, value=eth_value)
85         elif n_coins == 4:
86             PoolUseUnderlying4(deposit).add_liquidity([amounts[0], amounts[1], amounts[2], amounts[3]], min_mint_amount, True, value=eth_value)
87         elif n_coins == 5:
88             PoolUseUnderlying5(deposit).add_liquidity([amounts[0], amounts[1], amounts[2], amounts[3], amounts[4]], min_mint_amount, True, value=eth_value)
89     else:
90         if n_coins == 2:
91             Pool2(deposit).add_liquidity([amounts[0], amounts[1]], min_mint_amount, value=eth_value)
92         elif n_coins == 3:
93             Pool3(deposit).add_liquidity([amounts[0], amounts[1], amounts[2]], min_mint_amount, value=eth_value)
94         elif n_coins == 4:
95             Pool4(deposit).add_liquidity([amounts[0], amounts[1], amounts[2], amounts[3]], min_mint_amount, value=eth_value)
96         elif n_coins == 5:
97             Pool5(deposit).add_liquidity([amounts[0], amounts[1], amounts[2], amounts[3], amounts[4]], min_mint_amount, value=eth_value)
98 
99 
100 @payable
101 @external
102 @nonreentrant('lock')
103 def deposit_and_stake(
104         deposit: address,
105         lp_token: address,
106         gauge: address,
107         n_coins: uint256,
108         coins: address[MAX_COINS],
109         amounts: uint256[MAX_COINS],
110         min_mint_amount: uint256,
111         use_underlying: bool, # for aave, saave, ib (use_underlying) and crveth, cvxeth (use_eth)
112         pool: address = ZERO_ADDRESS, # for factory
113 ):
114     assert n_coins >= 2, 'n_coins must be >=2'
115     assert n_coins <= MAX_COINS, 'n_coins must be <=MAX_COINS'
116 
117     # Ensure allowance for swap or zap
118     for i in range(MAX_COINS):
119         if i >= n_coins:
120             break
121 
122         if coins[i] == ETH_ADDRESS or amounts[i] == 0 or self.allowance[deposit][coins[i]]:
123             continue
124 
125         self.allowance[deposit][coins[i]] = True
126         ERC20(coins[i]).approve(deposit, MAX_UINT256)
127 
128     # Ensure allowance for gauge
129     if not self.gauge_allowance[gauge]:
130         self.gauge_allowance[gauge] = True
131         ERC20(lp_token).approve(gauge, MAX_UINT256)
132 
133     # Transfer coins from owner
134     has_eth: bool = False
135     for i in range(MAX_COINS):
136         if i >= n_coins:
137             break
138 
139         if coins[i] == ETH_ADDRESS:
140             assert msg.value == amounts[i]
141             has_eth = True
142             continue
143 
144         if amounts[i] > 0:
145             # "safeTransferFrom" which works for ERC20s which return bool or not
146             _response: Bytes[32] = raw_call(
147                 coins[i],
148                 concat(
149                     method_id("transferFrom(address,address,uint256)"),
150                     convert(msg.sender, bytes32),
151                     convert(self, bytes32),
152                     convert(amounts[i], bytes32),
153                 ),
154                 max_outsize=32,
155             )  # dev: failed transfer
156             if len(_response) > 0:
157                 assert convert(_response, bool)  # dev: failed transfer
158 
159     if not has_eth:
160         assert msg.value == 0
161 
162     # Reverts if n_coins is wrong
163     self._add_liquidity(deposit, n_coins, amounts, min_mint_amount, msg.value, use_underlying, pool)
164 
165     lp_token_amount: uint256 = ERC20(lp_token).balanceOf(self)
166     assert lp_token_amount > 0 # dev: swap-token mismatch
167 
168     Gauge(gauge).deposit(lp_token_amount, msg.sender)
169 
170 
171 @payable
172 @external
173 def __default__():
174     pass