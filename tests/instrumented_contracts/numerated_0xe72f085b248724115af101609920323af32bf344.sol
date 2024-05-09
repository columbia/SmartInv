1 pragma solidity ^0.5.7;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35     address private _owner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     /**
40      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41      * account.
42      */
43     constructor () internal {
44         _owner = msg.sender;
45         emit OwnershipTransferred(address(0), _owner);
46     }
47 
48     /**
49      * @return the address of the owner.
50      */
51     function owner() public view returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(isOwner());
60         _;
61     }
62 
63     /**
64      * @return true if `msg.sender` is the owner of the contract.
65      */
66     function isOwner() public view returns (bool) {
67         return msg.sender == _owner;
68     }
69 
70     /**
71      * @dev Allows the current owner to relinquish control of the contract.
72      * It will not be possible to call the functions with the `onlyOwner`
73      * modifier anymore.
74      * @notice Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     /**
83      * @dev Allows the current owner to transfer control of the contract to a newOwner.
84      * @param newOwner The address to transfer ownership to.
85      */
86     function transferOwnership(address newOwner) public onlyOwner {
87         _transferOwnership(newOwner);
88     }
89 
90     /**
91      * @dev Transfers control of the contract to a newOwner.
92      * @param newOwner The address to transfer ownership to.
93      */
94     function _transferOwnership(address newOwner) internal {
95         require(newOwner != address(0));
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 // File: eth-token-recover/contracts/TokenRecover.sol
102 
103 /**
104  * @title TokenRecover
105  * @author Vittorio Minacori (https://github.com/vittominacori)
106  * @dev Allow to recover any ERC20 sent into the contract for error
107  */
108 contract TokenRecover is Ownable {
109 
110     /**
111      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
112      * @param tokenAddress The token contract address
113      * @param tokenAmount Number of tokens to be sent
114      */
115     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
116         IERC20(tokenAddress).transfer(owner(), tokenAmount);
117     }
118 }
119 
120 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
121 
122 /**
123  * @title SafeMath
124  * @dev Unsigned math operations with safety checks that revert on error
125  */
126 library SafeMath {
127     /**
128      * @dev Multiplies two unsigned integers, reverts on overflow.
129      */
130     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
132         // benefit is lost if 'b' is also tested.
133         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
134         if (a == 0) {
135             return 0;
136         }
137 
138         uint256 c = a * b;
139         require(c / a == b);
140 
141         return c;
142     }
143 
144     /**
145      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
146      */
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         // Solidity only automatically asserts when dividing by 0
149         require(b > 0);
150         uint256 c = a / b;
151         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152 
153         return c;
154     }
155 
156     /**
157      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         require(b <= a);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Adds two unsigned integers, reverts on overflow.
168      */
169     function add(uint256 a, uint256 b) internal pure returns (uint256) {
170         uint256 c = a + b;
171         require(c >= a);
172 
173         return c;
174     }
175 
176     /**
177      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
178      * reverts when dividing by zero.
179      */
180     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
181         require(b != 0);
182         return a % b;
183     }
184 }
185 
186 // File: openzeppelin-solidity/contracts/utils/Address.sol
187 
188 /**
189  * Utility library of inline functions on addresses
190  */
191 library Address {
192     /**
193      * Returns whether the target address is a contract
194      * @dev This function will return false if invoked during the constructor of a contract,
195      * as the code is not actually created until after the constructor finishes.
196      * @param account address of the account to check
197      * @return whether the target address is a contract
198      */
199     function isContract(address account) internal view returns (bool) {
200         uint256 size;
201         // XXX Currently there is no better way to check if there is a contract in an address
202         // than to check the size of the code at that address.
203         // See https://ethereum.stackexchange.com/a/14016/36603
204         // for more details about how this works.
205         // TODO Check this again before the Serenity release, because all addresses will be
206         // contracts then.
207         // solhint-disable-next-line no-inline-assembly
208         assembly { size := extcodesize(account) }
209         return size > 0;
210     }
211 }
212 
213 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
214 
215 /**
216  * @title SafeERC20
217  * @dev Wrappers around ERC20 operations that throw on failure (when the token
218  * contract returns false). Tokens that return no value (and instead revert or
219  * throw on failure) are also supported, non-reverting calls are assumed to be
220  * successful.
221  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
222  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
223  */
224 library SafeERC20 {
225     using SafeMath for uint256;
226     using Address for address;
227 
228     function safeTransfer(IERC20 token, address to, uint256 value) internal {
229         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
230     }
231 
232     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
233         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
234     }
235 
236     function safeApprove(IERC20 token, address spender, uint256 value) internal {
237         // safeApprove should only be called when setting an initial allowance,
238         // or when resetting it to zero. To increase and decrease it, use
239         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
240         require((value == 0) || (token.allowance(address(this), spender) == 0));
241         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
242     }
243 
244     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
245         uint256 newAllowance = token.allowance(address(this), spender).add(value);
246         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
247     }
248 
249     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
250         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
251         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
252     }
253 
254     /**
255      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
256      * on the return value: the return value is optional (but if data is returned, it must equal true).
257      * @param token The token targeted by the call.
258      * @param data The call data (encoded using abi.encode or one of its variants).
259      */
260     function callOptionalReturn(IERC20 token, bytes memory data) private {
261         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
262         // we're implementing it ourselves.
263 
264         // A Solidity high level call has three parts:
265         //  1. The target address is checked to verify it contains contract code
266         //  2. The call itself is made, and success asserted
267         //  3. The return value is decoded, which in turn checks the size of the returned data.
268 
269         require(address(token).isContract());
270 
271         // solhint-disable-next-line avoid-low-level-calls
272         (bool success, bytes memory returndata) = address(token).call(data);
273         require(success);
274 
275         if (returndata.length > 0) { // Return data is optional
276             require(abi.decode(returndata, (bool)));
277         }
278     }
279 }
280 
281 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
282 
283 /**
284  * @title TokenTimelock
285  * @dev TokenTimelock is a token holder contract that will allow a
286  * beneficiary to extract the tokens after a given release time
287  */
288 contract TokenTimelock {
289     using SafeERC20 for IERC20;
290 
291     // ERC20 basic token contract being held
292     IERC20 private _token;
293 
294     // beneficiary of tokens after they are released
295     address private _beneficiary;
296 
297     // timestamp when token release is enabled
298     uint256 private _releaseTime;
299 
300     constructor (IERC20 token, address beneficiary, uint256 releaseTime) public {
301         // solhint-disable-next-line not-rely-on-time
302         require(releaseTime > block.timestamp);
303         _token = token;
304         _beneficiary = beneficiary;
305         _releaseTime = releaseTime;
306     }
307 
308     /**
309      * @return the token being held.
310      */
311     function token() public view returns (IERC20) {
312         return _token;
313     }
314 
315     /**
316      * @return the beneficiary of the tokens.
317      */
318     function beneficiary() public view returns (address) {
319         return _beneficiary;
320     }
321 
322     /**
323      * @return the time when the tokens are released.
324      */
325     function releaseTime() public view returns (uint256) {
326         return _releaseTime;
327     }
328 
329     /**
330      * @notice Transfers tokens held by timelock to beneficiary.
331      */
332     function release() public {
333         // solhint-disable-next-line not-rely-on-time
334         require(block.timestamp >= _releaseTime);
335 
336         uint256 amount = _token.balanceOf(address(this));
337         require(amount > 0);
338 
339         _token.safeTransfer(_beneficiary, amount);
340     }
341 }
342 
343 // File: contracts/MBMTimelock.sol
344 
345 /**
346  * @title MBMTimelock
347  * @dev Extends from TokenTimelock which is a token holder contract that will allow a
348  *  beneficiary to extract the tokens after a given release time
349  */
350 contract MBMTimelock is TokenTimelock {
351 
352     // A text string to add a note
353     string private _note;
354 
355     /**
356      * @param token Address of the token being distributed
357      * @param beneficiary Who will receive the tokens after they are released
358      * @param releaseTime Timestamp when token release is enabled
359      * @param note A text string to add a note
360      */
361     constructor(
362         IERC20 token,
363         address beneficiary,
364         uint256 releaseTime,
365         string memory note
366     )
367         public
368         TokenTimelock(token, beneficiary, releaseTime)
369     {
370         _note = note;
371     }
372 
373     /**
374      * @return the timelock note.
375      */
376     function note() public view returns (string memory) {
377         return _note;
378     }
379 }
380 
381 // File: contracts/MBMLockBuilder.sol
382 
383 /**
384  * @title MBMLockBuilder
385  * @dev This contract will allow a owner to create new MBMTimelock
386  */
387 contract MBMLockBuilder is TokenRecover {
388     using SafeERC20 for IERC20;
389 
390     event LockCreated(address indexed timelock, address indexed beneficiary, uint256 releaseTime, uint256 amount);
391 
392     // ERC20 basic token contract being held
393     IERC20 private _token;
394 
395     /**
396      * @param token Address of the token being distributed
397      */
398     constructor(IERC20 token) public {
399         require(address(token) != address(0));
400 
401         _token = token;
402     }
403 
404     /**
405      * @param beneficiary Who will receive the tokens after they are released
406      * @param releaseTime Timestamp when token release is enabled
407      * @param amount The number of tokens to be locked for this contract
408      * @param note A text string to add a note
409      */
410     function createLock(
411         address beneficiary,
412         uint256 releaseTime,
413         uint256 amount,
414         string calldata note
415     )
416         external
417         onlyOwner
418     {
419         MBMTimelock lock = new MBMTimelock(_token, beneficiary, releaseTime, note);
420 
421         emit LockCreated(address(lock), beneficiary, releaseTime, amount);
422 
423         if (amount > 0) {
424             _token.safeTransfer(address(lock), amount);
425         }
426     }
427 
428     /**
429      * @return the token being held.
430      */
431     function token() public view returns (IERC20) {
432         return _token;
433     }
434 }