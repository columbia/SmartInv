1 pragma solidity ^0.4.8;
2 
3 /**
4  * Very basic owned/mortal boilerplate.  Used for basically everything, for
5  * security/access control purposes.
6  */
7 contract Owned {
8   address owner;
9 
10   modifier onlyOwner {
11     if (msg.sender != owner) {
12       throw;
13     }
14     _;
15   }
16 
17   /**
18    * Basic constructor.  The sender is the owner.
19    */
20   function Owned() {
21     owner = msg.sender;
22   }
23 
24   /**
25    * Transfers ownership of the contract to a new owner.
26    * @param newOwner  Who gets to inherit this thing.
27    */
28   function transferOwnership(address newOwner) onlyOwner {
29     owner = newOwner;
30   }
31 
32   /**
33    * Shuts down the contract and removes it from the blockchain state.
34    * Only available to the owner.
35    */
36   function shutdown() onlyOwner {
37     selfdestruct(owner);
38   }
39 
40   /**
41    * Withdraw all the funds from this contract.
42    * Only available to the owner.
43    */
44   function withdraw() onlyOwner {
45     if (!owner.send(this.balance)) {
46       throw;
47     }
48   }
49 }
50 
51 contract LotteryRoundFactoryInterface {
52   string public VERSION;
53   function transferOwnership(address newOwner);
54 }
55 
56 contract LotteryRoundFactoryInterfaceV1 is LotteryRoundFactoryInterface {
57   function createRound(bytes32 _saltHash, bytes32 _saltNHash) payable returns(address);
58 }
59 
60 contract LotteryRoundInterface {
61   bool public winningNumbersPicked;
62   uint256 public closingBlock;
63 
64   function pickTicket(bytes4 picks) payable;
65   function randomTicket() payable;
66 
67   function proofOfSalt(bytes32 salt, uint8 N) constant returns(bool);
68   function closeGame(bytes32 salt, uint8 N);
69   function claimOwnerFee(address payout);
70   function withdraw();
71   function shutdown();
72   function distributeWinnings();
73   function claimPrize();
74 
75   function paidOut() constant returns(bool);
76   function transferOwnership(address newOwner);
77 }
78 
79 /**
80  * The base interface is what the parent contract expects to be able to use.
81  * If rules change in the future, and new logic is introduced, it only has to
82  * implement these methods, wtih the role of the curator being used
83  * to execute the additional functionality (if any).
84  */
85 contract LotteryGameLogicInterface {
86   address public currentRound;
87   function finalizeRound() returns(address);
88   function isUpgradeAllowed() constant returns(bool);
89   function transferOwnership(address newOwner);
90 }
91 
92 contract LotteryGameLogicInterfaceV1 is LotteryGameLogicInterface {
93   function deposit() payable;
94   function setCurator(address newCurator);
95 }
96 
97 
98 /**
99  * Core game logic.  Handlings management of rounds, carry-over balances,
100  * paying winners, etc.  Separate from the main contract because it's more
101  * tightly-coupled to the factory/round logic than the game logic.  This
102  * allows for new rules in the future (e.g. partial picks, etc).  Carries
103  * the caveat that it cannot be upgraded until the current rules produce
104  * a winner, and can only be upgraded in the period between a winner under
105  * the current rules and the next round being started.
106  */
107 contract LotteryGameLogic is LotteryGameLogicInterfaceV1, Owned {
108 
109   LotteryRoundFactoryInterfaceV1 public roundFactory;
110 
111   address public curator;
112 
113   LotteryRoundInterface public currentRound;
114 
115   modifier onlyWhenNoRound {
116     if (currentRound != LotteryRoundInterface(0)) {
117       throw;
118     }
119     _;
120   }
121 
122   modifier onlyBeforeDraw {
123     if (
124       currentRound == LotteryRoundInterface(0) ||
125       block.number <= currentRound.closingBlock() ||
126       currentRound.winningNumbersPicked() == true
127     ) {
128       throw;
129     }
130     _;
131   }
132 
133   modifier onlyAfterDraw {
134     if (
135       currentRound == LotteryRoundInterface(0) ||
136       currentRound.winningNumbersPicked() == false
137     ) {
138       throw;
139     }
140     _;
141   }
142 
143   modifier onlyCurator {
144     if (msg.sender != curator) {
145       throw;
146     }
147     _;
148   }
149 
150   modifier onlyFromCurrentRound {
151     if (msg.sender != address(currentRound)) {
152       throw;
153     }
154     _;
155   }
156 
157   /**
158    * Creates the core logic of the lottery.  Requires a round factory
159    * and an initial curator.
160    * @param _roundFactory  The factory to generate new rounds
161    * @param _curator       The initial curator
162    */
163   function LotteryGameLogic(address _roundFactory, address _curator) {
164     roundFactory = LotteryRoundFactoryInterfaceV1(_roundFactory);
165     curator = _curator;
166   }
167 
168   /**
169    * Allows the curator to hand over curation responsibilities to someone else.
170    * @param newCurator  The new curator
171    */
172   function setCurator(address newCurator) onlyCurator onlyWhenNoRound {
173     curator = newCurator;
174   }
175 
176   /**
177    * Specifies whether or not upgrading this contract is allowed.  In general, if there
178    * is a round underway, or this contract is holding a balance, upgrading is not allowed.
179    */
180   function isUpgradeAllowed() constant returns(bool) {
181     return currentRound == LotteryRoundInterface(0) && this.balance < 1 finney;
182   }
183 
184   /**
185    * Starts a new round.  Can only be started by the curator, and only when there is no round
186    * currently underway
187    * @param saltHash    Secret salt, hashed N times.
188    * @param saltNHash   Proof of N, in the form of sha3(salt, N, salt)
189    */
190   function startRound(bytes32 saltHash, bytes32 saltNHash) onlyCurator onlyWhenNoRound {
191     if (this.balance > 0) {
192       currentRound = LotteryRoundInterface(
193         roundFactory.createRound.value(this.balance)(saltHash, saltNHash)
194       );
195     } else {
196       currentRound = LotteryRoundInterface(roundFactory.createRound(saltHash, saltNHash));
197     }
198   }
199 
200   /**
201    * Reveal the chosen salt and number of hash iterations, then close the current roundn
202    * and pick the winning numbers
203    * @param salt   The original salt
204    * @param N      The original N
205    */
206   function closeRound(bytes32 salt, uint8 N) onlyCurator onlyBeforeDraw {
207     currentRound.closeGame(salt, N);
208   }
209 
210   /**
211    * Finalize the round before returning it back to the the parent contract for
212    * historical purposes.  Attempts to pay winners and the curator if there was a winning
213    * draw, otherwise, pulls the balance out of the round before handing over ownership
214    * to the curator.
215    */
216   function finalizeRound() onlyOwner onlyAfterDraw returns(address) {
217     address roundAddress = address(currentRound);
218     if (!currentRound.paidOut()) {
219       // we'll only make one attempt here to pay the winners
220       currentRound.distributeWinnings();
221       currentRound.claimOwnerFee(curator);
222     } else if (currentRound.balance > 0) {
223       // otherwise, we have no winners, so just pull out funds in
224       // preparation for the next round.
225       currentRound.withdraw();
226     }
227 
228     // be sure someone can handle disputes, etc, if they arise.
229     // not that they'll be able to *do* anything, but they can at least
230     // try calling `distributeWinnings()` again...
231     currentRound.transferOwnership(curator);
232 
233     // clear this shit out.
234     delete currentRound;
235 
236     // if there are or were any problems distributing winnings, the winners can attempt to withdraw
237     // funds for themselves.  The contracts won't be destroyed so long as they have funds to pay out.
238     // handling them might require special care or something.
239 
240     return roundAddress;
241   }
242 
243   /**
244    * Mostly just used for testing.  Technically, this contract may be seeded with an initial deposit
245    * before
246    */
247   function deposit() payable onlyOwner onlyWhenNoRound {
248     // noop, just used for depositing funds during an upgrade.
249   }
250 
251   /**
252    * Only accept payments from the current round.  Required due to calling `.withdraw` at round's end.
253    */
254   function () payable onlyFromCurrentRound {
255     // another noop, since we can only receive funds from the current round.
256   }
257 }