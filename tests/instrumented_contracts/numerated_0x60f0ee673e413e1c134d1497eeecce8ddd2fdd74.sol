1 pragma solidity ^0.4.6;
2 
3 // Presale Smart Contract
4 //
5 // **** START:  WORK IN PROGRESS DISCLAIMER ****
6 // This is a work in progress and not intended for reuse.
7 // So don't reuse unless you know exactly what are you doing! 
8 // **** END:  WORK IN PROGRESS DISCLAIMER ****
9 //
10 // **** START:  PARANOIA DISCLAIMER ****
11 // A careful reader will find here some unnecessary checks and excessive code consuming some extra valuable gas. It is intentionally. 
12 // Even contract will works without these parts, they make the code more secure in production as well for future refactoring.
13 // Additionally it shows more clearly what we have took care of.
14 // You are welcome to discuss that places.
15 // **** END OF: PARANOIA DISCLAIMER *****
16 //
17 //
18 // @author ethernian
19 //
20 
21 contract Presale {
22 
23     string public constant VERSION = "0.1.3-beta";
24 
25 	/* ====== configuration START ====== */
26 
27 	uint public constant PRESALE_START  = 3044895;    /* approx. 22.01.2017 21:15 CET */
28 	uint public constant PRESALE_END    = 3048975;    /* approx. 23.01.2017 14:15 CET */
29 	uint public constant WITHDRAWAL_END = 3049935;    /* approx. 23.01.2017 18:15 CET */
30 
31 	address public constant OWNER = 0x45d5426471D12b21C3326dD0cF96f6656F7d14b1;
32 	
33     uint public constant MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH = 1;
34     uint public constant MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH = 5;
35     uint public constant MIN_ACCEPTED_AMOUNT_FINNEY = 1;
36 
37     /* ====== configuration END ====== */
38 	
39     string[5] private stateNames = ["BEFORE_START",  "PRESALE_RUNNING", "WITHDRAWAL_RUNNING", "REFUND_RUNNING", "CLOSED" ];
40     enum State { BEFORE_START,  PRESALE_RUNNING, WITHDRAWAL_RUNNING, REFUND_RUNNING, CLOSED }
41 
42     uint public total_received_amount;
43 	mapping (address => uint) public balances;
44 	
45     uint private constant MIN_TOTAL_AMOUNT_TO_RECEIVE = MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
46     uint private constant MAX_TOTAL_AMOUNT_TO_RECEIVE = MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
47     uint private constant MIN_ACCEPTED_AMOUNT = MIN_ACCEPTED_AMOUNT_FINNEY * 1 finney;
48 	
49 
50     //constructor
51     function Presale () validSetupOnly() { }
52 
53     //
54     // ======= interface methods =======
55     //
56 
57     //accept payments here
58     function ()
59     payable
60     noReentrancy
61     {
62         State state = currentState();
63         if (state == State.PRESALE_RUNNING) {
64             receiveFunds();
65         } else if (state == State.REFUND_RUNNING) {
66             // any entring call in Refund Phase will cause full refund
67             sendRefund();
68         } else {
69             throw;
70         }
71     }
72 
73     function refund() external
74     inState(State.REFUND_RUNNING)
75     noReentrancy
76     {
77         sendRefund();
78     }
79 
80 
81     function withdrawFunds() external
82     inState(State.WITHDRAWAL_RUNNING)
83     onlyOwner
84     noReentrancy
85     {
86         // transfer funds to owner if any
87         if (this.balance > 0) {
88             if (!OWNER.send(this.balance)) throw;
89         }
90     }
91 
92 
93     //displays current contract state in human readable form
94     function state()  external constant
95     returns (string)
96     {
97         return stateNames[ uint(currentState()) ];
98     }
99 
100 
101     //
102     // ======= implementation methods =======
103     //
104 
105     function sendRefund() private tokenHoldersOnly {
106         // load balance to refund plus amount currently sent
107         var amount_to_refund = balances[msg.sender] + msg.value;
108         // reset balance
109         balances[msg.sender] = 0;
110         // send refund back to sender
111         if (!msg.sender.send(amount_to_refund)) throw;
112     }
113 
114 
115     function receiveFunds() private notTooSmallAmountOnly {
116       // no overflow is possible here: nobody have soo much money to spend.
117       if (total_received_amount + msg.value > MAX_TOTAL_AMOUNT_TO_RECEIVE) {
118           // accept amount only and return change
119           var change_to_return = total_received_amount + msg.value - MAX_TOTAL_AMOUNT_TO_RECEIVE;
120           if (!msg.sender.send(change_to_return)) throw;
121 
122           var acceptable_remainder = MAX_TOTAL_AMOUNT_TO_RECEIVE - total_received_amount;
123           balances[msg.sender] += acceptable_remainder;
124           total_received_amount += acceptable_remainder;
125       } else {
126           // accept full amount
127           balances[msg.sender] += msg.value;
128           total_received_amount += msg.value;
129       }
130     }
131 
132 
133     function currentState() private constant returns (State) {
134         if (block.number < PRESALE_START) {
135             return State.BEFORE_START;
136         } else if (block.number <= PRESALE_END && total_received_amount < MAX_TOTAL_AMOUNT_TO_RECEIVE) {
137             return State.PRESALE_RUNNING;
138         } else if (block.number <= WITHDRAWAL_END && total_received_amount >= MIN_TOTAL_AMOUNT_TO_RECEIVE) {
139             return State.WITHDRAWAL_RUNNING;
140         } else if (this.balance > 0){
141             return State.REFUND_RUNNING;
142         } else {
143             return State.CLOSED;		
144 		} 
145     }
146 
147     //
148     // ============ modifiers ============
149     //
150 
151     //fails if state dosn't match
152     modifier inState(State state) {
153         if (state != currentState()) throw;
154         _;
155     }
156 
157 
158     //fails if something in setup is looking weird
159     modifier validSetupOnly() {
160         if ( OWNER == 0x0 
161             || PRESALE_START == 0 
162             || PRESALE_END == 0 
163             || WITHDRAWAL_END ==0
164             || PRESALE_START <= block.number
165             || PRESALE_START >= PRESALE_END
166             || PRESALE_END   >= WITHDRAWAL_END
167             || MIN_TOTAL_AMOUNT_TO_RECEIVE > MAX_TOTAL_AMOUNT_TO_RECEIVE )
168 				throw;
169         _;
170     }
171 
172 
173     //accepts calls from owner only
174     modifier onlyOwner(){
175     	if (msg.sender != OWNER)  throw;
176     	_;
177     }
178 
179 
180     //accepts calls from token holders only
181     modifier tokenHoldersOnly(){
182         if (balances[msg.sender] == 0) throw;
183         _;
184     }
185 
186 
187     // don`t accept transactions with value less than allowed minimum
188     modifier notTooSmallAmountOnly(){	
189         if (msg.value < MIN_ACCEPTED_AMOUNT) throw;
190         _;
191     }
192 
193 
194     //prevents reentrancy attacs
195     bool private locked = false;
196     modifier noReentrancy() {
197         if (locked) throw;
198         locked = true;
199         _;
200         locked = false;
201     }
202 }//contract