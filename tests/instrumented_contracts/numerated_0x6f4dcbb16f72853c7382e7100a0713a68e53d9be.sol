1 pragma solidity ^0.4.18;
2 
3 
4 contract GroupBuyContract {
5   /*** CONSTANTS ***/
6   uint256 public constant MAX_CONTRIBUTION_SLOTS = 20;
7   uint256 private firstStepLimit =  0.053613 ether;
8   uint256 private secondStepLimit = 0.564957 ether;
9 
10   /*** DATATYPES ***/
11   // @dev A Group is created for all the contributors who want to contribute
12   //  to the purchase of a particular token.
13   struct Group {
14     // Array of addresses of contributors in group
15     address[] contributorArr;
16     // Maps address to an address's position (+ 1) in the contributorArr;
17     // 1 is added to the position because zero is the default value in the mapping
18     mapping(address => uint256) addressToContributorArrIndex;
19     mapping(address => uint256) addressToContribution; // user address to amount contributed
20     bool exists; // For tracking whether a group has been initialized or not
21     uint256 contributedBalance; // Total amount contributed
22     uint256 purchasePrice; // Price of purchased token
23   }
24 
25   // @dev A Contributor record is created for each user participating in
26   //  this group buy contract. It stores the group ids the user contributed to
27   //  and a record of their sale proceeds.
28   struct Contributor {
29     // Maps tokenId to an tokenId's position (+ 1) in the groupArr;
30     // 1 is added to the position because zero is the default value in the mapping
31     mapping(uint256 => uint) tokenIdToGroupArrIndex;
32     // Array of tokenIds contributed to by a contributor
33     uint256[] groupArr;
34     bool exists;
35     // Ledger for withdrawable balance for this user.
36     //  Funds can come from excess paid into a groupBuy,
37     //  or from withdrawing from a group, or from
38     //  sale proceeds from a token.
39     uint256 withdrawableBalance;
40   }
41 
42   /*** EVENTS ***/
43   /// Admin Events
44   // @dev Event noting commission paid to contract
45   event Commission(uint256 _tokenId, uint256 amount);
46 
47   /// Contract Events
48   // @dev Event signifiying that contract received funds via fallback fn
49   event FundsReceived(address _from, uint256 amount);
50 
51   /// User Events
52   // @dev Event marking funds deposited into user _to's account
53   event FundsDeposited(address _to, uint256 amount);
54 
55   // @dev Event marking a withdrawal of amount by user _to
56   event FundsWithdrawn(address _to, uint256 amount);
57 
58   // @dev Event noting an interest distribution for user _to for token _tokenId.
59   //  Token Group will not be disbanded
60   event InterestDeposited(uint256 _tokenId, address _to, uint256 amount);
61 
62   // @dev Event for when a contributor joins a token group _tokenId
63   event JoinGroup(
64     uint256 _tokenId,
65     address contributor,
66     uint256 groupBalance,
67     uint256 contributionAdded
68   );
69 
70   // @dev Event for when a contributor leaves a token group
71   event LeaveGroup(
72     uint256 _tokenId,
73     address contributor,
74     uint256 groupBalance,
75     uint256 contributionSubtracted
76   );
77 
78   // @dev Event noting sales proceeds distribution for user _to from sale of token _tokenId
79   event ProceedsDeposited(uint256 _tokenId, address _to, uint256 amount);
80 
81   // @dev Event for when a token group purchases a token
82   event TokenPurchased(uint256 _tokenId, uint256 balance);
83 
84   /*** STORAGE ***/
85   // The addresses of the accounts (or contracts) that can execute actions within each roles.
86   address public ceoAddress;
87   address public cfoAddress;
88   address public cooAddress1;
89   address public cooAddress2;
90   address public cooAddress3;
91 
92   // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
93   bool public paused = false;
94   bool public forking = false;
95 
96   uint256 public activeGroups;
97   uint256 public commissionBalance;
98   uint256 private distributionNumerator;
99   uint256 private distributionDenominator;
100 
101   CelebrityToken public linkedContract;
102 
103   /// @dev A mapping from token IDs to the group associated with that token.
104   mapping(uint256 => Group) private tokenIndexToGroup;
105 
106   // @dev A mapping from owner address to available balance not held by a Group.
107   mapping(address => Contributor) private userAddressToContributor;
108 
109   /*** ACCESS MODIFIERS ***/
110   /// @dev Access modifier for CEO-only functionality
111   modifier onlyCEO() {
112     require(msg.sender == ceoAddress);
113     _;
114   }
115 
116   /// @dev Access modifier for CFO-only functionality
117   modifier onlyCFO() {
118     require(msg.sender == cfoAddress);
119     _;
120   }
121 
122   /// @dev Access modifier for COO-only functionality
123   modifier onlyCOO() {
124     require(
125       msg.sender == cooAddress1 ||
126       msg.sender == cooAddress2 ||
127       msg.sender == cooAddress3
128     );
129     _;
130   }
131 
132   /// @dev Access modifier for contract managers only functionality
133   modifier onlyCLevel() {
134     require(
135       msg.sender == ceoAddress ||
136       msg.sender == cooAddress1 ||
137       msg.sender == cooAddress2 ||
138       msg.sender == cooAddress3 ||
139       msg.sender == cfoAddress
140     );
141     _;
142   }
143 
144   /// @dev Modifier to allow actions only when the contract IS NOT paused
145   modifier whenNotPaused() {
146     require(!paused);
147     _;
148   }
149 
150   /// @dev Modifier to allow actions only when the contract IS paused
151   modifier whenPaused {
152     require(paused);
153     _;
154   }
155 
156   /// @dev Modifier to allow actions only when the contract IS NOT in forking mode
157   modifier whenNotForking() {
158     require(!forking);
159     _;
160   }
161 
162   /// @dev Modifier to allow actions only when the contract IS in forking mode
163   modifier whenForking {
164     require(forking);
165     _;
166   }
167 
168   /*** CONSTRUCTOR ***/
169   function GroupBuyContract(address contractAddress, uint256 numerator, uint256 denominator) public {
170     ceoAddress = msg.sender;
171     cooAddress1 = msg.sender;
172     cooAddress2 = msg.sender;
173     cooAddress3 = msg.sender;
174     cfoAddress = msg.sender;
175     distributionNumerator = numerator;
176     distributionDenominator = denominator;
177     linkedContract = CelebrityToken(contractAddress);
178   }
179 
180   /*** PUBLIC FUNCTIONS ***/
181   /// @notice Fallback fn for receiving ether
182   function() external payable {
183     FundsReceived(msg.sender, msg.value);
184   }
185 
186   /** Action Fns **/
187   /// @notice Backup function for activating token purchase
188   ///  requires sender to be a member of the group or CLevel
189   /// @param _tokenId The ID of the Token group
190   function activatePurchase(uint256 _tokenId) external whenNotPaused {
191     var group = tokenIndexToGroup[_tokenId];
192     require(group.addressToContribution[msg.sender] > 0 ||
193             msg.sender == ceoAddress ||
194             msg.sender == cooAddress1 ||
195             msg.sender == cooAddress2 ||
196             msg.sender == cooAddress3 ||
197             msg.sender == cfoAddress);
198 
199     // Safety check that enough money has been contributed to group
200     var price = linkedContract.priceOf(_tokenId);
201     require(group.contributedBalance >= price);
202 
203     // Safety check that token had not be purchased yet
204     require(group.purchasePrice == 0);
205 
206     _purchase(_tokenId, price);
207   }
208 
209   /// @notice Allow user to contribute to _tokenId token group
210   /// @param _tokenId The ID of the token group to be joined
211   function contributeToTokenGroup(uint256 _tokenId)
212   external payable whenNotForking whenNotPaused {
213     address userAdd = msg.sender;
214     // Safety check to prevent against an un  expected 0x0 default.
215     require(_addressNotNull(userAdd));
216 
217     /// Safety check to make sure contributor has not already joined this group
218     var group = tokenIndexToGroup[_tokenId];
219     var contributor = userAddressToContributor[userAdd];
220     if (!group.exists) { // Create group if not exists
221       group.exists = true;
222       activeGroups += 1;
223     } else {
224       require(group.addressToContributorArrIndex[userAdd] == 0);
225     }
226 
227     if (!contributor.exists) { // Create contributor if not exists
228       userAddressToContributor[userAdd].exists = true;
229     } else {
230       require(contributor.tokenIdToGroupArrIndex[_tokenId] == 0);
231     }
232 
233     // Safety check to make sure group isn't currently holding onto token
234     //  or has a group record stored (for sales proceeds distribution)
235     require(group.purchasePrice == 0);
236 
237     /// Safety check to ensure amount contributed is higher than min required percentage
238     ///  of purchase price
239     uint256 tokenPrice = linkedContract.priceOf(_tokenId);
240     require(msg.value >= uint256(SafeMath.div(tokenPrice, MAX_CONTRIBUTION_SLOTS)));
241 
242     // Index saved is 1 + the array's index, b/c 0 is the default value in a mapping,
243     //  so as stored on the mapping, array index will begin at 1
244     uint256 cIndex = tokenIndexToGroup[_tokenId].contributorArr.push(userAdd);
245     tokenIndexToGroup[_tokenId].addressToContributorArrIndex[userAdd] = cIndex;
246 
247     uint256 amountNeeded = SafeMath.sub(tokenPrice, group.contributedBalance);
248     if (msg.value > amountNeeded) {
249       tokenIndexToGroup[_tokenId].addressToContribution[userAdd] = amountNeeded;
250       tokenIndexToGroup[_tokenId].contributedBalance += amountNeeded;
251       // refund excess paid
252       userAddressToContributor[userAdd].withdrawableBalance += SafeMath.sub(msg.value, amountNeeded);
253       FundsDeposited(userAdd, SafeMath.sub(msg.value, amountNeeded));
254     } else {
255       tokenIndexToGroup[_tokenId].addressToContribution[userAdd] = msg.value;
256       tokenIndexToGroup[_tokenId].contributedBalance += msg.value;
257     }
258 
259     // Index saved is 1 + the array's index, b/c 0 is the default value in a mapping,
260     //  so as stored on the mapping, array index will begin at 1
261     uint256 gIndex = userAddressToContributor[userAdd].groupArr.push(_tokenId);
262     userAddressToContributor[userAdd].tokenIdToGroupArrIndex[_tokenId] = gIndex;
263 
264     JoinGroup(
265       _tokenId,
266       userAdd,
267       tokenIndexToGroup[_tokenId].contributedBalance,
268       tokenIndexToGroup[_tokenId].addressToContribution[userAdd]
269     );
270 
271     // Purchase token if enough funds contributed
272     if (tokenIndexToGroup[_tokenId].contributedBalance >= tokenPrice) {
273       _purchase(_tokenId, tokenPrice);
274     }
275   }
276 
277   /// @notice Allow user to leave purchase group; note that their contribution
278   ///  will be added to their withdrawable balance, and not directly refunded.
279   ///  User can call withdrawBalance to retrieve funds.
280   /// @param _tokenId The ID of the Token purchase group to be left
281   function leaveTokenGroup(uint256 _tokenId) external whenNotPaused {
282     address userAdd = msg.sender;
283 
284     var group = tokenIndexToGroup[_tokenId];
285     var contributor = userAddressToContributor[userAdd];
286 
287     // Safety check to prevent against an unexpected 0x0 default.
288     require(_addressNotNull(userAdd));
289 
290     // Safety check to make sure group exists;
291     require(group.exists);
292 
293     // Safety check to make sure group hasn't purchased token already
294     require(group.purchasePrice == 0);
295 
296     // Safety checks to ensure contributor has contributed to group
297     require(group.addressToContributorArrIndex[userAdd] > 0);
298     require(contributor.tokenIdToGroupArrIndex[_tokenId] > 0);
299 
300     uint refundBalance = _clearContributorRecordInGroup(_tokenId, userAdd);
301     _clearGroupRecordInContributor(_tokenId, userAdd);
302 
303     userAddressToContributor[userAdd].withdrawableBalance += refundBalance;
304     FundsDeposited(userAdd, refundBalance);
305 
306     LeaveGroup(
307       _tokenId,
308       userAdd,
309       tokenIndexToGroup[_tokenId].contributedBalance,
310       refundBalance
311     );
312   }
313 
314   /// @notice Allow user to leave purchase group; note that their contribution
315   ///  and any funds they have in their withdrawableBalance will transfered to them.
316   /// @param _tokenId The ID of the Token purchase group to be left
317   function leaveTokenGroupAndWithdrawBalance(uint256 _tokenId) external whenNotPaused {
318     address userAdd = msg.sender;
319 
320     var group = tokenIndexToGroup[_tokenId];
321     var contributor = userAddressToContributor[userAdd];
322 
323     // Safety check to prevent against an unexpected 0x0 default.
324     require(_addressNotNull(userAdd));
325 
326     // Safety check to make sure group exists;
327     require(group.exists);
328 
329     // Safety check to make sure group hasn't purchased token already
330     require(group.purchasePrice == 0);
331 
332     // Safety checks to ensure contributor has contributed to group
333     require(group.addressToContributorArrIndex[userAdd] > 0);
334     require(contributor.tokenIdToGroupArrIndex[_tokenId] > 0);
335 
336     uint refundBalance = _clearContributorRecordInGroup(_tokenId, userAdd);
337     _clearGroupRecordInContributor(_tokenId, userAdd);
338 
339     userAddressToContributor[userAdd].withdrawableBalance += refundBalance;
340     FundsDeposited(userAdd, refundBalance);
341 
342     _withdrawUserFunds(userAdd);
343 
344     LeaveGroup(
345       _tokenId,
346       userAdd,
347       tokenIndexToGroup[_tokenId].contributedBalance,
348       refundBalance
349     );
350   }
351 
352   /// @dev Withdraw balance from own account
353   function withdrawBalance() external whenNotPaused {
354     require(_addressNotNull(msg.sender));
355     require(userAddressToContributor[msg.sender].exists);
356 
357     _withdrawUserFunds(msg.sender);
358   }
359 
360   /** Admin Fns **/
361   /// @notice Fn for adjusting commission rate
362   /// @param numerator Numerator for calculating funds distributed
363   /// @param denominator Denominator for calculating funds distributed
364   function adjustCommission(uint256 numerator, uint256 denominator) external onlyCLevel {
365     require(numerator <= denominator);
366     distributionNumerator = numerator;
367     distributionDenominator = denominator;
368   }
369 
370   /// @dev In the event of needing a fork, this function moves all
371   ///  of a group's contributors' contributions into their withdrawable balance.
372   /// @notice Group is dissolved after fn call
373   /// @param _tokenId The ID of the Token purchase group
374   function dissolveTokenGroup(uint256 _tokenId) external onlyCOO whenForking {
375     var group = tokenIndexToGroup[_tokenId];
376 
377     // Safety check to make sure group exists and had not purchased a token
378     require(group.exists);
379     require(group.purchasePrice == 0);
380 
381     for (uint i = 0; i < tokenIndexToGroup[_tokenId].contributorArr.length; i++) {
382       address userAdd = tokenIndexToGroup[_tokenId].contributorArr[i];
383 
384       var userContribution = group.addressToContribution[userAdd];
385 
386       _clearGroupRecordInContributor(_tokenId, userAdd);
387 
388       // clear contributor record on group
389       tokenIndexToGroup[_tokenId].addressToContribution[userAdd] = 0;
390       tokenIndexToGroup[_tokenId].addressToContributorArrIndex[userAdd] = 0;
391 
392       // move contributor's contribution to their withdrawable balance
393       userAddressToContributor[userAdd].withdrawableBalance += userContribution;
394       ProceedsDeposited(_tokenId, userAdd, userContribution);
395     }
396     activeGroups -= 1;
397     tokenIndexToGroup[_tokenId].exists = false;
398   }
399 
400   /// @dev Backup fn to allow distribution of funds after sale,
401   ///  for the special scenario where an alternate sale platform is used;
402   /// @notice Group is dissolved after fn call
403   /// @param _tokenId The ID of the Token purchase group
404   /// @param _amount Funds to be distributed
405   function distributeCustomSaleProceeds(uint256 _tokenId, uint256 _amount) external onlyCOO {
406     var group = tokenIndexToGroup[_tokenId];
407 
408     // Safety check to make sure group exists and had purchased the token
409     require(group.exists);
410     require(group.purchasePrice > 0);
411     require(_amount > 0);
412 
413     _distributeProceeds(_tokenId, _amount);
414   }
415 
416   /* /// @dev Allow distribution of interest payment,
417   ///  Group is intact after fn call
418   /// @param _tokenId The ID of the Token purchase group
419   function distributeInterest(uint256 _tokenId) external onlyCOO payable {
420     var group = tokenIndexToGroup[_tokenId];
421     var amount = msg.value;
422     var excess = amount;
423 
424     // Safety check to make sure group exists and had purchased the token
425     require(group.exists);
426     require(group.purchasePrice > 0);
427     require(amount > 0);
428 
429     for (uint i = 0; i < tokenIndexToGroup[_tokenId].contributorArr.length; i++) {
430       address userAdd = tokenIndexToGroup[_tokenId].contributorArr[i];
431 
432       // calculate contributor's interest proceeds and add to their withdrawable balance
433       uint256 userProceeds = uint256(SafeMath.div(SafeMath.mul(amount,
434         tokenIndexToGroup[_tokenId].addressToContribution[userAdd]),
435         tokenIndexToGroup[_tokenId].contributedBalance));
436       userAddressToContributor[userAdd].withdrawableBalance += userProceeds;
437 
438       excess -= userProceeds;
439 
440       InterestDeposited(_tokenId, userAdd, userProceeds);
441     }
442     commissionBalance += excess;
443     Commission(_tokenId, excess);
444   } */
445 
446   /// @dev Distribute funds after a token is sold.
447   ///  Group is dissolved after fn call
448   /// @param _tokenId The ID of the Token purchase group
449   function distributeSaleProceeds(uint256 _tokenId) external onlyCOO {
450     var group = tokenIndexToGroup[_tokenId];
451 
452     // Safety check to make sure group exists and had purchased the token
453     require(group.exists);
454     require(group.purchasePrice > 0);
455 
456     // Safety check to make sure token had been sold
457     uint256 currPrice = linkedContract.priceOf(_tokenId);
458     uint256 soldPrice = _newPrice(group.purchasePrice);
459     require(currPrice > soldPrice);
460 
461     uint256 paymentIntoContract = uint256(SafeMath.div(SafeMath.mul(soldPrice, 94), 100));
462     _distributeProceeds(_tokenId, paymentIntoContract);
463   }
464 
465   /// @dev Called by any "C-level" role to pause the contract. Used only when
466   ///  a bug or exploit is detected and we need to limit damage.
467   function pause() external onlyCLevel whenNotPaused {
468     paused = true;
469   }
470 
471   /// @dev Unpauses the smart contract. Can only be called by the CEO, since
472   ///  one reason we may pause the contract is when CFO or COO accounts are
473   ///  compromised.
474   function unpause() external onlyCEO whenPaused {
475     // can't unpause if contract was upgraded
476     paused = false;
477   }
478 
479   /// @dev Called by any "C-level" role to set the contract to . Used only when
480   ///  a bug or exploit is detected and we need to limit damage.
481   function setToForking() external onlyCLevel whenNotForking {
482     forking = true;
483   }
484 
485   /// @dev Unpauses the smart contract. Can only be called by the CEO, since
486   ///  one reason we may pause the contract is when CFO or COO accounts are
487   ///  compromised.
488   function setToNotForking() external onlyCEO whenForking {
489     // can't unpause if contract was upgraded
490     forking = false;
491   }
492 
493   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
494   /// @param _newCEO The address of the new CEO
495   function setCEO(address _newCEO) external onlyCEO {
496     require(_newCEO != address(0));
497 
498     ceoAddress = _newCEO;
499   }
500 
501   /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
502   /// @param _newCFO The address of the new CFO
503   function setCFO(address _newCFO) external onlyCEO {
504     require(_newCFO != address(0));
505 
506     cfoAddress = _newCFO;
507   }
508 
509   /// @dev Assigns a new address to act as the COO1. Only available to the current CEO.
510   /// @param _newCOO1 The address of the new COO1
511   function setCOO1(address _newCOO1) external onlyCEO {
512     require(_newCOO1 != address(0));
513 
514     cooAddress1 = _newCOO1;
515   }
516 
517   /// @dev Assigns a new address to act as the COO2. Only available to the current CEO.
518   /// @param _newCOO2 The address of the new COO2
519   function setCOO2(address _newCOO2) external onlyCEO {
520     require(_newCOO2 != address(0));
521 
522     cooAddress2 = _newCOO2;
523   }
524 
525   /// @dev Assigns a new address to act as the COO3. Only available to the current CEO.
526   /// @param _newCOO3 The address of the new COO3
527   function setCOO3(address _newCOO3) external onlyCEO {
528     require(_newCOO3 != address(0));
529 
530     cooAddress3 = _newCOO3;
531   }
532 
533   /// @dev Backup fn to allow transfer of token out of
534   ///  contract, for use where a purchase group wants to use an alternate
535   ///  selling platform
536   /// @param _tokenId The ID of the Token purchase group
537   /// @param _to Address to transfer token to
538   function transferToken(uint256 _tokenId, address _to) external onlyCOO {
539     var group = tokenIndexToGroup[_tokenId];
540 
541     // Safety check to make sure group exists and had purchased the token
542     require(group.exists);
543     require(group.purchasePrice > 0);
544 
545     linkedContract.transfer(_to, _tokenId);
546   }
547 
548   /// @dev Withdraws sale commission, CFO-only functionality
549   /// @param _to Address for commission to be sent to
550   function withdrawCommission(address _to) external onlyCFO {
551     uint256 balance = commissionBalance;
552     address transferee = (_to == address(0)) ? cfoAddress : _to;
553     commissionBalance = 0;
554     if (balance > 0) {
555       transferee.transfer(balance);
556     }
557     FundsWithdrawn(transferee, balance);
558   }
559 
560   /** Information Query Fns **/
561   /// @dev Get contributed balance in _tokenId token group for user
562   /// @param _tokenId The ID of the token to be queried
563   function getContributionBalanceForTokenGroup(uint256 _tokenId, address userAdd) external view returns (uint balance) {
564     var group = tokenIndexToGroup[_tokenId];
565     require(group.exists);
566     balance = group.addressToContribution[userAdd];
567   }
568 
569   /// @dev Get contributed balance in _tokenId token group for user
570   /// @param _tokenId The ID of the token to be queried
571   function getSelfContributionBalanceForTokenGroup(uint256 _tokenId) external view returns (uint balance) {
572     var group = tokenIndexToGroup[_tokenId];
573     require(group.exists);
574     balance = group.addressToContribution[msg.sender];
575   }
576 
577   /// @dev Get array of contributors' addresses in _tokenId token group
578   /// @param _tokenId The ID of the token to be queried
579   function getContributorsInTokenGroup(uint256 _tokenId) external view returns (address[] contribAddr) {
580     var group = tokenIndexToGroup[_tokenId];
581     require(group.exists);
582     contribAddr = group.contributorArr;
583   }
584 
585   /// @dev Get no. of contributors in _tokenId token group
586   /// @param _tokenId The ID of the token to be queried
587   function getContributorsInTokenGroupCount(uint256 _tokenId) external view returns (uint count) {
588     var group = tokenIndexToGroup[_tokenId];
589     require(group.exists);
590     count = group.contributorArr.length;
591   }
592 
593   /// @dev Get list of tokenIds of token groups a user contributed to
594   function getGroupsContributedTo(address userAdd) external view returns (uint256[] groupIds) {
595     // Safety check to prevent against an unexpected 0x0 default.
596     require(_addressNotNull(userAdd));
597 
598     var contributor = userAddressToContributor[userAdd];
599     require(contributor.exists);
600 
601     groupIds = contributor.groupArr;
602   }
603 
604   /// @dev Get list of tokenIds of token groups the user contributed to
605   function getSelfGroupsContributedTo() external view returns (uint256[] groupIds) {
606     // Safety check to prevent against an unexpected 0x0 default.
607     require(_addressNotNull(msg.sender));
608 
609     var contributor = userAddressToContributor[msg.sender];
610     require(contributor.exists);
611 
612     groupIds = contributor.groupArr;
613   }
614 
615   /// @dev Get price at which token group purchased _tokenId token
616   function getGroupPurchasedPrice(uint256 _tokenId) external view returns (uint256 price) {
617     var group = tokenIndexToGroup[_tokenId];
618     require(group.exists);
619     require(group.purchasePrice > 0);
620     price = group.purchasePrice;
621   }
622 
623   /// @dev Get withdrawable balance from sale proceeds for a user
624   function getWithdrawableBalance() external view returns (uint256 balance) {
625     // Safety check to prevent against an unexpected 0x0 default.
626     require(_addressNotNull(msg.sender));
627 
628     var contributor = userAddressToContributor[msg.sender];
629     require(contributor.exists);
630 
631     balance = contributor.withdrawableBalance;
632   }
633 
634   /// @dev Get total contributed balance in _tokenId token group
635   /// @param _tokenId The ID of the token group to be queried
636   function getTokenGroupTotalBalance(uint256 _tokenId) external view returns (uint balance) {
637     var group = tokenIndexToGroup[_tokenId];
638     require(group.exists);
639     balance = group.contributedBalance;
640   }
641 
642   /*** PRIVATE FUNCTIONS ***/
643   /// @dev Safety check on _to address to prevent against an unexpected 0x0 default.
644   /// @param _to Address to be checked
645   function _addressNotNull(address _to) private pure returns (bool) {
646     return _to != address(0);
647   }
648 
649   /// @dev Clears record of a Contributor from a Group's record
650   /// @param _tokenId Token ID of Group to be cleared
651   /// @param _userAdd Address of Contributor
652   function _clearContributorRecordInGroup(uint256 _tokenId, address _userAdd) private returns (uint256 refundBalance) {
653     var group = tokenIndexToGroup[_tokenId];
654 
655     // Index was saved is 1 + the array's index, b/c 0 is the default value
656     //  in a mapping.
657     uint cIndex = group.addressToContributorArrIndex[_userAdd] - 1;
658     uint lastCIndex = group.contributorArr.length - 1;
659     refundBalance = group.addressToContribution[_userAdd];
660 
661     // clear contribution record in group
662     tokenIndexToGroup[_tokenId].addressToContributorArrIndex[_userAdd] = 0;
663     tokenIndexToGroup[_tokenId].addressToContribution[_userAdd] = 0;
664 
665     // move address in last position to deleted contributor's spot
666     if (lastCIndex > 0) {
667       tokenIndexToGroup[_tokenId].addressToContributorArrIndex[group.contributorArr[lastCIndex]] = cIndex;
668       tokenIndexToGroup[_tokenId].contributorArr[cIndex] = group.contributorArr[lastCIndex];
669     }
670 
671     tokenIndexToGroup[_tokenId].contributorArr.length -= 1;
672     tokenIndexToGroup[_tokenId].contributedBalance -= refundBalance;
673   }
674 
675   /// @dev Clears record of a Group from a Contributor's record
676   /// @param _tokenId Token ID of Group to be cleared
677   /// @param _userAdd Address of Contributor
678   function _clearGroupRecordInContributor(uint256 _tokenId, address _userAdd) private {
679     // Index saved is 1 + the array's index, b/c 0 is the default value
680     //  in a mapping.
681     uint gIndex = userAddressToContributor[_userAdd].tokenIdToGroupArrIndex[_tokenId] - 1;
682     uint lastGIndex = userAddressToContributor[_userAdd].groupArr.length - 1;
683 
684     // clear Group record in Contributor
685     userAddressToContributor[_userAdd].tokenIdToGroupArrIndex[_tokenId] = 0;
686 
687     // move tokenId from end of array to deleted Group record's spot
688     if (lastGIndex > 0) {
689       userAddressToContributor[_userAdd].tokenIdToGroupArrIndex[userAddressToContributor[_userAdd].groupArr[lastGIndex]] = gIndex;
690       userAddressToContributor[_userAdd].groupArr[gIndex] = userAddressToContributor[_userAdd].groupArr[lastGIndex];
691     }
692 
693     userAddressToContributor[_userAdd].groupArr.length -= 1;
694   }
695 
696   /// @dev Redistribute proceeds from token purchase
697   /// @param _tokenId Token ID of token to be purchased
698   /// @param _amount Amount paid into contract for token
699   function _distributeProceeds(uint256 _tokenId, uint256 _amount) private {
700     uint256 fundsForDistribution = uint256(SafeMath.div(SafeMath.mul(_amount,
701       distributionNumerator), distributionDenominator));
702     uint256 commission = _amount;
703 
704     for (uint i = 0; i < tokenIndexToGroup[_tokenId].contributorArr.length; i++) {
705       address userAdd = tokenIndexToGroup[_tokenId].contributorArr[i];
706 
707       // calculate contributor's sale proceeds and add to their withdrawable balance
708       uint256 userProceeds = uint256(SafeMath.div(SafeMath.mul(fundsForDistribution,
709         tokenIndexToGroup[_tokenId].addressToContribution[userAdd]),
710         tokenIndexToGroup[_tokenId].contributedBalance));
711 
712       _clearGroupRecordInContributor(_tokenId, userAdd);
713 
714       // clear contributor record on group
715       tokenIndexToGroup[_tokenId].addressToContribution[userAdd] = 0;
716       tokenIndexToGroup[_tokenId].addressToContributorArrIndex[userAdd] = 0;
717 
718       commission -= userProceeds;
719       userAddressToContributor[userAdd].withdrawableBalance += userProceeds;
720       ProceedsDeposited(_tokenId, userAdd, userProceeds);
721     }
722 
723     commissionBalance += commission;
724     Commission(_tokenId, commission);
725 
726     activeGroups -= 1;
727     tokenIndexToGroup[_tokenId].exists = false;
728     tokenIndexToGroup[_tokenId].contributorArr.length = 0;
729     tokenIndexToGroup[_tokenId].contributedBalance = 0;
730     tokenIndexToGroup[_tokenId].purchasePrice = 0;
731   }
732 
733   /// @dev Calculates next price of celebrity token
734   /// @param _oldPrice Previous price
735   function _newPrice(uint256 _oldPrice) private view returns (uint256 newPrice) {
736     if (_oldPrice < firstStepLimit) {
737       // first stage
738       newPrice = SafeMath.div(SafeMath.mul(_oldPrice, 200), 94);
739     } else if (_oldPrice < secondStepLimit) {
740       // second stage
741       newPrice = SafeMath.div(SafeMath.mul(_oldPrice, 120), 94);
742     } else {
743       // third stage
744       newPrice = SafeMath.div(SafeMath.mul(_oldPrice, 115), 94);
745     }
746   }
747 
748   /// @dev Calls CelebrityToken purchase fn and updates records
749   /// @param _tokenId Token ID of token to be purchased
750   /// @param _amount Amount to be paid to CelebrityToken
751   function _purchase(uint256 _tokenId, uint256 _amount) private {
752     tokenIndexToGroup[_tokenId].purchasePrice = _amount;
753     linkedContract.purchase.value(_amount)(_tokenId);
754     TokenPurchased(_tokenId, _amount);
755   }
756 
757   function _withdrawUserFunds(address userAdd) private {
758     uint256 balance = userAddressToContributor[userAdd].withdrawableBalance;
759     userAddressToContributor[userAdd].withdrawableBalance = 0;
760 
761     if (balance > 0) {
762       FundsWithdrawn(userAdd, balance);
763       userAdd.transfer(balance);
764     }
765   }
766 }
767 
768 
769 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
770 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
771 contract ERC721 {
772   // Required methods
773   function approve(address _to, uint256 _tokenId) public;
774   function balanceOf(address _owner) public view returns (uint256 balance);
775   function implementsERC721() public pure returns (bool);
776   function ownerOf(uint256 _tokenId) public view returns (address addr);
777   function takeOwnership(uint256 _tokenId) public;
778   function totalSupply() public view returns (uint256 total);
779   function transferFrom(address _from, address _to, uint256 _tokenId) public;
780   function transfer(address _to, uint256 _tokenId) public;
781 
782   event Transfer(address indexed from, address indexed to, uint256 tokenId);
783   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
784 
785   // Optional
786   // function name() public view returns (string name);
787   // function symbol() public view returns (string symbol);
788   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
789   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
790 }
791 
792 
793 contract CelebrityToken is ERC721 {
794 
795   /*** EVENTS ***/
796 
797   /// @dev The Birth event is fired whenever a new person comes into existence.
798   event Birth(uint256 tokenId, string name, address owner);
799 
800   /// @dev The TokenSold event is fired whenever a token is sold.
801   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
802 
803   /// @dev Transfer event as defined in current draft of ERC721.
804   ///  ownership is assigned, including births.
805   event Transfer(address from, address to, uint256 tokenId);
806 
807   /*** CONSTANTS ***/
808 
809   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
810   string public constant NAME = "CryptoCelebrities"; // solhint-disable-line
811   string public constant SYMBOL = "CelebrityToken"; // solhint-disable-line
812 
813   address public ceoAddress;
814   address public cooAddress;
815 
816   uint256 public promoCreatedCount;
817 
818   /*** DATATYPES ***/
819   struct Person {
820     string name;
821   }
822 
823   /*** CONSTRUCTOR ***/
824   function CelebrityToken() public {
825     ceoAddress = msg.sender;
826     cooAddress = msg.sender;
827   }
828 
829   /*** PUBLIC FUNCTIONS ***/
830   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
831   /// @param _to The address to be granted transfer approval. Pass address(0) to
832   ///  clear all approvals.
833   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
834   /// @dev Required for ERC-721 compliance.
835   function approve(
836     address _to,
837     uint256 _tokenId
838   ) public;
839 
840   /// For querying balance of a particular account
841   /// @param _owner The address for balance query
842   /// @dev Required for ERC-721 compliance.
843   function balanceOf(address _owner) public view returns (uint256 balance);
844 
845   /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
846   function createPromoPerson(address _owner, string _name, uint256 _price) public;
847 
848   /// @dev Creates a new Person with the given name.
849   function createContractPerson(string _name) public;
850 
851   /// @notice Returns all the relevant information about a specific person.
852   /// @param _tokenId The tokenId of the person of interest.
853   function getPerson(uint256 _tokenId) public view returns (
854     string personName,
855     uint256 sellingPrice,
856     address owner
857   );
858 
859   function implementsERC721() public pure returns (bool);
860 
861   /// @dev Required for ERC-721 compliance.
862   function name() public pure returns (string);
863 
864   /// For querying owner of token
865   /// @param _tokenId The tokenID for owner inquiry
866   /// @dev Required for ERC-721 compliance.
867   function ownerOf(uint256 _tokenId)
868     public
869     view
870     returns (address owner);
871     
872   function payout(address _to) public;
873 
874   // Allows someone to send ether and obtain the token
875   function purchase(uint256 _tokenId) public payable;
876 
877   function priceOf(uint256 _tokenId) public view returns (uint256 price);
878   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
879   /// @param _newCEO The address of the new CEO
880   function setCEO(address _newCEO) public;
881 
882   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
883   /// @param _newCOO The address of the new COO
884   function setCOO(address _newCOO) public;
885 
886   /// @dev Required for ERC-721 compliance.
887   function symbol() public pure returns (string);
888   /// @notice Allow pre-approved user to take ownership of a token
889   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
890   /// @dev Required for ERC-721 compliance.
891   function takeOwnership(uint256 _tokenId) public;
892 
893   /// @param _owner The owner whose celebrity tokens we are interested in.
894   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
895   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
896   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
897   ///  not contract-to-contract calls.
898   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens);
899 
900   /// For querying totalSupply of token
901   /// @dev Required for ERC-721 compliance.
902   function totalSupply() public view returns (uint256 total);
903 
904   /// Owner initates the transfer of the token to another account
905   /// @param _to The address for the token to be transferred to.
906   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
907   /// @dev Required for ERC-721 compliance.
908   function transfer(
909     address _to,
910     uint256 _tokenId
911   ) public;
912 
913   /// Third-party initiates transfer of token from address _from to address _to
914   /// @param _from The address for the token to be transferred from.
915   /// @param _to The address for the token to be transferred to.
916   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
917   /// @dev Required for ERC-721 compliance.
918   function transferFrom(
919     address _from,
920     address _to,
921     uint256 _tokenId
922   ) public;
923 
924   /*** PRIVATE FUNCTIONS ***/
925   /// Safety check on _to address to prevent against an unexpected 0x0 default.
926   function _addressNotNull(address _to) private pure returns (bool);
927 
928   /// For checking approval of transfer for address _to
929   function _approved(address _to, uint256 _tokenId) private view returns (bool);
930 
931   /// For creating Person
932   function _createPerson(string _name, address _owner, uint256 _price) private;
933 
934   /// Check for token ownership
935   function _owns(address claimant, uint256 _tokenId) private view returns (bool);
936 
937   /// For paying out balance on contract
938   function _payout(address _to) private;
939 
940   /// @dev Assigns ownership of a specific Person to an address.
941   function _transfer(address _from, address _to, uint256 _tokenId) private;
942 }
943 
944 
945 library SafeMath {
946   /**
947   * @dev Multiplies two numbers, throws on overflow.
948   */
949   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
950     if (a == 0) {
951       return 0;
952     }
953     uint256 c = a * b;
954     assert(c / a == b);
955     return c;
956   }
957 
958   /**
959   * @dev Integer division of two numbers, truncating the quotient.
960   */
961   function div(uint256 a, uint256 b) internal pure returns (uint256) {
962     // assert(b > 0); // Solidity automatically throws when dividing by 0
963     uint256 c = a / b;
964     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
965     return c;
966   }
967 
968   /**
969   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
970   */
971   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
972     assert(b <= a);
973     return a - b;
974   }
975 
976   /**
977   * @dev Adds two numbers, throws on overflow.
978   */
979   function add(uint256 a, uint256 b) internal pure returns (uint256) {
980     uint256 c = a + b;
981     assert(c >= a);
982     return c;
983   }
984 }