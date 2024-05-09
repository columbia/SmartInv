1 pragma solidity 0.4.21;
2 pragma experimental "v0.5.0";
3 
4 contract Owned {
5     address public owner;
6     address public newOwner;
7 
8     function Owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         assert(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address _newOwner) public onlyOwner {
18         require(_newOwner != owner);
19         newOwner = _newOwner;
20     }
21 
22     function acceptOwnership() public {
23         require(msg.sender == newOwner);
24         emit OwnerUpdate(owner, newOwner);
25         owner = newOwner;
26         newOwner = 0x0;
27     }
28 
29     event OwnerUpdate(address _prevOwner, address _newOwner);
30 }
31 
32 library SafeMath {
33 
34     /**
35     * @dev Multiplies two numbers, throws on overflow.*/
36     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
37         if (a == 0) {
38             return 0;
39         }
40         c = a * b;
41         assert(c / a == b);
42         return c;
43     }
44 
45     /**
46     * @dev Integer division of two numbers, truncating the quotient.
47     */
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         // assert(b > 0); // Solidity automatically throws when dividing by 0
50         // uint256 c = a / b;
51         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52         return a / b;
53     }
54 
55     /**
56     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57     */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         assert(b <= a);
60         return a - b;
61     }
62 
63     /**
64     * @dev Adds two numbers, throws on overflow.
65     */
66     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67         c = a + b;
68         assert(c >= a);
69         return c;
70     }
71 }
72 
73 interface ERC20TokenInterface {
74     function transfer(address _to, uint256 _value) external returns (bool success);
75     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
76     function approve(address _spender, uint256 _value) external returns (bool success);
77     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
78     function totalSupply() external view returns (uint256 _totalSupply);
79     function balanceOf(address _owner) external view returns (uint256 balance);
80 
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 }
84 
85 interface TokenVestingInterface {
86     function getReleasableFunds() external view returns (uint256);
87 
88     function release() external;
89 
90     function setWithdrawalAddress(address _newAddress) external;
91 
92     function revoke(string _reason) external view;
93 
94     function getTokenBalance() external view returns (uint256);
95 
96     function updateBalanceOnFunding(uint256 _amount) external;
97 
98     function salvageOtherTokensFromContract(address _tokenAddress, address _to, uint _amount) external;
99 
100     function salvageNotAllowedTokensSentToContract(address _to, uint _amount) external;
101 }
102 
103 interface VestingMasterInterface {
104     function amountLockedInVestings() view external returns (uint256);
105 
106     function substractLockedAmount(uint256 _amount) external;
107 
108     function addLockedAmount(uint256 _amount) external;
109 
110     function addInternalBalance(uint256 _amount) external;
111 }
112 
113 interface ReleasingScheduleInterface {
114     function getReleasableFunds(address _vesting) external view returns (uint256);
115 }
116 
117 /** @title Linear releasing schedule contract */
118 contract ReleasingScheduleLinearContract {
119     /** @dev Contains functionality for releasing funds linearly; set amount on set intervals until funds are available
120     * @param _startTime Start time of schedule (not first releas time)
121     * @param _tickDuration Interval of payouts
122     * @param _amountPerTick Amount to be released per interval
123     * @return created contracts address.
124     */
125     using SafeMath for uint256;
126     uint256 public startTime;
127     uint256 public tickDuration;
128     uint256 public amountPerTick;
129 
130     function ReleasingScheduleLinearContract(uint256 _startTime, uint256 _tickDuration, uint256 _amountPerTick) public{
131         startTime = _startTime;
132         tickDuration = _tickDuration;
133         amountPerTick = _amountPerTick;
134     }
135 
136     function getReleasableFunds(address _vesting) public view returns (uint256){
137         TokenVestingContract vesting = TokenVestingContract(_vesting);
138         uint256 balance = ERC20TokenInterface(vesting.tokenAddress()).balanceOf(_vesting);
139         // check if there is balance and if it is active yet
140         if (balance == 0 || (startTime >= now)) {
141             return 0;
142         }
143         // all funds that may be released according to vesting schedule 
144         uint256 vestingScheduleAmount = (now.sub(startTime) / tickDuration) * amountPerTick;
145         // deduct already released funds 
146         uint256 releasableFunds = vestingScheduleAmount.sub(vesting.alreadyReleasedAmount());
147         // make sure to release remainder of funds for last payout
148         if (releasableFunds > balance) {
149             releasableFunds = balance;
150         }
151         return releasableFunds;
152     }
153 }
154 
155 contract TgeOtherReleasingScheduleContract is ReleasingScheduleLinearContract {
156     uint256 constant releaseDate = 1578873600;
157     uint256 constant monthLength = 2592000;
158 
159     function TgeOtherReleasingScheduleContract(uint256 _amount, uint256 _startTime) ReleasingScheduleLinearContract(_startTime - monthLength, monthLength, _amount / 12) public {
160     }
161 
162     function getReleasableFunds(address _vesting) public view returns (uint256) {
163         if (now < releaseDate) {
164             return 0;
165         }
166         return super.getReleasableFunds(_vesting);
167     }
168 }
169 
170 contract TgeTeamReleasingScheduleContract {
171     uint256 constant releaseDate = 1578873600;
172 
173     function TgeTeamReleasingScheduleContract() public {}
174 
175     function getReleasableFunds(address _vesting) public view returns (uint256) {
176         TokenVestingContract vesting = TokenVestingContract(_vesting);
177         if (releaseDate >= now) {
178             return 0;
179         } else {
180             return vesting.getTokenBalance();
181         }
182 
183     }
184 }
185 
186 /** @title Vesting contract*/
187 contract TokenVestingContract is Owned {
188     /** @dev Contains basic vesting functionality. Uses releasing schedule to ascertain amount of funds to release
189     * @param _beneficiary Receiver of funds.
190     * @param _tokenAddress Address of token contract.
191     * @param _revocable Allows owner to terminate vesting, but all funds yet vested still go to beneficiary. Owner gets remainder of funds back.
192     * @param _changable Allows that releasing schedule and withdrawal address be changed. Essentialy rendering contract not binding.
193     * @param _releasingScheduleContract Address of scheduling contract, that implements getReleasableFunds() function
194     * @return created vesting's address.
195     */
196     using SafeMath for uint256;
197 
198     address public beneficiary;
199     address public tokenAddress;
200     bool public canReceiveTokens;
201     bool public revocable;  // 
202     bool public changable;  // allows that releasing schedule and withdrawal address be changed. Essentialy rendering contract not binding.
203     address public releasingScheduleContract;
204     bool fallbackTriggered;
205 
206     bool public revoked;
207     uint256 public alreadyReleasedAmount;
208     uint256 public internalBalance;
209 
210     event Released(uint256 _amount);
211     event RevokedAndDestroyed(string _reason);
212     event WithdrawalAddressSet(address _newAddress);
213     event TokensReceivedSinceLastCheck(uint256 _amount);
214     event VestingReceivedFunding(uint256 _amount);
215     event SetReleasingSchedule(address _addy);
216     event NotAllowedTokensReceived(uint256 amount);
217 
218     function TokenVestingContract(address _beneficiary, address _tokenAddress, bool _canReceiveTokens, bool _revocable, bool _changable, address _releasingScheduleContract) public {
219         beneficiary = _beneficiary;
220         tokenAddress = _tokenAddress;
221         canReceiveTokens = _canReceiveTokens;
222         revocable = _revocable;
223         changable = _changable;
224         releasingScheduleContract = _releasingScheduleContract;
225 
226         alreadyReleasedAmount = 0;
227         revoked = false;
228         internalBalance = 0;
229         fallbackTriggered = false;
230     }
231 
232     function setReleasingSchedule(address _releasingScheduleContract) external onlyOwner {
233         require(changable);
234         releasingScheduleContract = _releasingScheduleContract;
235 
236         emit SetReleasingSchedule(releasingScheduleContract);
237     }
238 
239     function setWithdrawalAddress(address _newAddress) external onlyOwner {
240         beneficiary = _newAddress;
241 
242         emit WithdrawalAddressSet(_newAddress);
243     }
244     /// release tokens that are already vested/releasable
245     function release() external returns (uint256 transferedAmount) {
246         checkForReceivedTokens();
247         require(msg.sender == beneficiary || msg.sender == owner);
248         uint256 amountToTransfer = ReleasingScheduleInterface(releasingScheduleContract).getReleasableFunds(this);
249         require(amountToTransfer > 0);
250         // internal accounting
251         alreadyReleasedAmount = alreadyReleasedAmount.add(amountToTransfer);
252         internalBalance = internalBalance.sub(amountToTransfer);
253         VestingMasterInterface(owner).substractLockedAmount(amountToTransfer);
254         // actual transfer
255         ERC20TokenInterface(tokenAddress).transfer(beneficiary, amountToTransfer);
256         emit Released(amountToTransfer);
257         return amountToTransfer;
258     }
259 
260     function revoke(string _reason) external onlyOwner {
261         require(revocable);
262         // returns funds not yet vested according to vesting schedule
263         uint256 releasableFunds = ReleasingScheduleInterface(releasingScheduleContract).getReleasableFunds(this);
264         ERC20TokenInterface(tokenAddress).transfer(beneficiary, releasableFunds);
265         VestingMasterInterface(owner).substractLockedAmount(releasableFunds);
266         // have to do it here, can't use return, because contract selfdestructs
267         // returns remainder of funds to VestingMaster and kill vesting contract
268         VestingMasterInterface(owner).addInternalBalance(getTokenBalance());
269         ERC20TokenInterface(tokenAddress).transfer(owner, getTokenBalance());
270         emit RevokedAndDestroyed(_reason);
271         selfdestruct(owner);
272     }
273 
274     function getTokenBalance() public view returns (uint256 tokenBalance) {
275         return ERC20TokenInterface(tokenAddress).balanceOf(address(this));
276     }
277     // master calls this when it uploads funds in order to differentiate betwen funds from master and 3rd party
278     function updateBalanceOnFunding(uint256 _amount) external onlyOwner {
279         internalBalance = internalBalance.add(_amount);
280         emit VestingReceivedFunding(_amount);
281     }
282     // check for changes in balance in order to track amount of locked tokens and notify master
283     function checkForReceivedTokens() public {
284         if (getTokenBalance() != internalBalance) {
285             uint256 receivedFunds = getTokenBalance().sub(internalBalance);
286             // if not allowed to receive tokens, do not account for them
287             if (canReceiveTokens) {
288                 internalBalance = getTokenBalance();
289                 VestingMasterInterface(owner).addLockedAmount(receivedFunds);
290             } else {
291                 emit NotAllowedTokensReceived(receivedFunds);
292             }
293             emit TokensReceivedSinceLastCheck(receivedFunds);
294         }
295         fallbackTriggered = true;
296     }
297 
298     function salvageOtherTokensFromContract(address _tokenAddress, address _to, uint _amount) external onlyOwner {
299         require(_tokenAddress != tokenAddress);
300         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
301     }
302 
303     function salvageNotAllowedTokensSentToContract(address _to, uint _amount) external onlyOwner {
304         // check if there are any new tokens
305         checkForReceivedTokens();
306         // only allow sending tokens, that were not allowed to be sent to contract
307         require(_amount <= getTokenBalance() - internalBalance);
308         ERC20TokenInterface(tokenAddress).transfer(_to, _amount);
309     }
310     function () external{
311         fallbackTriggered = true;
312     }
313 }
314 
315 contract VestingMasterContract is Owned {
316     using SafeMath for uint256;
317 
318     address public tokenAddress;
319     bool public canReceiveTokens;
320     address public moderator;
321     uint256 public internalBalance;
322     uint256 public amountLockedInVestings;
323     bool public fallbackTriggered;
324 
325     struct VestingStruct {
326         uint256 arrayPointer;
327         // custom data
328         address beneficiary;
329         address releasingScheduleContract;
330         string vestingType;
331         uint256 vestingVersion;
332     }
333 
334     address[] public vestingAddresses;
335     mapping(address => VestingStruct) public addressToVestingStruct;
336     mapping(address => address) public beneficiaryToVesting;
337 
338     event VestingContractFunded(address beneficiary, address tokenAddress, uint256 amount);
339     event LockedAmountDecreased(uint256 amount);
340     event LockedAmountIncreased(uint256 amount);
341     event TokensReceivedSinceLastCheck(uint256 amount);
342     event TokensReceivedWithApproval(uint256 amount, bytes extraData);
343     event NotAllowedTokensReceived(uint256 amount);
344 
345     function VestingMasterContract(address _tokenAddress, bool _canReceiveTokens) public{
346         tokenAddress = _tokenAddress;
347         canReceiveTokens = _canReceiveTokens;
348         internalBalance = 0;
349         amountLockedInVestings = 0;
350     }
351     // todo: make storage lib
352     ////////// STORAGE HELPERS  ///////////
353     function vestingExists(address _vestingAddress) public view returns (bool exists){
354         if (vestingAddresses.length == 0) {return false;}
355         return (vestingAddresses[addressToVestingStruct[_vestingAddress].arrayPointer] == _vestingAddress);
356     }
357 
358     function storeNewVesting(address _vestingAddress, address _beneficiary, address _releasingScheduleContract, string _vestingType, uint256 _vestingVersion) internal onlyOwner returns (uint256 vestingsLength) {
359         require(!vestingExists(_vestingAddress));
360         addressToVestingStruct[_vestingAddress].beneficiary = _beneficiary;
361         addressToVestingStruct[_vestingAddress].releasingScheduleContract = _releasingScheduleContract;
362         addressToVestingStruct[_vestingAddress].vestingType = _vestingType;
363         addressToVestingStruct[_vestingAddress].vestingVersion = _vestingVersion;
364         beneficiaryToVesting[_beneficiary] = _vestingAddress;
365         addressToVestingStruct[_vestingAddress].arrayPointer = vestingAddresses.push(_vestingAddress) - 1;
366         return vestingAddresses.length;
367     }
368 
369     function deleteVestingFromStorage(address _vestingAddress) internal onlyOwner returns (uint256 vestingsLength) {
370         require(vestingExists(_vestingAddress));
371         delete (beneficiaryToVesting[addressToVestingStruct[_vestingAddress].beneficiary]);
372         uint256 indexToDelete = addressToVestingStruct[_vestingAddress].arrayPointer;
373         address keyToMove = vestingAddresses[vestingAddresses.length - 1];
374         vestingAddresses[indexToDelete] = keyToMove;
375         addressToVestingStruct[keyToMove].arrayPointer = indexToDelete;
376         vestingAddresses.length--;
377         return vestingAddresses.length;
378     }
379 
380     function addVesting(address _vestingAddress, address _beneficiary, address _releasingScheduleContract, string _vestingType, uint256 _vestingVersion) public {
381         uint256 vestingBalance = TokenVestingInterface(_vestingAddress).getTokenBalance();
382         amountLockedInVestings = amountLockedInVestings.add(vestingBalance);
383         storeNewVesting(_vestingAddress, _beneficiary, _releasingScheduleContract, _vestingType, _vestingVersion);
384     }
385 
386     /// releases funds to beneficiary
387     function releaseVesting(address _vestingContract) external {
388         require(vestingExists(_vestingContract));
389         require(msg.sender == addressToVestingStruct[_vestingContract].beneficiary || msg.sender == owner || msg.sender == moderator);
390         TokenVestingInterface(_vestingContract).release();
391     }
392     /// Transfers releasable funds from vesting to beneficiary (caller of this method)
393     function releaseMyTokens() external {
394         address vesting = beneficiaryToVesting[msg.sender];
395         require(vesting != 0);
396         TokenVestingInterface(vesting).release();
397     }
398 
399     // add funds to vesting contract
400     function fundVesting(address _vestingContract, uint256 _amount) public onlyOwner {
401         // convenience, so you don't have to call it manualy if you just uploaded funds
402         checkForReceivedTokens();
403         // check if there is actually enough funds
404         require((internalBalance >= _amount) && (getTokenBalance() >= _amount));
405         // make sure that fundee is vesting contract on the list
406         require(vestingExists(_vestingContract));
407         internalBalance = internalBalance.sub(_amount);
408         ERC20TokenInterface(tokenAddress).transfer(_vestingContract, _amount);
409         TokenVestingInterface(_vestingContract).updateBalanceOnFunding(_amount);
410         emit VestingContractFunded(_vestingContract, tokenAddress, _amount);
411     }
412 
413     function getTokenBalance() public constant returns (uint256) {
414         return ERC20TokenInterface(tokenAddress).balanceOf(address(this));
415     }
416     // revoke vesting; release releasable funds to beneficiary and return remaining to master and kill vesting contract
417     function revokeVesting(address _vestingContract, string _reason) external onlyOwner {
418         TokenVestingInterface subVestingContract = TokenVestingInterface(_vestingContract);
419         subVestingContract.revoke(_reason);
420         deleteVestingFromStorage(_vestingContract);
421     }
422     // when vesting is revoked it sends back remaining tokens and updates internalBalance
423     function addInternalBalance(uint256 _amount) external {
424         require(vestingExists(msg.sender));
425         internalBalance = internalBalance.add(_amount);
426     }
427     // vestings notifies if there has been any changes in amount of locked tokens
428     function addLockedAmount(uint256 _amount) external {
429         require(vestingExists(msg.sender));
430         amountLockedInVestings = amountLockedInVestings.add(_amount);
431         emit LockedAmountIncreased(_amount);
432     }
433     // vestings notifies if there has been any changes in amount of locked tokens
434     function substractLockedAmount(uint256 _amount) external {
435         require(vestingExists(msg.sender));
436         amountLockedInVestings = amountLockedInVestings.sub(_amount);
437         emit LockedAmountDecreased(_amount);
438     }
439     // check for changes in balance in order to track amount of locked tokens
440     function checkForReceivedTokens() public {
441         if (getTokenBalance() != internalBalance) {
442             uint256 receivedFunds = getTokenBalance().sub(internalBalance);
443             if (canReceiveTokens) {
444                 amountLockedInVestings = amountLockedInVestings.add(receivedFunds);
445                 internalBalance = getTokenBalance();
446             }
447             else {
448                 emit NotAllowedTokensReceived(receivedFunds);
449             }
450             emit TokensReceivedSinceLastCheck(receivedFunds);
451         } else {
452             emit TokensReceivedSinceLastCheck(0);
453         }
454         fallbackTriggered = false;
455     }
456 
457     function salvageNotAllowedTokensSentToContract(address _contractFrom, address _to, uint _amount) external onlyOwner {
458         if (_contractFrom == address(this)) {
459             // check if there are any new tokens
460             checkForReceivedTokens();
461             // only allow sending tokens, that were not allowed to be sent to contract
462             require(_amount <= getTokenBalance() - internalBalance);
463             ERC20TokenInterface(tokenAddress).transfer(_to, _amount);
464         }
465         if (vestingExists(_contractFrom)) {
466             TokenVestingInterface(_contractFrom).salvageNotAllowedTokensSentToContract(_to, _amount);
467         }
468     }
469 
470     function salvageOtherTokensFromContract(address _tokenAddress, address _contractAddress, address _to, uint _amount) external onlyOwner {
471         require(_tokenAddress != tokenAddress);
472         if (_contractAddress == address(this)) {
473             ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
474         }
475         if (vestingExists(_contractAddress)) {
476             TokenVestingInterface(_contractAddress).salvageOtherTokensFromContract(_tokenAddress, _to, _amount);
477         }
478     }
479 
480     function killContract() external onlyOwner {
481         require(vestingAddresses.length == 0);
482         ERC20TokenInterface(tokenAddress).transfer(owner, getTokenBalance());
483         selfdestruct(owner);
484     }
485 
486     function setWithdrawalAddress(address _vestingContract, address _beneficiary) external {
487         require(vestingExists(_vestingContract));
488         TokenVestingContract vesting = TokenVestingContract(_vestingContract);
489         // withdrawal address can be changed only by beneficiary or in case vesting is changable also by owner
490         require(msg.sender == vesting.beneficiary() || (msg.sender == owner && vesting.changable()));
491         TokenVestingInterface(_vestingContract).setWithdrawalAddress(_beneficiary);
492         addressToVestingStruct[_vestingContract].beneficiary = _beneficiary;
493     }
494 
495     function receiveApproval(address _from, uint256 _amount, address _tokenAddress, bytes _extraData) external {
496         require(canReceiveTokens);
497         require(_tokenAddress == tokenAddress);
498         ERC20TokenInterface(_tokenAddress).transferFrom(_from, address(this), _amount);
499         amountLockedInVestings = amountLockedInVestings.add(_amount);
500         internalBalance = internalBalance.add(_amount);
501         emit TokensReceivedWithApproval(_amount, _extraData);
502     }
503 
504     // Deploys a vesting contract to _beneficiary. Assumes that a releasing
505     // schedule contract has already been deployed, so we pass it the address
506     // of that contract as _releasingSchedule
507     function deployVesting(
508         address _beneficiary,
509         string _vestingType,
510         uint256 _vestingVersion,
511         bool _canReceiveTokens,
512         bool _revocable,
513         bool _changable,
514         address _releasingSchedule
515     ) public onlyOwner {
516         TokenVestingContract newVesting = new TokenVestingContract(_beneficiary, tokenAddress, _canReceiveTokens, _revocable, _changable, _releasingSchedule);
517         addVesting(newVesting, _beneficiary, _releasingSchedule, _vestingType, _vestingVersion);
518     }
519 
520     function deployOtherVesting(
521         address _beneficiary,
522         uint256 _amount,
523         uint256 _startTime
524     ) public onlyOwner {
525         TgeOtherReleasingScheduleContract releasingSchedule = new TgeOtherReleasingScheduleContract(_amount, _startTime);
526         TokenVestingContract newVesting = new TokenVestingContract(_beneficiary, tokenAddress, true, true, true, releasingSchedule);
527         addVesting(newVesting, _beneficiary, releasingSchedule, 'other', 1);
528         fundVesting(newVesting, _amount);
529     }
530 
531     function deployTgeTeamVesting(
532     address _beneficiary,
533     uint256 _amount
534     ) public onlyOwner {
535         TgeTeamReleasingScheduleContract releasingSchedule = new TgeTeamReleasingScheduleContract();
536         TokenVestingContract newVesting = new TokenVestingContract(_beneficiary, tokenAddress, true, true, true, releasingSchedule);
537         addVesting(newVesting, _beneficiary, releasingSchedule, 'X8 team', 1);
538         fundVesting(newVesting, _amount);
539     }
540 
541 
542     /**
543     * Used to transfer ownership of a vesting contract to this master contract.
544     * The vesting contracts require that the master contract be their owner.
545     * Use this when you deploy a TokenVestingContract manually and need to transfer
546     * ownership to this master contract. First call transferOwnership on the vesting
547     * contract.
548     * @param _vesting the vesting contract of which to accept ownership.
549     */
550     function acceptOwnershipOfVesting(address _vesting) external onlyOwner {
551         TokenVestingContract(_vesting).acceptOwnership();
552     }
553 
554     function setModerator(address _moderator) external onlyOwner {
555         moderator = _moderator;
556     }
557 
558     function () external{
559         fallbackTriggered = true;
560     }
561 }