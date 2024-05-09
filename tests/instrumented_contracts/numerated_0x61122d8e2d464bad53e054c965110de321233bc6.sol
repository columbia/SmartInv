1 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  *
17  * TIP: If you would like to learn more about reentrancy and alternative ways
18  * to protect against it, check out our blog post
19  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
20  *
21  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
22  * metering changes introduced in the Istanbul hardfork.
23  */
24 contract ReentrancyGuard {
25     bool private _notEntered;
26 
27     constructor () internal {
28         // Storing an initial non-zero value makes deployment a bit more
29         // expensive, but in exchange the refund on every call to nonReentrant
30         // will be lower in amount. Since refunds are capped to a percetange of
31         // the total transaction's gas, it is best to keep them low in cases
32         // like this one, to increase the likelihood of the full refund coming
33         // into effect.
34         _notEntered = true;
35     }
36 
37     /**
38      * @dev Prevents a contract from calling itself, directly or indirectly.
39      * Calling a `nonReentrant` function from another `nonReentrant`
40      * function is not supported. It is possible to prevent this from happening
41      * by making the `nonReentrant` function external, and make it call a
42      * `private` function that does the actual work.
43      */
44     modifier nonReentrant() {
45         // On the first call to nonReentrant, _notEntered will be true
46         require(_notEntered, "ReentrancyGuard: reentrant call");
47 
48         // Any calls to nonReentrant after this point will fail
49         _notEntered = false;
50 
51         _;
52 
53         // By storing the original value once again, a refund is triggered (see
54         // https://eips.ethereum.org/EIPS/eip-2200)
55         _notEntered = true;
56     }
57 }
58 
59 // File: @openzeppelin/contracts/GSN/Context.sol
60 
61 pragma solidity ^0.5.0;
62 
63 /*
64  * @dev Provides information about the current execution context, including the
65  * sender of the transaction and its data. While these are generally available
66  * via msg.sender and msg.data, they should not be accessed in such a direct
67  * manner, since when dealing with GSN meta-transactions the account sending and
68  * paying for execution may not be the actual sender (as far as an application
69  * is concerned).
70  *
71  * This contract is only required for intermediate, library-like contracts.
72  */
73 contract Context {
74     // Empty internal constructor, to prevent people from mistakenly deploying
75     // an instance of this contract, which should be used via inheritance.
76     constructor () internal { }
77     // solhint-disable-previous-line no-empty-blocks
78 
79     function _msgSender() internal view returns (address payable) {
80         return msg.sender;
81     }
82 
83     function _msgData() internal view returns (bytes memory) {
84         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
85         return msg.data;
86     }
87 }
88 
89 // File: @openzeppelin/contracts/ownership/Ownable.sol
90 
91 pragma solidity ^0.5.0;
92 
93 /**
94  * @dev Contract module which provides a basic access control mechanism, where
95  * there is an account (an owner) that can be granted exclusive access to
96  * specific functions.
97  *
98  * This module is used through inheritance. It will make available the modifier
99  * `onlyOwner`, which can be applied to your functions to restrict their use to
100  * the owner.
101  */
102 contract Ownable is Context {
103     address private _owner;
104 
105     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 
107     /**
108      * @dev Initializes the contract setting the deployer as the initial owner.
109      */
110     constructor () internal {
111         address msgSender = _msgSender();
112         _owner = msgSender;
113         emit OwnershipTransferred(address(0), msgSender);
114     }
115 
116     /**
117      * @dev Returns the address of the current owner.
118      */
119     function owner() public view returns (address) {
120         return _owner;
121     }
122 
123     /**
124      * @dev Throws if called by any account other than the owner.
125      */
126     modifier onlyOwner() {
127         require(isOwner(), "Ownable: caller is not the owner");
128         _;
129     }
130 
131     /**
132      * @dev Returns true if the caller is the current owner.
133      */
134     function isOwner() public view returns (bool) {
135         return _msgSender() == _owner;
136     }
137 
138     /**
139      * @dev Leaves the contract without owner. It will not be possible to call
140      * `onlyOwner` functions anymore. Can only be called by the current owner.
141      *
142      * NOTE: Renouncing ownership will leave the contract without an owner,
143      * thereby removing any functionality that is only available to the owner.
144      */
145     function renounceOwnership() public onlyOwner {
146         emit OwnershipTransferred(_owner, address(0));
147         _owner = address(0);
148     }
149 
150     /**
151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
152      * Can only be called by the current owner.
153      */
154     function transferOwnership(address newOwner) public onlyOwner {
155         _transferOwnership(newOwner);
156     }
157 
158     /**
159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
160      */
161     function _transferOwnership(address newOwner) internal {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         emit OwnershipTransferred(_owner, newOwner);
164         _owner = newOwner;
165     }
166 }
167 
168 // File: @openzeppelin/contracts/math/SafeMath.sol
169 
170 pragma solidity ^0.5.0;
171 
172 /**
173  * @dev Wrappers over Solidity's arithmetic operations with added overflow
174  * checks.
175  *
176  * Arithmetic operations in Solidity wrap on overflow. This can easily result
177  * in bugs, because programmers usually assume that an overflow raises an
178  * error, which is the standard behavior in high level programming languages.
179  * `SafeMath` restores this intuition by reverting the transaction when an
180  * operation overflows.
181  *
182  * Using this library instead of the unchecked operations eliminates an entire
183  * class of bugs, so it's recommended to use it always.
184  */
185 library SafeMath {
186     /**
187      * @dev Returns the addition of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `+` operator.
191      *
192      * Requirements:
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
209      * - Subtraction cannot overflow.
210      */
211     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
212         return sub(a, b, "SafeMath: subtraction overflow");
213     }
214 
215     /**
216      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
217      * overflow (when the result is negative).
218      *
219      * Counterpart to Solidity's `-` operator.
220      *
221      * Requirements:
222      * - Subtraction cannot overflow.
223      *
224      * _Available since v2.4.0._
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
240      * - Multiplication cannot overflow.
241      */
242     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
243         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
244         // benefit is lost if 'b' is also tested.
245         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
246         if (a == 0) {
247             return 0;
248         }
249 
250         uint256 c = a * b;
251         require(c / a == b, "SafeMath: multiplication overflow");
252 
253         return c;
254     }
255 
256     /**
257      * @dev Returns the integer division of two unsigned integers. Reverts on
258      * division by zero. The result is rounded towards zero.
259      *
260      * Counterpart to Solidity's `/` operator. Note: this function uses a
261      * `revert` opcode (which leaves remaining gas untouched) while Solidity
262      * uses an invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      * - The divisor cannot be zero.
266      */
267     function div(uint256 a, uint256 b) internal pure returns (uint256) {
268         return div(a, b, "SafeMath: division by zero");
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      * - The divisor cannot be zero.
281      *
282      * _Available since v2.4.0._
283      */
284     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
285         // Solidity only automatically asserts when dividing by 0
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
302      * - The divisor cannot be zero.
303      */
304     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
305         return mod(a, b, "SafeMath: modulo by zero");
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * Reverts with custom message when dividing by zero.
311      *
312      * Counterpart to Solidity's `%` operator. This function uses a `revert`
313      * opcode (which leaves remaining gas untouched) while Solidity uses an
314      * invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      * - The divisor cannot be zero.
318      *
319      * _Available since v2.4.0._
320      */
321     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
322         require(b != 0, errorMessage);
323         return a % b;
324     }
325 }
326 
327 // File: contracts/payment/BuyItemV2.sol
328 
329 pragma solidity 0.5.15;
330 
331 
332 
333 
334 contract BuyItemV2 is ReentrancyGuard, Ownable {
335   using SafeMath for uint256;
336 
337   event EventBuyItem(address _to, uint256 _value);
338   event EventWithdraw(address _to, uint256 _value);
339 
340 
341   function () external payable {
342     require (address(msg.sender) != address(0) && address(msg.sender) != address(this), 'wrong address');
343     emit EventBuyItem(msg.sender, msg.value);
344   }
345 
346 
347   // withdraw
348   function withdraw (uint256 _amount, address payable _account)
349     public onlyOwner {
350     require (
351       address(_account) != address(0) &&
352       address(_account) != address(this), 'wrong address');
353     require(_amount <= address(this).balance, 'wrong price');
354 
355     _account.transfer(_amount);
356     emit EventWithdraw(_account, _amount);
357   }
358 }