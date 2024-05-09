1 pragma solidity ^0.4.19;
2 /*standart library for uint
3 */
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0 || b == 0){
7         return 0;
8     }
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /*
34 contract to identify owner
35 */
36 contract Ownable {
37 
38   address public owner;
39 
40   address public newOwner;
41 
42   address public techSupport;
43 
44   address public newTechSupport;
45 
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   modifier onlyTechSupport() {
52     require(msg.sender == techSupport);
53     _;
54   }
55 
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   function transferOwnership(address _newOwner) public onlyOwner {
61     require(_newOwner != address(0));
62     newOwner = _newOwner;
63   }
64 
65   function acceptOwnership() public {
66     if (msg.sender == newOwner) {
67       owner = newOwner;
68     }
69   }
70 
71   function transferTechSupport (address _newSupport) public{
72     require (msg.sender == owner || msg.sender == techSupport);
73     newTechSupport = _newSupport;
74   }
75 
76   function acceptSupport() public{
77     if(msg.sender == newTechSupport){
78       techSupport = newTechSupport;
79     }
80   }
81 }
82 
83 /*
84 ERC - 20 token contract
85 */
86 contract VGCToken {
87   function setCrowdsaleContract (address _address) public {}
88   function burnTokens(address _address) public{}
89   function getCrowdsaleBalance() public view returns(uint) {}
90   function getRefBalSended () public view returns(bool){}
91   function sendCrowdsaleBalance (address _address, uint _value) public {}
92   function finishIco() public{}
93 }
94 
95 //Crowdsale contract
96 contract Crowdsale is Ownable{
97 
98   using SafeMath for uint;
99   //power function
100   function pow(uint256 a, uint256 b) internal pure returns (uint256){
101    return (a**b);
102   }
103 
104   uint decimals = 2;
105   // Token contract address
106   VGCToken public token;
107 
108   struct Ico{
109     uint bonus;
110     uint balance;
111   }
112   // Constructor
113   function Crowdsale(address _tokenAddress, address _addressOwner) public{
114     token = VGCToken(_tokenAddress);
115     owner = _addressOwner;
116     structurePreIco.push(Ico(55555555555,1000000*pow(10,decimals))); //80% bonus
117     structurePreIco.push(Ico(58823529411,1000000*pow(10,decimals))); //70
118     structurePreIco.push(Ico(62500000000,1000000*pow(10,decimals))); //60
119     structurePreIco.push(Ico(66666666666,1000000*pow(10,decimals))); //50
120     structurePreIco.push(Ico(71428571428,1000000*pow(10,decimals))); //40
121     structurePreIco.push(Ico(76923076923,1000000*pow(10,decimals))); //30
122 
123 
124     structureIco.push(Ico(83333333333,10000000*pow(10,decimals))); //20
125     structureIco.push(Ico(90909090909,10000000*pow(10,decimals))); //10
126     structureIco.push(Ico(100000000000,10000000*pow(10,decimals))); //0
127 
128     techSupport = msg.sender;
129     token.setCrowdsaleContract(this);
130   }
131   //ICO structures (technical decision)
132   Ico[] public structurePreIco;
133   Ico[] public structureIco;
134     // Buy constants
135   uint public tokenPrice = 2000000000000000 / pow(10,decimals);
136   uint minDeposit = 100000000000000000; //0.1 ETH
137 
138     // preIco constants
139   uint public preIcoStart = 1516320000; // 01/19/2018
140   uint public preIcoFinish = 1521590400; // 03/21/2018
141 
142     // Ico constants
143   uint public icoStart = 1521590401; // 03/21/2018
144   uint public icoFinish = 1529625600; //06/21/2018
145   uint icoMinCap = 300000*pow(10,decimals);
146 
147   //check is now preICO
148   function isPreIco(uint _time) constant public returns (bool){
149     if((preIcoStart <= _time) && (_time <= preIcoFinish)){
150       return true;
151     }
152     return false;
153   }
154 
155   //check is now ICO
156   function isIco(uint _time) constant public returns (bool){
157     if((icoStart <= _time) && (_time <= icoFinish)){
158       return true;
159     }
160     return false;
161   }
162 
163   //crowdsale variables
164   uint public preIcoTokensSold = 0;
165   uint public iCoTokensSold = 0;
166   uint public tokensSold = 0;
167   uint public ethCollected = 0;
168 
169   //Ethereum investor balances (how much Eth they're donate to ICO)
170   mapping (address => uint) public investorBalances;
171 
172   //function calculate how many tokens will be send to investor in preIco
173   function  buyIfPreIcoDiscount (uint _value) internal returns(uint,uint) {
174     uint buffer = 0;
175     uint bufferEth = 0;
176     uint bufferValue = _value;
177     uint res = 0;
178 
179     for (uint i = 0; i<structurePreIco.length; i++){
180       res = _value/(tokenPrice*structurePreIco[i].bonus/100000000000);
181 
182       //Purchase over 5,000 VGC and get extra 10% bonus
183       if(res >= (uint)(5000).mul(pow(10,decimals))){
184         res = res.add(res/10);
185       }
186       if (res<=structurePreIco[i].balance){
187         //   bufferEth = bufferEth+_value;
188         structurePreIco[i].balance = structurePreIco[i].balance.sub(res);
189         buffer = res.add(buffer);
190         return (buffer,0);
191       }else {
192         buffer = buffer.add(structurePreIco[i].balance);
193         //   bufferEth = bufferEth.add(structurePreIco[i].balance.mul(tokenPrice)/structurePreIco[i].bonus);
194         bufferEth += structurePreIco[i].balance*tokenPrice*structurePreIco[i].bonus/100000000000;
195         _value = _value.sub(structurePreIco[i].balance*tokenPrice*structurePreIco[i].bonus/100000000000);
196         structurePreIco[i].balance = 0;
197         }
198       }
199     return  (buffer,bufferValue.sub(bufferEth));
200   }
201 
202   //function calculate how many tokens will be send to investor in Ico
203   function  buyIfIcoDiscount (uint _value) internal returns(uint,uint) {
204     uint buffer = 0;
205     uint bufferEth = 0;
206     uint bufferValue = _value;
207     uint res = 0;
208 
209     for (uint i = 0; i<structureIco.length; i++){
210       res = _value/(tokenPrice*structureIco[i].bonus/100000000000);
211 
212       //Purchase over 5,000 VGC and get extra 10% bonus
213       if(res >= (uint)(5000).mul(pow(10,decimals))){
214         res = res.add(res/10);
215       }
216         if (res<=structureIco[i].balance){
217           bufferEth = bufferEth+_value;
218           structureIco[i].balance = structureIco[i].balance.sub(res);
219           buffer = res.add(buffer);
220           return (buffer,0);
221         }else {
222           buffer = buffer.add(structureIco[i].balance);
223           bufferEth += structureIco[i].balance*tokenPrice*structureIco[i].bonus/100000000000;
224           _value = _value.sub(structureIco[i].balance*tokenPrice*structureIco[i].bonus/100000000000);
225           structureIco[i].balance = 0;
226       }
227     }
228     return  (buffer,bufferValue.sub(bufferEth));
229   }
230 
231   //fallback function (when investor send ether to contract)
232   function() public payable{
233     require(msg.value >= minDeposit);
234     require(isIco(now) || isPreIco(now));
235     require(buy(msg.sender,msg.value,now,false)); //redirect to func buy
236   }
237 
238   bool public preIcoEnded = false;
239   //function buy Tokens
240   function buy(address _address, uint _value, uint _time, bool dashboard) internal returns (bool){
241     uint tokensForSend;
242     uint etherForSend;
243     if (isPreIco(_time)){
244       (tokensForSend,etherForSend) = buyIfPreIcoDiscount(_value);
245       assert (tokensForSend >= 50*pow(10,decimals));
246       preIcoTokensSold += tokensForSend;
247       if (etherForSend!=0 && !dashboard){
248         _address.transfer(etherForSend);
249       }
250       owner.transfer(this.balance);
251     }
252     if (isIco(_time)){
253       if(!preIcoEnded){
254         for (uint i = 0; i<structurePreIco.length; i++){
255           structureIco[structureIco.length-1].balance = structureIco[structureIco.length-1].balance.add(structurePreIco[i].balance);
256           structurePreIco[i].balance = 0;
257         }
258        preIcoEnded = true;
259       }
260       (tokensForSend,etherForSend) = buyIfIcoDiscount(_value);
261       assert (tokensForSend >= 50*pow(10,decimals));
262       iCoTokensSold += tokensForSend;
263 
264       if (etherForSend!=0 && !dashboard){
265         _address.transfer(etherForSend);
266       }
267       investorBalances[_address] += _value.sub(etherForSend);
268 
269       if (isIcoTrue()){
270         owner.transfer(this.balance);
271       }
272     }
273 
274     tokensSold += tokensForSend;
275 
276     token.sendCrowdsaleBalance(_address,tokensForSend);
277 
278     ethCollected = ethCollected.add(_value.sub(etherForSend));
279 
280     return true;
281   }
282 
283   //someone can end ICO using this function (require 3 days after ICO end)
284   function finishIco() public {
285     require (now > icoFinish + 3 days);
286     require (token.getRefBalSended());
287     for (uint i = 0; i<structureIco.length; i++){
288       structureIco[i].balance = 0;
289     }
290     for (i = 0; i<structurePreIco.length; i++){
291       structurePreIco[i].balance = 0;
292     }
293     token.finishIco();
294   }
295 
296   //function check is ICO complete (minCap exceeded)
297   function isIcoTrue() public constant returns (bool){
298     if (tokensSold >= icoMinCap){
299       return true;
300     }
301     return false;
302   }
303 
304   //if ICO failed and now = ICO finished date +3 days then investor can withdrow his ether
305   function refund() public{
306     require (!isIcoTrue());
307     require (icoFinish + 3 days <= now);
308 
309     token.burnTokens(msg.sender);
310     msg.sender.transfer(investorBalances[msg.sender]);
311     investorBalances[msg.sender] = 0;
312   }
313 
314 
315   //ICO cabinets function
316   function sendEtherManually(address _address, uint _value) public onlyTechSupport{
317     require(buy(_address,_value,now,true));
318   }
319 
320   //ICO cabinets function, just for view
321   function tokensCount(uint _value) public view onlyTechSupport returns(uint res) {
322     if (isPreIco(now)){
323       (res,) = buyIfPreIcoDiscount(_value);
324     }
325     if (isIco(now)){
326       (res,) = buyIfIcoDiscount(_value);
327     }
328     return res;
329   }
330 
331   function getEtherBalanceOnCrowdsale() public view returns(uint) {
332     return this.balance;
333   }
334 }