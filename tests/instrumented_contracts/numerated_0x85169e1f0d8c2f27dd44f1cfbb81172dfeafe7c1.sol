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
37 
38     uint public constant PRESALE_START  = 3142163; /* approx. 08.02.2017 00:00 */
39     uint public constant PRESALE_END    = 3145693; /* approx. 08.02.2017 23:59 */
40     uint public constant WITHDRAWAL_END = 3151453; /* approx. 09.02.2017 23:59 */
41 
42 
43     address public constant OWNER = 0x45d5426471D12b21C3326dD0cF96f6656F7d14b1;
44 
45     uint public constant MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH = 1;
46     uint public constant MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH = 5;
47     uint public constant MIN_ACCEPTED_AMOUNT_FINNEY = 1;
48 
49     /* ====== configuration END ====== */
50 
51     string[5] private stateNames = ["BEFORE_START",  "PRESALE_RUNNING", "WITHDRAWAL_RUNNING", "REFUND_RUNNING", "CLOSED" ];
52     enum State { BEFORE_START,  PRESALE_RUNNING, WITHDRAWAL_RUNNING, REFUND_RUNNING, CLOSED }
53 
54     uint public total_received_amount;
55     mapping (address => uint) public balances;
56 
57     uint private constant MIN_TOTAL_AMOUNT_TO_RECEIVE = MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
58     uint private constant MAX_TOTAL_AMOUNT_TO_RECEIVE = MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
59     uint private constant MIN_ACCEPTED_AMOUNT = MIN_ACCEPTED_AMOUNT_FINNEY * 1 finney;
60     bool public isAborted = false;
61 
62 
63     //constructor
64     function Presale () validSetupOnly() { }
65 
66     //
67     // ======= interface methods =======
68     //
69 
70     //accept payments here
71     function ()
72     payable
73     noReentrancy
74     {
75         State state = currentState();
76         if (state == State.PRESALE_RUNNING) {
77             receiveFunds();
78         } else if (state == State.REFUND_RUNNING) {
79             // any entring call in Refund Phase will cause full refund
80             sendRefund();
81         } else {
82             throw;
83         }
84     }
85 
86     function refund() external
87     inState(State.REFUND_RUNNING)
88     noReentrancy
89     {
90         sendRefund();
91     }
92 
93 
94     function withdrawFunds() external
95     inState(State.WITHDRAWAL_RUNNING)
96     onlyOwner
97     noReentrancy
98     {
99         // transfer funds to owner if any
100         if (!OWNER.send(this.balance)) throw;
101     }
102 
103     function abort() external
104     inStateBefore(State.REFUND_RUNNING)
105     onlyOwner
106     {
107         isAborted = true;
108     }
109 
110     //displays current contract state in human readable form
111     function state()  external constant
112     returns (string)
113     {
114         return stateNames[ uint(currentState()) ];
115     }
116 
117 
118     //
119     // ======= implementation methods =======
120     //
121 
122     function sendRefund() private tokenHoldersOnly {
123         // load balance to refund plus amount currently sent
124         var amount_to_refund = balances[msg.sender] + msg.value;
125         // reset balance
126         balances[msg.sender] = 0;
127         // send refund back to sender
128         if (!msg.sender.send(amount_to_refund)) throw;
129     }
130 
131 
132     function receiveFunds() private notTooSmallAmountOnly {
133       // no overflow is possible here: nobody have soo much money to spend.
134       if (total_received_amount + msg.value > MAX_TOTAL_AMOUNT_TO_RECEIVE) {
135           // accept amount only and return change
136           var change_to_return = total_received_amount + msg.value - MAX_TOTAL_AMOUNT_TO_RECEIVE;
137           if (!msg.sender.send(change_to_return)) throw;
138 
139           var acceptable_remainder = MAX_TOTAL_AMOUNT_TO_RECEIVE - total_received_amount;
140           balances[msg.sender] += acceptable_remainder;
141           total_received_amount += acceptable_remainder;
142       } else {
143           // accept full amount
144           balances[msg.sender] += msg.value;
145           total_received_amount += msg.value;
146       }
147     }
148 
149 
150     function currentState() private constant returns (State) {
151         if (isAborted) {
152             return this.balance > 0 
153                    ? State.REFUND_RUNNING 
154                    : State.CLOSED;
155         } else if (block.number < PRESALE_START) {
156             return State.BEFORE_START;
157         } else if (block.number <= PRESALE_END && total_received_amount < MAX_TOTAL_AMOUNT_TO_RECEIVE) {
158             return State.PRESALE_RUNNING;
159         } else if (this.balance == 0) {
160             return State.CLOSED;
161         } else if (block.number <= WITHDRAWAL_END && total_received_amount >= MIN_TOTAL_AMOUNT_TO_RECEIVE) {
162             return State.WITHDRAWAL_RUNNING;
163         } else {
164             return State.REFUND_RUNNING;
165         } 
166     }
167 
168     //
169     // ============ modifiers ============
170     //
171 
172     //fails if state dosn't match
173     modifier inState(State state) {
174         if (state != currentState()) throw;
175         _;
176     }
177 
178     //fails if the current state is not before than the given one.
179     modifier inStateBefore(State state) {
180         if (currentState() >= state) throw;
181         _;
182     }
183 
184     //fails if something in setup is looking weird
185     modifier validSetupOnly() {
186         if ( OWNER == 0x0 
187             || PRESALE_START == 0 
188             || PRESALE_END == 0 
189             || WITHDRAWAL_END ==0
190             || PRESALE_START <= block.number
191             || PRESALE_START >= PRESALE_END
192             || PRESALE_END   >= WITHDRAWAL_END
193             || MIN_TOTAL_AMOUNT_TO_RECEIVE > MAX_TOTAL_AMOUNT_TO_RECEIVE )
194                 throw;
195         _;
196     }
197 
198 
199     //accepts calls from owner only
200     modifier onlyOwner(){
201         if (msg.sender != OWNER)  throw;
202         _;
203     }
204 
205 
206     //accepts calls from token holders only
207     modifier tokenHoldersOnly(){
208         if (balances[msg.sender] == 0) throw;
209         _;
210     }
211 
212 
213     // don`t accept transactions with value less than allowed minimum
214     modifier notTooSmallAmountOnly(){	
215         if (msg.value < MIN_ACCEPTED_AMOUNT) throw;
216         _;
217     }
218 
219 
220     //prevents reentrancy attacs
221     bool private locked = false;
222     modifier noReentrancy() {
223         if (locked) throw;
224         locked = true;
225         _;
226         locked = false;
227     }
228 }//contract