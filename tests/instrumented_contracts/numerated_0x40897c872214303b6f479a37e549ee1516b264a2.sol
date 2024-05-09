1 pragma solidity 0.5.17;
2 
3 // ----------------------------------------------------------------------------
4 // 'FLETA' 'Fleta Token' token contract
5 //
6 // Symbol	  : FLETA
7 // Name		: Fleta Token
8 // Total supply: 2,000,000,000 (Same as 0x7788D759F21F53533051A9AE657fA05A1E068fc6)
9 // Decimals	: 18
10 //
11 // Enjoy.
12 //
13 // (c) Sam Jeong / SendSquare Co. 2021. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 library SafeMath {
20 	function add(uint a, uint b) internal pure returns (uint c) {
21 		c = a + b;
22 		require(c >= a);
23 	}
24 	function sub(uint a, uint b) internal pure returns (uint c) {
25 		require(b <= a);
26 		c = a - b;
27 	}
28 	function mul(uint a, uint b) internal pure returns (uint c) {
29 		c = a * b;
30 		require(a == 0 || c / a == b);
31 	}
32 	function div(uint a, uint b) internal pure returns (uint c) {
33 		require(b > 0);
34 		c = a / b;
35 	}
36 }
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43 	function totalSupply() public view returns (uint);
44 	function balanceOf(address tokenOwner) public view returns (uint balance);
45 	function allowance(address tokenOwner, address spender) public view returns (uint remaining);
46 	function transfer(address to, uint tokens) public returns (bool success);
47 	function approve(address spender, uint tokens) public returns (bool success);
48 	function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50 	event Transfer(address indexed from, address indexed to, uint tokens);
51 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 contract Fletav2Gateway {
55 	function isGatewayAddress(address gatewayAddress) public view returns (bool);
56 }
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64 	function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72 	address public owner;
73 
74 	constructor() public {
75 		owner = msg.sender;
76 	}
77 
78 	modifier onlyOwner {
79 		require(msg.sender == owner, "only owner");
80 		_;
81 	}
82 }
83 
84 
85 // ----------------------------------------------------------------------------
86 // Manager contract
87 // ----------------------------------------------------------------------------
88 contract Managed is Owned {
89 	address public manager;
90 
91 	constructor() public {
92 		manager = msg.sender;
93 	}
94 
95 	modifier onlyManager {
96 		require(msg.sender == manager, "only manager");
97 		_;
98 	}
99 	
100 	// ------------------------------------------------------------------------
101 	// Change gateway manager
102 	// ------------------------------------------------------------------------
103 	function setGatewayManager(address addr) public onlyOwner {
104 		require(addr > address(0), "cannot setGatewayManager to 0x0");
105 		manager = addr;
106 	}
107 }
108 
109 // ----------------------------------------------------------------------------
110 // ERC20 Token, with the addition of symbol, name and decimals and a
111 // fixed supply
112 // ----------------------------------------------------------------------------
113 contract FletaV2Token is ERC20Interface, Owned, Managed {
114 	using SafeMath for uint;
115 
116 	string public symbol;
117 	string public name;
118 	uint8 public decimals;
119 	uint _totalSupply;
120 	bool _stopTrade;
121 
122 	mapping(address => uint) balances;
123 	mapping(address => mapping(address => uint)) allowed;
124 
125 	//Changes v2
126 	address public v1Address;
127 	mapping(address => bool) mswap;
128 	mapping(address => bool) mgatewayAddress;
129 
130 	// ------------------------------------------------------------------------
131 	// Constructor
132 	// The parameters of the constructor were added in v2.
133 	// ------------------------------------------------------------------------
134 	constructor(address v1Addr) public {
135 		symbol = "FLETA";
136 		name = "Fleta Token";
137 		decimals = 18;
138 // 		_stopTrade = false;
139 
140 		//blow Changes v2
141 //  	balances[owner] = 0;
142 
143 		_totalSupply = ERC20Interface(v1Addr).totalSupply();
144 		v1Address = v1Addr;
145 	}
146 
147 
148 	// ------------------------------------------------------------------------
149 	// Total supply
150 	// ------------------------------------------------------------------------
151 	function totalSupply() public view returns (uint) {
152 		return _totalSupply.sub(balances[address(0)]);
153 	}
154 
155 
156 	// ------------------------------------------------------------------------
157 	// Stop Trade
158 	// ------------------------------------------------------------------------
159 	function stopTrade() public onlyOwner {
160 		require(!_stopTrade, "already stop trade");
161 		_stopTrade = true;
162 	}
163 
164 
165 	// ------------------------------------------------------------------------
166 	// Start Trade
167 	// ------------------------------------------------------------------------
168 	function startTrade() public onlyOwner {
169 		require(_stopTrade, "already start trade");
170 		_stopTrade = false;
171 	}
172 
173 	// ------------------------------------------------------------------------
174 	// Get the token balance for account `tokenOwner`
175 	// Changes in v2 
176 	// - before swap, use V1 + V2 balance
177 	// - after swap, use V2 balance
178 	// ------------------------------------------------------------------------
179 	function balanceOf(address tokenOwner) public view returns (uint) {
180 		if (mswap[tokenOwner]) {
181 			return balances[tokenOwner];
182 		}
183 		return ERC20Interface(v1Address).balanceOf(tokenOwner).add(balances[tokenOwner]);
184 	}
185 
186 
187 	// ------------------------------------------------------------------------
188 	// Transfer the balance from token owner's account to `to` account
189 	// - Owner's account must have sufficient balance to transfer
190 	// - 0 value transfers are allowed
191 	// Changes in v2 
192 	// - insection _swap function See {_swap}
193 	// ------------------------------------------------------------------------
194 	function transfer(address to, uint tokens) public returns (bool) {
195 		require(!_stopTrade, "stop trade");
196 		_swap(msg.sender);
197 		require(to > address(0), "cannot transfer to 0x0");
198 
199 		balances[msg.sender] = balances[msg.sender].sub(tokens);
200 
201 		if (mgatewayAddress[to]) {
202 			//balances[to] = balances[to].add(tokens);
203 			//balances[to] = balances[to].sub(tokens);
204 			_totalSupply = _totalSupply.sub(tokens);
205 			emit Transfer(to, address(0), tokens);
206 		} else {
207 			balances[to] = balances[to].add(tokens);
208 		}
209 		emit Transfer(msg.sender, to, tokens);
210 
211 		return true;
212 	}
213 
214 
215 	// ------------------------------------------------------------------------
216 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
217 	// from the token owner's account
218 	//
219 	// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
220 	// recommends that there are no checks for the approval double-spend attack
221 	// as this should be implemented in user interfaces
222 	// ------------------------------------------------------------------------
223 	function approve(address spender, uint tokens) public returns (bool) {
224 		require(!_stopTrade, "stop trade");
225 		_swap(msg.sender);
226 
227 		allowed[msg.sender][spender] = tokens;
228 		emit Approval(msg.sender, spender, tokens);
229 		return true;
230 	}
231 
232 
233 	// ------------------------------------------------------------------------
234 	// Transfer `tokens` from the `from` account to the `to` account
235 	//
236 	// The calling account must already have sufficient tokens approve(...)-d
237 	// for spending from the `from` account and
238 	// - From account must have sufficient balance to transfer
239 	// - Spender must have sufficient allowance to transfer
240 	// - 0 value transfers are allowed
241 	// ------------------------------------------------------------------------
242 	function transferFrom(address from, address to, uint tokens) public returns (bool) {
243 		require(!_stopTrade, "stop trade");
244 		_swap(msg.sender);
245 		require(from > address(0), "cannot transfer from 0x0");
246 		require(to > address(0), "cannot transfer to 0x0");
247 
248 		balances[from] = balances[from].sub(tokens);
249 		if(from != to && from != msg.sender) {
250 			allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
251 		}
252 
253 		if (mgatewayAddress[to]) {
254 			//balances[to] = balances[to].add(tokens);
255 			//balances[to] = balances[to].sub(tokens);
256 			_totalSupply = _totalSupply.sub(tokens);
257 			emit Transfer(to, address(0), tokens);
258 		} else {
259 			balances[to] = balances[to].add(tokens);
260 		}
261 		emit Transfer(from, to, tokens);
262 
263 		return true;
264 	}
265 
266 
267 	// ------------------------------------------------------------------------
268 	// Returns the amount of tokens approved by the owner that can be
269 	// transferred to the spender's account
270 	// ------------------------------------------------------------------------
271 	function allowance(address tokenOwner, address spender) public view returns (uint) {
272 		require(!_stopTrade, "stop trade");
273 		return allowed[tokenOwner][spender];
274 	}
275 
276 
277 	// ------------------------------------------------------------------------
278 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
279 	// from the token owner's account. The `spender` contract function
280 	// `receiveApproval(...)` is then executed
281 	// ------------------------------------------------------------------------
282 	function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool) {
283 		require(msg.sender != spender, "msg.sender == spender");
284 
285 		allowed[msg.sender][spender] = tokens;
286 		emit Approval(msg.sender, spender, tokens);
287 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
288 		return true;
289 	}
290 
291 
292 	// ------------------------------------------------------------------------
293 	// Don't accept ETH
294 	// ------------------------------------------------------------------------
295 	function () external payable {
296 		revert();
297 	}
298 
299 
300 	// ------------------------------------------------------------------------
301 	// Owner can transfer out any accidentally sent ERC20 tokens
302 	// ------------------------------------------------------------------------
303 	function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool) {
304 		return ERC20Interface(tokenAddress).transfer(owner, tokens);
305 	}
306 
307 // ------------------------------------------------------------------------
308 // Below functions added to v2 
309 // ------------------------------------------------------------------------
310 	// ------------------------------------------------------------------------
311 	// Swap the token in v1 to v2.
312 	// ------------------------------------------------------------------------
313 	function swap(address swapAddr) public returns (bool) {
314 		require(!mswap[swapAddr], "already swap");
315 		_swap(swapAddr);
316 		return true;
317 	}
318 	function _swap(address swapAddr) private {
319 		if (!mswap[swapAddr]) {
320 			mswap[swapAddr] = true;
321 			uint _value = ERC20Interface(v1Address).balanceOf(swapAddr);
322 			balances[swapAddr] = balances[swapAddr].add(_value);
323 		}
324 	}
325 
326 	function isGatewayAddress(address gAddr) public view returns (bool) {
327 		return mgatewayAddress[gAddr];
328 	}
329 
330 	// ------------------------------------------------------------------------
331 	// Burns a specific amount of tokens
332 	// ------------------------------------------------------------------------
333 	function _burn(address burner, uint256 _value) private {
334 		_swap(burner);
335 
336 		balances[burner] = balances[burner].sub(_value);
337 		_totalSupply = _totalSupply.sub(_value);
338 
339 		emit Transfer(burner, address(0), _value);
340 	}
341 
342 	// ------------------------------------------------------------------------
343 	// Minting a specific amount of tokens
344 	// ------------------------------------------------------------------------
345 	function mint(address minter, uint256 _value) public onlyManager {
346 		require(!_stopTrade, "stop trade");
347 		_swap(minter);
348 		balances[minter] = balances[minter].add(_value);
349 		_totalSupply = _totalSupply.add(_value);
350 
351 		emit Transfer(address(0), minter, _value);
352 	}
353 
354 	// ------------------------------------------------------------------------
355 	// The gateway address is the eth address connected to the FLETA mainnet.
356 	// The transferred amount to this address is burned and minted to the FLETA mainnet address associated with this address.
357 	// ------------------------------------------------------------------------
358 	function depositGatewayAdd(address gatewayAddr) public onlyManager {
359 		require(!_stopTrade, "stop trade");
360 		mgatewayAddress[gatewayAddr] = true;
361 		if (balanceOf(gatewayAddr) > 0) {
362 			_burn(gatewayAddr, balanceOf(gatewayAddr));
363 		}
364 	}
365 
366 	// ------------------------------------------------------------------------
367 	// Remove gateway address map, revert normal address
368 	// ------------------------------------------------------------------------
369 	function depositGatewayRemove(address gatewayAddr) public onlyManager {
370 		require(!_stopTrade, "stop trade");
371 		mgatewayAddress[gatewayAddr] = false;
372 	}
373 
374 }