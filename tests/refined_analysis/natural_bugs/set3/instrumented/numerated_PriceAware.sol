1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "./RoleAware.sol";
5 import "./MarginRouter.sol";
6 import "../libraries/UniswapStyleLib.sol";
7 
8 /// Stores how many of token you could get for 1k of peg
9 struct TokenPrice {
10     uint256 blockLastUpdated;
11     uint256 tokenPer1k;
12     address[] liquidationPairs;
13     address[] inverseLiquidationPairs;
14     address[] liquidationTokens;
15     address[] inverseLiquidationTokens;
16 }
17 
18 /// @title The protocol features several mechanisms to prevent vulnerability to
19 /// price manipulation:
20 /// 1) global exposure caps on all tokens which need to be raised gradually
21 ///    during the process of introducing a new token, making attacks unprofitable
22 ///    due to lack  of scale
23 /// 2) Exponential moving average with cautious price update. Prices for estimating
24 ///    how much a trader can borrow need not be extremely current and precise, mainly
25 ///    they must be resilient against extreme manipulation
26 /// 3) Liquidators may not call from a contract address, to prevent extreme forms of
27 ///    of front-running and other price manipulation.
28 abstract contract PriceAware is Ownable, RoleAware {
29     address public immutable peg;
30     mapping(address => TokenPrice) public tokenPrices;
31     /// update window in blocks
32     uint16 public priceUpdateWindow = 8;
33     uint256 public UPDATE_RATE_PERMIL = 80;
34     uint256 public UPDATE_MAX_PEG_AMOUNT = 50_000;
35     uint256 public UPDATE_MIN_PEG_AMOUNT = 1_000;
36 
37     constructor(address _peg) Ownable() {
38         peg = _peg;
39     }
40 
41     /// Set window for price updates
42     function setPriceUpdateWindow(uint16 window) external onlyOwner {
43         priceUpdateWindow = window;
44     }
45 
46     /// Set rate for updates
47     function setUpdateRate(uint256 rate) external onlyOwner {
48         UPDATE_RATE_PERMIL = rate;
49     }
50 
51     function setUpdateMaxPegAmount(uint256 amount) external onlyOwner {
52         UPDATE_MAX_PEG_AMOUNT = amount;
53     }
54 
55     function setUpdateMinPegAmount(uint256 amount) external onlyOwner {
56         UPDATE_MIN_PEG_AMOUNT = amount;
57     }
58 
59     /// Get current price of token in peg
60     function getCurrentPriceInPeg(
61         address token,
62         uint256 inAmount,
63         bool forceCurBlock
64     ) public returns (uint256) {
65         TokenPrice storage tokenPrice = tokenPrices[token];
66         if (forceCurBlock) {
67             if (
68                 block.number - tokenPrice.blockLastUpdated > priceUpdateWindow
69             ) {
70                 // update the currently cached price
71                 return getPriceFromAMM(token, inAmount);
72             } else {
73                 // just get the current price from AMM
74                 return viewCurrentPriceInPeg(token, inAmount);
75             }
76         } else if (tokenPrice.tokenPer1k == 0) {
77             // do the best we can if it's at zero
78             return getPriceFromAMM(token, inAmount);
79         }
80 
81         if (block.number - tokenPrice.blockLastUpdated > priceUpdateWindow) {
82             // update the price somewhat
83             getPriceFromAMM(token, inAmount);
84         }
85 
86         return (inAmount * 1000 ether) / tokenPrice.tokenPer1k;
87     }
88 
89     /// Get view of current price of token in peg
90     function viewCurrentPriceInPeg(address token, uint256 inAmount)
91         public
92         view
93         returns (uint256)
94     {
95         if (token == peg) {
96             return inAmount;
97         } else {
98             TokenPrice storage tokenPrice = tokenPrices[token];
99             uint256[] memory pathAmounts =
100                 UniswapStyleLib.getAmountsOut(
101                     inAmount,
102                     tokenPrice.liquidationPairs,
103                     tokenPrice.liquidationTokens
104                 );
105             uint256 outAmount = pathAmounts[pathAmounts.length - 1];
106             return outAmount;
107         }
108     }
109 
110     /// @dev retrieves the price from the AMM
111     function getPriceFromAMM(address token, uint256 inAmount)
112         internal
113         virtual
114         returns (uint256)
115     {
116         if (token == peg) {
117             return inAmount;
118         } else {
119             TokenPrice storage tokenPrice = tokenPrices[token];
120             uint256[] memory pathAmounts =
121                 UniswapStyleLib.getAmountsOut(
122                     inAmount,
123                     tokenPrice.liquidationPairs,
124                     tokenPrice.liquidationTokens
125                 );
126             uint256 outAmount = pathAmounts[pathAmounts.length - 1];
127 
128             if (
129                 outAmount > UPDATE_MIN_PEG_AMOUNT &&
130                 outAmount < UPDATE_MAX_PEG_AMOUNT
131             ) {
132                 setPriceVal(tokenPrice, inAmount, outAmount);
133             }
134 
135             return outAmount;
136         }
137     }
138 
139     function setPriceVal(
140         TokenPrice storage tokenPrice,
141         uint256 inAmount,
142         uint256 outAmount
143     ) internal {
144         _setPriceVal(tokenPrice, inAmount, outAmount, UPDATE_RATE_PERMIL);
145         tokenPrice.blockLastUpdated = block.number;
146     }
147 
148     function _setPriceVal(
149         TokenPrice storage tokenPrice,
150         uint256 inAmount,
151         uint256 outAmount,
152         uint256 weightPerMil
153     ) internal {
154         uint256 updatePer1k = (1000 ether * inAmount) / (outAmount + 1);
155         tokenPrice.tokenPer1k =
156             (tokenPrice.tokenPer1k *
157                 (1000 - weightPerMil) +
158                 updatePer1k *
159                 weightPerMil) /
160             1000;
161     }
162 
163     /// add path from token to current liquidation peg
164     function setLiquidationPath(address[] memory path, address[] memory tokens)
165         external
166     {
167         require(
168             isTokenActivator(msg.sender),
169             "not authorized to set lending cap"
170         );
171 
172         address token = tokens[0];
173 
174         TokenPrice storage tokenPrice = tokenPrices[token];
175         tokenPrice.liquidationPairs = new address[](path.length);
176         tokenPrice.inverseLiquidationPairs = new address[](path.length);
177         tokenPrice.liquidationTokens = new address[](tokens.length);
178         tokenPrice.inverseLiquidationTokens = new address[](tokens.length);
179 
180         for (uint256 i = 0; path.length > i; i++) {
181             tokenPrice.liquidationPairs[i] = path[i];
182             tokenPrice.inverseLiquidationPairs[i] = path[path.length - i - 1];
183         }
184 
185         for (uint256 i = 0; tokens.length > i; i++) {
186             tokenPrice.liquidationTokens[i] = tokens[i];
187             tokenPrice.inverseLiquidationTokens[i] = tokens[
188                 tokens.length - i - 1
189             ];
190         }
191 
192         uint256[] memory pathAmounts =
193             UniswapStyleLib.getAmountsIn(1000 ether, path, tokens);
194         uint256 inAmount = pathAmounts[0];
195         _setPriceVal(tokenPrice, inAmount, 1000 ether, 1000);
196     }
197 
198     function liquidateToPeg(address token, uint256 amount)
199         internal
200         returns (uint256)
201     {
202         if (token == peg) {
203             return amount;
204         } else {
205             TokenPrice storage tP = tokenPrices[token];
206             uint256[] memory amounts =
207                 MarginRouter(router()).authorizedSwapExactT4T(
208                     amount,
209                     0,
210                     tP.liquidationPairs,
211                     tP.liquidationTokens
212                 );
213 
214             uint256 outAmount = amounts[amounts.length - 1];
215 
216             return outAmount;
217         }
218     }
219 
220     function liquidateFromPeg(address token, uint256 targetAmount)
221         internal
222         returns (uint256)
223     {
224         if (token == peg) {
225             return targetAmount;
226         } else {
227             TokenPrice storage tP = tokenPrices[token];
228             uint256[] memory amounts =
229                 MarginRouter(router()).authorizedSwapT4ExactT(
230                     targetAmount,
231                     type(uint256).max,
232                     tP.inverseLiquidationPairs,
233                     tP.inverseLiquidationTokens
234                 );
235 
236             return amounts[0];
237         }
238     }
239 }
