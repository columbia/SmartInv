1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 interface IUniswapV2PairV5 {
5     event Approval(address indexed owner, address indexed spender, uint value);
6     event Transfer(address indexed from, address indexed to, uint value);
7 
8     function name() external pure returns (string memory);
9     function symbol() external pure returns (string memory);
10     function decimals() external pure returns (uint8);
11     function totalSupply() external view returns (uint);
12     function balanceOf(address owner) external view returns (uint);
13     function allowance(address owner, address spender) external view returns (uint);
14 
15     function approve(address spender, uint value) external returns (bool);
16     function transfer(address to, uint value) external returns (bool);
17     function transferFrom(address from, address to, uint value) external returns (bool);
18 
19     function DOMAIN_SEPARATOR() external view returns (bytes32);
20     function PERMIT_TYPEHASH() external pure returns (bytes32);
21     function nonces(address owner) external view returns (uint);
22 
23     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
24 
25     event Mint(address indexed sender, uint amount0, uint amount1);
26     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
27     event Swap(
28         address indexed sender,
29         uint amount0In,
30         uint amount1In,
31         uint amount0Out,
32         uint amount1Out,
33         address indexed to
34     );
35     event Sync(uint112 reserve0, uint112 reserve1);
36 
37     function MINIMUM_LIQUIDITY() external pure returns (uint);
38     function factory() external view returns (address);
39     function token0() external view returns (address);
40     function token1() external view returns (address);
41     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
42     function price0CumulativeLast() external view returns (uint);
43     function price1CumulativeLast() external view returns (uint);
44     function kLast() external view returns (uint);
45 
46     function mint(address to) external returns (uint liquidity);
47     function burn(address to) external returns (uint amount0, uint amount1);
48     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
49     function skim(address to) external;
50     function sync() external;
51     function initialize(address, address) external;
52 }
53 
54 interface IFraxswapPair is IUniswapV2PairV5 {
55 
56     event LongTermSwap0To1(address indexed addr, uint256 orderId, uint256 amount0In, uint256 numberOfTimeIntervals);
57     event LongTermSwap1To0(address indexed addr, uint256 orderId, uint256 amount1In, uint256 numberOfTimeIntervals);
58     event CancelLongTermOrder(address indexed addr, uint256 orderId, address sellToken, uint256 unsoldAmount, address buyToken, uint256 purchasedAmount);
59     event WithdrawProceedsFromLongTermOrder(address indexed addr, uint256 orderId, address indexed proceedToken, uint256 proceeds, bool orderExpired);
60 
61     function longTermSwapFrom0To1(uint256 amount0In, uint256 numberOfTimeIntervals) external returns (uint256 orderId);
62     function longTermSwapFrom1To0(uint256 amount1In, uint256 numberOfTimeIntervals) external returns (uint256 orderId);
63     function cancelLongTermSwap(uint256 orderId) external;
64     function withdrawProceedsFromLongTermSwap(uint256 orderId) external returns (bool is_expired, address rewardTkn, uint256 totalReward);
65     function executeVirtualOrders(uint256 blockTimestamp) external;
66 
67     function orderTimeInterval() external returns (uint256);
68     function getTWAPHistoryLength() external view returns (uint);
69     function getTwammReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast, uint112 _twammReserve0, uint112 _twammReserve1);
70     function getReserveAfterTwamm(uint256 blockTimestamp) external view returns (uint112 _reserve0, uint112 _reserve1, uint256 lastVirtualOrderTimestamp, uint112 _twammReserve0, uint112 _twammReserve1);
71     function getNextOrderID() external view returns (uint256);
72     function getOrderIDsForUser(address user) external view returns (uint256[] memory);
73     function getOrderIDsForUserLength(address user) external view returns (uint256);
74     function twammUpToDate() external view returns (bool);
75     function getTwammState() external view returns (uint256 token0Rate, uint256 token1Rate, uint256 lastVirtualOrderTimestamp, uint256 orderTimeInterval_rtn, uint256 rewardFactorPool0, uint256 rewardFactorPool1);
76     function getTwammSalesRateEnding(uint256 _blockTimestamp) external view returns (uint256 orderPool0SalesRateEnding, uint256 orderPool1SalesRateEnding);
77     function getTwammRewardFactor(uint256 _blockTimestamp) external view returns (uint256 rewardFactorPool0AtTimestamp, uint256 rewardFactorPool1AtTimestamp);
78     function getTwammOrder(uint256 orderId) external view returns (uint256 id, uint256 expirationTimestamp, uint256 saleRate, address owner, address sellTokenAddr, address buyTokenAddr);
79     function getTwammOrderProceedsView(uint256 orderId, uint256 blockTimestamp) external view returns (bool orderExpired, uint256 totalReward);
80     function getTwammOrderProceeds(uint256 orderId) external returns (bool orderExpired, uint256 totalReward);
81 
82 
83     function togglePauseNewSwaps() external;
84 }