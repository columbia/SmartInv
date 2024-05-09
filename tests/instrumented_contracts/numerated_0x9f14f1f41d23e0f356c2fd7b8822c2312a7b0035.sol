1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 pragma solidity ^0.5.2;
25 
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32     * @dev Multiplies two unsigned integers, reverts on overflow.
33     */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Adds two unsigned integers, reverts on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82     * reverts when dividing by zero.
83     */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 pragma solidity ^0.5.2;
90 
91 
92 
93 /**
94  * @title SafeERC20
95  * @dev Wrappers around ERC20 operations that throw on failure.
96  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
97  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
98  */
99 library SafeERC20 {
100     using SafeMath for uint256;
101 
102     function safeTransfer(IERC20 token, address to, uint256 value) internal {
103         require(token.transfer(to, value));
104     }
105 
106     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
107         require(token.transferFrom(from, to, value));
108     }
109 
110     function safeApprove(IERC20 token, address spender, uint256 value) internal {
111         // safeApprove should only be called when setting an initial allowance,
112         // or when resetting it to zero. To increase and decrease it, use
113         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
114         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
115         require(token.approve(spender, value));
116     }
117 
118     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
119         uint256 newAllowance = token.allowance(address(this), spender).add(value);
120         require(token.approve(spender, newAllowance));
121     }
122 
123     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
124         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
125         require(token.approve(spender, newAllowance));
126     }
127 }
128 pragma solidity ^0.5.2;
129 
130 /**
131  * @title Helps contracts guard against reentrancy attacks.
132  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
133  * @dev If you mark a function `nonReentrant`, you should also
134  * mark it `external`.
135  */
136 contract ReentrancyGuard {
137     /// @dev counter to allow mutex lock with only one SSTORE operation
138     uint256 private _guardCounter;
139 
140     constructor () internal {
141         // The counter starts at one to prevent changing it from zero to a non-zero
142         // value, which is a more expensive operation.
143         _guardCounter = 1;
144     }
145 
146     /**
147      * @dev Prevents a contract from calling itself, directly or indirectly.
148      * Calling a `nonReentrant` function from another `nonReentrant`
149      * function is not supported. It is possible to prevent this from happening
150      * by making the `nonReentrant` function external, and make it call a
151      * `private` function that does the actual work.
152      */
153     modifier nonReentrant() {
154         _guardCounter += 1;
155         uint256 localCounter = _guardCounter;
156         _;
157         require(localCounter == _guardCounter);
158     }
159 }
160 /**
161  * @title Crowdsale
162  * @dev Crowdsale is a base contract for managing a token crowdsale,
163  * allowing investors to purchase tokens with ether. This contract implements
164  * such functionality in its most fundamental form and can be extended to provide additional
165  * functionality and/or custom behavior.
166  * The external interface represents the basic interface for purchasing tokens, and conform
167  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
168  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
169  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
170  * behavior.
171  */
172 contract Crowdsale is ReentrancyGuard {
173     using SafeMath for uint256;
174     using SafeERC20 for IERC20;
175 
176     // The token being sold
177     IERC20 private _token;
178 
179     // Address where funds are collected
180     address payable private _wallet;
181 
182     // How many token units a buyer gets per wei.
183     // The rate is the conversion between wei and the smallest and indivisible token unit.
184     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
185     // 1 wei will give you 1 unit, or 0.001 TOK.
186     uint256 private _rate;
187 
188     // Amount of wei raised
189     uint256 private _weiRaised;
190 
191     /**
192      * Event for token purchase logging
193      * @param purchaser who paid for the tokens
194      * @param beneficiary who got the tokens
195      * @param value weis paid for purchase
196      * @param amount amount of tokens purchased
197      */
198     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
199 
200     /**
201      * @param rate Number of token units a buyer gets per wei
202      * @dev The rate is the conversion between wei and the smallest and indivisible
203      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
204      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
205      * @param wallet Address where collected funds will be forwarded to
206      * @param token Address of the token being sold
207      */
208     constructor (uint256 rate, address payable wallet, IERC20 token) public {
209         require(rate > 0);
210         require(wallet != address(0));
211         require(address(token) != address(0));
212 
213         _rate = rate;
214         _wallet = wallet;
215         _token = token;
216     }
217 
218     /**
219      * @dev fallback function ***DO NOT OVERRIDE***
220      * Note that other contracts will transfer fund with a base gas stipend
221      * of 2300, which is not enough to call buyTokens. Consider calling
222      * buyTokens directly when purchasing tokens from a contract.
223      */
224     function () external payable {
225         buyTokens(msg.sender);
226     }
227 
228     /**
229      * @return the token being sold.
230      */
231     function token() public view returns (IERC20) {
232         return _token;
233     }
234 
235     /**
236      * @return the address where funds are collected.
237      */
238     function wallet() public view returns (address payable) {
239         return _wallet;
240     }
241 
242     /**
243      * @return the number of token units a buyer gets per wei.
244      */
245     function rate() public view returns (uint256) {
246         return _rate;
247     }
248 
249     /**
250      * @return the amount of wei raised.
251      */
252     function weiRaised() public view returns (uint256) {
253         return _weiRaised;
254     }
255 
256     /**
257      * @dev low level token purchase ***DO NOT OVERRIDE***
258      * This function has a non-reentrancy guard, so it shouldn't be called by
259      * another `nonReentrant` function.
260      * @param beneficiary Recipient of the token purchase
261      */
262     function buyTokens(address beneficiary) public nonReentrant payable {
263         uint256 weiAmount = msg.value;
264         _preValidatePurchase(beneficiary, weiAmount);
265 
266         // calculate token amount to be created
267         uint256 tokens = _getTokenAmount(weiAmount);
268 
269         // update state
270         _weiRaised = _weiRaised.add(weiAmount);
271 
272         _processPurchase(beneficiary, tokens);
273         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
274 
275         _updatePurchasingState(beneficiary, weiAmount);
276 
277         _forwardFunds();
278         _postValidatePurchase(beneficiary, weiAmount);
279     }
280 
281     /**
282      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
283      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
284      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
285      *     super._preValidatePurchase(beneficiary, weiAmount);
286      *     require(weiRaised().add(weiAmount) <= cap);
287      * @param beneficiary Address performing the token purchase
288      * @param weiAmount Value in wei involved in the purchase
289      */
290     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
291         require(beneficiary != address(0));
292         require(weiAmount != 0);
293     }
294 
295     /**
296      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
297      * conditions are not met.
298      * @param beneficiary Address performing the token purchase
299      * @param weiAmount Value in wei involved in the purchase
300      */
301     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
302         // solhint-disable-previous-line no-empty-blocks
303     }
304 
305     /**
306      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
307      * its tokens.
308      * @param beneficiary Address performing the token purchase
309      * @param tokenAmount Number of tokens to be emitted
310      */
311     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
312         _token.safeTransfer(beneficiary, tokenAmount);
313     }
314 
315     /**
316      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
317      * tokens.
318      * @param beneficiary Address receiving the tokens
319      * @param tokenAmount Number of tokens to be purchased
320      */
321     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
322         _deliverTokens(beneficiary, tokenAmount);
323     }
324 
325     /**
326      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
327      * etc.)
328      * @param beneficiary Address receiving the tokens
329      * @param weiAmount Value in wei involved in the purchase
330      */
331     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
332         // solhint-disable-previous-line no-empty-blocks
333     }
334 
335     /**
336      * @dev Override to extend the way in which ether is converted to tokens.
337      * @param weiAmount Value in wei to be converted into tokens
338      * @return Number of tokens that can be purchased with the specified _weiAmount
339      */
340     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
341         return weiAmount.mul(_rate);
342     }
343 
344     /**
345      * @dev Determines how ETH is stored/forwarded on purchases.
346      */
347     function _forwardFunds() internal {
348         _wallet.transfer(msg.value);
349     }
350 }