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
21 
22 contract Presale {
23 
24     string public constant VERSION = "0.1.3-beta";
25 
26 	/* ====== configuration START ====== */
27 
28 	uint public constant PRESALE_START  = 3116646; //	approx. 	03.02.2017 18:50
29 	uint public constant PRESALE_END    = 3116686; //	approx. 	03.02.2017 19:00
30 	uint public constant WITHDRAWAL_END = 3116726; //	approx. 	03.02.2017 19:10
31 
32 
33 	address public constant OWNER = 0xA4769870EB607A4fDaBFfbcC3AD066c8213bD87D;
34 	
35     uint public constant MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH = 1;
36     uint public constant MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH = 5;
37     uint public constant MIN_ACCEPTED_AMOUNT_FINNEY = 1;
38 
39     /* ====== configuration END ====== */
40 	
41     string[5] private stateNames = ["BEFORE_START",  "PRESALE_RUNNING", "WITHDRAWAL_RUNNING", "REFUND_RUNNING", "CLOSED" ];
42     enum State { BEFORE_START,  PRESALE_RUNNING, WITHDRAWAL_RUNNING, REFUND_RUNNING, CLOSED }
43 
44     uint public total_received_amount;
45 	mapping (address => uint) public balances;
46 	
47     uint private constant MIN_TOTAL_AMOUNT_TO_RECEIVE = MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
48     uint private constant MAX_TOTAL_AMOUNT_TO_RECEIVE = MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
49     uint private constant MIN_ACCEPTED_AMOUNT = MIN_ACCEPTED_AMOUNT_FINNEY * 1 finney;
50 	
51 
52     //constructor
53     function Presale () validSetupOnly() { }
54 
55     //
56     // ======= interface methods =======
57     //
58 
59     //accept payments here
60     function ()
61     payable
62     noReentrancy
63     {
64         State state = currentState();
65         if (state == State.PRESALE_RUNNING) {
66             receiveFunds();
67         } else if (state == State.REFUND_RUNNING) {
68             // any entring call in Refund Phase will cause full refund
69             sendRefund();
70         } else {
71             throw;
72         }
73     }
74 
75     function refund() external
76     inState(State.REFUND_RUNNING)
77     noReentrancy
78     {
79         sendRefund();
80     }
81 
82 
83     function withdrawFunds() external
84     inState(State.WITHDRAWAL_RUNNING)
85     onlyOwner
86     noReentrancy
87     {
88         // transfer funds to owner if any
89         if (this.balance > 0) {
90             if (!OWNER.send(this.balance)) throw;
91         }
92     }
93 
94 
95     //displays current contract state in human readable form
96     function state()  external constant
97     returns (string)
98     {
99         return stateNames[ uint(currentState()) ];
100     }
101 
102 
103     //
104     // ======= implementation methods =======
105     //
106 
107     function sendRefund() private tokenHoldersOnly {
108         // load balance to refund plus amount currently sent
109         var amount_to_refund = balances[msg.sender] + msg.value;
110         // reset balance
111         balances[msg.sender] = 0;
112         // send refund back to sender
113         if (!msg.sender.send(amount_to_refund)) throw;
114     }
115 
116 
117     function receiveFunds() private notTooSmallAmountOnly {
118       // no overflow is possible here: nobody have soo much money to spend.
119       if (total_received_amount + msg.value > MAX_TOTAL_AMOUNT_TO_RECEIVE) {
120           // accept amount only and return change
121           var change_to_return = total_received_amount + msg.value - MAX_TOTAL_AMOUNT_TO_RECEIVE;
122           if (!msg.sender.send(change_to_return)) throw;
123 
124           var acceptable_remainder = MAX_TOTAL_AMOUNT_TO_RECEIVE - total_received_amount;
125           balances[msg.sender] += acceptable_remainder;
126           total_received_amount += acceptable_remainder;
127       } else {
128           // accept full amount
129           balances[msg.sender] += msg.value;
130           total_received_amount += msg.value;
131       }
132     }
133 
134 
135     function currentState() private constant returns (State) {
136         if (block.number < PRESALE_START) {
137             return State.BEFORE_START;
138         } else if (block.number <= PRESALE_END && total_received_amount < MAX_TOTAL_AMOUNT_TO_RECEIVE) {
139             return State.PRESALE_RUNNING;
140         } else if (block.number <= WITHDRAWAL_END && total_received_amount >= MIN_TOTAL_AMOUNT_TO_RECEIVE) {
141             return State.WITHDRAWAL_RUNNING;
142         } else if (this.balance > 0){
143             return State.REFUND_RUNNING;
144         } else {
145             return State.CLOSED;		
146 		} 
147     }
148 
149     //
150     // ============ modifiers ============
151     //
152 
153     //fails if state dosn't match
154     modifier inState(State state) {
155         if (state != currentState()) throw;
156         _;
157     }
158 
159 
160     //fails if something in setup is looking weird
161     modifier validSetupOnly() {
162         if ( OWNER == 0x0 
163             || PRESALE_START == 0 
164             || PRESALE_END == 0 
165             || WITHDRAWAL_END ==0
166             || PRESALE_START <= block.number
167             || PRESALE_START >= PRESALE_END
168             || PRESALE_END   >= WITHDRAWAL_END
169             || MIN_TOTAL_AMOUNT_TO_RECEIVE > MAX_TOTAL_AMOUNT_TO_RECEIVE )
170 				throw;
171         _;
172     }
173 
174 
175     //accepts calls from owner only
176     modifier onlyOwner(){
177     	if (msg.sender != OWNER)  throw;
178     	_;
179     }
180 
181 
182     //accepts calls from token holders only
183     modifier tokenHoldersOnly(){
184         if (balances[msg.sender] == 0) throw;
185         _;
186     }
187 
188 
189     // don`t accept transactions with value less than allowed minimum
190     modifier notTooSmallAmountOnly(){	
191         if (msg.value < MIN_ACCEPTED_AMOUNT) throw;
192         _;
193     }
194 
195 
196     //prevents reentrancy attacs
197     bool private locked = false;
198     modifier noReentrancy() {
199         if (locked) throw;
200         locked = true;
201         _;
202         locked = false;
203     }
204 }//contract