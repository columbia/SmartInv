1 pragma solidity ^0.4.17;
2 
3 /// @author developers //NB!
4 /// @notice support@developers //NB!
5 /// @title  Contract presale //NB!
6 
7 contract AvPresale {
8 
9     string public constant RELEASE = "0.2.1_AviaTest";
10 
11     //config// 
12     uint public constant PRESALE_START  = 5298043; /* 22.03.2018 03:07:00 +3GMT */ //NB!
13     uint public constant PRESALE_END    = 5303803; /* 23.03.2018 03:07:00 +3GMT */ //NB!
14     uint public constant WITHDRAWAL_END = 5309563; /* 24.03.2018 03:07:00 +3GMT */ //NB!
15 
16     address public constant OWNER = 0x32Bac79f4B6395DEa37f0c2B68b6e26ce24a59EA; //NB!
17 
18     uint public constant MIN_TOTAL_AMOUNT_GET_ETH = 1; //NB!
19     uint public constant MAX_TOTAL_AMOUNT_GET_ETH = 2; //NB!
20 	//min send value 0.001 ETH (1 finney)
21     uint public constant MIN_GET_AMOUNT_FINNEY = 10; //NB!
22 
23     string[5] private standingNames = ["BEFORE_START",  "PRESALE_RUNNING", "WITHDRAWAL_RUNNING", "MONEY_BACK_RUNNING", "CLOSED" ];
24     enum State { BEFORE_START,  PRESALE_RUNNING, WITHDRAWAL_RUNNING, MONEY_BACK_RUNNING, CLOSED }
25 
26     uint public total_amount = 0;
27     uint public total_money_back = 0;
28     mapping (address => uint) public balances;
29 
30     uint private constant MIN_TOTAL_AMOUNT_GET = MIN_TOTAL_AMOUNT_GET_ETH * 1 ether;
31     uint private constant MAX_TOTAL_AMOUNT_GET = MAX_TOTAL_AMOUNT_GET_ETH * 1 ether;
32     uint private constant MIN_GET_AMOUNT = MIN_GET_AMOUNT_FINNEY * 1 finney;
33     bool public isTerminated = false;
34     bool public isStopped = false;
35 
36 
37     function AvPresale () public checkSettings() { }
38 
39 
40     //methods//
41 	
42 	//The transfer of money to the owner
43     function sendMoneyOwner() external
44 	inStanding(State.WITHDRAWAL_RUNNING)
45     onlyOwner
46     noReentrancy
47     {
48         OWNER.transfer(this.balance);
49     }
50 	
51 	//Money back to users
52     function moneyBack() external
53     inStanding(State.MONEY_BACK_RUNNING)
54     noReentrancy
55     {
56         sendMoneyBack();
57     }
58 	
59     //payments
60     function ()
61     payable
62     noReentrancy
63     public
64     {
65         State state = currentStanding();
66         if (state == State.PRESALE_RUNNING) {
67             getMoney();
68         } else if (state == State.MONEY_BACK_RUNNING) {
69             sendMoneyBack();
70         } else {
71             revert();
72         }
73     }
74 
75     //Forced termination
76     function termination() external
77     inStandingBefore(State.MONEY_BACK_RUNNING)
78     onlyOwner
79     {
80         isTerminated = true;
81     }
82 
83     //Forced stop with the possibility of withdrawal
84     function stop() external
85     inStanding(State.PRESALE_RUNNING)
86     onlyOwner
87     {
88         isStopped = true;
89     }
90 
91 
92     //Current status of the contract
93     function standing() external constant
94     returns (string)
95     {
96         return standingNames[ uint(currentStanding()) ];
97     }
98 
99     //Method adding money to the user
100     function getMoney() private notTooSmallAmountOnly {
101       if (total_amount + msg.value > MAX_TOTAL_AMOUNT_GET) {
102           var change_to_return = total_amount + msg.value - MAX_TOTAL_AMOUNT_GET;
103           var acceptable_remainder = MAX_TOTAL_AMOUNT_GET - total_amount;
104           balances[msg.sender] += acceptable_remainder;
105           total_amount += acceptable_remainder;
106           msg.sender.transfer(change_to_return);
107       } else {
108           balances[msg.sender] += msg.value;
109           total_amount += msg.value;
110       }
111     }
112 	
113 	//Method of repayment users 
114     function sendMoneyBack() private tokenHoldersOnly {
115         uint amount_to_money_back = min(balances[msg.sender], this.balance - msg.value) ;
116         balances[msg.sender] -= amount_to_money_back;
117         total_money_back += amount_to_money_back;
118         msg.sender.transfer(amount_to_money_back + msg.value);
119     }
120 
121     //Determining the current status of the contract
122     function currentStanding() private constant returns (State) {
123         if (isTerminated) {
124             return this.balance > 0
125                    ? State.MONEY_BACK_RUNNING
126                    : State.CLOSED;
127         } else if (block.number < PRESALE_START) {
128             return State.BEFORE_START;
129         } else if (block.number <= PRESALE_END && total_amount < MAX_TOTAL_AMOUNT_GET && !isStopped) {
130             return State.PRESALE_RUNNING;
131         } else if (this.balance == 0) {
132             return State.CLOSED;
133         } else if (block.number <= WITHDRAWAL_END && total_amount >= MIN_TOTAL_AMOUNT_GET) {
134             return State.WITHDRAWAL_RUNNING;
135         } else {
136             return State.MONEY_BACK_RUNNING;
137         }
138     }
139 
140     function min(uint a, uint b) pure private returns (uint) {
141         return a < b ? a : b;
142     }
143 
144     //Prohibition if the condition does not match
145     modifier inStanding(State state) {
146         require(state == currentStanding());
147         _;
148     }
149 
150     //Prohibition if the current state was not before
151     modifier inStandingBefore(State state) {
152         require(currentStanding() < state);
153         _;
154     }
155 
156     //Works on users's command
157     modifier tokenHoldersOnly(){
158         require(balances[msg.sender] > 0);
159         _;
160     }
161 
162     //Do not accept transactions with a sum less than the configuration limit
163     modifier notTooSmallAmountOnly(){
164         require(msg.value >= MIN_GET_AMOUNT);
165         _;
166     }
167 
168     //Prohibition of repeated treatment
169     bool private lock = false;
170     modifier noReentrancy() {
171         require(!lock);
172         lock = true;
173         _;
174         lock = false;
175     }
176 	
177 	 //Prohibition if it does not match the settings
178     modifier checkSettings() {
179         if ( OWNER == 0x0
180             || PRESALE_START == 0
181             || PRESALE_END == 0
182             || WITHDRAWAL_END ==0
183             || PRESALE_START <= block.number
184             || PRESALE_START >= PRESALE_END
185             || PRESALE_END   >= WITHDRAWAL_END
186             || MIN_TOTAL_AMOUNT_GET > MAX_TOTAL_AMOUNT_GET )
187                 revert();
188         _;
189     }
190 	
191 	//Works on owner's command
192     modifier onlyOwner(){
193         require(msg.sender == OWNER);
194         _;
195     }
196 }