1 pragma solidity ^0.4.11;
2 
3 // ==== DISCLAIMER ====
4 //
5 // ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.
6 // ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.
7 // IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.
8 // YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.
9 // DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.
10 //
11 // THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
12 // AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
13 // INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
14 // OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
15 // OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
16 // ====
17 //
18 
19 /// @author Santiment Sagl
20 /// @title  CrowdsaleMinter
21 
22 contract Base {
23 
24     function max(uint a, uint b) returns (uint) { return a >= b ? a : b; }
25     function min(uint a, uint b) returns (uint) { return a <= b ? a : b; }
26 
27     modifier only(address allowed) {
28         if (msg.sender != allowed) throw;
29         _;
30     }
31 
32 
33     ///@return True if `_addr` is a contract
34     function isContract(address _addr) constant internal returns (bool) {
35         if (_addr == 0) return false;
36         uint size;
37         assembly {
38             size := extcodesize(_addr)
39         }
40         return (size > 0);
41     }
42 
43     // *************************************************
44     // *          reentrancy handling                  *
45     // *************************************************
46 
47     //@dev predefined locks (up to uint bit length, i.e. 256 possible)
48     uint constant internal L00 = 2 ** 0;
49     uint constant internal L01 = 2 ** 1;
50     uint constant internal L02 = 2 ** 2;
51     uint constant internal L03 = 2 ** 3;
52     uint constant internal L04 = 2 ** 4;
53     uint constant internal L05 = 2 ** 5;
54 
55     //prevents reentrancy attacs: specific locks
56     uint private bitlocks = 0;
57     modifier noReentrancy(uint m) {
58         var _locks = bitlocks;
59         if (_locks & m > 0) throw;
60         bitlocks |= m;
61         _;
62         bitlocks = _locks;
63     }
64 
65     modifier noAnyReentrancy {
66         var _locks = bitlocks;
67         if (_locks > 0) throw;
68         bitlocks = uint(-1);
69         _;
70         bitlocks = _locks;
71     }
72 
73     ///@dev empty marking modifier signaling to user of the marked function , that it can cause an reentrant call.
74     ///     developer should make the caller function reentrant-safe if it use a reentrant function.
75     modifier reentrant { _; }
76 
77 }
78 
79 contract MintableToken {
80     //target token contract is responsible to accept only authorized mint calls.
81     function mint(uint amount, address account);
82 
83     //start the token on minting finished,
84     function start();
85 }
86 
87 contract Owned is Base {
88 
89     address public owner;
90     address public newOwner;
91 
92     function Owned() {
93         owner = msg.sender;
94     }
95 
96     function transferOwnership(address _newOwner) only(owner) {
97         newOwner = _newOwner;
98     }
99 
100     function acceptOwnership() only(newOwner) {
101         OwnershipTransferred(owner, newOwner);
102         owner = newOwner;
103     }
104 
105     event OwnershipTransferred(address indexed _from, address indexed _to);
106 
107 }
108 
109 contract BalanceStorage {
110     function balances(address account) public constant returns(uint balance);
111 }
112 
113 contract AddressList {
114     function contains(address addr) public constant returns (bool);
115 }
116 
117 contract MinMaxWhiteList {
118     function allowed(address addr) public constant returns (uint /*finney*/, uint /*finney*/ );
119 }
120 
121 contract PresaleBonusVoting {
122     function rawVotes(address addr) public constant returns (uint rawVote);
123 }
124 
125 contract CrowdsaleMinter is Owned {
126 
127     string public constant VERSION = "0.2.1-TEST.MAX.2";
128 
129     /* ====== configuration START ====== */
130     uint public constant COMMUNITY_SALE_START = 3971950; /* approx. 04.07.2017 10:00 */
131     uint public constant PRIORITY_SALE_START  = 3972150; /* approx. 04.07.2017 11:00 */
132     uint public constant PUBLIC_SALE_START    = 3972250; /* approx. 04.07.2017 11:30 */
133     uint public constant PUBLIC_SALE_END      = 3972350; /* approx. 04.07.2017 12:00 */
134     uint public constant WITHDRAWAL_END       = 3972450; /* approx. 04.07.2017 12:30 */
135 
136     address public TEAM_GROUP_WALLET           = 0x215aCB37845027cA64a4f29B2FCb7AffA8E9d326;
137     address public ADVISERS_AND_FRIENDS_WALLET = 0x41ab8360dEF1e19FdFa32092D83a7a7996C312a4;
138 
139     uint public constant TEAM_BONUS_PER_CENT            = 18;
140     uint public constant ADVISORS_AND_PARTNERS_PER_CENT = 10;
141 
142     MintableToken      public TOKEN                    = MintableToken(0x00000000000000000000000000);
143 
144     AddressList        public PRIORITY_ADDRESS_LIST    = AddressList(0x463635eFd22558c64Efa6227A45649eeDc0e4888);
145     MinMaxWhiteList    public COMMUNITY_ALLOWANCE_LIST = MinMaxWhiteList(0x26c63d631A307897d76Af5f02A08A09b3395DCb9);
146     BalanceStorage     public PRESALE_BALANCES         = BalanceStorage(0x4Fd997Ed7c10DbD04e95d3730cd77D79513076F2);
147     PresaleBonusVoting public PRESALE_BONUS_VOTING     = PresaleBonusVoting(0x283a97Af867165169AECe0b2E963b9f0FC7E5b8c);
148 
149     uint public constant COMMUNITY_PLUS_PRIORITY_SALE_CAP_ETH = 4;
150     uint public constant MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH = 3;
151     uint public constant MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH = 5;
152     uint public constant MIN_ACCEPTED_AMOUNT_FINNEY = 200;
153     uint public constant TOKEN_PER_ETH = 1000;
154     uint public constant PRE_SALE_BONUS_PER_CENT = 54;
155 
156     //constructor
157     function CrowdsaleMinter() {
158         //check configuration if something in setup is looking weird
159         if (
160             TOKEN_PER_ETH == 0
161             || TEAM_BONUS_PER_CENT + ADVISORS_AND_PARTNERS_PER_CENT >=100
162             || MIN_ACCEPTED_AMOUNT_FINNEY < 1
163             || owner == 0x0
164             || address(COMMUNITY_ALLOWANCE_LIST) == 0x0
165             || address(PRIORITY_ADDRESS_LIST) == 0x0
166             || address(PRESALE_BONUS_VOTING) == 0x0
167             || address(PRESALE_BALANCES) == 0x0
168             || COMMUNITY_SALE_START == 0
169             || PRIORITY_SALE_START == 0
170             || PUBLIC_SALE_START == 0
171             || PUBLIC_SALE_END == 0
172             || WITHDRAWAL_END == 0
173             || MIN_TOTAL_AMOUNT_TO_RECEIVE == 0
174             || MAX_TOTAL_AMOUNT_TO_RECEIVE == 0
175             || COMMUNITY_PLUS_PRIORITY_SALE_CAP == 0
176             || COMMUNITY_SALE_START <= block.number
177             || COMMUNITY_SALE_START >= PRIORITY_SALE_START
178             || PRIORITY_SALE_START >= PUBLIC_SALE_START
179             || PUBLIC_SALE_START >= PUBLIC_SALE_END
180             || PUBLIC_SALE_END >= WITHDRAWAL_END
181             || COMMUNITY_PLUS_PRIORITY_SALE_CAP > MAX_TOTAL_AMOUNT_TO_RECEIVE
182             || MIN_TOTAL_AMOUNT_TO_RECEIVE > MAX_TOTAL_AMOUNT_TO_RECEIVE )
183         throw;
184     }
185 
186     /* ====== configuration END ====== */
187 
188     /* ====== public states START====== */
189 
190     bool public isAborted = false;
191     mapping (address => uint) public balances;
192     bool public TOKEN_STARTED = false;
193     uint public total_received_amount;
194     address[] public investors;
195 
196     //displays number of uniq investors
197     function investorsCount() constant external returns(uint) { return investors.length; }
198 
199     //displays received amount in eth upto now
200     function TOTAL_RECEIVED_ETH() constant external returns (uint) { return total_received_amount / 1 ether; }
201 
202     //displays current contract state in human readable form
203     function state() constant external returns (string) { return stateNames[ uint(currentState()) ]; }
204 
205     function san_whitelist(address addr) public constant returns(uint, uint) { return COMMUNITY_ALLOWANCE_LIST.allowed(addr); }
206     function cfi_whitelist(address addr) public constant returns(bool) { return PRIORITY_ADDRESS_LIST.contains(addr); }
207 
208     /* ====== public states END ====== */
209 
210     string[] private stateNames = ["BEFORE_START", "COMMUNITY_SALE", "PRIORITY_SALE", "PRIORITY_SALE_FINISHED", "PUBLIC_SALE", "BONUS_MINTING", "WITHDRAWAL_RUNNING", "REFUND_RUNNING", "CLOSED" ];
211     enum State { BEFORE_START, COMMUNITY_SALE, PRIORITY_SALE, PRIORITY_SALE_FINISHED, PUBLIC_SALE, BONUS_MINTING, WITHDRAWAL_RUNNING, REFUND_RUNNING, CLOSED }
212 
213     uint private constant COMMUNITY_PLUS_PRIORITY_SALE_CAP = COMMUNITY_PLUS_PRIORITY_SALE_CAP_ETH * 1 ether;
214     uint private constant MIN_TOTAL_AMOUNT_TO_RECEIVE = MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
215     uint private constant MAX_TOTAL_AMOUNT_TO_RECEIVE = MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
216     uint private constant MIN_ACCEPTED_AMOUNT = MIN_ACCEPTED_AMOUNT_FINNEY * 1 finney;
217     bool private allBonusesAreMinted = false;
218 
219     //
220     // ======= interface methods =======
221     //
222 
223     //accept payments here
224     function ()
225     payable
226     noAnyReentrancy
227     {
228         State state = currentState();
229         uint amount_allowed;
230         if (state == State.COMMUNITY_SALE) {
231             var (min_finney, max_finney) = COMMUNITY_ALLOWANCE_LIST.allowed(msg.sender);
232             var (min, max) = (min_finney * 1 finney, max_finney * 1 finney);
233             var sender_balance = balances[msg.sender];
234             assert (sender_balance <= max); //sanity check: should be always true;
235             assert (msg.value >= min);      //reject payments less than minimum
236             amount_allowed = max - sender_balance;
237             _receiveFundsUpTo(amount_allowed);
238         } else if (state == State.PRIORITY_SALE) {
239             assert (PRIORITY_ADDRESS_LIST.contains(msg.sender));
240             amount_allowed = COMMUNITY_PLUS_PRIORITY_SALE_CAP - total_received_amount;
241             _receiveFundsUpTo(amount_allowed);
242         } else if (state == State.PUBLIC_SALE) {
243             amount_allowed = MAX_TOTAL_AMOUNT_TO_RECEIVE - total_received_amount;
244             _receiveFundsUpTo(amount_allowed);
245         } else if (state == State.REFUND_RUNNING) {
246             // any entring call in Refund Phase will cause full refund
247             _sendRefund();
248         } else {
249             throw;
250         }
251     }
252 
253 
254     function refund() external
255     inState(State.REFUND_RUNNING)
256     noAnyReentrancy
257     {
258         _sendRefund();
259     }
260 
261 
262     function withdrawFundsAndStartToken() external
263     inState(State.WITHDRAWAL_RUNNING)
264     noAnyReentrancy
265     only(owner)
266     {
267         // transfer funds to owner
268         if (!owner.send(this.balance)) throw;
269 
270         //notify token contract to start
271         if (TOKEN.call(bytes4(sha3("start()")))) {
272             TOKEN_STARTED = true;
273             TokenStarted(TOKEN);
274         }
275     }
276 
277     event TokenStarted(address tokenAddr);
278 
279     //there are around 40 addresses in PRESALE_ADDRESSES list. Everything fits into single Tx.
280     function mintAllBonuses() external
281     inState(State.BONUS_MINTING)
282     noAnyReentrancy
283     {
284         assert(!allBonusesAreMinted);
285         allBonusesAreMinted = true;
286 
287         uint TEAM_AND_PARTNERS_PER_CENT = TEAM_BONUS_PER_CENT + ADVISORS_AND_PARTNERS_PER_CENT;
288 
289         uint total_presale_amount_with_bonus = mintPresaleBonuses();
290         uint total_collected_amount = total_received_amount + total_presale_amount_with_bonus;
291         uint extra_amount = total_collected_amount * TEAM_AND_PARTNERS_PER_CENT / (100 - TEAM_AND_PARTNERS_PER_CENT);
292         uint extra_team_amount = extra_amount * TEAM_BONUS_PER_CENT / TEAM_AND_PARTNERS_PER_CENT;
293         uint extra_partners_amount = extra_amount * ADVISORS_AND_PARTNERS_PER_CENT / TEAM_AND_PARTNERS_PER_CENT;
294 /* 
295         //beautify total supply: round down to full eth.
296         uint total_to_mint = total_collected_amount + extra_amount;
297         uint round_remainder = total_to_mint - (total_to_mint / 1 ether * 1 ether);
298         extra_team_amount -= round_remainder; //this will reduce total_supply to rounded value
299 */
300         //mint group bonuses
301         _mint(extra_team_amount , TEAM_GROUP_WALLET);
302         _mint(extra_partners_amount, ADVISERS_AND_FRIENDS_WALLET);
303 
304     }
305 
306     function mintPresaleBonuses() internal returns(uint amount) {
307         uint total_presale_amount_with_bonus = 0;
308         //mint presale bonuses
309         for(uint i=0; i < PRESALE_ADDRESSES.length; ++i) {
310             address addr = PRESALE_ADDRESSES[i];
311             var amount_with_bonus = presaleTokenAmount(addr);
312             if (amount_with_bonus>0) {
313                 _mint(amount_with_bonus, addr);
314                 total_presale_amount_with_bonus += amount_with_bonus;
315             }
316         }//for
317         return total_presale_amount_with_bonus;
318     }
319 
320     function presaleTokenAmount(address addr) public constant returns(uint){
321         uint presale_balance = PRESALE_BALANCES.balances(addr);
322         if (presale_balance > 0) {
323             // this calculation is about waived pre-sale bonus.
324             // rawVote contains a value [0..1 ether].
325             //     0 ether    - means "default value" or "no vote" : 100% bonus saved
326             //     1 ether    - means "vote 100%" : 100% bonus saved
327             //    <=10 finney - special value "vote 0%" : no bonus at all (100% bonus waived).
328             //  other value - "PRE_SALE_BONUS_PER_CENT * rawVote / 1 ether" is an effective bonus per cent for particular presale member.
329             //
330             var rawVote = PRESALE_BONUS_VOTING.rawVotes(addr);
331             if (rawVote == 0)              rawVote = 1 ether; //special case "no vote" (default value) ==> (1 ether is 100%)
332             else if (rawVote <= 10 finney) rawVote = 0;       //special case "0%" (no bonus)           ==> (0 ether is   0%)
333             else if (rawVote > 1 ether)    rawVote = 1 ether; //max bonus is 100% (should not occur)
334             var presale_bonus = presale_balance * PRE_SALE_BONUS_PER_CENT * rawVote / 1 ether / 100;
335             return presale_balance + presale_bonus;
336         } else {
337             return 0;
338         }
339     }
340 
341     function attachToToken(MintableToken tokenAddr) external
342     inState(State.BEFORE_START)
343     only(owner)
344     {
345         TOKEN = tokenAddr;
346     }
347 
348     function abort() external
349     inStateBefore(State.REFUND_RUNNING)
350     only(owner)
351     {
352         isAborted = true;
353     }
354 
355     //
356     // ======= implementation methods =======
357     //
358 
359     function _sendRefund() private
360     tokenHoldersOnly
361     {
362         // load balance to refund plus amount currently sent
363         var amount_to_refund = balances[msg.sender] + msg.value;
364         // reset balance
365         balances[msg.sender] = 0;
366         // send refund back to sender
367         if (!msg.sender.send(amount_to_refund)) throw;
368     }
369 
370     function _receiveFundsUpTo(uint amount) private
371     notTooSmallAmountOnly
372     {
373         require (amount > 0);
374         if (msg.value > amount) {
375             // accept amount only and return change
376             var change_to_return = msg.value - amount;
377             if (!msg.sender.send(change_to_return)) throw;
378         } else {
379             // accept full amount
380             amount = msg.value;
381         }
382         if (balances[msg.sender] == 0) investors.push(msg.sender);
383         balances[msg.sender] += amount;
384         total_received_amount += amount;
385         _mint(amount,msg.sender);
386     }
387 
388     function _mint(uint amount, address account) private {
389         MintableToken(TOKEN).mint(amount * TOKEN_PER_ETH, account);
390     }
391 
392     function currentState() private constant
393     returns (State)
394     {
395         if (isAborted) {
396             return this.balance > 0
397                    ? State.REFUND_RUNNING
398                    : State.CLOSED;
399         } else if (block.number < COMMUNITY_SALE_START || address(TOKEN) == 0x0) {
400              return State.BEFORE_START;
401         } else if (block.number < PRIORITY_SALE_START) {
402             return State.COMMUNITY_SALE;
403         } else if (block.number < PUBLIC_SALE_START) {
404             return total_received_amount < COMMUNITY_PLUS_PRIORITY_SALE_CAP
405                 ? State.PRIORITY_SALE
406                 : State.PRIORITY_SALE_FINISHED;
407         } else if (block.number <= PUBLIC_SALE_END && total_received_amount < MAX_TOTAL_AMOUNT_TO_RECEIVE) {
408             return State.PUBLIC_SALE;
409         } else if (this.balance == 0) {
410             return State.CLOSED;
411         } else if (block.number <= WITHDRAWAL_END && total_received_amount >= MIN_TOTAL_AMOUNT_TO_RECEIVE) {
412             return allBonusesAreMinted
413                 ? State.WITHDRAWAL_RUNNING
414                 : State.BONUS_MINTING;
415         } else {
416             return State.REFUND_RUNNING;
417         }
418     }
419 
420     //
421     // ============ modifiers ============
422     //
423 
424     //fails if state dosn't match
425     modifier inState(State state) {
426         if (state != currentState()) throw;
427         _;
428     }
429 
430     //fails if the current state is not before than the given one.
431     modifier inStateBefore(State state) {
432         if (currentState() >= state) throw;
433         _;
434     }
435 
436     //accepts calls from token holders only
437     modifier tokenHoldersOnly(){
438         if (balances[msg.sender] == 0) throw;
439         _;
440     }
441 
442 
443     // don`t accept transactions with value less than allowed minimum
444     modifier notTooSmallAmountOnly(){
445         if (msg.value < MIN_ACCEPTED_AMOUNT) throw;
446         _;
447     }
448 
449     //
450     // ============ DATA ============
451     //
452 
453     address[] PRESALE_ADDRESSES = [
454         0xF55DFd2B02Cf3282680C94BD01E9Da044044E6A2,
455         0x0D40B53828948b340673674Ae65Ee7f5D8488e33,
456         0x0ea690d466d6bbd18F124E204EA486a4Bf934cbA,
457         0x6d25B9f40b92CcF158250625A152574603465192,
458         0x481Da0F1e89c206712BCeA4f7D6E60d7b42f6C6C,
459         0x416EDa5D6Ed29CAc3e6D97C102d61BC578C5dB87,
460         0xD78Ac6FFc90E084F5fD563563Cc9fD33eE303f18,
461         0xe6714ab523acEcf9b85d880492A2AcDBe4184892,
462         0x285A9cA5fE9ee854457016a7a5d3A3BB95538093,
463         0x600ca6372f312B081205B2C3dA72517a603a15Cc,
464         0x2b8d5C9209fBD500Fd817D960830AC6718b88112,
465         0x4B15Dd23E5f9062e4FB3a9B7DECF653C0215e560,
466         0xD67449e6AB23c1f46dea77d3f5E5D47Ff33Dc9a9,
467         0xd0ADaD7ed81AfDa039969566Ceb8423E0ab14d90,
468         0x245f27796a44d7E3D30654eD62850ff09EE85656,
469         0x639D6eC2cef4d6f7130b40132B3B6F5b667e5105,
470         0x5e9a69B8656914965d69d8da49c3709F0bF2B5Ef,
471         0x0832c3B801319b62aB1D3535615d1fe9aFc3397A,
472         0xf6Dd631279377205818C3a6725EeEFB9D0F6b9F3,
473         0x47696054e71e4c3f899119601a255a7065C3087B,
474         0xf107bE6c6833f61A24c64D63c8A7fcD784Abff06,
475         0x056f072Bd2240315b708DBCbDDE80d400f0394a1,
476         0x9e5BaeC244D8cCD49477037E28ed70584EeAD956,
477         0x40A0b2c1B4E30F27e21DF94e734671856b485966,
478         0x84f0620A547a4D14A7987770c4F5C25d488d6335,
479         0x036Ac11c161C09d94cA39F7B24C1bC82046c332B,
480         0x2912A18C902dE6f95321D6d6305D7B80Eec4C055,
481         0xE1Ad30971b83c17E2A24c0334CB45f808AbEBc87,
482         0x07f35b7FE735c49FD5051D5a0C2e74c9177fEa6d,
483         0x11669Cce6AF3ce1Ef3777721fCC0eef0eE57Eaba,
484         0xBDbaF6434d40D6355B1e80e40Cc4AB9C68D96116,
485         0x17125b59ac51cEe029E4bD78D7f5947D1eA49BB2,
486         0xA382A3A65c3F8ee2b726A2535B3c34A89D9094D4,
487         0xAB78c8781fB64Bed37B274C5EE759eE33465f1f3,
488         0xE74F2062612E3cAE8a93E24b2f0D3a2133373884,
489         0x505120957A9806827F8F111A123561E82C40bC78,
490         0x00A46922B1C54Ae6b5818C49B97E03EB4BB352e1,
491         0xE76fE52a251C8F3a5dcD657E47A6C8D16Fdf4bFA
492     ];
493 
494 }// CrowdsaleMinter