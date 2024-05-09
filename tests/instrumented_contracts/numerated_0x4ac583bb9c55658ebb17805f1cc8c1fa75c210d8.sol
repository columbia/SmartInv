1 pragma solidity ^0.4.23;
2 
3 contract Token { // ERC20 standard
4 
5     function balanceOf(address _owner) public view returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 
13 }
14 
15 
16 /**
17  * Overflow aware uint math functions.
18  *
19  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
20  */
21 
22 contract SafeMath {
23 
24     function safeMul(uint a, uint b) internal pure returns (uint) {
25         uint c = a * b;
26         assert(a == 0 || c / a == b);
27         return c;
28     }
29 
30     function safeSub(uint a, uint b) internal pure returns (uint) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     function safeAdd(uint a, uint b) internal pure returns (uint) {
36         uint c = a + b;
37         assert(c>=a && c>=b);
38         return c;
39     }
40 	
41 	function safeDiv(uint a, uint b) internal pure returns (uint) {
42 		// assert(b > 0); // Solidity automatically throws when dividing by 0
43 		uint c = a / b;
44 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
45 		return c;
46 	}
47 
48     // mitigate short address attack
49     // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
50     // TODO: doublecheck implication of >= compared to ==
51     modifier onlyPayloadSize(uint numWords) {
52         assert(msg.data.length >= numWords * 32 + 4);
53         _;
54     }
55 
56 }
57 
58 contract StandardToken is Token, SafeMath {
59 
60     uint256 public totalSupply;
61 
62     // TODO: update tests to expect throw
63     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool success) {
64         require(_to != address(0));
65         require(balances[msg.sender] >= _value && _value > 0);
66         balances[msg.sender] = safeSub(balances[msg.sender], _value);
67         balances[_to] = safeAdd(balances[_to], _value);
68         emit Transfer(msg.sender, _to, _value);
69 
70         return true;
71     }
72 
73     // TODO: update tests to expect throw
74     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool success) {
75         require(_to != address(0));
76         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
77         balances[_from] = safeSub(balances[_from], _value);
78         balances[_to] = safeAdd(balances[_to], _value);
79         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
80         emit Transfer(_from, _to, _value);
81 
82         return true;
83     }
84 
85     function balanceOf(address _owner) public view returns (uint256 balance) {
86         return balances[_owner];
87     }
88 
89     // To change the approve amount you first have to reduce the addresses'
90     //  allowance to zero by calling 'approve(_spender, 0)' if it is not
91     //  already 0 to mitigate the race condition described here:
92     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
93     function approve(address _spender, uint256 _value) public onlyPayloadSize(2) returns (bool success) {
94         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
95         allowed[msg.sender][_spender] = _value;
96         emit Approval(msg.sender, _spender, _value);
97 
98         return true;
99     }
100 
101     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) public onlyPayloadSize(3) returns (bool success) {
102         require(allowed[msg.sender][_spender] == _oldValue);
103         allowed[msg.sender][_spender] = _newValue;
104         emit Approval(msg.sender, _spender, _newValue);
105 
106         return true;
107     }
108 
109     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
110         return allowed[_owner][_spender];
111     }
112 
113     mapping (address => uint256) balances;
114     mapping (address => mapping (address => uint256)) allowed;
115 
116 }
117 
118 contract Lucre is StandardToken {
119 
120     // FIELDS
121 
122     string public name = "LUCRE";
123     string public symbol = "LCR";
124     uint256 public decimals = 18;
125     string public version = "1.0";
126 
127     uint256 public tokenCap = 12500000 * 10**18;  // 10/80 							  
128 
129     // crowdsale parameters
130     uint256 public startTime;
131     uint256 public endTime;
132 
133     // root control
134     address public fundWallet;
135     // control of liquidity and limited control of updatePrice
136     address public controlWallet;
137     // company reserve, advisor fee & marketing
138     address public companyWallet;
139 
140     // fundWallet controlled state variables
141     // halted: halt buying due to emergency, tradeable: signal that assets have been acquired
142     bool public halted = false;
143     bool public tradeable = false;
144 
145     // -- totalSupply defined in StandardToken
146     // -- mapping to token balances done in StandardToken
147 
148 
149     uint256 public rate;
150     uint256 public minAmount = 0.10 ether;
151 
152     // maps addresses
153     mapping (address => bool) public whitelist;
154 
155 
156     // EVENTS
157 
158     event Buy(address indexed participant, address indexed beneficiary, uint256 ethValue, uint256 amountTokens);
159     event AllocatePresale(address indexed participant, uint256 amountTokens);
160     event Whitelist(address indexed participant);
161     event RateUpdate(uint256 rate);
162 
163 
164     // MODIFIERS
165 
166     modifier isTradeable { // exempt companyWallet and fundWallet to allow company allocations
167         require(tradeable || msg.sender == fundWallet || msg.sender == companyWallet);
168         _;
169     }
170 
171     modifier onlyWhitelist {
172         require(whitelist[msg.sender]);
173         _;
174     }
175 
176     modifier onlyFundWallet {
177         require(msg.sender == fundWallet);
178         _;
179     }
180 
181     modifier onlyManagingWallets {
182         require(msg.sender == controlWallet || msg.sender == fundWallet || msg.sender == companyWallet);
183         _;
184     }
185 
186     modifier only_if_controlWallet {
187         if (msg.sender == controlWallet) _;
188     }
189 
190 
191     // CONSTRUCTOR
192 
193     constructor (address controlWalletInput, address companyWalletInput, uint preSaleDays, uint mainSaleDays, uint256 rateInput) public {
194         require(controlWalletInput != address(0));
195         require(rateInput > 0);
196         startTime = now + preSaleDays * 1 days; // 30 days of presales (default)
197         fundWallet = msg.sender;
198         controlWallet = controlWalletInput;
199         companyWallet = companyWalletInput;
200         whitelist[fundWallet] = true;
201         whitelist[controlWallet] = true;
202         whitelist[companyWallet] = true;
203         endTime = now + (preSaleDays + mainSaleDays) * 1 days; // mainSaleDays = 28 days (default)
204 		rate = rateInput;
205 
206     }
207 
208     // METHODS
209 
210     // allows controlWallet to update the price within a time constraint, allows fundWallet complete control
211     function updateRate(uint256 newRate) external onlyManagingWallets {
212         require(newRate > 0);
213         // either controlWallet command is compliant or transaction came from fundWallet
214         rate = newRate;
215         emit RateUpdate(rate);
216     }
217 
218 
219     function allocateTokens(address participant, uint256 amountTokens) private {
220         // 20% of total allocated for PR, Marketing, Team, Advisers
221         uint256 companyAllocation = safeMul(amountTokens, 25000000000000000) / 100000000000000000; //20/80
222         // check that token cap is not exceeded
223         uint256 newTokens = safeAdd(amountTokens, companyAllocation);
224         require(safeAdd(totalSupply, newTokens) <= tokenCap);
225         // increase token supply, assign tokens to participant
226         totalSupply = safeAdd(totalSupply, newTokens);
227         balances[participant] = safeAdd(balances[participant], amountTokens);
228         balances[companyWallet] = safeAdd(balances[companyWallet], companyAllocation);
229     }
230 
231     function allocatePresaleTokens(address participant, uint amountTokens) external onlyFundWallet {
232         require(now < endTime);
233         require(participant != address(0));
234         whitelist[participant] = true; // automatically whitelist accepted presale
235         allocateTokens(participant, amountTokens);
236         emit Whitelist(participant);
237         emit AllocatePresale(participant, amountTokens);
238     }
239 
240     function verifyParticipant(address participant) external onlyManagingWallets {
241         whitelist[participant] = true;
242         emit Whitelist(participant);
243     }
244 
245     function buy() external payable {
246         buyTo(msg.sender);
247     }
248 
249     function buyTo(address participant) public payable onlyWhitelist {
250         require(!halted);
251         require(participant != address(0));
252         require(msg.value >= minAmount);
253         require(now >= startTime && now < endTime);
254 		uint256 money = safeMul(msg.value, rate);
255 		uint256 bonusMoney = safeMul(money, getBonus()) / 100;
256 		uint256 tokensToBuy = safeAdd(money, bonusMoney);  
257         allocateTokens(participant, tokensToBuy);
258         // send ether to fundWallet
259         fundWallet.transfer(msg.value);
260         emit Buy(msg.sender, participant, msg.value, tokensToBuy);
261     }
262 
263 
264     function getBonus() internal view returns (uint256) {
265         uint256 icoDuration = safeSub(now, startTime);
266         uint256 discount;
267         if (icoDuration < 7 days) { 
268             discount = 0;
269         } else if (icoDuration < 14 days) { 
270             discount = 10; // 10% bonus
271         } else if (icoDuration < 21 days) { 
272             discount = 15; // 15% bonus
273         } else {
274             discount = 20; // 20% bonus
275         } 
276 		return discount;
277     }
278 
279 
280     function changeFundWallet(address newFundWallet) external onlyFundWallet {
281         require(newFundWallet != address(0));
282         fundWallet = newFundWallet;
283     }
284 
285     function changeControlWallet(address newControlWallet) external onlyFundWallet {
286         require(newControlWallet != address(0));
287         controlWallet = newControlWallet;
288     }
289 
290     function updateFundingStartTime(uint256 newStartTime) external onlyFundWallet {
291         require(now < startTime);
292         require(now < newStartTime);
293         startTime = newStartTime;
294     }
295 
296     function updateFundingEndTime(uint256 newEndTime) external onlyFundWallet {
297         require(now < endTime);
298         require(now < newEndTime);
299         endTime = newEndTime;
300     }
301 
302     function halt() external onlyFundWallet {
303         halted = true;
304     }
305     function unhalt() external onlyFundWallet {
306         halted = false;
307     }
308 
309     function enableTrading() external onlyFundWallet {
310         require(now > endTime);
311         tradeable = true;
312     }
313 
314     // fallback function
315     function() external payable {
316         buyTo(msg.sender);
317     }
318 
319     function claimTokens(address _token) external onlyFundWallet {
320         require(_token != address(0));
321         Token token = Token(_token);
322         uint256 balance = token.balanceOf(this);
323         token.transfer(fundWallet, balance);
324     }
325 
326     // prevent transfers until trading allowed
327     function transfer(address _to, uint256 _value) public isTradeable returns (bool success) {
328         return super.transfer(_to, _value);
329     }
330     function transferFrom(address _from, address _to, uint256 _value) public isTradeable returns (bool success) {
331         return super.transferFrom(_from, _to, _value);
332     }
333 
334 }