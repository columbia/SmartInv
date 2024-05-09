1 pragma solidity 0.4.18;
2 
3 contract IOwned {
4   function owner() public view returns (address) { owner; }
5   function transferOwnership(address _newOwner) public;
6 }
7 
8 contract Owned is IOwned {
9   address public owner;
10 
11   function Owned() public {
12     owner = msg.sender;
13   }
14 
15   modifier validAddress(address _address) {
16     require(_address != 0x0);
17     _;
18   }
19   modifier onlyOwner {
20     assert(msg.sender == owner);
21     _;
22   }
23   
24   function transferOwnership(address _newOwner) public validAddress(_newOwner) onlyOwner {
25     require(_newOwner != owner);
26     
27     owner = _newOwner;
28   }
29 }
30 
31 
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal view returns (uint256) {
34     uint256 c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal view returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal view returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal view returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 
59 contract IERC20Token {
60   function name() public view returns (string) { name; }
61   function symbol() public view returns (string) { symbol; }
62   function decimals() public view returns (uint8) { decimals; }
63   function totalSupply() public view returns (uint256) { totalSupply; }
64   function balanceOf(address _owner) public view returns (uint256 balance) { _owner; balance; }
65   function allowance(address _owner, address _spender) public view returns (uint256 remaining) { _owner; _spender; remaining; }
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
99     require(_value <= balanceOf[msg.sender]);
100     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
101     balanceOf[_to] = balanceOf[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     
104     return true;
105   }
106 
107   function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {
108     require(_value <= allowance[_from][msg.sender]);
109     require(_value <= balanceOf[_from]);
110     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
111     balanceOf[_from] = balanceOf[_from].sub(_value);
112     balanceOf[_to] = balanceOf[_to].add(_value);
113     Transfer(_from, _to, _value);
114     return true;
115   }
116 
117   function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool) {
118     require(_value == 0 || allowance[msg.sender][_spender] == 0);
119     allowance[msg.sender][_spender] = _value;
120     Approval(msg.sender, _spender, _value);
121     return true;
122   }
123 }
124 
125 contract ISerenityToken {
126   function initialSupply () public view returns (uint256) { initialSupply; }
127 
128   function totalSoldTokens () public view returns (uint256) { totalSoldTokens; }
129   function totalProjectToken() public view returns (uint256) { totalProjectToken; }
130 
131   function fundingEnabled() public view returns (bool) { fundingEnabled; }
132   function transfersEnabled() public view returns (bool) { transfersEnabled; }
133 }
134 
135 contract SerenityToken is ISerenityToken, ERC20Token, Owned {
136   using SafeMath for uint256;
137  
138   address public fundingWallet;
139   bool public fundingEnabled = true;
140   uint256 public maxSaleToken = 400000000 ether;
141   uint256 public initialSupply = 400000000 ether;
142   uint256 public totalSoldTokens = 0;
143   uint256 public totalProjectToken;
144   bool public transfersEnabled = false;
145 
146   mapping (address => bool) internal fundingWallets;
147 
148   event Finalize(address indexed _from, uint256 _value);
149   event DisableTransfers(address indexed _from);
150 
151   function SerenityToken() ERC20Token("Serenity", "SRNT", 18) public {
152     fundingWallet = msg.sender; 
153 
154     balanceOf[fundingWallet] = maxSaleToken;
155     balanceOf[0x47c8F28e6056374aBA3DF0854306c2556B104601] = maxSaleToken;
156     balanceOf[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f] = maxSaleToken;
157     balanceOf[0x041375343c3Bd1Bb28b40b5Ce7b4665A9a6e21D0] = maxSaleToken;
158 
159     fundingWallets[fundingWallet] = true;
160     fundingWallets[0x47c8F28e6056374aBA3DF0854306c2556B104601] = true;
161     fundingWallets[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f] = true;
162     fundingWallets[0x041375343c3Bd1Bb28b40b5Ce7b4665A9a6e21D0] = true;
163   }
164 
165   modifier validAddress(address _address) {
166     require(_address != 0x0);
167     _;
168   }
169 
170   modifier transfersAllowed(address _address) {
171     if (fundingEnabled) {
172       require(fundingWallets[_address]);
173     }
174     else {
175       require(transfersEnabled);
176     }
177     _;
178   }
179 
180   function transfer(address _to, uint256 _value) public validAddress(_to) transfersAllowed(msg.sender) returns (bool) {
181     return super.transfer(_to, _value);
182   }
183 
184   function autoTransfer(address _to, uint256 _value) public validAddress(_to) onlyOwner returns (bool) {
185     return super.transfer(_to, _value);
186   }
187 
188   function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) transfersAllowed(_from) returns (bool) {
189     return super.transferFrom(_from, _to, _value);
190   }
191 
192   function getTotalSoldTokens() public view returns (uint256) {
193     uint256 result = 0;
194     result = result.add(maxSaleToken.sub(balanceOf[fundingWallet]));
195     result = result.add(maxSaleToken.sub(balanceOf[0x47c8F28e6056374aBA3DF0854306c2556B104601]));
196     result = result.add(maxSaleToken.sub(balanceOf[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f]));
197     result = result.add(maxSaleToken.sub(balanceOf[0x041375343c3Bd1Bb28b40b5Ce7b4665A9a6e21D0]));
198     return result;
199   }
200 
201   function finalize() external onlyOwner {
202     require(fundingEnabled);
203     
204     totalSoldTokens = getTotalSoldTokens();
205 
206     totalProjectToken = totalSoldTokens.mul(15).div(100);
207 
208     // Zeroing a cold wallet.
209     balanceOf[fundingWallet] = 0;
210     balanceOf[0xCAD0AfB8Ec657D0DB9518B930855534f6433360f] = 0;
211     balanceOf[0x041375343c3Bd1Bb28b40b5Ce7b4665A9a6e21D0] = 0;
212 
213     // Shareholders/bounties
214     balanceOf[0x47c8F28e6056374aBA3DF0854306c2556B104601] = totalProjectToken;
215 
216     // End of crowdfunding.
217     fundingEnabled = false;
218     transfersEnabled = true;
219 
220     // End of crowdfunding.
221     Transfer(this, fundingWallet, 0);
222     Finalize(msg.sender, totalSupply);
223   }
224 
225   function disableTransfers() external onlyOwner {
226     require(transfersEnabled);
227 
228     transfersEnabled = false;
229 
230     DisableTransfers(msg.sender);
231   }
232 
233   function disableFundingWallets(address _address) external onlyOwner {
234     require(fundingEnabled);
235     require(fundingWallet != _address);
236     require(fundingWallets[_address]);
237 
238     fundingWallets[_address] = false;
239   }
240 
241   function enableFundingWallets(address _address) external onlyOwner {
242     require(fundingEnabled);
243     require(fundingWallet != _address);
244 
245     fundingWallets[_address] = true;
246   }
247 }
248 
249 
250 contract Crowdsale {
251   using SafeMath for uint256;
252 
253   SerenityToken public token;
254 
255   mapping(uint256 => uint8) internal icoWeeksDiscounts;
256 
257   bool public isICOStarted = false; 
258   uint256 public icoStartTime; 
259   uint256 public icoEndTime; 
260 
261   address public wallet = 0x47c8F28e6056374aBA3DF0854306c2556B104601;
262 
263   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
264 
265   modifier validAddress(address _address) {
266     require(_address != 0x0);
267     _;
268   }
269 
270   function Crowdsale() public {
271     token = createTokenContract();
272     initDiscounts();
273   }
274 
275   function initDiscounts() internal {
276     icoWeeksDiscounts[0] = 40;
277     icoWeeksDiscounts[1] = 35;
278     icoWeeksDiscounts[2] = 30;
279     icoWeeksDiscounts[3] = 25;
280     icoWeeksDiscounts[4] = 20;
281     icoWeeksDiscounts[5] = 10;
282   }
283 
284   function createTokenContract() internal returns (SerenityToken) {
285     return new SerenityToken();
286   }
287 
288   function () public payable {
289     buyTokens(msg.sender);
290   }
291 
292   function getDiscount() internal view returns (uint8) {
293     require(isICOStarted == true);
294     require(icoStartTime < now);
295     require(icoEndTime > now);
296 
297     uint256 weeksPassed = now.sub(icoStartTime).div(7 days);
298     return icoWeeksDiscounts[weeksPassed];
299   } 
300 
301   function buyTokens(address beneficiary) public validAddress(beneficiary) payable {
302     require(isICOStarted);
303     require(validPurchase());
304 
305     uint8 discountPercents = getDiscount();
306     uint256 tokens = msg.value.mul(100).div(100 - discountPercents).mul(10000);
307 
308     require(tokens >= 100 ether);
309 
310     token.autoTransfer(beneficiary, tokens);
311     TokenPurchase(msg.sender, beneficiary, msg.value, tokens);
312 
313     forwardFunds();
314   }
315 
316   function activateICO(uint256 _icoEndTime) public {
317     require(msg.sender == wallet);
318     require(_icoEndTime >= now);
319     require(isICOStarted == false);
320       
321     isICOStarted = true;
322     icoEndTime = _icoEndTime;
323     icoStartTime = now;
324   }
325 
326   function forwardFunds() internal {
327     wallet.transfer(msg.value);
328   }
329 
330   function finalize() public {
331     require(msg.sender == wallet);
332     token.finalize();
333   }
334 
335   function validPurchase() internal view returns (bool) {
336     bool withinICOPeriod = isICOStarted && now >= icoStartTime && now <= icoEndTime;
337 
338     bool nonZeroPurchase = msg.value != 0;
339     
340     return withinICOPeriod && nonZeroPurchase;
341   }
342 }