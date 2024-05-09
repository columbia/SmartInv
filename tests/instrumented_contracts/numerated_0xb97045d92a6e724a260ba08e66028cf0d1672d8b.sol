1 pragma solidity 0.4.19;
2 
3 contract Countout {
4 
5     address public owner;
6     uint128 public ownerBank;
7     uint8 public round;
8     uint8 public round_after;
9     uint8 public currentCount;
10     uint8 public totalCount;
11     uint128 public initialPrice = 0.005 ether;
12     uint128 public bonusPrice = 0.1 ether;
13     uint128 public nextPrice;
14     uint128 public sumPrice;
15     uint256 public lastTransactionTime;
16     address public lastCountAddress;    
17     uint8 private randomCount;
18     
19     address[] public sevenWinnerAddresses;      
20     mapping (address => uint128) public addressToBalance;
21 
22     event Count(address from, uint8 count);
23     event Hit(address from, uint8 count);
24 
25     /*** CONSTRUCTOR ***/
26     function Countout() public {
27         owner = msg.sender;
28         _renew();
29         _keepLastTransaction();
30         //Set randomcount as 10 as pre-sale
31         randomCount = 10;
32     }
33 
34     /*** Owner Action ***/
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39     
40     function transferOwnership(address _newOwner) public onlyOwner {
41         if (_newOwner != address(0)) {
42             owner = _newOwner;
43         }
44     }
45 
46     function ownerWithdraw() public onlyOwner {
47         require (block.timestamp > lastTransactionTime + 7 days); 
48 
49         if (round_after < 77 && sevenWinnerAddresses.length > 0){
50             uint128 sevensWinnerBack = (ownerBank + sumPrice) / uint8(sevenWinnerAddresses.length) - 0.0000007 ether;
51             uint8 i;
52             for (i = 0; i < sevenWinnerAddresses.length; i++){
53                 addressToBalance[sevenWinnerAddresses[i]]  = addressToBalance[sevenWinnerAddresses[i]] + sevensWinnerBack;
54             }         
55                
56         } else {
57             owner.transfer(this.balance);
58         }
59         sumPrice = 0;
60         ownerBank = 0;
61     }
62 
63     function sevenWinnerWithdraw() public {
64         require(addressToBalance[msg.sender] > 0);
65         msg.sender.transfer(addressToBalance[msg.sender]);
66         addressToBalance[msg.sender] = 0;
67     }    
68 
69     /*** Main Function ***/
70     function _payFee(uint128 _price, address _referralAddress) internal returns (uint128 _processing){
71         uint128 _cut = _price / 100;
72         _processing = _price - _cut;
73         if (_referralAddress != address(0)){
74             _referralAddress.transfer(_cut);
75         } else {    
76             ownerBank = ownerBank + _cut;    
77         }
78         uint8 i;
79         for (i = 0; i < sevenWinnerAddresses.length; i++){
80             addressToBalance[sevenWinnerAddresses[i]]  = addressToBalance[sevenWinnerAddresses[i]] + _cut;
81             _processing = _processing - _cut;
82         }
83 
84         uint128 _remaining = (7 - uint8(sevenWinnerAddresses.length)) * _cut;
85         ownerBank = ownerBank + _remaining;
86         _processing = _processing - _remaining;
87     }
88 
89     function _renew() internal{
90         round++;
91         if (sevenWinnerAddresses.length == 7){
92             round_after++;
93         }
94         currentCount = 0;
95         nextPrice = initialPrice;
96 
97         randomCount = uint8(block.blockhash(block.number-randomCount))%10 + 1;
98 
99         if(randomCount >= 7){
100             randomCount = uint8(block.blockhash(block.number-randomCount-randomCount))%10 + 1;  
101         }
102         
103         if (sevenWinnerAddresses.length < 7 && randomCount == 7){
104             randomCount++;
105         }         
106 
107     }
108 
109     function _keepLastTransaction() internal{
110         lastTransactionTime = block.timestamp;
111         lastCountAddress = msg.sender;
112     }
113 
114     function countUp(address _referralAddress) public payable {
115         require (block.timestamp < lastTransactionTime + 7 days);    
116         require (msg.value == nextPrice); 
117 
118         uint128 _price = uint128(msg.value);
119         uint128 _processing;
120       
121         totalCount++;
122         currentCount++; 
123 
124         _processing = _payFee(_price, _referralAddress);     
125         
126         if (currentCount > 1) {
127             lastCountAddress.transfer(_processing);
128         } else {
129             sumPrice = sumPrice + _processing;
130         }
131 
132         if (currentCount == randomCount) {
133             Hit(msg.sender, currentCount);
134             _renew(); 
135 
136         } else {
137             if (currentCount == 7) {
138                 if (sevenWinnerAddresses.length < 7){
139                     sevenWinnerAddresses.push(msg.sender);
140                 } else {
141 
142                     if (sumPrice <= bonusPrice) {
143                         msg.sender.transfer(sumPrice);
144                         sumPrice = 0;
145                     } else {
146                         msg.sender.transfer(bonusPrice);
147                         sumPrice = sumPrice - bonusPrice;
148                    }
149                 }
150                 _renew();
151             } else {
152                 nextPrice = nextPrice * 3/2;
153             }   
154 
155             Count(msg.sender, currentCount);            
156         }
157         _keepLastTransaction(); 
158     }
159 
160 }