1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40   function allowance(address owner, address spender) public view returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address spender, uint256 value) public returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract TokenLocker {
47     
48     address public owner;
49 
50     ERC20 public token;
51 
52     /**
53      * @dev Create a new TokenLocker contract
54      * @param tokenAddr ERC20 token this contract will be used to lock
55      */
56     function TokenLocker (ERC20 tokenAddr) public {
57         owner = msg.sender;
58         token = tokenAddr;
59     }
60 
61     /** 
62      *  @dev Call the ERC20 `transfer` function on the underlying token contract
63      *  @param dest Token destination
64      *  @param amount Amount of tokens to be transferred
65      */
66     function transfer(address dest, uint amount) public returns (bool) {
67         require(msg.sender == owner);
68         return token.transfer(dest, amount);
69     }
70 
71 }
72 
73 contract TokenRecipient {
74     event ReceivedEther(address indexed sender, uint amount);
75     event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);
76 
77     /**
78      * @dev Receive tokens and generate a log event
79      * @param from Address from which to transfer tokens
80      * @param value Amount of tokens to transfer
81      * @param token Address of token
82      * @param extraData Additional data to log
83      */
84     function receiveApproval(address from, uint256 value, address token, bytes extraData) public {
85         ERC20 t = ERC20(token);
86         require(t.transferFrom(from, this, value));
87         ReceivedTokens(from, value, token, extraData);
88     }
89 
90     /**
91      * @dev Receive Ether and generate a log event
92      */
93     function () payable public {
94         ReceivedEther(msg.sender, msg.value);
95     }
96 }
97 
98 contract DelegatedShareholderAssociation is TokenRecipient {
99 
100     uint public minimumQuorum;
101     uint public debatingPeriodInMinutes;
102     Proposal[] public proposals;
103     uint public numProposals;
104     ERC20 public sharesTokenAddress;
105 
106     /* Delegate addresses by delegator. */
107     mapping (address => address) public delegatesByDelegator;
108 
109     /* Locked tokens by delegator. */
110     mapping (address => uint) public lockedDelegatingTokens;
111 
112     /* Delegated votes by delegate. */
113     mapping (address => uint) public delegatedAmountsByDelegate;
114     
115     /* Tokens currently locked by vote delegation. */
116     uint public totalLockedTokens;
117 
118     /* Threshold for the ability to create proposals. */
119     uint public requiredSharesToBeBoardMember;
120 
121     /* Token Locker contract. */
122     TokenLocker public tokenLocker;
123 
124     /* Events for all state changes. */
125 
126     event ProposalAdded(uint proposalID, address recipient, uint amount, bytes metadataHash);
127     event Voted(uint proposalID, bool position, address voter);
128     event ProposalTallied(uint proposalID, uint yea, uint nay, uint quorum, bool active);
129     event ChangeOfRules(uint newMinimumQuorum, uint newDebatingPeriodInMinutes, address newSharesTokenAddress);
130     event TokensDelegated(address indexed delegator, uint numberOfTokens, address indexed delegate);
131     event TokensUndelegated(address indexed delegator, uint numberOfTokens, address indexed delegate);
132 
133     struct Proposal {
134         address recipient;
135         uint amount;
136         bytes metadataHash;
137         uint timeCreated;
138         uint votingDeadline;
139         bool finalized;
140         bool proposalPassed;
141         uint numberOfVotes;
142         bytes32 proposalHash;
143         Vote[] votes;
144         mapping (address => bool) voted;
145     }
146 
147     struct Vote {
148         bool inSupport;
149         address voter;
150     }
151 
152     /* Only shareholders can execute a function with this modifier. */
153     modifier onlyShareholders {
154         require(ERC20(sharesTokenAddress).balanceOf(msg.sender) > 0);
155         _;
156     }
157 
158     /* Only the DAO itself (via an approved proposal) can execute a function with this modifier. */
159     modifier onlySelf {
160         require(msg.sender == address(this));
161         _;
162     }
163 
164     /* Any account except the DAO itself can execute a function with this modifier. */
165     modifier notSelf {
166         require(msg.sender != address(this));
167         _;
168     }
169 
170     /* Only a shareholder who has *not* delegated his vote can execute a function with this modifier. */
171     modifier onlyUndelegated {
172         require(delegatesByDelegator[msg.sender] == address(0));
173         _;
174     }
175 
176     /* Only boardmembers (shareholders above a certain threshold) can execute a function with this modifier. */
177     modifier onlyBoardMembers {
178         require(ERC20(sharesTokenAddress).balanceOf(msg.sender) >= requiredSharesToBeBoardMember);
179         _;
180     }
181 
182     /* Only a shareholder who has delegated his vote can execute a function with this modifier. */
183     modifier onlyDelegated {
184         require(delegatesByDelegator[msg.sender] != address(0));
185         _;
186     }
187 
188     /**
189       * Delegate an amount of tokens
190       * 
191       * @notice Set the delegate address for a specified number of tokens belonging to the sending address, locking the tokens.
192       * @dev An address holding tokens (shares) may only delegate some portion of their vote to one delegate at any one time
193       * @param tokensToLock number of tokens to be locked (sending address must have at least this many tokens)
194       * @param delegate the address to which votes equal to the number of tokens locked will be delegated
195       */
196     function setDelegateAndLockTokens(uint tokensToLock, address delegate)
197         public
198         onlyShareholders
199         onlyUndelegated
200         notSelf
201     {
202         lockedDelegatingTokens[msg.sender] = tokensToLock;
203         delegatedAmountsByDelegate[delegate] = SafeMath.add(delegatedAmountsByDelegate[delegate], tokensToLock);
204         totalLockedTokens = SafeMath.add(totalLockedTokens, tokensToLock);
205         delegatesByDelegator[msg.sender] = delegate;
206         require(sharesTokenAddress.transferFrom(msg.sender, tokenLocker, tokensToLock));
207         require(sharesTokenAddress.balanceOf(tokenLocker) == totalLockedTokens);
208         TokensDelegated(msg.sender, tokensToLock, delegate);
209     }
210 
211     /** 
212      * Undelegate all delegated tokens
213      * 
214      * @notice Clear the delegate address for all tokens delegated by the sending address, unlocking the locked tokens.
215      * @dev Can only be called by a sending address currently delegating tokens, will transfer all locked tokens back to the sender
216      * @return The number of tokens previously locked, now released
217      */
218     function clearDelegateAndUnlockTokens()
219         public
220         onlyDelegated
221         notSelf
222         returns (uint lockedTokens)
223     {
224         address delegate = delegatesByDelegator[msg.sender];
225         lockedTokens = lockedDelegatingTokens[msg.sender];
226         lockedDelegatingTokens[msg.sender] = 0;
227         delegatedAmountsByDelegate[delegate] = SafeMath.sub(delegatedAmountsByDelegate[delegate], lockedTokens);
228         totalLockedTokens = SafeMath.sub(totalLockedTokens, lockedTokens);
229         delete delegatesByDelegator[msg.sender];
230         require(tokenLocker.transfer(msg.sender, lockedTokens));
231         require(sharesTokenAddress.balanceOf(tokenLocker) == totalLockedTokens);
232         TokensUndelegated(msg.sender, lockedTokens, delegate);
233         return lockedTokens;
234     }
235 
236     /**
237      * Change voting rules
238      *
239      * Make so that proposals need tobe discussed for at least `minutesForDebate/60` hours
240      * and all voters combined must own more than `minimumSharesToPassAVote` shares of token `sharesAddress` to be executed
241      * and a shareholder needs `sharesToBeBoardMember` shares to create a transaction proposal
242      *
243      * @param minimumSharesToPassAVote proposal can vote only if the sum of shares held by all voters exceed this number
244      * @param minutesForDebate the minimum amount of delay between when a proposal is made and when it can be executed
245      * @param sharesToBeBoardMember the minimum number of shares required to create proposals
246      */
247     function changeVotingRules(uint minimumSharesToPassAVote, uint minutesForDebate, uint sharesToBeBoardMember)
248         public
249         onlySelf
250     {
251         if (minimumSharesToPassAVote == 0 ) {
252             minimumSharesToPassAVote = 1;
253         }
254         minimumQuorum = minimumSharesToPassAVote;
255         debatingPeriodInMinutes = minutesForDebate;
256         requiredSharesToBeBoardMember = sharesToBeBoardMember;
257         ChangeOfRules(minimumQuorum, debatingPeriodInMinutes, sharesTokenAddress);
258     }
259 
260     /**
261      * Add Proposal
262      *
263      * Propose to send `weiAmount / 1e18` ether to `beneficiary` for `jobMetadataHash`. `transactionBytecode ? Contains : Does not contain` code.
264      *
265      * @dev Submit proposal for the DAO to execute a particular transaction. Submitter should check that the `beneficiary` account exists, unless the intent is to burn Ether.
266      * @param beneficiary who to send the ether to
267      * @param weiAmount amount of ether to send, in wei
268      * @param jobMetadataHash Hash of job metadata (IPFS)
269      * @param transactionBytecode bytecode of transaction
270      */
271     function newProposal(
272         address beneficiary,
273         uint weiAmount,
274         bytes jobMetadataHash,
275         bytes transactionBytecode
276     )
277         public
278         onlyBoardMembers
279         notSelf
280         returns (uint proposalID)
281     {
282         /* Proposals cannot be directed to the token locking contract. */
283         require(beneficiary != address(tokenLocker));
284         proposalID = proposals.length++;
285         Proposal storage p = proposals[proposalID];
286         p.recipient = beneficiary;
287         p.amount = weiAmount;
288         p.metadataHash = jobMetadataHash;
289         p.proposalHash = keccak256(beneficiary, weiAmount, transactionBytecode);
290         p.timeCreated = now;
291         p.votingDeadline = now + debatingPeriodInMinutes * 1 minutes;
292         p.finalized = false;
293         p.proposalPassed = false;
294         p.numberOfVotes = 0;
295         ProposalAdded(proposalID, beneficiary, weiAmount, jobMetadataHash);
296         numProposals = proposalID+1;
297         return proposalID;
298     }
299 
300     /**
301      * Check if a proposal code matches
302      *
303      * @param proposalNumber ID number of the proposal to query
304      * @param beneficiary who to send the ether to
305      * @param weiAmount amount of ether to send
306      * @param transactionBytecode bytecode of transaction
307      */
308     function checkProposalCode(
309         uint proposalNumber,
310         address beneficiary,
311         uint weiAmount,
312         bytes transactionBytecode
313     )
314         public
315         view
316         returns (bool codeChecksOut)
317     {
318         Proposal storage p = proposals[proposalNumber];
319         return p.proposalHash == keccak256(beneficiary, weiAmount, transactionBytecode);
320     }
321 
322     /**
323      * Log a vote for a proposal
324      *
325      * Vote `supportsProposal? in support of : against` proposal #`proposalNumber`
326      *
327      * @dev Vote in favor or against an existing proposal. Voter should check that the proposal destination account exists, unless the intent is to burn Ether.
328      * @param proposalNumber number of proposal
329      * @param supportsProposal either in favor or against it
330      */
331     function vote(
332         uint proposalNumber,
333         bool supportsProposal
334     )
335         public
336         onlyShareholders
337         notSelf
338         returns (uint voteID)
339     {
340         Proposal storage p = proposals[proposalNumber];
341         require(p.voted[msg.sender] != true);
342         voteID = p.votes.length++;
343         p.votes[voteID] = Vote({inSupport: supportsProposal, voter: msg.sender});
344         p.voted[msg.sender] = true;
345         p.numberOfVotes = voteID + 1;
346         Voted(proposalNumber, supportsProposal, msg.sender);
347         return voteID;
348     }
349 
350     /**
351      * Return whether a particular shareholder has voted on a particular proposal (convenience function)
352      * @param proposalNumber proposal number
353      * @param shareholder address to query
354      * @return whether or not the specified address has cast a vote on the specified proposal
355      */
356     function hasVoted(uint proposalNumber, address shareholder) public view returns (bool) {
357         Proposal storage p = proposals[proposalNumber];
358         return p.voted[shareholder];
359     }
360 
361     /**
362      * Count the votes, including delegated votes, in support of, against, and in total for a particular proposal
363      * @param proposalNumber proposal number
364      * @return yea votes, nay votes, quorum (total votes)
365      */
366     function countVotes(uint proposalNumber) public view returns (uint yea, uint nay, uint quorum) {
367         Proposal storage p = proposals[proposalNumber];
368         yea = 0;
369         nay = 0;
370         quorum = 0;
371         for (uint i = 0; i < p.votes.length; ++i) {
372             Vote storage v = p.votes[i];
373             uint voteWeight = SafeMath.add(sharesTokenAddress.balanceOf(v.voter), delegatedAmountsByDelegate[v.voter]);
374             quorum = SafeMath.add(quorum, voteWeight);
375             if (v.inSupport) {
376                 yea = SafeMath.add(yea, voteWeight);
377             } else {
378                 nay = SafeMath.add(nay, voteWeight);
379             }
380         }
381     }
382 
383     /**
384      * Finish vote
385      *
386      * Count the votes proposal #`proposalNumber` and execute it if approved
387      *
388      * @param proposalNumber proposal number
389      * @param transactionBytecode optional: if the transaction contained a bytecode, you need to send it
390      */
391     function executeProposal(uint proposalNumber, bytes transactionBytecode)
392         public
393         notSelf
394     {
395         Proposal storage p = proposals[proposalNumber];
396 
397         /* If at or past deadline, not already finalized, and code is correct, keep going. */
398         require((now >= p.votingDeadline) && !p.finalized && p.proposalHash == keccak256(p.recipient, p.amount, transactionBytecode));
399 
400         /* Count the votes. */
401         var ( yea, nay, quorum ) = countVotes(proposalNumber);
402 
403         /* Assert that a minimum quorum has been reached. */
404         require(quorum >= minimumQuorum);
405         
406         /* Mark proposal as finalized. */   
407         p.finalized = true;
408 
409         if (yea > nay) {
410             /* Mark proposal as passed. */
411             p.proposalPassed = true;
412 
413             /* Execute the function. */
414             require(p.recipient.call.value(p.amount)(transactionBytecode));
415 
416         } else {
417             /* Proposal failed. */
418             p.proposalPassed = false;
419         }
420 
421         /* Log event. */
422         ProposalTallied(proposalNumber, yea, nay, quorum, p.proposalPassed);
423     }
424 }
425 
426 contract WyvernDAO is DelegatedShareholderAssociation {
427 
428     string public constant name = "Project Wyvern DAO";
429 
430     uint public constant TOKEN_DECIMALS                     = 18;
431     uint public constant REQUIRED_SHARES_TO_BE_BOARD_MEMBER = 2000 * (10 ** TOKEN_DECIMALS); // set to ~ 0.1% of supply
432     uint public constant MINIMUM_QUORUM                     = 200000 * (10 ** TOKEN_DECIMALS); // set to 10% of supply
433     uint public constant DEBATE_PERIOD_MINUTES              = 60 * 24 * 3; // set to 3 days
434 
435     function WyvernDAO (ERC20 sharesAddress) public {
436         sharesTokenAddress = sharesAddress;
437         requiredSharesToBeBoardMember = REQUIRED_SHARES_TO_BE_BOARD_MEMBER;
438         minimumQuorum = MINIMUM_QUORUM;
439         debatingPeriodInMinutes = DEBATE_PERIOD_MINUTES;
440         tokenLocker = new TokenLocker(sharesAddress);
441     }
442 
443 }