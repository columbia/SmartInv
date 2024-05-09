1 pragma solidity ^0.4.17;
2 
3 //
4 // ==== DISCLAIMER ====
5 //
6 // ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.
7 // ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.
8 // IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.
9 // YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.
10 // DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.
11 //
12 // THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
13 // AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
14 // INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
15 // OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
16 // OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
17 // ====
18 //
19 //
20 // ==== PARANOIA NOTICE ====
21 // A careful reader will find some additional checks and excessive code, consuming some extra gas. This is intentional.
22 // Even though the contract should work without these parts, they make the code more secure in production and for future refactoring.
23 // Also, they show more clearly what we have considered and addressed during development.
24 // Discussion is welcome!
25 // ====
26 //
27 
28 /// @author ethernian
29 /// @notice report bugs to: bugs@ethernian.com
30 /// @title BnsPresale Contract
31 
32 contract BnsPresale {
33 
34     string public constant VERSION = "0.2.0-demo-test-02-max_1_eth";
35 
36     /* ====== configuration START ====== */
37     uint public constant PRESALE_START  = 4470680; /* approx. WED NOV 01 2017 16:45:00 GMT+0300 (CET) */
38     uint public constant PRESALE_END    = 4470740; /* approx. WED NOV 01 2017 17:00:00 GMT+0300 (CET) */
39     uint public constant WITHDRAWAL_END = 4470800; /* approx. WED NOV 01 2017 17:15:00 GMT+0100 (CET) */
40 
41     address public constant OWNER = 0xcEAfe38b8d3802789A2A2cc45EA5d08bE8EA3b49;
42 
43     uint public constant MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH = 0;
44     uint public constant MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH = 1;
45     uint public constant MIN_ACCEPTED_AMOUNT_FINNEY = 1;
46 
47     /* ====== configuration END ====== */
48 
49     string[5] private stateNames = ["BEFORE_START",  "PRESALE_RUNNING", "WITHDRAWAL_RUNNING", "REFUND_RUNNING", "CLOSED" ];
50     enum State { BEFORE_START,  PRESALE_RUNNING, WITHDRAWAL_RUNNING, REFUND_RUNNING, CLOSED }
51 
52     uint public total_received_amount;
53     uint public total_refunded;
54     mapping (address => uint) public balances;
55 
56     uint private constant MIN_TOTAL_AMOUNT_TO_RECEIVE = MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
57     uint private constant MAX_TOTAL_AMOUNT_TO_RECEIVE = MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
58     uint private constant MIN_ACCEPTED_AMOUNT = MIN_ACCEPTED_AMOUNT_FINNEY * 1 finney;
59     bool public isAborted = false;
60     bool public isStopped = false;
61 
62 
63     //constructor
64     function BnsPresale () public validSetupOnly() { }
65 
66     //
67     // ======= interface methods =======
68     //
69 
70     //accept payments here
71     function ()
72     payable
73     noReentrancy
74     public
75     {
76         State state = currentState();
77         if (state == State.PRESALE_RUNNING) {
78             receiveFunds();
79         } else if (state == State.REFUND_RUNNING) {
80             // any entring call in Refund Phase will cause full refund
81             sendRefund();
82         } else {
83             revert();
84         }
85     }
86 
87     function refund() external
88     inState(State.REFUND_RUNNING)
89     noReentrancy
90     {
91         sendRefund();
92     }
93 
94 
95     function withdrawFunds() external
96     onlyOwner
97     noReentrancy
98     {
99         // transfer funds to owner if any
100         OWNER.transfer(this.balance);
101     }
102 
103 
104     function abort() external
105     inStateBefore(State.REFUND_RUNNING)
106     onlyOwner
107     {
108         isAborted = true;
109     }
110 
111 
112     function stop() external
113     inState(State.PRESALE_RUNNING)
114     onlyOwner
115     {
116         isStopped = true;
117     }
118 
119 
120     //displays current contract state in human readable form
121     function state() external constant
122     returns (string)
123     {
124         return stateNames[ uint(currentState()) ];
125     }
126 
127 
128     //
129     // ======= implementation methods =======
130     //
131 
132     function sendRefund() private tokenHoldersOnly {
133         // load balance to refund plus amount currently sent
134         uint amount_to_refund = min(balances[msg.sender], this.balance - msg.value) ;
135 //
136         // change balance
137         balances[msg.sender] -= amount_to_refund;
138         total_refunded += amount_to_refund;
139 
140         // send refund back to sender
141         msg.sender.transfer(amount_to_refund + msg.value);
142     }
143 
144 
145     function receiveFunds() private notTooSmallAmountOnly {
146       // no overflow is possible here: nobody have soo much money to spend.
147       if (total_received_amount + msg.value > MAX_TOTAL_AMOUNT_TO_RECEIVE) {
148           // accept amount only and return change
149           var change_to_return = total_received_amount + msg.value - MAX_TOTAL_AMOUNT_TO_RECEIVE;
150           var acceptable_remainder = MAX_TOTAL_AMOUNT_TO_RECEIVE - total_received_amount;
151           balances[msg.sender] += acceptable_remainder;
152           total_received_amount += acceptable_remainder;
153 
154           msg.sender.transfer(change_to_return);
155       } else {
156           // accept full amount
157           balances[msg.sender] += msg.value;
158           total_received_amount += msg.value;
159       }
160     }
161 
162 
163     function currentState() private constant returns (State) {
164         if (isAborted) {
165             return this.balance > 0
166                    ? State.REFUND_RUNNING
167                    : State.CLOSED;
168         } else if (block.number < PRESALE_START) {
169             return State.BEFORE_START;
170         } else if (block.number <= PRESALE_END && total_received_amount < MAX_TOTAL_AMOUNT_TO_RECEIVE && !isStopped) {
171             return State.PRESALE_RUNNING;
172         } else if (this.balance == 0) {
173             return State.CLOSED;
174         } else if (block.number <= WITHDRAWAL_END && total_received_amount >= MIN_TOTAL_AMOUNT_TO_RECEIVE) {
175             return State.WITHDRAWAL_RUNNING;
176         } else {
177             return State.REFUND_RUNNING;
178         }
179     }
180 
181     function min(uint a, uint b) pure private returns (uint) {
182         return a < b ? a : b;
183     }
184 
185 
186     //
187     // ============ modifiers ============
188     //
189 
190     //fails if state doesn't match
191     modifier inState(State state) {
192         assert(state == currentState());
193         _;
194     }
195 
196     //fails if the current state is not before than the given one.
197     modifier inStateBefore(State state) {
198         assert(currentState() < state);
199         _;
200     }
201 
202 
203     //fails if something in setup is looking weird
204     modifier validSetupOnly() {
205         if ( OWNER == 0x0
206             || PRESALE_START == 0
207             || PRESALE_END == 0
208             || WITHDRAWAL_END ==0
209             || PRESALE_START <= block.number
210             || PRESALE_START >= PRESALE_END
211             || PRESALE_END   >= WITHDRAWAL_END
212             || MIN_TOTAL_AMOUNT_TO_RECEIVE > MAX_TOTAL_AMOUNT_TO_RECEIVE )
213                 revert();
214         _;
215     }
216 
217 
218     //accepts calls from owner only
219     modifier onlyOwner(){
220         assert(msg.sender == OWNER);
221         _;
222     }
223 
224 
225     //accepts calls from token holders only
226     modifier tokenHoldersOnly(){
227         assert(balances[msg.sender] > 0);
228         _;
229     }
230 
231 
232     // don`t accept transactions with value less than allowed minimum
233     modifier notTooSmallAmountOnly(){
234         assert(msg.value >= MIN_ACCEPTED_AMOUNT);
235         _;
236     }
237 
238 
239     //prevents reentrancy attacs
240     bool private locked = false;
241     modifier noReentrancy() {
242         assert(!locked);
243         locked = true;
244         _;
245         locked = false;
246     }
247 }//contract