1 pragma solidity 0.4.25;
2 
3  /*
4  *check ethgasstation.info
5  *to set good gas price and gas limit
6  *we recommend to set your gas limit to 150000
7  *and your gas price to 15 gwei
8  *visit Ethkassa.io for more details
9  */ 
10 
11 library SafeMath {
12 
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0);
21     uint256 c = a / b;
22     // assert(a == b * c + a % b);
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 
37 }
38 
39 
40 
41 contract EthKassa{
42 
43    using SafeMath for uint;
44     mapping (address => uint) public balances;
45     mapping (address => uint) public time;
46     
47     uint steep1 = 5000;
48     uint steep2 = 10000;
49     uint steep3 = 15000;
50     uint steep4 = 20000;
51     uint steep5 = 25000;
52     
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
64     modifier isIssetRecepient(){
65         require(balances[msg.sender] > 0,  "Please send something");
66         _;
67     }
68     
69     
70     modifier timeCheck(){
71         
72          require(now >= time[msg.sender].add(dividendsTime), "Too fast, bro, please wait a little");
73          _;
74         
75     }
76     function getDepositMultiplier()public view  returns(uint){
77         uint percent = getPercent();
78         uint rate = balances[msg.sender].mul(percent).div(10000);
79         uint depositMultiplier = now.sub(time[msg.sender]).div(dividendsTime);
80         return(rate.mul(depositMultiplier));
81         
82     }
83     
84     function receivePayment()isIssetRecepient timeCheck private {
85         
86         uint depositMultiplier = getDepositMultiplier();
87         time[msg.sender] = now;
88         msg.sender.transfer(depositMultiplier);
89         
90         allPercents+=depositMultiplier;
91         lastPayment =now;
92         emit PayOffDividends(msg.sender, depositMultiplier);
93         
94         
95     }
96     
97     function authorizationPayment()public view returns(bool){
98         
99         if (balances[msg.sender] > 0 && now >= (time[msg.sender].add(dividendsTime))){
100             return (true);
101         }else{
102             return(false);
103         }
104         
105     }
106    
107      
108     function getPercent() public view returns(uint){
109         
110         uint contractBalance = address(this).balance;
111         
112         uint balanceSteep1 = steep1.mul(1 ether);
113         uint balanceSteep2 = steep2.mul(1 ether);
114         uint balanceSteep3 = steep3.mul(1 ether);
115         uint balanceSteep4 = steep4.mul(1 ether);
116         uint balanceSteep5 = steep5.mul(1 ether);
117         
118         
119         if(contractBalance < balanceSteep1){
120             return(300);
121         }
122         if(contractBalance >= balanceSteep1 && contractBalance < balanceSteep2){
123             return(350);
124         }
125         if(contractBalance >= balanceSteep2 && contractBalance < balanceSteep3){
126             return(400);
127         }
128         if(contractBalance >= balanceSteep3 && contractBalance < balanceSteep4){
129             return(450);
130         }
131         if(contractBalance >= balanceSteep4 && contractBalance < balanceSteep5){
132             return(500);
133         }
134         if(contractBalance >= balanceSteep5){
135             return(550);
136         }
137         
138         
139     }
140     
141     function createDeposit() private{
142         
143         if(msg.value > 0){
144             
145             if (balances[msg.sender] == 0){
146                 emit NewInvestor(msg.sender, msg.value);
147                 allBeneficiaries+=1;
148             }
149             
150             
151             if(getDepositMultiplier() > 0 && now >= time[msg.sender].add(dividendsTime) ){
152                 receivePayment();
153             }
154             
155             balances[msg.sender] = balances[msg.sender].add(msg.value);
156             time[msg.sender] = now;
157             
158             allDeposits+=msg.value;
159             emit NewDeposit(msg.sender, msg.value);
160             
161         }else{
162             receivePayment();
163         }
164         
165     }
166     //BOF protection
167     function() external payable{
168         require((balances[msg.sender] + msg.value) >= balances[msg.sender]);
169         createDeposit();
170        
171     }
172     
173     
174 }