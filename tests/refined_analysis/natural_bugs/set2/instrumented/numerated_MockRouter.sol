1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import "@openzeppelin/contracts/utils/math/SafeMath.sol";
6 import "../external/Decimal.sol";
7 import "./IMockUniswapV2PairLiquidity.sol";
8 
9 contract MockRouter {
10     using SafeMath for uint256;
11     using Decimal for Decimal.D256;
12 
13     IMockUniswapV2PairLiquidity private PAIR;
14     address public WETH;
15 
16     constructor(address pair) {
17         PAIR = IMockUniswapV2PairLiquidity(pair);
18     }
19 
20     uint256 private constant LIQUIDITY_INCREMENT = 10000;
21 
22     uint256 private amountMinThreshold;
23 
24     function addLiquidityETH(
25         address token,
26         uint256 amountTokenDesired,
27         uint256 amountToken0Min,
28         uint256,
29         address to,
30         uint256
31     )
32         external
33         payable
34         returns (
35             uint256 amountToken,
36             uint256 amountETH,
37             uint256 liquidity
38         )
39     {
40         address pair = address(PAIR);
41         checkAmountMin(amountToken0Min);
42 
43         amountToken = amountTokenDesired;
44         amountETH = msg.value;
45         liquidity = LIQUIDITY_INCREMENT;
46         (uint112 reserves0, uint112 reserves1, ) = PAIR.getReserves();
47         IERC20(token).transferFrom(to, pair, amountToken);
48         PAIR.mintAmount{value: amountETH}(to, LIQUIDITY_INCREMENT);
49         uint112 newReserve0 = uint112(reserves0) + uint112(amountETH);
50         uint112 newReserve1 = uint112(reserves1) + uint112(amountToken);
51         PAIR.setReserves(newReserve0, newReserve1);
52     }
53 
54     function checkAmountMin(uint256 amount) public view {
55         require(amountMinThreshold == 0 || amountMinThreshold > amount, "amount liquidity revert");
56     }
57 
58     function setAmountMin(uint256 amount) public {
59         amountMinThreshold = amount;
60     }
61 
62     function addLiquidity(
63         address token0,
64         address token1,
65         uint256 amountToken0Desired,
66         uint256 amountToken1Desired,
67         uint256 amountToken0Min,
68         uint256,
69         address to,
70         uint256
71     )
72         external
73         returns (
74             uint256,
75             uint256,
76             uint256 liquidity
77         )
78     {
79         address pair = address(PAIR);
80         checkAmountMin(amountToken0Min);
81 
82         liquidity = LIQUIDITY_INCREMENT;
83 
84         IERC20(token0).transferFrom(to, pair, amountToken0Desired);
85         IERC20(token1).transferFrom(to, pair, amountToken1Desired);
86 
87         PAIR.mintAmount(to, LIQUIDITY_INCREMENT);
88 
89         (uint112 reserves0, uint112 reserves1, ) = PAIR.getReserves();
90 
91         uint112 newReserve0 = uint112(reserves0) + uint112(amountToken0Desired);
92         uint112 newReserve1 = uint112(reserves1) + uint112(amountToken1Desired);
93         PAIR.setReserves(newReserve0, newReserve1);
94 
95         return (0, 0, liquidity);
96     }
97 
98     function setWETH(address weth) public {
99         WETH = weth;
100     }
101 
102     function removeLiquidity(
103         address,
104         address,
105         uint256 liquidity,
106         uint256 amountToken0Min,
107         uint256,
108         address to,
109         uint256
110     ) external returns (uint256 amountFei, uint256 amountToken) {
111         checkAmountMin(amountToken0Min);
112 
113         Decimal.D256 memory percentWithdrawal = Decimal.ratio(liquidity, PAIR.balanceOf(to));
114         Decimal.D256 memory ratio = ratioOwned(to);
115         (amountFei, amountToken) = PAIR.burnToken(to, ratio.mul(percentWithdrawal));
116 
117         (uint112 reserves0, uint112 reserves1, ) = PAIR.getReserves();
118         uint112 newReserve0 = uint112(reserves0) - uint112(amountFei);
119         uint112 newReserve1 = uint112(reserves1) - uint112(amountToken);
120 
121         PAIR.setReserves(newReserve0, newReserve1);
122         transferLiquidity(liquidity);
123     }
124 
125     function transferLiquidity(uint256 liquidity) internal {
126         PAIR.transferFrom(msg.sender, address(PAIR), liquidity); // send liquidity to pair
127     }
128 
129     function ratioOwned(address to) public view returns (Decimal.D256 memory) {
130         uint256 balance = PAIR.balanceOf(to);
131         uint256 total = PAIR.totalSupply();
132         return Decimal.ratio(balance, total);
133     }
134 }
