1 pragma solidity ^0.4.18;
2 library SafeMath { //standard library for uint
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     if (a == 0 || b == 0){
5         return 0;
6     }
7     uint256 c = a * b;
8     assert(c / a == b);
9     return c;
10   }
11   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12     assert(b <= a);
13     return a - b;
14   }
15   function add(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a + b;
17     assert(c >= a);
18     return c;
19   }
20   function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
21     if (b == 0){
22       return 1;
23     }
24     uint256 c = a**b;
25     assert (c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable { //standart contract to identify owner
31   address public owner;
32 
33   address public newOwner;
34 
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39   function Ownable() public {
40     owner = msg.sender;
41   }
42   function transferOwnership(address _newOwner) public onlyOwner {
43     require(_newOwner != address(0));
44     newOwner = _newOwner;
45   }
46   function acceptOwnership() public {
47     if (msg.sender == newOwner) {
48       owner = newOwner;
49     }
50   }
51 }
52 
53 contract SpyceToken{
54   function sendCrowdsaleTokens(address, uint256)  public;
55   function setCrowdsaleContract (address) public;
56   function burnContributorTokens (address _address) public;
57 }
58 
59 contract SpyceCrowdsale is Ownable{
60   using SafeMath for uint;
61 
62   uint decimals = 18;
63 
64   // Token contract address
65   SpyceToken public token;
66 
67   function SpyceCrowdsale(address _tokenAddress) public{
68     token = SpyceToken(_tokenAddress);
69 
70     owner = msg.sender;
71     token.setCrowdsaleContract(this);
72 
73     stageStruct memory buffer;
74 
75     buffer.startDate = 0; 
76     
77     //1522195199 is equivalent to 03/27/2018 @ 11:59pm (UTC)
78     buffer.finishDate = 1522195199;
79     buffer.tokenPrice = 0.00016 ether;
80     buffer.minCap = 675000 ether;
81     buffer.maxCap = 150000000 ether;
82 
83     stages.push(buffer);
84   }
85 
86   /* Destribution addresses */
87   //All ether will be send to this address: 0x003b43733592eFa879B7154eDE5A4Eea47585f30
88   address distributionAddress = 0x003b43733592eFa879B7154eDE5A4Eea47585f30;
89 
90   function () public payable {
91     require (buy(msg.sender, msg.value, now));
92   }
93 
94 
95   function buy (address _address, uint _value, uint _time) internal returns(bool) {
96 
97     uint currentStage = getCurrentStage(_time);
98     
99     require(currentStage != 1000);
100 
101     uint tokensToSend = _value.mul((uint)(10).pow(decimals))/stages[currentStage].tokenPrice;
102 
103     require (tokensToSend.add(stages[currentStage].tokensSold) <= stages[currentStage].maxCap);
104 
105     stages[currentStage].tokensSold = stages[currentStage].tokensSold.add(tokensToSend);
106 
107     stages[currentStage].ethContributors[_address] = stages[currentStage].ethContributors[_address].add(_value);
108 
109     stages[currentStage].ethCollected = stages[currentStage].ethCollected.add(_value);
110 
111     token.sendCrowdsaleTokens(_address, tokensToSend);
112 
113     autoDistribute(currentStage);
114 
115     return true;
116   }
117 
118   function autoDistribute (uint currentStage) internal {
119     if (stages[currentStage].minCap <= stages[currentStage].tokensSold){
120 
121       distributionAddress.transfer(stages[currentStage].ethCollected.sub(stages[currentStage].ethSended));
122 
123       stages[currentStage].ethSended = stages[currentStage].ethCollected;
124     }
125   }
126   
127   
128 function manualSendTokens (address _address, uint _value) public onlyOwner {
129 
130     uint currentStage = getCurrentStage(now);
131     require(currentStage != 1000);
132 
133     stages[currentStage].tokensSold = stages[currentStage].tokensSold.add(_value.mul((uint)(10).pow(decimals)));
134 
135     token.sendCrowdsaleTokens(_address,_value.mul((uint)(10).pow(decimals)));
136 
137     autoDistribute(currentStage);
138   }
139   
140   struct stageStruct {
141     uint startDate;
142     uint finishDate;
143     uint tokenPrice;
144     uint minCap;
145     uint maxCap;
146     uint tokensSold;
147 
148     uint ethCollected;
149     uint ethSended;
150 
151     mapping (address => uint) ethContributors; 
152   }
153 
154   stageStruct[] public stages;
155 
156 
157   function addNewStage (uint _start, uint _finish, uint _price, uint _mincap, uint _maxcap) public onlyOwner {
158     stageStruct memory buffer;
159 
160     buffer.startDate = _start;
161     buffer.finishDate = _finish;
162     buffer.tokenPrice = _price;
163     buffer.minCap = _mincap.mul((uint)(10).pow(decimals));
164     buffer.maxCap = _maxcap.mul((uint)(10).pow(decimals));
165 
166     stages.push(buffer);
167   }
168   
169   function getCurrentStage (uint _time) public view returns (uint) {
170     uint currentStage = 0;
171     for (uint i = 0; i < stages.length; i++){
172       if (stages[i].startDate < _time && _time <= stages[i].finishDate){
173         currentStage = i;
174         break;
175       }
176     }
177     if (stages[currentStage].startDate < _time && _time <= stages[currentStage].finishDate){
178       return currentStage;
179     }else{
180       return 1000; //NO ACTIVE STAGE
181     }
182   }
183   
184   
185   function refund () public {
186     uint currentStage = getCurrentStage(now);
187 
188     for (uint i = 0; i < currentStage; i++){
189       if(stages[i].ethContributors[msg.sender] > 0 && stages[i].tokensSold < stages[i].minCap){
190         msg.sender.transfer(stages[i].ethContributors[msg.sender]);
191         stages[i].ethContributors[msg.sender] = 0;
192       }
193     }
194   }
195 
196 }