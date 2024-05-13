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
11 import {SafeMath} from "../lib/SafeMath.sol";
12 import {DecimalMath} from "../lib/DecimalMath.sol";
13 import {Types} from "../lib/Types.sol";
14 import {IDODOCallee} from "../intf/IDODOCallee.sol";
15 import {Storage} from "./Storage.sol";
16 import {Pricing} from "./Pricing.sol";
17 import {Settlement} from "./Settlement.sol";
18 
19 
20 /**
21  * @title Trader
22  * @author DODO Breeder
23  *
24  * @notice Functions for trader operations
25  */
26 contract Trader is Storage, Pricing, Settlement {
27     using SafeMath for uint256;
28 
29     // ============ Events ============
30 
31     event SellBaseToken(address indexed seller, uint256 payBase, uint256 receiveQuote);
32 
33     event BuyBaseToken(address indexed buyer, uint256 receiveBase, uint256 payQuote);
34 
35     event ChargeMaintainerFee(address indexed maintainer, bool isBaseToken, uint256 amount);
36 
37     // ============ Modifiers ============
38 
39     modifier tradeAllowed() {
40         require(_TRADE_ALLOWED_, "TRADE_NOT_ALLOWED");
41         _;
42     }
43 
44     modifier buyingAllowed() {
45         require(_BUYING_ALLOWED_, "BUYING_NOT_ALLOWED");
46         _;
47     }
48 
49     modifier sellingAllowed() {
50         require(_SELLING_ALLOWED_, "SELLING_NOT_ALLOWED");
51         _;
52     }
53 
54     modifier gasPriceLimit() {
55         require(tx.gasprice <= _GAS_PRICE_LIMIT_, "GAS_PRICE_EXCEED");
56         _;
57     }
58 
59     // ============ Trade Functions ============
60 
61     function sellBaseToken(
62         uint256 amount,
63         uint256 minReceiveQuote,
64         bytes calldata data
65     ) external tradeAllowed sellingAllowed gasPriceLimit preventReentrant returns (uint256) {
66         // query price
67         (
68             uint256 receiveQuote,
69             uint256 lpFeeQuote,
70             uint256 mtFeeQuote,
71             Types.RStatus newRStatus,
72             uint256 newQuoteTarget,
73             uint256 newBaseTarget
74         ) = _querySellBaseToken(amount);
75         require(receiveQuote >= minReceiveQuote, "SELL_BASE_RECEIVE_NOT_ENOUGH");
76 
77         // settle assets
78         _quoteTokenTransferOut(msg.sender, receiveQuote);
79         if (data.length > 0) {
80             IDODOCallee(msg.sender).dodoCall(false, amount, receiveQuote, data);
81         }
82         _baseTokenTransferIn(msg.sender, amount);
83         if (mtFeeQuote != 0) {
84             _quoteTokenTransferOut(_MAINTAINER_, mtFeeQuote);
85             emit ChargeMaintainerFee(_MAINTAINER_, false, mtFeeQuote);
86         }
87 
88         // update TARGET
89         if (_TARGET_QUOTE_TOKEN_AMOUNT_ != newQuoteTarget) {
90             _TARGET_QUOTE_TOKEN_AMOUNT_ = newQuoteTarget;
91         }
92         if (_TARGET_BASE_TOKEN_AMOUNT_ != newBaseTarget) {
93             _TARGET_BASE_TOKEN_AMOUNT_ = newBaseTarget;
94         }
95         if (_R_STATUS_ != newRStatus) {
96             _R_STATUS_ = newRStatus;
97         }
98 
99         _donateQuoteToken(lpFeeQuote);
100         emit SellBaseToken(msg.sender, amount, receiveQuote);
101 
102         return receiveQuote;
103     }
104 
105     function buyBaseToken(
106         uint256 amount,
107         uint256 maxPayQuote,
108         bytes calldata data
109     ) external tradeAllowed buyingAllowed gasPriceLimit preventReentrant returns (uint256) {
110         // query price
111         (
112             uint256 payQuote,
113             uint256 lpFeeBase,
114             uint256 mtFeeBase,
115             Types.RStatus newRStatus,
116             uint256 newQuoteTarget,
117             uint256 newBaseTarget
118         ) = _queryBuyBaseToken(amount);
119         require(payQuote <= maxPayQuote, "BUY_BASE_COST_TOO_MUCH");
120 
121         // settle assets
122         _baseTokenTransferOut(msg.sender, amount);
123         if (data.length > 0) {
124             IDODOCallee(msg.sender).dodoCall(true, amount, payQuote, data);
125         }
126         _quoteTokenTransferIn(msg.sender, payQuote);
127         if (mtFeeBase != 0) {
128             _baseTokenTransferOut(_MAINTAINER_, mtFeeBase);
129             emit ChargeMaintainerFee(_MAINTAINER_, true, mtFeeBase);
130         }
131 
132         // update TARGET
133         if (_TARGET_QUOTE_TOKEN_AMOUNT_ != newQuoteTarget) {
134             _TARGET_QUOTE_TOKEN_AMOUNT_ = newQuoteTarget;
135         }
136         if (_TARGET_BASE_TOKEN_AMOUNT_ != newBaseTarget) {
137             _TARGET_BASE_TOKEN_AMOUNT_ = newBaseTarget;
138         }
139         if (_R_STATUS_ != newRStatus) {
140             _R_STATUS_ = newRStatus;
141         }
142 
143         _donateBaseToken(lpFeeBase);
144         emit BuyBaseToken(msg.sender, amount, payQuote);
145 
146         return payQuote;
147     }
148 
149     // ============ Query Functions ============
150 
151     function querySellBaseToken(uint256 amount) external view returns (uint256 receiveQuote) {
152         (receiveQuote, , , , , ) = _querySellBaseToken(amount);
153         return receiveQuote;
154     }
155 
156     function queryBuyBaseToken(uint256 amount) external view returns (uint256 payQuote) {
157         (payQuote, , , , , ) = _queryBuyBaseToken(amount);
158         return payQuote;
159     }
160 
161     function _querySellBaseToken(uint256 amount)
162         internal
163         view
164         returns (
165             uint256 receiveQuote,
166             uint256 lpFeeQuote,
167             uint256 mtFeeQuote,
168             Types.RStatus newRStatus,
169             uint256 newQuoteTarget,
170             uint256 newBaseTarget
171         )
172     {
173         (newBaseTarget, newQuoteTarget) = getExpectedTarget();
174 
175         uint256 sellBaseAmount = amount;
176 
177         if (_R_STATUS_ == Types.RStatus.ONE) {
178             // case 1: R=1
179             // R falls below one
180             receiveQuote = _ROneSellBaseToken(sellBaseAmount, newQuoteTarget);
181             newRStatus = Types.RStatus.BELOW_ONE;
182         } else if (_R_STATUS_ == Types.RStatus.ABOVE_ONE) {
183             uint256 backToOnePayBase = newBaseTarget.sub(_BASE_BALANCE_);
184             uint256 backToOneReceiveQuote = _QUOTE_BALANCE_.sub(newQuoteTarget);
185             // case 2: R>1
186             // complex case, R status depends on trading amount
187             if (sellBaseAmount < backToOnePayBase) {
188                 // case 2.1: R status do not change
189                 receiveQuote = _RAboveSellBaseToken(sellBaseAmount, _BASE_BALANCE_, newBaseTarget);
190                 newRStatus = Types.RStatus.ABOVE_ONE;
191                 if (receiveQuote > backToOneReceiveQuote) {
192                     // [Important corner case!] may enter this branch when some precision problem happens. And consequently contribute to negative spare quote amount
193                     // to make sure spare quote>=0, mannually set receiveQuote=backToOneReceiveQuote
194                     receiveQuote = backToOneReceiveQuote;
195                 }
196             } else if (sellBaseAmount == backToOnePayBase) {
197                 // case 2.2: R status changes to ONE
198                 receiveQuote = backToOneReceiveQuote;
199                 newRStatus = Types.RStatus.ONE;
200             } else {
201                 // case 2.3: R status changes to BELOW_ONE
202                 receiveQuote = backToOneReceiveQuote.add(
203                     _ROneSellBaseToken(sellBaseAmount.sub(backToOnePayBase), newQuoteTarget)
204                 );
205                 newRStatus = Types.RStatus.BELOW_ONE;
206             }
207         } else {
208             // _R_STATUS_ == Types.RStatus.BELOW_ONE
209             // case 3: R<1
210             receiveQuote = _RBelowSellBaseToken(sellBaseAmount, _QUOTE_BALANCE_, newQuoteTarget);
211             newRStatus = Types.RStatus.BELOW_ONE;
212         }
213 
214         // count fees
215         lpFeeQuote = DecimalMath.mul(receiveQuote, _LP_FEE_RATE_);
216         mtFeeQuote = DecimalMath.mul(receiveQuote, _MT_FEE_RATE_);
217         receiveQuote = receiveQuote.sub(lpFeeQuote).sub(mtFeeQuote);
218 
219         return (receiveQuote, lpFeeQuote, mtFeeQuote, newRStatus, newQuoteTarget, newBaseTarget);
220     }
221 
222     function _queryBuyBaseToken(uint256 amount)
223         internal
224         view
225         returns (
226             uint256 payQuote,
227             uint256 lpFeeBase,
228             uint256 mtFeeBase,
229             Types.RStatus newRStatus,
230             uint256 newQuoteTarget,
231             uint256 newBaseTarget
232         )
233     {
234         (newBaseTarget, newQuoteTarget) = getExpectedTarget();
235 
236         // charge fee from user receive amount
237         lpFeeBase = DecimalMath.mul(amount, _LP_FEE_RATE_);
238         mtFeeBase = DecimalMath.mul(amount, _MT_FEE_RATE_);
239         uint256 buyBaseAmount = amount.add(lpFeeBase).add(mtFeeBase);
240 
241         if (_R_STATUS_ == Types.RStatus.ONE) {
242             // case 1: R=1
243             payQuote = _ROneBuyBaseToken(buyBaseAmount, newBaseTarget);
244             newRStatus = Types.RStatus.ABOVE_ONE;
245         } else if (_R_STATUS_ == Types.RStatus.ABOVE_ONE) {
246             // case 2: R>1
247             payQuote = _RAboveBuyBaseToken(buyBaseAmount, _BASE_BALANCE_, newBaseTarget);
248             newRStatus = Types.RStatus.ABOVE_ONE;
249         } else if (_R_STATUS_ == Types.RStatus.BELOW_ONE) {
250             uint256 backToOnePayQuote = newQuoteTarget.sub(_QUOTE_BALANCE_);
251             uint256 backToOneReceiveBase = _BASE_BALANCE_.sub(newBaseTarget);
252             // case 3: R<1
253             // complex case, R status may change
254             if (buyBaseAmount < backToOneReceiveBase) {
255                 // case 3.1: R status do not change
256                 // no need to check payQuote because spare base token must be greater than zero
257                 payQuote = _RBelowBuyBaseToken(buyBaseAmount, _QUOTE_BALANCE_, newQuoteTarget);
258                 newRStatus = Types.RStatus.BELOW_ONE;
259             } else if (buyBaseAmount == backToOneReceiveBase) {
260                 // case 3.2: R status changes to ONE
261                 payQuote = backToOnePayQuote;
262                 newRStatus = Types.RStatus.ONE;
263             } else {
264                 // case 3.3: R status changes to ABOVE_ONE
265                 payQuote = backToOnePayQuote.add(
266                     _ROneBuyBaseToken(buyBaseAmount.sub(backToOneReceiveBase), newBaseTarget)
267                 );
268                 newRStatus = Types.RStatus.ABOVE_ONE;
269             }
270         }
271 
272         return (payQuote, lpFeeBase, mtFeeBase, newRStatus, newQuoteTarget, newBaseTarget);
273     }
274 }
