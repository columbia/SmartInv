1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address who) external view returns (uint256);
6   function transfer(address to, uint256 value) external returns (bool);
7   function allowance(address owner, address spender) external view returns (uint256);
8   function transferFrom(address from, address to, uint256 value) external returns (bool);
9   function approve(address spender, uint256 value) external returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
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
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 contract PoolAndSaleInterface {
50     address public tokenSaleAddr;
51     address public votingAddr;
52     address public votingTokenAddr;
53     uint256 public tap;
54     uint256 public initialTap;
55     uint256 public initialRelease;
56 
57     function setTokenSaleContract(address _tokenSaleAddr) external;
58     function startProject() external;
59 }
60 
61 contract DaicoPool is PoolAndSaleInterface, Ownable {
62     using SafeMath for uint256;
63 
64     address public tokenSaleAddr;
65     address public votingAddr;
66     address public votingTokenAddr;
67     uint256 public tap;
68     uint256 public initialTap;
69     uint256 public initialRelease;
70     uint256 public releasedBalance;
71     uint256 public withdrawnBalance;
72     uint256 public lastUpdatedTime;
73     uint256 public fundRaised;
74     uint256 public closingRelease = 30 days;
75 
76     /* The unit of this variable is [10^-9 wei / token], intending to minimize rouding errors */
77     uint256 public refundRateNano = 0;
78   
79     enum Status {
80         Initializing,
81         ProjectInProgress,
82         Destructed
83     }
84   
85     Status public status;
86 
87     event TapHistory(uint256 new_tap);
88     event WithdrawalHistory(string token, uint256 amount);
89     event Refund(address receiver, uint256 amount);
90 
91     modifier onlyTokenSaleContract {
92         require(msg.sender == tokenSaleAddr);
93         _;
94     }
95 
96     modifier onlyVoting {
97         require(msg.sender == votingAddr);
98         _;
99     }
100 
101     modifier poolInitializing {
102         require(status == Status.Initializing);
103         _;
104     }
105 
106     modifier poolDestructed {
107         require(status == Status.Destructed);
108         _;
109     }
110 
111     constructor(address _votingTokenAddr, uint256 tap_amount, uint256 _initialRelease) public {
112         require(_votingTokenAddr != 0x0);
113         require(tap_amount > 0);
114 
115         initialTap = tap_amount;
116         votingTokenAddr = _votingTokenAddr;
117         status = Status.Initializing;
118         initialRelease = _initialRelease;
119  
120         votingAddr = new Voting(ERC20Interface(_votingTokenAddr), address(this));
121     }
122 
123     function () external payable {}
124 
125     function setTokenSaleContract(address _tokenSaleAddr) external {
126         /* Can be set only once */
127         require(tokenSaleAddr == address(0x0));
128         require(_tokenSaleAddr != address(0x0));
129         tokenSaleAddr = _tokenSaleAddr;
130     }
131 
132     function startProject() external onlyTokenSaleContract {
133         require(status == Status.Initializing);
134         status = Status.ProjectInProgress;
135         lastUpdatedTime = block.timestamp;
136         releasedBalance = initialRelease;
137         updateTap(initialTap);
138         fundRaised = address(this).balance;
139     }
140 
141     function withdraw(uint256 _amount) public onlyOwner {
142         require(_amount > 0);
143         uint256 amount = _amount;
144 
145         updateReleasedBalance();
146         uint256 available_balance = getAvailableBalance();
147         if (amount > available_balance) {
148             amount = available_balance;
149         }
150 
151         withdrawnBalance = withdrawnBalance.add(amount);
152         owner.transfer(amount);
153 
154         emit WithdrawalHistory("ETH", amount);
155     }
156 
157     function raiseTap(uint256 tapMultiplierRate) external onlyVoting {
158         updateReleasedBalance();
159         updateTap(tap.mul(tapMultiplierRate).div(100));
160     }
161 
162     function selfDestruction() external onlyVoting {
163         status = Status.Destructed;
164         updateReleasedBalance();
165         releasedBalance = releasedBalance.add(closingRelease.mul(tap));
166         updateTap(0);
167 
168         uint256 _totalSupply = ERC20Interface(votingTokenAddr).totalSupply(); 
169         refundRateNano = address(this).balance.sub(getAvailableBalance()).mul(10**9).div(_totalSupply);
170     }
171 
172     function refund(uint256 tokenAmount) external poolDestructed {
173         require(ERC20Interface(votingTokenAddr).transferFrom(msg.sender, this, tokenAmount));
174 
175         uint256 refundingEther = tokenAmount.mul(refundRateNano).div(10**9);
176         emit Refund(msg.sender, tokenAmount);
177         msg.sender.transfer(refundingEther);
178     }
179 
180     function getReleasedBalance() public view returns(uint256) {
181         uint256 time_elapsed = block.timestamp.sub(lastUpdatedTime);
182         return releasedBalance.add(time_elapsed.mul(tap));
183     }
184  
185     function getAvailableBalance() public view returns(uint256) {
186         uint256 available_balance = getReleasedBalance().sub(withdrawnBalance);
187 
188         if (available_balance > address(this).balance) {
189             available_balance = address(this).balance;
190         }
191 
192         return available_balance;
193     }
194 
195     function isStateInitializing() public view returns(bool) {
196         return (status == Status.Initializing); 
197     }
198 
199     function isStateProjectInProgress() public view returns(bool) {
200         return (status == Status.ProjectInProgress); 
201     }
202 
203     function isStateDestructed() public view returns(bool) {
204         return (status == Status.Destructed); 
205     }
206 
207     function updateReleasedBalance() internal {
208         releasedBalance = getReleasedBalance();
209         lastUpdatedTime = block.timestamp;
210     }
211 
212     function updateTap(uint256 new_tap) private {
213         tap = new_tap;
214         emit TapHistory(new_tap);
215     }
216 }
217 
218 library SafeMath {
219 
220   /**
221   * @dev Multiplies two numbers, throws on overflow.
222   */
223   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224     if (a == 0) {
225       return 0;
226     }
227     uint256 c = a * b;
228     assert(c / a == b);
229     return c;
230   }
231 
232   /**
233   * @dev Integer division of two numbers, truncating the quotient.
234   */
235   function div(uint256 a, uint256 b) internal pure returns (uint256) {
236     // assert(b > 0); // Solidity automatically throws when dividing by 0
237     // uint256 c = a / b;
238     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239     return a / b;
240   }
241 
242   /**
243   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
244   */
245   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
246     assert(b <= a);
247     return a - b;
248   }
249 
250   /**
251   * @dev Adds two numbers, throws on overflow.
252   */
253   function add(uint256 a, uint256 b) internal pure returns (uint256) {
254     uint256 c = a + b;
255     assert(c >= a);
256     return c;
257   }
258 }
259 
260 contract Voting{
261     using SafeMath for uint256;
262 
263     address public votingTokenAddr;
264     address public poolAddr;
265     mapping (uint256 => mapping(address => uint256)) public deposits;
266     mapping (uint => bool) public queued;
267 
268     uint256 proposalCostWei = 1 * 10**18;
269 
270     uint256 public constant VOTING_PERIOD = 14 days;
271 
272     struct Proposal {
273         uint256 start_time;
274         uint256 end_time;
275         Subject subject;
276         string reason;
277         mapping (bool => uint256) votes; 
278         uint256 voter_count;
279         bool isFinalized;
280         uint256 tapMultiplierRate;
281     }
282 
283     Proposal[] public proposals;
284     uint public constant PROPOSAL_EMPTY = 0;
285 
286     enum Subject {
287         RaiseTap,
288         Destruction
289     }
290 
291     event Vote(
292         address indexed voter,
293         uint256 amount
294     );
295 
296     event ReturnDeposit(
297         address indexed voter,
298         uint256 amount
299     );
300 
301     event ProposalRaised(
302         address indexed proposer,
303         string subject 
304     );
305 
306     /// @dev Constructor.
307     /// @param _votingTokenAddr The contract address of ERC20 
308     /// @param _poolAddr The contract address of DaicoPool
309     /// @return 
310     constructor (
311         address _votingTokenAddr,
312         address _poolAddr
313     ) public {
314         require(_votingTokenAddr != address(0x0));
315         require(_poolAddr != address(0x0));
316         votingTokenAddr = _votingTokenAddr;
317         poolAddr = _poolAddr;
318 
319         // Insert an empty proposal as the header in order to make index 0 to be missing number.
320         Proposal memory proposal;
321         proposal.subject = Subject.RaiseTap;
322         proposal.reason = "PROPOSAL_HEADER";
323         proposal.start_time = block.timestamp -1;
324         proposal.end_time = block.timestamp -1;
325         proposal.voter_count = 0;
326         proposal.isFinalized = true;
327 
328         proposals.push(proposal);
329         assert(proposals.length == 1);
330     }
331 
332     /// @dev Make a TAP raising proposal. It costs certain amount of ETH.
333     /// @param _reason The reason to raise the TAP. This field can be an URL of a WEB site.
334     /// @param _tapMultiplierRate TAP increase rate. From 101 to 200. i.e. 150 = 150% .
335     /// @return 
336     function addRaiseTapProposal (
337         string _reason,
338         uint256 _tapMultiplierRate
339     ) external payable returns(uint256) {
340         require(!queued[uint(Subject.RaiseTap)]);
341         require(100 < _tapMultiplierRate && _tapMultiplierRate <= 200);
342 
343         uint256 newID = addProposal(Subject.RaiseTap, _reason);
344         proposals[newID].tapMultiplierRate = _tapMultiplierRate;
345 
346         queued[uint(Subject.RaiseTap)] = true;
347         emit ProposalRaised(msg.sender, "RaiseTap");
348     }
349 
350     /// @dev Make a self destruction proposal. It costs certain amount of ETH.
351     /// @param _reason The reason to destruct the pool. This field can be an URL of a WEB site.
352     /// @return 
353     function addDestructionProposal (string _reason) external payable returns(uint256) {
354         require(!queued[uint(Subject.Destruction)]);
355 
356         addProposal(Subject.Destruction, _reason);
357 
358         queued[uint(Subject.Destruction)] = true;
359         emit ProposalRaised(msg.sender, "SelfDestruction");
360     }
361 
362     /// @dev Vote yes or no to current proposal.
363     /// @param amount Token amount to be voted.
364     /// @return 
365     function vote (bool agree, uint256 amount) external {
366         require(ERC20Interface(votingTokenAddr).transferFrom(msg.sender, this, amount));
367         uint256 pid = this.getCurrentVoting();
368         require(pid != PROPOSAL_EMPTY);
369 
370         require(proposals[pid].start_time <= block.timestamp);
371         require(proposals[pid].end_time >= block.timestamp);
372 
373         if (deposits[pid][msg.sender] == 0) {
374             proposals[pid].voter_count = proposals[pid].voter_count.add(1);
375         }
376 
377         deposits[pid][msg.sender] = deposits[pid][msg.sender].add(amount);
378         proposals[pid].votes[agree] = proposals[pid].votes[agree].add(amount);
379         emit Vote(msg.sender, amount);
380     }
381 
382     /// @dev Finalize the current voting. It can be invoked when the end time past.
383     /// @dev Anyone can invoke this function.
384     /// @return 
385     function finalizeVoting () external {
386         uint256 pid = this.getCurrentVoting();
387         require(pid != PROPOSAL_EMPTY);
388         require(proposals[pid].end_time <= block.timestamp);
389         require(!proposals[pid].isFinalized);
390 
391         proposals[pid].isFinalized = true;
392 
393         if (isSubjectRaiseTap(pid)) {
394             queued[uint(Subject.RaiseTap)] = false;
395             if (isPassed(pid)) {
396                 DaicoPool(poolAddr).raiseTap(proposals[pid].tapMultiplierRate);
397             }
398 
399         } else if (isSubjectDestruction(pid)) {
400             queued[uint(Subject.Destruction)] = false;
401             if (isPassed(pid)) {
402                 DaicoPool(poolAddr).selfDestruction();
403             }
404         }
405     }
406 
407     /// @dev Return all tokens which specific account used to vote so far.
408     /// @param account An address that deposited tokens. It also be the receiver.
409     /// @return 
410     function returnToken (address account) external returns(bool) {
411         uint256 amount = 0;
412     
413         for (uint256 pid = 0; pid < proposals.length; pid++) {
414             if(!proposals[pid].isFinalized){
415               break;
416             }
417             amount = amount.add(deposits[pid][account]);
418             deposits[pid][account] = 0;
419         }
420 
421         if(amount <= 0){
422            return false;
423         }
424 
425         require(ERC20Interface(votingTokenAddr).transfer(account, amount));
426         emit ReturnDeposit(account, amount);
427  
428         return true;
429     }
430 
431     /// @dev Return tokens to multiple addresses.
432     /// @param accounts Addresses that deposited tokens. They also be the receivers.
433     /// @return 
434     function returnTokenMulti (address[] accounts) external {
435         for(uint256 i = 0; i < accounts.length; i++){
436             this.returnToken(accounts[i]);
437         }
438     }
439 
440     /// @dev Return the index of on going voting.
441     /// @return The index of voting. 
442     function getCurrentVoting () public view returns(uint256) {
443         for (uint256 i = 0; i < proposals.length; i++) {
444             if (!proposals[i].isFinalized) {
445                 return i;
446             }
447         }
448         return PROPOSAL_EMPTY;
449     }
450 
451     /// @dev Check if a proposal has been agreed or not.
452     /// @param pid Index of a proposal.
453     /// @return True if the proposal passed. False otherwise. 
454     function isPassed (uint256 pid) public view returns(bool) {
455         require(proposals[pid].isFinalized);
456         uint256 ayes = getAyes(pid);
457         uint256 nays = getNays(pid);
458         uint256 absent = ERC20Interface(votingTokenAddr).totalSupply().sub(ayes).sub(nays);
459         return (ayes > nays.add(absent.div(6)));
460     }
461 
462     /// @dev Check if a voting has started or not.
463     /// @param pid Index of a proposal.
464     /// @return True if the voting already started. False otherwise. 
465     function isStarted (uint256 pid) public view returns(bool) {
466         if (pid > proposals.length) {
467             return false;
468         } else if (block.timestamp >= proposals[pid].start_time) {
469             return true;
470         }
471         return false;
472     }
473 
474     /// @dev Check if a voting has ended or not.
475     /// @param pid Index of a proposal.
476     /// @return True if the voting already ended. False otherwise. 
477     function isEnded (uint256 pid) public view returns(bool) {
478         if (pid > proposals.length) {
479             return false;
480         } else if (block.timestamp >= proposals[pid].end_time) {
481             return true;
482         }
483         return false;
484     }
485 
486     /// @dev Return the reason of a proposal.
487     /// @param pid Index of a proposal.
488     /// @return Text of the reason that is set when the proposal made. 
489     function getReason (uint256 pid) external view returns(string) {
490         require(pid < proposals.length);
491         return proposals[pid].reason;
492     }
493 
494     /// @dev Check if a proposal is about TAP raising or not.
495     /// @param pid Index of a proposal.
496     /// @return True if it's TAP raising. False otherwise.
497     function isSubjectRaiseTap (uint256 pid) public view returns(bool) {
498         require(pid < proposals.length);
499         return proposals[pid].subject == Subject.RaiseTap;
500     }
501 
502     /// @dev Check if a proposal is about self destruction or not.
503     /// @param pid Index of a proposal.
504     /// @return True if it's self destruction. False otherwise.
505     function isSubjectDestruction (uint256 pid) public view returns(bool) {
506         require(pid < proposals.length);
507         return proposals[pid].subject == Subject.Destruction;
508     }
509 
510     /// @dev Return the number of voters take part in a specific voting.
511     /// @param pid Index of a proposal.
512     /// @return The number of voters.
513     function getVoterCount (uint256 pid) external view returns(uint256) {
514         require(pid < proposals.length);
515         return proposals[pid].voter_count;
516     }
517 
518     /// @dev Return the number of votes that agrees the proposal.
519     /// @param pid Index of a proposal.
520     /// @return The number of votes that agrees the proposal.
521     function getAyes (uint256 pid) public view returns(uint256) {
522         require(pid < proposals.length);
523         require(proposals[pid].isFinalized);
524         return proposals[pid].votes[true];
525     }
526 
527     /// @dev Return the number of votes that disagrees the proposal.
528     /// @param pid Index of a proposal.
529     /// @return The number of votes that disagrees the proposal.
530     function getNays (uint256 pid) public view returns(uint256) {
531         require(pid < proposals.length);
532         require(proposals[pid].isFinalized);
533         return proposals[pid].votes[false];
534     }
535 
536     /// @dev Internal function to add a proposal into the voting queue.
537     /// @param _subject Subject of the proposal. Can be TAP raising or self destruction.
538     /// @param _reason Reason of the proposal. This field can be an URL of a WEB site.
539     /// @return Index of the proposal.
540     function addProposal (Subject _subject, string _reason) internal returns(uint256) {
541         require(msg.value == proposalCostWei);
542         require(DaicoPool(poolAddr).isStateProjectInProgress());
543         poolAddr.transfer(msg.value);
544 
545         Proposal memory proposal;
546         proposal.subject = _subject;
547         proposal.reason = _reason;
548         proposal.start_time = block.timestamp;
549         proposal.end_time = block.timestamp + VOTING_PERIOD;
550         proposal.voter_count = 0;
551         proposal.isFinalized = false;
552 
553         proposals.push(proposal);
554         uint256 newID = proposals.length - 1;
555         return newID;
556     }
557 }