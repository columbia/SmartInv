1 pragma solidity ^0.4.20;
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
51     require(msg.sender == techSupport || msg.sender == owner);
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
84 contract HeliosToken{
85   function setCrowdsaleContract (address) public;
86   function sendCrowdsaleTokens(address, uint256) public;
87   function endIco() public;
88 }
89 
90 //Crowdsale contract
91 contract Crowdsale is Ownable{
92 
93   using SafeMath for uint;
94 
95   uint decimals = 2;
96   // Token contract address
97   HeliosToken public token;
98 
99   // Constructor
100   function Crowdsale(address _tokenAddress) public{
101     token = HeliosToken(_tokenAddress);
102     techSupport = 0xcDDC1cE0b7D4C9B018b8a4b8f7Da2678D56E8619;
103 
104     token.setCrowdsaleContract(address(this));
105     owner = 0xA957c13265Cb1b101401d10f5E0b69E0b36ef000;
106   }
107 
108   //Crowdsale variables
109   uint public preIcoTokensSold = 0;
110   uint public tokensSold = 0;
111   uint public ethCollected = 0;
112 
113   mapping (address => uint) contributorBalances;
114 
115   uint public tokenPrice = 0.001 ether;
116 
117   //preIco constants
118   uint public constant preIcoStart = 1525168800; //1525168800
119   uint public constant preIcoFinish = 1527847200;
120   uint public constant preIcoMinInvest = 50*(uint(10).pow(decimals)); //50 Tokens
121   uint public constant preIcoMaxCap = 500000*(uint(10).pow(decimals)); //500000 Tokens
122 
123   // Ico constants
124   uint public constant icoStart = 1530439200; 
125   uint public constant icoFinish = 1538388000; 
126   uint public constant icoMinInvest = 10*(uint(10).pow(decimals)); //10 Tokens
127 
128   uint public constant minCap = 1000000 * uint(10).pow(decimals);
129 
130   function isPreIco (uint _time) public pure returns(bool) {
131     if((preIcoStart <= _time) && (_time < preIcoFinish)){
132       return true;
133     }
134   }
135   
136   //check is now ICO
137   function isIco(uint _time) public pure returns (bool){
138     if((icoStart <= _time) && (_time < icoFinish)){
139       return true;
140     }
141     return false;
142   }
143 
144   function timeBasedBonus(uint _time) public pure returns(uint) {
145     if(_time < preIcoStart || (_time > preIcoFinish && _time < icoStart)){
146       return 20;
147     }
148 
149     if(isPreIco(_time)){
150       if(preIcoStart + 1 weeks > _time){
151         return 20;
152       }
153       if(preIcoStart + 2 weeks > _time){
154         return 15;
155       }
156       if(preIcoStart + 3 weeks > _time){
157         return 10;
158       }
159     }
160     if(isIco(_time)){
161       if(icoStart + 1 weeks > _time){
162         return 20;
163       }
164       if(icoStart + 2 weeks > _time){
165         return 15;
166       }
167       if(icoStart + 3 weeks > _time){
168         return 10;
169       }
170     }
171     return 0;
172   }
173   
174   event OnSuccessfullyBuy(address indexed _address, uint indexed _etherValue, bool indexed isBought, uint _tokenValue);
175 
176   //fallback function (when investor send ether to contract)
177   function() public payable{
178     require(isPreIco(now) || isIco(now));
179     require(buy(msg.sender,msg.value, now)); //redirect to func buy
180   }
181 
182   //function buy Tokens
183   function buy(address _address, uint _value, uint _time) internal returns (bool){
184     
185     uint tokensToSend = etherToTokens(_value,_time);
186 
187     if (isPreIco(_time)){
188       require (tokensToSend >= preIcoMinInvest);
189       require (preIcoTokensSold.add(tokensToSend) <= preIcoMaxCap);
190       
191       token.sendCrowdsaleTokens(_address,tokensToSend);
192       preIcoTokensSold = preIcoTokensSold.add(tokensToSend);
193 
194       tokensSold = tokensSold.add(tokensToSend);
195       distributeEther();
196 
197     }else{
198       require (tokensToSend >= icoMinInvest);
199       token.sendCrowdsaleTokens(_address,tokensToSend);
200 
201       contributorBalances[_address] = contributorBalances[_address].add(_value);
202 
203       tokensSold = tokensSold.add(tokensToSend);
204 
205       if (tokensSold >= minCap){
206         distributeEther();
207       }
208     }
209 
210     emit OnSuccessfullyBuy(_address,_value,true, tokensToSend);
211     ethCollected = ethCollected.add(_value);
212 
213     return true;
214   }
215 
216   address public distributionAddress = 0x769EDcf3756A3Fd4D52B739E06dF060b7379C4Ef;
217   function distributeEther() internal {
218     distributionAddress.transfer(address(this).balance);
219   }
220   
221   event ManualTokensSended(address indexed _address, uint indexed _value, bool );
222   
223   function manualSendTokens (address _address, uint _tokens) public onlyTechSupport {
224     token.sendCrowdsaleTokens(_address, _tokens);
225     tokensSold = tokensSold.add(_tokens);
226     emit OnSuccessfullyBuy(_address,0,false,_tokens);
227   }
228 
229   function manualSendEther (address _address, uint _value) public onlyTechSupport {
230     uint tokensToSend = etherToTokens(_value, 0);
231     tokensSold = tokensSold.add(tokensToSend);
232     ethCollected = ethCollected.add(_value);
233 
234     token.sendCrowdsaleTokens(_address, tokensToSend);
235     emit OnSuccessfullyBuy(_address,_value,false, tokensToSend);
236   }
237   
238   //convert ether to tokens (without decimals)
239   function etherToTokens(uint _value, uint _time) public view returns(uint res) {
240     if(_time == 0){
241         _time = now;
242     }
243     res = _value.mul((uint)(10).pow(decimals))/tokenPrice;
244     uint bonus = timeBasedBonus(_time);
245     res = res.add(res.mul(bonus)/100);
246   }
247 
248   event Refund(address indexed contributor, uint ethValue);  
249 
250   function refund () public {
251     require (now > icoFinish && tokensSold < minCap);
252     require (contributorBalances[msg.sender] != 0);
253 
254     msg.sender.transfer(contributorBalances[msg.sender]);
255 
256     emit Refund(msg.sender, contributorBalances[msg.sender]);
257 
258     contributorBalances[msg.sender] = 0;
259   }
260   
261   function endIco () public onlyTechSupport {
262     require(now > icoFinish + 5 days);
263     token.endIco();
264   }
265   
266 }