1 pragma solidity ^0.4.6;
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
30 /// @title Presale Contract
31 
32 contract Presale {
33 
34     string public constant VERSION = "0.1.4-beta";
35 
36     /* ====== configuration START ====== */
37     uint public constant PRESALE_START  = 3151809; /* approx. 09.02.2017 14:30 */
38     uint public constant PRESALE_END    = 3152066; /* approx. 09.02.2017 15:30 */
39     uint public constant WITHDRAWAL_END = 3152323; /* approx. 09.02.2017 16:30 */
40 
41 
42     address public constant OWNER = 0xE76fE52a251C8F3a5dcD657E47A6C8D16Fdf4bFA;
43 
44     uint public constant MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH = 1;
45     uint public constant MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH = 5;
46     uint public constant MIN_ACCEPTED_AMOUNT_FINNEY = 1;
47 
48     /* ====== configuration END ====== */
49 
50     string[5] private stateNames = ["BEFORE_START",  "PRESALE_RUNNING", "WITHDRAWAL_RUNNING", "REFUND_RUNNING", "CLOSED" ];
51     enum State { BEFORE_START,  PRESALE_RUNNING, WITHDRAWAL_RUNNING, REFUND_RUNNING, CLOSED }
52 
53     uint public total_received_amount;
54     mapping (address => uint) public balances;
55 
56     uint private constant MIN_TOTAL_AMOUNT_TO_RECEIVE = MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
57     uint private constant MAX_TOTAL_AMOUNT_TO_RECEIVE = MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
58     uint private constant MIN_ACCEPTED_AMOUNT = MIN_ACCEPTED_AMOUNT_FINNEY * 1 finney;
59     bool public isAborted = false;
60 
61 
62     //constructor
63     function Presale () validSetupOnly() { }
64 
65     //
66     // ======= interface methods =======
67     //
68 
69     //accept payments here
70     function ()
71     payable
72     noReentrancy
73     {
74         State state = currentState();
75         if (state == State.PRESALE_RUNNING) {
76             receiveFunds();
77         } else if (state == State.REFUND_RUNNING) {
78             // any entring call in Refund Phase will cause full refund
79             sendRefund();
80         } else {
81             throw;
82         }
83     }
84 
85     function refund() external
86     inState(State.REFUND_RUNNING)
87     noReentrancy
88     {
89         sendRefund();
90     }
91 
92 
93     function withdrawFunds() external
94     inState(State.WITHDRAWAL_RUNNING)
95     onlyOwner
96     noReentrancy
97     {
98         // transfer funds to owner if any
99         if (!OWNER.send(this.balance)) throw;
100     }
101 
102     function abort() external
103     inStateBefore(State.REFUND_RUNNING)
104     onlyOwner
105     {
106         isAborted = true;
107     }
108 
109     //displays current contract state in human readable form
110     function state()  external constant
111     returns (string)
112     {
113         return stateNames[ uint(currentState()) ];
114     }
115 
116 
117     //
118     // ======= implementation methods =======
119     //
120 
121     function sendRefund() private tokenHoldersOnly {
122         // load balance to refund plus amount currently sent
123         var amount_to_refund = balances[msg.sender] + msg.value;
124         // reset balance
125         balances[msg.sender] = 0;
126         // send refund back to sender
127         if (!msg.sender.send(amount_to_refund)) throw;
128     }
129 
130 
131     function receiveFunds() private notTooSmallAmountOnly {
132       // no overflow is possible here: nobody have soo much money to spend.
133       if (total_received_amount + msg.value > MAX_TOTAL_AMOUNT_TO_RECEIVE) {
134           // accept amount only and return change
135           var change_to_return = total_received_amount + msg.value - MAX_TOTAL_AMOUNT_TO_RECEIVE;
136           if (!msg.sender.send(change_to_return)) throw;
137 
138           var acceptable_remainder = MAX_TOTAL_AMOUNT_TO_RECEIVE - total_received_amount;
139           balances[msg.sender] += acceptable_remainder;
140           total_received_amount += acceptable_remainder;
141       } else {
142           // accept full amount
143           balances[msg.sender] += msg.value;
144           total_received_amount += msg.value;
145       }
146     }
147 
148 
149     function currentState() private constant returns (State) {
150         if (isAborted) {
151             return this.balance > 0 
152                    ? State.REFUND_RUNNING 
153                    : State.CLOSED;
154         } else if (block.number < PRESALE_START) {
155             return State.BEFORE_START;
156         } else if (block.number <= PRESALE_END && total_received_amount < MAX_TOTAL_AMOUNT_TO_RECEIVE) {
157             return State.PRESALE_RUNNING;
158         } else if (this.balance == 0) {
159             return State.CLOSED;
160         } else if (block.number <= WITHDRAWAL_END && total_received_amount >= MIN_TOTAL_AMOUNT_TO_RECEIVE) {
161             return State.WITHDRAWAL_RUNNING;
162         } else {
163             return State.REFUND_RUNNING;
164         } 
165     }
166 
167     //
168     // ============ modifiers ============
169     //
170 
171     //fails if state dosn't match
172     modifier inState(State state) {
173         if (state != currentState()) throw;
174         _;
175     }
176 
177     //fails if the current state is not before than the given one.
178     modifier inStateBefore(State state) {
179         if (currentState() >= state) throw;
180         _;
181     }
182 
183     //fails if something in setup is looking weird
184     modifier validSetupOnly() {
185         if ( OWNER == 0x0 
186             || PRESALE_START == 0 
187             || PRESALE_END == 0 
188             || WITHDRAWAL_END ==0
189             || PRESALE_START <= block.number
190             || PRESALE_START >= PRESALE_END
191             || PRESALE_END   >= WITHDRAWAL_END
192             || MIN_TOTAL_AMOUNT_TO_RECEIVE > MAX_TOTAL_AMOUNT_TO_RECEIVE )
193                 throw;
194         _;
195     }
196 
197 
198     //accepts calls from owner only
199     modifier onlyOwner(){
200         if (msg.sender != OWNER)  throw;
201         _;
202     }
203 
204 
205     //accepts calls from token holders only
206     modifier tokenHoldersOnly(){
207         if (balances[msg.sender] == 0) throw;
208         _;
209     }
210 
211 
212     // don`t accept transactions with value less than allowed minimum
213     modifier notTooSmallAmountOnly(){	
214         if (msg.value < MIN_ACCEPTED_AMOUNT) throw;
215         _;
216     }
217 
218 
219     //prevents reentrancy attacs
220     bool private locked = false;
221     modifier noReentrancy() {
222         if (locked) throw;
223         locked = true;
224         _;
225         locked = false;
226     }
227 }//contract