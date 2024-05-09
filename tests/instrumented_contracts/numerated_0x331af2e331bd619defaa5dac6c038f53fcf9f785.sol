1 # @version 0.2.12
2 """
3 @title Curve CryptoSwap Deposit Zap
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 @dev Wraps / unwraps Ether, and redirects deposits / withdrawals
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 interface CurveCryptoSwap:
12     def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256): nonpayable
13     def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]): nonpayable
14     def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256): nonpayable
15     def token() -> address: view
16     def coins(i: uint256) -> address: view
17 
18 interface wETH:
19     def deposit(): payable
20     def withdraw(_amount: uint256): nonpayable
21 
22 
23 N_COINS: constant(uint256) = 3
24 WETH_IDX: constant(uint256) = N_COINS - 1
25 WETH: constant(address) = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
26 
27 pool: public(address)
28 token: public(address)
29 coins: public(address[N_COINS])
30 
31 
32 @payable
33 @external
34 def __default__():
35     assert msg.sender == WETH
36 
37 
38 @external
39 def __init__(_pool: address):
40     """
41     @notice Contract constructor
42     @param _pool `CurveCryptoSwap` deployment to target
43     """
44     self.pool = _pool
45     self.token = CurveCryptoSwap(_pool).token()
46 
47     for i in range(N_COINS):
48         coin: address = CurveCryptoSwap(_pool).coins(i)
49         response: Bytes[32] = raw_call(
50             coin,
51             concat(
52                 method_id("approve(address,uint256)"),
53                 convert(_pool, bytes32),
54                 convert(MAX_UINT256, bytes32)
55             ),
56             max_outsize=32
57         )
58         if len(response) > 0:
59             assert convert(response, bool)  # dev: bad response
60         self.coins[i] = coin
61 
62     assert self.coins[WETH_IDX] == WETH
63 
64 
65 @payable
66 @external
67 def add_liquidity(
68     _amounts: uint256[N_COINS],
69     _min_mint_amount: uint256,
70     _receiver: address = msg.sender
71 ) -> uint256:
72     """
73     @notice Add liquidity and wrap Ether to wETH
74     @param _amounts Amount of each token to deposit. `msg.value` must be
75                     equal to the given amount of Ether.
76     @param _min_mint_amount Minimum amount of LP token to receive
77     @param _receiver Receiver of the LP tokens
78     @return Amount of LP tokens received
79     """
80     assert msg.value == _amounts[WETH_IDX]
81     wETH(WETH).deposit(value=msg.value)
82 
83     for i in range(N_COINS-1):
84         if _amounts[i] > 0:
85             response: Bytes[32] = raw_call(
86                 self.coins[i],
87                 concat(
88                     method_id("transferFrom(address,address,uint256)"),
89                     convert(msg.sender, bytes32),
90                     convert(self, bytes32),
91                     convert(_amounts[i], bytes32)
92                 ),
93                 max_outsize=32
94             )
95             if len(response) > 0:
96                 assert convert(response, bool)  # dev: bad response
97 
98     CurveCryptoSwap(self.pool).add_liquidity(_amounts, _min_mint_amount)
99     token: address = self.token
100     amount: uint256 = ERC20(token).balanceOf(self)
101     response: Bytes[32] = raw_call(
102         token,
103         concat(
104             method_id("transfer(address,uint256)"),
105             convert(_receiver, bytes32),
106             convert(amount, bytes32)
107         ),
108         max_outsize=32
109     )
110     if len(response) > 0:
111         assert convert(response, bool)  # dev: bad response
112 
113     return amount
114 
115 
116 @external
117 def remove_liquidity(
118     _amount: uint256,
119     _min_amounts: uint256[N_COINS],
120     _receiver: address = msg.sender
121 ) -> uint256[N_COINS]:
122     """
123     @notice Withdraw coins from the pool, unwrapping wETH to Ether
124     @dev Withdrawal amounts are based on current deposit ratios
125     @param _amount Quantity of LP tokens to burn in the withdrawal
126     @param _min_amounts Minimum amounts of coins to receive
127     @param _receiver Receiver of the withdrawn tokens
128     @return Amounts of coins that were withdrawn
129     """
130     ERC20(self.token).transferFrom(msg.sender, self, _amount)
131     CurveCryptoSwap(self.pool).remove_liquidity(_amount, _min_amounts)
132 
133     amounts: uint256[N_COINS] = empty(uint256[N_COINS])
134     for i in range(N_COINS-1):
135         coin: address = self.coins[i]
136         amounts[i] = ERC20(coin).balanceOf(self)
137         response: Bytes[32] = raw_call(
138             coin,
139             concat(
140                 method_id("transfer(address,uint256)"),
141                 convert(_receiver, bytes32),
142                 convert(amounts[i], bytes32)
143             ),
144             max_outsize=32
145         )
146         if len(response) > 0:
147             assert convert(response, bool)  # dev: bad response
148 
149     amounts[WETH_IDX] = ERC20(WETH).balanceOf(self)
150     wETH(WETH).withdraw(amounts[WETH_IDX])
151     raw_call(_receiver, b"", value=self.balance)
152 
153     return amounts
154 
155 
156 @external
157 def remove_liquidity_one_coin(
158     _token_amount: uint256,
159     i: uint256,
160     _min_amount: uint256,
161     _receiver: address = msg.sender
162 ) -> uint256:
163     """
164     @notice Withdraw a single coin from the pool, unwrapping wETH to Ether
165     @param _token_amount Amount of LP tokens to burn in the withdrawal
166     @param i Index value of the coin to withdraw
167     @param _min_amount Minimum amount of coin to receive
168     @param _receiver Receiver of the withdrawn token
169     @return Amount of underlying coin received
170     """
171     ERC20(self.token).transferFrom(msg.sender, self, _token_amount)
172     CurveCryptoSwap(self.pool).remove_liquidity_one_coin(_token_amount, i, _min_amount)
173 
174     coin: address = self.coins[i]
175     amount: uint256 = ERC20(coin).balanceOf(self)
176     if i == WETH_IDX:
177         wETH(WETH).withdraw(amount)
178         raw_call(_receiver, b"", value=self.balance)
179     else:
180         response: Bytes[32] = raw_call(
181             coin,
182             concat(
183                 method_id("transfer(address,uint256)"),
184                 convert(_receiver, bytes32),
185                 convert(amount, bytes32)
186             ),
187             max_outsize=32
188         )
189         if len(response) > 0:
190             assert convert(response, bool)  # dev: bad response
191     return amount