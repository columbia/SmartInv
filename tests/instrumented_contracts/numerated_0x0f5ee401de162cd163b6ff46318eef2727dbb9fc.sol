1 pragma solidity ^0.4.11;
2 /*
3 Moira ICO Contract
4 
5 MOI is an ERC-20 Token Standar Compliant
6 
7 Contract developer: Fares A. Akel C.
8 f.antonio.akel@gmail.com
9 MIT PGP KEY ID: 078E41CB
10 */
11 
12 /**
13  * @title SafeMath by OpenZeppelin
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a * b;
20         assert(a == 0 || c / a == b);
21         return c;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 contract token { //Token functions definition
32 
33     function balanceOf(address _owner) public constant returns (uint256 balance);
34     function transfer(address _to, uint256 _value) public returns (bool success);
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
36     function approve(address _spender, uint256 _value) public returns (bool success);
37     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
38     }
39 contract MOIRAICO {
40     //This ico have 4 stages for 4 weeks and the Successful stage when finished
41     enum State {
42         Preico,
43         Ico,
44         Successful
45     }
46     
47     State public state = State.Preico; //Set initial stage
48     uint startTime = now; //block-time when it was deployed
49 
50     //List of prices for each stage, as both, eth and moi have 18 decimal, its a direct factor
51     uint[4] tablePrices = [
52     58000,
53     63800,
54     32200
55     ];
56 
57     mapping (address => uint) balances; //balances mapping
58     //public variables
59     uint public totalRaised;
60     uint public currentBalance;
61     uint public preICODeadline;
62     uint public ICOdeadline;
63     uint public completedAt;
64     token public tokenReward;
65     address public creator;
66     address public beneficiary; 
67     string public campaignUrl;
68     uint constant version = 1;
69 
70     //events for log
71 
72     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
73     event LogBeneficiaryPaid(address _beneficiaryAddress);
74     event LogFundingSuccessful(uint _totalRaised);
75     event LogFunderInitialized(
76         address _creator,
77         address _beneficiary,
78         string _url,
79         uint256 _preICODeadline,
80         uint256 _ICOdeadline);
81     event LogContributorsPayout(address _addr, uint _amount);
82 
83     modifier notFinished() {
84         require(state != State.Successful);
85         _;
86     }
87 
88     function MOIRAICO (
89         string _campaignUrl,
90         token _addressOfTokenUsedAsReward )
91         public
92     {
93         creator = msg.sender;
94         beneficiary = msg.sender;
95         campaignUrl = _campaignUrl;
96         preICODeadline = SafeMath.add(startTime,34 days);
97         ICOdeadline = SafeMath.add(preICODeadline,30 days);
98         currentBalance = 0;
99         tokenReward = token(_addressOfTokenUsedAsReward);
100         LogFunderInitialized(
101             creator,
102             beneficiary,
103             campaignUrl,
104             preICODeadline,
105             ICOdeadline);
106     }
107 
108     function contribute() public notFinished payable {
109 
110         require(msg.value > 1 finney); //minimun contribution
111 
112         uint tokenBought;
113         totalRaised =SafeMath.add(totalRaised, msg.value);
114         currentBalance = totalRaised;
115 
116         if(state == State.Preico){
117             tokenBought = SafeMath.mul(msg.value,tablePrices[0]);
118         }
119         else if(state == State.Preico && now < (startTime + 1 days)) {
120             tokenBought = SafeMath.mul(msg.value,tablePrices[1]);
121         }
122         else{
123             tokenBought = SafeMath.mul(msg.value,tablePrices[2]);
124         }
125 
126         tokenReward.transfer(msg.sender, tokenBought);
127         
128         LogFundingReceived(msg.sender, msg.value, totalRaised);
129         LogContributorsPayout(msg.sender, tokenBought);
130         
131         checkIfFundingCompleteOrExpired();
132     }
133 
134     function checkIfFundingCompleteOrExpired() public {
135         
136         if(now < ICOdeadline && state!=State.Successful){
137             if(now > preICODeadline && state==State.Preico){
138                 state = State.Ico;    
139             }
140         }
141         else if(now > ICOdeadline && state!=State.Successful) {
142             state = State.Successful;
143             completedAt = now;
144             LogFundingSuccessful(totalRaised);
145             finished();  
146         }
147     }
148 
149     function finished() public { //When finished eth and remaining tokens are transfered to beneficiary
150         uint remanent;
151 
152         require(state == State.Successful);
153         require(beneficiary.send(this.balance));
154         remanent =  tokenReward.balanceOf(this);
155         tokenReward.transfer(beneficiary,remanent);
156 
157         currentBalance = 0;
158 
159         LogBeneficiaryPaid(beneficiary);
160         LogContributorsPayout(beneficiary, remanent);
161     }
162 
163     function () public payable {
164         require(msg.value > 1 finney);
165         contribute();
166     }
167 }