1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (_a == 0) {
83       return 0;
84     }
85 
86     c = _a * _b;
87     assert(c / _a == _b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
95     // assert(_b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = _a / _b;
97     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
98     return _a / _b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
105     assert(_b <= _a);
106     return _a - _b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
113     c = _a + _b;
114     assert(c >= _a);
115     return c;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address _who) public view returns (uint256);
129   function transfer(address _to, uint256 _value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address _owner, address _spender)
141     public view returns (uint256);
142 
143   function transferFrom(address _from, address _to, uint256 _value)
144     public returns (bool);
145 
146   function approve(address _spender, uint256 _value) public returns (bool);
147   event Approval(
148     address indexed owner,
149     address indexed spender,
150     uint256 value
151   );
152 }
153 
154 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
155 
156 /**
157  * @title SafeERC20
158  * @dev Wrappers around ERC20 operations that throw on failure.
159  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
160  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
161  */
162 library SafeERC20 {
163   function safeTransfer(
164     ERC20Basic _token,
165     address _to,
166     uint256 _value
167   )
168     internal
169   {
170     require(_token.transfer(_to, _value));
171   }
172 
173   function safeTransferFrom(
174     ERC20 _token,
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     internal
180   {
181     require(_token.transferFrom(_from, _to, _value));
182   }
183 
184   function safeApprove(
185     ERC20 _token,
186     address _spender,
187     uint256 _value
188   )
189     internal
190   {
191     require(_token.approve(_spender, _value));
192   }
193 }
194 
195 // File: contracts/governance/DelegateReference.sol
196 
197 /**
198 * @title Delegate reference to be used in other contracts
199 */
200 interface DelegateReference {
201     /**
202     * @notice Stake specified amount of tokens to the delegate to participate in coin distribution
203     */
204     function stake(uint256 _amount) external;
205 
206     /**
207     * @notice Unstake specified amount of tokens from the delegate
208     */
209     function unstake(uint256 _amount) external;
210 
211     /**
212     * @notice Return number of tokens staked by the specified staker
213     */
214     function stakeOf(address _staker) external view returns (uint256);
215 
216     /**
217     * @notice Sets Aerum address for delegate & calling staker
218     */
219     function setAerumAddress(address _aerum) external;
220 }
221 
222 // File: contracts/vesting/MultiVestingWallet.sol
223 
224 /**
225  * @title TokenVesting
226  * @notice A token holder contract that can release its token balance gradually like a
227  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
228  * owner.
229  */
230 contract MultiVestingWallet is Ownable {
231     using SafeMath for uint256;
232     using SafeERC20 for ERC20;
233 
234     event Released(address indexed account, uint256 amount);
235     event Revoked(address indexed account);
236     event UnRevoked(address indexed account);
237     event ReturnTokens(uint256 amount);
238     event Promise(address indexed account, uint256 amount);
239     event Stake(address indexed delegate, uint256 amount);
240     event Unstake(address indexed delegate, uint256 amount);
241 
242     ERC20 public token;
243 
244     uint256 public cliff;
245     uint256 public start;
246     uint256 public duration;
247     uint256 public staked;
248 
249     bool public revocable;
250 
251     address[] public accounts;
252     mapping(address => bool) public known;
253     mapping(address => uint256) public promised;
254     mapping(address => uint256) public released;
255     mapping(address => bool) public revoked;
256 
257     /**
258      * @notice Creates a vesting contract that vests its balance of any ERC20 token to the
259      * of the balance will have vested.
260      * @param _token token being vested
261      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
262      * @param _start the time (as Unix time) at which point vesting starts
263      * @param _duration duration in seconds of the period in which the tokens will vest
264      * @param _revocable whether the vesting is revocable or not
265      */
266     constructor(
267         address _token,
268         uint256 _start,
269         uint256 _cliff,
270         uint256 _duration,
271         bool _revocable
272     )
273     public
274     {
275         require(_token != address(0));
276         require(_cliff <= _duration);
277 
278         token = ERC20(_token);
279         revocable = _revocable;
280         duration = _duration;
281         cliff = _start.add(_cliff);
282         start = _start;
283     }
284 
285     /**
286      * @notice Transfers vested tokens to beneficiary.
287      */
288     function release() external {
289         _release(msg.sender);
290     }
291 
292     /**
293      * @notice Transfers vested tokens to list of beneficiary.
294      * @param _addresses List of beneficiaries
295      */
296     function releaseBatch(address[] _addresses) external {
297         for (uint256 index = 0; index < _addresses.length; index++) {
298             _release(_addresses[index]);
299         }
300     }
301 
302     /**
303      * @notice Transfers vested tokens to batch of beneficiaries (starting 0)
304      * @param _start Index of first beneficiary to release tokens
305      * @param _count Number of beneficiaries to release tokens
306      */
307     function releaseBatchPaged(uint256 _start, uint256 _count) external {
308         uint256 last = _start.add(_count);
309         if (last > accounts.length) {
310             last = accounts.length;
311         }
312 
313         for (uint256 index = _start; index < last; index++) {
314             _release(accounts[index]);
315         }
316     }
317 
318     /**
319      * @notice Transfers vested tokens to all beneficiaries.
320      */
321     function releaseAll() external {
322         for (uint256 index = 0; index < accounts.length; index++) {
323             _release(accounts[index]);
324         }
325     }
326 
327     /**
328      * @notice Internal transfer of vested tokens to beneficiary.
329      */
330     function _release(address _beneficiary) internal {
331         uint256 amount = releasableAmount(_beneficiary);
332         if (amount > 0) {
333             released[_beneficiary] = released[_beneficiary].add(amount);
334             token.safeTransfer(_beneficiary, amount);
335 
336             emit Released(_beneficiary, amount);
337         }
338     }
339 
340     /**
341      * @notice Allows the owner to revoke the vesting. Tokens already vested
342      * remain in the contract, the rest are returned to the owner.
343      * @param _beneficiary Account which will be revoked
344      */
345     function revoke(address _beneficiary) public onlyOwner {
346         require(revocable);
347         require(!revoked[_beneficiary]);
348 
349         promised[_beneficiary] = vestedAmount(_beneficiary);
350         revoked[_beneficiary] = true;
351 
352         emit Revoked(_beneficiary);
353     }
354 
355     /**
356      * @notice Allows the owner to revoke the vesting for few addresses.
357      * @param _addresses Accounts which will be unrevoked
358      */
359     function revokeBatch(address[] _addresses) external onlyOwner {
360         for (uint256 index = 0; index < _addresses.length; index++) {
361             revoke(_addresses[index]);
362         }
363     }
364 
365     /**
366      * @notice Allows the owner to unrevoke the vesting.
367      * @param _beneficiary Account which will be unrevoked
368      */
369     function unRevoke(address _beneficiary) public onlyOwner {
370         require(revocable);
371         require(revoked[_beneficiary]);
372 
373         revoked[_beneficiary] = false;
374 
375         emit UnRevoked(_beneficiary);
376     }
377 
378     /**
379      * @notice Allows the owner to unrevoke the vesting for few addresses.
380      * @param _addresses Accounts which will be unrevoked
381      */
382     function unrevokeBatch(address[] _addresses) external onlyOwner {
383         for (uint256 index = 0; index < _addresses.length; index++) {
384             unRevoke(_addresses[index]);
385         }
386     }
387 
388     /**
389      * @notice Calculates the amount that has already vested but hasn't been released yet.
390      * @param _beneficiary Account which gets vested tokens
391      */
392     function releasableAmount(address _beneficiary) public view returns (uint256) {
393         return vestedAmount(_beneficiary).sub(released[_beneficiary]);
394     }
395 
396     /**
397      * @notice Calculates the amount that has already vested.
398      * @param _beneficiary Account which gets vested tokens
399      */
400     function vestedAmount(address _beneficiary) public view returns (uint256) {
401         uint256 totalPromised = promised[_beneficiary];
402 
403         if (block.timestamp < cliff) {
404             return 0;
405         } else if (block.timestamp >= start.add(duration) || revoked[_beneficiary]) {
406             return totalPromised;
407         } else {
408             return totalPromised.mul(block.timestamp.sub(start)).div(duration);
409         }
410     }
411 
412     /**
413      * @notice Calculates the amount of free tokens in contract
414      */
415     function remainingBalance() public view returns (uint256) {
416         uint256 tokenBalance = token.balanceOf(address(this));
417         uint256 totalPromised = 0;
418         uint256 totalReleased = 0;
419 
420         for (uint256 index = 0; index < accounts.length; index++) {
421             address account = accounts[index];
422             totalPromised = totalPromised.add(promised[account]);
423             totalReleased = totalReleased.add(released[account]);
424         }
425 
426         uint256 promisedNotReleased = totalPromised.sub(totalReleased);
427         if (promisedNotReleased > tokenBalance) {
428             return 0;
429         }
430         return tokenBalance.sub(promisedNotReleased);
431     }
432 
433     /**
434     * @notice Calculates amount of tokens promised
435     */
436     function totalPromised() public view returns (uint256) {
437         uint256 total = 0;
438 
439         for (uint256 index = 0; index < accounts.length; index++) {
440             address account = accounts[index];
441             total = total.add(promised[account]);
442         }
443 
444         return total;
445     }
446 
447     /**
448     * @notice Calculates amount of tokens released
449     */
450     function totalReleased() public view returns (uint256) {
451         uint256 total = 0;
452 
453         for (uint256 index = 0; index < accounts.length; index++) {
454             address account = accounts[index];
455             total = total.add(released[account]);
456         }
457 
458         return total;
459     }
460 
461     /**
462      * @notice Returns free tokens to owner
463      */
464     function returnRemaining() external onlyOwner {
465         uint256 remaining = remainingBalance();
466         require(remaining > 0);
467 
468         token.safeTransfer(owner, remaining);
469 
470         emit ReturnTokens(remaining);
471     }
472 
473     /**
474      * @notice Returns all tokens to owner
475      */
476     function returnAll() external onlyOwner {
477         uint256 remaining = token.balanceOf(address(this));
478         token.safeTransfer(owner, remaining);
479 
480         emit ReturnTokens(remaining);
481     }
482 
483     /**
484      * @notice Sets promise to account
485      * @param _beneficiary Account which gets vested tokens
486      * @param _amount Amount of tokens vested
487      */
488     function promise(address _beneficiary, uint256 _amount) public onlyOwner {
489         if (!known[_beneficiary]) {
490             known[_beneficiary] = true;
491             accounts.push(_beneficiary);
492         }
493 
494         promised[_beneficiary] = _amount;
495 
496         emit Promise(_beneficiary, _amount);
497     }
498 
499     /**
500      * @notice Sets promise to list of account
501      * @param _addresses Accounts which will get promises
502      * @param _amounts Promise amounts
503      */
504     function promiseBatch(address[] _addresses, uint256[] _amounts) external onlyOwner {
505         require(_addresses.length == _amounts.length);
506 
507         for (uint256 index = 0; index < _addresses.length; index++) {
508             promise(_addresses[index], _amounts[index]);
509         }
510     }
511 
512     /**
513      * @notice Returns full list if beneficiaries
514      */
515     function getBeneficiaries() external view returns (address[]) {
516         return accounts;
517     }
518 
519     /**
520      * @notice Returns number of beneficiaries
521      */
522     function getBeneficiariesCount() external view returns (uint256) {
523         return accounts.length;
524     }
525 
526     /**
527      * @notice Stake specified amount of vested tokens to the delegate by the beneficiary
528      */
529     function stake(address _delegate, uint256 _amount) external onlyOwner {
530         staked = staked.add(_amount);
531         token.approve(_delegate, _amount);
532         DelegateReference(_delegate).stake(_amount);
533 
534         emit Stake(_delegate, _amount);
535     }
536 
537     /**
538      * @notice Unstake the given number of vested tokens by the beneficiary
539      */
540     function unstake(address _delegate, uint256 _amount) external onlyOwner {
541         staked = staked.sub(_amount);
542         DelegateReference(_delegate).unstake(_amount);
543 
544         emit Unstake(_delegate, _amount);
545     }
546 }
547 
548 // File: contracts\registry\ContractRegistry.sol
549 
550 /**
551  * @title Contract registry
552  */
553 contract ContractRegistry is Ownable {
554 
555     struct ContractRecord {
556         address addr;
557         bytes32 name;
558         bool enabled;
559     }
560 
561     address private token;
562 
563     /**
564      * @dev contracts Mapping of contracts
565      */
566     mapping(bytes32 => ContractRecord) private contracts;
567     /**
568      * @dev contracts Mapping of contract names
569      */
570     bytes32[] private contractsName;
571 
572     event ContractAdded(bytes32 indexed _name);
573     event ContractRemoved(bytes32 indexed _name);
574 
575     constructor(address _token) public {
576         require(_token != address(0), "Token is required");
577         token = _token;
578     }
579 
580     /**
581      * @dev Returns contract by name
582      * @param _name Contract's name
583      */
584     function getContractByName(bytes32 _name) external view returns (address, bytes32, bool) {
585         ContractRecord memory record = contracts[_name];
586         if(record.addr == address(0) || !record.enabled) {
587             return;
588         }
589         return (record.addr, record.name, record.enabled);
590     }
591 
592     /**
593      * @dev Returns contract's names
594      */
595     function getContractNames() external view returns (bytes32[]) {
596         uint count = 0;
597         for(uint i = 0; i < contractsName.length; i++) {
598             if(contracts[contractsName[i]].enabled) {
599                 count++;
600             }
601         }
602         bytes32[] memory result = new bytes32[](count);
603         uint j = 0;
604         for(i = 0; i < contractsName.length; i++) {
605             if(contracts[contractsName[i]].enabled) {
606                 result[j] = contractsName[i];
607                 j++;
608             }
609         }
610         return result;
611     }
612 
613     /**
614      * @notice Creates a vesting contract that vests its balance of any ERC20 token to the
615      * of the balance will have vested.
616      * @param _name contract's name
617      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
618      * @param _start the time (as Unix time) at which point vesting starts
619      * @param _duration duration in seconds of the period in which the tokens will vest
620      * @param _revocable whether the vesting is revocable or not
621      */
622     function addContract(
623         bytes32 _name,
624         uint256 _start,
625         uint256 _cliff,
626         uint256 _duration,
627         bool _revocable) external onlyOwner {
628         require(contracts[_name].addr == address(0), "Contract's name should be unique");
629         require(_cliff <= _duration, "Cliff shall be bigger than duration");
630 
631         MultiVestingWallet wallet = new MultiVestingWallet(token, _start, _cliff, _duration, _revocable);
632         wallet.transferOwnership(msg.sender);
633         address walletAddr = address(wallet);
634         
635         ContractRecord memory record = ContractRecord({
636             addr: walletAddr,
637             name: _name,
638             enabled: true
639         });
640         contracts[_name] = record;
641         contractsName.push(_name);
642 
643         emit ContractAdded(_name);
644     }
645 
646     /**
647      * @dev Enables/disables contract by address
648      * @param _name Name of the contract
649      */
650     function setEnabled(bytes32 _name, bool enabled) external onlyOwner {
651         ContractRecord memory record = contracts[_name];
652         require(record.addr != address(0), "Contract with specified address does not exist");
653 
654         contracts[_name].enabled = enabled;
655     }
656 
657      /**
658      * @dev Set's new name
659      * @param _oldName Old name of the contract
660      * @param _newName New name of the contract
661      */
662     function setNewName(bytes32 _oldName, bytes32 _newName) external onlyOwner {
663         require(contracts[_newName].addr == address(0), "Contract's name should be unique");
664 
665         ContractRecord memory record = contracts[_oldName];
666         require(record.addr != address(0), "Contract's old name should be defined");
667 
668         record.name = _newName;
669         contracts[_newName] = record;
670         contractsName.push(_newName);
671 
672         delete contracts[_oldName];
673         contractsName = removeByValue(contractsName, _oldName);
674     }
675 
676     function removeByValue(bytes32[] memory _array, bytes32 _name) private pure returns(bytes32[]) {
677         uint i = 0;
678         uint j = 0;
679         bytes32[] memory outArray = new bytes32[](_array.length - 1);
680         while (i < _array.length) {
681             if(_array[i] != _name) {
682                 outArray[j] = _array[i];
683                 j++;
684             }
685             i++;
686         }
687         return outArray;
688     }
689 }