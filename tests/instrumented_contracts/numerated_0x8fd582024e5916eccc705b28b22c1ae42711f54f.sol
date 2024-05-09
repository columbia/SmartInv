1 pragma solidity 0.6.12;// SPDX-License-Identifier: MIT
2 
3 
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () internal {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 
92 
93 
94 /**
95  * @dev Interface of the ERC20 standard as defined in the EIP.
96  */
97 interface IERC20 {
98     /**
99      * @dev Returns the amount of tokens in existence.
100      */
101     function totalSupply() external view returns (uint256);
102 
103     /**
104      * @dev Returns the amount of tokens owned by `account`.
105      */
106     function balanceOf(address account) external view returns (uint256);
107 
108     /**
109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transfer(address recipient, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Returns the remaining number of tokens that `spender` will be
119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
120      * zero by default.
121      *
122      * This value changes when {approve} or {transferFrom} are called.
123      */
124     function allowance(address owner, address spender) external view returns (uint256);
125 
126     /**
127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
132      * that someone may use both the old and the new allowance by unfortunate
133      * transaction ordering. One possible solution to mitigate this race
134      * condition is to first reduce the spender's allowance to 0 and set the
135      * desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address spender, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
144      * allowance mechanism. `amount` is then deducted from the caller's
145      * allowance.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Emitted when `value` tokens are moved from one account (`from`) to
155      * another (`to`).
156      *
157      * Note that `value` may be zero.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 value);
160 
161     /**
162      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
163      * a call to {approve}. `value` is the new allowance.
164      */
165     event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 
169 
170 
171 /**
172  * @dev Wrappers over Solidity's arithmetic operations with added overflow
173  * checks.
174  *
175  * Arithmetic operations in Solidity wrap on overflow. This can easily result
176  * in bugs, because programmers usually assume that an overflow raises an
177  * error, which is the standard behavior in high level programming languages.
178  * `SafeMath` restores this intuition by reverting the transaction when an
179  * operation overflows.
180  *
181  * Using this library instead of the unchecked operations eliminates an entire
182  * class of bugs, so it's recommended to use it always.
183  */
184 library SafeMath {
185     /**
186      * @dev Returns the addition of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `+` operator.
190      *
191      * Requirements:
192      *
193      * - Addition cannot overflow.
194      */
195     function add(uint256 a, uint256 b) internal pure returns (uint256) {
196         uint256 c = a + b;
197         require(c >= a, "SafeMath: addition overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the subtraction of two unsigned integers, reverting on
204      * overflow (when the result is negative).
205      *
206      * Counterpart to Solidity's `-` operator.
207      *
208      * Requirements:
209      *
210      * - Subtraction cannot overflow.
211      */
212     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
213         return sub(a, b, "SafeMath: subtraction overflow");
214     }
215 
216     /**
217      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
218      * overflow (when the result is negative).
219      *
220      * Counterpart to Solidity's `-` operator.
221      *
222      * Requirements:
223      *
224      * - Subtraction cannot overflow.
225      */
226     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b <= a, errorMessage);
228         uint256 c = a - b;
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the multiplication of two unsigned integers, reverting on
235      * overflow.
236      *
237      * Counterpart to Solidity's `*` operator.
238      *
239      * Requirements:
240      *
241      * - Multiplication cannot overflow.
242      */
243     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
244         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
245         // benefit is lost if 'b' is also tested.
246         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
247         if (a == 0) {
248             return 0;
249         }
250 
251         uint256 c = a * b;
252         require(c / a == b, "SafeMath: multiplication overflow");
253 
254         return c;
255     }
256 
257     /**
258      * @dev Returns the integer division of two unsigned integers. Reverts on
259      * division by zero. The result is rounded towards zero.
260      *
261      * Counterpart to Solidity's `/` operator. Note: this function uses a
262      * `revert` opcode (which leaves remaining gas untouched) while Solidity
263      * uses an invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function div(uint256 a, uint256 b) internal pure returns (uint256) {
270         return div(a, b, "SafeMath: division by zero");
271     }
272 
273     /**
274      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
275      * division by zero. The result is rounded towards zero.
276      *
277      * Counterpart to Solidity's `/` operator. Note: this function uses a
278      * `revert` opcode (which leaves remaining gas untouched) while Solidity
279      * uses an invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b > 0, errorMessage);
287         uint256 c = a / b;
288         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
289 
290         return c;
291     }
292 
293     /**
294      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
295      * Reverts when dividing by zero.
296      *
297      * Counterpart to Solidity's `%` operator. This function uses a `revert`
298      * opcode (which leaves remaining gas untouched) while Solidity uses an
299      * invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      *
303      * - The divisor cannot be zero.
304      */
305     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
306         return mod(a, b, "SafeMath: modulo by zero");
307     }
308 
309     /**
310      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
311      * Reverts with custom message when dividing by zero.
312      *
313      * Counterpart to Solidity's `%` operator. This function uses a `revert`
314      * opcode (which leaves remaining gas untouched) while Solidity uses an
315      * invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      *
319      * - The divisor cannot be zero.
320      */
321     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
322         require(b != 0, errorMessage);
323         return a % b;
324     }
325 }
326 
327 
328 library PercentageCalculator {
329 	using SafeMath for uint256;
330 
331 	/*
332 	Note: Percentages will be provided in thousands to represent 3 digits after the decimal point.
333 	The division is made by 100000 
334 	*/ 
335 	function div(uint256 _amount, uint256 _percentage) public pure returns(uint256) {
336 		return _amount.mul(_percentage).div(100000);
337 	}
338 }
339 
340 
341 
342 
343 contract Vesting is Ownable {
344     uint256 public startDate;
345     uint256 internal constant periodLength = 30 days;
346     uint256[35] public cumulativeAmountsToVest;
347     uint256 public totalPercentages;
348     IERC20 internal token;
349 
350     struct Recipient {
351         uint256 withdrawnAmount;
352         uint256 withdrawPercentage;
353     }
354 
355     uint256 public totalRecipients;
356     mapping(address => Recipient) public recipients;
357 
358     event LogStartDateSet(address setter, uint256 startDate);
359     event LogRecipientAdded(address recipient, uint256 withdrawPercentage);
360     event LogTokensClaimed(address recipient, uint256 amount);
361 
362     /*
363      * Note: Percentages will be provided in thousands to represent 3 digits after the decimal point.
364      * Ex. 10% = 10000
365      */
366     modifier onlyValidPercentages(uint256 _percentage) {
367         require(
368             _percentage < 100000,
369             "Provided percentage should be less than 100%"
370         );
371         require(
372             _percentage > 0,
373             "Provided percentage should be greater than 0"
374         );
375         _;
376     }
377 
378     /**
379      * @param _tokenAddress The address of the ALBT token
380      * @param _cumulativeAmountsToVest The cumulative amounts for each vesting period
381      */
382     constructor(
383         address _tokenAddress,
384         uint256[35] memory _cumulativeAmountsToVest
385     ) public {
386         require(
387             _tokenAddress != address(0),
388             "Token Address can't be zero address"
389         );
390         token = IERC20(_tokenAddress);
391         cumulativeAmountsToVest = _cumulativeAmountsToVest;
392     }
393 
394     /**
395      * @dev Function that sets the start date of the Vesting
396      * @param _startDate The start date of the veseting presented as a timestamp
397      */
398     function setStartDate(uint256 _startDate) public onlyOwner {
399         require(_startDate >= now, "Start Date can't be in the past");
400 
401         startDate = _startDate;
402         emit LogStartDateSet(address(msg.sender), _startDate);
403     }
404 
405     /**
406      * @dev Function add recipient to the vesting contract
407      * @param _recipientAddress The address of the recipient
408      * @param _withdrawPercentage The percentage that the recipient should receive in each vesting period
409      */
410     function addRecipient(
411         address _recipientAddress,
412         uint256 _withdrawPercentage
413     ) public onlyOwner onlyValidPercentages(_withdrawPercentage) {
414         require(
415             _recipientAddress != address(0),
416             "Recepient Address can't be zero address"
417         );
418         totalPercentages = totalPercentages + _withdrawPercentage;
419         require(totalPercentages <= 100000, "Total percentages exceeds 100%");
420         totalRecipients++;
421 
422         recipients[_recipientAddress] = Recipient(0, _withdrawPercentage);
423         emit LogRecipientAdded(_recipientAddress, _withdrawPercentage);
424     }
425 
426     /**
427      * @dev Function add  multiple recipients to the vesting contract
428      * @param _recipients Array of recipient addresses. The arrya length should be less than 230, otherwise it will overflow the gas limit
429      * @param _withdrawPercentages Corresponding percentages of the recipients
430      */
431     function addMultipleRecipients(
432         address[] memory _recipients,
433         uint256[] memory _withdrawPercentages
434     ) public onlyOwner {
435         require(
436             _recipients.length < 230,
437             "The recipients must be not more than 230"
438         );
439         require(
440             _recipients.length == _withdrawPercentages.length,
441             "The two arryas are with different length"
442         );
443         for (uint256 i; i < _recipients.length; i++) {
444             addRecipient(_recipients[i], _withdrawPercentages[i]);
445         }
446     }
447 
448     /**
449      * @dev Function that withdraws all available tokens for the current period
450      */
451     function claim() public {
452         require(startDate != 0, "The vesting hasn't started");
453         require(now >= startDate, "The vesting hasn't started");
454 
455         (uint256 owedAmount, uint256 calculatedAmount) = calculateAmounts();
456         recipients[msg.sender].withdrawnAmount = calculatedAmount;
457         bool result = token.transfer(msg.sender, owedAmount);
458         require(result, "The claim was not successful");
459         emit LogTokensClaimed(msg.sender, owedAmount);
460     }
461 
462     /**
463      * @dev Function that returns the amount that the user can withdraw at the current period.
464      * @return _owedAmount The amount that the user can withdraw at the current period.
465      */
466     function hasClaim() public view returns (uint256 _owedAmount) {
467         if (now <= startDate) {
468             return 0;
469         }
470 
471         (uint256 owedAmount, uint256 _) = calculateAmounts();
472         return owedAmount;
473     }
474 
475     function calculateAmounts()
476         internal
477         view
478         returns (uint256 _owedAmount, uint256 _calculatedAmount)
479     {
480         uint256 period = (now - startDate) / (periodLength);
481         if (period >= cumulativeAmountsToVest.length) {
482             period = cumulativeAmountsToVest.length - 1;
483         }
484         uint256 calculatedAmount = PercentageCalculator.div(
485             cumulativeAmountsToVest[period],
486             recipients[msg.sender].withdrawPercentage
487         );
488         uint256 owedAmount = calculatedAmount -
489             recipients[msg.sender].withdrawnAmount;
490 
491         return (owedAmount, calculatedAmount);
492     }
493 }