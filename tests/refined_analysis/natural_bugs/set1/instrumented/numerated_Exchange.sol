1 //SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.4;
3 
4 import "../libraries/MathLib.sol";
5 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
8 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
9 import "../interfaces/IExchangeFactory.sol";
10 
11 /**
12  * @title Exchange contract for Elastic Swap representing a single ERC20 pair of tokens to be swapped.
13  * @author Elastic DAO
14  * @notice This contract provides all of the needed functionality for a liquidity provider to supply/withdraw ERC20
15  * tokens and traders to swap tokens for one another.
16  */
17 contract Exchange is ERC20, ReentrancyGuard {
18     using MathLib for uint256;
19     using SafeERC20 for IERC20;
20 
21     address public immutable baseToken; // address of ERC20 base token (elastic or fixed supply)
22     address public immutable quoteToken; // address of ERC20 quote token (WETH or a stable coin w/ fixed supply)
23     address public immutable exchangeFactoryAddress;
24 
25     uint256 public constant TOTAL_LIQUIDITY_FEE = 30; // fee provided to liquidity providers + DAO in basis points
26 
27     MathLib.InternalBalances public internalBalances =
28         MathLib.InternalBalances(0, 0, 0);
29 
30     event AddLiquidity(
31         address indexed liquidityProvider,
32         uint256 baseTokenQtyAdded,
33         uint256 quoteTokenQtyAdded
34     );
35     event RemoveLiquidity(
36         address indexed liquidityProvider,
37         uint256 baseTokenQtyRemoved,
38         uint256 quoteTokenQtyRemoved
39     );
40     event Swap(
41         address indexed sender,
42         uint256 baseTokenQtyIn,
43         uint256 quoteTokenQtyIn,
44         uint256 baseTokenQtyOut,
45         uint256 quoteTokenQtyOut
46     );
47 
48     /**
49      * @dev Called to check timestamps from users for expiration of their calls.
50      * Used in place of a modifier for byte code savings
51      */
52     function isNotExpired(uint256 _expirationTimeStamp) internal view {
53         require(_expirationTimeStamp >= block.timestamp, "Exchange: EXPIRED");
54     }
55 
56     /**
57      * @notice called by the exchange factory to create a new erc20 token swap pair (do not call this directly!)
58      * @param _name The human readable name of this pair (also used for the liquidity token name)
59      * @param _symbol Shortened symbol for trading pair (also used for the liquidity token symbol)
60      * @param _baseToken address of the ERC20 base token in the pair. This token can have a fixed or elastic supply
61      * @param _quoteToken address of the ERC20 quote token in the pair. This token is assumed to have a fixed supply.
62      */
63     constructor(
64         string memory _name,
65         string memory _symbol,
66         address _baseToken,
67         address _quoteToken,
68         address _exchangeFactoryAddress
69     ) ERC20(_name, _symbol) {
70         baseToken = _baseToken;
71         quoteToken = _quoteToken;
72         exchangeFactoryAddress = _exchangeFactoryAddress;
73     }
74 
75     /**
76      * @notice primary entry point for a liquidity provider to add new liquidity (base and quote tokens) to the exchange
77      * and receive liquidity tokens in return.
78      * Requires approvals to be granted to this exchange for both base and quote tokens.
79      * @param _baseTokenQtyDesired qty of baseTokens that you would like to add to the exchange
80      * @param _quoteTokenQtyDesired qty of quoteTokens that you would like to add to the exchange
81      * @param _baseTokenQtyMin minimum acceptable qty of baseTokens that will be added (or transaction will revert)
82      * @param _quoteTokenQtyMin minimum acceptable qty of quoteTokens that will be added (or transaction will revert)
83      * @param _liquidityTokenRecipient address for the exchange to issue the resulting liquidity tokens from
84      * this transaction to
85      * @param _expirationTimestamp timestamp that this transaction must occur before (or transaction will revert)
86      */
87     function addLiquidity(
88         uint256 _baseTokenQtyDesired,
89         uint256 _quoteTokenQtyDesired,
90         uint256 _baseTokenQtyMin,
91         uint256 _quoteTokenQtyMin,
92         address _liquidityTokenRecipient,
93         uint256 _expirationTimestamp
94     ) external nonReentrant() {
95         isNotExpired(_expirationTimestamp);
96 
97         MathLib.TokenQtys memory tokenQtys =
98             MathLib.calculateAddLiquidityQuantities(
99                 _baseTokenQtyDesired,
100                 _quoteTokenQtyDesired,
101                 _baseTokenQtyMin,
102                 _quoteTokenQtyMin,
103                 IERC20(baseToken).balanceOf(address(this)),
104                 IERC20(quoteToken).balanceOf(address(this)),
105                 this.totalSupply(),
106                 internalBalances
107             );
108 
109         internalBalances.kLast =
110             internalBalances.baseTokenReserveQty *
111             internalBalances.quoteTokenReserveQty;
112 
113         if (tokenQtys.liquidityTokenFeeQty > 0) {
114             // mint liquidity tokens to fee address for k growth.
115             _mint(
116                 IExchangeFactory(exchangeFactoryAddress).feeAddress(),
117                 tokenQtys.liquidityTokenFeeQty
118             );
119         }
120         _mint(_liquidityTokenRecipient, tokenQtys.liquidityTokenQty); // mint liquidity tokens to recipient
121 
122         if (tokenQtys.baseTokenQty != 0) {
123             bool isExchangeEmpty =
124                 IERC20(baseToken).balanceOf(address(this)) == 0;
125 
126             // transfer base tokens to Exchange
127             IERC20(baseToken).safeTransferFrom(
128                 msg.sender,
129                 address(this),
130                 tokenQtys.baseTokenQty
131             );
132 
133             if (isExchangeEmpty) {
134                 require(
135                     IERC20(baseToken).balanceOf(address(this)) ==
136                         tokenQtys.baseTokenQty,
137                     "Exchange: FEE_ON_TRANSFER_NOT_SUPPORTED"
138                 );
139             }
140         }
141 
142         if (tokenQtys.quoteTokenQty != 0) {
143             // transfer quote tokens to Exchange
144             IERC20(quoteToken).safeTransferFrom(
145                 msg.sender,
146                 address(this),
147                 tokenQtys.quoteTokenQty
148             );
149         }
150 
151         emit AddLiquidity(
152             msg.sender,
153             tokenQtys.baseTokenQty,
154             tokenQtys.quoteTokenQty
155         );
156     }
157 
158     /**
159      * @notice called by a liquidity provider to redeem liquidity tokens from the exchange and receive back
160      * base and quote tokens. Required approvals to be granted to this exchange for the liquidity token
161      * @param _liquidityTokenQty qty of liquidity tokens that you would like to redeem
162      * @param _baseTokenQtyMin minimum acceptable qty of base tokens to receive back (or transaction will revert)
163      * @param _quoteTokenQtyMin minimum acceptable qty of quote tokens to receive back (or transaction will revert)
164      * @param _tokenRecipient address for the exchange to issue the resulting base and
165      * quote tokens from this transaction to
166      * @param _expirationTimestamp timestamp that this transaction must occur before (or transaction will revert)
167      */
168     function removeLiquidity(
169         uint256 _liquidityTokenQty,
170         uint256 _baseTokenQtyMin,
171         uint256 _quoteTokenQtyMin,
172         address _tokenRecipient,
173         uint256 _expirationTimestamp
174     ) external nonReentrant() {
175         isNotExpired(_expirationTimestamp);
176         require(this.totalSupply() > 0, "Exchange: INSUFFICIENT_LIQUIDITY");
177         require(
178             _baseTokenQtyMin > 0 && _quoteTokenQtyMin > 0,
179             "Exchange: MINS_MUST_BE_GREATER_THAN_ZERO"
180         );
181 
182         uint256 baseTokenReserveQty =
183             IERC20(baseToken).balanceOf(address(this));
184         uint256 quoteTokenReserveQty =
185             IERC20(quoteToken).balanceOf(address(this));
186 
187         uint256 totalSupplyOfLiquidityTokens = this.totalSupply();
188         // calculate any DAO fees here.
189         uint256 liquidityTokenFeeQty =
190             MathLib.calculateLiquidityTokenFees(
191                 totalSupplyOfLiquidityTokens,
192                 internalBalances
193             );
194 
195         // we need to factor this quantity in to any total supply before redemption
196         totalSupplyOfLiquidityTokens += liquidityTokenFeeQty;
197 
198         uint256 baseTokenQtyToReturn =
199             (_liquidityTokenQty * baseTokenReserveQty) /
200                 totalSupplyOfLiquidityTokens;
201         uint256 quoteTokenQtyToReturn =
202             (_liquidityTokenQty * quoteTokenReserveQty) /
203                 totalSupplyOfLiquidityTokens;
204 
205         require(
206             baseTokenQtyToReturn >= _baseTokenQtyMin,
207             "Exchange: INSUFFICIENT_BASE_QTY"
208         );
209 
210         require(
211             quoteTokenQtyToReturn >= _quoteTokenQtyMin,
212             "Exchange: INSUFFICIENT_QUOTE_QTY"
213         );
214 
215         // this ensure that we are removing the equivalent amount of decay
216         // when this person exits.
217         uint256 baseTokenQtyToRemoveFromInternalAccounting =
218             (_liquidityTokenQty * internalBalances.baseTokenReserveQty) /
219                 totalSupplyOfLiquidityTokens;
220 
221         internalBalances
222             .baseTokenReserveQty -= baseTokenQtyToRemoveFromInternalAccounting;
223 
224         // We should ensure no possible overflow here.
225         if (quoteTokenQtyToReturn > internalBalances.quoteTokenReserveQty) {
226             internalBalances.quoteTokenReserveQty = 0;
227         } else {
228             internalBalances.quoteTokenReserveQty -= quoteTokenQtyToReturn;
229         }
230 
231         internalBalances.kLast =
232             internalBalances.baseTokenReserveQty *
233             internalBalances.quoteTokenReserveQty;
234 
235         if (liquidityTokenFeeQty > 0) {
236             _mint(
237                 IExchangeFactory(exchangeFactoryAddress).feeAddress(),
238                 liquidityTokenFeeQty
239             );
240         }
241 
242         _burn(msg.sender, _liquidityTokenQty);
243         IERC20(baseToken).safeTransfer(_tokenRecipient, baseTokenQtyToReturn);
244         IERC20(quoteToken).safeTransfer(_tokenRecipient, quoteTokenQtyToReturn);
245         emit RemoveLiquidity(
246             msg.sender,
247             baseTokenQtyToReturn,
248             quoteTokenQtyToReturn
249         );
250     }
251 
252     /**
253      * @notice swaps base tokens for a minimum amount of quote tokens.  Fees are included in all transactions.
254      * The exchange must be granted approvals for the base token by the caller.
255      * @param _baseTokenQty qty of base tokens to swap
256      * @param _minQuoteTokenQty minimum qty of quote tokens to receive in exchange for
257      * your base tokens (or the transaction will revert)
258      * @param _expirationTimestamp timestamp that this transaction must occur before (or transaction will revert)
259      */
260     function swapBaseTokenForQuoteToken(
261         uint256 _baseTokenQty,
262         uint256 _minQuoteTokenQty,
263         uint256 _expirationTimestamp
264     ) external nonReentrant() {
265         isNotExpired(_expirationTimestamp);
266         require(
267             _baseTokenQty > 0 && _minQuoteTokenQty > 0,
268             "Exchange: INSUFFICIENT_TOKEN_QTY"
269         );
270 
271         uint256 quoteTokenQty =
272             MathLib.calculateQuoteTokenQty(
273                 _baseTokenQty,
274                 _minQuoteTokenQty,
275                 TOTAL_LIQUIDITY_FEE,
276                 internalBalances
277             );
278 
279         IERC20(baseToken).safeTransferFrom(
280             msg.sender,
281             address(this),
282             _baseTokenQty
283         );
284 
285         IERC20(quoteToken).safeTransfer(msg.sender, quoteTokenQty);
286         emit Swap(msg.sender, _baseTokenQty, 0, 0, quoteTokenQty);
287     }
288 
289     /**
290      * @notice swaps quote tokens for a minimum amount of base tokens.  Fees are included in all transactions.
291      * The exchange must be granted approvals for the quote token by the caller.
292      * @param _quoteTokenQty qty of quote tokens to swap
293      * @param _minBaseTokenQty minimum qty of base tokens to receive in exchange for
294      * your quote tokens (or the transaction will revert)
295      * @param _expirationTimestamp timestamp that this transaction must occur before (or transaction will revert)
296      */
297     function swapQuoteTokenForBaseToken(
298         uint256 _quoteTokenQty,
299         uint256 _minBaseTokenQty,
300         uint256 _expirationTimestamp
301     ) external nonReentrant() {
302         isNotExpired(_expirationTimestamp);
303         require(
304             _quoteTokenQty > 0 && _minBaseTokenQty > 0,
305             "Exchange: INSUFFICIENT_TOKEN_QTY"
306         );
307 
308         uint256 baseTokenQty =
309             MathLib.calculateBaseTokenQty(
310                 _quoteTokenQty,
311                 _minBaseTokenQty,
312                 IERC20(baseToken).balanceOf(address(this)),
313                 TOTAL_LIQUIDITY_FEE,
314                 internalBalances
315             );
316 
317         IERC20(quoteToken).safeTransferFrom(
318             msg.sender,
319             address(this),
320             _quoteTokenQty
321         );
322 
323         IERC20(baseToken).safeTransfer(msg.sender, baseTokenQty);
324         emit Swap(msg.sender, 0, _quoteTokenQty, baseTokenQty, 0);
325     }
326 }
