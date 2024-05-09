1 /**
2 **********************************************  
3 *           GOLDMINING.FARM                  *
4 **********************************************
5 * NAME: GOLDMINING TOKEN                     *
6 * VERSION: 0.1.1                             *
7 * TICKER: GMT                                *
8 * SUPPLY: 5000 GMT                           *
9 * MINING START: ETHEREUM BLOCK # 10975998    *
10 * BONUS BLOCK: 0 BLOCKS ONLY                 *
11 * BONUS REWARD: 1X [ NO BONUS ]              *
12 * BLOCK REWARD: 0.25 GMT / BLOCK             *
13 * TEAM ALLOCATION: 5%                        *
14 **********************************************
15 *           MORE DETAILS                     *
16 **********************************************
17 * App: https://goldmining.farm               *
18 * Telegram: https://t.me/goldminingfarm      *
19 * Twitter: https://twitter.com/goldminingfarm*
20 **********************************************
21  */
22 
23 
24 pragma solidity ^0.6.0;
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address payable) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes memory) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 
38 
39 
40 
41 pragma solidity ^0.6.0;
42 
43 /**
44  * @dev Interface of the ERC20 standard as defined in the EIP.
45  */
46 interface IERC20 {
47     /**
48      * @dev Returns the amount of tokens in existence.
49      */
50     function totalSupply() external view returns (uint256);
51 
52     /**
53      * @dev Returns the amount of tokens owned by `account`.
54      */
55     function balanceOf(address account) external view returns (uint256);
56 
57    
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62    
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65   
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68    
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71 
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 
77 
78 
79 pragma solidity ^0.6.0;
80 
81 library SafeMath {
82   
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a, "SafeMath: addition overflow");
86 
87         return c;
88     }
89 
90    
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         return sub(a, b, "SafeMath: subtraction overflow");
93     }
94 
95 
96     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99 
100         return c;
101     }
102 
103    
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105       
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112 
113         return c;
114     }
115 
116    
117     function div(uint256 a, uint256 b) internal pure returns (uint256) {
118         return div(a, b, "SafeMath: division by zero");
119     }
120 
121   
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130   
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         return mod(a, b, "SafeMath: modulo by zero");
133     }
134 
135    
136     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b != 0, errorMessage);
138         return a % b;
139     }
140 }
141 
142 
143 
144 pragma solidity ^0.6.2;
145 
146 /**
147  * @dev Collection of functions related to the address type
148  */
149 library Address {
150    
151     function isContract(address account) internal view returns (bool) {
152         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
153         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
154         // for accounts without code, i.e. `keccak256('')`
155         bytes32 codehash;
156         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
157         // solhint-disable-next-line no-inline-assembly
158         assembly { codehash := extcodehash(account) }
159         return (codehash != accountHash && codehash != 0x0);
160     }
161 
162     function sendValue(address payable recipient, uint256 amount) internal {
163         require(address(this).balance >= amount, "Address: insufficient balance");
164 
165         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
166         (bool success, ) = recipient.call{ value: amount }("");
167         require(success, "Address: unable to send value, recipient may have reverted");
168     }
169 
170   
171     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
172       return functionCall(target, data, "Address: low-level call failed");
173     }
174 
175   
176     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
177         return _functionCallWithValue(target, data, 0, errorMessage);
178     }
179 
180   
181     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
182         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
183     }
184 
185  
186     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
187         require(address(this).balance >= value, "Address: insufficient balance for call");
188         return _functionCallWithValue(target, data, value, errorMessage);
189     }
190 
191     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
192         require(isContract(target), "Address: call to non-contract");
193 
194         // solhint-disable-next-line avoid-low-level-calls
195         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
196         if (success) {
197             return returndata;
198         } else {
199             // Look for revert reason and bubble it up if present
200             if (returndata.length > 0) {
201                 // The easiest way to bubble the revert reason is using memory via assembly
202 
203                 // solhint-disable-next-line no-inline-assembly
204                 assembly {
205                     let returndata_size := mload(returndata)
206                     revert(add(32, returndata), returndata_size)
207                 }
208             } else {
209                 revert(errorMessage);
210             }
211         }
212     }
213 }
214 
215 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
216 
217 
218 
219 pragma solidity ^0.6.0;
220 
221 contract ERC20 is Context, IERC20 {
222     using SafeMath for uint256;
223     using Address for address;
224 
225     mapping (address => uint256) private _balances;
226 
227     mapping (address => mapping (address => uint256)) private _allowances;
228 
229     uint256 private _totalSupply;
230 
231     string private _name;
232     string private _symbol;
233     uint8 private _decimals;
234 
235   
236     constructor (string memory name, string memory symbol) public {
237         _name = name;
238         _symbol = symbol;
239         _decimals = 18;
240     }
241 
242     /**
243      * @dev Returns the name of the token.
244      */
245     function name() public view returns (string memory) {
246         return _name;
247     }
248 
249     /**
250      * @dev Returns the symbol of the token, usually a shorter version of the
251      * name.
252      */
253     function symbol() public view returns (string memory) {
254         return _symbol;
255     }
256 
257   
258     function decimals() public view returns (uint8) {
259         return _decimals;
260     }
261 
262     /**
263      * @dev See {IERC20-totalSupply}.
264      */
265     function totalSupply() public view override returns (uint256) {
266         return _totalSupply;
267     }
268 
269     /**
270      * @dev See {IERC20-balanceOf}.
271      */
272     function balanceOf(address account) public view override returns (uint256) {
273         return _balances[account];
274     }
275 
276     /**
277      * @dev See {IERC20-transfer}.
278      *
279      * Requirements:
280      *
281      * - `recipient` cannot be the zero address.
282      * - the caller must have a balance of at least `amount`.
283      */
284     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
285         _transfer(_msgSender(), recipient, amount);
286         return true;
287     }
288 
289     /**
290      * @dev See {IERC20-allowance}.
291      */
292     function allowance(address owner, address spender) public view virtual override returns (uint256) {
293         return _allowances[owner][spender];
294     }
295 
296     /**
297      * @dev See {IERC20-approve}.
298      *
299      * Requirements:
300      *
301      * - `spender` cannot be the zero address.
302      */
303     function approve(address spender, uint256 amount) public virtual override returns (bool) {
304         _approve(_msgSender(), spender, amount);
305         return true;
306     }
307 
308  
309     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
310         _transfer(sender, recipient, amount);
311         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
312         return true;
313     }
314 
315 
316     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
317         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
318         return true;
319     }
320 
321    
322     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
323         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
324         return true;
325     }
326 
327   
328     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
329         require(sender != address(0), "ERC20: transfer from the zero address");
330         require(recipient != address(0), "ERC20: transfer to the zero address");
331 
332         _beforeTokenTransfer(sender, recipient, amount);
333 
334         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
335         _balances[recipient] = _balances[recipient].add(amount);
336         emit Transfer(sender, recipient, amount);
337     }
338 
339   
340     function _mint(address account, uint256 amount) internal virtual {
341         require(account != address(0), "ERC20: mint to the zero address");
342 
343         _beforeTokenTransfer(address(0), account, amount);
344 
345         _totalSupply = _totalSupply.add(amount);
346         _balances[account] = _balances[account].add(amount);
347         emit Transfer(address(0), account, amount);
348     }
349 
350  
351     function _burn(address account, uint256 amount) internal virtual {
352         require(account != address(0), "ERC20: burn from the zero address");
353 
354         _beforeTokenTransfer(account, address(0), amount);
355 
356         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
357         _totalSupply = _totalSupply.sub(amount);
358         emit Transfer(account, address(0), amount);
359     }
360 
361   
362     function _approve(address owner, address spender, uint256 amount) internal virtual {
363         require(owner != address(0), "ERC20: approve from the zero address");
364         require(spender != address(0), "ERC20: approve to the zero address");
365 
366         _allowances[owner][spender] = amount;
367         emit Approval(owner, spender, amount);
368     }
369 
370   
371     function _setupDecimals(uint8 decimals_) internal {
372         _decimals = decimals_;
373     }
374 
375  
376     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
377 }
378 
379 
380 
381 
382 
383 pragma solidity ^0.6.0;
384 
385 
386 contract Ownable is Context {
387     address private _owner;
388 
389     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
390 
391     /**
392      * @dev Initializes the contract setting the deployer as the initial owner.
393      */
394     constructor () internal {
395         address msgSender = _msgSender();
396         _owner = msgSender;
397         emit OwnershipTransferred(address(0), msgSender);
398     }
399 
400     /**
401      * @dev Returns the address of the current owner.
402      */
403     function owner() public view returns (address) {
404         return _owner;
405     }
406 
407     /**
408      * @dev Throws if called by any account other than the owner.
409      */
410     modifier onlyOwner() {
411         require(_owner == _msgSender(), "Ownable: caller is not the owner");
412         _;
413     }
414 
415  
416     function renounceOwnership() public virtual onlyOwner {
417         emit OwnershipTransferred(_owner, address(0));
418         _owner = address(0);
419     }
420 
421     /**
422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
423      * Can only be called by the current owner.
424      */
425     function transferOwnership(address newOwner) public virtual onlyOwner {
426         require(newOwner != address(0), "Ownable: new owner is the zero address");
427         emit OwnershipTransferred(_owner, newOwner);
428         _owner = newOwner;
429     }
430 }
431 
432 
433 
434 pragma solidity 0.6.12;
435 
436 
437 // GoldMining Token with Governance.
438 
439 
440 contract GoldMining is ERC20("GoldMining Token", "GMT"), Ownable {
441     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
442     function mint(address _to, uint256 _amount) public onlyOwner {
443         _mint(_to, _amount);
444         _moveDelegates(address(0), _delegates[_to], _amount);
445     }
446 
447     mapping (address => address) internal _delegates;
448 
449     /// @notice A checkpoint for marking number of votes from a given block
450     struct Checkpoint {
451         uint32 fromBlock;
452         uint256 votes;
453     }
454 
455     /// @notice A record of votes checkpoints for each account, by index
456     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
457 
458     /// @notice The number of checkpoints for each account
459     mapping (address => uint32) public numCheckpoints;
460 
461     /// @notice The EIP-712 typehash for the contract's domain
462     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
463 
464     /// @notice The EIP-712 typehash for the delegation struct used by the contract
465     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
466 
467     /// @notice A record of states for signing / validating signatures
468     mapping (address => uint) public nonces;
469 
470       /// @notice An event thats emitted when an account changes its delegate
471     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
472 
473     /// @notice An event thats emitted when a delegate account's vote balance changes
474     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
475 
476     /**
477      * @notice Delegate votes from `msg.sender` to `delegatee`
478      * @param delegator The address to get delegatee for
479      */
480     function delegates(address delegator)
481         external
482         view
483         returns (address)
484     {
485         return _delegates[delegator];
486     }
487 
488  
489     function delegate(address delegatee) external {
490         return _delegate(msg.sender, delegatee);
491     }
492 
493  
494     function delegateBySig(
495         address delegatee,
496         uint nonce,
497         uint expiry,
498         uint8 v,
499         bytes32 r,
500         bytes32 s
501     )
502         external
503     {
504         bytes32 domainSeparator = keccak256(
505             abi.encode(
506                 DOMAIN_TYPEHASH,
507                 keccak256(bytes(name())),
508                 getChainId(),
509                 address(this)
510             )
511         );
512 
513         bytes32 structHash = keccak256(
514             abi.encode(
515                 DELEGATION_TYPEHASH,
516                 delegatee,
517                 nonce,
518                 expiry
519             )
520         );
521 
522         bytes32 digest = keccak256(
523             abi.encodePacked(
524                 "\x19\x01",
525                 domainSeparator,
526                 structHash
527             )
528         );
529 
530         address signatory = ecrecover(digest, v, r, s);
531         require(signatory != address(0), "GMT::delegateBySig: invalid signature");
532         require(nonce == nonces[signatory]++, "GMT::delegateBySig: invalid nonce");
533         require(now <= expiry, "GMT::delegateBySig: signature expired");
534         return _delegate(signatory, delegatee);
535     }
536 
537 
538     function getCurrentVotes(address account)
539         external
540         view
541         returns (uint256)
542     {
543         uint32 nCheckpoints = numCheckpoints[account];
544         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
545     }
546 
547  
548     function getPriorVotes(address account, uint blockNumber)
549         external
550         view
551         returns (uint256)
552     {
553         require(blockNumber < block.number, "GMT::getPriorVotes: not yet determined");
554 
555         uint32 nCheckpoints = numCheckpoints[account];
556         if (nCheckpoints == 0) {
557             return 0;
558         }
559 
560         // First check most recent balance
561         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
562             return checkpoints[account][nCheckpoints - 1].votes;
563         }
564 
565         // Next check implicit zero balance
566         if (checkpoints[account][0].fromBlock > blockNumber) {
567             return 0;
568         }
569 
570         uint32 lower = 0;
571         uint32 upper = nCheckpoints - 1;
572         while (upper > lower) {
573             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
574             Checkpoint memory cp = checkpoints[account][center];
575             if (cp.fromBlock == blockNumber) {
576                 return cp.votes;
577             } else if (cp.fromBlock < blockNumber) {
578                 lower = center;
579             } else {
580                 upper = center - 1;
581             }
582         }
583         return checkpoints[account][lower].votes;
584     }
585 
586     function _delegate(address delegator, address delegatee)
587         internal
588     {
589         address currentDelegate = _delegates[delegator];
590         uint256 delegatorBalance = balanceOf(delegator); 
591         _delegates[delegator] = delegatee;
592 
593         emit DelegateChanged(delegator, currentDelegate, delegatee);
594 
595         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
596     }
597 
598     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
599         if (srcRep != dstRep && amount > 0) {
600             if (srcRep != address(0)) {
601                 // decrease old representative
602                 uint32 srcRepNum = numCheckpoints[srcRep];
603                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
604                 uint256 srcRepNew = srcRepOld.sub(amount);
605                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
606             }
607 
608             if (dstRep != address(0)) {
609                 // increase new representative
610                 uint32 dstRepNum = numCheckpoints[dstRep];
611                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
612                 uint256 dstRepNew = dstRepOld.add(amount);
613                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
614             }
615         }
616     }
617 
618     function _writeCheckpoint(
619         address delegatee,
620         uint32 nCheckpoints,
621         uint256 oldVotes,
622         uint256 newVotes
623     )
624         internal
625     {
626         uint32 blockNumber = safe32(block.number, "GMT::_writeCheckpoint: block number exceeds 32 bits");
627 
628         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
629             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
630         } else {
631             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
632             numCheckpoints[delegatee] = nCheckpoints + 1;
633         }
634 
635         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
636     }
637 
638     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
639         require(n < 2**32, errorMessage);
640         return uint32(n);
641     }
642 
643     function getChainId() internal pure returns (uint) {
644         uint256 chainId;
645         assembly { chainId := chainid() }
646         return chainId;
647     }
648 }