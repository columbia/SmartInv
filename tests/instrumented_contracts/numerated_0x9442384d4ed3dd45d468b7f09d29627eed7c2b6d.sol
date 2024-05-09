1 pragma solidity ^0.4.16;
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
35 
36     }
37 contract MOIRAICO {
38     //This ico have 3 stages
39     enum State {
40         Preico,
41         Ico,
42         Successful
43     }
44     
45     State public state = State.Preico; //Set initial stage
46     uint startTime = now; //block-time when it was deployed
47 
48     //We use an aproximation of 1 eth = 290$ for this price calculation
49     //List of prices for each stage, as both, eth and moi have 18 decimal, its a direct factor
50     uint[9] tablePrices = [
51     63800,70180,76560, //+10%,+20%,+30%
52     58000,63800,70180, //+0%,+10%,+20%
53     32200,35420,38640  //+0%,+10%,+20%
54     ];
55 
56     mapping (address => uint) balances; //balances mapping
57     //public variables
58     uint public totalRaised;
59     uint public currentBalance;
60     uint public preICODeadline;
61     uint public ICOdeadline;
62     uint public completedAt;
63     token public tokenReward;
64     address public creator;
65     address public beneficiary; 
66     string public campaignUrl;
67     uint constant version = 1;
68 
69     //events for log
70 
71     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
72     event LogBeneficiaryPaid(address _beneficiaryAddress);
73     event LogFundingSuccessful(uint _totalRaised);
74     event LogFunderInitialized(
75         address _creator,
76         address _beneficiary,
77         string _url,
78         uint256 _preICODeadline,
79         uint256 _ICOdeadline);
80     event LogContributorsPayout(address _addr, uint _amount);
81 
82     modifier notFinished() {
83         require(state != State.Successful);
84         _;
85     }
86 
87     function MOIRAICO (
88         string _campaignUrl,
89         token _addressOfTokenUsedAsReward )
90         public
91     {
92         creator = msg.sender;
93         beneficiary = msg.sender;
94         campaignUrl = _campaignUrl;
95         preICODeadline = SafeMath.add(startTime,34 days);
96         ICOdeadline = SafeMath.add(preICODeadline,30 days);
97         currentBalance = 0;
98         tokenReward = token(_addressOfTokenUsedAsReward);
99         LogFunderInitialized(
100             creator,
101             beneficiary,
102             campaignUrl,
103             preICODeadline,
104             ICOdeadline);
105     }
106 
107     function contribute() public notFinished payable {
108 
109         require(msg.value > 1 finney); //minimun contribution
110 
111         uint tokenBought;
112         totalRaised =SafeMath.add(totalRaised, msg.value);
113         currentBalance = totalRaised;
114         /**
115          * Here price logic is made
116          */
117         if(state == State.Preico && now < (startTime + 1 days)){ //if we are on preico first day
118             if(msg.value < 10 ether){ //if the amount is less than 10 ether
119                 tokenBought = SafeMath.mul(msg.value,tablePrices[0]);
120             }
121             else if(msg.value < 20 ether){//if the amount is more than 10 ether and less than 20
122                 tokenBought = SafeMath.mul(msg.value,tablePrices[1]);
123             }
124             else{//if the amount is more than 20 ether
125                 tokenBought = SafeMath.mul(msg.value,tablePrices[2]);
126             }
127         }
128         else if(state == State.Preico) {//if we are on preico normal days
129             if(msg.value < 10 ether){ //if the amount is less than 10 ether
130                 tokenBought = SafeMath.mul(msg.value,tablePrices[3]);
131             }
132             else if(msg.value < 20 ether){//if the amount is more than 10 ether and less than 20
133                 tokenBought = SafeMath.mul(msg.value,tablePrices[4]);
134             }
135             else{//if the amount is more than 20 ether
136                 tokenBought = SafeMath.mul(msg.value,tablePrices[5]);
137             }
138         }
139         else{//if we are on ico
140             if(msg.value < 10 ether){ //if the amount is less than 10 ether
141                 tokenBought = SafeMath.mul(msg.value,tablePrices[6]);
142             }
143             else if(msg.value < 20 ether){//if the amount is more than 10 ether and less than 20
144                 tokenBought = SafeMath.mul(msg.value,tablePrices[7]);
145             }
146             else{//if the amount is more than 20 ether
147                 tokenBought = SafeMath.mul(msg.value,tablePrices[8]);
148             }
149         }
150 
151         tokenReward.transfer(msg.sender, tokenBought);
152         
153         LogFundingReceived(msg.sender, msg.value, totalRaised);
154         LogContributorsPayout(msg.sender, tokenBought);
155         
156         checkIfFundingCompleteOrExpired();
157     }
158 
159     function checkIfFundingCompleteOrExpired() public {
160         
161         if(now < ICOdeadline && state!=State.Successful){
162             if(now > preICODeadline && state==State.Preico){
163                 state = State.Ico;    
164             }
165         }
166         else if(now > ICOdeadline && state!=State.Successful) {
167             state = State.Successful;
168             completedAt = now;
169             LogFundingSuccessful(totalRaised);
170             finished();  
171         }
172     }
173 
174     function payOut() public {
175         require(msg.sender == beneficiary);
176         require(beneficiary.send(this.balance));
177         LogBeneficiaryPaid(beneficiary);
178     }
179 
180 
181     function finished() public { //When finished eth and remaining tokens are transfered to beneficiary
182         uint remanent;
183 
184         require(state == State.Successful);
185         require(beneficiary.send(this.balance));
186         remanent =  tokenReward.balanceOf(this);
187         tokenReward.transfer(beneficiary,remanent);
188 
189         currentBalance = 0;
190 
191         LogBeneficiaryPaid(beneficiary);
192         LogContributorsPayout(beneficiary, remanent);
193     }
194 
195     function () public payable {
196         require(msg.value > 1 finney);
197         contribute();
198     }
199 }