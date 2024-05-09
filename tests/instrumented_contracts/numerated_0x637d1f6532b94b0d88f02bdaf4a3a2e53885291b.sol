1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
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
59 contract IERC20Token {
60   function name() public constant returns (string) { name; }
61   function symbol() public constant returns (string) { symbol; }
62   function decimals() public constant returns (uint8) { decimals; }
63   function totalSupply() public constant returns (uint256) { totalSupply; }
64   function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
65   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
66 
67   function transfer(address _to, uint256 _value) public returns (bool);
68   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
69   function approve(address _spender, uint256 _value) public returns (bool);
70 }
71 
72 contract ERC20Token is IERC20Token {
73   using SafeMath for uint256;
74 
75   string public standard = 'Token 0.1';
76   string public name = '';
77   string public symbol = '';
78   uint8 public decimals = 0;
79   uint256 public totalSupply = 0;
80   mapping (address => uint256) public balanceOf;
81   mapping (address => mapping (address => uint256)) public allowance;
82 
83   event Transfer(address indexed _from, address indexed _to, uint256 _value);
84   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 
86   function ERC20Token(string _name, string _symbol, uint8 _decimals) public {
87     require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
88     name = _name;
89     symbol = _symbol;
90     decimals = _decimals;
91   }
92 
93   modifier validAddress(address _address) {
94     require(_address != 0x0);
95     _;
96   }
97 
98   function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool) {
99     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
100     balanceOf[_to] = balanceOf[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     
103     return true;
104   }
105 
106   function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {
107     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
108     balanceOf[_from] = balanceOf[_from].sub(_value);
109     balanceOf[_to] = balanceOf[_to].add(_value);
110     Transfer(_from, _to, _value);
111     return true;
112   }
113 
114   function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool) {
115     require(_value == 0 || allowance[msg.sender][_spender] == 0);
116     allowance[msg.sender][_spender] = _value;
117     Approval(msg.sender, _spender, _value);
118     return true;
119   }
120 }
121 
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
139   uint256 public maxSaleToken = 3500000 ether;
140   uint256 public initialSupply = 3500000 ether;
141   uint256 public totalSoldTokens = 0;
142   uint256 public totalProjectToken;
143   bool public transfersEnabled = false;
144 
145   mapping (address => bool) private fundingWallets;
146 
147   event Finalize(address indexed _from, uint256 _value);
148   event DisableTransfers(address indexed _from);
149 
150   function SerenityToken() ERC20Token("SERENITY", "SERENITY", 18) public {
151     fundingWallet = msg.sender; 
152 
153     balanceOf[fundingWallet] = maxSaleToken;
154     balanceOf[0x47c8F28e6056374aBA3DF0854306c2556B104601] = maxSaleToken;
155     balanceOf[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f] = maxSaleToken;
156     balanceOf[0x041375343c3Bd1Bb28b40b5Ce7b4665A9a6e21D0] = maxSaleToken;
157 
158     fundingWallets[fundingWallet] = true;
159     fundingWallets[0x47c8F28e6056374aBA3DF0854306c2556B104601] = true;
160     fundingWallets[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f] = true;
161     fundingWallets[0x041375343c3Bd1Bb28b40b5Ce7b4665A9a6e21D0] = true;
162   }
163 
164   modifier validAddress(address _address) {
165     require(_address != 0x0);
166     _;
167   }
168 
169   modifier transfersAllowed(address _address) {
170     if (fundingEnabled) {
171       require(fundingWallets[_address]);
172     }
173     else {
174       require(transfersEnabled);
175     }
176     _;
177   }
178 
179   function transfer(address _to, uint256 _value) public validAddress(_to) transfersAllowed(msg.sender) returns (bool) {
180     return super.transfer(_to, _value);
181   }
182 
183   function autoTransfer(address _to, uint256 _value) public validAddress(_to) onlyOwner returns (bool) {
184     return super.transfer(_to, _value);
185   }
186 
187   function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) transfersAllowed(_from) returns (bool) {
188     return super.transferFrom(_from, _to, _value);
189   }
190 
191   function getTotalSoldTokens() public constant returns (uint256) {
192     uint256 result = 0;
193     result = result.add(maxSaleToken.sub(balanceOf[fundingWallet]));
194     result = result.add(maxSaleToken.sub(balanceOf[0x47c8F28e6056374aBA3DF0854306c2556B104601]));
195     result = result.add(maxSaleToken.sub(balanceOf[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f]));
196     result = result.add(maxSaleToken.sub(balanceOf[0x041375343c3Bd1Bb28b40b5Ce7b4665A9a6e21D0]));
197     return result;
198   }
199 
200   function finalize() external onlyOwner {
201     require(fundingEnabled);
202     
203     totalSoldTokens = getTotalSoldTokens();
204 
205     totalProjectToken = totalSoldTokens.mul(15).div(100);
206 
207     // Zeroing a cold wallet.
208     balanceOf[fundingWallet] = 0;
209     balanceOf[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f] = 0;
210     balanceOf[0x041375343c3Bd1Bb28b40b5Ce7b4665A9a6e21D0] = 0;
211 
212     // Shareholders/bounties
213     balanceOf[0x47c8F28e6056374aBA3DF0854306c2556B104601] = totalProjectToken;
214 
215     // End of crowdfunding.
216     fundingEnabled = false;
217     transfersEnabled = true;
218 
219     // End of crowdfunding.
220     Transfer(this, fundingWallet, 0);
221     Finalize(msg.sender, totalSupply);
222   }
223 
224   function disableTransfers() external onlyOwner {
225     require(transfersEnabled);
226 
227     transfersEnabled = false;
228 
229     DisableTransfers(msg.sender);
230   }
231 
232   function disableFundingWallets(address _address) external onlyOwner {
233     require(fundingEnabled);
234     require(fundingWallet != _address);
235     require(fundingWallets[_address]);
236 
237     fundingWallets[_address] = false;
238   }
239 
240   function enableFundingWallets(address _address) external onlyOwner {
241     require(fundingEnabled);
242     require(fundingWallet != _address);
243 
244     fundingWallets[_address] = true;
245   }
246 }
247 
248 
249 contract Crowdsale {
250   using SafeMath for uint256;
251 
252   SerenityToken public token;
253 
254   mapping(uint256 => uint8) icoWeeksDiscounts; 
255 
256   uint256 public preStartTime = 1510704000;
257   uint256 public preEndTime = 1512086400; 
258 
259   bool public isICOStarted = false; 
260   uint256 public icoStartTime; 
261   uint256 public icoEndTime; 
262 
263   address public wallet = 0x47c8F28e6056374aBA3DF0854306c2556B104601;
264   uint256 public finneyPerToken = 100;
265   uint256 public weiRaised;
266   uint256 public ethRaised;
267 
268   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
269 
270   modifier validAddress(address _address) {
271     require(_address != 0x0);
272     _;
273   }
274 
275   function Crowdsale() public {
276     token = createTokenContract();
277     initDiscounts();
278   }
279 
280   function initDiscounts() internal {
281     icoWeeksDiscounts[0] = 40;
282     icoWeeksDiscounts[1] = 35;
283     icoWeeksDiscounts[2] = 30;
284     icoWeeksDiscounts[3] = 25;
285     icoWeeksDiscounts[4] = 20;
286     icoWeeksDiscounts[5] = 10;
287   }
288 
289   function createTokenContract() internal returns (SerenityToken) {
290     return new SerenityToken();
291   }
292 
293   function () public payable {
294     buyTokens(msg.sender);
295   }
296 
297   function getTimeDiscount() internal constant returns(uint8) {
298     require(isICOStarted == true);
299     require(icoStartTime < now);
300     require(icoEndTime > now);
301 
302     uint256 weeksPassed = (now - icoStartTime) / 7 days;
303     return icoWeeksDiscounts[weeksPassed];
304   } 
305 
306   function getTotalSoldDiscount() internal constant returns(uint8) {
307     require(isICOStarted == true);
308     require(icoStartTime < now);
309     require(icoEndTime > now);
310 
311     uint256 totalSold = token.getTotalSoldTokens();
312 
313     if (totalSold < 150000 ether)
314       return 50;
315     else if (totalSold < 250000 ether)
316       return 40;
317     else if (totalSold < 500000 ether)
318       return 35;
319     else if (totalSold < 700000 ether)
320       return 30;
321     else if (totalSold < 1100000 ether)
322       return 25;
323     else if (totalSold < 2100000 ether)
324       return 20;
325     else if (totalSold < 3500000 ether)
326       return 10;
327   }
328 
329   function getDiscount() internal constant returns (uint8) {
330     if (!isICOStarted)
331       return 50;
332     else {
333       uint8 timeDiscount = getTimeDiscount();
334       uint8 totalSoldDiscount = getTotalSoldDiscount();
335 
336       if (timeDiscount < totalSoldDiscount)
337         return timeDiscount;
338       else 
339         return totalSoldDiscount;
340     }
341   }
342 
343   function buyTokens(address beneficiary) public validAddress(beneficiary) payable {
344     require(isICOStarted || token.getTotalSoldTokens() < 150000 ether);
345     require(validPurchase());
346 
347     uint8 discountPercents = getDiscount();
348     uint256 tokens = msg.value.mul(100).div(100 - discountPercents).mul(10);
349 
350     require(tokens > 1 ether);
351 
352     weiRaised = weiRaised.add(msg.value);
353     
354     token.autoTransfer(beneficiary, tokens);
355     TokenPurchase(msg.sender, beneficiary, msg.value, tokens);
356 
357     forwardFunds();
358   }
359 
360   function activateICO(uint256 _icoEndTime) public {
361     require(msg.sender == wallet);
362     require(_icoEndTime >= now);
363     require(isICOStarted == false);
364       
365     isICOStarted = true;
366     icoEndTime = _icoEndTime;
367     icoStartTime = now;
368   }
369 
370   function forwardFunds() internal {
371     wallet.transfer(msg.value);
372   }
373 
374   function finalize() public {
375     require(msg.sender == wallet);
376     token.finalize();
377   }
378 
379   function validPurchase() internal constant returns (bool) {
380     bool withinPresalePeriod = now >= preStartTime && now <= preEndTime;
381     bool withinICOPeriod = isICOStarted && now >= icoStartTime && now <= icoEndTime;
382 
383     bool nonZeroPurchase = msg.value != 0;
384     
385     return (withinPresalePeriod || withinICOPeriod) && nonZeroPurchase;
386   }
387 }