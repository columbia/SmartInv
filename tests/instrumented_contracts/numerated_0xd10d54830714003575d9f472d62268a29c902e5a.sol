1 # @version 0.2.12
2 """
3 @title Pool Migrator
4 @author Curve.fi
5 @notice Zap for moving liquidity between Curve tricrypto pools in a single transaction
6 @license MIT
7 """
8 
9 N_COINS: constant(int128) = 3  # <- change
10 
11 OLD_POOL: constant(address) = 0x80466c64868E1ab14a1Ddf27A676C3fcBE638Fe5
12 OLD_TOKEN: constant(address) = 0xcA3d75aC011BF5aD07a98d02f18225F9bD9A6BDF
13 OLD_GAUGE: constant(address) = 0x6955a55416a06839309018A8B0cB72c4DDC11f15
14 
15 NEW_POOL: constant(address) = 0xD51a44d3FaE010294C616388b506AcdA1bfAAE46
16 NEW_TOKEN: constant(address) = 0xc4AD29ba4B3c580e6D59105FFf484999997675Ff
17 NEW_GAUGE: constant(address) = 0xDeFd8FdD20e0f34115C7018CCfb655796F6B2168
18 
19 COINS: constant(address[N_COINS]) = [
20     0xdAC17F958D2ee523a2206206994597C13D831ec7,
21     0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599,
22     0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
23 ]
24 
25 
26 # For flash loan protection
27 PRECISIONS: constant(uint256[N_COINS]) = [
28     1000000000000,
29     10000000000,
30     1,
31 ]
32 ALLOWED_DEVIATION: constant(uint256) = 10**16  # 1% * 1e18
33 
34 
35 interface ERC20:
36     def approve(_spender: address, _amount: uint256): nonpayable
37     def transfer(_to: address, _amount: uint256): nonpayable
38     def transferFrom(_owner: address, _spender: address, _amount: uint256) -> bool: nonpayable
39     def balanceOf(_user: address) -> uint256: view
40 
41 interface Gauge:
42     def withdraw(_value: uint256): nonpayable
43     def deposit(_value: uint256, _addr: address, _claim_rewards: bool): nonpayable
44 
45 interface Swap:
46     def add_liquidity(_amounts: uint256[N_COINS], _min_mint_amount: uint256): nonpayable
47     def remove_liquidity(_burn_amount: uint256, _min_amounts: uint256[N_COINS]): nonpayable
48     def balances(i: uint256) -> uint256: view
49     def price_oracle(i: uint256) -> uint256: view
50 
51 
52 @external
53 def __init__():
54     for c in COINS:
55         ERC20(c).approve(NEW_POOL, MAX_UINT256)
56     ERC20(NEW_TOKEN).approve(NEW_GAUGE, MAX_UINT256)
57 
58 
59 @internal
60 @view
61 def is_safe():
62     balances: uint256[N_COINS] = PRECISIONS
63     S: uint256 = 0
64     for i in range(N_COINS):
65         balances[i] *= Swap(NEW_POOL).balances(i)
66         if i > 0:
67             balances[i] = balances[i] * Swap(NEW_POOL).price_oracle(i-1) / 10**18
68         S += balances[i]
69     for i in range(N_COINS):
70         ratio: uint256 = balances[i] * 10**18 / S
71         assert ratio > 10**18/N_COINS - ALLOWED_DEVIATION and ratio < 10**18/N_COINS + ALLOWED_DEVIATION, "Target pool might be under attack now - wait"
72 
73 
74 @external
75 def migrate_to_new_pool():
76     """
77     @notice Migrate liquidity between two pools
78     Better to transfer 1 wei of old gauge and old LP to the zap
79     """
80     self.is_safe()
81 
82     old_amount: uint256 = 0
83     bal: uint256 = ERC20(OLD_GAUGE).balanceOf(msg.sender)
84 
85     coins: address[N_COINS] = COINS
86     coin_balances: uint256[N_COINS] = empty(uint256[N_COINS])
87 
88     # Transfer the gauge in and withdraw if we have something
89     if bal > 0:
90         ERC20(OLD_GAUGE).transferFrom(msg.sender, self, bal)
91         Gauge(OLD_GAUGE).withdraw(bal)
92         old_amount += bal
93 
94     # Transfer LP in if we have something
95     bal = ERC20(OLD_TOKEN).balanceOf(msg.sender)
96     if bal > 0:
97         ERC20(OLD_TOKEN).transferFrom(msg.sender, self, bal)
98         old_amount += bal
99 
100     # Get usdt/wbtc/weth
101     if old_amount > 0:
102         Swap(OLD_POOL).remove_liquidity(old_amount, empty(uint256[N_COINS]))
103 
104     # Deposit
105     for i in range(N_COINS):
106         bal = ERC20(coins[i]).balanceOf(self)
107         if bal > 0:
108             bal -= 1
109         coin_balances[i] = bal
110     Swap(NEW_POOL).add_liquidity(coin_balances, 0)
111 
112     # Put in the gauge
113     bal = ERC20(NEW_TOKEN).balanceOf(self)
114     if bal > 1:
115         Gauge(NEW_GAUGE).deposit(bal - 1, msg.sender, False)