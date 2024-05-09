1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6   function Ownable() public {
7     owner = msg.sender;
8   }
9   modifier onlyOwner() {
10     require(msg.sender == owner);
11     _;
12   }
13   function transferOwnership(address newOwner) public onlyOwner {
14     require(newOwner != address(0));
15     OwnershipTransferred(owner, newOwner);
16     owner = newOwner;
17   }
18 }
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a / b;
30     return c;
31   }
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 contract ERC20 is ERC20Basic {
49   function allowance(address owner, address spender) public view returns (uint256);
50   function transferFrom(address from, address to, uint256 value) public returns (bool);
51   function approve(address spender, uint256 value) public returns (bool);
52   event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56   mapping(address => uint256) balances;
57   function transfer(address _to, uint256 _value) public returns (bool) {
58     require(_to != address(0));
59     require(_value <= balances[msg.sender]);
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     Transfer(msg.sender, _to, _value);
63     return true;
64   }
65   function balanceOf(address _owner) public view returns (uint256 balance) {
66     return balances[_owner];
67   }
68 }
69 contract StandardToken is ERC20, BasicToken {
70   mapping (address => mapping (address => uint256)) internal allowed;
71   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[_from]);
74     require(_value <= allowed[_from][msg.sender]);
75     balances[_from] = balances[_from].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78     Transfer(_from, _to, _value);
79     return true;
80   }
81   function approve(address _spender, uint256 _value) public returns (bool) {
82     allowed[msg.sender][_spender] = _value;
83     Approval(msg.sender, _spender, _value);
84     return true;
85   }
86   function allowance(address _owner, address _spender) public view returns (uint256) {
87     return allowed[_owner][_spender];
88   }
89   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
90     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
91     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
92     return true;
93   }
94   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
95     uint oldValue = allowed[msg.sender][_spender];
96     if (_subtractedValue > oldValue) {
97       allowed[msg.sender][_spender] = 0;
98     } else {
99       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
100     }
101     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102     return true;
103   }
104 }
105 
106 contract BurnableToken is StandardToken {
107   event Burn(address indexed burner, uint256 value);
108   function burn(uint256 _value) public {
109     require(_value > 0);
110     require(_value <= balances[msg.sender]);
111     address burner = msg.sender;
112     balances[burner] = balances[burner].sub(_value);
113     totalSupply = totalSupply.sub(_value);
114     Burn(burner, _value);
115   }
116 }
117 contract KimJCoin is BurnableToken {
118   string public constant name = "KimJ Coin";
119   string public constant symbol = "KJC";
120   uint32 public constant decimals = 18;
121   uint256 public constant INITIAL_SUPPLY = 20000000 *(10 ** 18);  
122   address public giveAddress = 0xacc31A27A5Ce81cB7b6269003226024963016F37;
123   function KimJCoin() public {
124     uint256 _keep = 90;
125     uint256 _giveTokens = 10;
126 
127     totalSupply = INITIAL_SUPPLY;
128     balances[msg.sender] = INITIAL_SUPPLY.mul(_keep).div(100);
129     balances[giveAddress] = INITIAL_SUPPLY.mul(_giveTokens).div(100);
130   }
131   
132   function AddressDefault() public view returns (address){
133     return giveAddress;
134   }
135   
136 }
137 
138 contract ICO is Ownable {
139 
140   using SafeMath for uint256;
141 
142   KimJCoin public token;
143 
144   address multisig;
145   address restricted;
146 
147   uint256 rate;
148   uint256 minAmount;
149 
150   uint256 preIcoStartDate;
151   uint256 preIcoEndDate;
152   
153   uint256 tier1StartDate;
154   uint256 tier1EndDate;
155   uint256 tier2StartDate;
156   uint256 tier2EndDate;
157 
158   uint256 percentsTeamTokens;
159   uint256 percentsBountySecondTokens;
160   uint256 percentsBountyFirstTokens;
161   uint256 percentsNuclearTokens;
162   uint256 percentsBounty;
163   uint256 percentsPreSaleTokens;
164   uint256 percentsIco1;
165   uint256 percentsIco2;
166   uint256 totaldivineTokensIssued;
167   uint256 totalEthereumRaised;
168   modifier saleIsOn() {
169     uint256 curState = getStatus();
170     require(curState != 0);
171     _;
172   }
173 
174   modifier isUnderHardCap() {
175     uint256 _availableTokens = token.balanceOf(this);
176     uint256 _tokens = calculateTokens(msg.value);
177     uint256 _minTokens = holdTokensOnStage();
178     require(_availableTokens.sub(_tokens) >= _minTokens);
179     _;
180   }
181 
182   modifier checkMinAmount() {
183     require(msg.value >= minAmount);
184     _;
185   }
186   function ICO() public {
187     
188    token   =  new KimJCoin();
189     multisig = msg.sender;
190     restricted = msg.sender;
191     minAmount = 0.01 * 1 ether;
192     rate = 1000;
193 
194   preIcoStartDate = 1519257600  ;
195     preIcoEndDate = 1521072000;  
196   
197   tier1StartDate = 1521072000;
198   tier1EndDate = 1522540800;
199   
200   tier2StartDate = 1522540800;
201   tier2EndDate = 1525132800;
202   
203     percentsTeamTokens = 15;
204     percentsBountySecondTokens = 5;
205   percentsBountyFirstTokens = 5;
206   percentsNuclearTokens = 5;
207   percentsBounty = 10;
208   
209     percentsPreSaleTokens = 30;
210     percentsIco1 = 25;
211   percentsIco2 = 15;
212   totaldivineTokensIssued = 0;
213   totalEthereumRaised = 0;
214   }
215 
216   function calculateTokens(uint256 value) internal constant returns (uint256) {
217     uint256 tokensOrig = rate.mul(value).div(1 ether).mul(10 ** 18);
218     uint256 tokens = rate.mul(value).div(1 ether).mul(10 ** 18);
219     uint256 curState = getStatus();
220     if(curState== 1){
221       tokens += tokens.div(2);
222     }
223   
224     bytes20 divineHash = ripemd160(block.coinbase, block.number, block.timestamp);
225     if (divineHash[0] == 0) 
226     {
227       uint256 divineMultiplier;
228       if (curState==1){
229         divineMultiplier = 4;
230       }
231       else if (curState==2){
232         divineMultiplier = 3;
233       }
234       else if (curState==3){
235         divineMultiplier = 2;
236       }
237       else{
238         divineMultiplier = 1;
239       }
240       
241       uint256 divineTokensIssued = tokensOrig.mul(divineMultiplier);
242       tokens += divineTokensIssued;
243       totaldivineTokensIssued.add(divineTokensIssued);
244     }
245 
246   
247   
248     return tokens;
249   }
250 
251   // 0 - stop
252   // 1 - preSale
253   // 2 - sale 1
254   // 3 - sale 2
255   function getStatus() internal constant returns (uint256) {
256     if(now > tier2EndDate) {
257       return 0;
258     } else if(now > tier2StartDate && now < tier2EndDate) {
259       return 3;
260     } else if(now > tier1StartDate && now < tier1EndDate) {
261       return 2;
262     } else if(now > preIcoStartDate && now < preIcoEndDate){
263       return 1;
264     } else {
265       return 0;
266     }
267   }
268 
269   function holdTokensOnStage() public view returns (uint256) {
270     uint256 _totalSupply = token.totalSupply();
271     uint256 _percents = 100;
272     uint256 curState = getStatus();
273     if(curState == 3) {
274       _percents = percentsTeamTokens+percentsNuclearTokens;  //100 - (30+10+25+15) = 20
275     } else if(curState == 2) {
276       _percents = _percents.sub(percentsPreSaleTokens.add(percentsBounty).add(percentsIco1));  //100 - (30+10+25) = 35
277     } else if(curState == 1) {
278       _percents = _percents.sub(percentsPreSaleTokens.add(percentsBounty)); //100 - (30+10) = 60
279     }
280 
281     return _totalSupply.mul(_percents).div(100);
282   }
283 
284   function onBalance() public view returns (uint256) {
285     return token.balanceOf(this);
286   }
287 
288   function availableTokensOnCurrentStage() public view returns (uint256) {
289     uint256 _currentHolder = token.balanceOf(this);
290     uint256 _minTokens = holdTokensOnStage();
291     return _currentHolder.sub(_minTokens);
292   }
293 
294   function getStatusInfo() public view returns (string) {
295     uint256 curState = getStatus();
296     if(now > tier2EndDate) {
297       return "ICO is over";
298     } else if(curState == 3) {
299       return "Now ICO #2 is active";
300     } else if(curState == 2) {
301       return "Now ICO #1 is active";
302     } else if(curState == 1) {
303       return "Now Pre-ICO is active";
304     } else {
305       return "The sale of tokens is stopped";
306     }
307   }
308 
309   // burn the rest
310   // keep nuc and team tokens
311   function burnTokens() public onlyOwner {
312     require(now > tier2EndDate);
313     uint256 circulating = token.totalSupply().sub(token.balanceOf(this));
314 
315     uint256 _teamTokens = circulating.mul(percentsTeamTokens).div(100 - percentsTeamTokens-percentsNuclearTokens);
316     uint256 _nucTokens = circulating.mul(percentsNuclearTokens).div(100 - percentsTeamTokens-percentsNuclearTokens);
317 
318     // safety check. The math should work out, but this is here just in case
319     if (_teamTokens.add(_nucTokens)>token.balanceOf(this)){
320       _nucTokens = token.balanceOf(this).sub(_teamTokens);
321     }
322 
323     token.transfer(restricted, _teamTokens);
324     token.transfer(token.AddressDefault(), _nucTokens);
325     uint256 _burnTokens = token.balanceOf(this);
326     if (_burnTokens>0){
327       token.burn(_burnTokens);
328     }
329   }
330 
331   function createTokens() public saleIsOn isUnderHardCap checkMinAmount payable {
332     uint256 tokens = calculateTokens(msg.value);
333     totalEthereumRaised.add(msg.value);
334     multisig.transfer(msg.value);
335     token.transfer(msg.sender, tokens);
336   }
337 
338 
339   function() external payable {
340     createTokens();
341   }
342   
343   function getStats() public constant returns (uint256, uint256, uint256) {
344         return (totalEthereumRaised, token.totalSupply(), totaldivineTokensIssued);
345     }
346 }