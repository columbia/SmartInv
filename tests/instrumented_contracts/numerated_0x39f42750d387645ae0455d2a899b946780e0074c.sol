1 pragma solidity ^0.4.24;
2 
3 contract Approvable {
4 
5     mapping(address => bool) public approved;
6 
7     constructor () public {
8         approved[msg.sender] = true;
9     }
10 
11     function approve(address _address) public onlyApproved {
12         require(_address != address(0));
13         approved[_address] = true;
14     }
15 
16     function revokeApproval(address _address) public onlyApproved {
17         require(_address != address(0));
18         approved[_address] = false;
19     }
20 
21     modifier onlyApproved() {
22         require(approved[msg.sender]);
23         _;
24     }
25 }
26 
27 contract DIDToken is Approvable {
28 
29     using SafeMath for uint256;
30 
31     event LogIssueDID(address indexed to, uint256 numDID);
32     event LogDecrementDID(address indexed to, uint256 numDID);
33     event LogExchangeDIDForEther(address indexed to, uint256 numDID);
34     event LogInvestEtherForDID(address indexed to, uint256 numWei);
35 
36     address[] public DIDHoldersArray;
37 
38     address public PullRequestsAddress;
39     address public DistenseAddress;
40 
41     uint256 public investmentLimitAggregate  = 100000 ether;  // This is the max DID all addresses can receive from depositing ether
42     uint256 public investmentLimitAddress = 100 ether;  // This is the max DID any address can receive from Ether deposit
43     uint256 public investedAggregate = 1 ether;
44 
45     string public name;
46     string public symbol;
47     uint8 public decimals;
48     uint256 public totalSupply;
49 
50     struct DIDHolder {
51         uint256 balance;
52         uint256 netContributionsDID;    // essentially the number of DID remaining for calculating how much ether an account may invest
53         uint256 DIDHoldersIndex;
54         uint256 weiInvested;
55         uint256 tasksCompleted;
56     }
57     mapping (address => DIDHolder) public DIDHolders;
58 
59     constructor () public {
60         name = "Distense DID";
61         symbol = "DID";
62         totalSupply = 0;
63         decimals = 18;
64     }
65 
66     function issueDID(address _recipient, uint256 _numDID) public onlyApproved returns (bool) {
67         require(_recipient != address(0));
68         require(_numDID > 0);
69 
70         _numDID = _numDID * 1 ether;
71         totalSupply = SafeMath.add(totalSupply, _numDID);
72         
73         uint256 balance = DIDHolders[_recipient].balance;
74         DIDHolders[_recipient].balance = SafeMath.add(balance, _numDID);
75 
76         //  If is a new DIDHolder, set their position in DIDHoldersArray
77         if (DIDHolders[_recipient].DIDHoldersIndex == 0) {
78             uint256 index = DIDHoldersArray.push(_recipient) - 1;
79             DIDHolders[_recipient].DIDHoldersIndex = index;
80         }
81 
82         emit LogIssueDID(_recipient, _numDID);
83 
84         return true;
85     }
86 
87     function decrementDID(address _address, uint256 _numDID) external onlyApproved returns (uint256) {
88         require(_address != address(0));
89         require(_numDID > 0);
90 
91         uint256 numDID = _numDID * 1 ether;
92         require(SafeMath.sub(DIDHolders[_address].balance, numDID) >= 0);
93         require(SafeMath.sub(totalSupply, numDID ) >= 0);
94 
95         totalSupply = SafeMath.sub(totalSupply, numDID);
96         DIDHolders[_address].balance = SafeMath.sub(DIDHolders[_address].balance, numDID);
97 
98         //  If DIDHolder has exchanged all of their DID remove from DIDHoldersArray
99         //  For minimizing blockchain size and later client query performance
100         if (DIDHolders[_address].balance == 0) {
101             deleteDIDHolderWhenBalanceZero(_address);
102         }
103 
104         emit LogDecrementDID(_address, numDID);
105 
106         return DIDHolders[_address].balance;
107     }
108 
109     function exchangeDIDForEther(uint256 _numDIDToExchange)
110         external
111     returns (uint256) {
112 
113         uint256 numDIDToExchange = _numDIDToExchange * 1 ether;
114         uint256 netContributionsDID = getNumContributionsDID(msg.sender);
115         require(netContributionsDID >= numDIDToExchange);
116 
117         Distense distense = Distense(DistenseAddress);
118         uint256 DIDPerEther = distense.getParameterValueByTitle(distense.didPerEtherParameterTitle());
119 
120         require(numDIDToExchange < totalSupply);
121 
122         uint256 numWeiToIssue = calculateNumWeiToIssue(numDIDToExchange, DIDPerEther);
123         address contractAddress = this;
124         require(contractAddress.balance >= numWeiToIssue, "DIDToken contract must have sufficient wei");
125 
126         //  Adjust number of DID owned first
127         DIDHolders[msg.sender].balance = SafeMath.sub(DIDHolders[msg.sender].balance, numDIDToExchange);
128         DIDHolders[msg.sender].netContributionsDID = SafeMath.sub(DIDHolders[msg.sender].netContributionsDID, numDIDToExchange);
129         totalSupply = SafeMath.sub(totalSupply, numDIDToExchange);
130 
131         msg.sender.transfer(numWeiToIssue);
132 
133         if (DIDHolders[msg.sender].balance == 0) {
134             deleteDIDHolderWhenBalanceZero(msg.sender);
135         }
136         emit LogExchangeDIDForEther(msg.sender, numDIDToExchange);
137 
138         return DIDHolders[msg.sender].balance;
139     }
140 
141     function investEtherForDID() external payable returns (uint256) {
142         require(getNumWeiAddressMayInvest(msg.sender) >= msg.value);
143         require(investedAggregate < investmentLimitAggregate);
144 
145         Distense distense = Distense(DistenseAddress);
146         uint256 DIDPerEther = SafeMath.div(distense.getParameterValueByTitle(distense.didPerEtherParameterTitle()), 1 ether);
147 
148         uint256 numDIDToIssue = calculateNumDIDToIssue(msg.value, DIDPerEther);
149         require(DIDHolders[msg.sender].netContributionsDID >= numDIDToIssue);
150         totalSupply = SafeMath.add(totalSupply, numDIDToIssue);
151         DIDHolders[msg.sender].balance = SafeMath.add(DIDHolders[msg.sender].balance, numDIDToIssue);
152         DIDHolders[msg.sender].netContributionsDID = SafeMath.sub(DIDHolders[msg.sender].netContributionsDID, numDIDToIssue);
153 
154         DIDHolders[msg.sender].weiInvested += msg.value;
155         investedAggregate = investedAggregate + msg.value;
156 
157         emit LogIssueDID(msg.sender, numDIDToIssue);
158         emit LogInvestEtherForDID(msg.sender, msg.value);
159 
160         return DIDHolders[msg.sender].balance;
161     }
162 
163     function incrementDIDFromContributions(address _contributor, uint256 _reward) onlyApproved public {
164         uint256 weiReward = _reward * 1 ether;
165         DIDHolders[_contributor].netContributionsDID = SafeMath.add(DIDHolders[_contributor].netContributionsDID, weiReward);
166     }
167 
168     function incrementTasksCompleted(address _contributor) onlyApproved public returns (bool) {
169         DIDHolders[_contributor].tasksCompleted++;
170         return true;
171     }
172 
173     function pctDIDOwned(address _address) external view returns (uint256) {
174         return SafeMath.percent(DIDHolders[_address].balance, totalSupply, 20);
175     }
176 
177     function getNumWeiAddressMayInvest(address _contributor) public view returns (uint256) {
178 
179         uint256 DIDFromContributions = DIDHolders[_contributor].netContributionsDID;
180         require(DIDFromContributions > 0);
181         uint256 netUninvestedEther = SafeMath.sub(investmentLimitAddress, DIDHolders[_contributor].weiInvested);
182         require(netUninvestedEther > 0);
183 
184         Distense distense = Distense(DistenseAddress);
185         uint256 DIDPerEther = distense.getParameterValueByTitle(distense.didPerEtherParameterTitle());
186 
187         return (DIDFromContributions * 1 ether) / DIDPerEther;
188     }
189 
190     function rewardContributor(address _contributor, uint256 _reward) external onlyApproved returns (bool) {
191         uint256 reward = SafeMath.div(_reward, 1 ether);
192         bool issued = issueDID(_contributor, reward);
193         if (issued) incrementDIDFromContributions(_contributor, reward);
194         incrementTasksCompleted(_contributor);
195     }
196 
197     function getWeiAggregateMayInvest() public view returns (uint256) {
198         return SafeMath.sub(investmentLimitAggregate, investedAggregate);
199     }
200 
201     function getNumDIDHolders() external view returns (uint256) {
202         return DIDHoldersArray.length;
203     }
204 
205     function getAddressBalance(address _address) public view returns (uint256) {
206         return DIDHolders[_address].balance;
207     }
208 
209     function getNumContributionsDID(address _address) public view returns (uint256) {
210         return DIDHolders[_address].netContributionsDID;
211     }
212 
213     function getWeiInvested(address _address) public view returns (uint256) {
214         return DIDHolders[_address].weiInvested;
215     }
216 
217     function calculateNumDIDToIssue(uint256 msgValue, uint256 DIDPerEther) public pure returns (uint256) {
218         return SafeMath.mul(msgValue, DIDPerEther);
219     }
220 
221     function calculateNumWeiToIssue(uint256 _numDIDToExchange, uint256 _DIDPerEther) public pure returns (uint256) {
222         _numDIDToExchange = _numDIDToExchange * 1 ether;
223         return SafeMath.div(_numDIDToExchange, _DIDPerEther);
224     }
225 
226     function deleteDIDHolderWhenBalanceZero(address holder) internal {
227         if (DIDHoldersArray.length > 1) {
228             address lastElement = DIDHoldersArray[DIDHoldersArray.length - 1];
229             DIDHoldersArray[DIDHolders[holder].DIDHoldersIndex] = lastElement;
230             DIDHoldersArray.length--;
231             delete DIDHolders[holder];
232         }
233     }
234 
235     function deleteDIDHolder(address holder) public onlyApproved {
236         if (DIDHoldersArray.length > 1) {
237             address lastElement = DIDHoldersArray[DIDHoldersArray.length - 1];
238             DIDHoldersArray[DIDHolders[holder].DIDHoldersIndex] = lastElement;
239             DIDHoldersArray.length--;
240             delete DIDHolders[holder];
241         }
242     }
243 
244     function setDistenseAddress(address _distenseAddress) onlyApproved public  {
245         DistenseAddress = _distenseAddress;
246     }
247 
248 }
249 
250 contract Distense is Approvable {
251 
252     using SafeMath for uint256;
253 
254     address public DIDTokenAddress;
255 
256     /*
257       Distense' votable parameters
258       Parameter is the perfect word` for these: "a numerical or other measurable factor forming one of a set
259       that defines a system or sets the conditions of its operation".
260     */
261 
262     //  Titles are what uniquely identify parameters, so query by titles when iterating with clients
263     bytes32[] public parameterTitles;
264 
265     struct Parameter {
266         bytes32 title;
267         uint256 value;
268         mapping(address => Vote) votes;
269     }
270 
271     struct Vote {
272         address voter;
273         uint256 lastVoted;
274     }
275 
276     mapping(bytes32 => Parameter) public parameters;
277 
278     Parameter public votingIntervalParameter;
279     bytes32 public votingIntervalParameterTitle = 'votingInterval';
280 
281     Parameter public pctDIDToDetermineTaskRewardParameter;
282     bytes32 public pctDIDToDetermineTaskRewardParameterTitle = 'pctDIDToDetermineTaskReward';
283 
284     Parameter public pctDIDRequiredToMergePullRequest;
285     bytes32 public pctDIDRequiredToMergePullRequestTitle = 'pctDIDRequiredToMergePullRequest';
286 
287     Parameter public maxRewardParameter;
288     bytes32 public maxRewardParameterTitle = 'maxReward';
289 
290     Parameter public numDIDRequiredToApproveVotePullRequestParameter;
291     bytes32 public numDIDRequiredToApproveVotePullRequestParameterTitle = 'numDIDReqApproveVotePullRequest';
292 
293     Parameter public numDIDRequiredToTaskRewardVoteParameter;
294     bytes32 public numDIDRequiredToTaskRewardVoteParameterTitle = 'numDIDRequiredToTaskRewardVote';
295 
296     Parameter public minNumberOfTaskRewardVotersParameter;
297     bytes32 public minNumberOfTaskRewardVotersParameterTitle = 'minNumberOfTaskRewardVoters';
298 
299     Parameter public numDIDRequiredToAddTaskParameter;
300     bytes32 public numDIDRequiredToAddTaskParameterTitle = 'numDIDRequiredToAddTask';
301 
302     Parameter public defaultRewardParameter;
303     bytes32 public defaultRewardParameterTitle = 'defaultReward';
304 
305     Parameter public didPerEtherParameter;
306     bytes32 public didPerEtherParameterTitle = 'didPerEther';
307 
308     Parameter public votingPowerLimitParameter;
309     bytes32 public votingPowerLimitParameterTitle = 'votingPowerLimit';
310 
311     event LogParameterValueUpdate(bytes32 title, uint256 value);
312 
313     constructor (address _DIDTokenAddress) public {
314 
315         DIDTokenAddress = _DIDTokenAddress;
316 
317         // Launch Distense with some votable parameters
318         // that can be later updated by contributors
319         // Current values can be found at https://disten.se/parameters
320 
321         // Percentage of DID that must vote on a proposal for it to be approved and payable
322         pctDIDToDetermineTaskRewardParameter = Parameter({
323             title : pctDIDToDetermineTaskRewardParameterTitle,
324             //     Every hard-coded int except for dates and numbers (not percentages) pertaining to ether or DID are decimals to two decimal places
325             //     So this is 15.00%
326             value: 15 * 1 ether
327         });
328         parameters[pctDIDToDetermineTaskRewardParameterTitle] = pctDIDToDetermineTaskRewardParameter;
329         parameterTitles.push(pctDIDToDetermineTaskRewardParameterTitle);
330 
331 
332         pctDIDRequiredToMergePullRequest = Parameter({
333             title : pctDIDRequiredToMergePullRequestTitle,
334             value: 10 * 1 ether
335         });
336         parameters[pctDIDRequiredToMergePullRequestTitle] = pctDIDRequiredToMergePullRequest;
337         parameterTitles.push(pctDIDRequiredToMergePullRequestTitle);
338 
339 
340         votingIntervalParameter = Parameter({
341             title : votingIntervalParameterTitle,
342             value: 1296000 * 1 ether// 15 * 86400 = 1.296e+6
343         });
344         parameters[votingIntervalParameterTitle] = votingIntervalParameter;
345         parameterTitles.push(votingIntervalParameterTitle);
346 
347 
348         maxRewardParameter = Parameter({
349             title : maxRewardParameterTitle,
350             value: 2000 * 1 ether
351         });
352         parameters[maxRewardParameterTitle] = maxRewardParameter;
353         parameterTitles.push(maxRewardParameterTitle);
354 
355 
356         numDIDRequiredToApproveVotePullRequestParameter = Parameter({
357             title : numDIDRequiredToApproveVotePullRequestParameterTitle,
358             //     100 DID
359             value: 100 * 1 ether
360         });
361         parameters[numDIDRequiredToApproveVotePullRequestParameterTitle] = numDIDRequiredToApproveVotePullRequestParameter;
362         parameterTitles.push(numDIDRequiredToApproveVotePullRequestParameterTitle);
363 
364 
365         // This parameter is the number of DID an account must own to vote on a task's reward
366         // The task reward is the number of DID payable upon successful completion and approval of a task
367 
368         // This parameter mostly exists to get the percentage of DID that have voted higher per voter
369         //   as looping through voters to determineReward()s is gas-expensive.
370 
371         // This parameter also limits attacks by noobs that want to mess with Distense.
372         numDIDRequiredToTaskRewardVoteParameter = Parameter({
373             title : numDIDRequiredToTaskRewardVoteParameterTitle,
374             // 100
375             value: 100 * 1 ether
376         });
377         parameters[numDIDRequiredToTaskRewardVoteParameterTitle] = numDIDRequiredToTaskRewardVoteParameter;
378         parameterTitles.push(numDIDRequiredToTaskRewardVoteParameterTitle);
379 
380 
381         minNumberOfTaskRewardVotersParameter = Parameter({
382             title : minNumberOfTaskRewardVotersParameterTitle,
383             //     7
384             value: 7 * 1 ether
385         });
386         parameters[minNumberOfTaskRewardVotersParameterTitle] = minNumberOfTaskRewardVotersParameter;
387         parameterTitles.push(minNumberOfTaskRewardVotersParameterTitle);
388 
389 
390         numDIDRequiredToAddTaskParameter = Parameter({
391             title : numDIDRequiredToAddTaskParameterTitle,
392             //     100
393             value: 100 * 1 ether
394         });
395         parameters[numDIDRequiredToAddTaskParameterTitle] = numDIDRequiredToAddTaskParameter;
396         parameterTitles.push(numDIDRequiredToAddTaskParameterTitle);
397 
398 
399         defaultRewardParameter = Parameter({
400             title : defaultRewardParameterTitle,
401             //     100
402             value: 100 * 1 ether
403         });
404         parameters[defaultRewardParameterTitle] = defaultRewardParameter;
405         parameterTitles.push(defaultRewardParameterTitle);
406 
407 
408         didPerEtherParameter = Parameter({
409             title : didPerEtherParameterTitle,
410             //     1000
411             value: 200 * 1 ether
412         });
413         parameters[didPerEtherParameterTitle] = didPerEtherParameter;
414         parameterTitles.push(didPerEtherParameterTitle);
415 
416         votingPowerLimitParameter = Parameter({
417             title : votingPowerLimitParameterTitle,
418             //     20.00%
419             value: 20 * 1 ether
420         });
421         parameters[votingPowerLimitParameterTitle] = votingPowerLimitParameter;
422         parameterTitles.push(votingPowerLimitParameterTitle);
423 
424     }
425 
426     function getParameterValueByTitle(bytes32 _title) public view returns (uint256) {
427         return parameters[_title].value;
428     }
429 
430     /**
431         Function called when contributors vote on parameters at /parameters url
432         In the client there are: max and min buttons and a text input
433 
434         @param _title name of parameter title the DID holder is voting on.  This must be one of the hardcoded titles in this file.
435         @param _voteValue integer in percentage effect.  For example if the current value of a parameter is 20, and the voter votes 24, _voteValue
436         would be 20, for a 20% increase.
437 
438         If _voteValue is 1 it's a max upvote, if -1 max downvote. Maximum votes, as just mentioned, affect parameter values by
439         max(percentage of DID owned by the voter, value of the votingLimit parameter).
440         If _voteValue has a higher absolute value than 1, the user has voted a specific value not maximum up or downvote.
441         In that case we update the value to the voted value if the value would affect the parameter value less than their percentage DID ownership.
442           If they voted a value that would affect the parameter's value by more than their percentage DID ownership we affect the value by their percentage DID ownership.
443     */
444     function voteOnParameter(bytes32 _title, int256 _voteValue)
445         public
446         votingIntervalReached(msg.sender, _title)
447         returns
448     (uint256) {
449 
450         DIDToken didToken = DIDToken(DIDTokenAddress);
451         uint256 votersDIDPercent = didToken.pctDIDOwned(msg.sender);
452         require(votersDIDPercent > 0);
453 
454         uint256 currentValue = getParameterValueByTitle(_title);
455 
456         //  For voting power purposes, limit the pctDIDOwned to the maximum of the Voting Power Limit parameter or the voter's percentage ownership
457         //  of DID
458         uint256 votingPowerLimit = getParameterValueByTitle(votingPowerLimitParameterTitle);
459 
460         uint256 limitedVotingPower = votersDIDPercent > votingPowerLimit ? votingPowerLimit : votersDIDPercent;
461 
462         uint256 update;
463         if (
464             _voteValue == 1 ||  // maximum upvote
465             _voteValue == - 1 || // minimum downvote
466             _voteValue > int(limitedVotingPower) || // vote value greater than votingPowerLimit
467             _voteValue < - int(limitedVotingPower)  // vote value greater than votingPowerLimit absolute value
468         ) {
469             update = (limitedVotingPower * currentValue) / (100 * 1 ether);
470         } else if (_voteValue > 0) {
471             update = SafeMath.div((uint(_voteValue) * currentValue), (1 ether * 100));
472         } else if (_voteValue < 0) {
473             int256 adjustedVoteValue = (-_voteValue); // make the voteValue positive and convert to on-chain decimals
474             update = uint((adjustedVoteValue * int(currentValue))) / (100 * 1 ether);
475         } else revert(); //  If _voteValue is 0 refund gas to voter
476 
477         if (_voteValue > 0)
478             currentValue = SafeMath.add(currentValue, update);
479         else
480             currentValue = SafeMath.sub(currentValue, update);
481 
482         updateParameterValue(_title, currentValue);
483         updateLastVotedOnParameter(_title, msg.sender);
484         emit LogParameterValueUpdate(_title, currentValue);
485 
486         return currentValue;
487     }
488 
489     function getParameterByTitle(bytes32 _title) public view returns (bytes32, uint256) {
490         Parameter memory param = parameters[_title];
491         return (param.title, param.value);
492     }
493 
494     function getNumParameters() public view returns (uint256) {
495         return parameterTitles.length;
496     }
497 
498     function updateParameterValue(bytes32 _title, uint256 _newValue) internal returns (uint256) {
499         Parameter storage parameter = parameters[_title];
500         parameter.value = _newValue;
501         return parameter.value;
502     }
503 
504     function updateLastVotedOnParameter(bytes32 _title, address voter) internal returns (bool) {
505         Parameter storage parameter = parameters[_title];
506         parameter.votes[voter].lastVoted = now;
507     }
508 
509     function setDIDTokenAddress(address _didTokenAddress) public onlyApproved {
510         DIDTokenAddress = _didTokenAddress;
511     }
512 
513     modifier votingIntervalReached(address _voter, bytes32 _title) {
514         Parameter storage parameter = parameters[_title];
515         uint256 lastVotedOnParameter = parameter.votes[_voter].lastVoted * 1 ether;
516         require((now * 1 ether) >= lastVotedOnParameter + getParameterValueByTitle(votingIntervalParameterTitle));
517         _;
518     }
519 }
520 
521 contract PullRequests is Approvable {
522 
523     address public DIDTokenAddress;
524     address public DistenseAddress;
525     address public TasksAddress;
526 
527     struct PullRequest {
528         address contributor;
529         bytes32 taskId;
530         uint128 prNum;
531         uint256 pctDIDApproved;
532         mapping(address => bool) voted;
533     }
534 
535     bytes32[] public pullRequestIds;
536 
537     mapping(bytes32 => PullRequest) pullRequests;
538 
539     event LogAddPullRequest(bytes32 _prId, bytes32 taskId, uint128 prNum);
540     event LogPullRequestApprovalVote(bytes32 _prId, uint256 pctDIDApproved);
541     event LogRewardPullRequest(bytes32 _prId, bytes32 taskId, uint128 prNum);
542 
543     constructor (
544         address _DIDTokenAddress,
545         address _DistenseAddress,
546         address _TasksAddress
547     ) public {
548         DIDTokenAddress = _DIDTokenAddress;
549         DistenseAddress = _DistenseAddress;
550         TasksAddress = _TasksAddress;
551     }
552 
553     function addPullRequest(bytes32 _prId, bytes32 _taskId, uint128 _prNum) external returns (bool) {
554         pullRequests[_prId].contributor = msg.sender;
555         pullRequests[_prId].taskId = _taskId;
556         pullRequests[_prId].prNum = _prNum;
557         pullRequestIds.push(_prId);
558 
559         emit LogAddPullRequest(_prId, _taskId, _prNum);
560 
561         return true;
562     }
563 
564     function getPullRequestById(bytes32 _prId) external view returns (address, bytes32, uint128, uint256) {
565         PullRequest memory pr = pullRequests[_prId];
566         return (pr.contributor, pr.taskId, pr.prNum, pr.pctDIDApproved);
567     }
568 
569     function getNumPullRequests() external view returns (uint256) {
570         return pullRequestIds.length;
571     }
572 
573     function approvePullRequest(bytes32 _prId)
574         hasEnoughDIDToApprovePR
575         external
576     returns (uint256) {
577 
578         require(pullRequests[_prId].voted[msg.sender] == false, "voter already voted on this PR");
579         require(pullRequests[_prId].contributor != msg.sender, "contributor voted on their PR");
580         Distense distense = Distense(DistenseAddress);
581         DIDToken didToken = DIDToken(DIDTokenAddress);
582 
583         PullRequest storage _pr = pullRequests[_prId];
584 
585         //  Record approval vote to prevent multiple voting
586         _pr.voted[msg.sender] = true;
587 
588         //  This is not very gas efficient at all but the stack was too deep.  Need to refactor/research ways to improve
589         //  Increment _pr.pctDIDApproved by the lower of the votingPowerLimitParameter or the voters pctDIDOwned
590         _pr.pctDIDApproved += didToken.pctDIDOwned(msg.sender) > distense.getParameterValueByTitle(
591             distense.votingPowerLimitParameterTitle()
592         ) ? distense.getParameterValueByTitle(
593             distense.votingPowerLimitParameterTitle()
594         ) : didToken.pctDIDOwned(msg.sender);
595 
596         if (
597             _pr.pctDIDApproved > distense.getParameterValueByTitle(
598                 distense.pctDIDRequiredToMergePullRequestTitle()
599             )
600         ) {
601             Tasks tasks = Tasks(TasksAddress);
602 
603             uint256 reward;
604             Tasks.RewardStatus rewardStatus;
605             (reward, rewardStatus) = tasks.getTaskRewardAndStatus(_pr.taskId);
606 
607             require(rewardStatus != Tasks.RewardStatus.PAID);
608             Tasks.RewardStatus updatedRewardStatus = tasks.setTaskRewardPaid(_pr.taskId);
609 
610             //  Only issueDID after we confirm taskRewardPaid
611             require(updatedRewardStatus == Tasks.RewardStatus.PAID);
612             didToken.rewardContributor(_pr.contributor, reward);
613 
614             emit LogRewardPullRequest(_prId, _pr.taskId, _pr.prNum);
615         }
616 
617         emit LogPullRequestApprovalVote(_prId, _pr.pctDIDApproved);
618         return _pr.pctDIDApproved;
619     }
620 
621     modifier hasEnoughDIDToApprovePR() {
622 
623         Distense distense = Distense(DistenseAddress);
624         uint256 threshold = distense.getParameterValueByTitle(
625             distense.numDIDRequiredToApproveVotePullRequestParameterTitle()
626         );
627 
628         DIDToken didToken = DIDToken(DIDTokenAddress);
629 
630         require(didToken.getNumContributionsDID(msg.sender) > threshold);
631         _;
632     }
633 
634     function setDIDTokenAddress(address _DIDTokenAddress) public onlyApproved {
635         DIDTokenAddress = _DIDTokenAddress;
636     }
637 
638     function setDistenseAddress(address _DistenseAddress) public onlyApproved {
639         DistenseAddress = _DistenseAddress;
640     }
641 
642     function setTasksAddress(address _TasksAddress) public onlyApproved {
643         TasksAddress = _TasksAddress;
644     }
645 }
646 
647 contract Tasks is Approvable {
648 
649     using SafeMath for uint256;
650 
651     address public DIDTokenAddress;
652     address public DistenseAddress;
653 
654     bytes32[] public taskIds;
655 
656     enum RewardStatus { TENTATIVE, DETERMINED, PAID }
657 
658     struct Task {
659         string title;
660         address createdBy;
661         uint256 reward;
662         RewardStatus rewardStatus;
663         uint256 pctDIDVoted;
664         uint64 numVotes;
665         mapping(address => bool) rewardVotes;
666         uint256 taskIdsIndex;   // for easy later deletion to minimize query time and blockchain size
667     }
668 
669     mapping(bytes32 => Task) tasks;
670     mapping(bytes32 => bool) tasksTitles;
671 
672     event LogAddTask(bytes32 taskId, string title);
673     event LogTaskRewardVote(bytes32 taskId, uint256 reward, uint256 pctDIDVoted);
674     event LogTaskRewardDetermined(bytes32 taskId, uint256 reward);
675 
676     constructor (address _DIDTokenAddress, address _DistenseAddress) public {
677         DIDTokenAddress = _DIDTokenAddress;
678         DistenseAddress = _DistenseAddress;
679     }
680 
681     function addTask(bytes32 _taskId, string _title) external hasEnoughDIDToAddTask returns
682         (bool) {
683 
684         bytes32 titleBytes32 = keccak256(abi.encodePacked(_title));
685         require(!tasksTitles[titleBytes32], "Task title already exists");
686 
687         Distense distense = Distense(DistenseAddress);
688 
689         tasks[_taskId].createdBy = msg.sender;
690         tasks[_taskId].title = _title;
691         tasks[_taskId].reward = distense.getParameterValueByTitle(distense.defaultRewardParameterTitle());
692         tasks[_taskId].rewardStatus = RewardStatus.TENTATIVE;
693 
694         taskIds.push(_taskId);
695         tasksTitles[titleBytes32] = true;
696         tasks[_taskId].taskIdsIndex = taskIds.length - 1;
697         emit LogAddTask(_taskId, _title);
698 
699         return true;
700     }
701 
702     function getTaskById(bytes32 _taskId) external view returns (
703         string,
704         address,
705         uint256,
706         Tasks.RewardStatus,
707         uint256,
708         uint64
709     ) {
710 
711         Task memory task = tasks[_taskId];
712         return (
713             task.title,
714             task.createdBy,
715             task.reward,
716             task.rewardStatus,
717             task.pctDIDVoted,
718             task.numVotes
719         );
720 
721     }
722 
723     function taskExists(bytes32 _taskId) external view returns (bool) {
724         return tasks[_taskId].createdBy != 0;
725     }
726 
727     function getNumTasks() external view returns (uint256) {
728         return taskIds.length;
729     }
730 
731     function taskRewardVote(bytes32 _taskId, uint256 _reward) external returns (bool) {
732 
733         DIDToken didToken = DIDToken(DIDTokenAddress);
734         uint256 balance = didToken.getAddressBalance(msg.sender);
735         Distense distense = Distense(DistenseAddress);
736 
737         Task storage task = tasks[_taskId];
738 
739         require(_reward >= 0);
740 
741         //  Essentially refund the remaining gas if user's vote will have no effect
742         require(task.reward != (_reward * 1 ether));
743 
744         // Don't let the voter vote if the reward has already been determined
745         require(task.rewardStatus != RewardStatus.DETERMINED);
746 
747         //  Has the voter already voted on this task?
748         require(!task.rewardVotes[msg.sender]);
749 
750         //  Does the voter own at least as many DID as the reward their voting for?
751         //  This ensures new contributors don't have too much sway over the issuance of new DID.
752         require(balance > distense.getParameterValueByTitle(distense.numDIDRequiredToTaskRewardVoteParameterTitle()));
753 
754         //  Require the reward to be less than or equal to the maximum reward parameter,
755         //  which basically is a hard, floating limit on the number of DID that can be issued for any single task
756         require((_reward * 1 ether) <= distense.getParameterValueByTitle(distense.maxRewardParameterTitle()));
757 
758         task.rewardVotes[msg.sender] = true;
759 
760         uint256 pctDIDOwned = didToken.pctDIDOwned(msg.sender);
761         task.pctDIDVoted = task.pctDIDVoted + pctDIDOwned;
762 
763         //  Get the current votingPowerLimit
764         uint256 votingPowerLimit = distense.getParameterValueByTitle(distense.votingPowerLimitParameterTitle());
765         //  For voting purposes, limit the pctDIDOwned
766         uint256 limitedVotingPower = pctDIDOwned > votingPowerLimit ? votingPowerLimit : pctDIDOwned;
767 
768         uint256 difference;
769         uint256 update;
770 
771         if ((_reward * 1 ether) > task.reward) {
772             difference = SafeMath.sub((_reward * 1 ether), task.reward);
773             update = (limitedVotingPower * difference) / (1 ether * 100);
774             task.reward += update;
775         } else {
776             difference = SafeMath.sub(task.reward, (_reward * 1 ether));
777             update = (limitedVotingPower * difference) / (1 ether * 100);
778             task.reward -= update;
779         }
780 
781         task.numVotes++;
782 
783         uint256 pctDIDVotedThreshold = distense.getParameterValueByTitle(
784             distense.pctDIDToDetermineTaskRewardParameterTitle()
785         );
786 
787         uint256 minNumVoters = distense.getParameterValueByTitle(
788             distense.minNumberOfTaskRewardVotersParameterTitle()
789         );
790 
791         if (task.pctDIDVoted > pctDIDVotedThreshold || task.numVotes > SafeMath.div(minNumVoters, 1 ether)) {
792             emit LogTaskRewardDetermined(_taskId, task.reward);
793             task.rewardStatus = RewardStatus.DETERMINED;
794         }
795 
796         return true;
797 
798     }
799 
800     function getTaskReward(bytes32 _taskId) external view returns (uint256) {
801         return tasks[_taskId].reward;
802     }
803 
804     function getTaskRewardAndStatus(bytes32 _taskId) external view returns (uint256, RewardStatus) {
805         return (
806             tasks[_taskId].reward,
807             tasks[_taskId].rewardStatus
808         );
809     }
810 
811     function setTaskRewardPaid(bytes32 _taskId) external onlyApproved returns (RewardStatus) {
812         tasks[_taskId].rewardStatus = RewardStatus.PAID;
813         return tasks[_taskId].rewardStatus;
814     }
815 
816     //  Allow deleting of PAID taskIds to minimize blockchain size & query time on client
817     //  taskIds are memorialized in the form of events/logs, so this doesn't truly delete them,
818     //  it just prevents them from slowing down query times
819     function deleteTask(bytes32 _taskId) external onlyApproved returns (bool) {
820         Task storage task = tasks[_taskId];
821 
822         if (task.rewardStatus == RewardStatus.PAID) {
823             uint256 index = tasks[_taskId].taskIdsIndex;
824             delete taskIds[index];
825             delete tasks[_taskId];
826 
827             // Move the last element to the deleted index.  If we don't do this there are no efficiencies and the index will still still be
828             // iterated over on the client
829             uint256 taskIdsLength = taskIds.length;
830             if (taskIdsLength > 1) {
831                 bytes32 lastElement = taskIds[taskIdsLength - 1];
832                 taskIds[index] = lastElement;
833                 taskIds.length--;
834             }
835             return true;
836         }
837         return false;
838     }
839 
840     modifier hasEnoughDIDToAddTask() {
841         DIDToken didToken = DIDToken(DIDTokenAddress);
842         uint256 balance = didToken.getAddressBalance(msg.sender);
843 
844         Distense distense = Distense(DistenseAddress);
845         uint256 numDIDRequiredToAddTask = distense.getParameterValueByTitle(
846             distense.numDIDRequiredToAddTaskParameterTitle()
847         );
848         require(balance >= numDIDRequiredToAddTask);
849         _;
850     }
851 
852     function setDIDTokenAddress(address _DIDTokenAddress) public onlyApproved {
853         DIDTokenAddress = _DIDTokenAddress;
854     }
855 
856     function setDistenseAddress(address _DistenseAddress) public onlyApproved {
857         DistenseAddress = _DistenseAddress;
858     }
859 
860 }
861 
862 library SafeMath {
863   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
864     if (a == 0) {
865       return 0;
866     }
867     uint256 c = a * b;
868     assert(c / a == b);
869     return c;
870   }
871 
872   function div(uint256 a, uint256 b) internal pure returns (uint256) {
873     // assert(b > 0); // Solidity automatically throws when dividing by 0
874     uint256 c = a / b;
875     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
876     return c;
877   }
878 
879   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
880     assert(b <= a);
881     return a - b;
882   }
883 
884   function add(uint256 a, uint256 b) internal pure returns (uint256) {
885     uint256 c = a + b;
886     assert(c >= a);
887     return c;
888   }
889 
890 
891   function percent(uint numerator, uint denominator, uint precision) public pure
892   returns(uint quotient) {
893 
894     // caution, check safe-to-multiply here
895     uint _numerator  = numerator * 10 ** (precision + 1);
896 
897     // with rounding of last digit
898     uint _quotient =  ((_numerator / denominator) + 5) / 10;
899     return _quotient;
900   }
901 
902 }