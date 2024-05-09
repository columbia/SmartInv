1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://12hourfasttrain.github.io
5 */
6 // MULTIPLIER: 120%
7 // THT Token Owners: 10%
8 // Referral: 3%
9 // Marketing: 3%
10 // Last Investor: 10%
11 // Min: 0.05 ETH
12 // Max: 1 ETH
13 
14 interface TwelveHourTokenInterface {
15      function fallback() external payable; 
16      function buy(address _referredBy) external payable returns (uint256);
17      function exit() external;
18 }
19 
20 contract TwelveHourFastTrain {
21 	address public owner;
22 	address public twelveHourTokenAddress;
23     TwelveHourTokenInterface public TwelveHourToken; 
24 	uint256 constant private THT_TOKEN_OWNERS     = 10;
25     address constant private PROMO = 0x31778364A4000F785c59D42Bb80e7E6E60b8457b;
26     uint constant public PROMO_PERCENT = 1;
27     uint constant public MULTIPLIER = 120;
28     uint constant public MAX_DEPOSIT = 1 ether;
29     uint constant public MIN_DEPOSIT = 0.05 ether;
30 	uint256 constant public VERIFY_REFERRAL_PRICE = 0.01 ether;
31 	uint256 constant public REFERRAL             = 3;
32 
33     uint constant public LAST_DEPOSIT_PERCENT = 10;
34     
35     LastDeposit public last;
36 
37 	mapping(address => bool) public referrals;
38 
39     struct Deposit {
40         address depositor; 
41         uint128 deposit;   
42         uint128 expect;    
43     }
44 
45     struct LastDeposit {
46         address depositor;
47         uint expect;
48         uint depositTime;
49     }
50 
51     Deposit[] public queue;
52     uint public currentReceiverIndex = 0; 
53 
54 	modifier onlyOwner() 
55     {
56       require(msg.sender == owner);
57       _;
58     }
59     modifier disableContract()
60     {
61       require(tx.origin == msg.sender);
62       _;
63     }
64 
65 	/**
66     * @dev set TwelveHourToken contract
67     * @param _addr TwelveHourToken address
68     */
69     function setTwelveHourToken(address _addr) public onlyOwner
70     {
71       twelveHourTokenAddress = _addr;
72       TwelveHourToken = TwelveHourTokenInterface(twelveHourTokenAddress);  
73     }
74 
75 	constructor() public 
76     {
77       owner = msg.sender;
78     }
79 
80     function () public payable {
81         if (msg.sender != twelveHourTokenAddress) invest(0x0);
82     }
83 
84     function invest(address _referral) public payable disableContract
85     {
86 		if(msg.value == 0 && msg.sender == last.depositor) {
87             require(gasleft() >= 220000, "We require more gas!");
88             require(last.depositTime + 12 hours < now, "Last depositor should wait 12 hours to claim reward");
89             
90             uint128 money = uint128((address(this).balance));
91             if(money >= last.expect){
92                 last.depositor.transfer(last.expect);
93             } else {
94                 last.depositor.transfer(money);
95             }
96             
97             delete last;
98         }
99         else if(msg.value > 0){
100             require(gasleft() >= 220000, "We require more gas!");
101             require(msg.value >= MIN_DEPOSIT, "Deposit must be >= 0.01 ETH and <= 1 ETH"); 
102             uint256 valueDeposit = msg.value;
103             if(valueDeposit > MAX_DEPOSIT) {
104                 msg.sender.transfer(valueDeposit - MAX_DEPOSIT);
105                 valueDeposit = MAX_DEPOSIT;
106             }
107 			uint256 _profitTHT     = valueDeposit * THT_TOKEN_OWNERS / 100;
108 			sendProfitTHT(_profitTHT);
109             queue.push(Deposit(msg.sender, uint128(valueDeposit), uint128(valueDeposit*MULTIPLIER/100)));
110 
111             last.depositor = msg.sender;
112             last.expect += valueDeposit*LAST_DEPOSIT_PERCENT/100;
113             last.depositTime = now;
114 
115             uint promo = valueDeposit*PROMO_PERCENT/100;
116             PROMO.transfer(promo);
117 			uint devFee = valueDeposit*2/100;
118             owner.transfer(devFee);
119 			
120 			uint256 _referralBonus = valueDeposit * REFERRAL/100;
121 			if (_referral != 0x0 && _referral != msg.sender && referrals[_referral] == true) address(_referral).transfer(_referralBonus);
122 			else owner.transfer(_referralBonus);
123 
124             pay();
125         }
126     }
127 
128 	function pay() private {
129         uint128 money = uint128((address(this).balance)-last.expect);
130         for(uint i=0; i<queue.length; i++){
131             uint idx = currentReceiverIndex + i;  
132             Deposit storage dep = queue[idx]; 
133             if(money >= dep.expect){  
134                 dep.depositor.transfer(dep.expect); 
135                 money -= dep.expect;            
136                 delete queue[idx];
137             }else{
138                 dep.depositor.transfer(money); 
139                 dep.expect -= money;       
140                 break;
141             }
142             if(gasleft() <= 50000)        
143                 break;
144         }
145         currentReceiverIndex += i; 
146     }
147 
148 	function sendProfitTHT(uint256 profitTHT) private
149     {
150         buyTHT(calEthSendToTHT(profitTHT));
151         exitTHT();
152     }
153 	
154 	function exitTHT() private
155     {
156       TwelveHourToken.exit();
157     }
158 	
159 	/**
160     * @dev calculate dividend eth for THT owner
161     * @param _eth value want share
162     * value = _eth * 100 / 64
163     */
164     function calEthSendToTHT(uint256 _eth) private pure returns(uint256 _value)
165     {
166       _value = _eth * 100 / 64;
167     }
168 
169 	function buyTHT(uint256 _value) private
170     {
171       TwelveHourToken.fallback.value(_value)();
172     }
173 
174 	function totalEthereumBalance() public view returns (uint256) {
175         return address(this).balance;
176     }
177 
178     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
179         Deposit storage dep = queue[idx];
180         return (dep.depositor, dep.deposit, dep.expect);
181     }
182 
183 
184 	function verifyReferrals() public payable disableContract
185     {
186       require(msg.value >= VERIFY_REFERRAL_PRICE);
187       referrals[msg.sender] = true;
188       owner.transfer(msg.value);
189     }
190     
191     function getDepositByAddress(address depositor) public view returns (uint256 index, uint256 deposit, uint256 expect) {
192         for(uint i=currentReceiverIndex; i<queue.length; ++i){
193             Deposit storage dep = queue[i];
194             if(dep.depositor == depositor){
195                 index = i;
196                 deposit = dep.deposit;
197                 expect = dep.expect;
198                 break;
199             }
200         }
201     }
202     
203     function getData()public view returns(uint256 _lastDepositBonus, uint256 _endTime, uint256 _currentlyServing, uint256 _queueLength, address _lastAddress) {
204         _lastDepositBonus = address(this).balance;
205         _endTime = last.depositTime + 12 hours;
206         _currentlyServing = currentReceiverIndex;
207         _queueLength = queue.length;
208         _lastAddress = last.depositor;
209     }
210 
211 }