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
208 	// In the future, when the controller supports multiple token
209 	// heads, allow the controller to reconstitute the transfer and
210 	// approval history.
211 
212 	function controllerTransfer(address _from, address _to, uint _value) onlyController {
213 		Transfer(_from, _to, _value);
214 	}
215 
216 	function controllerApprove(address _owner, address _spender, uint _value) onlyController {
217 		Approval(_owner, _spender, _value);
218 	}
219 }
220 
221 contract Controller is Owned, Finalizable {
222 	Ledger public ledger;
223 	Token public token;
224 
225 	function Controller() {
226 	}
227 
228 	// functions below this line are onlyOwner
229 
230 	function setToken(address _token) onlyOwner {
231 		token = Token(_token);
232 	}
233 
234 	function setLedger(address _ledger) onlyOwner {
235 		ledger = Ledger(_ledger);
236 	}
237 
238 	modifier onlyToken() {
239 		require(msg.sender == address(token));
240 		_;
241 	}
242 
243 	modifier onlyLedger() {
244 		require(msg.sender == address(ledger));
245 		_;
246 	}
247 
248 	// public functions
249 
250 	function totalSupply() constant returns (uint) {
251 		return ledger.totalSupply();
252 	}
253 
254 	function balanceOf(address _a) constant returns (uint) {
255 		return ledger.balanceOf(_a);
256 	}
257 
258 	function allowance(address _owner, address _spender) constant returns (uint) {
259 		return ledger.allowance(_owner, _spender);
260 	}
261 
262 	// functions below this line are onlyLedger
263 
264 	// let the ledger send transfer events (the most obvious case
265 	// is when we mint directly to the ledger and need the Transfer()
266 	// events to appear in the token)
267 	function ledgerTransfer(address from, address to, uint val) onlyLedger {
268 		token.controllerTransfer(from, to, val);
269 	}
270 
271 	// functions below this line are onlyToken
272 
273 	function transfer(address _from, address _to, uint _value) onlyToken returns (bool success) {
274 		return ledger.transfer(_from, _to, _value);
275 	}
276 
277 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyToken returns (bool success) {
278 		return ledger.transferFrom(_spender, _from, _to, _value);
279 	}
280 
281 	function approve(address _owner, address _spender, uint _value) onlyToken returns (bool success) {
282 		return ledger.approve(_owner, _spender, _value);
283 	}
284 
285 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyToken returns (bool success) {
286 		return ledger.increaseApproval(_owner, _spender, _addedValue);
287 	}
288 
289 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyToken returns (bool success) {
290 		return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
291 	}
292 
293 	function burn(address _owner, uint _amount) onlyToken {
294 		ledger.burn(_owner, _amount);
295 	}
296 }
297 
298 contract Ledger is Owned, SafeMath, Finalizable {
299 	Controller public controller;
300 	mapping(address => uint) public balanceOf;
301 	mapping (address => mapping (address => uint)) public allowance;
302 	uint public totalSupply;
303 	uint public mintingNonce;
304 	bool public mintingStopped;
305 
306 	// functions below this line are onlyOwner
307 
308 	function Ledger() {
309 	}
310 
311 	function setController(address _controller) onlyOwner notFinalized {
312 		controller = Controller(_controller);
313 	}
314 
315 	function stopMinting() onlyOwner {
316 		mintingStopped = true;
317 	}
318 
319 	function multiMint(uint nonce, uint256[] bits) onlyOwner {
320 		require(!mintingStopped);
321 		if (nonce != mintingNonce) return;
322 		mintingNonce += 1;
323 		uint256 lomask = (1 << 96) - 1;
324 		uint created = 0;
325 		for (uint i=0; i<bits.length; i++) {
326 			address a = address(bits[i]>>96);
327 			uint value = bits[i]&lomask;
328 			balanceOf[a] = balanceOf[a] + value;
329 			controller.ledgerTransfer(0, a, value);
330 			created += value;
331 		}
332 		totalSupply += created;
333 	}
334 
335 	// functions below this line are onlyController
336 
337 	modifier onlyController() {
338 		require(msg.sender == address(controller));
339 		_;
340 	}
341 
342 	function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
343 		if (balanceOf[_from] < _value) return false;
344 
345 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
346 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
347 		return true;
348 	}
349 
350 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
351 		if (balanceOf[_from] < _value) return false;
352 
353 		var allowed = allowance[_from][_spender];
354 		if (allowed < _value) return false;
355 
356 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
357 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
358 		allowance[_from][_spender] = safeSub(allowed, _value);
359 		return true;
360 	}
361 
362 	function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
363 		// require user to set to zero before resetting to nonzero
364 		if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
365 			return false;
366 		}
367 
368 		allowance[_owner][_spender] = _value;
369 		return true;
370 	}
371 
372 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyController returns (bool success) {
373 		uint oldValue = allowance[_owner][_spender];
374 		allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
375 		return true;
376 	}
377 
378 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyController returns (bool success) {
379 		uint oldValue = allowance[_owner][_spender];
380 		if (_subtractedValue > oldValue) {
381 			allowance[_owner][_spender] = 0;
382 		} else {
383 			allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
384 		}
385 		return true;
386 	}
387 
388 	function burn(address _owner, uint _amount) onlyController {
389 		balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
390 		totalSupply = safeSub(totalSupply, _amount);
391 	}
392 }