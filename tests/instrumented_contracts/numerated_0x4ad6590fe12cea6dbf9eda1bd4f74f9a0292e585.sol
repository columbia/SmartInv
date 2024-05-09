1 pragma solidity ^0.4.21;
2 
3 contract CryptoGems {
4 
5 
6 	// Start of ERC20 Token standard
7 
8 	event Transfer(address indexed _from, address indexed _to, uint256 _value); 
9 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
10 
11 	uint256 constant private MAX_UINT256 = 2**256 - 1;
12 	string public name = "CryptoGem";
13 	string public symbol = "GEM";
14 	uint public decimals = 4;
15 	uint256 public totalSupply = 0;
16 
17 	mapping (address => uint256) public balances;
18 	mapping (address => mapping (address => uint256)) public allowed;
19 
20 	function transfer(address _to, uint256 _value) public returns (bool success) {
21 		require(balances[msg.sender] >= _value);
22 		balances[msg.sender] -= _value;
23 		balances[_to] += _value;
24 		emit Transfer(msg.sender, _to, _value);
25 		return true;
26 	}
27 
28 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
29 		uint256 allowance = allowed[_from][msg.sender];
30 		require(balances[_from] >= _value && allowance >= _value);
31 		balances[_to] += _value;
32 		balances[_from] -= _value;
33 		if (allowance < MAX_UINT256) {
34 			allowed[_from][msg.sender] -= _value;
35 		}
36 		emit Transfer(_from, _to, _value);
37 		return true;
38 	}
39 
40 	function balanceOf(address _owner) public view returns (uint256 balance) {
41 		return balances[_owner];
42 	}
43 
44 	function approve(address _spender, uint256 _value) public returns (bool success) {
45 		allowed[msg.sender][_spender] = _value;
46 		emit Approval(msg.sender, _spender, _value);
47 		return true;
48 	}
49 
50 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
51 		return allowed[_owner][_spender];
52 	}  
53 
54 	// End of ERC20 Token standard
55 
56 	event Mint(address indexed to, uint256 amount);
57 	event stateEvent(address indexed owner, uint256 id, uint64 state);
58 	event TransferMiner(address indexed owner, address indexed to, uint256 id);
59 
60 	// Structure of Miner //
61 	struct Miner {
62 		uint256 id;
63 		string name;
64 		uint64 workDuration;
65 		uint64 sleepDuration;
66 		uint64 difficulty;
67 
68 		uint256 workBlock;
69 		uint256 sleepBlock;
70 
71 		uint64 state;
72 		bytes32 hash;
73 		address owner;
74 
75 		bool onSale;
76 		uint256 salePrice;
77 
78 		uint64 exp;
79 	}
80 	
81 	Miner[] public miners;
82 
83 	uint256 public gemPerMiner = 0;
84 	uint256 public gemPerEther = 0;
85 	uint256 public etherPerMiner = 0;
86 	uint256 public etherPerSale = 0;
87 	bool public sale = true;
88 	address public contractOwner;
89 
90 
91 	function CryptoGems() public {
92 		contractOwner = msg.sender;
93 		gemPerEther = 10000 * (10**decimals);
94 		etherPerMiner = 0.5 ether;
95 		etherPerSale = 0.001 ether;
96 		gemPerMiner = 5000 * (10**decimals);
97 		sale = true;
98 	}
99 
100 	modifier onlyContractOwner() {
101 		require(msg.sender == contractOwner);
102 		_;
103 	}
104 
105 	//    Actions Payable   //
106 	function buyGems() public payable { 
107 		require( sale == true );
108 		require( msg.value > 0 );
109 		balances[ msg.sender ] += (msg.value * gemPerEther)/(1 ether);
110 		totalSupply += (msg.value * gemPerEther)/(1 ether);
111 	}
112 
113 	function buyMinersWithEther(uint64 quantity) public payable {
114 		require( sale == true );
115 		require( quantity * etherPerMiner <= msg.value);
116 		for(uint64 i=1;i<=quantity;i++) {
117 			createMiner();
118 		}
119 	}
120 	function buyMinersWithGem(uint64 quantity) public {
121 		require( sale == true );
122 		require( quantity * gemPerMiner <= balances[ msg.sender ]);
123 		balances[ msg.sender ] -= quantity * gemPerMiner;
124 		balances[ contractOwner ] += quantity * gemPerMiner;
125 
126 		emit Transfer(msg.sender, contractOwner, quantity * gemPerMiner);
127 
128 
129 		for(uint64 i=1;i<=quantity;i++) {
130 			createMiner();
131 		}
132 	}
133 
134 	function createMiner() private {
135 		uint64 nonce = 1;
136 		Miner memory _miner = Miner({
137 			id: 0,
138 			name: "",
139 			workDuration:  uint64(keccak256(miners.length, msg.sender, nonce++))%(3000-2000)+2000,
140 			sleepDuration: uint64(keccak256(miners.length, msg.sender, nonce))%(2200-1800)+1800,
141 			difficulty: uint64(keccak256(miners.length, msg.sender, nonce))%(130-100)+100,
142 			workBlock: 0,
143 			sleepBlock: 0,
144 			state: 3,
145 			hash: keccak256(miners.length, msg.sender),
146 			owner: msg.sender,
147 			onSale: false,
148 			salePrice: 0,
149 			exp: 0
150 		});
151 		uint256 id = miners.push(_miner) - 1;
152 		miners[id].id = id;
153 	}
154 
155 
156 	//   Actions   //
157 	function goToWork(uint256 id) public {
158 		require(msg.sender == miners[id].owner);
159 		uint64 state = minerState(id);
160 		miners[id].state = state;
161 		if(state == 3) {
162 			//init and ready states
163 			miners[id].workBlock = block.number;
164 			miners[id].state = 0;
165 			emit stateEvent(miners[id].owner, id, 0);
166 		}
167 	}
168 
169 	function goToSleep(uint256 id) public {
170 		require(msg.sender == miners[id].owner);
171 		uint64 state = minerState(id);
172 		miners[id].state = state;
173 		if(state == 1) {
174 			//tired state
175 			miners[id].sleepBlock = block.number;
176 			miners[id].state = 2;
177 			uint64 curLvl = getMinerLevel(id);
178 			miners[id].exp = miners[id].exp + miners[id].workDuration;
179 			uint64 lvl = getMinerLevel(id);
180 
181 			uint256 gemsMined = (10**decimals)*miners[id].workDuration / miners[id].difficulty;
182 			balances[ msg.sender ] += gemsMined;
183 			totalSupply += gemsMined;
184 
185 
186 			if(curLvl < lvl) {
187 				miners[id].difficulty = miners[id].difficulty - 2;
188 			}
189 			emit stateEvent(miners[id].owner, id, 2);
190 		}
191 	}
192 
193 	function setOnSale(uint256 id, bool _onSale, uint256 _salePrice) public payable { 
194 		require( msg.value >= etherPerSale );
195 		require( msg.sender == miners[id].owner);
196 		require( _salePrice >= 0 );
197 
198 		miners[id].onSale = _onSale;
199 		miners[id].salePrice = _salePrice;
200 	
201 	}
202 
203 	function buyMinerFromSale(uint256 id) public {
204 		require(msg.sender != miners[id].owner);
205 		require(miners[id].onSale == true);
206 		require(balances[msg.sender] >= miners[id].salePrice);
207 		transfer(miners[id].owner, miners[id].salePrice);
208 
209 		emit TransferMiner(miners[id].owner, msg.sender, id);
210 		miners[id].owner = msg.sender;
211 
212 		miners[id].onSale = false;
213 		miners[id].salePrice = 0;
214 	}
215 
216 	function transferMiner(address to, uint256 id) public returns (bool success) {
217 		require(miners[id].owner == msg.sender);
218 		miners[id].owner = to;
219 		emit TransferMiner(msg.sender, to, id);
220 		return true;
221 	}
222 
223 
224 	function nameMiner(uint256 id, string _name) public returns (bool success) {
225 		require(msg.sender == miners[id].owner);
226 		bytes memory b = bytes(miners[id].name ); // Uses memory
227 		if (b.length == 0) {
228 			miners[id].name = _name;
229 		} else return false;
230 
231 		return true;
232 	}
233 
234 	//   Calls   //
235 	function getMinersByAddress(address _address) public constant returns(uint256[]) {
236 		uint256[] memory m = new uint256[](miners.length);
237 		uint256 cnt = 0;
238 		for(uint256 i=0;i<miners.length;i++) {
239 			if(miners[i].owner == _address) {
240 				m[cnt++] = i;
241 			}
242 		}
243 		uint256[] memory ret = new uint256[](cnt);
244 		for(i=0;i<cnt;i++) {
245 			ret[i] = m[i];
246 		}
247 		return ret;
248 	}
249 
250 	function getMinersOnSale() public constant returns(uint256[]) {
251 		uint256[] memory m = new uint256[](miners.length);
252 		uint256 cnt = 0;
253 		for(uint256 i=0;i<miners.length;i++) {
254 			if(miners[i].onSale == true) {
255 				m[cnt++] = i;
256 			}
257 		}
258 		uint256[] memory ret = new uint256[](cnt);
259 		for(i=0;i<cnt;i++) {
260 			ret[i] = m[i];
261 		}
262 		return ret;
263 	}
264 
265 	function minerState(uint256 id) public constant returns (uint64) {
266 		// require(msg.sender == miners[id].owner);
267 
268 		//working
269 		if(miners[id].workBlock !=0 && block.number - miners[id].workBlock <= miners[id].workDuration) {
270 			return 0;
271 		}
272 		//sleeping
273 		if(miners[id].sleepBlock !=0 && block.number - miners[id].sleepBlock <= miners[id].sleepDuration) {
274 			return 2;
275 		}
276 		//tired
277 		if(miners[id].workBlock !=0 && block.number - miners[id].workBlock > miners[id].workDuration && miners[id].workBlock > miners[id].sleepBlock) {
278 			return 1;
279 		}
280 		//ready
281 		if(miners[id].sleepBlock !=0 && block.number - miners[id].sleepBlock > miners[id].sleepDuration && miners[id].sleepBlock > miners[id].workBlock) {
282 			return 3;
283 		}
284 		return 3;
285 	}
286 
287 	function getMinerLevel(uint256 id)  public constant returns (uint8){
288 		uint256 exp = miners[id].exp;
289 		if(exp < 15000) return 1;
290 		if(exp < 35000) return 2;
291 		if(exp < 60000) return 3;
292 		if(exp < 90000) return 4;
293 		if(exp < 125000) return 5;
294 		if(exp < 165000) return 6;
295 		if(exp < 210000) return 7;
296 		if(exp < 260000) return 8;
297 		if(exp < 315000) return 9;
298 		return 10;
299 	}
300 	
301 
302 
303 	//   Admin Only   //
304 	function withdrawEther(address _sendTo, uint256 _amount) onlyContractOwner public returns(bool) {
305 	    
306         address CryptoGemsContract = this;
307 		if (_amount > CryptoGemsContract.balance) {
308 			_sendTo.transfer(CryptoGemsContract.balance);
309 		} else {
310 			_sendTo.transfer(_amount);
311 		}
312 		return true;
313 	}
314 	function changeContractOwner(address _contractOwner) onlyContractOwner public {
315 		contractOwner = _contractOwner;
316 	}
317 	function setMinerPrice(uint256 _amount) onlyContractOwner public returns(bool) {
318 		etherPerMiner = _amount;
319 		return true;
320 	}
321 	function setGemPerMiner(uint256 _amount) onlyContractOwner public returns(bool) {
322 		gemPerMiner = _amount;
323 		return true;
324 	}
325 	function setSale(bool _sale) onlyContractOwner public returns(bool) {
326 		sale = _sale;
327 		return true;
328 	}
329 	function setGemPrice(uint256 _amount) onlyContractOwner public returns(bool) {
330 		gemPerEther = _amount;
331 		return true;
332 	}
333 
334 }