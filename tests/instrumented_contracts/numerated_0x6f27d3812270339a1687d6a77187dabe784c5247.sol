1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 		if (a == 0) {
6 			return 0;
7 		}
8 		uint256 c = a * b;
9 		assert(c / a == b);
10 		return c;
11 	}
12 
13 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
14 		// assert(b > 0); // Solidity automatically throws when dividing by 0
15 		uint256 c = a / b;
16 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
17 		return c;
18 	}
19 
20 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21 		assert(b <= a);
22 		return a - b;
23 	}
24 
25 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
26 		uint256 c = a + b;
27 		assert(c >= a);
28 		return c;
29 	}
30 }
31 
32 contract Ownable {
33 	address public owner;
34 
35 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37 	function Ownable() public {
38 		owner = msg.sender;
39 	}
40 
41 	modifier onlyOwner() {
42 		require(msg.sender == owner);
43 		_;
44 	}
45 
46 	function transferOwnership(address newOwner) public onlyOwner {
47 		require(newOwner != address(0));
48 		OwnershipTransferred(owner, newOwner);
49 		owner = newOwner;
50 	}
51 }
52 
53 contract ERC20Basic {
54 	uint256 public totalSupply;
55 	uint256 freezeTransferTime;
56 	function balanceOf(address who) public constant returns (uint256);
57 	function transfer(address to, uint256 value) public returns (bool);
58 	event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract ERC20 is ERC20Basic {
62 	function allowance(address owner, address spender) public constant returns (uint256);
63 	function transferFrom(address from, address to, uint256 value) public returns (bool);
64 	function approve(address spender, uint256 value) public returns (bool);
65 	event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 contract BasicToken is ERC20Basic {
69 
70 	using SafeMath for uint256;
71 	mapping(address => uint256) balances;
72 
73 	function transfer(address _to, uint256 _value) public returns (bool) {
74 		require(_to != address(0));
75         require(now >= freezeTransferTime);
76 		balances[msg.sender] = balances[msg.sender].sub(_value);
77 		balances[_to] = balances[_to].add(_value);
78 		Transfer(msg.sender, _to, _value);
79 		return true;
80 	}
81 
82 	function balanceOf(address _owner) public constant returns (uint256 balance) {
83 		return balances[_owner];
84 	}
85 }
86 
87 contract StandardToken is ERC20, BasicToken {
88 
89 	mapping (address => mapping (address => uint256)) allowed;
90 
91 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92 		require(_to != address(0));
93 		require(now >= freezeTransferTime);
94 
95 		var _allowance = allowed[_from][msg.sender];
96 		balances[_to] = balances[_to].add(_value);
97 		balances[_from] = balances[_from].sub(_value);
98 		allowed[_from][msg.sender] = _allowance.sub(_value);
99 		Transfer(_from, _to, _value);
100 		return true;
101 	}
102 
103 	function approve(address _spender, uint256 _value) public returns (bool) {
104 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
105 		allowed[msg.sender][_spender] = _value;
106 		Approval(msg.sender, _spender, _value);
107 		return true;
108 	}
109 
110 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
111 		return allowed[_owner][_spender];
112 	}
113 }
114 
115 contract MintableToken is StandardToken, Ownable {
116 
117 	event Mint(address indexed to, uint256 amount);
118 	event MintFinished();
119 
120 	bool public mintingFinished = false;
121 
122 	modifier canMint() {
123 		require(!mintingFinished);
124 		_;
125 	}
126 
127 	function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
128 		totalSupply = totalSupply.add(_amount);
129 		balances[_to] = balances[_to].add(_amount);
130 		Mint(_to, _amount);
131 		return true;
132 	}
133 
134 	function finishMinting() public onlyOwner returns (bool) {
135 		mintingFinished = true;
136 		MintFinished();
137 		return true;
138 	}
139 }
140 
141 contract SIGToken is MintableToken {
142 
143 	string public constant name = "Saxinvest Group Coin";
144 	string public constant symbol = "SIG";
145 	uint32 public constant decimals = 18;
146 
147 	function SIGToken(uint256 _freezeTransferTime) public {
148 		freezeTransferTime = _freezeTransferTime;
149 	}
150 }
151 
152 contract SIGICO is Ownable {
153 	using SafeMath for uint256;
154 
155 	SIGToken public token;
156 
157 	uint256 public startTime;
158 	uint256 public endTime;
159 	uint256 public freezeTransferTime;
160 
161 	bool public isFinalized = false;
162 
163 	uint256 Round1 = 1517000399; // first round end time
164 	uint256 Round2 = 1519851599; // second round end time
165 
166 	address SafeAddr = 0x99C5FAb804600C8504EEeE0908251b0504B6354A;
167 
168 	address FundOwnerAddr_1 = 0x8C6Ef7697b14bD32Be490036566396B0bc821569;
169 	address FundOwnerAddr_2 = 0xEeE2A9aE8db4bd43E72aa912dD908557D5D23891;
170 	address FundOwnerAddr_3 = 0x8f89f10C379cD244c451Df6aD4a569aFe567c22f;
171 
172 	address ReserveFundAddr = 0xC9a5E3c3ed6c340dD10F87fe35929d93fee642Ed;
173 
174 	address DeveloperTokensStoreAddr = 0x0e22b0Baa6714A8Dd18dC966002E02b5116522EF;
175 	address OtherTokensStoreAddr = 0x53E936299f2b7A7173A81B28C93591C880aDfD45;
176 
177 	uint256 rate;
178 	uint256 TotalBuyers;
179 	uint256 PercentageForFounders = 10;
180 	uint256 PercentageForReserveFund = 5;
181 	uint256 PercentageForDevelopers = 3;
182 	uint256 PercentageForOther = 2;
183 	uint256 tokenCost;
184 
185 	mapping (address => bool) Buyers;
186 	mapping (uint8 => uint256) BonusTokens;
187 	mapping (uint8 => uint256) Restricted;
188 
189 	event TokenPurchase(address indexed sender, address indexed buyer, uint8 round, uint256 rate, uint256 weiAmount, uint256 tokens, uint256 bonus);
190 	event ChangeRate(uint256 changeTime, uint256 prevRate, uint256 newRate, uint256 prevSupply);
191 	event Finalized();
192 
193 	function SIGICO(uint256 _startTime, uint256 _endTime, uint256 _rate) public {
194 		require(_startTime >= now);
195 		require(_endTime >= _startTime);
196 		require(_rate > 0);
197 
198 		freezeTransferTime = _endTime.add(90 * 1 days);
199         token = new SIGToken(freezeTransferTime);
200 
201 		startTime = _startTime;
202 		endTime = _endTime;
203 		rate = _rate;
204 
205 		tokenCost = uint256(1 ether).div(rate);
206 	}
207 
208 	function () external payable {
209 		buyTokens(msg.sender);
210 	}
211 
212 	function buyTokens(address buyer) public payable {
213 		require(buyer != address(0));
214 		require(validPurchase());
215 
216 		uint256 tokens = rate.mul(msg.value).div(1 ether);
217 		uint256 tokens2mint = 0;
218         uint256 bonus = 0;
219         uint8 round = 3;
220 
221 		if(now < Round1){
222             round = 1;
223 			bonus = tokens.mul(20).div(100);
224             BonusTokens[round] += bonus;
225 		}else if(now > Round1 && now < Round2){
226             round = 2;
227 			bonus = tokens.mul(10).div(100);
228             BonusTokens[round] += bonus;
229 		}
230 
231 		tokens += bonus;
232         tokens2mint = tokens.mul(1 ether);
233 		token.mint(buyer, tokens2mint);
234 		TokenPurchase(msg.sender, buyer, round, rate, msg.value, tokens, bonus);
235 
236         if(Buyers[buyer] != true){
237 			TotalBuyers += 1;
238 			Buyers[buyer] = true;
239 		}
240 
241 		forwardFunds();
242 	}
243 
244 	function forwardFunds() internal {
245 		SafeAddr.transfer(msg.value);
246 	}
247 
248 	function validPurchase() internal view returns (bool) {
249 		bool withinPeriod = now >= startTime && now <= endTime;
250 		bool nonZeroPurchase = msg.value != 0;
251 		bool haveEnoughEther = msg.value >= tokenCost;
252 		return withinPeriod && nonZeroPurchase && haveEnoughEther;
253 	}
254 
255 	function hasEnded() public view returns (bool) {
256 		return now > endTime;
257 	}
258 
259 	function finalize() onlyOwner public {
260 		require(!isFinalized);
261 		require(hasEnded());
262 		finalization();
263 		Finalized();
264 		isFinalized = true;
265 	}
266 
267 	function finalization() internal {
268 		uint256 totalSupply = token.totalSupply().div(1 ether);
269 
270 		uint256 tokens = totalSupply.mul(PercentageForFounders).div(100 - PercentageForFounders);
271 		uint256 tokens2mint = tokens.mul(1 ether);
272 		token.mint(FundOwnerAddr_1, tokens2mint);
273 		token.mint(FundOwnerAddr_2, tokens2mint);
274 		token.mint(FundOwnerAddr_3, tokens2mint);
275 		Restricted[1] = tokens.mul(3);
276 
277 		tokens = totalSupply.mul(PercentageForDevelopers).div(100 - PercentageForDevelopers);
278         tokens2mint = tokens.mul(1 ether);
279 		token.mint(DeveloperTokensStoreAddr, tokens2mint);
280 		Restricted[2] = tokens;
281 
282 		tokens = totalSupply.mul(PercentageForOther).div(100 - PercentageForOther);
283         tokens2mint = tokens.mul(1 ether);
284 		token.mint(OtherTokensStoreAddr, tokens2mint);
285 		Restricted[3] = tokens;
286 
287 		tokens = totalSupply.mul(PercentageForReserveFund).div(100 - PercentageForReserveFund);
288 		tokens2mint = tokens.mul(1 ether);
289 		token.mint(ReserveFundAddr, tokens2mint);
290 		Restricted[4] = tokens;
291 
292 		token.finishMinting();
293 	}
294 
295 	function changeRate(uint256 _rate) onlyOwner public returns (uint256){
296 		require(!isFinalized);
297 		require(_rate > 0);
298 		uint256 totalSupply = token.totalSupply().div(1 ether);
299 		tokenCost = uint256(1 ether).div(_rate);
300 		ChangeRate(now, rate, _rate, totalSupply);
301 		rate = _rate;
302 		return rate;
303 	}
304 
305 	function getRestrictedTokens(uint8 _who) onlyOwner public constant returns (uint256){
306 		require(isFinalized);
307 		require(_who <= 4);
308 		return Restricted[_who];
309 	}
310 
311 	function getBonusTokens(uint8 _round) onlyOwner public constant returns (uint256){
312 		require(_round < 3);
313 		return BonusTokens[_round];
314 	}
315 
316 	function getTotalBuyers() onlyOwner public constant returns (uint256){
317 		return TotalBuyers;
318 	}
319 }