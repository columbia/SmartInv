1 pragma solidity 0.4.24;
2 
3 /**
4  * @dev Collection of functions related to the address type,
5  */
6 library Address {
7     /**
8      * @dev Returns true if `account` is a contract.
9      *
10      * This test is non-exhaustive, and there may be false-negatives: during the
11      * execution of a contract's constructor, its address will be reported as
12      * not containing a contract.
13      *
14      * > It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      */
17     function isContract(address account) internal view returns (bool) {
18         // This method relies in extcodesize, which returns 0 for contracts in
19         // construction, since the code is only stored at the end of the
20         // constructor execution.
21 
22         uint256 size;
23         // solhint-disable-next-line no-inline-assembly
24         assembly { size := extcodesize(account) }
25         return size > 0;
26     }
27 }
28 
29 
30 /**
31  * @title ERC20Basic
32  * @dev Simpler version of ERC20 interface
33  * @dev see https://github.com/ethereum/EIPs/issues/179
34  */
35 contract ERC20Basic {
36   function totalSupply() public view returns (uint256);
37   function balanceOf(address who) public view returns (uint256);
38   function transfer(address to, uint256 value) public returns (bool);
39   event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 /**
43  * @title Basic token
44  * @dev Basic version of StandardToken, with no allowances.
45  */
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   uint256 totalSupply_;
52 
53   /**
54   * @dev total number of tokens in existence
55   */
56   function totalSupply() public view returns (uint256) {
57     return totalSupply_;
58   }
59 
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67     require(_value <= balances[msg.sender]);
68 
69     // SafeMath.sub will throw if there is not enough balance.
70     balances[msg.sender] = balances[msg.sender].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     Transfer(msg.sender, _to, _value);
73     return true;
74   }
75 
76   /**
77   * @dev Gets the balance of the specified address.
78   * @param _owner The address to query the the balance of.
79   * @return An uint256 representing the amount owned by the passed address.
80   */
81   function balanceOf(address _owner) public view returns (uint256 balance) {
82     return balances[_owner];
83   }
84 
85 }
86 
87 
88 /**
89  * @title SafeERC20
90  * @dev Wrappers around ERC20 operations that throw on failure (when the token
91  * contract returns false). Tokens that return no value (and instead revert or
92  * throw on failure) are also supported, non-reverting calls are assumed to be
93  * successful.
94  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
95  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
96  */
97 library SafeERC20 {
98     using SafeMath for uint256;
99     using Address for address;
100 
101     function safeTransfer(IERC20 token, address to, uint256 value) internal {
102         callOptionalReturn(token, abi.encodeWithSelector(bytes4(0xa9059cbb), to, value));
103     }
104 
105     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
106         callOptionalReturn(token, abi.encodeWithSelector(bytes4(0x23b872dd), from, to, value));
107     }
108 
109     function safeApprove(IERC20 token, address spender, uint256 value) internal {
110         // safeApprove should only be called when setting an initial allowance,
111         // or when resetting it to zero. To increase and decrease it, use
112         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
113         // solhint-disable-next-line max-line-length
114         require((value == 0) || (token.allowance(address(this), spender) == 0),
115             "SafeERC20: approve from non-zero to non-zero allowance"
116         );
117         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
118     }
119 
120     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
121         uint256 newAllowance = token.allowance(address(this), spender).add(value);
122         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
123     }
124 
125     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
126         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
127         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
128     }
129 
130     /**
131      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
132      * on the return value: the return value is optional (but if data is returned, it must not be false).
133      * @param token The token targeted by the call.
134      * @param data The call data (encoded using abi.encode or one of its variants).
135      */
136     function callOptionalReturn(IERC20 token, bytes memory data) private {
137         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
138         // we're implementing it ourselves.
139 
140         // A Solidity high level call has three parts:
141         //  1. The target address is checked to verify it contains contract code
142         //  2. The call itself is made, and success asserted
143         //  3. The return value is decoded, which in turn checks the size of the returned data.
144         // solhint-disable-next-line max-line-length
145         require(address(token).isContract(), "SafeERC20: call to non-contract");
146 
147         // call returns only success in 0.4.24
148         // solhint-disable-next-line avoid-low-level-calls
149         bool success = address(token).call(data);
150         require(success, "SafeERC20: low-level call failed");
151     }
152 }
153 
154 /**
155  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
156  * the optional functions; to access them see `ERC20Detailed`.
157  */
158 interface IERC20 {
159     /**
160      * @dev Returns the amount of tokens in existence.
161      */
162     function totalSupply() external view returns (uint256);
163 
164     /**
165      * @dev Returns the amount of tokens owned by `account`.
166      */
167     function balanceOf(address account) external view returns (uint256);
168 
169     /**
170      * @dev Moves `amount` tokens from the caller's account to `recipient`.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * Emits a `Transfer` event.
175      */
176     function transfer(address recipient, uint256 amount) external returns (bool);
177 
178     /**
179      * @dev Returns the remaining number of tokens that `spender` will be
180      * allowed to spend on behalf of `owner` through `transferFrom`. This is
181      * zero by default.
182      *
183      * This value changes when `approve` or `transferFrom` are called.
184      */
185     function allowance(address owner, address spender) external view returns (uint256);
186 
187     /**
188      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * > Beware that changing an allowance with this method brings the risk
193      * that someone may use both the old and the new allowance by unfortunate
194      * transaction ordering. One possible solution to mitigate this race
195      * condition is to first reduce the spender's allowance to 0 and set the
196      * desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      *
199      * Emits an `Approval` event.
200      */
201     function approve(address spender, uint256 amount) external returns (bool);
202 
203     /**
204      * @dev Moves `amount` tokens from `sender` to `recipient` using the
205      * allowance mechanism. `amount` is then deducted from the caller's
206      * allowance.
207      *
208      * Returns a boolean value indicating whether the operation succeeded.
209      *
210      * Emits a `Transfer` event.
211      */
212     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
213 
214     /**
215      * @dev Emitted when `value` tokens are moved from one account (`from`) to
216      * another (`to`).
217      *
218      * Note that `value` may be zero.
219      */
220     event Transfer(address indexed from, address indexed to, uint256 value);
221 
222     /**
223      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
224      * a call to `approve`. `value` is the new allowance.
225      */
226     event Approval(address indexed owner, address indexed spender, uint256 value);
227 }
228 
229 
230 /**
231  * @title SafeMath
232  * @dev Math operations with safety checks that throw on error
233  */
234 library SafeMath {
235 
236   /**
237   * @dev Multiplies two numbers, throws on overflow.
238   */
239   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
240     if (a == 0) {
241       return 0;
242     }
243     uint256 c = a * b;
244     assert(c / a == b);
245     return c;
246   }
247 
248   /**
249   * @dev Integer division of two numbers, truncating the quotient.
250   */
251   function div(uint256 a, uint256 b) internal pure returns (uint256) {
252     // assert(b > 0); // Solidity automatically throws when dividing by 0
253     uint256 c = a / b;
254     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
255     return c;
256   }
257 
258   /**
259   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
260   */
261   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
262     assert(b <= a);
263     return a - b;
264   }
265 
266   /**
267   * @dev Adds two numbers, throws on overflow.
268   */
269   function add(uint256 a, uint256 b) internal pure returns (uint256) {
270     uint256 c = a + b;
271     assert(c >= a);
272     return c;
273   }
274 }
275 
276 /**
277  * @title Ownable
278  * @dev The Ownable contract has an owner address, and provides basic authorization control
279  * functions, this simplifies the implementation of "user permissions".
280  */
281 contract Ownable {
282   address public owner;
283 
284 
285   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287 
288   /**
289    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
290    * account.
291    */
292   function Ownable() public {
293     owner = msg.sender;
294   }
295 
296   /**
297    * @dev Throws if called by any account other than the owner.
298    */
299   modifier onlyOwner() {
300     require(msg.sender == owner);
301     _;
302   }
303 
304   /**
305    * @dev Allows the current owner to transfer control of the contract to a newOwner.
306    * @param newOwner The address to transfer ownership to.
307    */
308   function transferOwnership(address newOwner) public onlyOwner {
309     require(newOwner != address(0));
310     OwnershipTransferred(owner, newOwner);
311     owner = newOwner;
312   }
313 
314 }
315 
316 
317 /*
318 
319   Copyright Ethfinex Inc 2018
320 
321   Licensed under the Apache License, Version 2.0
322   http://www.apache.org/licenses/LICENSE-2.0
323 
324 */
325 
326 contract WrapperLockEth is BasicToken, Ownable {
327     using SafeERC20 for IERC20;
328     using SafeMath for uint256;
329 
330     address public TRANSFER_PROXY_VEFX = 0xdcDb42C9a256690bd153A7B409751ADFC8Dd5851;
331     address public TRANSFER_PROXY_V2 = 0x95e6f48254609a6ee006f7d493c8e5fb97094cef;
332     mapping (address => bool) public isSigner;
333 
334     string public name;
335     string public symbol;
336     uint public decimals;
337     address public originalToken = 0x00;
338 
339     mapping (address => uint) public depositLock;
340     mapping (address => uint256) public balances;
341 
342     constructor(string _name, string _symbol, uint _decimals ) Ownable() {
343         name = _name;
344         symbol = _symbol;
345         decimals = _decimals;
346         isSigner[msg.sender] = true;
347     }
348 
349     // @dev method only for testing, needs to be commented out when deploying
350     // function addProxy(address _addr) public {
351     //     TRANSFER_PROXY_VEFX = _addr;
352     // }
353 
354     function deposit(uint _value, uint _forTime) public payable returns (bool success) {
355         require(_forTime >= 1);
356         require(now + _forTime * 1 hours >= depositLock[msg.sender]);
357         balances[msg.sender] = balances[msg.sender].add(msg.value);
358         totalSupply_ = totalSupply_.add(msg.value);
359         depositLock[msg.sender] = now + _forTime * 1 hours;
360         return true;
361     }
362 
363     function withdraw(
364         uint _value,
365         uint8 v,
366         bytes32 r,
367         bytes32 s,
368         uint signatureValidUntilBlock
369     )
370         public
371         returns
372         (bool)
373     {
374         require(balanceOf(msg.sender) >= _value);
375         if (now > depositLock[msg.sender]) {
376             balances[msg.sender] = balances[msg.sender].sub(_value);
377             totalSupply_ = totalSupply_.sub(_value);
378             msg.sender.transfer(_value);
379         } else {
380             require(block.number < signatureValidUntilBlock);
381             require(isValidSignature(keccak256(msg.sender, address(this), signatureValidUntilBlock), v, r, s));
382             balances[msg.sender] = balances[msg.sender].sub(_value);
383             totalSupply_ = totalSupply_.sub(_value);
384             depositLock[msg.sender] = 0;
385             msg.sender.transfer(_value);
386         }
387         return true;
388     }
389 
390     function withdrawDifferentToken(address _differentToken) public onlyOwner returns (bool) {
391         require(_differentToken != originalToken);
392         require(IERC20(_differentToken).balanceOf(address(this)) > 0);
393         IERC20(_differentToken).safeTransfer(msg.sender, IERC20(_differentToken).balanceOf(address(this)));
394         return true;
395     }
396 
397     function transfer(address _to, uint256 _value) public returns (bool) {
398         return false;
399     }
400 
401     function transferFrom(address _from, address _to, uint _value) public {
402         require(isSigner[_to] || isSigner[_from]);
403         assert(msg.sender == TRANSFER_PROXY_VEFX || msg.sender == TRANSFER_PROXY_V2);
404         balances[_to] = balances[_to].add(_value);
405         depositLock[_to] = depositLock[_to] > now ? depositLock[_to] : now + 1 hours;
406         balances[_from] = balances[_from].sub(_value);
407         Transfer(_from, _to, _value);
408     }
409 
410     function allowance(address _owner, address _spender) public constant returns (uint) {
411         if (_spender == TRANSFER_PROXY_VEFX || _spender == TRANSFER_PROXY_V2) {
412             return 2**256 - 1;
413         }
414     }
415 
416     function balanceOf(address _owner) public constant returns (uint256) {
417         return balances[_owner];
418     }
419 
420     function isValidSignature(
421         bytes32 hash,
422         uint8 v,
423         bytes32 r,
424         bytes32 s)
425         public
426         constant
427         returns (bool)
428     {
429         return isSigner[ecrecover(
430             keccak256("\x19Ethereum Signed Message:\n32", hash),
431             v,
432             r,
433             s
434         )];
435     }
436 
437     function addSigner(address _newSigner) public {
438         require(isSigner[msg.sender]);
439         isSigner[_newSigner] = true;
440     }
441 
442     function keccak(address _sender, address _wrapper, uint _validTill) public pure returns(bytes32) {
443         return keccak256(_sender, _wrapper, _validTill);
444     }
445 }