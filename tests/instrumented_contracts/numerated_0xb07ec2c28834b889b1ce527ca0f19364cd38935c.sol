1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    */
79   function renounceOwnership() public onlyOwner {
80     emit OwnershipRenounced(owner);
81     owner = address(0);
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address _newOwner) public onlyOwner {
89     _transferOwnership(_newOwner);
90   }
91 
92   /**
93    * @dev Transfers control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function _transferOwnership(address _newOwner) internal {
97     require(_newOwner != address(0));
98     emit OwnershipTransferred(owner, _newOwner);
99     owner = _newOwner;
100   }
101 }
102 
103 interface ITokenLedger {
104   function totalTokens() external view returns (uint256);
105   function totalInCirculation() external view returns (uint256);
106   function balanceOf(address account) external view returns (uint256);
107   function mintTokens(uint256 amount) external;
108   function transfer(address sender, address reciever, uint256 amount) external;
109   function creditAccount(address account, uint256 amount) external;
110   function debitAccount(address account, uint256 amount) external;
111   function addAdmin(address admin) external;
112   function removeAdmin(address admin) external;
113 }
114 
115 library CstLibrary {
116   using SafeMath for uint256;
117 
118   function getTokenName(address _storage) public view returns(bytes32) {
119     return ExternalStorage(_storage).getBytes32Value("cstTokenName");
120   }
121 
122   function setTokenName(address _storage, bytes32 tokenName) public {
123     ExternalStorage(_storage).setBytes32Value("cstTokenName", tokenName);
124   }
125 
126   function getTokenSymbol(address _storage) public view returns(bytes32) {
127     return ExternalStorage(_storage).getBytes32Value("cstTokenSymbol");
128   }
129 
130   function setTokenSymbol(address _storage, bytes32 tokenName) public {
131     ExternalStorage(_storage).setBytes32Value("cstTokenSymbol", tokenName);
132   }
133 
134   function getBuyPrice(address _storage) public view returns(uint256) {
135     return ExternalStorage(_storage).getUIntValue("cstBuyPrice");
136   }
137 
138   function setBuyPrice(address _storage, uint256 value) public {
139     ExternalStorage(_storage).setUIntValue("cstBuyPrice", value);
140   }
141 
142   function getCirculationCap(address _storage) public view returns(uint256) {
143     return ExternalStorage(_storage).getUIntValue("cstCirculationCap");
144   }
145 
146   function setCirculationCap(address _storage, uint256 value) public {
147     ExternalStorage(_storage).setUIntValue("cstCirculationCap", value);
148   }
149 
150   function getBalanceLimit(address _storage) public view returns(uint256) {
151     return ExternalStorage(_storage).getUIntValue("cstBalanceLimit");
152   }
153 
154   function setBalanceLimit(address _storage, uint256 value) public {
155     ExternalStorage(_storage).setUIntValue("cstBalanceLimit", value);
156   }
157 
158   function getFoundation(address _storage) public view returns(address) {
159     return ExternalStorage(_storage).getAddressValue("cstFoundation");
160   }
161 
162   function setFoundation(address _storage, address value) public {
163     ExternalStorage(_storage).setAddressValue("cstFoundation", value);
164   }
165 
166   function getAllowance(address _storage, address account, address spender) public view returns (uint256) {
167     return ExternalStorage(_storage).getMultiLedgerValue("cstAllowance", account, spender);
168   }
169 
170   function setAllowance(address _storage, address account, address spender, uint256 allowance) public {
171     ExternalStorage(_storage).setMultiLedgerValue("cstAllowance", account, spender, allowance);
172   }
173 
174   function getCustomBuyerLimit(address _storage, address buyer) public view returns (uint256) {
175     return ExternalStorage(_storage).getLedgerValue("cstCustomBuyerLimit", buyer);
176   }
177 
178   function setCustomBuyerLimit(address _storage, address buyer, uint256 value) public {
179     ExternalStorage(_storage).setLedgerValue("cstCustomBuyerLimit", buyer, value);
180   }
181 
182   function getCustomBuyerForIndex(address _storage, uint256 index) public view returns (address) {
183     return ExternalStorage(_storage).ledgerEntryForIndex(keccak256("cstCustomBuyerLimit"), index);
184   }
185 
186   function getCustomBuyerMappingCount(address _storage) public view returns(uint256) {
187     return ExternalStorage(_storage).getLedgerCount("cstCustomBuyerLimit");
188   }
189 
190   function getApprovedBuyer(address _storage, address buyer) public view returns (bool) {
191     return ExternalStorage(_storage).getBooleanMapValue("cstApprovedBuyer", buyer);
192   }
193 
194   function setApprovedBuyer(address _storage, address buyer, bool value) public {
195     ExternalStorage(_storage).setBooleanMapValue("cstApprovedBuyer", buyer, value);
196   }
197 
198   function getApprovedBuyerForIndex(address _storage, uint256 index) public view returns (address) {
199     return ExternalStorage(_storage).booleanMapEntryForIndex(keccak256("cstApprovedBuyer"), index);
200   }
201 
202   function getApprovedBuyerMappingCount(address _storage) public view returns(uint256) {
203     return ExternalStorage(_storage).getBooleanMapCount("cstApprovedBuyer");
204   }
205 
206   function getTotalUnvestedAndUnreleasedTokens(address _storage) public view returns(uint256) {
207     return ExternalStorage(_storage).getUIntValue("cstUnvestedAndUnreleasedTokens");
208   }
209 
210   function setTotalUnvestedAndUnreleasedTokens(address _storage, uint256 value) public {
211     ExternalStorage(_storage).setUIntValue("cstUnvestedAndUnreleasedTokens", value);
212   }
213 
214   function vestingMappingSize(address _storage) public view returns(uint256) {
215     return ExternalStorage(_storage).getLedgerCount("cstFullyVestedAmount");
216   }
217 
218   function vestingBeneficiaryForIndex(address _storage, uint256 index) public view returns(address) {
219     return ExternalStorage(_storage).ledgerEntryForIndex(keccak256("cstFullyVestedAmount"), index);
220   }
221 
222   function releasableAmount(address _storage, address beneficiary) public view returns (uint256) {
223     uint256 releasedAmount = getVestingReleasedAmount(_storage, beneficiary);
224     return vestedAvailableAmount(_storage, beneficiary).sub(releasedAmount);
225   }
226 
227   function vestedAvailableAmount(address _storage, address beneficiary) public view returns (uint256) {
228     uint256 start = getVestingStart(_storage, beneficiary);
229     uint256 fullyVestedAmount = getFullyVestedAmount(_storage, beneficiary);
230 
231     if (start == 0 || fullyVestedAmount == 0) {
232       return 0;
233     }
234 
235     uint256 duration = getVestingDuration(_storage, beneficiary);
236     if (duration == 0) {
237       return 0;
238     }
239     uint256 cliff = getVestingCliff(_storage, beneficiary);
240     uint256 revokeDate = getVestingRevokeDate(_storage, beneficiary);
241 
242     if (now < cliff || (revokeDate > 0 && revokeDate < cliff)) {
243       return 0;
244     } else if (revokeDate > 0 && revokeDate > cliff) {
245       return fullyVestedAmount.mul(revokeDate.sub(start)).div(duration);
246     } else if (now >= start.add(duration)) {
247       return fullyVestedAmount;
248     } else {
249       return fullyVestedAmount.mul(now.sub(start)).div(duration);
250     }
251   }
252 
253   function vestedAmount(address _storage, address beneficiary) public view returns (uint256) {
254     uint256 start = getVestingStart(_storage, beneficiary);
255     uint256 fullyVestedAmount = getFullyVestedAmount(_storage, beneficiary);
256 
257     if (start == 0 || fullyVestedAmount == 0) {
258       return 0;
259     }
260 
261     uint256 duration = getVestingDuration(_storage, beneficiary);
262     if (duration == 0) {
263       return 0;
264     }
265 
266     uint256 revokeDate = getVestingRevokeDate(_storage, beneficiary);
267 
268     if (now <= start) {
269       return 0;
270     } else if (revokeDate > 0) {
271       return fullyVestedAmount.mul(revokeDate.sub(start)).div(duration);
272     } else if (now >= start.add(duration)) {
273       return fullyVestedAmount;
274     } else {
275       return fullyVestedAmount.mul(now.sub(start)).div(duration);
276     }
277   }
278 
279   function canGrantVestedTokens(address _storage, address beneficiary) public view returns (bool) {
280     uint256 existingFullyVestedAmount = getFullyVestedAmount(_storage, beneficiary);
281     if (existingFullyVestedAmount == 0) {
282       return true;
283     }
284 
285     uint256 existingVestedAmount = vestedAvailableAmount(_storage, beneficiary);
286     uint256 existingReleasedAmount = getVestingReleasedAmount(_storage, beneficiary);
287     uint256 revokeDate = getVestingRevokeDate(_storage, beneficiary);
288 
289     if (revokeDate > 0 ||
290         (existingVestedAmount == existingFullyVestedAmount &&
291         existingReleasedAmount == existingFullyVestedAmount)) {
292       return true;
293     }
294 
295     return false;
296   }
297 
298   function canRevokeVesting(address _storage, address beneficiary) public view returns (bool) {
299     bool isRevocable = getVestingRevocable(_storage, beneficiary);
300     uint256 revokeDate = getVestingRevokeDate(_storage, beneficiary);
301     uint256 start = getVestingStart(_storage, beneficiary);
302     uint256 duration = getVestingDuration(_storage, beneficiary);
303 
304     return start > 0 &&
305            isRevocable &&
306            revokeDate == 0 &&
307            now < start.add(duration);
308   }
309 
310   function revokeVesting(address _storage, address beneficiary) public {
311     require(canRevokeVesting(_storage, beneficiary));
312 
313     uint256 totalUnvestedAndUnreleasedAmount = getTotalUnvestedAndUnreleasedTokens(_storage);
314     uint256 unvestedAmount = getFullyVestedAmount(_storage, beneficiary).sub(vestedAvailableAmount(_storage, beneficiary));
315 
316     setVestingRevokeDate(_storage, beneficiary, now);
317     setTotalUnvestedAndUnreleasedTokens(_storage, totalUnvestedAndUnreleasedAmount.sub(unvestedAmount));
318   }
319 
320   function getVestingSchedule(address _storage, address _beneficiary) public
321                                                                       view returns (uint256 startDate,
322                                                                                         uint256 cliffDate,
323                                                                                         uint256 durationSec,
324                                                                                         uint256 fullyVestedAmount,
325                                                                                         uint256 releasedAmount,
326                                                                                         uint256 revokeDate,
327                                                                                         bool isRevocable) {
328     startDate         = getVestingStart(_storage, _beneficiary);
329     cliffDate         = getVestingCliff(_storage, _beneficiary);
330     durationSec       = getVestingDuration(_storage, _beneficiary);
331     fullyVestedAmount = getFullyVestedAmount(_storage, _beneficiary);
332     releasedAmount    = getVestingReleasedAmount(_storage, _beneficiary);
333     revokeDate        = getVestingRevokeDate(_storage, _beneficiary);
334     isRevocable       = getVestingRevocable(_storage, _beneficiary);
335   }
336 
337   function setVestingSchedule(address _storage,
338                               address beneficiary,
339                               uint256 fullyVestedAmount,
340                               uint256 startDate,
341                               uint256 cliffDate,
342                               uint256 duration,
343                               bool isRevocable) public {
344     require(canGrantVestedTokens(_storage, beneficiary));
345 
346     uint256 totalUnvestedAndUnreleasedAmount = getTotalUnvestedAndUnreleasedTokens(_storage);
347     setTotalUnvestedAndUnreleasedTokens(_storage, totalUnvestedAndUnreleasedAmount.add(fullyVestedAmount));
348 
349     ExternalStorage(_storage).setLedgerValue("cstVestingStart", beneficiary, startDate);
350     ExternalStorage(_storage).setLedgerValue("cstVestingCliff", beneficiary, cliffDate);
351     ExternalStorage(_storage).setLedgerValue("cstVestingDuration", beneficiary, duration);
352     ExternalStorage(_storage).setLedgerValue("cstFullyVestedAmount", beneficiary, fullyVestedAmount);
353     ExternalStorage(_storage).setBooleanMapValue("cstVestingRevocable", beneficiary, isRevocable);
354 
355     setVestingRevokeDate(_storage, beneficiary, 0);
356     setVestingReleasedAmount(_storage, beneficiary, 0);
357   }
358 
359   function releaseVestedTokens(address _storage, address beneficiary) public {
360     uint256 unreleased = releasableAmount(_storage, beneficiary);
361     uint256 releasedAmount = getVestingReleasedAmount(_storage, beneficiary);
362     uint256 totalUnvestedAndUnreleasedAmount = getTotalUnvestedAndUnreleasedTokens(_storage);
363 
364     releasedAmount = releasedAmount.add(unreleased);
365     setVestingReleasedAmount(_storage, beneficiary, releasedAmount);
366     setTotalUnvestedAndUnreleasedTokens(_storage, totalUnvestedAndUnreleasedAmount.sub(unreleased));
367   }
368 
369   function getVestingStart(address _storage, address beneficiary) public view returns(uint256) {
370     return ExternalStorage(_storage).getLedgerValue("cstVestingStart", beneficiary);
371   }
372 
373   function getVestingCliff(address _storage, address beneficiary) public view returns(uint256) {
374     return ExternalStorage(_storage).getLedgerValue("cstVestingCliff", beneficiary);
375   }
376 
377   function getVestingDuration(address _storage, address beneficiary) public view returns(uint256) {
378     return ExternalStorage(_storage).getLedgerValue("cstVestingDuration", beneficiary);
379   }
380 
381   function getFullyVestedAmount(address _storage, address beneficiary) public view returns(uint256) {
382     return ExternalStorage(_storage).getLedgerValue("cstFullyVestedAmount", beneficiary);
383   }
384 
385   function getVestingRevocable(address _storage, address beneficiary) public view returns(bool) {
386     return ExternalStorage(_storage).getBooleanMapValue("cstVestingRevocable", beneficiary);
387   }
388 
389   function setVestingReleasedAmount(address _storage, address beneficiary, uint256 value) public {
390     ExternalStorage(_storage).setLedgerValue("cstVestingReleasedAmount", beneficiary, value);
391   }
392 
393   function getVestingReleasedAmount(address _storage, address beneficiary) public view returns(uint256) {
394     return ExternalStorage(_storage).getLedgerValue("cstVestingReleasedAmount", beneficiary);
395   }
396 
397   function setVestingRevokeDate(address _storage, address beneficiary, uint256 value) public {
398     ExternalStorage(_storage).setLedgerValue("cstVestingRevokeDate", beneficiary, value);
399   }
400 
401   function getVestingRevokeDate(address _storage, address beneficiary) public view returns(uint256) {
402     return ExternalStorage(_storage).getLedgerValue("cstVestingRevokeDate", beneficiary);
403   }
404 
405   function getRewardsContractHash(address _storage) public view returns (bytes32) {
406     return ExternalStorage(_storage).getBytes32Value("cstRewardsContractHash");
407   }
408 
409   function setRewardsContractHash(address _storage, bytes32 rewardsContractHash) public {
410     ExternalStorage(_storage).setBytes32Value("cstRewardsContractHash", rewardsContractHash);
411   }
412 
413 }
414 
415 contract ERC20 {
416   function allowance(address owner, address spender) public view returns (uint256);
417   function transferFrom(address from, address to, uint256 value) public returns (bool);
418   function approve(address spender, uint256 value) public returns (bool);
419   function totalSupply() public view returns (uint256);
420   function balanceOf(address account) public view returns (uint256);
421   function transfer(address to, uint256 value) public returns (bool);
422   event Transfer(address indexed _from, address indexed _to, uint256 _value);
423   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
424 }
425 
426 contract administratable is Ownable {
427   using SafeMath for uint256;
428 
429   address[] public adminsForIndex;
430   address[] public superAdminsForIndex;
431   mapping (address => bool) public admins;
432   mapping (address => bool) public superAdmins;
433   mapping (address => bool) private processedAdmin;
434   mapping (address => bool) private processedSuperAdmin;
435 
436   event AddAdmin(address indexed admin);
437   event RemoveAdmin(address indexed admin);
438   event AddSuperAdmin(address indexed admin);
439   event RemoveSuperAdmin(address indexed admin);
440 
441   modifier onlyAdmins {
442     if (msg.sender != owner && !superAdmins[msg.sender] && !admins[msg.sender]) revert();
443     _;
444   }
445 
446   modifier onlySuperAdmins {
447     if (msg.sender != owner && !superAdmins[msg.sender]) revert();
448     _;
449   }
450 
451   function totalSuperAdminsMapping() public view returns (uint256) {
452     return superAdminsForIndex.length;
453   }
454 
455   function addSuperAdmin(address admin) public onlySuperAdmins {
456     require(admin != address(0));
457     superAdmins[admin] = true;
458     if (!processedSuperAdmin[admin]) {
459       superAdminsForIndex.push(admin);
460       processedSuperAdmin[admin] = true;
461     }
462 
463     emit AddSuperAdmin(admin);
464   }
465 
466   function removeSuperAdmin(address admin) public onlySuperAdmins {
467     require(admin != address(0));
468     superAdmins[admin] = false;
469 
470     emit RemoveSuperAdmin(admin);
471   }
472 
473   function totalAdminsMapping() public view returns (uint256) {
474     return adminsForIndex.length;
475   }
476 
477   function addAdmin(address admin) public onlySuperAdmins {
478     require(admin != address(0));
479     admins[admin] = true;
480     if (!processedAdmin[admin]) {
481       adminsForIndex.push(admin);
482       processedAdmin[admin] = true;
483     }
484 
485     emit AddAdmin(admin);
486   }
487 
488   function removeAdmin(address admin) public onlySuperAdmins {
489     require(admin != address(0));
490     admins[admin] = false;
491 
492     emit RemoveAdmin(admin);
493   }
494 }
495 
496 contract CstLedger is ITokenLedger, administratable {
497 
498   using SafeMath for uint256;
499 
500   uint256 private _totalInCirculation; // warning this does not take into account unvested nor vested-unreleased tokens into consideration
501   uint256 private _totalTokens;
502   mapping (address => uint256) private _balanceOf;
503   mapping (address => bool) private accounts;
504   address[] public accountForIndex;
505 
506   function totalTokens() external view returns (uint256) {
507     return _totalTokens;
508   }
509 
510   function totalInCirculation() external view returns (uint256) {
511     return _totalInCirculation;
512   }
513 
514   function balanceOf(address account) external view returns (uint256) {
515     return _balanceOf[account];
516   }
517 
518   function mintTokens(uint256 amount) external onlyAdmins {
519     _totalTokens = _totalTokens.add(amount);
520   }
521 
522   function ledgerCount() external view returns (uint256) {
523     return accountForIndex.length;
524   }
525 
526   function makeAccountIterable(address account) internal {
527     if (!accounts[account]) {
528       accountForIndex.push(account);
529       accounts[account] = true;
530     }
531   }
532 
533   function transfer(address sender, address recipient, uint256 amount) external onlyAdmins {
534     require(sender != address(0));
535     require(recipient != address(0));
536     require(_balanceOf[sender] >= amount);
537 
538     _balanceOf[sender] = _balanceOf[sender].sub(amount);
539     _balanceOf[recipient] = _balanceOf[recipient].add(amount);
540     makeAccountIterable(recipient);
541   }
542 
543   function creditAccount(address account, uint256 amount) external onlyAdmins { // remove tokens
544     require(account != address(0));
545     require(_balanceOf[account] >= amount);
546 
547     _totalInCirculation = _totalInCirculation.sub(amount);
548     _balanceOf[account] = _balanceOf[account].sub(amount);
549   }
550 
551   function debitAccount(address account, uint256 amount) external onlyAdmins { // add tokens
552     require(account != address(0));
553     _totalInCirculation = _totalInCirculation.add(amount);
554     _balanceOf[account] = _balanceOf[account].add(amount);
555     makeAccountIterable(account);
556   }
557 }
558 
559 contract ExternalStorage is administratable {
560   using SafeMath for uint256;
561 
562   mapping(bytes32 => address[]) public primaryLedgerEntryForIndex;
563   mapping(bytes32 => mapping(address => address[])) public secondaryLedgerEntryForIndex;
564   mapping(bytes32 => mapping(address => mapping(address => uint256))) private MultiLedgerStorage;
565   mapping(bytes32 => mapping(address => bool)) private ledgerPrimaryEntries;
566   mapping(bytes32 => mapping(address => mapping(address => bool))) private ledgerSecondaryEntries;
567 
568   function getMultiLedgerValue(string record, address primaryAddress, address secondaryAddress) external view returns (uint256) {
569     return MultiLedgerStorage[keccak256(abi.encodePacked(record))][primaryAddress][secondaryAddress];
570   }
571 
572   function primaryLedgerCount(string record) external view returns (uint256) {
573     return primaryLedgerEntryForIndex[keccak256(abi.encodePacked(record))].length;
574   }
575 
576   function secondaryLedgerCount(string record, address primaryAddress) external view returns (uint256) {
577     return secondaryLedgerEntryForIndex[keccak256(abi.encodePacked(record))][primaryAddress].length;
578   }
579 
580   function setMultiLedgerValue(string record, address primaryAddress, address secondaryAddress, uint256 value) external onlyAdmins {
581     bytes32 hash = keccak256(abi.encodePacked(record));
582     if (!ledgerSecondaryEntries[hash][primaryAddress][secondaryAddress]) {
583       secondaryLedgerEntryForIndex[hash][primaryAddress].push(secondaryAddress);
584       ledgerSecondaryEntries[hash][primaryAddress][secondaryAddress] = true;
585 
586       if (!ledgerPrimaryEntries[hash][primaryAddress]) {
587         primaryLedgerEntryForIndex[hash].push(primaryAddress);
588         ledgerPrimaryEntries[hash][primaryAddress] = true;
589       }
590     }
591 
592     MultiLedgerStorage[hash][primaryAddress][secondaryAddress] = value;
593   }
594 
595   mapping(bytes32 => address[]) public ledgerEntryForIndex;
596   mapping(bytes32 => mapping(address => uint256)) private LedgerStorage;
597   mapping(bytes32 => mapping(address => bool)) private ledgerAccounts;
598 
599   function getLedgerValue(string record, address _address) external view returns (uint256) {
600     return LedgerStorage[keccak256(abi.encodePacked(record))][_address];
601   }
602 
603   function getLedgerCount(string record) external view returns (uint256) {
604     return ledgerEntryForIndex[keccak256(abi.encodePacked(record))].length;
605   }
606 
607   function setLedgerValue(string record, address _address, uint256 value) external onlyAdmins {
608     bytes32 hash = keccak256(abi.encodePacked(record));
609     if (!ledgerAccounts[hash][_address]) {
610       ledgerEntryForIndex[hash].push(_address);
611       ledgerAccounts[hash][_address] = true;
612     }
613 
614     LedgerStorage[hash][_address] = value;
615   }
616 
617   mapping(bytes32 => address[]) public booleanMapEntryForIndex;
618   mapping(bytes32 => mapping(address => bool)) private BooleanMapStorage;
619   mapping(bytes32 => mapping(address => bool)) private booleanMapAccounts;
620 
621   function getBooleanMapValue(string record, address _address) external view returns (bool) {
622     return BooleanMapStorage[keccak256(abi.encodePacked(record))][_address];
623   }
624 
625   function getBooleanMapCount(string record) external view returns (uint256) {
626     return booleanMapEntryForIndex[keccak256(abi.encodePacked(record))].length;
627   }
628 
629   function setBooleanMapValue(string record, address _address, bool value) external onlyAdmins {
630     bytes32 hash = keccak256(abi.encodePacked(record));
631     if (!booleanMapAccounts[hash][_address]) {
632       booleanMapEntryForIndex[hash].push(_address);
633       booleanMapAccounts[hash][_address] = true;
634     }
635 
636     BooleanMapStorage[hash][_address] = value;
637   }
638 
639   mapping(bytes32 => uint256) private UIntStorage;
640 
641   function getUIntValue(string record) external view returns (uint256) {
642     return UIntStorage[keccak256(abi.encodePacked(record))];
643   }
644 
645   function setUIntValue(string record, uint256 value) external onlyAdmins {
646     UIntStorage[keccak256(abi.encodePacked(record))] = value;
647   }
648 
649   mapping(bytes32 => bytes32) private Bytes32Storage;
650 
651   function getBytes32Value(string record) external view returns (bytes32) {
652     return Bytes32Storage[keccak256(abi.encodePacked(record))];
653   }
654 
655   function setBytes32Value(string record, bytes32 value) external onlyAdmins {
656     Bytes32Storage[keccak256(abi.encodePacked(record))] = value;
657   }
658 
659   mapping(bytes32 => address) private AddressStorage;
660 
661   function getAddressValue(string record) external view returns (address) {
662     return AddressStorage[keccak256(abi.encodePacked(record))];
663   }
664 
665   function setAddressValue(string record, address value) external onlyAdmins {
666     AddressStorage[keccak256(abi.encodePacked(record))] = value;
667   }
668 
669   mapping(bytes32 => bytes) private BytesStorage;
670 
671   function getBytesValue(string record) external view returns (bytes) {
672     return BytesStorage[keccak256(abi.encodePacked(record))];
673   }
674 
675   function setBytesValue(string record, bytes value) external onlyAdmins {
676     BytesStorage[keccak256(abi.encodePacked(record))] = value;
677   }
678 
679   mapping(bytes32 => bool) private BooleanStorage;
680 
681   function getBooleanValue(string record) external view returns (bool) {
682     return BooleanStorage[keccak256(abi.encodePacked(record))];
683   }
684 
685   function setBooleanValue(string record, bool value) external onlyAdmins {
686     BooleanStorage[keccak256(abi.encodePacked(record))] = value;
687   }
688 
689   mapping(bytes32 => int256) private IntStorage;
690 
691   function getIntValue(string record) external view returns (int256) {
692     return IntStorage[keccak256(abi.encodePacked(record))];
693   }
694 
695   function setIntValue(string record, int256 value) external onlyAdmins {
696     IntStorage[keccak256(abi.encodePacked(record))] = value;
697   }
698 }
699 
700 contract configurable {
701   function configureFromStorage() public returns (bool);
702 }
703 
704 contract displayable {
705   function bytes32ToString(bytes32 x) public pure returns (string) {
706     bytes memory bytesString = new bytes(32);
707     uint256 charCount = 0;
708     for (uint256 j = 0; j < 32; j++) {
709       if (x[j] != 0) {
710         bytesString[charCount] = x[j];
711         charCount++;
712       }
713     }
714     bytes memory bytesStringTrimmed = new bytes(charCount);
715     for (j = 0; j < charCount; j++) {
716       bytesStringTrimmed[j] = bytesString[j];
717     }
718     return string(bytesStringTrimmed);
719   }
720 }
721 
722 contract freezable is administratable {
723   using SafeMath for uint256;
724 
725   bool public frozenToken;
726   // TODO move this into external storage
727   address[] public frozenAccountForIndex;
728   mapping (address => bool) public frozenAccount;
729   mapping (address => bool) private processedAccount;
730 
731   event FrozenFunds(address indexed target, bool frozen);
732   event FrozenToken(bool frozen);
733 
734   modifier unlessFrozen {
735     require(!frozenToken);
736     require(!frozenAccount[msg.sender]);
737     _;
738   }
739 
740   function totalFrozenAccountsMapping() public view returns(uint256) {
741     return frozenAccountForIndex.length;
742   }
743 
744   function freezeAccount(address target, bool freeze) public onlySuperAdmins {
745     frozenAccount[target] = freeze;
746     if (!processedAccount[target]) {
747       frozenAccountForIndex.push(target);
748       processedAccount[target] = true;
749     }
750     emit FrozenFunds(target, freeze);
751   }
752 
753   function freezeToken(bool freeze) public onlySuperAdmins {
754     frozenToken = freeze;
755     emit FrozenToken(frozenToken);
756   }
757 
758 }
759 
760 contract IStorable {
761   function getLedgerNameHash() external view returns (bytes32);
762   function getStorageNameHash() external view returns (bytes32);
763 }
764 
765 contract upgradeable is administratable {
766   address public predecessor;
767   address public successor;
768   bool public isTokenContract;
769   string public version;
770 
771   event Upgraded(address indexed successor);
772   event UpgradedFrom(address indexed predecessor);
773   event Transfer(address indexed _from, address indexed _to, uint256 _value);
774 
775   modifier unlessUpgraded() {
776     if (msg.sender != successor && successor != address(0)) revert();
777     _;
778   }
779 
780   modifier isUpgraded() {
781     if (successor == address(0)) revert();
782     _;
783   }
784 
785   modifier hasPredecessor() {
786     if (predecessor == address(0)) revert();
787     _;
788   }
789 
790   function isDeprecated() public view returns (bool) {
791     return successor != address(0);
792   }
793 
794   function upgradeTo(address _successor, uint256 remainingContractBalance) public onlySuperAdmins unlessUpgraded returns (bool){
795     require(_successor != address(0));
796     successor = _successor;
797     if (remainingContractBalance > 0) {
798       emit Transfer(this, _successor, remainingContractBalance);
799     }
800 
801     emit Upgraded(_successor);
802     return true;
803   }
804 
805   function upgradedFrom(address _predecessor) public onlySuperAdmins returns (bool) {
806     require(_predecessor != address(0));
807 
808     predecessor = _predecessor;
809 
810     emit UpgradedFrom(_predecessor);
811 
812     // TODO refactor this into registry contract when ready for registry upgrade
813     if (upgradeable(_predecessor).predecessor() != address(0)) {
814       if (upgradeable(_predecessor).isTokenContract()) {
815         emit Transfer(_predecessor, this, ERC20(_predecessor).balanceOf(_predecessor));
816       }
817     } else {
818       emit Transfer(this, this, 0); // make etherscan see this as an ERC-20. lets remove in v3
819     }
820 
821     return true;
822   }
823 }
824 
825 contract CardStackToken is ERC20,
826                            freezable,
827                            displayable,
828                            upgradeable,
829                            configurable,
830                            IStorable {
831 
832   using SafeMath for uint256;
833   using CstLibrary for address;
834 
835   ITokenLedger public tokenLedger;
836   string public storageName;
837   string public ledgerName;
838   address public externalStorage;
839   address public registry;
840   uint8 public constant decimals = 18;
841   bool public isTokenContract = true;
842   bool public haltPurchase;
843 
844   // This state is specific to the first version of the CST
845   // token contract and the token generation event, and hence
846   // there is no reason to persist in external storage for
847   // future contracts.
848   bool public allowTransfers;
849   mapping (address => bool) public whitelistedTransferer;
850   address[] public whitelistedTransfererForIndex;
851   mapping (address => bool) private processedWhitelistedTransferer;
852   uint256 public contributionMinimum;
853 
854   event Mint(uint256 amountMinted, uint256 totalTokens, uint256 circulationCap);
855   event Approval(address indexed _owner,
856                  address indexed _spender,
857                  uint256 _value);
858   event Transfer(address indexed _from,
859                  address indexed _to,
860                  uint256 _value);
861   event WhiteList(address indexed buyer, uint256 holdCap);
862   event ConfigChanged(uint256 buyPrice, uint256 circulationCap, uint256 balanceLimit);
863   event VestedTokenGrant(address indexed beneficiary, uint256 startDate, uint256 cliffDate, uint256 durationSec, uint256 fullyVestedAmount, bool isRevocable);
864   event VestedTokenRevocation(address indexed beneficiary);
865   event VestedTokenRelease(address indexed beneficiary, uint256 amount);
866   event StorageUpdated(address storageAddress, address ledgerAddress);
867   event PurchaseHalted();
868   event PurchaseResumed();
869 
870   modifier onlyFoundation {
871     address foundation = externalStorage.getFoundation();
872     require(foundation != address(0));
873     if (msg.sender != owner && msg.sender != foundation) revert();
874     _;
875   }
876 
877   modifier initStorage {
878     address ledgerAddress = Registry(registry).getStorage(ledgerName);
879     address storageAddress = Registry(registry).getStorage(storageName);
880 
881     tokenLedger = ITokenLedger(ledgerAddress);
882     externalStorage = storageAddress;
883     _;
884   }
885 
886   constructor(address _registry, string _storageName, string _ledgerName) public payable {
887     isTokenContract = true;
888     version = "2";
889     require(_registry != address(0));
890     storageName = _storageName;
891     ledgerName = _ledgerName;
892     registry = _registry;
893 
894     addSuperAdmin(registry);
895   }
896 
897   /* This unnamed function is called whenever someone tries to send ether directly to the token contract */
898   function () public {
899     revert(); // Prevents accidental sending of ether
900   }
901 
902   function getLedgerNameHash() external view returns (bytes32) {
903     return keccak256(abi.encodePacked(ledgerName));
904   }
905 
906   function getStorageNameHash() external view returns (bytes32) {
907     return keccak256(abi.encodePacked(storageName));
908   }
909 
910   function configure(bytes32 _tokenName,
911                      bytes32 _tokenSymbol,
912                      uint256 _buyPrice,
913                      uint256 _circulationCap,
914                      uint256 _balanceLimit,
915                      address _foundation) public onlySuperAdmins initStorage returns (bool) {
916 
917     uint256 __buyPrice= externalStorage.getBuyPrice();
918     if (__buyPrice> 0 && __buyPrice!= _buyPrice) {
919       require(frozenToken);
920     }
921 
922     externalStorage.setTokenName(_tokenName);
923     externalStorage.setTokenSymbol(_tokenSymbol);
924     externalStorage.setBuyPrice(_buyPrice);
925     externalStorage.setCirculationCap(_circulationCap);
926     externalStorage.setFoundation(_foundation);
927     externalStorage.setBalanceLimit(_balanceLimit);
928 
929     emit ConfigChanged(_buyPrice, _circulationCap, _balanceLimit);
930 
931     return true;
932   }
933 
934   function configureFromStorage() public onlySuperAdmins unlessUpgraded initStorage returns (bool) {
935     freezeToken(true);
936     return true;
937   }
938 
939   function updateStorage(string newStorageName, string newLedgerName) public onlySuperAdmins unlessUpgraded returns (bool) {
940     require(frozenToken);
941 
942     storageName = newStorageName;
943     ledgerName = newLedgerName;
944 
945     configureFromStorage();
946 
947     address ledgerAddress = Registry(registry).getStorage(ledgerName);
948     address storageAddress = Registry(registry).getStorage(storageName);
949     emit StorageUpdated(storageAddress, ledgerAddress);
950     return true;
951   }
952 
953   function name() public view unlessUpgraded returns(string) {
954     return bytes32ToString(externalStorage.getTokenName());
955   }
956 
957   function symbol() public view unlessUpgraded returns(string) {
958     return bytes32ToString(externalStorage.getTokenSymbol());
959   }
960 
961   function totalInCirculation() public view unlessUpgraded returns(uint256) {
962     return tokenLedger.totalInCirculation().add(totalUnvestedAndUnreleasedTokens());
963   }
964 
965   function cstBalanceLimit() public view unlessUpgraded returns(uint256) {
966     return externalStorage.getBalanceLimit();
967   }
968 
969   function buyPrice() public view unlessUpgraded returns(uint256) {
970     return externalStorage.getBuyPrice();
971   }
972 
973   function circulationCap() public view unlessUpgraded returns(uint256) {
974     return externalStorage.getCirculationCap();
975   }
976 
977   // intentionally allowing this to be visible if upgraded so foundation can
978   // withdraw funds from contract that has a successor
979   function foundation() public view returns(address) {
980     return externalStorage.getFoundation();
981   }
982 
983   function totalSupply() public view unlessUpgraded returns(uint256) {
984     return tokenLedger.totalTokens();
985   }
986 
987   function tokensAvailable() public view unlessUpgraded returns(uint256) {
988     return totalSupply().sub(totalInCirculation());
989   }
990 
991   function balanceOf(address account) public view unlessUpgraded returns (uint256) {
992     address thisAddress = this;
993     if (thisAddress == account) {
994       return tokensAvailable();
995     } else {
996       return tokenLedger.balanceOf(account);
997     }
998   }
999 
1000   function transfer(address recipient, uint256 amount) public unlessFrozen unlessUpgraded returns (bool) {
1001     require(allowTransfers || whitelistedTransferer[msg.sender]);
1002     require(amount > 0);
1003     require(!frozenAccount[recipient]);
1004 
1005     tokenLedger.transfer(msg.sender, recipient, amount);
1006     emit Transfer(msg.sender, recipient, amount);
1007 
1008     return true;
1009   }
1010 
1011   function mintTokens(uint256 mintedAmount) public onlySuperAdmins unlessUpgraded returns (bool) {
1012     uint256 _circulationCap = externalStorage.getCirculationCap();
1013     tokenLedger.mintTokens(mintedAmount);
1014 
1015     emit Mint(mintedAmount, tokenLedger.totalTokens(), _circulationCap);
1016 
1017     emit Transfer(address(0), this, mintedAmount);
1018 
1019     return true;
1020   }
1021 
1022   function grantTokens(address recipient, uint256 amount) public onlySuperAdmins unlessUpgraded returns (bool) {
1023     require(amount <= tokensAvailable());
1024     require(!frozenAccount[recipient]);
1025 
1026     tokenLedger.debitAccount(recipient, amount);
1027     emit Transfer(this, recipient, amount);
1028 
1029     return true;
1030   }
1031 
1032   function setHaltPurchase(bool _haltPurchase) public onlySuperAdmins unlessUpgraded returns (bool) {
1033     haltPurchase = _haltPurchase;
1034 
1035     if (_haltPurchase) {
1036       emit PurchaseHalted();
1037     } else {
1038       emit PurchaseResumed();
1039     }
1040     return true;
1041   }
1042 
1043   function buy() external payable unlessFrozen unlessUpgraded returns (uint256) {
1044     require(!haltPurchase);
1045     require(externalStorage.getApprovedBuyer(msg.sender));
1046 
1047     uint256 _buyPriceTokensPerWei = externalStorage.getBuyPrice();
1048     uint256 _circulationCap = externalStorage.getCirculationCap();
1049     require(msg.value > 0);
1050     require(_buyPriceTokensPerWei > 0);
1051     require(_circulationCap > 0);
1052 
1053     uint256 amount = msg.value.mul(_buyPriceTokensPerWei);
1054     require(totalInCirculation().add(amount) <= _circulationCap);
1055     require(amount <= tokensAvailable());
1056 
1057     uint256 balanceLimit;
1058     uint256 buyerBalance = tokenLedger.balanceOf(msg.sender);
1059     uint256 customLimit = externalStorage.getCustomBuyerLimit(msg.sender);
1060     require(contributionMinimum == 0 || buyerBalance.add(amount) >= contributionMinimum);
1061 
1062     if (customLimit > 0) {
1063       balanceLimit = customLimit;
1064     } else {
1065       balanceLimit = externalStorage.getBalanceLimit();
1066     }
1067 
1068     require(balanceLimit > 0 && balanceLimit >= buyerBalance.add(amount));
1069 
1070     tokenLedger.debitAccount(msg.sender, amount);
1071     emit Transfer(this, msg.sender, amount);
1072 
1073     return amount;
1074   }
1075 
1076   // intentionally allowing this to be visible if upgraded so foundation can
1077   // withdraw funds from contract that has a successor
1078   function foundationWithdraw(uint256 amount) public onlyFoundation returns (bool) {
1079     /* UNTRUSTED */
1080     msg.sender.transfer(amount);
1081 
1082     return true;
1083   }
1084 
1085   function foundationDeposit() public payable unlessUpgraded returns (bool) {
1086     return true;
1087   }
1088 
1089   function allowance(address owner, address spender) public view unlessUpgraded returns (uint256) {
1090     return externalStorage.getAllowance(owner, spender);
1091   }
1092 
1093   function transferFrom(address from, address to, uint256 value) public unlessFrozen unlessUpgraded returns (bool) {
1094     require(allowTransfers);
1095     require(!frozenAccount[from]);
1096     require(!frozenAccount[to]);
1097     require(from != msg.sender);
1098     require(value > 0);
1099 
1100     uint256 allowanceValue = allowance(from, msg.sender);
1101     require(allowanceValue >= value);
1102 
1103     tokenLedger.transfer(from, to, value);
1104     externalStorage.setAllowance(from, msg.sender, allowanceValue.sub(value));
1105 
1106     emit Transfer(from, to, value);
1107     return true;
1108   }
1109 
1110   /* Beware that changing an allowance with this method brings the risk that someone may use both the old
1111    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1112    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1113    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1114    *
1115    * Please use `increaseApproval` or `decreaseApproval` instead.
1116    */
1117   function approve(address spender, uint256 value) public unlessFrozen unlessUpgraded returns (bool) {
1118     require(spender != address(0));
1119     require(!frozenAccount[spender]);
1120     require(msg.sender != spender);
1121 
1122     externalStorage.setAllowance(msg.sender, spender, value);
1123 
1124     emit Approval(msg.sender, spender, value);
1125     return true;
1126   }
1127 
1128   function increaseApproval(address spender, uint256 addedValue) public unlessFrozen unlessUpgraded returns (bool) {
1129     return approve(spender, externalStorage.getAllowance(msg.sender, spender).add(addedValue));
1130   }
1131 
1132   function decreaseApproval(address spender, uint256 subtractedValue) public unlessFrozen unlessUpgraded returns (bool) {
1133     uint256 oldValue = externalStorage.getAllowance(msg.sender, spender);
1134 
1135     if (subtractedValue > oldValue) {
1136       return approve(spender, 0);
1137     } else {
1138       return approve(spender, oldValue.sub(subtractedValue));
1139     }
1140   }
1141 
1142   function grantVestedTokens(address beneficiary,
1143                              uint256 fullyVestedAmount,
1144                              uint256 startDate, // 0 indicates start "now"
1145                              uint256 cliffSec,
1146                              uint256 durationSec,
1147                              bool isRevocable) public onlySuperAdmins unlessUpgraded returns(bool) {
1148 
1149     uint256 _circulationCap = externalStorage.getCirculationCap();
1150 
1151     require(beneficiary != address(0));
1152     require(!frozenAccount[beneficiary]);
1153     require(durationSec >= cliffSec);
1154     require(totalInCirculation().add(fullyVestedAmount) <= _circulationCap);
1155     require(fullyVestedAmount <= tokensAvailable());
1156 
1157     uint256 _now = now;
1158     if (startDate == 0) {
1159       startDate = _now;
1160     }
1161 
1162     uint256 cliffDate = startDate.add(cliffSec);
1163 
1164     externalStorage.setVestingSchedule(beneficiary,
1165                                        fullyVestedAmount,
1166                                        startDate,
1167                                        cliffDate,
1168                                        durationSec,
1169                                        isRevocable);
1170 
1171     emit VestedTokenGrant(beneficiary, startDate, cliffDate, durationSec, fullyVestedAmount, isRevocable);
1172 
1173     return true;
1174   }
1175 
1176 
1177   function revokeVesting(address beneficiary) public onlySuperAdmins unlessUpgraded returns (bool) {
1178     require(beneficiary != address(0));
1179     externalStorage.revokeVesting(beneficiary);
1180 
1181     releaseVestedTokensForBeneficiary(beneficiary);
1182 
1183     emit VestedTokenRevocation(beneficiary);
1184 
1185     return true;
1186   }
1187 
1188   function releaseVestedTokens() public unlessFrozen unlessUpgraded returns (bool) {
1189     return releaseVestedTokensForBeneficiary(msg.sender);
1190   }
1191 
1192   function releaseVestedTokensForBeneficiary(address beneficiary) public unlessFrozen unlessUpgraded returns (bool) {
1193     require(beneficiary != address(0));
1194     require(!frozenAccount[beneficiary]);
1195 
1196     uint256 unreleased = releasableAmount(beneficiary);
1197 
1198     if (unreleased == 0) { return true; }
1199 
1200     externalStorage.releaseVestedTokens(beneficiary);
1201 
1202     tokenLedger.debitAccount(beneficiary, unreleased);
1203     emit Transfer(this, beneficiary, unreleased);
1204 
1205     emit VestedTokenRelease(beneficiary, unreleased);
1206 
1207     return true;
1208   }
1209 
1210   function releasableAmount(address beneficiary) public view unlessUpgraded returns (uint256) {
1211     return externalStorage.releasableAmount(beneficiary);
1212   }
1213 
1214   function totalUnvestedAndUnreleasedTokens() public view unlessUpgraded returns (uint256) {
1215     return externalStorage.getTotalUnvestedAndUnreleasedTokens();
1216   }
1217 
1218   function vestingMappingSize() public view unlessUpgraded returns (uint256) {
1219     return externalStorage.vestingMappingSize();
1220   }
1221 
1222   function vestingBeneficiaryForIndex(uint256 index) public view unlessUpgraded returns (address) {
1223     return externalStorage.vestingBeneficiaryForIndex(index);
1224   }
1225 
1226   function vestingSchedule(address _beneficiary) public
1227                                                  view unlessUpgraded returns (uint256 startDate,
1228                                                                               uint256 cliffDate,
1229                                                                               uint256 durationSec,
1230                                                                               uint256 fullyVestedAmount,
1231                                                                               uint256 vestedAmount,
1232                                                                               uint256 vestedAvailableAmount,
1233                                                                               uint256 releasedAmount,
1234                                                                               uint256 revokeDate,
1235                                                                               bool isRevocable) {
1236     (
1237       startDate,
1238       cliffDate,
1239       durationSec,
1240       fullyVestedAmount,
1241       releasedAmount,
1242       revokeDate,
1243       isRevocable
1244     ) =  externalStorage.getVestingSchedule(_beneficiary);
1245 
1246     vestedAmount = externalStorage.vestedAmount(_beneficiary);
1247     vestedAvailableAmount = externalStorage.vestedAvailableAmount(_beneficiary);
1248   }
1249 
1250   function totalCustomBuyersMapping() public view returns (uint256) {
1251     return externalStorage.getCustomBuyerMappingCount();
1252   }
1253 
1254   function customBuyerLimit(address buyer) public view returns (uint256) {
1255     return externalStorage.getCustomBuyerLimit(buyer);
1256   }
1257 
1258   function customBuyerForIndex(uint256 index) public view returns (address) {
1259     return externalStorage.getCustomBuyerForIndex(index);
1260   }
1261 
1262   function setCustomBuyer(address buyer, uint256 balanceLimit) public onlySuperAdmins unlessUpgraded returns (bool) {
1263     require(buyer != address(0));
1264     externalStorage.setCustomBuyerLimit(buyer, balanceLimit);
1265     addBuyer(buyer);
1266 
1267     return true;
1268   }
1269 
1270   function setAllowTransfers(bool _allowTransfers) public onlySuperAdmins unlessUpgraded returns (bool) {
1271     allowTransfers = _allowTransfers;
1272     return true;
1273   }
1274 
1275   function setContributionMinimum(uint256 _contributionMinimum) public onlySuperAdmins unlessUpgraded returns (bool) {
1276     contributionMinimum = _contributionMinimum;
1277     return true;
1278   }
1279 
1280   function totalBuyersMapping() public view returns (uint256) {
1281     return externalStorage.getApprovedBuyerMappingCount();
1282   }
1283 
1284   function approvedBuyer(address buyer) public view returns (bool) {
1285     return externalStorage.getApprovedBuyer(buyer);
1286   }
1287 
1288   function approvedBuyerForIndex(uint256 index) public view returns (address) {
1289     return externalStorage.getApprovedBuyerForIndex(index);
1290   }
1291 
1292   function addBuyer(address buyer) public onlySuperAdmins unlessUpgraded returns (bool) {
1293     require(buyer != address(0));
1294     externalStorage.setApprovedBuyer(buyer, true);
1295 
1296     uint256 balanceLimit = externalStorage.getCustomBuyerLimit(buyer);
1297     if (balanceLimit == 0) {
1298       balanceLimit = externalStorage.getBalanceLimit();
1299     }
1300 
1301     emit WhiteList(buyer, balanceLimit);
1302 
1303     return true;
1304   }
1305 
1306   function removeBuyer(address buyer) public onlySuperAdmins unlessUpgraded returns (bool) {
1307     require(buyer != address(0));
1308     externalStorage.setApprovedBuyer(buyer, false);
1309 
1310     return true;
1311   }
1312 
1313   function totalTransferWhitelistMapping() public view returns (uint256) {
1314     return whitelistedTransfererForIndex.length;
1315   }
1316 
1317   function setWhitelistedTransferer(address transferer, bool _allowTransfers) public onlySuperAdmins unlessUpgraded returns (bool) {
1318     require(transferer != address(0));
1319     whitelistedTransferer[transferer] = _allowTransfers;
1320     if (!processedWhitelistedTransferer[transferer]) {
1321       whitelistedTransfererForIndex.push(transferer);
1322       processedWhitelistedTransferer[transferer] = true;
1323     }
1324 
1325     return true;
1326   }
1327 }
1328 
1329 contract Registry is administratable, upgradeable {
1330   using SafeMath for uint256;
1331 
1332   bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
1333   bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
1334   bytes32 constant BARE_DOMAIN_NAMEHASH = 0x794941fae74d6435d1b29ee1c08cc39941ba78470872e6afd0693c7eeb63025c; // namehash for "cardstack.eth"
1335 
1336   mapping(bytes32 => address) public storageForHash;
1337   mapping(bytes32 => address) public contractForHash;
1338   mapping(bytes32 => bytes32) public hashForNamehash;
1339   mapping(bytes32 => bytes32) public namehashForHash;
1340   string[] public contractNameForIndex;
1341 
1342   event ContractRegistered(address indexed _contract, string _name, bytes32 namehash);
1343   event ContractUpgraded(address indexed successor, address indexed predecessor, string name, bytes32 namehash);
1344   event StorageAdded(address indexed storageAddress, string name);
1345   event StorageRemoved(address indexed storageAddress, string name);
1346   event AddrChanged(bytes32 indexed node, address a);
1347 
1348   function() public {
1349     revert();
1350   }
1351 
1352   function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
1353     return interfaceId == ADDR_INTERFACE_ID ||
1354            interfaceId == INTERFACE_META_ID;
1355   }
1356 
1357   function addr(bytes32 node) public view returns (address) {
1358     return contractForHash[hashForNamehash[node]];
1359   }
1360 
1361   function getContractHash(string name) public view unlessUpgraded returns (bytes32) {
1362     return keccak256(abi.encodePacked(name));
1363   }
1364 
1365   function numContracts() public view returns(uint256) {
1366     return contractNameForIndex.length;
1367   }
1368 
1369   function setNamehash(string contractName, bytes32 namehash) external onlySuperAdmins unlessUpgraded returns (bool) {
1370     require(namehash != 0x0);
1371 
1372     bytes32 hash = keccak256(abi.encodePacked(contractName));
1373     address contractAddress = contractForHash[hash];
1374 
1375     require(contractAddress != 0x0);
1376     require(hashForNamehash[namehash] == 0x0);
1377 
1378     hashForNamehash[namehash] = hash;
1379     namehashForHash[hash] = namehash;
1380 
1381     emit AddrChanged(namehash, contractAddress);
1382   }
1383 
1384   function register(string name, address contractAddress, bytes32 namehash) external onlySuperAdmins unlessUpgraded returns (bool) {
1385     bytes32 hash = keccak256(abi.encodePacked(name));
1386     require(bytes(name).length > 0);
1387     require(contractAddress != 0x0);
1388     require(contractForHash[hash] == 0x0);
1389     require(hashForNamehash[namehash] == 0x0);
1390 
1391     contractNameForIndex.push(name);
1392     contractForHash[hash] = contractAddress;
1393 
1394     if (namehash != 0x0) {
1395       hashForNamehash[namehash] = hash;
1396       namehashForHash[hash] = namehash;
1397     }
1398 
1399     address storageAddress = storageForHash[IStorable(contractAddress).getStorageNameHash()];
1400     address ledgerAddress = storageForHash[IStorable(contractAddress).getLedgerNameHash()];
1401 
1402     if (storageAddress != 0x0) {
1403       ExternalStorage(storageAddress).addAdmin(contractAddress);
1404     }
1405     if (ledgerAddress != 0x0) {
1406       CstLedger(ledgerAddress).addAdmin(contractAddress);
1407     }
1408 
1409     configurable(contractAddress).configureFromStorage();
1410 
1411     emit ContractRegistered(contractAddress, name, namehash);
1412 
1413     if (namehash != 0x0) {
1414       emit AddrChanged(namehash, contractAddress);
1415     }
1416 
1417     return true;
1418   }
1419 
1420   function upgradeContract(string name, address successor) external onlySuperAdmins unlessUpgraded returns (bytes32) {
1421     bytes32 hash = keccak256(abi.encodePacked(name));
1422     require(successor != 0x0);
1423     require(contractForHash[hash] != 0x0);
1424 
1425     address predecessor = contractForHash[hash];
1426     require(freezable(predecessor).frozenToken());
1427 
1428     contractForHash[hash] = successor;
1429 
1430     uint256 remainingContractBalance;
1431     // we need https://github.com/ethereum/EIPs/issues/165
1432     // to be able to see if a contract is ERC20 or not...
1433     if (hash == keccak256("cst")) {
1434       remainingContractBalance = ERC20(predecessor).balanceOf(predecessor);
1435     }
1436 
1437     upgradeable(predecessor).upgradeTo(successor,
1438                                        remainingContractBalance);
1439     upgradeable(successor).upgradedFrom(predecessor);
1440 
1441     address successorStorageAddress = storageForHash[IStorable(successor).getStorageNameHash()];
1442     address successorLedgerAddress = storageForHash[IStorable(successor).getLedgerNameHash()];
1443     address predecessorStorageAddress = storageForHash[IStorable(predecessor).getStorageNameHash()];
1444     address predecessorLedgerAddress = storageForHash[IStorable(predecessor).getLedgerNameHash()];
1445 
1446     if (successorStorageAddress != 0x0) {
1447       ExternalStorage(successorStorageAddress).addAdmin(successor);
1448     }
1449     if (predecessorStorageAddress != 0x0) {
1450       ExternalStorage(predecessorStorageAddress).removeAdmin(predecessor);
1451     }
1452 
1453     if (successorLedgerAddress != 0x0) {
1454       CstLedger(successorLedgerAddress).addAdmin(successor);
1455     }
1456     if (predecessorLedgerAddress != 0x0) {
1457       CstLedger(predecessorLedgerAddress).removeAdmin(predecessor);
1458     }
1459 
1460     configurable(successor).configureFromStorage();
1461 
1462     if (hashForNamehash[BARE_DOMAIN_NAMEHASH] == hash) {
1463       emit AddrChanged(BARE_DOMAIN_NAMEHASH, successor);
1464     }
1465     if (namehashForHash[hash] != 0x0 && namehashForHash[hash] != BARE_DOMAIN_NAMEHASH) {
1466       emit AddrChanged(namehashForHash[hash], successor);
1467     }
1468 
1469     emit ContractUpgraded(successor, predecessor, name, namehashForHash[hash]);
1470     return hash;
1471   }
1472 
1473   function addStorage(string name, address storageAddress) external onlySuperAdmins unlessUpgraded {
1474     require(storageAddress != address(0));
1475     bytes32 hash = keccak256(abi.encodePacked(name));
1476     storageForHash[hash] = storageAddress;
1477 
1478     emit StorageAdded(storageAddress, name);
1479   }
1480 
1481   function getStorage(string name) public view unlessUpgraded returns (address) {
1482     return storageForHash[keccak256(abi.encodePacked(name))];
1483   }
1484 
1485   function removeStorage(string name) public onlySuperAdmins unlessUpgraded {
1486     address storageAddress = storageForHash[keccak256(abi.encodePacked(name))];
1487     delete storageForHash[keccak256(abi.encodePacked(name))];
1488 
1489     emit StorageRemoved(storageAddress, name);
1490   }
1491 }