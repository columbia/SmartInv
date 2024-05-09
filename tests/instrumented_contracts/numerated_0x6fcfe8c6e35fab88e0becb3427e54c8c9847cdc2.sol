1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity 0.8.17;
4 
5 interface IUniswapV3PoolActions {
6     function swap(
7         address recipient,
8         bool zeroForOne,
9         int256 amountSpecified,
10         uint160 sqrtPriceLimitX96,
11         bytes calldata data
12     ) external returns (int256 amount0, int256 amount1);
13 }
14 interface IUniswapV3SwapCallback {
15     function uniswapV3SwapCallback(
16         int256 amount0Delta,
17         int256 amount1Delta,
18         bytes calldata data
19     ) external;
20 }
21 interface RocketStorageInterface {
22     function getAddress(bytes32 _key) external view returns (address);
23 }
24 interface RocketDepositPoolInterface {
25     function deposit() external payable;
26 }
27 interface IERC20 {
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 }
31 interface IWETH9 {
32     function withdraw(uint256) external;
33 }
34 
35 
36 
37 contract RocketUniArb is IUniswapV3SwapCallback {
38     address immutable weth;
39     address immutable reth;
40 
41     address immutable rocketStorage;
42     bytes32 immutable depositPoolKey;
43     
44     constructor(address _weth, address _rocketStorage) {
45         weth = _weth;
46         reth = RocketStorageInterface(_rocketStorage).getAddress(keccak256("contract.addressrocketTokenRETH"));
47 
48         rocketStorage = _rocketStorage;
49         depositPoolKey = keccak256("contract.addressrocketDepositPool");
50     }
51 
52     receive () external payable { }
53 
54     function arb(uint256 depositAmount, uint256 minProfit, bytes calldata swapData) external {
55         // Our calldata should contain
56         // 1: the address of the uniswap v3 weth <-> rEth pool we should swap on
57         // 2: the amount of rEth to swap into the pool (aka the amount of rEth we expect to recieve from minting)
58         (address uniPool, uint256 rethExpected) = abi.decode(swapData, (address, uint256));
59 
60         // do a swap on our hardcoded uniswap v3 pool - we're swapping `rethExpected` amount of rEth for some unknown amount of weth
61         // the pool will pay the weth to us, then call uniswapV3SwapCallback() in which we'll actually do the rEth mint, and pay the rEth back to the pool
62         {
63             bool swapZeroForOne = true; // config parameter telling the pool which direction to swap. true when swapping reth to weth, false when swapping weth to reth
64             uint160 priceLimit = 4295128740; // This constant essentially tells uniswap v3 that we do not have a price limit.
65             bytes memory innerCalldata = abi.encode(depositAmount);
66             IUniswapV3PoolActions(uniPool).swap(address(this), swapZeroForOne, int256(rethExpected), priceLimit, innerCalldata);
67         }
68 
69         // all eth left in this contract is arb profit
70         uint256 profit = address(this).balance;
71         require(profit > minProfit, "LOW PROFIT");
72         payable(msg.sender).transfer(profit);
73     }
74 
75     function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) external override {
76         // unwrap all weth owned by this contract
77         uint256 wethBalance = IERC20(weth).balanceOf(address(this));
78         IWETH9(weth).withdraw(wethBalance);
79 
80         // the amount to deposit to rocketpool is in our calldata, extract it
81         uint256 depositAmount = abi.decode(data, (uint256));
82 
83         // deposit to rocketpool, and use the pool (ie msg.sender) as the recipient
84         address rocketDepositPool = RocketStorageInterface(rocketStorage).getAddress(depositPoolKey);
85         RocketDepositPoolInterface(rocketDepositPool).deposit{value:depositAmount}();
86 
87         // repay the pool
88         // The amount we need to repay is just whichever amount delta is positive. But because we know statically which direction we're swapping in, we know it's amount0Delta
89         uint256 repayAmount = uint256(amount0Delta);
90         IERC20(reth).transfer(msg.sender, repayAmount);
91     }
92 }