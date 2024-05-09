1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 // Sources flattened with hardhat v2.12.0 https://hardhat.org
5 
6 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
7 
8 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
9 
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Emitted when `value` tokens are moved from one account (`from`) to
17      * another (`to`).
18      *
19      * Note that `value` may be zero.
20      */
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     /**
24      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
25      * a call to {approve}. `value` is the new allowance.
26      */
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `to`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address to, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `from` to `to` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address from,
84         address to,
85         uint256 amount
86     ) external returns (bool);
87 }
88 
89 
90 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.3
91 
92 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
93 
94 
95 /**
96  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
97  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
98  *
99  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
100  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
101  * need to send a transaction, and thus is not required to hold Ether at all.
102  */
103 interface IERC20Permit {
104     /**
105      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
106      * given ``owner``'s signed approval.
107      *
108      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
109      * ordering also apply here.
110      *
111      * Emits an {Approval} event.
112      *
113      * Requirements:
114      *
115      * - `spender` cannot be the zero address.
116      * - `deadline` must be a timestamp in the future.
117      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
118      * over the EIP712-formatted function arguments.
119      * - the signature must use ``owner``'s current nonce (see {nonces}).
120      *
121      * For more information on the signature format, see the
122      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
123      * section].
124      */
125     function permit(
126         address owner,
127         address spender,
128         uint256 value,
129         uint256 deadline,
130         uint8 v,
131         bytes32 r,
132         bytes32 s
133     ) external;
134 
135     /**
136      * @dev Returns the current nonce for `owner`. This value must be
137      * included whenever a signature is generated for {permit}.
138      *
139      * Every successful call to {permit} increases ``owner``'s nonce by one. This
140      * prevents a signature from being used multiple times.
141      */
142     function nonces(address owner) external view returns (uint256);
143 
144     /**
145      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
146      */
147     // solhint-disable-next-line func-name-mixedcase
148     function DOMAIN_SEPARATOR() external view returns (bytes32);
149 }
150 
151 
152 // File @uniswap/v3-periphery/contracts/libraries/TransferHelper.sol@v1.4.1
153 
154 
155 library TransferHelper {
156     /// @notice Transfers tokens from the targeted address to the given destination
157     /// @notice Errors with 'STF' if transfer fails
158     /// @param token The contract address of the token to be transferred
159     /// @param from The originating address from which the tokens will be transferred
160     /// @param to The destination address of the transfer
161     /// @param value The amount to be transferred
162     function safeTransferFrom(
163         address token,
164         address from,
165         address to,
166         uint256 value
167     ) internal {
168         (bool success, bytes memory data) =
169             token.call(abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, value));
170         require(success && (data.length == 0 || abi.decode(data, (bool))), 'STF');
171     }
172 
173     /// @notice Transfers tokens from msg.sender to a recipient
174     /// @dev Errors with ST if transfer fails
175     /// @param token The contract address of the token which will be transferred
176     /// @param to The recipient of the transfer
177     /// @param value The value of the transfer
178     function safeTransfer(
179         address token,
180         address to,
181         uint256 value
182     ) internal {
183         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.transfer.selector, to, value));
184         require(success && (data.length == 0 || abi.decode(data, (bool))), 'ST');
185     }
186 
187     /// @notice Approves the stipulated contract to spend the given allowance in the given token
188     /// @dev Errors with 'SA' if transfer fails
189     /// @param token The contract address of the token to be approved
190     /// @param to The target of the approval
191     /// @param value The amount of the given token the target will be allowed to spend
192     function safeApprove(
193         address token,
194         address to,
195         uint256 value
196     ) internal {
197         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.approve.selector, to, value));
198         require(success && (data.length == 0 || abi.decode(data, (bool))), 'SA');
199     }
200 
201     /// @notice Transfers ETH to the recipient address
202     /// @dev Fails with `STE`
203     /// @param to The destination of the transfer
204     /// @param value The value to be transferred
205     function safeTransferETH(address to, uint256 value) internal {
206         (bool success, ) = to.call{value: value}(new bytes(0));
207         require(success, 'STE');
208     }
209 }
210 
211 
212 // File contracts/Fraxferry/Fraxferry.sol
213 
214 
215 // ====================================================================
216 // |     ______                   _______                             |
217 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
218 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
219 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
220 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
221 // |                                                                  |
222 // ====================================================================
223 // ============================ Fraxferry =============================
224 // ====================================================================
225 // Ferry that can be used to ship tokens between chains
226 
227 // Frax Finance: https://github.com/FraxFinance
228 
229 // Primary Author(s)
230 // Dennis: https://github.com/denett
231 
232 /*
233 ** Modus operandi:
234 ** - User sends tokens to the contract. This transaction is stored in the contract.
235 ** - Captain queries the source chain for transactions to ship.
236 ** - Captain sends batch (start, end, hash) to start the trip,
237 ** - Crewmembers check the batch and can dispute it if it is invalid.
238 ** - Non disputed batches can be executed by the first officer by providing the transactions as calldata. 
239 ** - Hash of the transactions must be equal to the hash in the batch. User receives their tokens on the other chain.
240 ** - In case there was a fraudulent transaction (a hacker for example), the owner can cancel a single transaction, such that it will not be executed.
241 ** - The owner can manually manage the tokens in the contract and must make sure it has enough funds.
242 **
243 ** What must happen for a false batch to be executed:
244 ** - Captain is tricked into proposing a batch with a false hash
245 ** - All crewmembers bots are offline/censured/compromised and no one disputes the proposal
246 **
247 ** Other risks:
248 ** - Reorgs on the source chain. Avoided, by only returning the transactions on the source chain that are at least one hour old.
249 ** - Rollbacks of optimistic rollups. Avoided by running a node.
250 ** - Operators do not have enough time to pause the chain after a fake proposal. Avoided by requiring a minimal amount of time between sending the proposal and executing it.
251 */
252 
253 
254 
255 contract Fraxferry {
256    IERC20 immutable public token;
257    IERC20 immutable public targetToken;
258    uint immutable public chainid;
259    uint immutable public targetChain;   
260    
261    address public owner;
262    address public nominatedOwner;
263    address public captain;
264    address public firstOfficer;
265    mapping(address => bool) public crewmembers;
266 
267    bool public paused;
268    
269    uint public MIN_WAIT_PERIOD_ADD=3600; // Minimal 1 hour waiting
270    uint public MIN_WAIT_PERIOD_EXECUTE=82800; // Minimal 23 hour waiting
271    uint public FEE=1*1e18; // 1 token
272    uint immutable MAX_FEE=100e18; // Max fee is 100 tokens
273    uint immutable public REDUCED_DECIMALS=1e10;
274    
275    Transaction[] public transactions;
276    mapping(uint => bool) public cancelled;
277    uint public executeIndex;
278    Batch[] public batches;
279    
280    struct Transaction {
281       address user;
282       uint64 amount;
283       uint32 timestamp;
284    }
285    
286    struct Batch {
287       uint64 start;
288       uint64 end;
289       uint64 departureTime;
290       uint64 status;
291       bytes32 hash;
292    }
293    
294    struct BatchData {
295       uint startTransactionNo;
296       Transaction[] transactions;
297    }
298 
299    constructor(IERC20 _token, uint _chainid, IERC20 _targetToken, uint _targetChain) {
300       //require (block.chainid==_chainid,"Wrong chain");
301       chainid=_chainid;
302       token = _token;
303       targetToken = _targetToken;
304       owner = msg.sender;
305       targetChain = _targetChain;
306    }
307    
308    
309    // ############## Events ##############
310    
311    event Embark(address indexed sender, uint index, uint amount, uint amountAfterFee, uint timestamp);
312    event Disembark(uint start, uint end, bytes32 hash); 
313    event Depart(uint batchNo,uint start,uint end,bytes32 hash); 
314    event RemoveBatch(uint batchNo);
315    event DisputeBatch(uint batchNo, bytes32 hash);
316    event Cancelled(uint index, bool cancel);
317    event Pause(bool paused);
318    event OwnerNominated(address indexed newOwner);
319    event OwnerChanged(address indexed previousOwner,address indexed newOwner);
320    event SetCaptain(address indexed previousCaptain, address indexed newCaptain);   
321    event SetFirstOfficer(address indexed previousFirstOfficer, address indexed newFirstOfficer);
322    event SetCrewmember(address indexed crewmember,bool set); 
323    event SetFee(uint previousFee, uint fee);
324    event SetMinWaitPeriods(uint previousMinWaitAdd,uint previousMinWaitExecute,uint minWaitAdd,uint minWaitExecute); 
325    
326    // ############## Modifiers ##############
327    
328    modifier isOwner() {
329       require (msg.sender==owner,"Not owner");
330       _;
331    }
332    
333    modifier isCaptain() {
334       require (msg.sender==captain,"Not captain");
335       _;
336    }
337    
338    modifier isFirstOfficer() {
339       require (msg.sender==firstOfficer,"Not first officer");
340       _;
341    }   
342     
343    modifier isCrewmember() {
344       require (crewmembers[msg.sender] || msg.sender==owner || msg.sender==captain || msg.sender==firstOfficer,"Not crewmember");
345       _;
346    }
347    
348    modifier notPaused() {
349       require (!paused,"Paused");
350       _;
351    } 
352    
353    // ############## Ferry actions ##############
354    
355    function embarkWithRecipient(uint amount, address recipient) public notPaused {
356       amount = (amount/REDUCED_DECIMALS)*REDUCED_DECIMALS; // Round amount to fit in data structure
357       require (amount>FEE,"Amount too low");
358       require (amount/REDUCED_DECIMALS<=type(uint64).max,"Amount too high");
359       TransferHelper.safeTransferFrom(address(token),msg.sender,address(this),amount); 
360       uint64 amountAfterFee = uint64((amount-FEE)/REDUCED_DECIMALS);
361       emit Embark(recipient,transactions.length,amount,amountAfterFee*REDUCED_DECIMALS,block.timestamp);
362       transactions.push(Transaction(recipient,amountAfterFee,uint32(block.timestamp)));   
363    }
364    
365    function embark(uint amount) public {
366       embarkWithRecipient(amount, msg.sender) ;
367    }
368 
369    function embarkWithSignature(
370       uint256 _amount,
371       address recipient,
372       uint256 deadline,
373       bool approveMax,
374       uint8 v,
375       bytes32 r,
376       bytes32 s
377    ) public {
378       uint amount = approveMax ? type(uint256).max : _amount;
379       IERC20Permit(address(token)).permit(msg.sender, address(this), amount, deadline, v, r, s);
380       embarkWithRecipient(amount,recipient);
381    }   
382    
383    function depart(uint start, uint end, bytes32 hash) external notPaused isCaptain {
384       require ((batches.length==0 && start==0) || (batches.length>0 && start==batches[batches.length-1].end+1),"Wrong start");
385       require (end>=start && end<type(uint64).max,"Wrong end");
386       batches.push(Batch(uint64(start),uint64(end),uint64(block.timestamp),0,hash));
387       emit Depart(batches.length-1,start,end,hash);
388    }
389    
390    function disembark(BatchData calldata batchData) external notPaused isFirstOfficer {
391       Batch memory batch = batches[executeIndex++];
392       require (batch.status==0,"Batch disputed");
393       require (batch.start==batchData.startTransactionNo,"Wrong start");
394       require (batch.start+batchData.transactions.length-1==batch.end,"Wrong size");
395       require (block.timestamp-batch.departureTime>=MIN_WAIT_PERIOD_EXECUTE,"Too soon");
396       
397       bytes32 hash = keccak256(abi.encodePacked(targetChain, targetToken, chainid, token, batch.start));
398       for (uint i=0;i<batchData.transactions.length;++i) {
399          if (!cancelled[batch.start+i]) {
400             TransferHelper.safeTransfer(address(token),batchData.transactions[i].user,batchData.transactions[i].amount*REDUCED_DECIMALS);
401          }
402          hash = keccak256(abi.encodePacked(hash, batchData.transactions[i].user,batchData.transactions[i].amount));
403       }
404       require (batch.hash==hash,"Wrong hash");
405       emit Disembark(batch.start,batch.end,hash);
406    }
407    
408    function removeBatches(uint batchNo) external isOwner {
409       require (executeIndex<=batchNo,"Batch already executed");
410       while (batches.length>batchNo) batches.pop();
411       emit RemoveBatch(batchNo);
412    }
413    
414    function disputeBatch(uint batchNo, bytes32 hash) external isCrewmember {
415       require (batches[batchNo].hash==hash,"Wrong hash");
416       require (executeIndex<=batchNo,"Batch already executed");
417       require (batches[batchNo].status==0,"Batch already disputed");
418       batches[batchNo].status=1; // Set status on disputed
419       _pause(true);
420       emit DisputeBatch(batchNo,hash);
421    }
422    
423    function pause() external isCrewmember {
424       _pause(true);
425    }
426    
427    function unPause() external isOwner {
428       _pause(false);
429    }   
430    
431    function _pause(bool _paused) internal {
432       paused=_paused;
433       emit Pause(_paused);
434    } 
435    
436    function _jettison(uint index, bool cancel) internal {
437       require (executeIndex==0 || index>batches[executeIndex-1].end,"Transaction already executed");
438       cancelled[index]=cancel;
439       emit Cancelled(index,cancel);
440    }
441    
442    function jettison(uint index, bool cancel) external isOwner {
443       _jettison(index,cancel);
444    }
445    
446    function jettisonGroup(uint[] calldata indexes, bool cancel) external isOwner {
447       for (uint i=0;i<indexes.length;++i) {
448          _jettison(indexes[i],cancel);
449       }
450    }   
451    
452    // ############## Parameters management ##############
453    
454    function setFee(uint _FEE) external isOwner {
455       require(FEE<MAX_FEE);
456       emit SetFee(FEE,_FEE);
457       FEE=_FEE;
458    }
459    
460    function setMinWaitPeriods(uint _MIN_WAIT_PERIOD_ADD, uint _MIN_WAIT_PERIOD_EXECUTE) external isOwner {
461       require(_MIN_WAIT_PERIOD_ADD>=3600 && _MIN_WAIT_PERIOD_EXECUTE>=3600,"Period too short");
462       emit SetMinWaitPeriods(MIN_WAIT_PERIOD_ADD, MIN_WAIT_PERIOD_EXECUTE,_MIN_WAIT_PERIOD_ADD, _MIN_WAIT_PERIOD_EXECUTE);
463       MIN_WAIT_PERIOD_ADD=_MIN_WAIT_PERIOD_ADD;
464       MIN_WAIT_PERIOD_EXECUTE=_MIN_WAIT_PERIOD_EXECUTE;
465    }
466    
467    // ############## Roles management ##############
468    
469    function nominateNewOwner(address newOwner) external isOwner {
470       nominatedOwner = newOwner;
471       emit OwnerNominated(newOwner);
472    }   
473    
474    function acceptOwnership() external {
475       require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
476       emit OwnerChanged(owner, nominatedOwner);
477       owner = nominatedOwner;
478       nominatedOwner = address(0);
479    }
480    
481    function setCaptain(address newCaptain) external isOwner {
482       emit SetCaptain(captain,newCaptain);
483       captain=newCaptain;
484    }
485    
486    function setFirstOfficer(address newFirstOfficer) external isOwner {
487       emit SetFirstOfficer(firstOfficer,newFirstOfficer);
488       firstOfficer=newFirstOfficer;
489    }    
490    
491    function setCrewmember(address crewmember, bool set) external isOwner {
492       crewmembers[crewmember]=set;
493       emit SetCrewmember(crewmember,set);
494    }   
495   
496    
497    // ############## Token management ##############   
498    
499    function sendTokens(address receiver, uint amount) external isOwner {
500       require (receiver!=address(0),"Zero address not allowed");
501       TransferHelper.safeTransfer(address(token),receiver,amount);
502    }   
503    
504    // Generic proxy
505    function execute(address _to, uint256 _value, bytes calldata _data) external isOwner returns (bool, bytes memory) {
506       require(_data.length==0 || _to.code.length>0,"Can not call a function on a EOA");
507       (bool success, bytes memory result) = _to.call{value:_value}(_data);
508       return (success, result);
509    }   
510    
511    // ############## Views ##############
512    function getNextBatch(uint _start, uint max) public view returns (uint start, uint end, bytes32 hash) {
513       uint cutoffTime = block.timestamp-MIN_WAIT_PERIOD_ADD;
514       if (_start<transactions.length && transactions[_start].timestamp<cutoffTime) {
515          start=_start;
516          end=start+max-1;
517          if (end>=transactions.length) end=transactions.length-1;
518          while(transactions[end].timestamp>=cutoffTime) end--;
519          hash = getTransactionsHash(start,end);
520       }
521    }
522    
523    function getBatchData(uint start, uint end) public view returns (BatchData memory data) {
524       data.startTransactionNo = start;
525       data.transactions = new Transaction[](end-start+1);
526       for (uint i=start;i<=end;++i) {
527          data.transactions[i-start]=transactions[i];
528       }
529    }
530    
531    function getBatchAmount(uint start, uint end) public view returns (uint totalAmount) {
532       for (uint i=start;i<=end;++i) {
533          totalAmount+=transactions[i].amount;
534       }
535       totalAmount*=REDUCED_DECIMALS;
536    }
537    
538    function getTransactionsHash(uint start, uint end) public view returns (bytes32) {
539       bytes32 result = keccak256(abi.encodePacked(chainid, token, targetChain, targetToken, uint64(start)));
540       for (uint i=start;i<=end;++i) {
541          result = keccak256(abi.encodePacked(result, transactions[i].user,transactions[i].amount));
542       }
543       return result;
544    }   
545    
546    function noTransactions() public view returns (uint) {
547       return transactions.length;
548    }
549    
550    function noBatches() public view returns (uint) {
551       return batches.length;
552    }
553 }