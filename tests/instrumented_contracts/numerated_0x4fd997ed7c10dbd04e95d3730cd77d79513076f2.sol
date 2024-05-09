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
34     string public constant VERSION = "0.1.4";
35 
36     /* ====== configuration START ====== */
37     uint public constant PRESALE_START  = 3172723; /* approx. 12.02.2017 23:50 */
38     uint public constant PRESALE_END    = 3302366; /* approx. 06.03.2017 00:00 */
39     uint public constant WITHDRAWAL_END = 3678823; /* approx. 06.05.2017 00:00 */
40 
41     address public constant OWNER = 0xE76fE52a251C8F3a5dcD657E47A6C8D16Fdf4bFA;
42 
43     uint public constant MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH = 4000;
44     uint public constant MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH = 12000;
45     uint public constant MIN_ACCEPTED_AMOUNT_FINNEY = 1;
46 
47     /* ====== configuration END ====== */
48 
49     string[5] private stateNames = ["BEFORE_START",  "PRESALE_RUNNING", "WITHDRAWAL_RUNNING", "REFUND_RUNNING", "CLOSED" ];
50     enum State { BEFORE_START,  PRESALE_RUNNING, WITHDRAWAL_RUNNING, REFUND_RUNNING, CLOSED }
51 
52     uint public total_received_amount;
53     mapping (address => uint) public balances;
54 
55     uint private constant MIN_TOTAL_AMOUNT_TO_RECEIVE = MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
56     uint private constant MAX_TOTAL_AMOUNT_TO_RECEIVE = MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
57     uint private constant MIN_ACCEPTED_AMOUNT = MIN_ACCEPTED_AMOUNT_FINNEY * 1 finney;
58     bool public isAborted = false;
59 
60 
61     //constructor
62     function Presale () validSetupOnly() { }
63 
64     //
65     // ======= interface methods =======
66     //
67 
68     //accept payments here
69     function ()
70     payable
71     noReentrancy
72     {
73         State state = currentState();
74         if (state == State.PRESALE_RUNNING) {
75             receiveFunds();
76         } else if (state == State.REFUND_RUNNING) {
77             // any entring call in Refund Phase will cause full refund
78             sendRefund();
79         } else {
80             throw;
81         }
82     }
83 
84     function refund() external
85     inState(State.REFUND_RUNNING)
86     noReentrancy
87     {
88         sendRefund();
89     }
90 
91 
92     function withdrawFunds() external
93     inState(State.WITHDRAWAL_RUNNING)
94     onlyOwner
95     noReentrancy
96     {
97         // transfer funds to owner if any
98         if (!OWNER.send(this.balance)) throw;
99     }
100 
101     function abort() external
102     inStateBefore(State.REFUND_RUNNING)
103     onlyOwner
104     {
105         isAborted = true;
106     }
107 
108     //displays current contract state in human readable form
109     function state()  external constant
110     returns (string)
111     {
112         return stateNames[ uint(currentState()) ];
113     }
114 
115 
116     //
117     // ======= implementation methods =======
118     //
119 
120     function sendRefund() private tokenHoldersOnly {
121         // load balance to refund plus amount currently sent
122         var amount_to_refund = balances[msg.sender] + msg.value;
123         // reset balance
124         balances[msg.sender] = 0;
125         // send refund back to sender
126         if (!msg.sender.send(amount_to_refund)) throw;
127     }
128 
129 
130     function receiveFunds() private notTooSmallAmountOnly {
131       // no overflow is possible here: nobody have soo much money to spend.
132       if (total_received_amount + msg.value > MAX_TOTAL_AMOUNT_TO_RECEIVE) {
133           // accept amount only and return change
134           var change_to_return = total_received_amount + msg.value - MAX_TOTAL_AMOUNT_TO_RECEIVE;
135           if (!msg.sender.send(change_to_return)) throw;
136 
137           var acceptable_remainder = MAX_TOTAL_AMOUNT_TO_RECEIVE - total_received_amount;
138           balances[msg.sender] += acceptable_remainder;
139           total_received_amount += acceptable_remainder;
140       } else {
141           // accept full amount
142           balances[msg.sender] += msg.value;
143           total_received_amount += msg.value;
144       }
145     }
146 
147 
148     function currentState() private constant returns (State) {
149         if (isAborted) {
150             return this.balance > 0 
151                    ? State.REFUND_RUNNING 
152                    : State.CLOSED;
153         } else if (block.number < PRESALE_START) {
154             return State.BEFORE_START;
155         } else if (block.number <= PRESALE_END && total_received_amount < MAX_TOTAL_AMOUNT_TO_RECEIVE) {
156             return State.PRESALE_RUNNING;
157         } else if (this.balance == 0) {
158             return State.CLOSED;
159         } else if (block.number <= WITHDRAWAL_END && total_received_amount >= MIN_TOTAL_AMOUNT_TO_RECEIVE) {
160             return State.WITHDRAWAL_RUNNING;
161         } else {
162             return State.REFUND_RUNNING;
163         } 
164     }
165 
166     //
167     // ============ modifiers ============
168     //
169 
170     //fails if state dosn't match
171     modifier inState(State state) {
172         if (state != currentState()) throw;
173         _;
174     }
175 
176     //fails if the current state is not before than the given one.
177     modifier inStateBefore(State state) {
178         if (currentState() >= state) throw;
179         _;
180     }
181 
182     //fails if something in setup is looking weird
183     modifier validSetupOnly() {
184         if ( OWNER == 0x0 
185             || PRESALE_START == 0 
186             || PRESALE_END == 0 
187             || WITHDRAWAL_END ==0
188             || PRESALE_START <= block.number
189             || PRESALE_START >= PRESALE_END
190             || PRESALE_END   >= WITHDRAWAL_END
191             || MIN_TOTAL_AMOUNT_TO_RECEIVE > MAX_TOTAL_AMOUNT_TO_RECEIVE )
192                 throw;
193         _;
194     }
195 
196 
197     //accepts calls from owner only
198     modifier onlyOwner(){
199         if (msg.sender != OWNER)  throw;
200         _;
201     }
202 
203 
204     //accepts calls from token holders only
205     modifier tokenHoldersOnly(){
206         if (balances[msg.sender] == 0) throw;
207         _;
208     }
209 
210 
211     // don`t accept transactions with value less than allowed minimum
212     modifier notTooSmallAmountOnly(){	
213         if (msg.value < MIN_ACCEPTED_AMOUNT) throw;
214         _;
215     }
216 
217 
218     //prevents reentrancy attacs
219     bool private locked = false;
220     modifier noReentrancy() {
221         if (locked) throw;
222         locked = true;
223         _;
224         locked = false;
225     }
226 }//contract