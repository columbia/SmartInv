1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33 }
34 
35 
36 
37 contract EtProfit{
38 
39    using SafeMath for uint;
40     // array containing information about beneficiaries
41     mapping (address => uint) public balances;
42     //array containing information about the time of payment
43     mapping (address => uint) public time;
44     
45     //The marks of the balance on the contract after which the percentage of payments will change
46     uint steep1 = 1000;
47     uint steep2 = 2000;
48     uint steep3 = 3000;
49     uint steep4 = 4000;
50     uint steep5 = 5000;
51     
52     //the time through which dividends will be paid
53     uint dividendsTime = 1 days;
54     
55     event NewInvestor(address indexed investor, uint deposit);
56     event PayOffDividends(address indexed investor, uint value);
57     event NewDeposit(address indexed investor, uint value);
58     
59     uint public allDeposits;
60     uint public allPercents;
61     uint public allBeneficiaries;
62     uint public lastPayment;
63     
64     
65     
66     /**
67      * The modifier checking the positive balance of the beneficiary
68     */
69     modifier isIssetRecepient(){
70         require(balances[msg.sender] > 0,  "Deposit not found");
71         _;
72     }
73     
74     /**
75      * modifier checking the next payout time
76      */
77     modifier timeCheck(){
78         
79          require(now >= time[msg.sender].add(dividendsTime), "Too fast payout request. The time of payment has not yet come");
80          _;
81         
82     }
83     function getDepositMultiplier()public view  returns(uint){
84         uint percent = getPercent();
85         uint rate = balances[msg.sender].mul(percent).div(10000);
86         uint depositMultiplier = now.sub(time[msg.sender]).div(dividendsTime);
87         return(rate.mul(depositMultiplier));
88         
89     }
90     
91     /**
92     *The method is called upon an empty payment for the contract, pays the interest on the deposit to the final beneficiary.
93     * A check is made on the funds on the depositor's account and the time at which he can receive a deposit interest
94     */
95     function receivePayment()isIssetRecepient timeCheck private{
96         
97         uint depositMultiplier = getDepositMultiplier();
98         time[msg.sender] = now;
99         msg.sender.transfer(depositMultiplier);
100         
101         allPercents+=depositMultiplier;
102         lastPayment =now;
103         emit PayOffDividends(msg.sender, depositMultiplier);
104         
105         
106     }
107     
108     /**
109      * Method for verifying the availability of interest payments to the ultimate beneficiary
110      * @return bool
111      */
112     function authorizationPayment()public view returns(bool){
113         
114         if (balances[msg.sender] > 0 && now >= (time[msg.sender].add(dividendsTime))){
115             return (true);
116         }else{
117             return(false);
118         }
119         
120     }
121    
122     /**
123      * Returns the percentage that will be accrued to the final beneficiary,
124      * depending on the available balance of the etherium on the contract
125      * 
126      * @return uint percent
127      */ 
128     function getPercent() public view returns(uint){
129         
130         uint contractBalance = address(this).balance;
131         
132         uint balanceSteep1 = steep1.mul(1 ether);
133         uint balanceSteep2 = steep2.mul(1 ether);
134         uint balanceSteep3 = steep3.mul(1 ether);
135         uint balanceSteep4 = steep4.mul(1 ether);
136         uint balanceSteep5 = steep5.mul(1 ether);
137         
138         
139         if(contractBalance < balanceSteep1){
140             return(425);
141         }
142         if(contractBalance >= balanceSteep1 && contractBalance < balanceSteep2){
143             return(450);
144         }
145         if(contractBalance >= balanceSteep2 && contractBalance < balanceSteep3){
146             return(475);
147         }
148         if(contractBalance >= balanceSteep3 && contractBalance < balanceSteep4){
149             return(500);
150         }
151         if(contractBalance >= balanceSteep4 && contractBalance < balanceSteep5){
152             return(525);
153         }
154         if(contractBalance >= balanceSteep5){
155             return(550);
156         }
157         
158         
159     }
160     
161     
162     
163     /**
164      * The method of accepting payments, if a zero payment has come, then we start the procedure for refunding
165      * the interest on the deposit, if the payment is not empty, we record the number of broadcasts on the contract
166      * and the payment time
167      */
168     function createDeposit() private{
169         
170         if(msg.value > 0){
171             
172             if (balances[msg.sender] == 0){
173                 emit NewInvestor(msg.sender, msg.value);
174                 allBeneficiaries+=1;
175             }
176             
177             
178             if(getDepositMultiplier() > 0 && now >= time[msg.sender].add(dividendsTime) ){
179                 receivePayment();
180             }
181             
182             balances[msg.sender] = balances[msg.sender].add(msg.value);
183             time[msg.sender] = now;
184             
185             allDeposits+=msg.value;
186             emit NewDeposit(msg.sender, msg.value);
187             
188         }else{
189             receivePayment();
190         }
191         
192     }
193 
194 
195     /**
196      * function that is launched when transferring money to a contract
197      */
198     function() external payable{
199         //buffer overflow protection
200         require((balances[msg.sender] + msg.value) >= balances[msg.sender]);
201         createDeposit();
202        
203     }
204     
205     
206 }