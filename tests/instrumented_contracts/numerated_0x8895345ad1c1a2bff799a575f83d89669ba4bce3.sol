1 pragma solidity ^0.5.0;
2 
3 contract Context {
4     // Empty internal constructor, to prevent people from mistakenly deploying
5     // an instance of this contract, which should be used via inheritance.
6     constructor () internal { }
7     // solhint-disable-previous-line no-empty-blocks
8 
9     function _msgSender() internal view returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     /**
25      * @dev Initializes the contract setting the deployer as the initial owner.
26      */
27     constructor () internal {
28         address msgSender = _msgSender();
29         _owner = msgSender;
30         emit OwnershipTransferred(address(0), msgSender);
31     }
32 
33     /**
34      * @dev Returns the address of the current owner.
35      */
36     function owner() public view returns (address) {
37         return _owner;
38     }
39 
40     /**
41      * @dev Throws if called by any account other than the owner.
42      */
43     modifier onlyOwner() {
44         require(isOwner(), "Ownable: caller is not the owner");
45         _;
46     }
47 
48     /**
49      * @dev Returns true if the caller is the current owner.
50      */
51     function isOwner() public view returns (bool) {
52         return _msgSender() == _owner;
53     }
54 
55     /**
56      * @dev Leaves the contract without owner. It will not be possible to call
57      * `onlyOwner` functions anymore. Can only be called by the current owner.
58      *
59      * NOTE: Renouncing ownership will leave the contract without an owner,
60      * thereby removing any functionality that is only available to the owner.
61      */
62     function renounceOwnership() public onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      * Can only be called by the current owner.
70      */
71     function transferOwnership(address newOwner) public onlyOwner {
72         _transferOwnership(newOwner);
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      */
78     function _transferOwnership(address newOwner) internal {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 }
84 
85 interface IERC20 {
86     /**
87      * @dev Returns the amount of tokens in existence.
88      */
89     function totalSupply() external view returns (uint256);
90 
91     /**
92      * @dev Returns the amount of tokens owned by `account`.
93      */
94     function balanceOf(address account) external view returns (uint256);
95 
96     /**
97      * @dev Moves `amount` tokens from the caller's account to `recipient`.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transfer(address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Returns the remaining number of tokens that `spender` will be
107      * allowed to spend on behalf of `owner` through {transferFrom}. This is
108      * zero by default.
109      *
110      * This value changes when {approve} or {transferFrom} are called.
111      */
112     function allowance(address owner, address spender) external view returns (uint256);
113 
114     /**
115      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * IMPORTANT: Beware that changing an allowance with this method brings the risk
120      * that someone may use both the old and the new allowance by unfortunate
121      * transaction ordering. One possible solution to mitigate this race
122      * condition is to first reduce the spender's allowance to 0 and set the
123      * desired value afterwards:
124      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address spender, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Moves `amount` tokens from `sender` to `recipient` using the
132      * allowance mechanism. `amount` is then deducted from the caller's
133      * allowance.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Emitted when `value` tokens are moved from one account (`from`) to
143      * another (`to`).
144      *
145      * Note that `value` may be zero.
146      */
147     event Transfer(address indexed from, address indexed to, uint256 value);
148 
149     /**
150      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
151      * a call to {approve}. `value` is the new allowance.
152      */
153     event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 library SafeMath {
157     /**
158      * @dev Returns the addition of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `+` operator.
162      *
163      * Requirements:
164      * - Addition cannot overflow.
165      */
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         require(c >= a, "SafeMath: addition overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      * - Subtraction cannot overflow.
181      */
182     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183         return sub(a, b, "SafeMath: subtraction overflow");
184     }
185 
186     /**
187      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
188      * overflow (when the result is negative).
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      * - Subtraction cannot overflow.
194      *
195      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
196      * @dev Get it via `npm install @openzeppelin/contracts@next`.
197      */
198     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b <= a, errorMessage);
200         uint256 c = a - b;
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the multiplication of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `*` operator.
210      *
211      * Requirements:
212      * - Multiplication cannot overflow.
213      */
214     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
215         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
216         // benefit is lost if 'b' is also tested.
217         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
218         if (a == 0) {
219             return 0;
220         }
221 
222         uint256 c = a * b;
223         require(c / a == b, "SafeMath: multiplication overflow");
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the integer division of two unsigned integers. Reverts on
230      * division by zero. The result is rounded towards zero.
231      *
232      * Counterpart to Solidity's `/` operator. Note: this function uses a
233      * `revert` opcode (which leaves remaining gas untouched) while Solidity
234      * uses an invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      * - The divisor cannot be zero.
238      */
239     function div(uint256 a, uint256 b) internal pure returns (uint256) {
240         return div(a, b, "SafeMath: division by zero");
241     }
242 
243     /**
244      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
245      * division by zero. The result is rounded towards zero.
246      *
247      * Counterpart to Solidity's `/` operator. Note: this function uses a
248      * `revert` opcode (which leaves remaining gas untouched) while Solidity
249      * uses an invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      * - The divisor cannot be zero.
253 
254      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
255      * @dev Get it via `npm install @openzeppelin/contracts@next`.
256      */
257     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         // Solidity only automatically asserts when dividing by 0
259         require(b > 0, errorMessage);
260         uint256 c = a / b;
261         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
262 
263         return c;
264     }
265 
266     /**
267      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
268      * Reverts when dividing by zero.
269      *
270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
271      * opcode (which leaves remaining gas untouched) while Solidity uses an
272      * invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      * - The divisor cannot be zero.
276      */
277     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
278         return mod(a, b, "SafeMath: modulo by zero");
279     }
280 
281     /**
282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
283      * Reverts with custom message when dividing by zero.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      * - The divisor cannot be zero.
291      *
292      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
293      * @dev Get it via `npm install @openzeppelin/contracts@next`.
294      */
295     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b != 0, errorMessage);
297         return a % b;
298     }
299 }
300 
301 contract Bridge is Ownable {
302 
303     using SafeMath for uint256;
304 
305     enum Stage { Deployed, Claim, Pause, Swap, Finished }
306 
307     Stage public currentStage;
308 
309     uint256 public minTransferAmount;
310     uint256 constant public border = 10**14;
311 
312     struct Transfer {
313         string accountName;
314         string accountOpenkey;
315         uint256 amount;
316     }
317 
318     mapping(address => Transfer) public claims;
319     mapping(address => Transfer[]) public swaps;
320     mapping(string => string) public nameToOpenkey;
321     address[] public claimParticipants;
322     address[] public swapParticipants;
323 
324     IERC20 public token;
325 
326     event NextStage(address _sender, Stage _currentStage, uint256 _timestamp);
327     event Swap(address _from, string accountName, string accountOpenkey, uint256 amount, uint256 timestamp);
328     event Claim(address _from, string accountName, string accountOpenkey, uint256 amount, uint256 timestamp);
329 
330     /// @dev modifier that allow to call function if current stage is bigger than specified
331     modifier stageAfter(Stage _stage) {
332         require(uint256(currentStage) > uint256(_stage));
333         _;
334     }
335 
336     /// @dev modifier that allow to call function if current stage is less than specified
337     modifier stageBefore(Stage _stage) {
338         require(uint256(currentStage) < uint256(_stage));
339         _;
340     }
341 
342     constructor(IERC20 _token, uint256 _minTransferAmount) public {
343         require(_minTransferAmount >= border, 'invalid _minTransferAmount');
344         minTransferAmount = _minTransferAmount;
345         token = _token;
346         currentStage = Stage.Deployed;
347     }
348 
349     /// @dev function that call specified convert strategy to convert tokens
350     function convert(string memory _accountName, string memory _accountOpenkey, uint256 _amount)
351     stageAfter(Stage.Deployed)
352     stageBefore(Stage.Finished)
353     public {
354 
355         require(currentStage != Stage.Pause, "You can't convert tokens during a pause");        
356         // openkey and account name validation check 
357         require(isValidAccountName(_accountName), "invalid account name");
358         require(isValidOpenkey(_accountOpenkey), "invalid openkey");
359         // can not convert less that minimum amount
360         require(_amount >= minTransferAmount, "too few tokens");
361 
362         string memory openkey = nameToOpenkey[_accountName];
363         
364         require(
365                 keccak256(abi.encodePacked(openkey)) == keccak256(abi.encodePacked(_accountOpenkey)) || 
366                 bytes(openkey).length == 0,
367                 "account already exist with another openkey"
368             );
369     
370         // round tokens amount to 4 decimals
371         uint256 intValue = _amount.div(border);
372         uint256 roundedValue = intValue.mul(border);
373         
374         // transfer tokens
375         require(token.transferFrom(msg.sender, address(this), roundedValue), "transferFrom failed");
376 
377         if (currentStage == Stage.Claim) {
378             
379             string memory registeredAccountName = claims[msg.sender].accountName;
380             require(
381                 keccak256(abi.encodePacked(registeredAccountName)) == keccak256(abi.encodePacked(_accountName)) || 
382                 bytes(registeredAccountName).length == 0,
383                 "you have already registered an account"
384             );
385 
386             // Claim stage            
387             addNewClaimParticipant(msg.sender);
388             uint256 previousAmount = claims[msg.sender].amount;
389             claims[msg.sender] = Transfer(_accountName, _accountOpenkey, roundedValue.add(previousAmount));
390             emit Claim(msg.sender, _accountName, _accountOpenkey, roundedValue, now);
391         
392         } else if(currentStage == Stage.Swap) {
393             // Swap stage
394             addNewSwapParticipant(msg.sender);
395             swaps[msg.sender].push(Transfer(_accountName, _accountOpenkey, roundedValue));
396             emit Swap(msg.sender, _accountName, _accountOpenkey, roundedValue, now);
397         }
398         
399         if(bytes(openkey).length == 0) {
400             nameToOpenkey[_accountName] = _accountOpenkey;
401         }
402     }
403 
404     function nextStage() onlyOwner stageBefore(Stage.Finished) public {
405         // move to next stage
406         uint256 next = uint256(currentStage) + 1;
407         currentStage = Stage(next);
408 
409         emit NextStage(msg.sender, currentStage, now);
410     }
411     
412     function setMinTransferAmount(uint256 _minTransferAmount) onlyOwner public {
413         require(_minTransferAmount >= border, 'invalid _minTransferAmount');
414         minTransferAmount = _minTransferAmount;
415     }
416 
417     function addNewClaimParticipant(address _addr) private {
418         if (claims[_addr].amount == uint256(0)) {
419             claimParticipants.push(_addr);
420         }
421     }
422 
423         
424     function addNewSwapParticipant(address _addr) private {
425         if (swaps[_addr].length == uint256(0)) {
426             swapParticipants.push(_addr);
427         }
428     }
429     
430     function isValidOpenkey(string memory str) public pure returns (bool) {
431         bytes memory b = bytes(str);
432         if(b.length != 53) return false;
433 
434         // EOS
435         if (bytes1(b[0]) != 0x45 || bytes1(b[1]) != 0x4F || bytes1(b[2]) != 0x53)
436             return false;
437 
438         for(uint i = 3; i<b.length; i++){
439             bytes1 char = b[i];
440 
441             // base58
442             if(!(char >= 0x31 && char <= 0x39) &&
443                !(char >= 0x41 && char <= 0x48) &&
444                !(char >= 0x4A && char <= 0x4E) &&
445                !(char >= 0x50 && char <= 0x5A) &&
446                !(char >= 0x61 && char <= 0x6B) &&
447                !(char >= 0x6D && char <= 0x7A)) 
448             return false;
449         }
450 
451         return true;
452     }
453 
454     function isValidAccountName(string memory account) public pure returns (bool) {
455         bytes memory b = bytes(account);
456         if (b.length != 12) return false;
457 
458         for(uint i = 0; i<b.length; i++){
459             bytes1 char = b[i];
460 
461             // a-z && 1-5 && .
462             if(!(char >= 0x61 && char <= 0x7A) && 
463                !(char >= 0x31 && char <= 0x35) && 
464                !(char == 0x2E)) 
465             return  false;
466         }
467         
468         return true;
469     }
470 
471     function isValidAccount(string memory _accountName, string memory _accountOpenkey) public pure returns (bool) {
472             return(isValidAccountName(_accountName) && isValidOpenkey(_accountOpenkey));
473         }
474         
475 }