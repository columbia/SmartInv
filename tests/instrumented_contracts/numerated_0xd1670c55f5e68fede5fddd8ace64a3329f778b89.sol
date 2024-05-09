1 pragma solidity ^0.4.23;
2 
3 /*
4  * Contract accepting reservations for ATS tokens.
5  * The actual tokens are not yet created and distributed due to non-technical reasons.
6  * This contract is used to collect funds for the ATS token sale and to transparently document that on a blockchain.
7  * It is tailored to allow a simple user journey while keeping complexity minimal.
8  * Once the privileged "state controller" sets the state to "Open", anybody can send Ether to the contract.
9  * Only Ether sent from whitelisted addresses is accepted for future ATS token conversion.
10  * The whitelisting is done by a dedicated whitelist controller.
11  * Whitelisting can take place asynchronously - that is, participants don't need to wait for the whitelisting to
12  * succeed before sending funds. This is a technical detail which allows for a smoother user journey.
13  * The state controller can switch to synchronous whitelisting (no Ether accepted from accounts not whitelisted before).
14  * Participants can trigger refunding during the Open state by making a transfer of 0 Ether.
15  * Funds of those not whitelisted (not accepted) are never locked, they can trigger refund beyond Open state.
16  * Only in Over state can whitelisted Ether deposits be fetched from the contract.
17  *
18  * When setting the state to Open, the state controller specifies a minimal timeframe for this state.
19  * Transition to the next state (Locked) is not possible (enforced by the contract).
20  * This gives participants the guarantee that they can get their full deposits refunded anytime and independently
21  * of the will of anybody else during that timeframe.
22  * (Note that this is true only as long as the whole process takes place before the date specified by FALLBACK_FETCH_FUNDS_TS)
23  *
24  * Ideally, there's no funds left in the contract once the state is set to Over and the accepted deposits were fetched.
25  * Since this can't really be foreseen, there's a fallback which allows to fetch all remaining Ether
26  * to a pre-specified address after a pre-specified date.
27  *
28  * Static analysis: block.timestamp is not used in a way which gives miners leeway for taking advantage.
29  *
30  * see https://code.lab10.io/graz/04-artis/artis/issues/364 for task evolution
31  */
32 contract ATSTokenReservation {
33 
34     // ################### DATA STRUCTURES ###################
35 
36     enum States {
37         Init, // initial state. Contract is deployed, but deposits not yet accepted
38         Open, // open for token reservations. Refunds possible for all
39         Locked, // open for token reservations. Refunds locked for accepted deposits
40         Over // contract has done its duty. Funds payout can be triggered by state controller
41     }
42 
43     // ################### CONSTANTS ###################
44 
45     // 1. Oct 2018
46     uint32 FALLBACK_PAYOUT_TS = 1538352000;
47 
48     // ################### STATE VARIABLES ###################
49 
50     States public state = States.Init;
51 
52     // privileged account: switch contract state, change config, whitelisting, trigger payout, ...
53     address public stateController;
54 
55     // privileged account: whitelisting
56     address public whitelistController;
57 
58     // Collected funds can be transferred only to this address. Is set in constructor.
59     address public payoutAddress;
60 
61     // accepted deposits (received from whitelisted accounts)
62     uint256 public cumAcceptedDeposits = 0;
63     // not (yet) accepted deposits (received from non-whitelisted accounts)
64     uint256 public cumAlienDeposits = 0;
65 
66     // cap for how much we accept (since the amount of tokens sold is also capped)
67     uint256 public maxCumAcceptedDeposits = 1E9 * 1E18; // pre-set to effectively unlimited (> existing ETH)
68 
69     uint256 public minDeposit = 0.1 * 1E18; // lower bound per participant (can be a kind of spam protection)
70 
71     uint256 minLockingTs; // earliest possible start of "locked" phase
72 
73     // whitelisted addresses (those having "accepted" deposits)
74     mapping (address => bool) public whitelist;
75 
76     // the state controller can set this in order to disallow deposits from addresses not whitelisted before
77     bool public requireWhitelistingBeforeDeposit = false;
78 
79     // tracks accepted deposits (whitelisted accounts)
80     mapping (address => uint256) public acceptedDeposits;
81 
82     // tracks alien (not yet accepted) deposits (non-whitelisted accounts)
83     mapping (address => uint256) public alienDeposits;
84 
85     // ################### EVENTS ###################
86 
87     // emitted events transparently document the open funding activities.
88     // only deposits made by whitelisted accounts (and not followed by a refund) count.
89 
90     event StateTransition(States oldState, States newState);
91     event Whitelisted(address addr);
92     event Deposit(address addr, uint256 amount);
93     event Refund(address addr, uint256 amount);
94 
95     // emitted when the accepted deposits are fetched to an account controlled by the ATS token provider
96     event FetchedDeposits(uint256 amount);
97 
98     // ################### MODIFIERS ###################
99 
100     modifier onlyStateControl() { require(msg.sender == stateController, "no permission"); _; }
101 
102     modifier onlyWhitelistControl()	{
103         require(msg.sender == stateController || msg.sender == whitelistController, "no permission");
104         _;
105     }
106 
107     modifier requireState(States _requiredState) { require(state == _requiredState, "wrong state"); _; }
108 
109     // ################### CONSTRUCTOR ###################
110 
111     // the contract creator is set as stateController
112     constructor(address _whitelistController, address _payoutAddress) public {
113         whitelistController = _whitelistController;
114         payoutAddress = _payoutAddress;
115         stateController = msg.sender;
116     }
117 
118     // ################### FALLBACK FUNCTION ###################
119 
120     // implements the deposit and refund actions.
121     function () payable public {
122         if(msg.value > 0) {
123             require(state == States.Open || state == States.Locked);
124             if(requireWhitelistingBeforeDeposit) {
125                 require(whitelist[msg.sender] == true, "not whitelisted");
126             }
127             tryDeposit();
128         } else {
129             tryRefund();
130         }
131     }
132 
133     // ################### PUBLIC FUNCTIONS ###################
134 
135     function stateSetOpen(uint32 _minLockingTs) public
136         onlyStateControl
137         requireState(States.Init)
138     {
139         minLockingTs = _minLockingTs;
140         setState(States.Open);
141     }
142 
143     function stateSetLocked() public
144         onlyStateControl
145         requireState(States.Open)
146     {
147         require(block.timestamp >= minLockingTs);
148         setState(States.Locked);
149     }
150 
151     function stateSetOver() public
152         onlyStateControl
153         requireState(States.Locked)
154     {
155         setState(States.Over);
156     }
157 
158     // state controller can change the cap. Reducing possible only if not below current deposits
159     function updateMaxAcceptedDeposits(uint256 _newMaxDeposits) public onlyStateControl {
160         require(cumAcceptedDeposits <= _newMaxDeposits);
161         maxCumAcceptedDeposits = _newMaxDeposits;
162     }
163 
164     // new limit to be enforced for future deposits
165     function updateMinDeposit(uint256 _newMinDeposit) public onlyStateControl {
166         minDeposit = _newMinDeposit;
167     }
168 
169     // option to switch between async and sync whitelisting
170     function setRequireWhitelistingBeforeDeposit(bool _newState) public onlyStateControl {
171         requireWhitelistingBeforeDeposit = _newState;
172     }
173 
174     // Since whitelisting can occur asynchronously, an account to be whitelisted may already have deposited Ether.
175     // In this case the deposit is converted form alien to accepted.
176     // Since the deposit logic depends on the whitelisting status and since transactions are processed sequentially,
177     // it's ensured that at any time an account can have either (XOR) no or alien or accepted deposits and that
178     // the whitelisting status corresponds to the deposit status (not_whitelisted <-> alien | whitelisted <-> accepted).
179     // This function is idempotent.
180     function addToWhitelist(address _addr) public onlyWhitelistControl {
181         if(whitelist[_addr] != true) {
182             // if address has alien deposit: convert it to accepted
183             if(alienDeposits[_addr] > 0) {
184                 cumAcceptedDeposits += alienDeposits[_addr];
185                 acceptedDeposits[_addr] += alienDeposits[_addr];
186                 cumAlienDeposits -= alienDeposits[_addr];
187                 delete alienDeposits[_addr]; // needs to be the last statement in this block!
188             }
189             whitelist[_addr] = true;
190             emit Whitelisted(_addr);
191         }
192     }
193 
194     // Option for batched whitelisting (for times with crowded chain).
195     // caller is responsible to not blow gas limit with too many addresses at once
196     function batchAddToWhitelist(address[] _addresses) public onlyWhitelistControl {
197         for (uint i = 0; i < _addresses.length; i++) {
198             addToWhitelist(_addresses[i]);
199         }
200     }
201 
202 
203     // transfers an alien deposit back to the sender
204     function refundAlienDeposit(address _addr) public onlyWhitelistControl {
205         // Note: this implementation requires that alienDeposits has a primitive value type.
206         // With a complex type, this code would produce a dangling reference.
207         uint256 withdrawAmount = alienDeposits[_addr];
208         require(withdrawAmount > 0);
209         delete alienDeposits[_addr]; // implies setting the value to 0
210         cumAlienDeposits -= withdrawAmount;
211         emit Refund(_addr, withdrawAmount);
212         _addr.transfer(withdrawAmount); // throws on failure
213     }
214 
215     // payout of the accepted deposits to the pre-designated address, available once it's all over
216     function payout() public
217         onlyStateControl
218         requireState(States.Over)
219     {
220         uint256 amount = cumAcceptedDeposits;
221         cumAcceptedDeposits = 0;
222         emit FetchedDeposits(amount);
223         payoutAddress.transfer(amount);
224         // not idempotent, but multiple invocation would just trigger zero-transfers
225     }
226 
227     // After the specified date, any of the privileged/special accounts can trigger payment of remaining funds
228     // to the payoutAddress. This is a safety net to minimize the risk of funds remaining stuck.
229     // It's not yet clear what we can / should / are allowed to do with alien deposits which aren't reclaimed.
230     // With this fallback in place, we have for example the option to donate them at some point.
231     function fallbackPayout() public {
232         require(msg.sender == stateController || msg.sender == whitelistController || msg.sender == payoutAddress);
233         require(block.timestamp > FALLBACK_PAYOUT_TS);
234         payoutAddress.transfer(address(this).balance);
235     }
236 
237     // ################### INTERNAL FUNCTIONS ###################
238 
239     // rule enforcement and book-keeping for incoming deposits
240     function tryDeposit() internal {
241         require(cumAcceptedDeposits + msg.value <= maxCumAcceptedDeposits);
242         if(whitelist[msg.sender] == true) {
243             require(acceptedDeposits[msg.sender] + msg.value >= minDeposit);
244             acceptedDeposits[msg.sender] += msg.value;
245             cumAcceptedDeposits += msg.value;
246         } else {
247             require(alienDeposits[msg.sender] + msg.value >= minDeposit);
248             alienDeposits[msg.sender] += msg.value;
249             cumAlienDeposits += msg.value;
250         }
251         emit Deposit(msg.sender, msg.value);
252     }
253 
254     // rule enforcement and book-keeping for refunding requests
255     function tryRefund() internal {
256         // Note: this implementation requires that acceptedDeposits and alienDeposits have a primitive value type.
257         // With a complex type, this code would produce dangling references.
258         uint256 withdrawAmount;
259         if(whitelist[msg.sender] == true) {
260             require(state == States.Open);
261             withdrawAmount = acceptedDeposits[msg.sender];
262             require(withdrawAmount > 0);
263             delete acceptedDeposits[msg.sender]; // implies setting the value to 0
264             cumAcceptedDeposits -= withdrawAmount;
265         } else {
266             // alien deposits can be withdrawn anytime (we prefer to not touch them)
267             withdrawAmount = alienDeposits[msg.sender];
268             require(withdrawAmount > 0);
269             delete alienDeposits[msg.sender]; // implies setting the value to 0
270             cumAlienDeposits -= withdrawAmount;
271         }
272         emit Refund(msg.sender, withdrawAmount);
273         // do the actual transfer last as recommended since the DAO incident (Checks-Effects-Interaction pattern)
274         msg.sender.transfer(withdrawAmount); // throws on failure
275     }
276 
277     function setState(States _newState) internal {
278         state = _newState;
279         emit StateTransition(state, _newState);
280     }
281 }