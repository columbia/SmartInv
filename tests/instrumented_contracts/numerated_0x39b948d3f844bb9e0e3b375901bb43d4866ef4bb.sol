1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract owned {
31     address public owner;
32 
33     function owned() public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 }
42 
43 contract ERC20Basic {
44   uint256 public totalSupply;
45   function balanceOf(address owner) public constant returns (uint256 balance);
46   function transfer(address to, uint256 value) public returns (bool success);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49  
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public constant returns (uint256 remaining);
52   function transferFrom(address from, address to, uint256 value) public returns (bool success);
53   function approve(address spender, uint256 value) public returns (bool success);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 contract BasicToken is ERC20Basic {
58     
59   using SafeMath for uint256;
60  
61   mapping (address => uint256) public balances;
62  
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to] && _value > 0 && _to != address(this) && _to != address(0)); 
65     balances[msg.sender] = balances[msg.sender].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     Transfer(msg.sender, _to, _value);
68     return true;
69   }
70 
71   function balanceOf(address _owner) public constant returns (uint256 balance) {
72     return balances[_owner];
73   }
74 }
75 
76 contract StandardToken is ERC20, BasicToken {
77 
78   mapping (address => mapping (address => uint256)) allowed;
79  
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to] && _value > 0 && _to != address(this) && _to != address(0));
82     uint _allowance = allowed[_from][msg.sender];
83     balances[_to] = balances[_to].add(_value);
84     balances[_from] = balances[_from].sub(_value);
85     allowed[_from][msg.sender] = _allowance.sub(_value);
86     Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   function approve(address _spender, uint256 _value) public returns (bool) {
91       require (((_value == 0) || (allowed[msg.sender][_spender] == 0)) && _spender != address(this) && _spender != address(0));
92       allowed[msg.sender][_spender] = _value;
93       Approval(msg.sender, _spender, _value);
94       return true;
95   }
96 
97   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
98     return allowed[_owner][_spender];
99   }
100  
101 }
102 
103 contract UNICToken is owned, StandardToken {
104     
105   string public constant name = 'UNIC Token';
106   string public constant symbol = 'UNIC';
107   uint8 public constant decimals = 18;
108   uint256 public constant initialSupply = 250000000 * 10 ** uint256(decimals);
109 
110   function UNICToken() public onlyOwner {
111     totalSupply = initialSupply;
112     balances[msg.sender] = initialSupply;
113   }
114 
115 }
116 
117 contract Crowdsale is owned, UNICToken {
118     
119   using SafeMath for uint;
120   
121   UNICToken public token = new UNICToken();
122 
123   address constant multisig = 0x867570869f8a46c685A51EE87b5D979A6ef657A9;
124   uint constant rate = 3400;
125 
126   uint256 public constant forSale = 55000000 * 10 ** uint256(decimals);
127 
128   uint public constant presaleWhitelistDiscount = 40;
129   uint public presaleWhitelistTokensLimit = 750000 * 10 ** uint256(decimals);
130 
131   uint public constant presaleStart = 1520503200;           /** 08.03 */
132   uint public constant presaleEnd = 1521453600;             /** 19.03 */
133   uint public constant presaleDiscount = 30;
134   uint public presaleTokensLimit = 5000000 * 10 ** uint256(decimals);
135 
136   uint public constant firstRoundICOStart = 1522317600;      /** 29.03 */
137   uint public constant firstRoundICOEnd = 1523527200;        /** 12.04 */
138   uint public constant firstRoundICODiscount = 20;
139   uint public firstRoundICOTokensLimit = 6250000 * 10 ** uint256(decimals);
140 
141   uint public constant secondRoundICOStart = 1524736800;     /** 26.04 */
142   uint public constant secondRoundICOEnd = 1526551200;       /** 17.05 */
143   uint public constant secondRoundICODiscount = 10;
144   uint public secondRoundICOTokensLimit = 43750000 * 10 ** uint256(decimals);
145 
146   uint public constant presaleFemaleStart = 1520467200;       /** 08.03 */
147   uint public constant presaleFemaleEnd = 1520553600;         /** 09.03 */
148   uint public constant presaleFemaleDiscount = 88;
149   uint public presaleFemaleTokensLimit = 88888 * 10 ** uint256(decimals);  
150 
151   uint public constant presalePiStart = 1520985600;           /** 14.03 The day of number PI */
152   uint public constant presalePiEnd = 1521072000;             /** 15.03 */
153   uint public constant presalePiDiscount = 34;
154   uint public presalePiTokensLimit = 31415926535897932384626;
155 
156   uint public constant firstRoundWMStart = 1522800000;           /** 04.04 The Day of webmaster 404 */
157   uint public constant firstRoundWMEnd = 1522886400;             /** 05.04 */
158   uint public constant firstRoundWMDiscount = 25;
159   uint public firstRoundWMTokensLimit = 404404 * 10 ** uint256(decimals);
160 
161   uint public constant firstRoundCosmosStart = 1523491200;       /** 12.04 The day of cosmonautics */
162   uint public constant firstRoundCosmosEnd = 1523577600;         /** 13.04 */
163   uint public constant firstRoundCosmosDiscount = 25;
164   uint public firstRoundCosmosTokensLimit = 121961 * 10 ** uint256(decimals);
165 
166   uint public constant secondRoundMayStart = 1525132800;          /** 01.05 International Solidarity Day for Workers */
167   uint public constant secondRoundMayEnd = 1525219200;            /** 02.05 */
168   uint public constant secondRoundMayDiscount = 15;
169   uint public secondRoundMayTokensLimit = 1111111 * 10 ** uint256(decimals);
170 
171   uint public etherRaised = 0;
172   uint public tokensSold = 0;
173 
174   address public icoManager;
175     
176   mapping (address => bool) public WhiteList;
177   mapping (address => bool) public Females;
178 
179   mapping (address => bool) public KYC1;
180   mapping (address => bool) public KYC2;
181   mapping (address => uint256) public KYCLimit;
182   uint256 public constant KYCLimitValue = 1.5 ether;
183 
184   modifier onlyManager() {
185     require(msg.sender == icoManager);
186     _;
187   }
188 
189   function setICOManager(address _newIcoManager) public onlyOwner returns (bool) {
190     require(_newIcoManager != address(0));
191     icoManager = _newIcoManager;
192     return true;
193   }
194 
195   function massPay(address[] dests, uint256 value) public onlyOwner returns (bool) {
196     uint256 i = 0;
197     uint256 toSend = value * 10 ** uint256(decimals);
198     while (i < dests.length) {
199       if(dests[i] != address(0)){
200         transfer(dests[i], toSend);
201       }
202       i++;
203     }
204     return true;
205   }
206 
207   function Crowdsale() public onlyOwner {
208     token = UNICToken(this);
209     balances[msg.sender] = balances[msg.sender].sub(forSale);
210     balances[token] = balances[token].add(forSale);
211   }
212 
213   function setParams(address[] dests, uint _type) internal {
214     uint256 i = 0;
215     while (i < dests.length) {
216       if(dests[i] != address(0)){
217         if(_type==1){
218           WhiteList[dests[i]] = true;
219         }else if(_type==2){
220           Females[dests[i]] = true;
221         }else if(_type==3){
222           KYC1[dests[i]] = true;
223           KYCLimit[dests[i]] = KYCLimitValue;
224         }else if(_type==4){
225           KYC2[dests[i]] = true;
226         }
227       }
228       i++;
229     }
230   } 
231 
232   function setWhiteList(address[] dests) onlyManager external {
233     setParams(dests, 1);
234   }
235 
236   function setFemaleBonus(address[] dests) onlyManager external {
237     setParams(dests, 2);
238   }
239 
240   function setKYCLimited(address[] dests) onlyManager external {
241     setParams(dests, 3);
242   }
243 
244   function setKYCFull(address[] dests) onlyManager external {
245     setParams(dests, 4);
246   }
247 
248   function isPresale() internal view returns (bool) {
249     return now >= presaleStart && now <= presaleEnd;
250   }
251 
252   function isFirstRound() internal view returns (bool) {
253     return now >= firstRoundICOStart && now <= firstRoundICOEnd;
254   }
255 
256   function isSecondRound() internal view returns (bool) {
257     return now >= secondRoundICOStart && now <= secondRoundICOEnd;
258   }
259 
260   modifier saleIsOn() {
261     require(isPresale() || isFirstRound() || isSecondRound());
262     _;
263   }
264 
265   function isFemaleSale() internal view returns (bool) {
266     return now >= presaleFemaleStart && now <= presaleFemaleEnd;
267   }
268 
269   function isPiSale() internal view returns (bool) {
270     return now >= presalePiStart && now <= presalePiEnd;
271   }
272 
273   function isWMSale() internal view returns (bool) {
274     return now >= firstRoundWMStart && now <= firstRoundWMEnd;
275   }
276 
277   function isCosmosSale() internal view returns (bool) {
278     return now >= firstRoundCosmosStart && now <= firstRoundCosmosEnd;
279   }
280 
281   function isMaySale() internal view returns (bool) {
282     return now >= secondRoundMayStart && now <= secondRoundMayEnd;
283   }
284 
285   function discount(uint _discount, uint _limit, uint _saleLimit, uint _value, uint _defultDiscount) internal pure returns(uint){
286     uint tmpDiscount = _value.mul(_discount).div(100);
287     uint newValue = _value.add(tmpDiscount);
288     if(_limit >= newValue && _saleLimit >= newValue) {
289       return tmpDiscount;
290     }else{
291       return _defultDiscount;
292     }
293   }
294 
295   function() external payable {
296     buyTokens(msg.sender);
297   }
298 
299   function buyTokens(address _buyer) saleIsOn public payable {
300     assert((_buyer != address(0) && msg.value > 0 && ((KYC1[_buyer] && msg.value < KYCLimitValue) || KYC2[_buyer])));
301     assert((KYC2[_buyer] || (KYC1[_buyer] && msg.value < KYCLimit[_buyer])));
302 
303     uint tokens = rate.mul(msg.value);
304     uint discountTokens = 0;
305     
306     if (isPresale()) {
307 
308       discountTokens = discount(presaleDiscount, presaleTokensLimit, presaleTokensLimit, tokens, discountTokens);
309 
310       if(isFemaleSale() && Females[_buyer]) {
311         discountTokens = discount(presaleFemaleDiscount, presaleFemaleTokensLimit, presaleTokensLimit, tokens, discountTokens);
312       }
313       if(WhiteList[_buyer]) {
314         discountTokens = discount(presaleWhitelistDiscount, presaleWhitelistTokensLimit, presaleTokensLimit, tokens, discountTokens);
315       }
316       if(isPiSale()) {
317         discountTokens = discount(presalePiDiscount, presalePiTokensLimit, presaleTokensLimit, tokens, discountTokens);
318       }
319 
320     } else if (isFirstRound()) {
321 
322       discountTokens = discount(firstRoundICODiscount, firstRoundICOTokensLimit, firstRoundICOTokensLimit, tokens, discountTokens);
323 
324       if(isCosmosSale()) {
325         discountTokens = discount(firstRoundCosmosDiscount, firstRoundCosmosTokensLimit, firstRoundICOTokensLimit, tokens, discountTokens);
326       }
327       if(isWMSale()) {
328         discountTokens = discount(firstRoundWMDiscount, firstRoundWMTokensLimit, firstRoundICOTokensLimit, tokens, discountTokens);
329       } 
330 
331     } else if (isSecondRound()) {
332 
333       discountTokens = discount(secondRoundICODiscount, secondRoundICOTokensLimit, secondRoundICOTokensLimit, tokens, discountTokens);
334 
335       if(isMaySale()) {
336         discountTokens = discount(secondRoundMayDiscount, secondRoundMayTokensLimit, secondRoundICOTokensLimit, tokens, discountTokens);
337       }
338 
339     }
340         
341     uint tokensWithBonus = tokens.add(discountTokens);
342       
343     if((isPresale() && presaleTokensLimit >= tokensWithBonus) ||
344       (isFirstRound() && firstRoundICOTokensLimit >=  tokensWithBonus) ||
345       (isSecondRound() && secondRoundICOTokensLimit >= tokensWithBonus)){
346       
347       multisig.transfer(msg.value);
348       etherRaised = etherRaised.add(msg.value);
349       token.transfer(msg.sender, tokensWithBonus);
350       tokensSold = tokensSold.add(tokensWithBonus);
351 
352       if(KYC1[_buyer]){
353         KYCLimit[_buyer] = KYCLimit[_buyer].sub(msg.value);
354       }
355 
356       if (isPresale()) {
357         
358         presaleTokensLimit = presaleTokensLimit.sub(tokensWithBonus);
359         
360         if(WhiteList[_buyer]) {
361           presaleWhitelistTokensLimit = presaleWhitelistTokensLimit.sub(tokensWithBonus);
362         }
363       
364         if(isFemaleSale() && Females[_buyer]) {
365           presaleFemaleTokensLimit = presaleFemaleTokensLimit.sub(tokensWithBonus);
366         }
367 
368         if(isPiSale()) {
369           presalePiTokensLimit = presalePiTokensLimit.sub(tokensWithBonus);
370         }
371 
372       } else if (isFirstRound()) {
373 
374         firstRoundICOTokensLimit = firstRoundICOTokensLimit.sub(tokensWithBonus);
375         
376         if(isWMSale()) {
377           firstRoundWMTokensLimit = firstRoundWMTokensLimit.sub(tokensWithBonus);
378         }
379       
380         if(isCosmosSale()) {
381           firstRoundCosmosTokensLimit = firstRoundCosmosTokensLimit.sub(tokensWithBonus);
382         }
383 
384       } else if (isSecondRound()) {
385 
386         secondRoundICOTokensLimit = secondRoundICOTokensLimit.sub(tokensWithBonus);
387 
388         if(isMaySale()) {
389           secondRoundMayTokensLimit = secondRoundMayTokensLimit.sub(tokensWithBonus);
390         }
391 
392       }
393 
394     }
395 
396   }
397 
398 }