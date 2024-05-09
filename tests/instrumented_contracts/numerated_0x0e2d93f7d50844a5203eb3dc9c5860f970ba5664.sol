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
84 contract TokenReceivable is Owned {
85 	function claimTokens(address _token, address _to) onlyOwner returns (bool) {
86 		IToken token = IToken(_token);
87 		return token.transfer(_to, token.balanceOf(this));
88 	}
89 }
90 
91 contract EventDefinitions {
92 	event Transfer(address indexed from, address indexed to, uint value);
93 	event Approval(address indexed owner, address indexed spender, uint value);
94 }
95 
96 contract Token is Finalizable, TokenReceivable, SafeMath, EventDefinitions, Pausable {
97 	// Set these appropriately before you deploy
98 	string constant public name = "eByte Token";
99 	uint8 constant public decimals = 8;
100 	string constant public symbol = "EBYTE";
101 	Controller public controller;
102 	string public motd;
103 	event Motd(string message);
104 
105 	// functions below this line are onlyOwner
106 
107 	// set "message of the day"
108 	function setMotd(string _m) onlyOwner {
109 		motd = _m;
110 		Motd(_m);
111 	}
112 
113 	function setController(address _c) onlyOwner notFinalized {
114 		controller = Controller(_c);
115 	}
116 
117 	// functions below this line are public
118 
119 	function balanceOf(address a) constant returns (uint) {
120 		return controller.balanceOf(a);
121 	}
122 
123 	function totalSupply() constant returns (uint) {
124 		return controller.totalSupply();
125 	}
126 
127 	function allowance(address _owner, address _spender) constant returns (uint) {
128 		return controller.allowance(_owner, _spender);
129 	}
130 
131 	function transfer(address _to, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
132 		if (controller.transfer(msg.sender, _to, _value)) {
133 			Transfer(msg.sender, _to, _value);
134 			return true;
135 		}
136 		return false;
137 	}
138 
139 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3) notPaused returns (bool success) {
140 		if (controller.transferFrom(msg.sender, _from, _to, _value)) {
141 			Transfer(_from, _to, _value);
142 			return true;
143 		}
144 		return false;
145 	}
146 
147 	function approve(address _spender, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
148 		// promote safe user behavior
149 		if (controller.approve(msg.sender, _spender, _value)) {
150 			Approval(msg.sender, _spender, _value);
151 			return true;
152 		}
153 		return false;
154 	}
155 
156 	function increaseApproval (address _spender, uint _addedValue) onlyPayloadSize(2) notPaused returns (bool success) {
157 		if (controller.increaseApproval(msg.sender, _spender, _addedValue)) {
158 			uint newval = controller.allowance(msg.sender, _spender);
159 			Approval(msg.sender, _spender, newval);
160 			return true;
161 		}
162 		return false;
163 	}
164 
165 	function decreaseApproval (address _spender, uint _subtractedValue) onlyPayloadSize(2) notPaused returns (bool success) {
166 		if (controller.decreaseApproval(msg.sender, _spender, _subtractedValue)) {
167 			uint newval = controller.allowance(msg.sender, _spender);
168 			Approval(msg.sender, _spender, newval);
169 			return true;
170 		}
171 		return false;
172 	}
173 
174 	modifier onlyPayloadSize(uint numwords) {
175 		assert(msg.data.length >= numwords * 32 + 4);
176 		_;
177 	}
178 
179 	function burn(uint _amount) notPaused {
180 		controller.burn(msg.sender, _amount);
181 		Transfer(msg.sender, 0x0, _amount);
182 	}
183 
184 	// functions below this line are onlyController
185 
186 	modifier onlyController() {
187 		assert(msg.sender == address(controller));
188 		_;
189 	}
190 
191 	function controllerTransfer(address _from, address _to, uint _value) onlyController {
192 		Transfer(_from, _to, _value);
193 	}
194 
195 	function controllerApprove(address _owner, address _spender, uint _value) onlyController {
196 		Approval(_owner, _spender, _value);
197 	}
198 }
199 
200 contract Controller is Owned, Finalizable {
201 	Ledger public ledger;
202 	Token public token;
203 
204 	function Controller() {
205 	}
206 
207 	// functions below this line are onlyOwner
208 
209 	function setToken(address _token) onlyOwner {
210 		token = Token(_token);
211 	}
212 
213 	function setLedger(address _ledger) onlyOwner {
214 		ledger = Ledger(_ledger);
215 	}
216 
217 	modifier onlyToken() {
218 		require(msg.sender == address(token));
219 		_;
220 	}
221 
222 	modifier onlyLedger() {
223 		require(msg.sender == address(ledger));
224 		_;
225 	}
226 
227 	// public functions
228 
229 	function totalSupply() constant returns (uint) {
230 		return ledger.totalSupply();
231 	}
232 
233 	function balanceOf(address _a) constant returns (uint) {
234 		return ledger.balanceOf(_a);
235 	}
236 
237 	function allowance(address _owner, address _spender) constant returns (uint) {
238 		return ledger.allowance(_owner, _spender);
239 	}
240 
241 	// functions below this line are onlyLedger
242 
243 	function ledgerTransfer(address from, address to, uint val) onlyLedger {
244 		token.controllerTransfer(from, to, val);
245 	}
246 
247 	// functions below this line are onlyToken
248 
249 	function transfer(address _from, address _to, uint _value) onlyToken returns (bool success) {
250 		return ledger.transfer(_from, _to, _value);
251 	}
252 
253 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyToken returns (bool success) {
254 		return ledger.transferFrom(_spender, _from, _to, _value);
255 	}
256 
257 	function approve(address _owner, address _spender, uint _value) onlyToken returns (bool success) {
258 		return ledger.approve(_owner, _spender, _value);
259 	}
260 
261 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyToken returns (bool success) {
262 		return ledger.increaseApproval(_owner, _spender, _addedValue);
263 	}
264 
265 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyToken returns (bool success) {
266 		return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
267 	}
268 
269 	function burn(address _owner, uint _amount) onlyToken {
270 		ledger.burn(_owner, _amount);
271 	}
272 }
273 
274 contract Ledger is Owned, SafeMath, Finalizable, TokenReceivable {
275 	Controller public controller;
276 	mapping(address => uint) public balanceOf;
277 	mapping (address => mapping (address => uint)) public allowance;
278 	uint public totalSupply;
279 	uint public mintingNonce;
280 	bool public mintingStopped;
281 
282 	// functions below this line are onlyOwner
283 
284 	function Ledger() {
285 	}
286 
287 	function setController(address _controller) onlyOwner notFinalized {
288 		controller = Controller(_controller);
289 	}
290 
291 	function stopMinting() onlyOwner {
292 		mintingStopped = true;
293 	}
294 
295 	function multiMint(uint nonce, uint256[] bits) external onlyOwner {
296 		require(!mintingStopped);
297 		if (nonce != mintingNonce) return;
298 		mintingNonce += 1;
299 		uint256 lomask = (1 << 96) - 1;
300 		uint created = 0;
301 		for (uint i=0; i<bits.length; i++) {
302 			address a = address(bits[i]>>96);
303 			uint value = bits[i]&lomask;
304 			balanceOf[a] = balanceOf[a] + value;
305 			controller.ledgerTransfer(0, a, value);
306 			created += value;
307 		}
308 		totalSupply += created;
309 	}
310 
311 	// functions below this line are onlyController
312 
313 	modifier onlyController() {
314 		require(msg.sender == address(controller));
315 		_;
316 	}
317 
318 	function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
319 		if (balanceOf[_from] < _value) return false;
320 
321 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
322 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
323 		return true;
324 	}
325 
326 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
327 		if (balanceOf[_from] < _value) return false;
328 
329 		var allowed = allowance[_from][_spender];
330 		if (allowed < _value) return false;
331 
332 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
333 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
334 		allowance[_from][_spender] = safeSub(allowed, _value);
335 		return true;
336 	}
337 
338 	function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
339 		// require user to set to zero before resetting to nonzero
340 		if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
341 			return false;
342 		}
343 
344 		allowance[_owner][_spender] = _value;
345 		return true;
346 	}
347 
348 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyController returns (bool success) {
349 		uint oldValue = allowance[_owner][_spender];
350 		allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
351 		return true;
352 	}
353 
354 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyController returns (bool success) {
355 		uint oldValue = allowance[_owner][_spender];
356 		if (_subtractedValue > oldValue) {
357 			allowance[_owner][_spender] = 0;
358 		} else {
359 			allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
360 		}
361 		return true;
362 	}
363 
364 	function burn(address _owner, uint _amount) onlyController {
365 		balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
366 		totalSupply = safeSub(totalSupply, _amount);
367 	}
368 }