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
11 import {ReentrancyGuard} from "./lib/ReentrancyGuard.sol";
12 import {SafeERC20} from "./lib/SafeERC20.sol";
13 import {SafeMath} from "./lib/SafeMath.sol";
14 import {IDODO} from "./intf/IDODO.sol";
15 import {IERC20} from "./intf/IERC20.sol";
16 import {IWETH} from "./intf/IWETH.sol";
17 
18 interface IDODOZoo {
19     function getDODO(address baseToken, address quoteToken) external view returns (address);
20 }
21 
22 /**
23  * @title DODO Eth Proxy
24  * @author DODO Breeder
25  *
26  * @notice Handle ETH-WETH converting for users.
27  */
28 contract DODOEthProxy is ReentrancyGuard {
29     using SafeERC20 for IERC20;
30     using SafeMath for uint256;
31 
32     address public _DODO_ZOO_;
33     address payable public _WETH_;
34 
35     // ============ Events ============
36 
37     event ProxySellEthToToken(
38         address indexed seller,
39         address indexed quoteToken,
40         uint256 payEth,
41         uint256 receiveToken
42     );
43 
44     event ProxyBuyEthWithToken(
45         address indexed buyer,
46         address indexed quoteToken,
47         uint256 receiveEth,
48         uint256 payToken
49     );
50 
51     event ProxySellTokenToEth(
52         address indexed seller,
53         address indexed baseToken,
54         uint256 payToken,
55         uint256 receiveEth
56     );
57 
58     event ProxyBuyTokenWithEth(
59         address indexed buyer,
60         address indexed baseToken,
61         uint256 receiveToken,
62         uint256 payEth
63     );
64 
65     event ProxyDepositEthAsBase(address indexed lp, address indexed DODO, uint256 ethAmount);
66 
67     event ProxyWithdrawEthAsBase(address indexed lp, address indexed DODO, uint256 ethAmount);
68 
69     event ProxyDepositEthAsQuote(address indexed lp, address indexed DODO, uint256 ethAmount);
70 
71     event ProxyWithdrawEthAsQuote(address indexed lp, address indexed DODO, uint256 ethAmount);
72 
73     // ============ Functions ============
74 
75     constructor(address dodoZoo, address payable weth) public {
76         _DODO_ZOO_ = dodoZoo;
77         _WETH_ = weth;
78     }
79 
80     fallback() external payable {
81         require(msg.sender == _WETH_, "WE_SAVED_YOUR_ETH_:)");
82     }
83 
84     receive() external payable {
85         require(msg.sender == _WETH_, "WE_SAVED_YOUR_ETH_:)");
86     }
87 
88     function sellEthToToken(
89         address quoteTokenAddress,
90         uint256 ethAmount,
91         uint256 minReceiveTokenAmount
92     ) external payable preventReentrant returns (uint256 receiveTokenAmount) {
93         require(msg.value == ethAmount, "ETH_AMOUNT_NOT_MATCH");
94         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(_WETH_, quoteTokenAddress);
95         require(DODO != address(0), "DODO_NOT_EXIST");
96         IWETH(_WETH_).deposit{value: ethAmount}();
97         IWETH(_WETH_).approve(DODO, ethAmount);
98         receiveTokenAmount = IDODO(DODO).sellBaseToken(ethAmount, minReceiveTokenAmount, "");
99         _transferOut(quoteTokenAddress, msg.sender, receiveTokenAmount);
100         emit ProxySellEthToToken(msg.sender, quoteTokenAddress, ethAmount, receiveTokenAmount);
101         return receiveTokenAmount;
102     }
103 
104     function buyEthWithToken(
105         address quoteTokenAddress,
106         uint256 ethAmount,
107         uint256 maxPayTokenAmount
108     ) external preventReentrant returns (uint256 payTokenAmount) {
109         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(_WETH_, quoteTokenAddress);
110         require(DODO != address(0), "DODO_NOT_EXIST");
111         payTokenAmount = IDODO(DODO).queryBuyBaseToken(ethAmount);
112         _transferIn(quoteTokenAddress, msg.sender, payTokenAmount);
113         IERC20(quoteTokenAddress).safeApprove(DODO, payTokenAmount);
114         IDODO(DODO).buyBaseToken(ethAmount, maxPayTokenAmount, "");
115         IWETH(_WETH_).withdraw(ethAmount);
116         msg.sender.transfer(ethAmount);
117         emit ProxyBuyEthWithToken(msg.sender, quoteTokenAddress, ethAmount, payTokenAmount);
118         return payTokenAmount;
119     }
120 
121     function sellTokenToEth(
122         address baseTokenAddress,
123         uint256 tokenAmount,
124         uint256 minReceiveEthAmount
125     ) external preventReentrant returns (uint256 receiveEthAmount) {
126         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(baseTokenAddress, _WETH_);
127         require(DODO != address(0), "DODO_NOT_EXIST");
128         IERC20(baseTokenAddress).safeApprove(DODO, tokenAmount);
129         _transferIn(baseTokenAddress, msg.sender, tokenAmount);
130         receiveEthAmount = IDODO(DODO).sellBaseToken(tokenAmount, minReceiveEthAmount, "");
131         IWETH(_WETH_).withdraw(receiveEthAmount);
132         msg.sender.transfer(receiveEthAmount);
133         emit ProxySellTokenToEth(msg.sender, baseTokenAddress, tokenAmount, receiveEthAmount);
134         return receiveEthAmount;
135     }
136 
137     function buyTokenWithEth(
138         address baseTokenAddress,
139         uint256 tokenAmount,
140         uint256 maxPayEthAmount
141     ) external payable preventReentrant returns (uint256 payEthAmount) {
142         require(msg.value == maxPayEthAmount, "ETH_AMOUNT_NOT_MATCH");
143         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(baseTokenAddress, _WETH_);
144         require(DODO != address(0), "DODO_NOT_EXIST");
145         payEthAmount = IDODO(DODO).queryBuyBaseToken(tokenAmount);
146         IWETH(_WETH_).deposit{value: payEthAmount}();
147         IWETH(_WETH_).approve(DODO, payEthAmount);
148         IDODO(DODO).buyBaseToken(tokenAmount, maxPayEthAmount, "");
149         _transferOut(baseTokenAddress, msg.sender, tokenAmount);
150         uint256 refund = maxPayEthAmount.sub(payEthAmount);
151         if (refund > 0) {
152             msg.sender.transfer(refund);
153         }
154         emit ProxyBuyTokenWithEth(msg.sender, baseTokenAddress, tokenAmount, payEthAmount);
155         return payEthAmount;
156     }
157 
158     function depositEthAsBase(uint256 ethAmount, address quoteTokenAddress)
159         external
160         payable
161         preventReentrant
162     {
163         require(msg.value == ethAmount, "ETH_AMOUNT_NOT_MATCH");
164         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(_WETH_, quoteTokenAddress);
165         require(DODO != address(0), "DODO_NOT_EXIST");
166         IWETH(_WETH_).deposit{value: ethAmount}();
167         IWETH(_WETH_).approve(DODO, ethAmount);
168         IDODO(DODO).depositBaseTo(msg.sender, ethAmount);
169         emit ProxyDepositEthAsBase(msg.sender, DODO, ethAmount);
170     }
171 
172     function withdrawEthAsBase(uint256 ethAmount, address quoteTokenAddress)
173         external
174         preventReentrant
175         returns (uint256 withdrawAmount)
176     {
177         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(_WETH_, quoteTokenAddress);
178         require(DODO != address(0), "DODO_NOT_EXIST");
179         address ethLpToken = IDODO(DODO)._BASE_CAPITAL_TOKEN_();
180 
181         // transfer all pool shares to proxy
182         uint256 lpBalance = IERC20(ethLpToken).balanceOf(msg.sender);
183         IERC20(ethLpToken).transferFrom(msg.sender, address(this), lpBalance);
184         IDODO(DODO).withdrawBase(ethAmount);
185 
186         // transfer remain shares back to msg.sender
187         lpBalance = IERC20(ethLpToken).balanceOf(address(this));
188         IERC20(ethLpToken).transfer(msg.sender, lpBalance);
189 
190         // because of withdraw penalty, withdrawAmount may not equal to ethAmount
191         // query weth amount first and than transfer ETH to msg.sender
192         uint256 wethAmount = IERC20(_WETH_).balanceOf(address(this));
193         IWETH(_WETH_).withdraw(wethAmount);
194         msg.sender.transfer(wethAmount);
195         emit ProxyWithdrawEthAsBase(msg.sender, DODO, wethAmount);
196         return wethAmount;
197     }
198 
199     function withdrawAllEthAsBase(address quoteTokenAddress)
200         external
201         preventReentrant
202         returns (uint256 withdrawAmount)
203     {
204         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(_WETH_, quoteTokenAddress);
205         require(DODO != address(0), "DODO_NOT_EXIST");
206         address ethLpToken = IDODO(DODO)._BASE_CAPITAL_TOKEN_();
207 
208         // transfer all pool shares to proxy
209         uint256 lpBalance = IERC20(ethLpToken).balanceOf(msg.sender);
210         IERC20(ethLpToken).transferFrom(msg.sender, address(this), lpBalance);
211         IDODO(DODO).withdrawAllBase();
212 
213         // because of withdraw penalty, withdrawAmount may not equal to ethAmount
214         // query weth amount first and than transfer ETH to msg.sender
215         uint256 wethAmount = IERC20(_WETH_).balanceOf(address(this));
216         IWETH(_WETH_).withdraw(wethAmount);
217         msg.sender.transfer(wethAmount);
218         emit ProxyWithdrawEthAsBase(msg.sender, DODO, wethAmount);
219         return wethAmount;
220     }
221 
222     function depositEthAsQuote(uint256 ethAmount, address baseTokenAddress)
223         external
224         payable
225         preventReentrant
226     {
227         require(msg.value == ethAmount, "ETH_AMOUNT_NOT_MATCH");
228         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(baseTokenAddress, _WETH_);
229         require(DODO != address(0), "DODO_NOT_EXIST");
230         IWETH(_WETH_).deposit{value: ethAmount}();
231         IWETH(_WETH_).approve(DODO, ethAmount);
232         IDODO(DODO).depositQuoteTo(msg.sender, ethAmount);
233         emit ProxyDepositEthAsQuote(msg.sender, DODO, ethAmount);
234     }
235 
236     function withdrawEthAsQuote(uint256 ethAmount, address baseTokenAddress)
237         external
238         preventReentrant
239         returns (uint256 withdrawAmount)
240     {
241         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(baseTokenAddress, _WETH_);
242         require(DODO != address(0), "DODO_NOT_EXIST");
243         address ethLpToken = IDODO(DODO)._QUOTE_CAPITAL_TOKEN_();
244 
245         // transfer all pool shares to proxy
246         uint256 lpBalance = IERC20(ethLpToken).balanceOf(msg.sender);
247         IERC20(ethLpToken).transferFrom(msg.sender, address(this), lpBalance);
248         IDODO(DODO).withdrawQuote(ethAmount);
249 
250         // transfer remain shares back to msg.sender
251         lpBalance = IERC20(ethLpToken).balanceOf(address(this));
252         IERC20(ethLpToken).transfer(msg.sender, lpBalance);
253 
254         // because of withdraw penalty, withdrawAmount may not equal to ethAmount
255         // query weth amount first and than transfer ETH to msg.sender
256         uint256 wethAmount = IERC20(_WETH_).balanceOf(address(this));
257         IWETH(_WETH_).withdraw(wethAmount);
258         msg.sender.transfer(wethAmount);
259         emit ProxyWithdrawEthAsQuote(msg.sender, DODO, wethAmount);
260         return wethAmount;
261     }
262 
263     function withdrawAllEthAsQuote(address baseTokenAddress)
264         external
265         preventReentrant
266         returns (uint256 withdrawAmount)
267     {
268         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(baseTokenAddress, _WETH_);
269         require(DODO != address(0), "DODO_NOT_EXIST");
270         address ethLpToken = IDODO(DODO)._QUOTE_CAPITAL_TOKEN_();
271 
272         // transfer all pool shares to proxy
273         uint256 lpBalance = IERC20(ethLpToken).balanceOf(msg.sender);
274         IERC20(ethLpToken).transferFrom(msg.sender, address(this), lpBalance);
275         IDODO(DODO).withdrawAllQuote();
276 
277         // because of withdraw penalty, withdrawAmount may not equal to ethAmount
278         // query weth amount first and than transfer ETH to msg.sender
279         uint256 wethAmount = IERC20(_WETH_).balanceOf(address(this));
280         IWETH(_WETH_).withdraw(wethAmount);
281         msg.sender.transfer(wethAmount);
282         emit ProxyWithdrawEthAsQuote(msg.sender, DODO, wethAmount);
283         return wethAmount;
284     }
285 
286     // ============ Helper Functions ============
287 
288     function _transferIn(
289         address tokenAddress,
290         address from,
291         uint256 amount
292     ) internal {
293         IERC20(tokenAddress).safeTransferFrom(from, address(this), amount);
294     }
295 
296     function _transferOut(
297         address tokenAddress,
298         address to,
299         uint256 amount
300     ) internal {
301         IERC20(tokenAddress).safeTransfer(to, amount);
302     }
303 }
