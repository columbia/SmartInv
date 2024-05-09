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
91 }
92 
93 contract EventDefinitions {
94 	event Transfer(address indexed from, address indexed to, uint value);
95 	event Approval(address indexed owner, address indexed spender, uint value);
96 }
97 
98 contract Token is Finalizable, TokenReceivable, SafeMath, EventDefinitions, Pausable {
99 	// Set these appropriately before you deploy
100 	string constant public name = "Chicken Token";
101 	uint8 constant public decimals = 8;
102 	string constant public symbol = "?";
103 	Controller public controller;
104 	string public motd;
105 	event Motd(string message);
106 
107 	// functions below this line are onlyOwner
108 
109 	// set "message of the day"
110 	function setMotd(string _m) onlyOwner {
111 		motd = _m;
112 		Motd(_m);
113 	}
114 
115 	function setController(address _c) onlyOwner notFinalized {
116 		controller = Controller(_c);
117 	}
118 
119 	// functions below this line are public
120 
121 	function balanceOf(address a) constant returns (uint) {
122 		return controller.balanceOf(a);
123 	}
124 
125 	function totalSupply() constant returns (uint) {
126 		return controller.totalSupply();
127 	}
128 
129 	function allowance(address _owner, address _spender) constant returns (uint) {
130 		return controller.allowance(_owner, _spender);
131 	}
132 
133 	function transfer(address _to, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
134 		if (controller.transfer(msg.sender, _to, _value)) {
135 			Transfer(msg.sender, _to, _value);
136 			return true;
137 		}
138 		return false;
139 	}
140 
141 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3) notPaused returns (bool success) {
142 		if (controller.transferFrom(msg.sender, _from, _to, _value)) {
143 			Transfer(_from, _to, _value);
144 			return true;
145 		}
146 		return false;
147 	}
148 
149 	function approve(address _spender, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
150 		// promote safe user behavior
151 		if (controller.approve(msg.sender, _spender, _value)) {
152 			Approval(msg.sender, _spender, _value);
153 			return true;
154 		}
155 		return false;
156 	}
157 
158 	function increaseApproval (address _spender, uint _addedValue) onlyPayloadSize(2) notPaused returns (bool success) {
159 		if (controller.increaseApproval(msg.sender, _spender, _addedValue)) {
160 			uint newval = controller.allowance(msg.sender, _spender);
161 			Approval(msg.sender, _spender, newval);
162 			return true;
163 		}
164 		return false;
165 	}
166 
167 	function decreaseApproval (address _spender, uint _subtractedValue) onlyPayloadSize(2) notPaused returns (bool success) {
168 		if (controller.decreaseApproval(msg.sender, _spender, _subtractedValue)) {
169 			uint newval = controller.allowance(msg.sender, _spender);
170 			Approval(msg.sender, _spender, newval);
171 			return true;
172 		}
173 		return false;
174 	}
175 
176 	modifier onlyPayloadSize(uint numwords) {
177 		assert(msg.data.length >= numwords * 32 + 4);
178 		_;
179 	}
180 
181 	function burn(uint _amount) notPaused {
182 		controller.burn(msg.sender, _amount);
183 		Transfer(msg.sender, 0x0, _amount);
184 	}
185 
186 	// functions below this line are onlyController
187 
188 	modifier onlyController() {
189 		assert(msg.sender == address(controller));
190 		_;
191 	}
192 
193 	// In the future, when the controller supports multiple token
194 	// heads, allow the controller to reconstitute the transfer and
195 	// approval history.
196 
197 	function controllerTransfer(address _from, address _to, uint _value) onlyController {
198 		Transfer(_from, _to, _value);
199 	}
200 
201 	function controllerApprove(address _owner, address _spender, uint _value) onlyController {
202 		Approval(_owner, _spender, _value);
203 	}
204 }
205 
206 contract Controller is Owned, Finalizable {
207 	Ledger public ledger;
208 	Token public token;
209 
210 	function Controller() {
211 	}
212 
213 	// functions below this line are onlyOwner
214 
215 	function setToken(address _token) onlyOwner {
216 		token = Token(_token);
217 	}
218 
219 	function setLedger(address _ledger) onlyOwner {
220 		ledger = Ledger(_ledger);
221 	}
222 
223 	modifier onlyToken() {
224 		require(msg.sender == address(token));
225 		_;
226 	}
227 
228 	modifier onlyLedger() {
229 		require(msg.sender == address(ledger));
230 		_;
231 	}
232 
233 	// public functions
234 
235 	function totalSupply() constant returns (uint) {
236 		return ledger.totalSupply();
237 	}
238 
239 	function balanceOf(address _a) constant returns (uint) {
240 		return ledger.balanceOf(_a);
241 	}
242 
243 	function allowance(address _owner, address _spender) constant returns (uint) {
244 		return ledger.allowance(_owner, _spender);
245 	}
246 
247 	// functions below this line are onlyLedger
248 
249 	// let the ledger send transfer events (the most obvious case
250 	// is when we mint directly to the ledger and need the Transfer()
251 	// events to appear in the token)
252 	function ledgerTransfer(address from, address to, uint val) onlyLedger {
253 		token.controllerTransfer(from, to, val);
254 	}
255 
256 	// functions below this line are onlyToken
257 
258 	function transfer(address _from, address _to, uint _value) onlyToken returns (bool success) {
259 		return ledger.transfer(_from, _to, _value);
260 	}
261 
262 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyToken returns (bool success) {
263 		return ledger.transferFrom(_spender, _from, _to, _value);
264 	}
265 
266 	function approve(address _owner, address _spender, uint _value) onlyToken returns (bool success) {
267 		return ledger.approve(_owner, _spender, _value);
268 	}
269 
270 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyToken returns (bool success) {
271 		return ledger.increaseApproval(_owner, _spender, _addedValue);
272 	}
273 
274 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyToken returns (bool success) {
275 		return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
276 	}
277 
278 	function burn(address _owner, uint _amount) onlyToken {
279 		ledger.burn(_owner, _amount);
280 	}
281 }
282 
283 contract Ledger is Owned, SafeMath, Finalizable, TokenReceivable {
284 	Controller public controller;
285 	mapping(address => uint) public balanceOf;
286 	mapping (address => mapping (address => uint)) public allowance;
287 	uint public totalSupply;
288 	uint public mintingNonce;
289 	bool public mintingStopped;
290 
291 	// functions below this line are onlyOwner
292 
293 	function Ledger() {
294 	}
295 
296 	function setController(address _controller) onlyOwner notFinalized {
297 		controller = Controller(_controller);
298 	}
299 
300 	function stopMinting() onlyOwner {
301 		mintingStopped = true;
302 	}
303 
304 	function multiMint(uint nonce, uint256[] bits) onlyOwner {
305 		require(!mintingStopped);
306 		if (nonce != mintingNonce) return;
307 		mintingNonce += 1;
308 		uint256 lomask = (1 << 96) - 1;
309 		uint created = 0;
310 		for (uint i=0; i<bits.length; i++) {
311 			address a = address(bits[i]>>96);
312 			uint value = bits[i]&lomask;
313 			balanceOf[a] = balanceOf[a] + value;
314 			controller.ledgerTransfer(0, a, value);
315 			created += value;
316 		}
317 		totalSupply += created;
318 	}
319 
320 	// functions below this line are onlyController
321 
322 	modifier onlyController() {
323 		require(msg.sender == address(controller));
324 		_;
325 	}
326 
327 	function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
328 		if (balanceOf[_from] < _value) return false;
329 
330 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
331 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
332 		return true;
333 	}
334 
335 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
336 		if (balanceOf[_from] < _value) return false;
337 
338 		var allowed = allowance[_from][_spender];
339 		if (allowed < _value) return false;
340 
341 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
342 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
343 		allowance[_from][_spender] = safeSub(allowed, _value);
344 		return true;
345 	}
346 
347 	function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
348 		// require user to set to zero before resetting to nonzero
349 		if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
350 			return false;
351 		}
352 
353 		allowance[_owner][_spender] = _value;
354 		return true;
355 	}
356 
357 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyController returns (bool success) {
358 		uint oldValue = allowance[_owner][_spender];
359 		allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
360 		return true;
361 	}
362 
363 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyController returns (bool success) {
364 		uint oldValue = allowance[_owner][_spender];
365 		if (_subtractedValue > oldValue) {
366 			allowance[_owner][_spender] = 0;
367 		} else {
368 			allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
369 		}
370 		return true;
371 	}
372 
373 	function burn(address _owner, uint _amount) onlyController {
374 		balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
375 		totalSupply = safeSub(totalSupply, _amount);
376 	}
377 }