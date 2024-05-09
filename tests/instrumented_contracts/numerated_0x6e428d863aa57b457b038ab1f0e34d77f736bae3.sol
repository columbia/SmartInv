1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal constant returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract IOwned {
31   function owner() public constant returns (address) { owner; }
32   function transferOwnership(address _newOwner) public;
33 }
34 
35 contract Owned is IOwned {
36   address public owner;
37 
38   function Owned() public {
39     owner = msg.sender;
40   }
41 
42   modifier validAddress(address _address) {
43     require(_address != 0x0);
44     _;
45   }
46   modifier onlyOwner {
47     assert(msg.sender == owner);
48     _;
49   }
50   
51   function transferOwnership(address _newOwner) public validAddress(_newOwner) onlyOwner {
52     require(_newOwner != owner);
53     
54     owner = _newOwner;
55   }
56 }
57 
58 
59 
60 contract IERC20Token {
61   function name() public constant returns (string) { name; }
62   function symbol() public constant returns (string) { symbol; }
63   function decimals() public constant returns (uint8) { decimals; }
64   function totalSupply() public constant returns (uint256) { totalSupply; }
65   function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
66   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
67 
68   function transfer(address _to, uint256 _value) public returns (bool);
69   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
70   function approve(address _spender, uint256 _value) public returns (bool);
71 }
72 
73 contract ERC20Token is IERC20Token {
74   using SafeMath for uint256;
75 
76   string public standard = 'Token 0.1';
77   string public name = '';
78   string public symbol = '';
79   uint8 public decimals = 0;
80   uint256 public totalSupply = 0;
81   mapping (address => uint256) public balanceOf;
82   mapping (address => mapping (address => uint256)) public allowance;
83 
84   event Transfer(address indexed _from, address indexed _to, uint256 _value);
85   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86 
87   function ERC20Token(string _name, string _symbol, uint8 _decimals) public {
88     require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
89     name = _name;
90     symbol = _symbol;
91     decimals = _decimals;
92   }
93 
94   modifier validAddress(address _address) {
95     require(_address != 0x0);
96     _;
97   }
98 
99   function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool) {
100     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
101     balanceOf[_to] = balanceOf[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     
104     return true;
105   }
106 
107   function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {
108     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
109     balanceOf[_from] = balanceOf[_from].sub(_value);
110     balanceOf[_to] = balanceOf[_to].add(_value);
111     Transfer(_from, _to, _value);
112     return true;
113   }
114 
115   function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool) {
116     require(_value == 0 || allowance[msg.sender][_spender] == 0);
117     allowance[msg.sender][_spender] = _value;
118     Approval(msg.sender, _spender, _value);
119     return true;
120   }
121 }
122 
123 
124 contract ISerenityToken {
125   function initialSupply () public constant returns (uint256) { initialSupply; }
126 
127   function totalSoldTokens () public constant returns (uint256) { totalSoldTokens; }
128   function totalProjectToken() public constant returns (uint256) { totalProjectToken; }
129 
130   function fundingEnabled() public constant returns (bool) { fundingEnabled; }
131   function transfersEnabled() public constant returns (bool) { transfersEnabled; }
132 }
133 
134 contract SerenityToken is ISerenityToken, ERC20Token, Owned {
135   using SafeMath for uint256;
136  
137   address public fundingWallet;
138   bool public fundingEnabled = true;
139   uint256 public maxSaleToken = 3500000;
140   uint256 public initialSupply = 350000 ether;
141   uint256 public totalSoldTokens;
142   uint256 public totalProjectToken;
143   uint256 private totalLockToken;
144   bool public transfersEnabled = false; 
145 
146   mapping (address => bool) private fundingWallets;
147   mapping (address => allocationLock) public allocations;
148 
149   struct allocationLock {
150     uint256 value;
151     uint256 end;
152     bool locked;
153   }
154 
155   event Finalize(address indexed _from, uint256 _value);
156   event Lock(address indexed _from, address indexed _to, uint256 _value, uint256 _end);
157   event Unlock(address indexed _from, address indexed _to, uint256 _value);
158   event DisableTransfers(address indexed _from);
159 
160   function SerenityToken() ERC20Token("SERENITY INVEST", "SERENITY", 18) public {
161     fundingWallet = msg.sender; 
162 
163     balanceOf[fundingWallet] = maxSaleToken;
164 
165     fundingWallets[fundingWallet] = true;
166     fundingWallets[0x47c8F28e6056374aBA3DF0854306c2556B104601] = true;
167   }
168 
169   modifier validAddress(address _address) {
170     require(_address != 0x0);
171     _;
172   }
173 
174   modifier transfersAllowed(address _address) {
175     if (fundingEnabled) {
176       require(fundingWallets[_address]);
177     }
178 
179     require(transfersEnabled);
180     _;
181   }
182 
183   function transfer(address _to, uint256 _value) public validAddress(_to) transfersAllowed(msg.sender) returns (bool) {
184     return super.transfer(_to, _value);
185   }
186 
187   function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) transfersAllowed(_from) returns (bool) {
188     return super.transferFrom(_from, _to, _value);
189   }
190 
191   function lock(address _to, uint256 _value, uint256 _end) internal validAddress(_to) onlyOwner returns (bool) {
192     require(_value > 0);
193 
194     assert(totalProjectToken > 0);
195     totalLockToken = totalLockToken.add(_value);
196     assert(totalProjectToken >= totalLockToken);
197 
198     require(allocations[_to].value == 0);
199 
200     // Assign a new lock.
201     allocations[_to] = allocationLock({
202       value: _value,
203       end: _end,
204       locked: true
205     });
206 
207     Lock(this, _to, _value, _end);
208 
209     return true;
210   }
211 
212   function unlock() external {
213     require(allocations[msg.sender].locked);
214     require(now >= allocations[msg.sender].end);
215     
216     balanceOf[msg.sender] = balanceOf[msg.sender].add(allocations[msg.sender].value);
217 
218     allocations[msg.sender].locked = false;
219 
220     Transfer(this, msg.sender, allocations[msg.sender].value);
221     Unlock(this, msg.sender, allocations[msg.sender].value);
222   }
223 
224   function finalize() external onlyOwner {
225     require(fundingEnabled);
226     
227     totalSoldTokens = maxSaleToken.sub(balanceOf[fundingWallet]);
228 
229     totalProjectToken = totalSoldTokens.mul(15).div(100);
230 
231     lock(0x47c8F28e6056374aBA3DF0854306c2556B104601, totalProjectToken, now);
232     
233     // Zeroing a cold wallet.
234     balanceOf[fundingWallet] = 0;
235 
236     // End of crowdfunding.
237     fundingEnabled = false;
238     transfersEnabled = true;
239 
240     // End of crowdfunding.
241     Transfer(this, fundingWallet, 0);
242     Finalize(msg.sender, totalSupply);
243   }
244 
245   function disableTransfers() external onlyOwner {
246     require(transfersEnabled);
247 
248     transfersEnabled = false;
249 
250     DisableTransfers(msg.sender);
251   }
252 
253   function disableFundingWallets(address _address) external onlyOwner {
254     require(fundingEnabled);
255     require(fundingWallet != _address);
256     require(fundingWallets[_address]);
257 
258     fundingWallets[_address] = false;
259   }
260 }
261 
262 
263 
264 contract Crowdsale {
265   using SafeMath for uint256;
266 
267   SerenityToken public token;
268 
269   mapping(uint256 => uint8) icoWeeksDiscounts; 
270 
271   uint256 public preStartTime = 1510704000;
272   uint256 public preEndTime = 1512086400; 
273 
274   bool public isICOStarted = false; 
275   uint256 public icoStartTime; 
276   uint256 public icoEndTime; 
277 
278   address public wallet = 0x47c8F28e6056374aBA3DF0854306c2556B104601;
279   uint256 public tokensPerEth = 10;
280   uint256 public weiRaised;
281   uint256 public ethRaised;
282 
283   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
284 
285   modifier validAddress(address _address) {
286     require(_address != 0x0);
287     _;
288   }
289 
290   function Crowdsale() public {
291     token = createTokenContract();
292     initDiscounts();
293   }
294 
295   function initDiscounts() internal {
296     icoWeeksDiscounts[0] = 40;
297     icoWeeksDiscounts[1] = 35;
298     icoWeeksDiscounts[2] = 30;
299     icoWeeksDiscounts[3] = 25;
300     icoWeeksDiscounts[4] = 20;
301     icoWeeksDiscounts[5] = 10;
302   }
303 
304   function createTokenContract() internal returns (SerenityToken) {
305     return new SerenityToken();
306   }
307 
308   function () public payable {
309     buyTokens(msg.sender);
310   }
311 
312   function getTimeDiscount() internal returns(uint8) {
313     require(isICOStarted == true);
314     require(icoStartTime < now);
315     require(icoEndTime > now);
316 
317     uint256 weeksPassed = (now - icoStartTime) / 7 days;
318     return icoWeeksDiscounts[weeksPassed];
319   } 
320 
321   function getTotalSoldDiscount() internal returns(uint8) {
322     require(isICOStarted == true);
323     require(icoStartTime < now);
324     require(icoEndTime > now);
325 
326     uint256 totalSold = token.totalSoldTokens();
327 
328     if (totalSold < 150000)
329       return 50;
330     else if (totalSold < 250000)
331       return 40;
332     else if (totalSold < 500000)
333       return 35;
334     else if (totalSold < 700000)
335       return 30;
336     else if (totalSold < 1100000)
337       return 25;
338     else if (totalSold < 2100000)
339       return 20;
340     else if (totalSold < 3500000)
341       return 10;
342   }
343 
344   function getDiscount() internal constant returns (uint8) {
345     if (!isICOStarted)
346       return 50;
347     else {
348       uint8 timeDiscount = getTimeDiscount();
349       uint8 totalSoldDiscount = getTotalSoldDiscount();
350 
351       if (timeDiscount < totalSoldDiscount)
352         return timeDiscount;
353       else 
354         return totalSoldDiscount;
355     }
356   }
357 
358   function buyTokens(address beneficiary) public validAddress(beneficiary) payable {
359     require(validPurchase());
360     require(msg.value > 1 ether);
361 
362     uint256 ethAmount = msg.value / 1 ether;
363 
364     uint8 discountPercents = getDiscount();
365     uint256 costWithDiscount = tokensPerEth.div(100 - discountPercents).mul(100);
366     uint256 tokens = ethAmount.mul(costWithDiscount);
367 
368     weiRaised = weiRaised.add(ethAmount * 1 ether);
369 
370     token.transfer(beneficiary, tokens);
371     TokenPurchase(msg.sender, beneficiary, ethAmount * 1 ether , tokens);
372 
373     forwardFunds();
374   }
375 
376   function activeteICO(uint256 _icoEndTime) public {
377     require(msg.sender == wallet);
378     require(_icoEndTime >= now);
379     require(_icoEndTime >= preEndTime);
380     require(isICOStarted == false);
381       
382     isICOStarted = true;
383     icoEndTime = _icoEndTime;
384   }
385 
386   function forwardFunds() internal {
387     wallet.transfer(msg.value);
388   }
389 
390   function validPurchase() internal constant returns (bool) {
391     bool withinPresalePeriod = now >= preStartTime && now <= preEndTime;
392     bool withinICOPeriod = isICOStarted && now >= icoStartTime && now <= icoEndTime;
393 
394     bool nonZeroPurchase = msg.value != 0;
395     
396     return (withinPresalePeriod || withinICOPeriod) && nonZeroPurchase;
397   }
398 }