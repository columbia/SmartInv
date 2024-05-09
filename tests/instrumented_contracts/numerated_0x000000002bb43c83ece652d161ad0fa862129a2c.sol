1 pragma solidity ^0.4.20;// blaze it
2 
3 interface ERC20 {
4     function totalSupply() external constant returns (uint supply);
5     function balanceOf(address _owner) external constant returns (uint balance);
6     function transfer(address _to, uint _value) external returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
8     function approve(address _spender, uint _value) external returns (bool success);
9     function allowance(address _owner, address _spender) external constant returns (uint remaining);
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 contract TokenRescue {
14     // use this method to rescue your tokens if you sent them by mistake but be quick or someone else will get them
15     function rescueToken(ERC20 _token)
16     external
17     {
18         _token.transfer(msg.sender, _token.balanceOf(this));
19     }
20     // require data for transactions
21     function() external payable {
22         revert();
23     }
24 }
25 interface AccountRegistryInterface {
26     function canVoteOnProposal(address _voter, address _proposal) external view returns (bool);
27 }
28 contract Vote is ERC20, TokenRescue {
29     uint256 supply = 0;
30     AccountRegistryInterface public accountRegistry = AccountRegistryInterface(0x000000002bb43c83eCe652d161ad0fa862129A2C);
31     address public owner = 0x4a6f6B9fF1fc974096f9063a45Fd12bD5B928AD1;
32 
33     uint8 public constant decimals = 1;
34     string public symbol = "FV";
35     string public name = "FinneyVote";
36 
37     mapping (address => uint256) balances;
38     mapping (address => mapping (address => uint256)) approved;
39 
40     function totalSupply() external constant returns (uint256) {
41         return supply;
42     }
43     function balanceOf(address _owner) external constant returns (uint256) {
44         return balances[_owner];
45     }
46     function approve(address _spender, uint256 _value) external returns (bool) {
47         approved[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;
50     }
51     function allowance(address _owner, address _spender) external constant returns (uint256) {
52         return approved[_owner][_spender];
53     }
54     function transfer(address _to, uint256 _value) external returns (bool) {
55         if (balances[msg.sender] < _value) {
56             return false;
57         }
58         balances[msg.sender] -= _value;
59         balances[_to] += _value;
60         Transfer(msg.sender, _to, _value);
61         return true;
62     }
63     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
64         if (balances[_from] < _value
65          || approved[_from][msg.sender] < _value
66          || _value == 0) {
67             return false;
68         }
69         approved[_from][msg.sender] -= _value;
70         balances[_from] -= _value;
71         balances[_to] += _value;
72         Transfer(_from, _to, _value);
73         return true;
74     }
75     function grant(address _to, uint256 _grant) external {
76         require(msg.sender == address(accountRegistry));
77         balances[_to] += _grant;
78         supply += _grant;
79         Transfer(address(0), _to, _grant);
80     }
81     // vote5 and vote1 are available for future use
82     function vote5(address _voter, address _votee) external {
83         require(balances[_voter] >= 10);
84         require(accountRegistry.canVoteOnProposal(_voter, msg.sender));
85         balances[_voter] -= 10;
86         balances[owner] += 5;
87         balances[_votee] += 5;
88         Transfer(_voter, owner, 5);
89         Transfer(_voter, _votee, 5);
90     }
91     function vote1(address _voter, address _votee) external {
92         require(balances[_voter] >= 10);
93         require(accountRegistry.canVoteOnProposal(_voter, msg.sender));
94         balances[_voter] -= 10;
95         balances[owner] += 9;
96         balances[_votee] += 1;
97         Transfer(_voter, owner, 9);
98         Transfer(_voter, _votee, 1);
99     }
100     function vote9(address _voter, address _votee) external {
101         require(balances[_voter] >= 10);
102         require(accountRegistry.canVoteOnProposal(_voter, msg.sender));
103         balances[_voter] -= 10;
104         balances[owner] += 1;
105         balances[_votee] += 9;
106         Transfer(_voter, owner, 1);
107         Transfer(_voter, _votee, 9);
108     }
109     modifier onlyOwner () {
110         require(msg.sender == owner);
111         _;
112     }
113     event Owner(address indexed owner);
114     event Registry(address indexed registry);
115     function transferOwnership(address _newOwner)
116     external onlyOwner {
117         uint256 balance = balances[owner];
118         balances[_newOwner] += balance;
119         balances[owner] = 0;
120         Transfer(owner, _newOwner, balance);
121         owner = _newOwner;
122         Owner(_newOwner);
123     }
124     function migrateAccountRegistry(AccountRegistryInterface _newAccountRegistry)
125     external onlyOwner {
126         accountRegistry = _newAccountRegistry;
127         Registry(_newAccountRegistry);
128     }
129 }
130 interface ProposalInterface {
131     /* uint8:
132         enum Position {
133             SKIP, // default
134             APPROVE,
135             REJECT,
136             AMEND, // == (APPROVE | REJECT)
137             LOL
138             // more to be determined by community
139         }
140     */
141     function getPosition(address _user) external view returns (uint8);
142     function argumentCount() external view returns (uint256);
143     function vote(uint256 _argumentId) external;
144     // bytes could be:
145     // utf8 string
146     // swarm hash
147     // ipfs hash
148     // and others tbd
149     event Case(bytes content);
150 }
151 contract ProperProposal is ProposalInterface, TokenRescue {
152     struct Argument {
153         address source;
154         uint8 position;
155         uint256 count;
156     }
157     Argument[] public arguments;
158     mapping (address => uint256) public votes;
159     Vote public constant voteToken = Vote(0x000000002647e16d9BaB9e46604D75591D289277);
160 
161     function getPosition(address _user)
162     external view
163     returns (uint8) {
164         return arguments[votes[_user]].position;
165     }
166 
167     function argumentCount() external view returns (uint256) {
168         return arguments.length;
169     }
170     function argumentSource(uint256 _index)
171     external view
172     returns (address) {
173         return arguments[_index].source;
174     }
175 
176     function argumentPosition(uint256 _index)
177     external view
178     returns (uint8) {
179         return arguments[_index].position;
180     }
181 
182     function argumentVoteCount(uint256 _index)
183     external view
184     returns (uint256) {
185         return arguments[_index].count;
186     }
187 
188     function source()
189     external view
190     returns (address) {
191         return arguments[0].source;
192     }
193 
194     function voteCount()
195     external view
196     returns (uint256) {
197         return -arguments[0].count;
198     }
199 
200     function vote(uint256 _argumentId)
201     external {
202         address destination = arguments[_argumentId].source;
203         voteToken.vote9(msg.sender, destination);
204         arguments[votes[msg.sender]].count--;
205         arguments[
206             votes[msg.sender] = _argumentId
207         ].count++;
208     }
209 
210     event Case(bytes content);
211 
212     function argue(uint8 _position, bytes _text)
213     external
214     returns (uint256) {
215         address destination = arguments[0].source;
216         voteToken.vote9(msg.sender, destination);
217         uint256 argumentId = arguments.length;
218         arguments.push(Argument(msg.sender, _position, 1));
219         Case(_text);
220         arguments[votes[msg.sender]].count--;
221         votes[msg.sender] = argumentId;
222         return argumentId;
223     }
224 
225     function init(address _source, bytes _resolution)
226     external {
227         assert(msg.sender == 0x000000002bb43c83eCe652d161ad0fa862129A2C);
228         arguments.push(Argument(_source, 0/*SKIP*/, 0));
229         Case(_resolution);
230     }
231 }
232 interface CabalInterface {
233     // TBD
234     function canonCount() external view returns (uint256);
235 }
236 contract AccountRegistry is AccountRegistryInterface, TokenRescue {
237     
238     uint256 constant public registrationDeposit = 1 finney;
239     uint256 constant public proposalCensorshipFee = 50 finney;
240 
241     // this is the first deterministic contract address for 0x24AE90765668938351075fB450892800d9A52E39
242     address constant public burn = 0x000000003Ffc15cd9eA076d7ec40B8f516367Ca1;
243 
244     Vote public constant token = Vote(0x000000002647e16d9BaB9e46604D75591D289277);
245 
246     /* uint8 membership bitmap:
247      * 0 - proposer
248      * 1 - registered to vote
249      * 2 - pending proposal
250      * 3 - proposal
251      * 4 - board member
252      * 5 - pending cabal
253      * 6 - cabal
254      * 7 - board
255      */
256     uint8 constant UNCONTACTED = 0;
257     uint8 constant PROPOSER = 1;
258     uint8 constant VOTER = 2;
259     uint8 constant PENDING_PROPOSAL = 4;
260     uint8 constant PROPOSAL = 8;
261     uint8 constant PENDING_CABAL = 16;
262     uint8 constant CABAL = 32;
263     uint8 constant BOARD = 64;
264     struct Account {
265         uint256 lastAccess;
266         uint8 membership;
267         address appointer;//nominated this account for BOARD
268         address denouncer;//denounced this BOARD account
269         address voucher;//nominated this account for PROPOSER
270         address devoucher;//denounced this account for PROPOSER
271     }
272     mapping (address => Account) accounts;
273 
274     function AccountRegistry()
275     public
276     {
277         accounts[0x4a6f6B9fF1fc974096f9063a45Fd12bD5B928AD1].membership = BOARD;
278         Board(0x4a6f6B9fF1fc974096f9063a45Fd12bD5B928AD1);
279         accounts[0x90Fa310397149A7a9058Ae2d56e66e707B12D3A7].membership = BOARD;
280         Board(0x90Fa310397149A7a9058Ae2d56e66e707B12D3A7);
281         accounts[0x424a6e871E8cea93791253B47291193637D6966a].membership = BOARD;
282         Board(0x424a6e871E8cea93791253B47291193637D6966a);
283         accounts[0xA4caDe6ecbed8f75F6fD50B8be92feb144400CC4].membership = BOARD;
284         Board(0xA4caDe6ecbed8f75F6fD50B8be92feb144400CC4);
285     }
286 
287     event Voter(address indexed voter);
288     event Deregistered(address indexed voter);
289     event Nominated(address indexed board, string endorsement);
290     event Board(address indexed board);
291     event Denounced(address indexed board, string reason);
292     event Revoked(address indexed board);
293     event Proposal(ProposalInterface indexed proposal);
294     event Cabal(CabalInterface indexed cabal);
295     event BannedProposal(ProposalInterface indexed proposal, string reason);
296     event Vouch(address indexed proposer, string vouch);
297     event Proposer(address indexed proposer);
298     event Devouch(address indexed proposer, string vouch);
299     event Shutdown(address indexed proposer);
300 
301     // To register a Cabal, you must
302     // - implement CabalInterface
303     // - open-source your Cabal on Etherscan or equivalent
304     function registerCabal(CabalInterface _cabal)
305     external {
306         Account storage account = accounts[_cabal];
307         require(account.membership & (PENDING_CABAL | CABAL) == 0);
308         account.membership |= PENDING_CABAL;
309     }
310 
311     function confirmCabal(CabalInterface _cabal)
312     external {
313         require(accounts[msg.sender].membership & BOARD != 0);
314         Account storage account = accounts[_cabal];
315         require(account.membership & PENDING_CABAL != 0);
316         account.membership ^= (CABAL | PENDING_CABAL);
317         Cabal(_cabal);
318     }
319 
320     function register()
321     external payable
322     {
323         require(msg.value == registrationDeposit);
324         Account storage account = accounts[msg.sender];
325         require(account.membership & VOTER == 0);
326         account.lastAccess = now;
327         account.membership |= VOTER;
328         token.grant(msg.sender, 40);
329         Voter(msg.sender);
330     }
331 
332     // smart contracts must implement the fallback function in order to deregister
333     function deregister()
334     external
335     {
336         Account storage account = accounts[msg.sender];
337         require(account.membership & VOTER != 0);
338         require(account.lastAccess + 7 days <= now);
339         account.membership ^= VOTER;
340         account.lastAccess = 0;
341         // the MANDATORY transfer keeps population() meaningful
342         msg.sender.transfer(registrationDeposit);
343         Deregistered(msg.sender);
344     }
345 
346     function population()
347     external view
348     returns (uint256)
349     {
350         return this.balance / 1 finney;
351     }
352 
353     function deregistrationDate()
354     external view
355     returns (uint256)
356     {
357         return accounts[msg.sender].lastAccess + 7 days;
358     }
359 
360     // always true for deregistered accounts
361     function canDeregister(address _voter)
362     external view
363     returns (bool)
364     {
365         return accounts[_voter].lastAccess + 7 days <= now;
366     }
367 
368     function canVoteOnProposal(address _voter, address _proposal)
369     external view
370     returns (bool)
371     {
372         return accounts[_voter].membership & VOTER != 0
373             && accounts[_proposal].membership & PROPOSAL != 0;
374     }
375 
376     function canVote(address _voter)
377     external view
378     returns (bool)
379     {
380         return accounts[_voter].membership & VOTER != 0;
381     }
382 
383     function isProposal(address _proposal)
384     external view
385     returns (bool)
386     {
387         return accounts[_proposal].membership & PROPOSAL != 0;
388     }
389 
390     function isPendingProposal(address _proposal)
391     external view
392     returns (bool)
393     {
394         return accounts[_proposal].membership & PENDING_PROPOSAL != 0;
395     }
396 
397     function isPendingCabal(address _account)
398     external view
399     returns (bool)
400     {
401         return accounts[_account].membership & PENDING_CABAL != 0;
402     }
403 
404     function isCabal(address _account)
405     external view
406     returns (bool)
407     {
408         return accounts[_account].membership & CABAL != 0;
409     }
410 
411     // under no condition should you let anyone control two BOARD accounts
412     function appoint(address _board, string _vouch)
413     external {
414         require(accounts[msg.sender].membership & BOARD != 0);
415         Account storage candidate = accounts[_board];
416         if (candidate.membership & BOARD != 0) {
417             return;
418         }
419         address appt = candidate.appointer;
420         if (accounts[appt].membership & BOARD == 0) {
421             candidate.appointer = msg.sender;
422             Nominated(_board, _vouch);
423             return;
424         }
425         if (appt == msg.sender) {
426             return;
427         }
428         Nominated(_board, _vouch);
429         candidate.membership |= BOARD;
430         Board(_board);
431     }
432 
433     function denounce(address _board, string _reason)
434     external {
435         require(accounts[msg.sender].membership & BOARD != 0);
436         Account storage board = accounts[_board];
437         if (board.membership & BOARD == 0) {
438             return;
439         }
440         address dncr = board.denouncer;
441         if (accounts[dncr].membership & BOARD == 0) {
442             board.denouncer = msg.sender;
443             Denounced(_board, _reason);
444             return;
445         }
446         if (dncr == msg.sender) {
447             return;
448         }
449         Denounced(_board, _reason);
450         board.membership ^= BOARD;
451         Revoked(_board);
452     }
453 
454     function vouchProposer(address _proposer, string _vouch)
455     external {
456         require(accounts[msg.sender].membership & BOARD != 0);
457         Account storage candidate = accounts[_proposer];
458         if (candidate.membership & PROPOSER != 0) {
459             return;
460         }
461         address appt = candidate.voucher;
462         if (accounts[appt].membership & BOARD == 0) {
463             candidate.voucher = msg.sender;
464             Vouch(_proposer, _vouch);
465             return;
466         }
467         if (appt == msg.sender) {
468             return;
469         }
470         Vouch(_proposer, _vouch);
471         candidate.membership |= PROPOSER;
472         Proposer(_proposer);
473     }
474 
475     function devouchProposer(address _proposer, string _devouch)
476     external {
477         require(accounts[msg.sender].membership & BOARD != 0);
478         Account storage candidate = accounts[_proposer];
479         if (candidate.membership & PROPOSER == 0) {
480             return;
481         }
482         address appt = candidate.devoucher;
483         if (accounts[appt].membership & BOARD == 0) {
484             candidate.devoucher = msg.sender;
485             Devouch(_proposer, _devouch);
486             return;
487         }
488         if (appt == msg.sender) {
489             return;
490         }
491         Devouch(_proposer, _devouch);
492         candidate.membership &= ~PROPOSER;
493         Shutdown(_proposer);
494     }
495 
496     function proposeProper(bytes _resolution)
497     external
498     returns (ProposalInterface)
499     {
500         ProperProposal proposal = new ProperProposal();
501         proposal.init(msg.sender, _resolution);
502         accounts[proposal].membership |= PROPOSAL;
503         Proposal(proposal);
504         return proposal;
505     }
506 
507     function proposeProxy(bytes _resolution)
508     external
509     returns (ProposalInterface)
510     {
511         ProperProposal proposal;
512         bytes memory clone = hex"600034603b57602f80600f833981f3600036818037808036816f5fbe2cc9b1b684ec445caf176042348e5af415602c573d81803e3d81f35b80fd";
513         assembly {
514             let data := add(clone, 0x20)
515             proposal := create(0, data, 58)
516         }
517         proposal.init(msg.sender, _resolution);
518         accounts[proposal].membership |= PROPOSAL;
519         Proposal(proposal);
520         return proposal;
521     }
522 
523     function sudoPropose(ProposalInterface _proposal)
524     external {
525         require(accounts[msg.sender].membership & PROPOSER != 0);
526         uint8 membership = accounts[_proposal].membership;
527         require(membership == 0);
528         accounts[_proposal].membership = PROPOSAL;
529         Proposal(_proposal);
530     }
531 
532     // To submit an outside proposal contract, you must:
533     // - ensure it conforms to ProposalInterface
534     // - ensure it properly transfers the VOTE token, calling Vote.voteX
535     // - open-source it using Etherscan or equivalent
536     function proposeExternal(ProposalInterface _proposal)
537     external
538     {
539         Account storage account = accounts[_proposal];
540         require(account.membership & (PENDING_PROPOSAL | PROPOSAL) == 0);
541         account.membership |= PENDING_PROPOSAL;
542     }
543 
544     function confirmProposal(ProposalInterface _proposal)
545     external
546     {
547         require(accounts[msg.sender].membership & BOARD != 0);
548         Account storage account = accounts[_proposal];
549         require(account.membership & PENDING_PROPOSAL != 0);
550         account.membership ^= (PROPOSAL | PENDING_PROPOSAL);
551         Proposal(_proposal);
552     }
553 
554     // bans prevent accounts from voting through this proposal
555     // this should only be used to stop a proposal that is abusing the VOTE token
556     // the burn is to penalize bans, so that they cannot suppress ideas
557     function banProposal(ProposalInterface _proposal, string _reason)
558     external payable
559     {
560         require(msg.value == proposalCensorshipFee);
561         require(accounts[msg.sender].membership & BOARD != 0);
562         Account storage account = accounts[_proposal];
563         require(account.membership & PROPOSAL != 0);
564         account.membership &= ~PROPOSAL;
565         burn.transfer(proposalCensorshipFee);
566         BannedProposal(_proposal, _reason);
567     }
568 
569     // board members reserve the right to reject outside proposals for any reason
570     function rejectProposal(ProposalInterface _proposal)
571     external
572     {
573         require(accounts[msg.sender].membership & BOARD != 0);
574         Account storage account = accounts[_proposal];
575         require(account.membership & PENDING_PROPOSAL != 0);
576         account.membership &= PENDING_PROPOSAL;
577     }
578 
579     // this code lives here instead of in the token so that it can be upgraded with account registry migration
580     function faucet()
581     external {
582         Account storage account = accounts[msg.sender];
583         require(account.membership & VOTER != 0);
584         uint256 lastAccess = account.lastAccess;
585         uint256 grant = (now - lastAccess) / 72 minutes;
586         if (grant > 40) {
587             grant = 40;
588             account.lastAccess = now;
589         } else {
590             account.lastAccess = lastAccess + grant * 72 minutes;
591         }
592         token.grant(msg.sender, grant);
593     }
594 
595     function availableFaucet(address _account)
596     external view
597     returns (uint256) {
598         uint256 grant = (now - accounts[_account].lastAccess) / 72 minutes;
599         if (grant > 40) {
600             grant = 40;
601         }
602         return grant;
603     }
604 }