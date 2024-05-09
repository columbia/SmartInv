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
27 	uint public constant PRESALE_START  = 3071952; //	approx. 	27.01.2017 08:30
28 	uint public constant PRESALE_END    = 3074472; //	approx. 	27.01.2017 19:00
29 	uint public constant WITHDRAWAL_END = 3080232; //	approx. 	28.01.2017 19:00
30 
31 
32 	address public constant OWNER = 0x45d5426471D12b21C3326dD0cF96f6656F7d14b1;
33 	
34     uint public constant MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH = 1;
35     uint public constant MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH = 5;
36     uint public constant MIN_ACCEPTED_AMOUNT_FINNEY = 1;
37 
38     /* ====== configuration END ====== */
39 	
40     string[5] private stateNames = ["BEFORE_START",  "PRESALE_RUNNING", "WITHDRAWAL_RUNNING", "REFUND_RUNNING", "CLOSED" ];
41     enum State { BEFORE_START,  PRESALE_RUNNING, WITHDRAWAL_RUNNING, REFUND_RUNNING, CLOSED }
42 
43     uint public total_received_amount;
44 	mapping (address => uint) public balances;
45 	
46     uint private constant MIN_TOTAL_AMOUNT_TO_RECEIVE = MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
47     uint private constant MAX_TOTAL_AMOUNT_TO_RECEIVE = MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
48     uint private constant MIN_ACCEPTED_AMOUNT = MIN_ACCEPTED_AMOUNT_FINNEY * 1 finney;
49 	
50 
51     //constructor
52     function Presale () validSetupOnly() { }
53 
54     //
55     // ======= interface methods =======
56     //
57 
58     //accept payments here
59     function ()
60     payable
61     noReentrancy
62     {
63         State state = currentState();
64         if (state == State.PRESALE_RUNNING) {
65             receiveFunds();
66         } else if (state == State.REFUND_RUNNING) {
67             // any entring call in Refund Phase will cause full refund
68             sendRefund();
69         } else {
70             throw;
71         }
72     }
73 
74     function refund() external
75     inState(State.REFUND_RUNNING)
76     noReentrancy
77     {
78         sendRefund();
79     }
80 
81 
82     function withdrawFunds() external
83     inState(State.WITHDRAWAL_RUNNING)
84     onlyOwner
85     noReentrancy
86     {
87         // transfer funds to owner if any
88         if (this.balance > 0) {
89             if (!OWNER.send(this.balance)) throw;
90         }
91     }
92 
93 
94     //displays current contract state in human readable form
95     function state()  external constant
96     returns (string)
97     {
98         return stateNames[ uint(currentState()) ];
99     }
100 
101 
102     //
103     // ======= implementation methods =======
104     //
105 
106     function sendRefund() private tokenHoldersOnly {
107         // load balance to refund plus amount currently sent
108         var amount_to_refund = balances[msg.sender] + msg.value;
109         // reset balance
110         balances[msg.sender] = 0;
111         // send refund back to sender
112         if (!msg.sender.send(amount_to_refund)) throw;
113     }
114 
115 
116     function receiveFunds() private notTooSmallAmountOnly {
117       // no overflow is possible here: nobody have soo much money to spend.
118       if (total_received_amount + msg.value > MAX_TOTAL_AMOUNT_TO_RECEIVE) {
119           // accept amount only and return change
120           var change_to_return = total_received_amount + msg.value - MAX_TOTAL_AMOUNT_TO_RECEIVE;
121           if (!msg.sender.send(change_to_return)) throw;
122 
123           var acceptable_remainder = MAX_TOTAL_AMOUNT_TO_RECEIVE - total_received_amount;
124           balances[msg.sender] += acceptable_remainder;
125           total_received_amount += acceptable_remainder;
126       } else {
127           // accept full amount
128           balances[msg.sender] += msg.value;
129           total_received_amount += msg.value;
130       }
131     }
132 
133 
134     function currentState() private constant returns (State) {
135         if (block.number < PRESALE_START) {
136             return State.BEFORE_START;
137         } else if (block.number <= PRESALE_END && total_received_amount < MAX_TOTAL_AMOUNT_TO_RECEIVE) {
138             return State.PRESALE_RUNNING;
139         } else if (block.number <= WITHDRAWAL_END && total_received_amount >= MIN_TOTAL_AMOUNT_TO_RECEIVE) {
140             return State.WITHDRAWAL_RUNNING;
141         } else if (this.balance > 0){
142             return State.REFUND_RUNNING;
143         } else {
144             return State.CLOSED;		
145 		} 
146     }
147 
148     //
149     // ============ modifiers ============
150     //
151 
152     //fails if state dosn't match
153     modifier inState(State state) {
154         if (state != currentState()) throw;
155         _;
156     }
157 
158 
159     //fails if something in setup is looking weird
160     modifier validSetupOnly() {
161         if ( OWNER == 0x0 
162             || PRESALE_START == 0 
163             || PRESALE_END == 0 
164             || WITHDRAWAL_END ==0
165             || PRESALE_START <= block.number
166             || PRESALE_START >= PRESALE_END
167             || PRESALE_END   >= WITHDRAWAL_END
168             || MIN_TOTAL_AMOUNT_TO_RECEIVE > MAX_TOTAL_AMOUNT_TO_RECEIVE )
169 				throw;
170         _;
171     }
172 
173 
174     //accepts calls from owner only
175     modifier onlyOwner(){
176     	if (msg.sender != OWNER)  throw;
177     	_;
178     }
179 
180 
181     //accepts calls from token holders only
182     modifier tokenHoldersOnly(){
183         if (balances[msg.sender] == 0) throw;
184         _;
185     }
186 
187 
188     // don`t accept transactions with value less than allowed minimum
189     modifier notTooSmallAmountOnly(){	
190         if (msg.value < MIN_ACCEPTED_AMOUNT) throw;
191         _;
192     }
193 
194 
195     //prevents reentrancy attacs
196     bool private locked = false;
197     modifier noReentrancy() {
198         if (locked) throw;
199         locked = true;
200         _;
201         locked = false;
202     }
203 }//contract