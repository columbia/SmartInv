1 // Unattributed material copyright New Alchemy Limited, 2017. All rights reserved.
2 pragma solidity >=0.4.10;
3 
4 // from Zeppelin
5 contract SafeMath {
6     function safeMul(uint a, uint b) internal returns (uint) {
7         uint c = a * b;
8         require(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function safeSub(uint a, uint b) internal returns (uint) {
13         require(b <= a);
14         return a - b;
15     }
16 
17     function safeAdd(uint a, uint b) internal returns (uint) {
18         uint c = a + b;
19         require(c>=a && c>=b);
20         return c;
21     }
22 }
23 // end from Zeppelin
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
91 
92 	function claimEther() onlyOwner {
93 		owner.transfer(this.balance);
94 	}
95 }
96 
97 contract EventDefinitions {
98 	event Transfer(address indexed from, address indexed to, uint value);
99 	event Approval(address indexed owner, address indexed spender, uint value);
100 }
101 
102 contract Token is Finalizable, TokenReceivable, SafeMath, EventDefinitions, Pausable {
103 	// Set these appropriately before you deploy
104 	string constant public name = "Token Report";
105 	uint8 constant public decimals = 8;
106 	string constant public symbol = "EDGE";
107 	Controller public controller;
108 	string public motd;
109 	event Motd(string message);
110 
111 	// functions below this line are onlyOwner
112 
113 	// set "message of the day"
114 	function setMotd(string _m) onlyOwner {
115 		motd = _m;
116 		Motd(_m);
117 	}
118 
119 	function setController(address _c) onlyOwner notFinalized {
120 		controller = Controller(_c);
121 	}
122 
123 	// functions below this line are public
124 
125 	function balanceOf(address a) constant returns (uint) {
126 		return controller.balanceOf(a);
127 	}
128 
129 	function totalSupply() constant returns (uint) {
130 		return controller.totalSupply();
131 	}
132 
133 	function allowance(address _owner, address _spender) constant returns (uint) {
134 		return controller.allowance(_owner, _spender);
135 	}
136 
137 	function transfer(address _to, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
138 		if (controller.transfer(msg.sender, _to, _value)) {
139 			Transfer(msg.sender, _to, _value);
140 			return true;
141 		}
142 		return false;
143 	}
144 
145 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3) notPaused returns (bool success) {
146 		if (controller.transferFrom(msg.sender, _from, _to, _value)) {
147 			Transfer(_from, _to, _value);
148 			return true;
149 		}
150 		return false;
151 	}
152 
153 	function approve(address _spender, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
154 		// promote safe user behavior
155 		if (controller.approve(msg.sender, _spender, _value)) {
156 			Approval(msg.sender, _spender, _value);
157 			return true;
158 		}
159 		return false;
160 	}
161 
162 	function increaseApproval (address _spender, uint _addedValue) onlyPayloadSize(2) notPaused returns (bool success) {
163 		if (controller.increaseApproval(msg.sender, _spender, _addedValue)) {
164 			uint newval = controller.allowance(msg.sender, _spender);
165 			Approval(msg.sender, _spender, newval);
166 			return true;
167 		}
168 		return false;
169 	}
170 
171 	function decreaseApproval (address _spender, uint _subtractedValue) onlyPayloadSize(2) notPaused returns (bool success) {
172 		if (controller.decreaseApproval(msg.sender, _spender, _subtractedValue)) {
173 			uint newval = controller.allowance(msg.sender, _spender);
174 			Approval(msg.sender, _spender, newval);
175 			return true;
176 		}
177 		return false;
178 	}
179 
180 	// fallback function simply forwards Ether to the controller's fallback
181 	function () payable {
182 		controller.fallback.value(msg.value)(msg.sender);
183 	}
184 
185 	modifier onlyPayloadSize(uint numwords) {
186 		assert(msg.data.length >= numwords * 32 + 4);
187 		_;
188 	}
189 
190 	function burn(uint _amount) notPaused {
191 		controller.burn(msg.sender, _amount);
192 		Transfer(msg.sender, 0x0, _amount);
193 	}
194 
195 	// functions below this line are onlyController
196 
197 	modifier onlyController() {
198 		assert(msg.sender == address(controller));
199 		_;
200 	}
201 
202 	// In the future, when the controller supports multiple token
203 	// heads, allow the controller to reconstitute the transfer and
204 	// approval history.
205 
206 	function controllerTransfer(address _from, address _to, uint _value) onlyController {
207 		Transfer(_from, _to, _value);
208 	}
209 
210 	function controllerApprove(address _owner, address _spender, uint _value) onlyController {
211 		Approval(_owner, _spender, _value);
212 	}
213 }
214 
215 contract Controller is Owned, TokenReceivable, Finalizable {
216 	Ledger public ledger;
217 	Token public token;
218 
219 	function Controller() {
220 	}
221 
222 	// functions below this line are onlyOwner
223 
224 	function setToken(address _token) onlyOwner {
225 		token = Token(_token);
226 	}
227 
228 	function setLedger(address _ledger) onlyOwner {
229 		ledger = Ledger(_ledger);
230 	}
231 
232 	modifier onlyToken() {
233 		require(msg.sender == address(token));
234 		_;
235 	}
236 
237 	modifier onlyLedger() {
238 		require(msg.sender == address(ledger));
239 		_;
240 	}
241 
242 	// public functions
243 
244 	function totalSupply() constant returns (uint) {
245 		return ledger.totalSupply();
246 	}
247 
248 	function balanceOf(address _a) constant returns (uint) {
249 		return ledger.balanceOf(_a);
250 	}
251 
252 	function allowance(address _owner, address _spender) constant returns (uint) {
253 		return ledger.allowance(_owner, _spender);
254 	}
255 
256 	// functions below this line are onlyLedger
257 
258 	// let the ledger send transfer events (the most obvious case
259 	// is when we mint directly to the ledger and need the Transfer()
260 	// events to appear in the token)
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
290 
291 	// code below is dedicated to whitelist sale logic
292 
293 	// mapping of address to contribution amount whitelist
294 	mapping (address => uint) public whitelist;
295 	mapping (address => uint) public exchg;
296 
297 	function addToWhitelist(address addr, uint rate, uint weimax) onlyOwner {
298 		exchg[addr] = rate;
299 		whitelist[addr] = weimax;
300 	}
301 
302 	// token fallback function forwards to this
303 	function fallback(address orig) payable onlyToken {
304 		uint max = whitelist[orig];
305 		uint denom = exchg[orig];
306 		require(denom != 0);
307 		require(msg.value <= max);
308 		whitelist[orig] = max - msg.value;
309 		uint tkn = msg.value / denom;
310 		ledger.controllerMint(orig, tkn);
311 		token.controllerTransfer(0, orig, tkn);
312 	}
313 }
314 
315 contract Ledger is Owned, SafeMath, Finalizable {
316 	Controller public controller;
317 	mapping(address => uint) public balanceOf;
318 	mapping (address => mapping (address => uint)) public allowance;
319 	uint public totalSupply;
320 	uint public mintingNonce;
321 	bool public mintingStopped;
322 
323 	// functions below this line are onlyOwner
324 
325 	function Ledger() {
326 	}
327 
328 	function setController(address _controller) onlyOwner notFinalized {
329 		controller = Controller(_controller);
330 	}
331 
332 	function stopMinting() onlyOwner {
333 		mintingStopped = true;
334 	}
335 
336 	function multiMint(uint nonce, uint256[] bits) onlyOwner {
337 		require(!mintingStopped);
338 		if (nonce != mintingNonce) return;
339 		mintingNonce += 1;
340 		uint256 lomask = (1 << 96) - 1;
341 		uint created = 0;
342 		for (uint i=0; i<bits.length; i++) {
343 			address a = address(bits[i]>>96);
344 			uint value = bits[i]&lomask;
345 			balanceOf[a] = balanceOf[a] + value;
346 			controller.ledgerTransfer(0, a, value);
347 			created += value;
348 		}
349 		totalSupply += created;
350 	}
351 
352 	// functions below this line are onlyController
353 
354 	modifier onlyController() {
355 		require(msg.sender == address(controller));
356 		_;
357 	}
358 
359 	function controllerMint(address to, uint amt) onlyController {
360 		require(!mintingStopped);
361 		balanceOf[to] = safeAdd(balanceOf[to], amt);
362 		totalSupply = safeAdd(totalSupply, amt);
363 	}
364 
365 	function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
366 		if (balanceOf[_from] < _value) return false;
367 
368 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
369 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
370 		return true;
371 	}
372 
373 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
374 		if (balanceOf[_from] < _value) return false;
375 
376 		var allowed = allowance[_from][_spender];
377 		if (allowed < _value) return false;
378 
379 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
380 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
381 		allowance[_from][_spender] = safeSub(allowed, _value);
382 		return true;
383 	}
384 
385 	function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
386 		// require user to set to zero before resetting to nonzero
387 		if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
388 			return false;
389 		}
390 
391 		allowance[_owner][_spender] = _value;
392 		return true;
393 	}
394 
395 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyController returns (bool success) {
396 		uint oldValue = allowance[_owner][_spender];
397 		allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
398 		return true;
399 	}
400 
401 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyController returns (bool success) {
402 		uint oldValue = allowance[_owner][_spender];
403 		if (_subtractedValue > oldValue) {
404 			allowance[_owner][_spender] = 0;
405 		} else {
406 			allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
407 		}
408 		return true;
409 	}
410 
411 	function burn(address _owner, uint _amount) onlyController {
412 		balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
413 		totalSupply = safeSub(totalSupply, _amount);
414 	}
415 }