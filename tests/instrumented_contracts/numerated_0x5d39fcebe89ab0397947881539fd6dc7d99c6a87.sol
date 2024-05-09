1 pragma solidity ^0.4.6;
2 
3 // Presale Smart Contract
4 //
5 // **** START:  PARANOIA DISCLAIMER ****
6 // A carefull reader will find here some unnecessary checks and excessive code consuming some extra valueable gas. It is intentionally. 
7 // Even contract will works without these parts, they make the code more secure in production as well for future refactorings.
8 // Additionally it shows more clearly what we have took care of.
9 // You are welcome to discuss that places.
10 // **** END OF: PARANOIA DISCLAIMER *****
11 //
12 // @author ethernian
13 //
14 
15 contract Presale {
16 
17 	function cleanUp() onlyOwner {
18 		selfdestruct(OWNER);
19 	}
20 
21     string public constant VERSION = "0.1.3-[min1,max5]";
22 
23 	/* ====== configuration START ====== */
24     uint public constant MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH = 1;
25     uint public constant MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH = 5;
26     uint public constant MIN_ACCEPTED_AMOUNT_FINNEY = 1;
27 	uint public constant PRESALE_START = 3044444;
28 	uint public constant PRESALE_END = 3044555;
29 	uint public constant WITHDRAWAL_END = 3044666;
30 	address public constant OWNER = 0xF55DFd2B02Cf3282680C94BD01E9Da044044E6A2;
31     /* ====== configuration END ====== */
32 	
33     string[5] private stateNames = ["BEFORE_START",  "PRESALE_RUNNING", "WITHDRAWAL_RUNNING", "REFUND_RUNNING", "CLOSED" ];
34     enum State { BEFORE_START,  PRESALE_RUNNING, WITHDRAWAL_RUNNING, REFUND_RUNNING, CLOSED }
35 
36     uint public total_received_amount;
37 	mapping (address => uint) public balances;
38 	
39     uint private constant MIN_TOTAL_AMOUNT_TO_RECEIVE = MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
40     uint private constant MAX_TOTAL_AMOUNT_TO_RECEIVE = MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;
41     uint private constant MIN_ACCEPTED_AMOUNT = MIN_ACCEPTED_AMOUNT_FINNEY * 1 finney;
42 	
43 
44     //constructor
45     function Presale () validSetupOnly() { }
46 
47     //
48     // ======= interface methods =======
49     //
50 
51     //accept payments here
52     function ()
53     payable
54     noReentrancy
55     {
56         State state = currentState();
57         if (state == State.PRESALE_RUNNING) {
58             receiveFunds();
59         } else if (state == State.REFUND_RUNNING) {
60             // any entring call in Refund Phase will cause full refund
61             sendRefund();
62         } else {
63             throw;
64         }
65     }
66 
67     function refund() external
68     inState(State.REFUND_RUNNING)
69     noReentrancy
70     {
71         sendRefund();
72     }
73 
74 
75     function withdrawFunds() external
76     inState(State.WITHDRAWAL_RUNNING)
77     onlyOwner
78     noReentrancy
79     {
80         // transfer funds to owner if any
81         if (this.balance > 0) {
82             if (!OWNER.send(this.balance)) throw;
83         }
84     }
85 
86 
87     //displays current contract state in human readable form
88     function state()  external constant
89     returns (string)
90     {
91         return stateNames[ uint(currentState()) ];
92     }
93 
94 
95     //
96     // ======= implementation methods =======
97     //
98 
99     function sendRefund() private tokenHoldersOnly {
100         // load balance to refund plus amount currently sent
101         var amount_to_refund = balances[msg.sender] + msg.value;
102         // reset balance
103         balances[msg.sender] = 0;
104         // send refund back to sender
105         if (!msg.sender.send(amount_to_refund)) throw;
106     }
107 
108 
109     function receiveFunds() private notTooSmallAmountOnly {
110       // no overflow is possible here: nobody have soo much money to spend.
111       if (total_received_amount + msg.value > MAX_TOTAL_AMOUNT_TO_RECEIVE) {
112           // accept amount only and return change
113           var change_to_return = total_received_amount + msg.value - MAX_TOTAL_AMOUNT_TO_RECEIVE;
114           if (!msg.sender.send(change_to_return)) throw;
115 
116           var acceptable_remainder = MAX_TOTAL_AMOUNT_TO_RECEIVE - total_received_amount;
117           balances[msg.sender] += acceptable_remainder;
118           total_received_amount += acceptable_remainder;
119       } else {
120           // accept full amount
121           balances[msg.sender] += msg.value;
122           total_received_amount += msg.value;
123       }
124     }
125 
126 
127     function currentState() private constant returns (State) {
128         if (block.number < PRESALE_START) {
129             return State.BEFORE_START;
130         } else if (block.number <= PRESALE_END && total_received_amount < MAX_TOTAL_AMOUNT_TO_RECEIVE) {
131             return State.PRESALE_RUNNING;
132         } else if (block.number <= WITHDRAWAL_END && total_received_amount >= MIN_TOTAL_AMOUNT_TO_RECEIVE) {
133             return State.WITHDRAWAL_RUNNING;
134         } else if (this.balance > 0){
135             return State.REFUND_RUNNING;
136         } else {
137             return State.CLOSED;		
138 		} 
139     }
140 
141     //
142     // ============ modifiers ============
143     //
144 
145     //fails if state dosn't match
146     modifier inState(State state) {
147         if (state != currentState()) throw;
148         _;
149     }
150 
151 
152     //fails if something in setup is looking weird
153     modifier validSetupOnly() {
154         if ( OWNER == 0x0 
155             || PRESALE_START == 0 
156             || PRESALE_END == 0 
157             || WITHDRAWAL_END ==0
158             || PRESALE_START <= block.number
159             || PRESALE_START >= PRESALE_END
160             || PRESALE_END   >= WITHDRAWAL_END
161             || MIN_TOTAL_AMOUNT_TO_RECEIVE > MAX_TOTAL_AMOUNT_TO_RECEIVE )
162 				throw;
163         _;
164     }
165 
166 
167     //accepts calls from owner only
168     modifier onlyOwner(){
169     	if (msg.sender != OWNER)  throw;
170     	_;
171     }
172 
173 
174     //accepts calls from token holders only
175     modifier tokenHoldersOnly(){
176         if (balances[msg.sender] == 0) throw;
177         _;
178     }
179 
180 
181     // don`t accept transactions with value less than allowed minimum
182     modifier notTooSmallAmountOnly(){	
183         if (msg.value < MIN_ACCEPTED_AMOUNT) throw;
184         _;
185     }
186 
187 
188     //prevents reentrancy attacs
189     bool private locked = false;
190     modifier noReentrancy() {
191         if (locked) throw;
192         locked = true;
193         _;
194         locked = false;
195     }
196 }//contract