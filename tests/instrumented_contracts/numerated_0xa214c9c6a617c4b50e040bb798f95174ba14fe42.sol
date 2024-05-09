1 pragma solidity ^0.4.19;
2 
3 library SafeMath { //standart library for uint
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0 || b == 0){
6         return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b <= a);
15     return a - b;
16   }
17 
18   function add(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a + b;
20     assert(c >= a);
21     return c;
22   }
23 
24   function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
25     if (b == 0){
26       return 1;
27     }
28     uint256 c = a**b;
29     assert (c >= a);
30     return c;
31   }
32 }
33 
34 //standart contract to identify owner
35 contract Ownable {
36 
37   address public owner;
38 
39   address public newOwner;
40 
41   address public techSupport;
42 
43   address public newTechSupport;
44 
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   modifier onlyTechSupport() {
51     require(msg.sender == techSupport);
52     _;
53   }
54 
55   function Ownable() public {
56     owner = msg.sender;
57   }
58 
59   function transferOwnership(address _newOwner) public onlyOwner {
60     require(_newOwner != address(0));
61     newOwner = _newOwner;
62   }
63 
64   function acceptOwnership() public {
65     if (msg.sender == newOwner) {
66       owner = newOwner;
67     }
68   }
69 
70   function transferTechSupport (address _newSupport) public{
71     require (msg.sender == owner || msg.sender == techSupport);
72     newTechSupport = _newSupport;
73   }
74 
75   function acceptSupport() public{
76     if(msg.sender == newTechSupport){
77       techSupport = newTechSupport;
78     }
79   }
80 
81 }
82 
83 //Abstract Token contract
84 contract BineuroToken{
85   function setCrowdsaleContract (address) public;
86   function sendCrowdsaleTokens(address, uint256)  public;
87   function burnTokens(address,address, address, uint) public;
88   function getOwner()public view returns(address);
89 }
90 
91 //Crowdsale contract
92 contract Crowdsale is Ownable{
93 
94   using SafeMath for uint;
95 
96   uint decimals = 3;
97   // Token contract address
98   BineuroToken public token;
99 
100   // Constructor
101   function Crowdsale(address _tokenAddress) public{
102     token = BineuroToken(_tokenAddress);
103     techSupport = msg.sender;
104 
105     token.setCrowdsaleContract(this);
106     owner = token.getOwner();
107   }
108 
109   address etherDistribution1 = 0x64f89e3CE504f1b15FcD4465b780Fb393ab79187;
110   address etherDistribution2 = 0x320359973d7953FbEf62C4f50960C46D8DBE2425;
111 
112   address bountyAddress = 0x7e06828655Ba568Bbe06eD8ce165e4052A6Ea441;
113 
114   //Crowdsale variables
115   uint public tokensSold = 0;
116   uint public ethCollected = 0;
117 
118   // Buy constants
119   uint minDeposit = (uint)(500).mul((uint)(10).pow(decimals));
120 
121   uint tokenPrice = 0.0001 ether;
122 
123   // Ico constants
124   uint public icoStart = 1519034400; //02/19/2018 1519034400
125   uint public icoFinish = 1521453600; //03/19/2018 
126 
127   uint public maxCap = 27000 ether;
128 
129   //Owner can change end date
130   function changeIcoFinish (uint _newDate) public onlyOwner {
131     icoFinish = _newDate;
132   }
133   
134   //check is now ICO
135   function isIco(uint _time) public view returns (bool){
136     if((icoStart <= _time) && (_time < icoFinish)){
137       return true;
138     }
139     return false;
140   }
141 
142   function timeBasedBonus(uint _time) public view returns(uint res) {
143     res = 20;
144     uint timeBuffer = icoStart;
145     for (uint i = 0; i<10; i++){
146       if(_time <= timeBuffer + 7 days){
147         return res;
148       }else{
149         res = res - 2;
150         timeBuffer = timeBuffer + 7 days;
151       }
152       if (res == 0){
153         return (0);
154       }
155     }
156     return res;
157   }
158   
159   function volumeBasedBonus(uint _value)public pure returns(uint res) {
160     if(_value < 5 ether){
161       return 0;
162     }
163     if (_value < 15 ether){
164       return 2;
165     }
166     if (_value < 30 ether){
167       return 5;
168     }
169     if (_value < 50 ether){
170       return 8;
171     }
172     return 10;
173   }
174   
175   //fallback function (when investor send ether to contract)
176   function() public payable{
177     require(isIco(now));
178     require(ethCollected.add(msg.value) <= maxCap);
179     require(buy(msg.sender,msg.value, now)); //redirect to func buy
180   }
181 
182   //function buy Tokens
183   function buy(address _address, uint _value, uint _time) internal returns (bool){
184     uint tokensForSend = etherToTokens(_value,_time);
185 
186     require (tokensForSend >= minDeposit);
187 
188     tokensSold = tokensSold.add(tokensForSend);
189     ethCollected = ethCollected.add(_value);
190 
191     token.sendCrowdsaleTokens(_address,tokensForSend);
192     etherDistribution1.transfer(this.balance/2);
193     etherDistribution2.transfer(this.balance);
194 
195     return true;
196   }
197 
198   function manualSendTokens (address _address, uint _tokens) public onlyTechSupport {
199     token.sendCrowdsaleTokens(_address, _tokens);
200     tokensSold = tokensSold.add(_tokens);
201   }
202 
203   //convert ether to tokens (without decimals)
204   function etherToTokens(uint _value, uint _time) public view returns(uint res) {
205     res = _value.mul((uint)(10).pow(decimals))/(tokenPrice);
206     uint bonus = timeBasedBonus(_time).add(volumeBasedBonus(_value));
207     res = res.add(res.mul(bonus)/100);
208   }
209   
210   bool public isIcoEnded = false;
211   
212   function endIco () public {
213     require(!isIcoEnded);
214     require(msg.sender == owner || msg.sender == techSupport);
215     require(now > icoFinish + 5 days);
216     token.burnTokens(etherDistribution1, etherDistribution2, bountyAddress, tokensSold);
217     isIcoEnded = true;
218   }
219 }