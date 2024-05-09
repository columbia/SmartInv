1 // Copyright New Alchemy Limited, 2017. All rights reserved.
2 
3 pragma solidity >=0.4.10;
4 
5 // from Zeppelin
6 contract SafeMath {
7 	function safeMul(uint a, uint b) internal returns (uint) {
8 		uint c = a * b;
9 		require(a == 0 || c / a == b);
10 		return c;
11 	}
12 
13 	function safeSub(uint a, uint b) internal returns (uint) {
14 		require(b <= a);
15 		return a - b;
16 	}
17 
18 	function safeAdd(uint a, uint b) internal returns (uint) {
19 		uint c = a + b;
20 		require(c>=a && c>=b);
21 		return c;
22 	}
23 }
24 
25 contract Owned {
26 	address public owner;
27 	address newOwner;
28 
29 	function Owned() {
30 		owner = msg.sender;
31 	}
32 
33 	modifier onlyOwner() {
34 		require(msg.sender == owner);
35 		_;
36 	}
37 
38 	function changeOwner(address _newOwner) onlyOwner {
39 		newOwner = _newOwner;
40 	}
41 
42 	function acceptOwnership() {
43 		if (msg.sender == newOwner) {
44 			owner = newOwner;
45 		}
46 	}
47 }
48 
49 contract Pausable is Owned {
50 	bool public paused;
51 
52 	function pause() onlyOwner {
53 		paused = true;
54 	}
55 
56 	function unpause() onlyOwner {
57 		paused = false;
58 	}
59 
60 	modifier notPaused() {
61 		require(!paused);
62 		_;
63 	}
64 }
65 
66 contract Finalizable is Owned {
67 	bool public finalized;
68 
69 	function finalize() onlyOwner {
70 		finalized = true;
71 	}
72 
73 	modifier notFinalized() {
74 		require(!finalized);
75 		_;
76 	}
77 }
78 
79 contract IToken {
80 	function transfer(address _to, uint _value) returns (bool);
81 	function balanceOf(address owner) returns(uint);
82 }
83 
84 // In case someone accidentally sends token to one of these contracts,
85 // add a way to get them back out.
86 contract TokenReceivable is Owned {
87 	function claimTokens(address _token, address _to) onlyOwner returns (bool) {
88 		IToken token = IToken(_token);
89 		return token.transfer(_to, token.balanceOf(this));
90 	}
91 }
92 
93 contract EventDefinitions {
94 	event Transfer(address indexed from, address indexed to, uint value);
95 	event TransferInternalLedgerAT(address indexed _from, address _to, uint256 indexed _value, bytes32 indexed mdn);
96 	event Approval(address indexed owner, address indexed spender, uint value);
97 }
98 
99 contract Token is Finalizable, TokenReceivable, SafeMath, EventDefinitions, Pausable {
100 	// Set these appropriately before you deploy
101 	string constant public name = "AirToken";
102 	uint8 constant public decimals = 8;
103 	string constant public symbol = "AIR";
104 	Controller public controller;
105 	string public motd;
106 	address public atFundDeposit;
107 	event Motd(string message);
108 
109 	// functions below this line are onlyOwner
110 
111 	// set "message of the day"
112 	function setMotd(string _m) onlyOwner {
113 		motd = _m;
114 		Motd(_m);
115 	}
116 
117 	function setController(address _c) onlyOwner notFinalized {
118 		controller = Controller(_c);
119 	}
120 
121 	function setBeneficiary(address _beneficiary) onlyOwner {
122 		atFundDeposit = _beneficiary;
123 	}
124 
125 	// functions below this line are public
126 
127 	function balanceOf(address a) constant returns (uint) {
128 		return controller.balanceOf(a);
129 	}
130 
131 	function totalSupply() constant returns (uint) {
132 		return controller.totalSupply();
133 	}
134 
135 	function allowance(address _owner, address _spender) constant returns (uint) {
136 		return controller.allowance(_owner, _spender);
137 	}
138 
139 	function transfer(address _to, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
140 		if (controller.transfer(msg.sender, _to, _value)) {
141 			Transfer(msg.sender, _to, _value);
142 			return true;
143 		}
144 		return false;
145 	}
146 
147 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3) notPaused returns (bool success) {
148 		if (controller.transferFrom(msg.sender, _from, _to, _value)) {
149 			Transfer(_from, _to, _value);
150 			return true;
151 		}
152 		return false;
153 	}
154 
155 	function approve(address _spender, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
156 		// promote safe user behavior
157 		if (controller.approve(msg.sender, _spender, _value)) {
158 			Approval(msg.sender, _spender, _value);
159 			return true;
160 		}
161 		return false;
162 	}
163 
164 	function increaseApproval (address _spender, uint _addedValue) onlyPayloadSize(2) notPaused returns (bool success) {
165 		if (controller.increaseApproval(msg.sender, _spender, _addedValue)) {
166 			uint newval = controller.allowance(msg.sender, _spender);
167 			Approval(msg.sender, _spender, newval);
168 			return true;
169 		}
170 		return false;
171 	}
172 
173 	function decreaseApproval (address _spender, uint _subtractedValue) onlyPayloadSize(2) notPaused returns (bool success) {
174 		if (controller.decreaseApproval(msg.sender, _spender, _subtractedValue)) {
175 			uint newval = controller.allowance(msg.sender, _spender);
176 			Approval(msg.sender, _spender, newval);
177 			return true;
178 		}
179 		return false;
180 	}
181 
182 	modifier onlyPayloadSize(uint numwords) {
183 		assert(msg.data.length >= numwords * 32 + 4);
184 		_;
185 	}
186 
187 	function burn(uint _amount) notPaused {
188 		controller.burn(msg.sender, _amount);
189 		Transfer(msg.sender, 0x0, _amount);
190 	}
191 
192 	function transferToInternalLedger(uint256 _value, bytes32 _mdn) external returns (bool success) {
193 		require(atFundDeposit != 0);
194 		if (transfer(atFundDeposit, _value)) {
195 			TransferInternalLedgerAT(msg.sender, atFundDeposit, _value, _mdn);
196 			return true;
197 		}
198 		return false;
199 	}
200 
201 	// functions below this line are onlyController
202 
203 	modifier onlyController() {
204 		assert(msg.sender == address(controller));
205 		_;
206 	}
207 
208 
209 	function controllerTransfer(address _from, address _to, uint _value) onlyController {
210 		Transfer(_from, _to, _value);
211 	}
212 
213 	function controllerApprove(address _owner, address _spender, uint _value) onlyController {
214 		Approval(_owner, _spender, _value);
215 	}
216 }
217 
218 contract Controller is Owned, Finalizable {
219 	Ledger public ledger;
220 	Token public token;
221 
222 	function Controller() {
223 	}
224 
225 	// functions below this line are onlyOwner
226 
227 	function setToken(address _token) onlyOwner {
228 		token = Token(_token);
229 	}
230 
231 	function setLedger(address _ledger) onlyOwner {
232 		ledger = Ledger(_ledger);
233 	}
234 
235 	modifier onlyToken() {
236 		require(msg.sender == address(token));
237 		_;
238 	}
239 
240 	modifier onlyLedger() {
241 		require(msg.sender == address(ledger));
242 		_;
243 	}
244 
245 	// public functions
246 
247 	function totalSupply() constant returns (uint) {
248 		return ledger.totalSupply();
249 	}
250 
251 	function balanceOf(address _a) constant returns (uint) {
252 		return ledger.balanceOf(_a);
253 	}
254 
255 	function allowance(address _owner, address _spender) constant returns (uint) {
256 		return ledger.allowance(_owner, _spender);
257 	}
258 
259 	// functions below this line are onlyLedger
260 
261 	function ledgerTransfer(address from, address to, uint val) onlyLedger {
262 		token.controllerTransfer(from, to, val);
263 	}
264 
265 	// functions below this line are onlyToken
266 
267 	function transfer(address _from, address _to, uint _value) onlyToken returns (bool success) {
268 		return ledger.transfer(_from, _to, _value);
269 	}
270 
271 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyToken returns (bool success) {
272 		return ledger.transferFrom(_spender, _from, _to, _value);
273 	}
274 
275 	function approve(address _owner, address _spender, uint _value) onlyToken returns (bool success) {
276 		return ledger.approve(_owner, _spender, _value);
277 	}
278 
279 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyToken returns (bool success) {
280 		return ledger.increaseApproval(_owner, _spender, _addedValue);
281 	}
282 
283 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyToken returns (bool success) {
284 		return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
285 	}
286 
287 	function burn(address _owner, uint _amount) onlyToken {
288 		ledger.burn(_owner, _amount);
289 	}
290 }
291 
292 contract Ledger is Owned, SafeMath, Finalizable {
293 	Controller public controller;
294 	mapping(address => uint) public balanceOf;
295 	mapping (address => mapping (address => uint)) public allowance;
296 	uint public totalSupply;
297 	uint public mintingNonce;
298 	bool public mintingStopped;
299 
300 	// functions below this line are onlyOwner
301 
302 	function Ledger() {
303 	}
304 
305 	function setController(address _controller) onlyOwner notFinalized {
306 		controller = Controller(_controller);
307 	}
308 
309 	function stopMinting() onlyOwner {
310 		mintingStopped = true;
311 	}
312 
313 	function multiMint(uint nonce, uint256[] bits) onlyOwner {
314 		require(!mintingStopped);
315 		if (nonce != mintingNonce) return;
316 		mintingNonce += 1;
317 		uint256 lomask = (1 << 96) - 1;
318 		uint created = 0;
319 		for (uint i=0; i<bits.length; i++) {
320 			address a = address(bits[i]>>96);
321 			uint value = bits[i]&lomask;
322 			balanceOf[a] = balanceOf[a] + value;
323 			controller.ledgerTransfer(0, a, value);
324 			created += value;
325 		}
326 		totalSupply += created;
327 	}
328 
329 	// functions below this line are onlyController
330 
331 	modifier onlyController() {
332 		require(msg.sender == address(controller));
333 		_;
334 	}
335 
336 	function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
337 		if (balanceOf[_from] < _value) return false;
338 
339 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
340 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
341 		return true;
342 	}
343 
344 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
345 		if (balanceOf[_from] < _value) return false;
346 
347 		var allowed = allowance[_from][_spender];
348 		if (allowed < _value) return false;
349 
350 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
351 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
352 		allowance[_from][_spender] = safeSub(allowed, _value);
353 		return true;
354 	}
355 
356 	function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
357 		// require user to set to zero before resetting to nonzero
358 		if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
359 			return false;
360 		}
361 
362 		allowance[_owner][_spender] = _value;
363 		return true;
364 	}
365 
366 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyController returns (bool success) {
367 		uint oldValue = allowance[_owner][_spender];
368 		allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
369 		return true;
370 	}
371 
372 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyController returns (bool success) {
373 		uint oldValue = allowance[_owner][_spender];
374 		if (_subtractedValue > oldValue) {
375 			allowance[_owner][_spender] = 0;
376 		} else {
377 			allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
378 		}
379 		return true;
380 	}
381 
382 	function burn(address _owner, uint _amount) onlyController {
383 		balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
384 		totalSupply = safeSub(totalSupply, _amount);
385 	}
386 }