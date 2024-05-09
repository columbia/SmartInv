1 // SPDX-License-Identifier: MIT
2 
3 /*
4 MIT License
5 
6 Permission is hereby granted, free of charge, to any person obtaining a copy
7 of this software and associated documentation files (the "Software"), to deal
8 in the Software without restriction, including without limitation the rights
9 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
10 copies of the Software, and to permit persons to whom the Software is
11 furnished to do so, subject to the following conditions:
12 
13 The above copyright notice and this permission notice shall be included in all
14 copies or substantial portions of the Software.
15 
16 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
17 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
18 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
19 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
20 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
21 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
22 SOFTWARE.
23 */
24 
25 pragma solidity ^0.6.12;
26 
27 /**
28  * @dev Standard math utilities missing in the Solidity language.
29  */
30 library Math {
31     /**
32      * @dev Returns the largest of two numbers.
33      */
34     function max(uint256 a, uint256 b) internal pure returns (uint256) {
35         return a >= b ? a : b;
36     }
37 
38     /**
39      * @dev Returns the smallest of two numbers.
40      */
41     function min(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a < b ? a : b;
43     }
44 
45     /**
46      * @dev Returns the average of two numbers. The result is rounded towards
47      * zero.
48      */
49     function average(uint256 a, uint256 b) internal pure returns (uint256) {
50         // (a + b) / 2 can overflow, so we distribute
51         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
52     }
53 }
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that revert on error
58  */
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, reverts on overflow.
63   */
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66     // benefit is lost if 'b' is also tested.
67     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
68     if (a == 0) {
69       return 0;
70     }
71 
72     uint256 c = a * b;
73     require(c / a == b);
74 
75     return c;
76   }
77 
78   /**
79   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
80   */
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     require(b > 0); // Solidity only automatically asserts when dividing by 0
83     uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85 
86     return c;
87   }
88 
89   /**
90   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
91   */
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     require(b <= a);
94     uint256 c = a - b;
95 
96     return c;
97   }
98 
99   /**
100   * @dev Adds two numbers, reverts on overflow.
101   */
102   function add(uint256 a, uint256 b) internal pure returns (uint256) {
103     uint256 c = a + b;
104     require(c >= a);
105 
106     return c;
107   }
108 
109   /**
110   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
111   * reverts when dividing by zero.
112   */
113   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114     require(b != 0);
115     return a % b;
116   }
117 }
118 
119 interface IERC20 {
120 
121     function totalSupply() external view returns (uint256);
122     function balanceOf(address account) external view returns (uint256);
123     function transfer(address recipient, uint256 amount) external returns (bool);
124     function allowance(address owner, address spender) external view returns (uint256);
125     function approve(address spender, uint256 amount) external returns (bool);
126     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
127  
128     event Transfer(address indexed from, address indexed to, uint256 value);
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 
133 library SafeERC20 {
134     using SafeMath for uint256;
135     // using Address for address;
136 
137     function safeTransfer(IERC20 token, address to, uint256 value) internal {
138         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
139     }
140 
141     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
142         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
143     }
144 
145     /**
146      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
147      * on the return value: the return value is optional (but if data is returned, it must not be false).
148      * @param token The token targeted by the call.
149      * @param data The call data (encoded using abi.encode or one of its variants).
150      */
151     function callOptionalReturn(IERC20 token, bytes memory data) private {
152 
153         // solhint-disable-next-line avoid-low-level-calls
154         (bool success, bytes memory returndata) = address(token).call(data);
155         require(success, "SafeERC20: low-level call failed");
156 
157         if (returndata.length > 0) { // Return data is optional
158             // solhint-disable-next-line max-line-length
159             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
160         }
161     }
162 }
163 
164 contract ReentrancyGuard {
165     bool private _notEntered;
166 
167     constructor () internal {
168         _notEntered = true;
169     }
170 
171     modifier nonReentrant() {
172         // On the first call to nonReentrant, _notEntered will be true
173         require(_notEntered, "ReentrancyGuard: reentrant call");
174 
175         // Any calls to nonReentrant after this point will fail
176         _notEntered = false;
177 
178         _;
179 
180         // By storing the original value once again, a refund is triggered (see
181         // https://eips.ethereum.org/EIPS/eip-2200)
182         _notEntered = true;
183     }
184 }
185 
186 /**
187  * @title Ownable
188  * @dev The Ownable contract has an owner address, and provides basic authorization control
189  * functions, this simplifies the implementation of "user permissions".
190  */
191 contract Ownable {
192   address private _owner;
193 
194   event OwnershipRenounced(address indexed previousOwner);
195   
196   event OwnershipTransferred(
197     address indexed previousOwner,
198     address indexed newOwner
199   );
200 
201 
202   /**
203    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
204    * account.
205    */
206   constructor() public {
207     _owner = msg.sender;
208   }
209 
210   /**
211    * @return the address of the owner.
212    */
213   function owner() public view returns(address) {
214     return _owner;
215   }
216 
217   /**
218    * @dev Throws if called by any account other than the owner.
219    */
220   modifier onlyOwner() {
221     require(isOwner());
222     _;
223   }
224 
225   /**
226    * @return true if `msg.sender` is the owner of the contract.
227    */
228   function isOwner() public view returns(bool) {
229     return msg.sender == _owner;
230   }
231 
232   /**
233    * @dev Allows the current owner to relinquish control of the contract.
234    * @notice Renouncing to ownership will leave the contract without an owner.
235    * It will not be possible to call the functions with the `onlyOwner`
236    * modifier anymore.
237    */
238   function renounceOwnership() public onlyOwner {
239     emit OwnershipRenounced(_owner);
240     _owner = address(0);
241   }
242 
243   /**
244    * @dev Allows the current owner to transfer control of the contract to a newOwner.
245    * @param newOwner The address to transfer ownership to.
246    */
247   function transferOwnership(address newOwner) public onlyOwner {
248     _transferOwnership(newOwner);
249   }
250 
251   /**
252    * @dev Transfers control of the contract to a newOwner.
253    * @param newOwner The address to transfer ownership to.
254    */
255   function _transferOwnership(address newOwner) internal {
256     require(newOwner != address(0));
257     emit OwnershipTransferred(_owner, newOwner);
258     _owner = newOwner;
259   }
260 }
261 
262 /**
263  * @title Crowdsale
264  * @dev Crowdsale is a base contract for managing a token crowdsale,
265  * allowing investors to purchase tokens with ether. This contract implements
266  * such functionality in its most fundamental form and can be extended to provide additional
267  * functionality and/or custom behavior.
268  * The external interface represents the basic interface for purchasing tokens, and conforms
269  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
270  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
271  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
272  * behavior.
273  */
274 contract Crowdsale is ReentrancyGuard, Ownable {
275     using SafeMath for uint256;
276     using SafeERC20 for IERC20;
277 
278     // The token being sold
279     IERC20 private _token;
280 
281     // Address where funds are collected
282     address payable private _wallet;
283 
284     uint256 private _usdwei;
285 
286     // Amount of wei raised
287     uint256 private _weiRaised;
288 
289     /**
290      * Event for token purchase logging
291      * @param purchaser who paid for the tokens
292      * @param beneficiary who got the tokens
293      * @param value weis paid for purchase
294      * @param amount amount of tokens purchased
295      */
296     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
297 
298     /**
299      * @param usdwei Wei price of 1 USD
300      * @param wallet Address where collected funds will be forwarded to
301      * @param token Address of the token being sold
302      */
303     constructor (uint256 usdwei, address payable wallet, IERC20 token) public {
304         require(usdwei > 0, "Crowdsale: USD wei price is 0");
305         require(wallet != address(0), "Crowdsale: wallet is the zero address");
306         require(address(token) != address(0), "Crowdsale: token is the zero address");
307 
308         _usdwei = usdwei;
309         _wallet = wallet;
310         _token = token;
311     }
312 
313     /**
314      * @dev fallback function ***DO NOT OVERRIDE***
315      * Note that other contracts will transfer funds with a base gas stipend
316      * of 2300, which is not enough to call buyTokens. Consider calling
317      * buyTokens directly when purchasing tokens from a contract.
318      */
319     fallback() external payable {
320         buyTokens(msg.sender);
321     }
322 
323     /**
324      * @param usdwei Wei price of 1 USD
325      */
326     function updateUSDWeiRate(uint256 usdwei) external onlyOwner {
327         _usdwei = usdwei;
328     }
329 
330     /**
331      * @return the token being sold.
332      */
333     function token() public view returns (IERC20) {
334         return _token;
335     }
336 
337     /**
338      * @return the address where funds are collected.
339      */
340     function wallet() public view returns (address payable) {
341         return _wallet;
342     }
343 
344     /**
345      * @return the amount of wei raised.
346      */
347     function weiRaised() public view returns (uint256) {
348         return _weiRaised;
349     }
350 
351     /**
352      * @dev low level token purchase ***DO NOT OVERRIDE***
353      * This function has a non-reentrancy guard, so it shouldn't be called by
354      * another `nonReentrant` function.
355      * @param beneficiary Recipient of the token purchase
356      */
357     function buyTokens(address beneficiary) public nonReentrant payable {
358         uint256 weiAmount = msg.value;
359         _preValidatePurchase(beneficiary, weiAmount);
360 
361         // calculate token amount to be created
362         uint256 tokens = _getTokenAmount(weiAmount);
363 
364         // update state
365         _weiRaised = _weiRaised.add(weiAmount);
366 
367         _processPurchase(beneficiary, tokens);
368         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
369 
370         _updatePurchasingState(beneficiary, weiAmount);
371 
372         _forwardFunds();
373         _postValidatePurchase(beneficiary, weiAmount);
374     }
375 
376     /**
377      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
378      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
379      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
380      *     super._preValidatePurchase(beneficiary, weiAmount);
381      *     require(weiRaised().add(weiAmount) <= cap);
382      * @param beneficiary Address performing the token purchase
383      * @param weiAmount Value in wei involved in the purchase
384      */
385     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
386         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
387         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
388         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
389     }
390 
391     /**
392      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
393      * conditions are not met.
394      * @param beneficiary Address performing the token purchase
395      * @param weiAmount Value in wei involved in the purchase
396      */
397     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
398         // solhint-disable-previous-line no-empty-blocks
399     }
400 
401     /**
402      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
403      * its tokens.
404      * @param beneficiary Address performing the token purchase
405      * @param tokenAmount Number of tokens to be emitted
406      */
407     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal virtual {
408         _token.safeTransfer(beneficiary, tokenAmount);
409     }
410 
411     /**
412      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
413      * tokens.
414      * @param beneficiary Address receiving the tokens
415      * @param tokenAmount Number of tokens to be purchased
416      */
417     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
418         _deliverTokens(beneficiary, tokenAmount);
419     }
420 
421     /**
422      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
423      * etc.)
424      * @param beneficiary Address receiving the tokens
425      * @param weiAmount Value in wei involved in the purchase
426      */
427     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
428         // solhint-disable-previous-line no-empty-blocks
429     }
430 
431     /**
432      * @dev Override to extend the way in which ether is converted to tokens.
433      * @param weiAmount Value in wei to be converted into tokens
434      * @return Number of tokens that can be purchased with the specified _weiAmount
435      */
436     function _getTokenAmount(uint256 weiAmount) public view returns (uint256) {
437 
438         uint256 tokenprice_usd;
439         
440         // Calculate discounts
441         
442         if (weiAmount >= 25 ether) {
443             tokenprice_usd = _usdwei.mul(80).div(100);
444         } else if (weiAmount >= 5 ether) {
445             tokenprice_usd = _usdwei.mul(85).div(100);
446         } else {
447             tokenprice_usd = _usdwei.mul(90).div(100);       
448         }
449 
450         uint256 result = (weiAmount.mul(1e18).div(tokenprice_usd)).div(1e9);
451         
452         require(result > 0, "Less than minimum amount paid");
453         
454         return result;
455         
456     }
457 
458     /**
459      * @dev Determines how ETH is stored/forwarded on purchases.
460      */
461     function _forwardFunds() internal {
462         _wallet.transfer(msg.value);
463     }
464 }
465 
466 /**
467  * @title AllowanceCrowdsale
468  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
469  */
470 contract AllowanceCrowdsale is Crowdsale {
471     using SafeMath for uint256;
472     using SafeERC20 for IERC20;
473 
474     address private _tokenWallet;
475 
476     /**
477      * @dev Constructor, takes token wallet address.
478      * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale.
479      */
480     constructor (address tokenWallet, uint256 usdwei, address payable wallet, IERC20 token)
481         public 
482         Crowdsale(usdwei, wallet, token)
483     {
484         require(tokenWallet != address(0), "AllowanceCrowdsale: token wallet is the zero address");
485         _tokenWallet = tokenWallet;
486     }
487 
488     /**
489      * @return the address of the wallet that will hold the tokens.
490      */
491     function tokenWallet() public view returns (address) {
492         return _tokenWallet;
493     }
494 
495     /**
496      * @dev Checks the amount of tokens left in the allowance.
497      * @return Amount of tokens left in the allowance
498      */
499     function remainingTokens() public view returns (uint256) {
500         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
501     }
502 
503     /**
504      * @dev Overrides parent behavior by transferring tokens from wallet.
505      * @param beneficiary Token purchaser
506      * @param tokenAmount Amount of tokens purchased
507      */
508     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal override {
509         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
510     }
511 }