1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4 	uint256 public totalSupply;
5 
6 	function balanceOf(address who) public view returns (uint256 balance);
7 
8 	function allowance(address owner, address spender) public view returns (uint256 remaining);
9 
10 	function transfer(address to, uint256 value) public returns (bool success);
11 
12 	function approve(address spender, uint256 value) public returns (bool success);
13 
14 	function transferFrom(address from, address to, uint256 value) public returns (bool success);
15 
16 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
17 
18 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 library SafeMath {
22 	function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
23 		c = a - b;
24 		assert(b <= a && c <= a);
25 		return c;
26 	}
27 
28 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
29 		c = a + b;
30 		assert(c >= a && c>=b);
31 		return c;
32 	}
33 }
34 
35 library SafeERC20 {
36 	function safeTransfer(ERC20 _token, address _to, uint256 _value) internal {
37 		require(_token.transfer(_to, _value));
38 	}
39 }
40 
41 contract Owned {
42 	address public owner;
43 
44 	constructor() public {
45 		owner = msg.sender;
46 	}
47 
48 	modifier onlyOwner {
49 		require(msg.sender == owner,"O1- Owner only function");
50 		_;
51 	}
52 
53 	function setOwner(address newOwner) onlyOwner public {
54 		owner = newOwner;
55 	}
56 }
57 
58 contract Pausable is Owned {
59 	event Pause();
60 	event Unpause();
61 
62 	bool public paused = false;
63 
64 	modifier whenNotPaused() {
65 		require(!paused);
66 		_;
67 	}
68 
69 	modifier whenPaused() {
70 		require(paused);
71 		_;
72 	}
73 
74 	function pause() public onlyOwner whenNotPaused {
75 		paused = true;
76 		emit Pause();
77 	}
78 
79 	function unpause() public onlyOwner whenPaused {
80 		paused = false;
81 		emit Unpause();
82 	}
83 }
84 
85 contract VIDToken is Owned, Pausable, ERC20 {
86 	using SafeMath for uint256;
87 	using SafeERC20 for ERC20;
88 
89 	mapping (address => uint256) public balances;
90 	mapping (address => mapping (address => uint256)) public allowed;
91 	mapping (address => bool) public frozenAccount;
92 	mapping (address => bool) public verifyPublisher;
93 	mapping (address => bool) public verifyWallet;
94 
95 	struct fStruct { uint256 index; }
96 	mapping(string => fStruct) private fileHashes;
97 	string[] private fileIndex;
98 
99 	string public constant name = "V-ID Token";
100 	uint8 public constant decimals = 18;
101 	string public constant symbol = "VIDT";
102 	uint256 public constant initialSupply = 100000000;
103 
104 	uint256 public validationPrice = 7 * 10 ** uint(decimals);
105 	address public validationWallet = address(0);
106 
107 	constructor() public {
108 		validationWallet = msg.sender;
109 		verifyWallet[msg.sender] = true;
110 		totalSupply = initialSupply * 10 ** uint(decimals);
111 		balances[msg.sender] = totalSupply;
112 		emit Transfer(address(0),owner,initialSupply);
113 	}
114 
115 	function () public payable {
116 		revert();
117 	}
118 
119 	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
120 		require(_to != msg.sender,"T1- Recipient can not be the same as sender");
121 		require(_to != address(0),"T2- Please check the recipient address");
122 		require(balances[msg.sender] >= _value,"T3- The balance of sender is too low");
123 		require(!frozenAccount[msg.sender],"T4- The wallet of sender is frozen");
124 		require(!frozenAccount[_to],"T5- The wallet of recipient is frozen");
125 
126 		balances[msg.sender] = balances[msg.sender].sub(_value);
127 		balances[_to] = balances[_to].add(_value);
128 
129 		emit Transfer(msg.sender, _to, _value);
130 
131 		return true;
132 	}
133 
134 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
135 		require(_to != address(0),"TF1- Please check the recipient address");
136 		require(balances[_from] >= _value,"TF2- The balance of sender is too low");
137 		require(allowed[_from][msg.sender] >= _value,"TF3- The allowance of sender is too low");
138 		require(!frozenAccount[_from],"TF4- The wallet of sender is frozen");
139 		require(!frozenAccount[_to],"TF5- The wallet of recipient is frozen");
140 
141 		balances[_from] = balances[_from].sub(_value);
142 		balances[_to] = balances[_to].add(_value);
143 
144 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145 
146 		emit Transfer(_from, _to, _value);
147 
148 		return true;
149 	}
150 
151 	function balanceOf(address _owner) public view returns (uint256 balance) {
152 		return balances[_owner];
153 	}
154 
155 	function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
156 		require((_value == 0) || (allowed[msg.sender][_spender] == 0),"A1- Reset allowance to 0 first");
157 
158 		allowed[msg.sender][_spender] = _value;
159 
160 		emit Approval(msg.sender, _spender, _value);
161 
162 		return true;
163 	}
164 
165 	function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {
166 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
167 
168 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169 
170 		return true;
171 	}
172 
173 	function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {
174 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_subtractedValue);
175 
176 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177 
178 		return true;
179 	}
180 
181 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
182 		return allowed[_owner][_spender];
183 	}
184 
185 	struct TKN { address sender; uint256 value; bytes data; bytes4 sig; }
186 
187 	function tokenFallback(address _from, uint256 _value, bytes _data) public pure returns (bool) {
188 		TKN memory tkn;
189 		tkn.sender = _from;
190 		tkn.value = _value;
191 		tkn.data = _data;
192 		uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
193 		tkn.sig = bytes4(u);
194 		return true;
195 	}
196 
197 	function transferToken(address tokenAddress, uint256 tokens) public onlyOwner {
198 		ERC20(tokenAddress).safeTransfer(owner,tokens);
199 	}
200 
201 	function burn(uint256 _value) public onlyOwner returns (bool) {
202 		require(_value <= balances[msg.sender],"B1- The balance of burner is too low");
203 
204 		balances[msg.sender] = balances[msg.sender].sub(_value);
205 		totalSupply = totalSupply.sub(_value);
206 
207 		emit Burn(msg.sender, _value);
208 
209 		emit Transfer(msg.sender, address(0), _value);
210 
211 		return true;
212 	}
213 
214 	function freeze(address _address, bool _state) public onlyOwner returns (bool) {
215 		frozenAccount[_address] = _state;
216 
217 		emit Freeze(_address, _state);
218 
219 		return true;
220 	}
221 
222 	function validatePublisher(address Address, bool State, string Publisher) public onlyOwner returns (bool) {
223 		verifyPublisher[Address] = State;
224 
225 		emit ValidatePublisher(Address,State,Publisher);
226 
227 		return true;
228 	}
229 
230 	function validateWallet(address Address, bool State, string Wallet) public onlyOwner returns (bool) {
231 		verifyWallet[Address] = State;
232 
233 		emit ValidateWallet(Address,State,Wallet);
234 
235 		return true;
236 	}
237 
238 	function validateFile(address To, uint256 Payment, bytes Data, bool cStore, bool eLog) public whenNotPaused returns (bool) {
239 		require(Payment>=validationPrice,"V1- Insufficient payment provided");
240 		require(verifyPublisher[msg.sender],"V2- Unverified publisher address");
241 		require(!frozenAccount[msg.sender],"V3- The wallet of publisher is frozen");
242 		require(Data.length == 64,"V4- Invalid hash provided");
243 
244 		if (!verifyWallet[To] || frozenAccount[To]) {
245 			To = validationWallet;
246 		}
247 
248 		uint256 index = 0;
249 		string memory fileHash = string(Data);
250 
251 		if (cStore) {
252 			if (fileIndex.length > 0) {
253 				require(fileHashes[fileHash].index == 0,"V5- This hash was previously validated");
254 			}
255 
256 			fileHashes[fileHash].index = fileIndex.push(fileHash)-1;
257 			index = fileHashes[fileHash].index;
258 		}
259 
260 		if (allowed[To][msg.sender] >= Payment) {
261 			allowed[To][msg.sender] = allowed[To][msg.sender].sub(Payment);
262 		} else {
263 			balances[msg.sender] = balances[msg.sender].sub(Payment);
264 			balances[To] = balances[To].add(Payment);
265 		}
266 
267 		emit Transfer(msg.sender, To, Payment);
268 
269 		if (eLog) {
270 			emit ValidateFile(index,fileHash);
271 		}
272 
273 		return true;
274 	}
275 
276 	function verifyFile(string fileHash) public view returns (bool) {
277 		if (fileIndex.length == 0) {
278 			return false;
279 		}
280 
281 		bytes memory a = bytes(fileIndex[fileHashes[fileHash].index]);
282 		bytes memory b = bytes(fileHash);
283 
284 		if (a.length != b.length) {
285 			return false;
286 		}
287 
288 		for (uint256 i = 0; i < a.length; i ++) {
289 			if (a[i] != b[i]) {
290 				return false;
291 			}
292 		}
293 
294 		return true;
295 	}
296 
297 	function setPrice(uint256 newPrice) public onlyOwner {
298 		validationPrice = newPrice;
299 	}
300 
301 	function setWallet(address newWallet) public onlyOwner {
302 		validationWallet = newWallet;
303 	}
304 
305 	function listFiles(uint256 startAt, uint256 stopAt) onlyOwner public returns (bool) {
306 		if (fileIndex.length == 0) {
307 			return false;
308 		}
309 
310 		require(startAt <= fileIndex.length-1,"L1- Please select a valid start");
311 
312 		if (stopAt > 0) {
313 			require(stopAt > startAt && stopAt <= fileIndex.length-1,"L2- Please select a valid stop");
314 		} else {
315 			stopAt = fileIndex.length-1;
316 		}
317 
318 		for (uint256 i = startAt; i <= stopAt; i++) {
319 			emit LogEvent(i,fileIndex[i]);
320 		}
321 
322 		return true;
323 	}
324 
325 	event Burn(address indexed burner, uint256 value);
326 	event Freeze(address target, bool frozen);
327 
328 	event ValidateFile(uint256 index, string data);
329 	event ValidatePublisher(address indexed publisherAddress, bool state, string indexed publisherName);
330 	event ValidateWallet(address indexed walletAddress, bool state, string indexed walletName);
331 
332 	event LogEvent(uint256 index, string data) anonymous;
333 }