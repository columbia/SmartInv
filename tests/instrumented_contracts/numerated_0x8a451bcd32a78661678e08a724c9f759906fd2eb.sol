1 pragma solidity ^0.5.0;
2 
3 
4 contract IOwnable {
5 
6     address public owner;
7     address public newOwner;
8 
9     event OwnerChanged(address _oldOwner, address _newOwner);
10 
11     function changeOwner(address _newOwner) public;
12     function acceptOwnership() public;
13 }
14 
15 contract Ownable is IOwnable {
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     constructor() public {
23         owner = msg.sender;
24         emit OwnerChanged(address(0), owner);
25     }
26 
27     function changeOwner(address _newOwner) public onlyOwner {
28         newOwner = _newOwner;
29     }
30 
31     function acceptOwnership() public {
32         require(msg.sender == newOwner);
33         emit OwnerChanged(owner, newOwner);
34         owner = newOwner;
35         newOwner = address(0);
36     }
37 }
38 contract SafeMath {
39 
40     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a * b;
42         assert(a == 0 || c / a == b);
43         return c;
44     }
45 
46     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
47         assert(b > 0);
48         uint256 c = a / b;
49         return c;
50     }
51 
52     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
53         assert(a >= b);
54         return a - b;
55     }
56 
57     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         assert(c >= a);
60         return c;
61     }
62 }
63 
64 
65 contract IERC20Token {
66     string public name;
67     string public symbol;
68     uint8 public decimals;
69     uint256 public totalSupply;
70 
71     function balanceOf(address _owner) public view returns (uint256 balance);
72     function transfer(address _to, uint256 _value)  public returns (bool success);
73     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
74     function approve(address _spender, uint256 _value)  public returns (bool success);
75     function allowance(address _owner, address _spender)  public view returns (uint256 remaining);
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 }
80 
81 contract IWinbixToken is IERC20Token {
82 
83     uint256 public votableTotal;
84     uint256 public accruableTotal;
85     address public issuer;
86     bool public transferAllowed;
87 
88     mapping (address => bool) public isPayable;
89 
90     event SetIssuer(address _address);
91     event TransferAllowed(bool _newState);
92     event FreezeWallet(address _address);
93     event UnfreezeWallet(address _address);
94     event IssueTokens(address indexed _to, uint256 _value);
95     event IssueVotable(address indexed _to, uint256 _value);
96     event IssueAccruable(address indexed _to, uint256 _value);
97     event BurnTokens(address indexed _from, uint256 _value);
98     event BurnVotable(address indexed _from, uint256 _value);
99     event BurnAccruable(address indexed _from, uint256 _value);
100     event SetPayable(address _address, bool _state);
101 
102     function setIssuer(address _address) public;
103     function allowTransfer(bool _allowTransfer) public;
104     function freeze(address _address) public;
105     function unfreeze(address _address) public;
106     function isFrozen(address _address) public returns (bool);
107     function issue(address _to, uint256 _value) public;
108     function issueVotable(address _to, uint256 _value) public;
109     function issueAccruable(address _to, uint256 _value) public;
110     function votableBalanceOf(address _address) public view returns (uint256);
111     function accruableBalanceOf(address _address) public view returns (uint256);
112     function burn(uint256 _value) public;
113     function burnAll() public;
114     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool);
115     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool);
116     function setMePayable(bool _state) public;
117 }
118 
119 contract IWinbixPayable {
120 
121     function catchWinbix(address payable _from, uint256 _value) external;
122 
123 }
124 
125 contract WinbixPayable is IWinbixPayable {
126 
127     IWinbixToken internal winbixToken;
128 
129     function winbixPayable(address payable _from, uint256 _value) internal;
130 
131     function catchWinbix(address payable _from, uint256 _value) external {
132         require(address(msg.sender) == address(winbixToken));
133         winbixPayable(_from, _value);
134     }
135 
136 }
137 
138 
139 contract IVerificationList is IOwnable {
140 
141     event Accept(address _address);
142     event Reject(address _address);
143     event SendToCheck(address _address);
144     event RemoveFromList(address _address);
145     
146     function isAccepted(address _address) public view returns (bool);
147     function isRejected(address _address) public view returns (bool);
148     function isOnCheck(address _address) public view returns (bool);
149     function isInList(address _address) public view returns (bool);
150     function isNotInList(address _address) public view returns (bool);
151     function isAcceptedOrNotInList(address _address) public view returns (bool);
152     function getState(address _address) public view returns (uint8);
153     
154     function accept(address _address) public;
155     function reject(address _address) public;
156     function toCheck(address _address) public;
157     function remove(address _address) public;
158 }
159 
160 contract IVoting is IOwnable {
161 
162     uint public startDate;
163     uint public endDate;
164     uint public votesYes;
165     uint public votesNo;
166     uint8 public subject;
167     uint public nextVotingDate;
168 
169 
170     event InitVoting(uint startDate, uint endDate, uint8 subject);
171     event Vote(address _address, int _vote);
172 
173     function initProlongationVoting() public;
174     function initTapChangeVoting(uint8 newPercent) public;
175     function inProgress() public view returns (bool);
176     function yes(address _address, uint _votes) public;
177     function no(address _address, uint _votes) public;
178     function vote(address _address) public view returns (int);
179     function votesTotal() public view returns (uint);
180     function isSubjectApproved() public view returns (bool);
181 }
182 
183 contract ITap is IOwnable {
184 
185     uint8[12] public tapPercents = [2, 2, 3, 11, 11, 17, 11, 11, 8, 8, 8, 8];
186     uint8 public nextTapNum;
187     uint8 public nextTapPercent = tapPercents[nextTapNum];
188     uint public nextTapDate;
189     uint public remainsForTap;
190     uint public baseEther;
191 
192     function init(uint _baseEther, uint _startDate) public;
193     function changeNextTap(uint8 _newPercent) public;
194     function getNext() public returns (uint);
195     function subRemainsForTap(uint _delta) public;
196 }
197 
198 contract IRefund is IOwnable {
199     
200     ITap public tap;
201     uint public refundedTokens;
202     uint public tokensBase;
203 
204     function init(uint _tokensBase, address _tap, uint _startDate) public;
205     function refundEther(uint _value) public returns (uint);
206     function calculateEtherForRefund(uint _tokensAmount) public view returns (uint);
207 }
208 
209 contract PreDAICO is Ownable, WinbixPayable, SafeMath {
210 
211     enum KycStates { None, OnCheck, Accepted, Rejected }
212     enum VotingType { None, Prolongation, TapChange }
213 
214     uint constant SOFTCAP = 6250000 ether;
215     uint constant HARDCAP = 25000000 ether;
216     uint constant TOKENS_FOR_MARKETING = 2500000 ether;
217     uint constant TOKENS_FOR_ISSUE = 27500000 ether;
218 
219     uint constant MIN_PURCHASE = 0.1 ether;
220 
221     uint constant SKIP_TIME = 15 minutes;
222 
223     uint constant PRICE1 = 550 szabo;
224     uint constant PRICE2 = 600 szabo;
225     uint constant PRICE3 = 650 szabo;
226     uint constant PRICE4 = 700 szabo;
227     uint constant PRICE5 = 750 szabo;
228 
229     uint public soldTokens;
230     uint public recievedEther;
231     uint public etherAfterKyc;
232     uint public tokensAfterKyc;
233     uint public refundedTokens;
234 
235     IVerificationList public buyers;
236     IVoting public voting;
237     ITap public tap;
238     IRefund public refund;
239 
240     address public kycChecker;
241 
242     mapping (address => uint) public etherPaid;
243     mapping (address => uint) public wbxSold;
244 
245     uint public startDate;
246     uint public endDate;
247     uint public additionalTime;
248 
249     uint public tokensForMarketingTotal;
250     uint public tokensForMarketingRemains;
251 
252     VotingType private votingType;
253     bool private votingApplied = true;
254 
255 
256     event HardcapCompiled();
257     event SoftcapCompiled();
258     event Tap(address _address, uint _value);
259     event Refund(address _address, uint _tokenAmount, uint _etherAmount);
260 
261     modifier isProceeds {
262         require(now >= startDate && now <= endDate);
263         _;
264     }
265 
266     modifier onlyKycChecker {
267         require(msg.sender == kycChecker);
268         _;
269     }
270 
271     function setExternals(
272         address _winbixToken,
273         address _buyers,
274         address _voting,
275         address _tap,
276         address _refund
277     ) public onlyOwner {
278         if (address(winbixToken) == address(0)) {
279             winbixToken = IWinbixToken(_winbixToken);
280             winbixToken.setMePayable(true);
281         }
282         if (address(buyers) == address(0)) {
283             buyers = IVerificationList(_buyers);
284             buyers.acceptOwnership();
285         }
286         if (address(voting) == address(0)) {
287             voting = IVoting(_voting);
288             voting.acceptOwnership();
289         }
290         if (address(tap) == address(0)) {
291             tap = ITap(_tap);
292             tap.acceptOwnership();
293         }
294         if (address(refund) == address(0)) {
295             refund = IRefund(_refund);
296             refund.acceptOwnership();
297         }
298         kycChecker = msg.sender;
299     }
300 
301     function setKycChecker(address _address) public onlyOwner {
302         kycChecker = _address;
303     }
304 
305     function startPreDaico() public onlyOwner {
306         require(
307             (startDate == 0) &&
308             address(buyers) != address(0) &&
309             address(voting) != address(0) &&
310             address(tap) != address(0) &&
311             address(refund) != address(0)
312         );
313         winbixToken.issue(address(this), TOKENS_FOR_ISSUE);
314         startDate = now;
315         endDate = now + 60 days;
316     }
317 
318     function () external payable isProceeds {
319         require(soldTokens < HARDCAP && msg.value >= MIN_PURCHASE);
320 
321         uint etherValue = msg.value;
322         uint tokenPrice = getTokenPrice();
323         uint tokenValue = safeMul(etherValue, 1 ether) / tokenPrice;
324         uint newSum = safeAdd(soldTokens, tokenValue);
325         bool softcapNotYetCompiled = soldTokens < SOFTCAP;
326 
327         buyers.toCheck(msg.sender);
328         winbixToken.freeze(msg.sender);
329 
330         if (newSum > HARDCAP) {
331             uint forRefund = safeMul((newSum - HARDCAP), tokenPrice) / (1 ether);
332             address(msg.sender).transfer(forRefund);
333             etherValue = safeSub(etherValue, forRefund);
334             tokenValue = safeSub(HARDCAP, soldTokens);
335         }
336 
337         soldTokens += tokenValue;
338         recievedEther += etherValue;
339         etherPaid[msg.sender] += etherValue;
340         wbxSold[msg.sender] += tokenValue;
341 
342         winbixToken.transfer(msg.sender, tokenValue);
343         winbixToken.issueVotable(msg.sender, tokenValue);
344         winbixToken.issueAccruable(msg.sender, tokenValue);
345 
346         if (softcapNotYetCompiled && soldTokens >= SOFTCAP) {
347             emit SoftcapCompiled();
348         }
349         if (soldTokens == HARDCAP) {
350             endDate = now;
351             emit HardcapCompiled();
352         }
353     }
354 
355     function getTokenPrice() public view returns (uint) {
356         if (soldTokens <= 5000000 ether) {
357             return PRICE1;
358         } else if (soldTokens <= 10000000 ether) {
359             return PRICE2;
360         } else if (soldTokens <= 15000000 ether) {
361             return PRICE3;
362         } else if (soldTokens <= 20000000 ether) {
363             return PRICE4;
364         } else {
365             return PRICE5;
366         }
367     }
368 
369     function kycSuccess(address _address) public onlyKycChecker {
370         require(now > endDate + SKIP_TIME && now < endDate + additionalTime + 15 days);
371         require(!buyers.isAccepted(_address));
372         etherAfterKyc += etherPaid[_address];
373         tokensAfterKyc += wbxSold[_address];
374         winbixToken.unfreeze(_address);
375         buyers.accept(_address);
376     }
377 
378     function kycFail(address _address) public onlyKycChecker {
379         require(now > endDate + SKIP_TIME && now < endDate + additionalTime + 15 days);
380         require(!buyers.isRejected(_address));
381         if (buyers.isAccepted(_address)) {
382             etherAfterKyc -= etherPaid[_address];
383             tokensAfterKyc -= wbxSold[_address];
384         }
385         winbixToken.freeze(_address);
386         buyers.reject(_address);
387     }
388 
389     function getKycState(address _address) public view returns (KycStates) {
390         return KycStates(buyers.getState(_address));
391     }
392 
393 
394     function prepareTokensAfterKyc() public {
395         require(tokensForMarketingTotal == 0);
396         require(now > endDate + additionalTime + 15 days + SKIP_TIME && soldTokens >= SOFTCAP);
397         tokensForMarketingTotal = tokensAfterKyc / 10;
398         tokensForMarketingRemains = tokensForMarketingTotal;
399         winbixToken.burn(TOKENS_FOR_ISSUE - soldTokens - tokensForMarketingTotal);
400         winbixToken.allowTransfer(true);
401         tap.init(etherAfterKyc, endDate + additionalTime + 17 days + SKIP_TIME);
402         refund.init(tokensAfterKyc, address(tap), endDate + 45 days);
403     }
404 
405     function transferTokensForMarketing(address _to, uint _value) public onlyOwner {
406         require(_value <= tokensForMarketingRemains && buyers.isAcceptedOrNotInList(_to));
407         winbixToken.transfer(_to, _value);
408         winbixToken.issueAccruable(_to, _value);
409         tokensForMarketingRemains -= _value;
410     }
411 
412     function burnTokensIfSoftcapNotCompiled() public {
413         require(endDate > 0 && now > endDate + 2 days + SKIP_TIME && soldTokens < SOFTCAP);
414         winbixToken.burnAll();
415     }
416 
417 
418     function getTap() public onlyOwner {
419         uint tapValue = tap.getNext();
420         address(msg.sender).transfer(tapValue);
421         emit Tap(msg.sender, tapValue);
422     }
423 
424 
425     function getVotingSubject() public view returns (uint8) {
426         return voting.subject();
427     }
428 
429     function initCrowdsaleProlongationVoting() public onlyOwner {
430         require(now >= endDate + SKIP_TIME && now <= endDate + 12 hours);
431         require(soldTokens >= SOFTCAP * 75 / 100);
432         require(soldTokens <= HARDCAP * 90 / 100);
433         voting.initProlongationVoting();
434         votingApplied = false;
435         additionalTime = 2 days;
436         votingType = VotingType.Prolongation;
437     }
438 
439     function initTapChangeVoting(uint8 newPercent) public onlyOwner {
440         require(tokensForMarketingTotal > 0);
441         require(now > endDate + 17 days);
442         voting.initTapChangeVoting(newPercent);
443         votingApplied = false;
444         votingType = VotingType.TapChange;
445     }
446 
447     function isVotingInProgress() public view returns (bool) {
448         return voting.inProgress();
449     }
450 
451     function getVotingWeight(address _address) public view returns (uint) {
452         if (votingType == VotingType.TapChange && !buyers.isAccepted(_address)) {
453             return 0;
454         }
455         return winbixToken.votableBalanceOf(_address);
456     }
457 
458     function voteYes() public {
459         voting.yes(msg.sender, getVotingWeight(msg.sender));
460     }
461 
462     function voteNo() public {
463         voting.no(msg.sender, getVotingWeight(msg.sender));
464     }
465 
466     function getVote(address _address) public view returns (int) {
467         return voting.vote(_address);
468     }
469 
470     function getVotesTotal() public view returns (uint) {
471         return voting.votesTotal();
472     }
473 
474     function isSubjectApproved() public view returns (bool) {
475         return voting.isSubjectApproved();
476     }
477 
478     function applyVotedProlongation() public {
479         require(now < endDate + 2 days);
480         require(votingType == VotingType.Prolongation);
481         require(!votingApplied);
482         require(!voting.inProgress());
483         votingApplied = true;
484         if (voting.isSubjectApproved()) {
485             startDate = endDate + 2 days;
486             endDate = startDate + 30 days;
487             additionalTime = 0;
488         }
489     }
490 
491     function applyVotedPercent() public {
492         require(votingType == VotingType.TapChange);
493         require(!votingApplied);
494         require(!voting.inProgress());
495         require(now < voting.nextVotingDate());
496         votingApplied = true;
497         if (voting.isSubjectApproved()) {
498             tap.changeNextTap(voting.subject());
499         }
500     }
501 
502 
503     function refundableBalanceOf(address _address) public view returns (uint) {
504         if (!buyers.isAcceptedOrNotInList(_address)) return 0;
505         return winbixToken.votableBalanceOf(_address);
506     }
507 
508     function calculateEtherForRefund(uint _tokensAmount) public view returns (uint) {
509         return refund.calculateEtherForRefund(_tokensAmount);
510     }
511 
512 
513     function winbixPayable(address payable _from, uint256 _value) internal {
514         if (_value == 0) return;
515         uint etherValue;
516         KycStates state = getKycState(_from);
517         if (
518             (soldTokens < SOFTCAP && now > endDate + 2 days) ||
519             ((state == KycStates.Rejected || state == KycStates.OnCheck) && (now > endDate + additionalTime + 17 days))
520         ) {
521             etherValue = etherPaid[_from];
522             require(etherValue > 0 && _value == wbxSold[_from]);
523             _from.transfer(etherValue);
524             etherPaid[_from] = 0;
525             wbxSold[_from] = 0;
526             winbixToken.unfreeze(_from);
527         } else {
528             require(winbixToken.votableBalanceOf(_from) >= _value);
529             etherValue = refund.refundEther(_value);
530             _from.transfer(etherValue);
531             tap.subRemainsForTap(etherValue);
532             emit Refund(_from, _value, etherValue);
533         }
534         winbixToken.burn(_value);
535     }
536 }