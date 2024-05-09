1 pragma solidity ^0.4.18;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract IERC20Token {
34   function name() public constant returns (string) { name; }
35   function symbol() public constant returns (string) { symbol; }
36   function decimals() public constant returns (uint8) { decimals; }
37   function totalSupply() public constant returns (uint256) { totalSupply; }
38   function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
39   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
40 
41   function transfer(address _to, uint256 _value) public returns (bool);
42   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
43   function approve(address _spender, uint256 _value) public returns (bool);
44 }
45 
46 contract ERC20Token is IERC20Token {
47   using SafeMath for uint256;
48 
49   string public standard = 'Token 0.1';
50   string public name = '';
51   string public symbol = '';
52   uint8 public decimals = 0;
53   uint256 public totalSupply = 0;
54   mapping (address => uint256) public balanceOf;
55   mapping (address => mapping (address => uint256)) public allowance;
56 
57   event Transfer(address indexed _from, address indexed _to, uint256 _value);
58   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 
60   function ERC20Token(string _name, string _symbol, uint8 _decimals) public {
61     require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
62     name = _name;
63     symbol = _symbol;
64     decimals = _decimals;
65   }
66 
67   modifier validAddress(address _address) {
68     require(_address != 0x0);
69     _;
70   }
71 
72   function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool) {
73     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
74     balanceOf[_to] = balanceOf[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     
77     return true;
78   }
79 
80   function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {
81     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
82     balanceOf[_from] = balanceOf[_from].sub(_value);
83     balanceOf[_to] = balanceOf[_to].add(_value);
84     Transfer(_from, _to, _value);
85     return true;
86   }
87 
88   function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool) {
89     require(_value == 0 || allowance[msg.sender][_spender] == 0);
90     allowance[msg.sender][_spender] = _value;
91     Approval(msg.sender, _spender, _value);
92     return true;
93   }
94 }
95 
96 
97 contract IOwned {
98   function owner() public constant returns (address) { owner; }
99   function transferOwnership(address _newOwner) public;
100 }
101 
102 contract Owned is IOwned {
103   address public owner;
104 
105   function Owned() public {
106     owner = msg.sender;
107   }
108 
109   modifier validAddress(address _address) {
110     require(_address != 0x0);
111     _;
112   }
113   modifier onlyOwner {
114     assert(msg.sender == owner);
115     _;
116   }
117   
118   function transferOwnership(address _newOwner) public validAddress(_newOwner) onlyOwner {
119     require(_newOwner != owner);
120     
121     owner = _newOwner;
122   }
123 }
124 
125 
126 contract ISerenityToken {
127   function initialSupply () public constant returns (uint256) { initialSupply; }
128 
129   function totalSoldTokens () public constant returns (uint256) { totalSoldTokens; }
130   function totalProjectToken() public constant returns (uint256) { totalProjectToken; }
131 
132   function fundingEnabled() public constant returns (bool) { fundingEnabled; }
133   function transfersEnabled() public constant returns (bool) { transfersEnabled; }
134 }
135 
136 contract SerenityToken is ISerenityToken, ERC20Token, Owned {
137   using SafeMath for uint256;
138  
139   address public fundingWallet;
140   bool public fundingEnabled = true;
141   uint256 public maxSaleToken = 3500000;
142   uint256 public initialSupply = 350000 ether;
143   uint256 public totalSoldTokens;
144   uint256 public totalProjectToken;
145   uint256 private totalLockToken;
146   bool public transfersEnabled = false; 
147 
148   mapping (address => bool) private fundingWallets;
149   mapping (address => allocationLock) public allocations;
150 
151   struct allocationLock {
152     uint256 value;
153     uint256 end;
154     bool locked;
155   }
156 
157   event Finalize(address indexed _from, uint256 _value);
158   event Lock(address indexed _from, address indexed _to, uint256 _value, uint256 _end);
159   event Unlock(address indexed _from, address indexed _to, uint256 _value);
160   event DisableTransfers(address indexed _from);
161 
162   function SerenityToken() ERC20Token("SERENITY INVEST", "SERENITY", 18) public {
163     fundingWallet = msg.sender; 
164 
165     balanceOf[fundingWallet] = maxSaleToken;
166     balanceOf[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f] = maxSaleToken;
167     balanceOf[0x47c8F28e6056374aBA3DF0854306c2556B104601] = maxSaleToken;
168 
169     fundingWallets[fundingWallet] = true;
170     fundingWallets[0x47c8F28e6056374aBA3DF0854306c2556B104601] = true;
171     fundingWallets[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f] = true;
172   }
173 
174   modifier validAddress(address _address) {
175     require(_address != 0x0);
176     _;
177   }
178 
179   modifier transfersAllowed(address _address) {
180     if (fundingEnabled) {
181       require(fundingWallets[_address]);
182     }
183     else {
184       require(transfersEnabled);
185     }
186     _;
187   }
188 
189   function transfer(address _to, uint256 _value) public validAddress(_to) transfersAllowed(msg.sender) returns (bool) {
190     return super.transfer(_to, _value);
191   }
192 
193   function autoTransfer(address _to, uint256 _value) public validAddress(_to) onlyOwner returns (bool) {
194     return super.transfer(_to, _value);
195   }
196 
197   function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) transfersAllowed(_from) returns (bool) {
198     return super.transferFrom(_from, _to, _value);
199   }
200 
201   function lock(address _to, uint256 _value, uint256 _end) internal validAddress(_to) onlyOwner returns (bool) {
202     require(_value > 0);
203 
204     assert(totalProjectToken > 0);
205     totalLockToken = totalLockToken.add(_value);
206     assert(totalProjectToken >= totalLockToken);
207 
208     require(allocations[_to].value == 0);
209 
210     // Assign a new lock.
211     allocations[_to] = allocationLock({
212       value: _value,
213       end: _end,
214       locked: true
215     });
216 
217     Lock(this, _to, _value, _end);
218 
219     return true;
220   }
221 
222   function unlock() external {
223     require(allocations[msg.sender].locked);
224     require(now >= allocations[msg.sender].end);
225     
226     balanceOf[msg.sender] = balanceOf[msg.sender].add(allocations[msg.sender].value);
227 
228     allocations[msg.sender].locked = false;
229 
230     Transfer(this, msg.sender, allocations[msg.sender].value);
231     Unlock(this, msg.sender, allocations[msg.sender].value);
232   }
233 
234   function finalize() external onlyOwner {
235     require(fundingEnabled);
236     
237     totalSoldTokens = maxSaleToken.sub(balanceOf[fundingWallet]);
238 
239     totalProjectToken = totalSoldTokens.mul(15).div(100);
240 
241     lock(0x47c8F28e6056374aBA3DF0854306c2556B104601, totalProjectToken, now);
242     
243     // Zeroing a cold wallet.
244     balanceOf[fundingWallet] = 0;
245     balanceOf[0x47c8F28e6056374aBA3DF0854306c2556B104601] = 0;
246     balanceOf[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f] = 0;
247 
248     // End of crowdfunding.
249     fundingEnabled = false;
250     transfersEnabled = true;
251 
252     // End of crowdfunding.
253     Transfer(this, fundingWallet, 0);
254     Finalize(msg.sender, totalSupply);
255   }
256 
257   function disableTransfers() external onlyOwner {
258     require(transfersEnabled);
259 
260     transfersEnabled = false;
261 
262     DisableTransfers(msg.sender);
263   }
264 
265   function disableFundingWallets(address _address) external onlyOwner {
266     require(fundingEnabled);
267     require(fundingWallet != _address);
268     require(fundingWallets[_address]);
269 
270     fundingWallets[_address] = false;
271   }
272 }
273 
274 
275 contract Crowdsale {
276   using SafeMath for uint256;
277 
278   SerenityToken public token;
279 
280   mapping(uint256 => uint8) icoWeeksDiscounts; 
281 
282   uint256 public preStartTime = 1510704000;
283   uint256 public preEndTime = 1512086400; 
284 
285   bool public isICOStarted = false; 
286   uint256 public icoStartTime; 
287   uint256 public icoEndTime; 
288 
289   address public wallet = 0x47c8F28e6056374aBA3DF0854306c2556B104601;
290   uint256 public finneyPerToken = 100;
291   uint256 public weiRaised;
292   uint256 public ethRaised;
293 
294   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
295 
296   modifier validAddress(address _address) {
297     require(_address != 0x0);
298     _;
299   }
300 
301   function Crowdsale() public {
302     token = createTokenContract();
303     initDiscounts();
304   }
305 
306   function initDiscounts() internal {
307     icoWeeksDiscounts[0] = 40;
308     icoWeeksDiscounts[1] = 35;
309     icoWeeksDiscounts[2] = 30;
310     icoWeeksDiscounts[3] = 25;
311     icoWeeksDiscounts[4] = 20;
312     icoWeeksDiscounts[5] = 10;
313   }
314 
315   function createTokenContract() internal returns (SerenityToken) {
316     return new SerenityToken();
317   }
318 
319   function () public payable {
320     buyTokens(msg.sender);
321   }
322 
323   function getTimeDiscount() internal returns(uint8) {
324     require(isICOStarted == true);
325     require(icoStartTime < now);
326     require(icoEndTime > now);
327 
328     uint256 weeksPassed = (now - icoStartTime) / 7 days;
329     return icoWeeksDiscounts[weeksPassed];
330   } 
331 
332   function getTotalSoldDiscount() internal returns(uint8) {
333     require(isICOStarted == true);
334     require(icoStartTime < now);
335     require(icoEndTime > now);
336 
337     uint256 totalSold = token.totalSoldTokens();
338 
339     if (totalSold < 150000)
340       return 50;
341     else if (totalSold < 250000)
342       return 40;
343     else if (totalSold < 500000)
344       return 35;
345     else if (totalSold < 700000)
346       return 30;
347     else if (totalSold < 1100000)
348       return 25;
349     else if (totalSold < 2100000)
350       return 20;
351     else if (totalSold < 3500000)
352       return 10;
353   }
354 
355   function getDiscount() internal constant returns (uint8) {
356     if (!isICOStarted)
357       return 50;
358     else {
359       uint8 timeDiscount = getTimeDiscount();
360       uint8 totalSoldDiscount = getTotalSoldDiscount();
361 
362       if (timeDiscount < totalSoldDiscount)
363         return timeDiscount;
364       else 
365         return totalSoldDiscount;
366     }
367   }
368 
369   function buyTokens(address beneficiary) public validAddress(beneficiary) payable {
370     require(validPurchase());
371 
372     uint256 finneyAmount = msg.value / 1 finney;
373 
374     uint8 discountPercents = getDiscount();
375     uint256 tokens = finneyAmount.mul(100).div(100 - discountPercents).div(finneyPerToken);
376 
377     require(tokens > 0);
378 
379     weiRaised = weiRaised.add(finneyAmount * 1 finney);
380     
381     token.autoTransfer(beneficiary, tokens);
382     TokenPurchase(msg.sender, beneficiary, finneyAmount * 1 finney, tokens);
383 
384     forwardFunds();
385   }
386 
387   function activeteICO(uint256 _icoEndTime) public {
388     require(msg.sender == wallet);
389     require(_icoEndTime >= now);
390     require(_icoEndTime >= preEndTime);
391     require(isICOStarted == false);
392       
393     isICOStarted = true;
394     icoEndTime = _icoEndTime;
395   }
396 
397   function forwardFunds() internal {
398     wallet.transfer(msg.value);
399   }
400 
401   function validPurchase() internal constant returns (bool) {
402     bool withinPresalePeriod = now >= preStartTime && now <= preEndTime;
403     bool withinICOPeriod = isICOStarted && now >= icoStartTime && now <= icoEndTime;
404 
405     bool nonZeroPurchase = msg.value != 0;
406     
407     return (withinPresalePeriod || withinICOPeriod) && nonZeroPurchase;
408   }
409 }