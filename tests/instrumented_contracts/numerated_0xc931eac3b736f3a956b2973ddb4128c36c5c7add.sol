1 // Copyright New Alchemy Limited, 2017. All rights reserved.
2 
3 pragma solidity >=0.4.10;
4 
5 // from Zeppelin
6 contract SafeMath {
7     function safeMul(uint a, uint b) internal returns (uint) {
8         uint c = a * b;
9         require(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function safeSub(uint a, uint b) internal returns (uint) {
14         require(b <= a);
15         return a - b;
16     }
17 
18     function safeAdd(uint a, uint b) internal returns (uint) {
19         uint c = a + b;
20         require(c>=a && c>=b);
21         return c;
22     }
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
95 	event Approval(address indexed owner, address indexed spender, uint value);
96 }
97 
98 contract Token is Finalizable, TokenReceivable, SafeMath, EventDefinitions, Pausable {
99 	string constant public name = "Token Report";
100 	uint8 constant public decimals = 8;
101 	string constant public symbol = "DATA";
102 	Controller public controller;
103 	string public motd;
104 	event Motd(string message);
105 
106 	// functions below this line are onlyOwner
107 
108 	// set "message of the day"
109 	function setMotd(string _m) onlyOwner {
110 		motd = _m;
111 		Motd(_m);
112 	}
113 
114 	function setController(address _c) onlyOwner notFinalized {
115 		controller = Controller(_c);
116 	}
117 
118 	// functions below this line are public
119 
120 	function balanceOf(address a) constant returns (uint) {
121 		return controller.balanceOf(a);
122 	}
123 
124 	function totalSupply() constant returns (uint) {
125 		return controller.totalSupply();
126 	}
127 
128 	function allowance(address _owner, address _spender) constant returns (uint) {
129 		return controller.allowance(_owner, _spender);
130 	}
131 
132 	function transfer(address _to, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
133 		if (controller.transfer(msg.sender, _to, _value)) {
134 			Transfer(msg.sender, _to, _value);
135 			return true;
136 		}
137 		return false;
138 	}
139 
140 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3) notPaused returns (bool success) {
141 		if (controller.transferFrom(msg.sender, _from, _to, _value)) {
142 			Transfer(_from, _to, _value);
143 			return true;
144 		}
145 		return false;
146 	}
147 
148 	function approve(address _spender, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
149 		// promote safe user behavior
150 		if (controller.approve(msg.sender, _spender, _value)) {
151 			Approval(msg.sender, _spender, _value);
152 			return true;
153 		}
154 		return false;
155 	}
156 
157 	function increaseApproval (address _spender, uint _addedValue) onlyPayloadSize(2) notPaused returns (bool success) {
158 		if (controller.increaseApproval(msg.sender, _spender, _addedValue)) {
159 			uint newval = controller.allowance(msg.sender, _spender);
160 			Approval(msg.sender, _spender, newval);
161 			return true;
162 		}
163 		return false;
164 	}
165 
166 	function decreaseApproval (address _spender, uint _subtractedValue) onlyPayloadSize(2) notPaused returns (bool success) {
167 		if (controller.decreaseApproval(msg.sender, _spender, _subtractedValue)) {
168 			uint newval = controller.allowance(msg.sender, _spender);
169 			Approval(msg.sender, _spender, newval);
170 			return true;
171 		}
172 		return false;
173 	}
174 
175 	modifier onlyPayloadSize(uint numwords) {
176 		assert(msg.data.length >= numwords * 32 + 4);
177 		_;
178 	}
179 
180 	function burn(uint _amount) notPaused {
181 		controller.burn(msg.sender, _amount);
182 		Transfer(msg.sender, 0x0, _amount);
183 	}
184 
185 	// functions below this line are onlyController
186 
187 	modifier onlyController() {
188 		assert(msg.sender == address(controller));
189 		_;
190 	}
191 
192 	// In the future, when the controller supports multiple token
193 	// heads, allow the controller to reconstitute the transfer and
194 	// approval history.
195 
196 	function controllerTransfer(address _from, address _to, uint _value) onlyController {
197 		Transfer(_from, _to, _value);
198 	}
199 
200 	function controllerApprove(address _owner, address _spender, uint _value) onlyController {
201 		Approval(_owner, _spender, _value);
202 	}
203 }
204 
205 contract Controller is Owned, Finalizable {
206 	Ledger public ledger;
207 	Token public token;
208 
209 	function Controller() {
210 	}
211 
212 	// functions below this line are onlyOwner
213 
214 	function setToken(address _token) onlyOwner {
215 		token = Token(_token);
216 	}
217 
218 	function setLedger(address _ledger) onlyOwner {
219 		ledger = Ledger(_ledger);
220 	}
221 
222 	modifier onlyToken() {
223 		require(msg.sender == address(token));
224 		_;
225 	}
226 
227 	modifier onlyLedger() {
228 		require(msg.sender == address(ledger));
229 		_;
230 	}
231 
232 	// public functions
233 
234 	function totalSupply() constant returns (uint) {
235 		return ledger.totalSupply();
236 	}
237 
238 	function balanceOf(address _a) constant returns (uint) {
239 		return ledger.balanceOf(_a);
240 	}
241 
242 	function allowance(address _owner, address _spender) constant returns (uint) {
243 		return ledger.allowance(_owner, _spender);
244 	}
245 
246 	// functions below this line are onlyLedger
247 
248 	// let the ledger send transfer events (the most obvious case
249 	// is when we mint directly to the ledger and need the Transfer()
250 	// events to appear in the token)
251 	function ledgerTransfer(address from, address to, uint val) onlyLedger {
252 		token.controllerTransfer(from, to, val);
253 	}
254 
255 	// functions below this line are onlyToken
256 
257 	function transfer(address _from, address _to, uint _value) onlyToken returns (bool success) {
258 		return ledger.transfer(_from, _to, _value);
259 	}
260 
261 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyToken returns (bool success) {
262 		return ledger.transferFrom(_spender, _from, _to, _value);
263 	}
264 
265 	function approve(address _owner, address _spender, uint _value) onlyToken returns (bool success) {
266 		return ledger.approve(_owner, _spender, _value);
267 	}
268 
269 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyToken returns (bool success) {
270 		return ledger.increaseApproval(_owner, _spender, _addedValue);
271 	}
272 
273 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyToken returns (bool success) {
274 		return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
275 	}
276 
277 	function burn(address _owner, uint _amount) onlyToken {
278 		ledger.burn(_owner, _amount);
279 	}
280 }
281 
282 contract Ledger is Owned, SafeMath, Finalizable {
283 	Controller public controller;
284 	mapping(address => uint) public balanceOf;
285 	mapping (address => mapping (address => uint)) public allowance;
286 	uint public totalSupply;
287 	uint public mintingNonce;
288 	bool public mintingStopped;
289 
290 	// functions below this line are onlyOwner
291 
292 	function Ledger() {
293 	}
294 
295 	function setController(address _controller) onlyOwner notFinalized {
296 		controller = Controller(_controller);
297 	}
298 
299 	function stopMinting() onlyOwner {
300 		mintingStopped = true;
301 	}
302 
303 	function multiMint(uint nonce, uint256[] bits) onlyOwner {
304 		require(!mintingStopped);
305 		if (nonce != mintingNonce) return;
306 		mintingNonce += 1;
307 		uint256 lomask = (1 << 96) - 1;
308 		uint created = 0;
309 		for (uint i=0; i<bits.length; i++) {
310 			address a = address(bits[i]>>96);
311 			uint value = bits[i]&lomask;
312 			balanceOf[a] = balanceOf[a] + value;
313 			controller.ledgerTransfer(0, a, value);
314 			created += value;
315 		}
316 		totalSupply += created;
317 	}
318 
319 	// functions below this line are onlyController
320 
321 	modifier onlyController() {
322 		require(msg.sender == address(controller));
323 		_;
324 	}
325 
326 	function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
327 		if (balanceOf[_from] < _value) return false;
328 
329 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
330 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
331 		return true;
332 	}
333 
334 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
335 		if (balanceOf[_from] < _value) return false;
336 
337 		var allowed = allowance[_from][_spender];
338 		if (allowed < _value) return false;
339 
340 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
341 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
342 		allowance[_from][_spender] = safeSub(allowed, _value);
343 		return true;
344 	}
345 
346 	function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
347 		// require user to set to zero before resetting to nonzero
348 		if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
349 			return false;
350 		}
351 
352 		allowance[_owner][_spender] = _value;
353 		return true;
354 	}
355 
356 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyController returns (bool success) {
357 		uint oldValue = allowance[_owner][_spender];
358 		allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
359 		return true;
360 	}
361 
362 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyController returns (bool success) {
363 		uint oldValue = allowance[_owner][_spender];
364 		if (_subtractedValue > oldValue) {
365 			allowance[_owner][_spender] = 0;
366 		} else {
367 			allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
368 		}
369 		return true;
370 	}
371 
372 	function burn(address _owner, uint _amount) onlyController {
373 		balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
374 		totalSupply = safeSub(totalSupply, _amount);
375 	}
376 }