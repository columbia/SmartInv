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
97 	string constant public name = "Rights Token";
98 	uint8 constant public decimals = 8;
99 	string constant public symbol = "RTK";
100 	Controller public controller;
101 	string public motd;
102 	event Motd(string message);
103 
104 	// functions below this line are onlyOwner
105 
106 	function setMotd(string _m) onlyOwner {
107 		motd = _m;
108 		Motd(_m);
109 	}
110 
111 	function setController(address _c) onlyOwner notFinalized {
112 		controller = Controller(_c);
113 	}
114 
115 	// functions below this line are public
116 
117 	function balanceOf(address a) constant returns (uint) {
118 		return controller.balanceOf(a);
119 	}
120 
121 	function totalSupply() constant returns (uint) {
122 		return controller.totalSupply();
123 	}
124 
125 	function allowance(address _owner, address _spender) constant returns (uint) {
126 		return controller.allowance(_owner, _spender);
127 	}
128 
129 	function transfer(address _to, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
130 		if (controller.transfer(msg.sender, _to, _value)) {
131 			Transfer(msg.sender, _to, _value);
132 			return true;
133 		}
134 		return false;
135 	}
136 
137 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3) notPaused returns (bool success) {
138 		if (controller.transferFrom(msg.sender, _from, _to, _value)) {
139 			Transfer(_from, _to, _value);
140 			return true;
141 		}
142 		return false;
143 	}
144 
145 	function approve(address _spender, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
146 		// promote safe user behavior
147 		if (controller.approve(msg.sender, _spender, _value)) {
148 			Approval(msg.sender, _spender, _value);
149 			return true;
150 		}
151 		return false;
152 	}
153 
154 	function increaseApproval (address _spender, uint _addedValue) onlyPayloadSize(2) notPaused returns (bool success) {
155 		if (controller.increaseApproval(msg.sender, _spender, _addedValue)) {
156 			uint newval = controller.allowance(msg.sender, _spender);
157 			Approval(msg.sender, _spender, newval);
158 			return true;
159 		}
160 		return false;
161 	}
162 
163 	function decreaseApproval (address _spender, uint _subtractedValue) onlyPayloadSize(2) notPaused returns (bool success) {
164 		if (controller.decreaseApproval(msg.sender, _spender, _subtractedValue)) {
165 			uint newval = controller.allowance(msg.sender, _spender);
166 			Approval(msg.sender, _spender, newval);
167 			return true;
168 		}
169 		return false;
170 	}
171 
172 	modifier onlyPayloadSize(uint numwords) {
173 		assert(msg.data.length >= numwords * 32 + 4);
174 		_;
175 	}
176 
177 	function burn(uint _amount) notPaused {
178 		controller.burn(msg.sender, _amount);
179 		Transfer(msg.sender, 0x0, _amount);
180 	}
181 
182 	// functions below this line are onlyController
183 
184 	modifier onlyController() {
185 		assert(msg.sender == address(controller));
186 		_;
187 	}
188 
189 	function controllerTransfer(address _from, address _to, uint _value) onlyController {
190 		Transfer(_from, _to, _value);
191 	}
192 
193 	function controllerApprove(address _owner, address _spender, uint _value) onlyController {
194 		Approval(_owner, _spender, _value);
195 	}
196 }
197 
198 contract Controller is Owned, Finalizable {
199 	Ledger public ledger;
200 	Token public token;
201 
202 	function Controller() {
203 	}
204 
205 	// functions below this line are onlyOwner
206 
207 	function setToken(address _token) onlyOwner {
208 		token = Token(_token);
209 	}
210 
211 	function setLedger(address _ledger) onlyOwner {
212 		ledger = Ledger(_ledger);
213 	}
214 
215 	modifier onlyToken() {
216 		require(msg.sender == address(token));
217 		_;
218 	}
219 
220 	modifier onlyLedger() {
221 		require(msg.sender == address(ledger));
222 		_;
223 	}
224 
225 	// public functions
226 
227 	function totalSupply() constant returns (uint) {
228 		return ledger.totalSupply();
229 	}
230 
231 	function balanceOf(address _a) constant returns (uint) {
232 		return ledger.balanceOf(_a);
233 	}
234 
235 	function allowance(address _owner, address _spender) constant returns (uint) {
236 		return ledger.allowance(_owner, _spender);
237 	}
238 
239 	// functions below this line are onlyLedger
240 
241 	function ledgerTransfer(address from, address to, uint val) onlyLedger {
242 		token.controllerTransfer(from, to, val);
243 	}
244 
245 	// functions below this line are onlyToken
246 
247 	function transfer(address _from, address _to, uint _value) onlyToken returns (bool success) {
248 		return ledger.transfer(_from, _to, _value);
249 	}
250 
251 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyToken returns (bool success) {
252 		return ledger.transferFrom(_spender, _from, _to, _value);
253 	}
254 
255 	function approve(address _owner, address _spender, uint _value) onlyToken returns (bool success) {
256 		return ledger.approve(_owner, _spender, _value);
257 	}
258 
259 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyToken returns (bool success) {
260 		return ledger.increaseApproval(_owner, _spender, _addedValue);
261 	}
262 
263 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyToken returns (bool success) {
264 		return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
265 	}
266 
267 	function burn(address _owner, uint _amount) onlyToken {
268 		ledger.burn(_owner, _amount);
269 	}
270 }
271 
272 contract Ledger is Owned, SafeMath, Finalizable, TokenReceivable {
273 	Controller public controller;
274 	mapping(address => uint) public balanceOf;
275 	mapping (address => mapping (address => uint)) public allowance;
276 	uint public totalSupply;
277 	uint public mintingNonce;
278 	bool public mintingStopped;
279 
280 	// functions below this line are onlyOwner
281 
282 	function Ledger() {
283 	}
284 
285 	function setController(address _controller) onlyOwner notFinalized {
286 		controller = Controller(_controller);
287 	}
288 
289 	function stopMinting() onlyOwner {
290 		mintingStopped = true;
291 	}
292 
293 	function multiMint(uint nonce, uint256[] bits) external onlyOwner {
294 		require(!mintingStopped);
295 		if (nonce != mintingNonce) return;
296 		mintingNonce += 1;
297 		uint256 lomask = (1 << 96) - 1;
298 		uint created = 0;
299 		for (uint i=0; i<bits.length; i++) {
300 			address a = address(bits[i]>>96);
301 			uint value = bits[i]&lomask;
302 			balanceOf[a] = balanceOf[a] + value;
303 			controller.ledgerTransfer(0, a, value);
304 			created += value;
305 		}
306 		totalSupply += created;
307 	}
308 
309 	// functions below this line are onlyController
310 
311 	modifier onlyController() {
312 		require(msg.sender == address(controller));
313 		_;
314 	}
315 
316 	function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
317 		if (balanceOf[_from] < _value) return false;
318 
319 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
320 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
321 		return true;
322 	}
323 
324 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
325 		if (balanceOf[_from] < _value) return false;
326 
327 		var allowed = allowance[_from][_spender];
328 		if (allowed < _value) return false;
329 
330 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
331 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
332 		allowance[_from][_spender] = safeSub(allowed, _value);
333 		return true;
334 	}
335 
336 	function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
337 		// require user to set to zero before resetting to nonzero
338 		if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
339 			return false;
340 		}
341 
342 		allowance[_owner][_spender] = _value;
343 		return true;
344 	}
345 
346 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyController returns (bool success) {
347 		uint oldValue = allowance[_owner][_spender];
348 		allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
349 		return true;
350 	}
351 
352 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyController returns (bool success) {
353 		uint oldValue = allowance[_owner][_spender];
354 		if (_subtractedValue > oldValue) {
355 			allowance[_owner][_spender] = 0;
356 		} else {
357 			allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
358 		}
359 		return true;
360 	}
361 
362 	function burn(address _owner, uint _amount) onlyController {
363 		balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
364 		totalSupply = safeSub(totalSupply, _amount);
365 	}
366 }