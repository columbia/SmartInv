1 pragma solidity ^0.4.10;
2 
3 contract ERC20 {
4   uint public totalSupply;
5   function balanceOf(address who) constant returns (uint);
6   function allowance(address owner, address spender) constant returns (uint);
7 
8   function transfer(address to, uint value) returns (bool ok);
9   function transferFrom(address from, address to, uint value) returns (bool ok);
10   function approve(address spender, uint value) returns (bool ok);
11   event Transfer(address indexed from, address indexed to, uint value);
12   event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 /*
15  * Safe Math Smart Contract.  Copyright © 2016 by ABDK Consulting.
16  */
17 
18 /**
19  * Provides methods to safely add, subtract and multiply uint256 numbers.
20  */
21 contract SafeMath {
22   uint256 constant private MAX_UINT256 =
23     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
24 
25   /**
26    * Add two uint256 values, throw in case of overflow.
27    *
28    * @param x first value to add
29    * @param y second value to add
30    * @return x + y
31    */
32   function safeAdd (uint256 x, uint256 y)
33   constant internal
34   returns (uint256 z) {
35     if (x > MAX_UINT256 - y) throw;
36     return x + y;
37   }
38 
39   /**
40    * Subtract one uint256 value from another, throw in case of underflow.
41    *
42    * @param x value to subtract from
43    * @param y value to subtract
44    * @return x - y
45    */
46   function safeSub (uint256 x, uint256 y)
47   constant internal
48   returns (uint256 z) {
49     if (x < y) throw;
50     return x - y;
51   }
52 
53   /**
54    * Multiply two uint256 values, throw in case of overflow.
55    *
56    * @param x first value to multiply
57    * @param y second value to multiply
58    * @return x * y
59    */
60   function safeMul (uint256 x, uint256 y)
61   constant internal
62   returns (uint256 z) {
63     if (y == 0) return 0; // Prevent division by zero at the next line
64     if (x > MAX_UINT256 / y) throw;
65     return x * y;
66   }
67 }
68 
69 contract Vote is ERC20, SafeMath{
70 
71 	mapping (address => uint) balances;
72 	mapping (address => mapping (address => uint)) allowed;
73 
74 	uint public totalSupply;
75 	uint public initialSupply;
76 	string public name;
77 	string public symbol;
78 	uint8 public decimals;
79 
80 	function Vote(){
81 		initialSupply = 100000;
82 		totalSupply = initialSupply;
83 		balances[msg.sender] = initialSupply;
84 		name = "EthTaipei Logo Vote";
85 		symbol = "EthTaipei Logo";
86 		decimals = 0;
87 	}
88 
89 	function transfer(address _to, uint _value) returns (bool) {
90 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
91 	    balances[_to] = safeAdd(balances[_to], _value);
92 	    Transfer(msg.sender, _to, _value);
93 	    return true;
94   	}
95 
96   	function transferFrom(address _from, address _to, uint _value) returns (bool) {
97 	    var _allowance = allowed[_from][msg.sender];	    
98 	    balances[_to] = safeAdd(balances[_to], _value);
99 	    balances[_from] = safeSub(balances[_from], _value);
100 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
101 	    Transfer(_from, _to, _value);
102 	    return true;
103   	}
104 
105   	function approve(address _spender, uint _value) returns (bool) {
106     	allowed[msg.sender][_spender] = _value;
107     	Approval(msg.sender, _spender, _value);
108     	return true;
109   	}
110 
111   	function balanceOf(address _address) constant returns (uint balance) {
112   		return balances[_address];
113   	}
114 
115   	function allowance(address _owner, address _spender) constant returns (uint remaining) {
116     	return allowed[_owner][_spender];
117   	}
118 
119 }
120 contract Ownable {
121   address public owner;
122 
123   function Ownable() {
124     owner = msg.sender;
125   }
126 
127   modifier onlyOwner() {
128     if (msg.sender == owner)
129       _;
130   }
131 
132   function transferOwnership(address newOwner) onlyOwner {
133     if (newOwner != address(0)) owner = newOwner;
134   }
135 
136 }
137 
138 contract wLogoVote {
139 	function claimReward(address _receiver);
140 }
141 
142 contract Logo is Ownable{
143 
144 	wLogoVote public logoVote;
145 
146 	address public author;
147 	string public metadataUrl;
148 
149 	event ReceiveTips(address _from, uint _value);
150 
151 	function Logo(address _owner, address _author, string _metadatUrl){
152 		owner = _owner;
153 		author = _author;
154 		metadataUrl = _metadatUrl;
155 		logoVote = wLogoVote(msg.sender);
156 	}
157 
158 	function tips() payable {
159 		ReceiveTips(msg.sender, msg.value);
160 		if(!author.send(msg.value)) throw;
161 	}
162 
163 	function claimReward() onlyOwner {
164 		logoVote.claimReward(author);
165 	}
166 
167 	function setMetadata(string _metadataUrl) onlyOwner {
168 		metadataUrl = _metadataUrl;
169 	}
170 
171 	function () payable {
172 		tips();
173 	}
174 }
175 /*
176  * Pausable
177  * Abstract contract that allows children to implement an
178  * emergency stop mechanism.
179  */
180 
181 contract Pausable is Ownable {
182   bool public stopped;
183 
184   modifier stopInEmergency {
185     if (stopped) {
186       throw;
187     }
188     _;
189   }
190   
191   modifier onlyInEmergency {
192     if (!stopped) {
193       throw;
194     }
195     _;
196   }
197 
198   // called by the owner on emergency, triggers stopped state
199   function emergencyStop() external onlyOwner {
200     stopped = true;
201   }
202 
203   // called by the owner on end of emergency, returns to normal state
204   function release() external onlyOwner onlyInEmergency {
205     stopped = false;
206   }
207 
208 }
209 contract Token{
210 	function transfer(address to, uint value) returns (bool ok);
211 }
212 
213 contract Faucet {
214 
215 	address public tokenAddress;
216 	Token token;
217 
218 	function Faucet(address _tokenAddress) {
219 		tokenAddress = _tokenAddress;
220 		token = Token(tokenAddress);
221 	}
222   
223 	function getToken() {
224 		if(!token.transfer(msg.sender, 1)) throw;
225 	}
226 
227 	function () {
228 		getToken();
229 	}
230 
231 }
232 
233 contract LogoVote is Pausable, SafeMath{
234 
235 	Vote public vote;
236 	Faucet public faucet;
237 	Logo[] public logos;
238 
239 	mapping (address => uint) backers;
240 	mapping (address => bool) rewards;
241 	uint rewardClaimed;
242 
243 	uint public votePerETH;
244 	uint public totalReward;
245 	uint public startBlock;
246 	uint public endBlock;
247 	address public winner;
248 
249 	event ReceiveDonate(address addr, uint value);
250 
251 	modifier respectTimeFrame() {
252 		if (!isRespectTimeFrame()) throw;
253 		_;
254 	}
255 
256 	modifier afterEnd() {
257 		if (!isAfterEnd()) throw;
258 		_;
259 	}
260 
261 	function LogoVote() {
262 		vote = new Vote();
263 		faucet = new Faucet(vote);
264 		votePerETH = 1000; // donate 0.001 ether to get 1 vote 
265 		totalReward = 0;
266 		startBlock = getBlockNumber();
267 		endBlock = startBlock + ( 30 * 24 * 60 * 60 / 15 ); //end in 30 days
268 		rewardClaimed = 0;
269 	}
270 
271 	// functions only for owner 
272 	function sendToFaucet(uint _amount) onlyOwner {
273 		if(!vote.transfer(faucet, _amount)) throw;
274 	}
275 
276 	function registLogo(address _owner, address _author, string _metadatUrl) 
277 						onlyOwner respectTimeFrame returns (address) {
278 		Logo logoAddress = new Logo(_owner, _author, _metadatUrl);
279 		logos.push(logoAddress);
280 		return logoAddress;
281 	}
282 
283 	function claimWinner () onlyOwner afterEnd {
284 		if (isLogo(winner)) throw;
285 		winner = logos[0];
286 		for (uint8 i = 1; i < logos.length; i++) {
287 			if (vote.balanceOf(logos[i]) > vote.balanceOf(winner))
288 				winner = logos[i];
289 		} 
290 	}
291 
292 	function cleanBalance () onlyOwner afterEnd {
293 		if (rewardClaimed >= logos.length || getBlockNumber() < endBlock + 43200) throw;
294 		if(!vote.transfer(owner, vote.balanceOf(this))) throw;
295 		if (!owner.send(this.balance)) throw;
296 	}
297 
298 	// normal user can donate to get votes
299 	function donate(address beneficiary) internal stopInEmergency respectTimeFrame {
300 		uint voteToSend = safeMul(msg.value, votePerETH)/(1 ether);
301 		if (!vote.transfer(beneficiary, voteToSend)) throw; 
302 		backers[beneficiary] = safeAdd(backers[beneficiary], msg.value);
303 		totalReward = safeAdd(totalReward, msg.value);
304 
305 		ReceiveDonate(beneficiary, msg.value);
306 	}
307 
308 	// normal user can get back their funds if in emergency 
309 	function getFunds() onlyInEmergency {
310 		if (backers[msg.sender] == 0) throw;
311 		uint amount = backers[msg.sender];
312 		backers[msg.sender] = 0;
313 
314 		if(!msg.sender.send(amount)) throw;
315 	}
316 
317 	// logo's owner can claim their rewards after end 
318 	function claimReward (address _receiver) stopInEmergency afterEnd {
319 		if (!isLogo(msg.sender)) throw;
320 		if (rewards[msg.sender]) throw;
321 		if (rewardClaimed == logos.length) throw;
322 		uint amount = totalReward / safeMul(2, logos.length); // all logos share the 50% of rewards
323 		if (msg.sender == winner) {
324 			amount = safeAdd(amount, totalReward/2);
325 		}
326 		rewards[msg.sender] = true;
327 		rewardClaimed = safeAdd(rewardClaimed, 1);
328 		if (!_receiver.send(amount)) throw;
329 	}
330 
331 
332 	// helper functions 
333 	function isLogo (address _logoAddress) constant returns (bool) {
334 		for (uint8 i = 0; i < logos.length; i++) {
335 			if (logos[i] == _logoAddress) return true;
336 		}
337 	}
338 
339 	function getLogos() constant returns (Logo[]) {
340 		return logos;
341 	}
342 
343 	function getBlockNumber() constant returns (uint) {
344       return block.number;
345     }
346 
347 	function isAfterEnd() constant returns (bool) {
348       return getBlockNumber() > endBlock;
349     }
350 
351 	function isRespectTimeFrame() constant returns (bool) {
352 		return getBlockNumber() < endBlock;
353 	}
354 
355 	function () payable {
356 		if (isAfterEnd()) throw;
357 		donate(msg.sender);
358 	}
359 }