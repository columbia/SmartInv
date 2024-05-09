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
98 contract BitLearnToken is Finalizable, TokenReceivable, SafeMath, EventDefinitions, Pausable {
99 	string constant public name = "BTLN Test Token";
100 	uint8 constant public decimals = 8;
101 	string constant public symbol = "BTLN";
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
192 	function controllerTransfer(address _from, address _to, uint _value) onlyController {
193 		Transfer(_from, _to, _value);
194 	}
195 
196 	function controllerApprove(address _owner, address _spender, uint _value) onlyController {
197 		Approval(_owner, _spender, _value);
198 	}
199 }
200 
201 contract Controller is Owned, Finalizable {
202 	Ledger public ledger;
203 	BitLearnToken public token;
204 
205 	function Controller() {
206 	}
207 
208 	// functions below this line are onlyOwner
209 
210 	function setToken(address _token) onlyOwner {
211 		token = BitLearnToken(_token);
212 	}
213 
214 	function setLedger(address _ledger) onlyOwner {
215 		ledger = Ledger(_ledger);
216 	}
217 
218 	modifier onlyToken() {
219 		require(msg.sender == address(token));
220 		_;
221 	}
222 
223 	modifier onlyLedger() {
224 		require(msg.sender == address(ledger));
225 		_;
226 	}
227 
228 	// public functions
229 
230 	function totalSupply() constant returns (uint) {
231 		return ledger.totalSupply();
232 	}
233 
234 	function balanceOf(address _a) constant returns (uint) {
235 		return ledger.balanceOf(_a);
236 	}
237 
238 	function allowance(address _owner, address _spender) constant returns (uint) {
239 		return ledger.allowance(_owner, _spender);
240 	}
241 
242 	// functions below this line are onlyLedger
243 
244 	function ledgerTransfer(address from, address to, uint val) onlyLedger {
245 		token.controllerTransfer(from, to, val);
246 	}
247 
248 	// functions below this line are onlyToken
249 
250 	function transfer(address _from, address _to, uint _value) onlyToken returns (bool success) {
251 		return ledger.transfer(_from, _to, _value);
252 	}
253 
254 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyToken returns (bool success) {
255 		return ledger.transferFrom(_spender, _from, _to, _value);
256 	}
257 
258 	function approve(address _owner, address _spender, uint _value) onlyToken returns (bool success) {
259 		return ledger.approve(_owner, _spender, _value);
260 	}
261 
262 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyToken returns (bool success) {
263 		return ledger.increaseApproval(_owner, _spender, _addedValue);
264 	}
265 
266 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyToken returns (bool success) {
267 		return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
268 	}
269 
270 	function burn(address _owner, uint _amount) onlyToken {
271 		ledger.burn(_owner, _amount);
272 	}
273 }
274 
275 contract Ledger is Owned, SafeMath, Finalizable {
276 	Controller public controller;
277 	mapping(address => uint) public balanceOf;
278 	mapping (address => mapping (address => uint)) public allowance;
279 	uint public totalSupply;
280 	uint public mintingNonce;
281 	bool public mintingStopped;
282 
283 	// functions below this line are onlyOwner
284 
285 	function Ledger() {
286 	}
287 
288 	function setController(address _controller) onlyOwner notFinalized {
289 		controller = Controller(_controller);
290 	}
291 
292 	function stopMinting() onlyOwner {
293 		mintingStopped = true;
294 	}
295 
296 	function multiMint(uint nonce, uint256[] bits) onlyOwner {
297 		require(!mintingStopped);
298 		if (nonce != mintingNonce) return;
299 		mintingNonce += 1;
300 		uint256 lomask = (1 << 96) - 1;
301 		uint created = 0;
302 		for (uint i=0; i<bits.length; i++) {
303 			address a = address(bits[i]>>96);
304 			uint value = bits[i]&lomask;
305 			balanceOf[a] = balanceOf[a] + value;
306 			controller.ledgerTransfer(0, a, value);
307 			created += value;
308 		}
309 		totalSupply += created;
310 	}
311 
312 	// functions below this line are onlyController
313 
314 	modifier onlyController() {
315 		require(msg.sender == address(controller));
316 		_;
317 	}
318 
319 	function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
320 		if (balanceOf[_from] < _value) return false;
321 
322 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
323 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
324 		return true;
325 	}
326 
327 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
328 		if (balanceOf[_from] < _value) return false;
329 
330 		var allowed = allowance[_from][_spender];
331 		if (allowed < _value) return false;
332 
333 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
334 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
335 		allowance[_from][_spender] = safeSub(allowed, _value);
336 		return true;
337 	}
338 
339 	function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
340 		// require user to set to zero before resetting to nonzero
341 		if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
342 			return false;
343 		}
344 
345 		allowance[_owner][_spender] = _value;
346 		return true;
347 	}
348 
349 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyController returns (bool success) {
350 		uint oldValue = allowance[_owner][_spender];
351 		allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
352 		return true;
353 	}
354 
355 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyController returns (bool success) {
356 		uint oldValue = allowance[_owner][_spender];
357 		if (_subtractedValue > oldValue) {
358 			allowance[_owner][_spender] = 0;
359 		} else {
360 			allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
361 		}
362 		return true;
363 	}
364 
365 	function burn(address _owner, uint _amount) onlyController {
366 		balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
367 		totalSupply = safeSub(totalSupply, _amount);
368 	}
369 }