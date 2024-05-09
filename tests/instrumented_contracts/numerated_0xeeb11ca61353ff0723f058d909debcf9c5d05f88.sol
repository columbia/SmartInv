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
80     buffer.minCap = 108 ether;
81     buffer.maxCap = 24000 ether;
82 
83     stages.push(buffer);
84   }
85 
86   /* Destribution addresses */
87   //All ether will be send to this address
88   address distributionAddress = 0xe6997e8359599d0B5f17B7E1bF77f7fFC509Afbe;
89 
90 
91   function () public payable {
92     require (buy(msg.sender, msg.value, now));
93   }
94 
95 
96   function buy (address _address, uint _value, uint _time) internal returns(bool) {
97 
98     uint currentStage = getCurrentStage(_time);
99     
100     require(currentStage != 1000);
101 
102     uint tokensToSend = _value.mul((uint)(10).pow(decimals))/stages[currentStage].tokenPrice;
103 
104     require (tokensToSend.add(stages[currentStage].tokensSold) <= stages[currentStage].maxCap);
105 
106     stages[currentStage].tokensSold = stages[currentStage].tokensSold.add(tokensToSend);
107 
108     stages[currentStage].ethContributors[_address] = stages[currentStage].ethContributors[_address].add(_value);
109 
110     stages[currentStage].ethCollected = stages[currentStage].ethCollected.add(_value);
111 
112     token.sendCrowdsaleTokens(_address, tokensToSend);
113 
114     autoDistribute(currentStage);
115 
116     return true;
117   }
118 
119   function autoDistribute (uint currentStage) internal {
120     if (stages[currentStage].minCap <= stages[currentStage].tokensSold){
121 
122       distributionAddress.transfer(stages[currentStage].ethCollected.sub(stages[currentStage].ethSended));
123 
124       stages[currentStage].ethSended = stages[currentStage].ethCollected;
125     }
126   }
127   
128   
129 function manualSendTokens (address _address, uint _value) public onlyOwner {
130 
131     uint currentStage = getCurrentStage(now);
132     require(currentStage != 1000);
133 
134     stages[currentStage].tokensSold = stages[currentStage].tokensSold.add(_value.mul((uint)(10).pow(decimals)));
135 
136     token.sendCrowdsaleTokens(_address,_value.mul((uint)(10).pow(decimals)));
137 
138     autoDistribute(currentStage);
139   }
140   
141   struct stageStruct {
142     uint startDate;
143     uint finishDate;
144     uint tokenPrice;
145     uint minCap;
146     uint maxCap;
147     uint tokensSold;
148 
149     uint ethCollected;
150     uint ethSended;
151 
152     mapping (address => uint) ethContributors; 
153   }
154 
155   stageStruct[] public stages;
156 
157 
158   function addNewStage (uint _start, uint _finish, uint _price, uint _mincap, uint _maxcap) public onlyOwner {
159     stageStruct memory buffer;
160 
161     buffer.startDate = _start;
162     buffer.finishDate = _finish;
163     buffer.tokenPrice = _price;
164     buffer.minCap = _mincap.mul((uint)(10).pow(decimals));
165     buffer.maxCap = _maxcap.mul((uint)(10).pow(decimals));
166 
167     stages.push(buffer);
168   }
169   
170   function getCurrentStage (uint _time) public view returns (uint) {
171     uint currentStage = 0;
172     for (uint i = 0; i < stages.length; i++){
173       if (stages[i].startDate < _time && _time <= stages[i].finishDate){
174         currentStage = i;
175         break;
176       }
177     }
178     if (stages[currentStage].startDate < _time && _time <= stages[currentStage].finishDate){
179       return currentStage;
180     }else{
181       return 1000; //NO ACTIVE STAGE
182     }
183   }
184   
185   
186   function refund () public {
187     uint currentStage = getCurrentStage(now);
188 
189     for (uint i = 0; i < currentStage; i++){
190       if(stages[i].ethContributors[msg.sender] > 0 && stages[i].tokensSold < stages[i].minCap){
191         msg.sender.transfer(stages[i].ethContributors[msg.sender]);
192         stages[i].ethContributors[msg.sender] = 0;
193       }
194     }
195   }
196 
197 }