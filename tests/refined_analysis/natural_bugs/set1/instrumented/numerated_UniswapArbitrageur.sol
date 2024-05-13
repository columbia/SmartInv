1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 import {Ownable} from "../lib/Ownable.sol";
12 import {IDODO} from "../intf/IDODO.sol";
13 import {IERC20} from "../intf/IERC20.sol";
14 import {SafeERC20} from "../lib/SafeERC20.sol";
15 import {SafeMath} from "../lib/SafeMath.sol";
16 
17 interface IUniswapV2Pair {
18     function token0() external view returns (address);
19 
20     function token1() external view returns (address);
21 
22     function getReserves()
23         external
24         view
25         returns (
26             uint112 reserve0,
27             uint112 reserve1,
28             uint32 blockTimestampLast
29         );
30 
31     function swap(
32         uint256 amount0Out,
33         uint256 amount1Out,
34         address to,
35         bytes calldata data
36     ) external;
37 }
38 
39 contract UniswapArbitrageur {
40     using SafeMath for uint256;
41     using SafeERC20 for IERC20;
42 
43     address public _UNISWAP_;
44     address public _DODO_;
45     address public _BASE_;
46     address public _QUOTE_;
47 
48     bool public _REVERSE_; // true if dodo.baseToken=uniswap.token0
49 
50     constructor(address _uniswap, address _dodo) public {
51         _UNISWAP_ = _uniswap;
52         _DODO_ = _dodo;
53 
54         _BASE_ = IDODO(_DODO_)._BASE_TOKEN_();
55         _QUOTE_ = IDODO(_DODO_)._QUOTE_TOKEN_();
56 
57         address token0 = IUniswapV2Pair(_UNISWAP_).token0();
58         address token1 = IUniswapV2Pair(_UNISWAP_).token1();
59 
60         if (token0 == _BASE_ && token1 == _QUOTE_) {
61             _REVERSE_ = false;
62         } else if (token0 == _QUOTE_ && token1 == _BASE_) {
63             _REVERSE_ = true;
64         } else {
65             require(true, "DODO_UNISWAP_NOT_MATCH");
66         }
67 
68         IERC20(_BASE_).approve(_DODO_, uint256(-1));
69         IERC20(_QUOTE_).approve(_DODO_, uint256(-1));
70     }
71 
72     function executeBuyArbitrage(uint256 baseAmount) external returns (uint256 quoteProfit) {
73         IDODO(_DODO_).buyBaseToken(baseAmount, uint256(-1), "0xd");
74         quoteProfit = IERC20(_QUOTE_).balanceOf(address(this));
75         IERC20(_QUOTE_).transfer(msg.sender, quoteProfit);
76         return quoteProfit;
77     }
78 
79     function executeSellArbitrage(uint256 baseAmount) external returns (uint256 baseProfit) {
80         IDODO(_DODO_).sellBaseToken(baseAmount, 0, "0xd");
81         baseProfit = IERC20(_BASE_).balanceOf(address(this));
82         IERC20(_BASE_).transfer(msg.sender, baseProfit);
83         return baseProfit;
84     }
85 
86     function dodoCall(
87         bool isDODOBuy,
88         uint256 baseAmount,
89         uint256 quoteAmount,
90         bytes calldata
91     ) external {
92         require(msg.sender == _DODO_, "WRONG_DODO");
93         if (_REVERSE_) {
94             _inverseArbitrage(isDODOBuy, baseAmount, quoteAmount);
95         } else {
96             _arbitrage(isDODOBuy, baseAmount, quoteAmount);
97         }
98     }
99 
100     function _inverseArbitrage(
101         bool isDODOBuy,
102         uint256 baseAmount,
103         uint256 quoteAmount
104     ) internal {
105         (uint112 _reserve0, uint112 _reserve1, ) = IUniswapV2Pair(_UNISWAP_).getReserves();
106         uint256 token0Balance = uint256(_reserve0);
107         uint256 token1Balance = uint256(_reserve1);
108         uint256 token0Amount;
109         uint256 token1Amount;
110         if (isDODOBuy) {
111             IERC20(_BASE_).transfer(_UNISWAP_, baseAmount);
112             // transfer token1 into uniswap
113             uint256 newToken0Balance = token0Balance.mul(token1Balance).div(
114                 token1Balance.add(baseAmount)
115             );
116             token0Amount = token0Balance.sub(newToken0Balance).mul(9969).div(10000); // mul 0.9969
117             require(token0Amount > quoteAmount, "NOT_PROFITABLE");
118             IUniswapV2Pair(_UNISWAP_).swap(token0Amount, token1Amount, address(this), "");
119         } else {
120             IERC20(_QUOTE_).transfer(_UNISWAP_, quoteAmount);
121             // transfer token0 into uniswap
122             uint256 newToken1Balance = token0Balance.mul(token1Balance).div(
123                 token0Balance.add(quoteAmount)
124             );
125             token1Amount = token1Balance.sub(newToken1Balance).mul(9969).div(10000); // mul 0.9969
126             require(token1Amount > baseAmount, "NOT_PROFITABLE");
127             IUniswapV2Pair(_UNISWAP_).swap(token0Amount, token1Amount, address(this), "");
128         }
129     }
130 
131     function _arbitrage(
132         bool isDODOBuy,
133         uint256 baseAmount,
134         uint256 quoteAmount
135     ) internal {
136         (uint112 _reserve0, uint112 _reserve1, ) = IUniswapV2Pair(_UNISWAP_).getReserves();
137         uint256 token0Balance = uint256(_reserve0);
138         uint256 token1Balance = uint256(_reserve1);
139         uint256 token0Amount;
140         uint256 token1Amount;
141         if (isDODOBuy) {
142             IERC20(_BASE_).transfer(_UNISWAP_, baseAmount);
143             // transfer token0 into uniswap
144             uint256 newToken1Balance = token1Balance.mul(token0Balance).div(
145                 token0Balance.add(baseAmount)
146             );
147             token1Amount = token1Balance.sub(newToken1Balance).mul(9969).div(10000); // mul 0.9969
148             require(token1Amount > quoteAmount, "NOT_PROFITABLE");
149             IUniswapV2Pair(_UNISWAP_).swap(token0Amount, token1Amount, address(this), "");
150         } else {
151             IERC20(_QUOTE_).transfer(_UNISWAP_, quoteAmount);
152             // transfer token1 into uniswap
153             uint256 newToken0Balance = token1Balance.mul(token0Balance).div(
154                 token1Balance.add(quoteAmount)
155             );
156             token0Amount = token0Balance.sub(newToken0Balance).mul(9969).div(10000); // mul 0.9969
157             require(token0Amount > baseAmount, "NOT_PROFITABLE");
158             IUniswapV2Pair(_UNISWAP_).swap(token0Amount, token1Amount, address(this), "");
159         }
160     }
161 
162     function retrieve(address token, uint256 amount) external {
163         IERC20(token).safeTransfer(msg.sender, amount);
164     }
165 }
