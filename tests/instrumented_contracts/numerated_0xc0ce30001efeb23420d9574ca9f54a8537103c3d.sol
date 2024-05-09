1 pragma solidity ^0.4.18;
2 
3 contract agame {
4    
5     address internal owner;
6     uint256 internal startCount;
7     
8     uint internal roundCount; 
9     uint internal startTime;
10     uint internal currentRoundSupport;
11     uint internal currentRoundLeft;
12     uint internal timeout;
13     mapping(uint => uint) roundSupportMapping;
14    
15     uint constant internal decimals = 18;
16     uint constant internal min_wei = 1e9;
17     uint constant internal dividendFee = 10;
18     uint constant internal dynamicDividendFee = 6;
19     uint constant internal platformDividendFee = 4;
20    
21     constructor(uint _startCount,uint timeout_) public{
22         require(_startCount>0);
23         owner = msg.sender;
24         startCount = _startCount * 1e14;
25         currentRoundLeft = startCount;
26         currentRoundSupport = startCount;
27         roundCount = 1;
28         startTime = now;
29         timeout = timeout_;
30         roundSupportMapping[roundCount] = currentRoundLeft;
31     }
32     
33     modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37     
38     modifier running() {
39         require((now - startTime) < timeout,'time is out');
40         _;
41     }
42     
43     modifier correctValue(uint256 _eth) {
44         require(_eth >= min_wei, "can not lessthan 1 gwei ");
45         require(_eth <= 100000000000000000000000, "no vitalik, no");
46         _;
47     }
48     
49    string contractName = "OGAME";
50    
51    mapping(address => Buyer) buyerList;
52    mapping(address => Buyer) buyerList_next;
53    address[] addressList;
54    address[] addressList_next;
55    
56    event ChangeName(string name_);
57    event BuySuccess(address who,uint256 value,uint againCount);
58    event SendDivedend(address who,uint256 value);
59    event Transfer(
60         address indexed from,
61         address indexed to,
62         uint256 tokens
63     );
64     event ReturnValue(
65         address indexed from,
66         address indexed to,
67         uint256 tokens
68     );
69     
70     function getContractName() public view returns(string name_){    
71         return contractName;
72     }
73    
74     function setContractName(string newName) public onlyOwner{
75        contractName = newName;
76        emit ChangeName(newName);
77     }
78     
79     function getCurrentRoundLeft() public view returns(uint left,uint _all){
80         return (currentRoundLeft,currentRoundSupport);
81     }
82     
83     function transfer(address to_,uint256 amount) public onlyOwner returns(bool success_){
84         to_.transfer(amount);
85         emit Transfer(address(this), to_, amount);
86         return true;
87     }
88    
89     function dealDivedendOfBuyers() internal onlyOwner returns(bool success_){
90         for (uint128 i = 0; i < addressList.length; i++) {
91             uint256 _amount = buyerList[addressList[i]].amount*(100+dividendFee)/100;
92             address _to = addressList[i];
93             _to.transfer(_amount);
94             emit SendDivedend(_to, _amount);
95         }
96         return true;
97     }
98    
99     function gettAddressList() public view returns(address[] addressList_){
100         return addressList;
101     }
102     
103     function gameInfo() public view returns(string _gameName,uint _roundCount,uint _remaining,uint _all,uint _leftTime){
104         return (contractName,roundCount,currentRoundLeft,currentRoundSupport,timeout-(now - startTime));
105     }
106    
107     struct Buyer{
108         address who;
109         uint256 amount;
110         uint time;
111         uint againCount;
112         bool isValue;
113     }
114   
115     function buy(uint againCount_) payable correctValue(msg.value) running public{
116 
117         uint256 value = msg.value;
118         address sender = msg.sender;
119         uint returnValue = 0;
120         if(currentRoundLeft <= value){
121            returnValue = value - currentRoundLeft;
122            value = currentRoundLeft;
123         }
124 
125         currentRoundLeft -= value;
126 
127         if(currentRoundLeft == 0){
128             _initNextRound();
129         }
130 
131         if(returnValue > 0){
132             sender.transfer(returnValue);
133             emit ReturnValue(address(this), sender, returnValue);
134         }
135 
136         Buyer memory buyer;
137         if(buyerList[sender].isValue){
138             buyer = buyerList[sender];
139             buyer.amount = buyer.amount + value;
140             buyerList[sender] = (buyer);
141         }else{
142             addressList.push(sender);
143             buyer = Buyer(sender,value,now,againCount_,true);
144             buyerList[sender] = (buyer);
145         }
146         emit BuySuccess(sender,value,againCount_);
147        
148     }
149     
150     // 内部方法
151     function _initNextRound() internal{ 
152         currentRoundSupport = currentRoundSupport * (100 + dividendFee + dynamicDividendFee + platformDividendFee)/100;
153         currentRoundLeft = currentRoundSupport;
154         roundCount++;
155         roundSupportMapping[roundCount] = currentRoundSupport;
156         startTime = now;
157     }
158     
159     // view
160     function mybalance() public view onlyOwner returns(uint256 balance){
161         return address(this).balance;
162     }
163     
164     function userAmount(address user) public view returns(uint256 _amount,uint256 _devidend){
165         return (buyerList[user].amount,(buyerList[user].amount * (100+dividendFee) / 100));
166     }
167     
168     function userDevidend(address user) public view returns(uint256 _amount){
169         return (buyerList[user].amount * (100+dividendFee) / 100);
170     }
171   
172 }