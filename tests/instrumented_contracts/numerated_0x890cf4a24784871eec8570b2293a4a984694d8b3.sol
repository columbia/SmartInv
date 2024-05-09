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
97 	string constant public name = "Peg Test Token";
98 	uint8 constant public decimals = 8;
99 	string constant public symbol = "PTT";
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
146 		if (controller.approve(msg.sender, _spender, _value)) {
147 			Approval(msg.sender, _spender, _value);
148 			return true;
149 		}
150 		return false;
151 	}
152 
153 	function increaseApproval (address _spender, uint _addedValue) onlyPayloadSize(2) notPaused returns (bool success) {
154 		if (controller.increaseApproval(msg.sender, _spender, _addedValue)) {
155 			uint newval = controller.allowance(msg.sender, _spender);
156 			Approval(msg.sender, _spender, newval);
157 			return true;
158 		}
159 		return false;
160 	}
161 
162 	function decreaseApproval (address _spender, uint _subtractedValue) onlyPayloadSize(2) notPaused returns (bool success) {
163 		if (controller.decreaseApproval(msg.sender, _spender, _subtractedValue)) {
164 			uint newval = controller.allowance(msg.sender, _spender);
165 			Approval(msg.sender, _spender, newval);
166 			return true;
167 		}
168 		return false;
169 	}
170 
171 	modifier onlyPayloadSize(uint numwords) {
172 		assert(msg.data.length >= numwords * 32 + 4);
173 		_;
174 	}
175 
176 	function burn(uint _amount) notPaused {
177 		controller.burn(msg.sender, _amount);
178 		Transfer(msg.sender, 0x0, _amount);
179 	}
180 
181 	// functions below this line are onlyController
182 
183 	modifier onlyController() {
184 		assert(msg.sender == address(controller));
185 		_;
186 	}
187 
188 	function controllerTransfer(address _from, address _to, uint _value) onlyController {
189 		Transfer(_from, _to, _value);
190 	}
191 
192 	function controllerApprove(address _owner, address _spender, uint _value) onlyController {
193 		Approval(_owner, _spender, _value);
194 	}
195 }
196 
197 contract Controller is Owned, Finalizable {
198 	Ledger public ledger;
199 	Token public token;
200 
201 	function Controller() {
202 	}
203 
204 	// functions below this line are onlyOwner
205 
206 	function setToken(address _token) onlyOwner {
207 		token = Token(_token);
208 	}
209 
210 	function setLedger(address _ledger) onlyOwner {
211 		ledger = Ledger(_ledger);
212 	}
213 
214 	modifier onlyToken() {
215 		require(msg.sender == address(token));
216 		_;
217 	}
218 
219 	modifier onlyLedger() {
220 		require(msg.sender == address(ledger));
221 		_;
222 	}
223 
224 	// public functions
225 
226 	function totalSupply() constant returns (uint) {
227 		return ledger.totalSupply();
228 	}
229 
230 	function balanceOf(address _a) constant returns (uint) {
231 		return ledger.balanceOf(_a);
232 	}
233 
234 	function allowance(address _owner, address _spender) constant returns (uint) {
235 		return ledger.allowance(_owner, _spender);
236 	}
237 
238 	// functions below this line are onlyLedger
239 
240 	function ledgerTransfer(address from, address to, uint val) onlyLedger {
241 		token.controllerTransfer(from, to, val);
242 	}
243 
244 	// functions below this line are onlyToken
245 
246 	function transfer(address _from, address _to, uint _value) onlyToken returns (bool success) {
247 		return ledger.transfer(_from, _to, _value);
248 	}
249 
250 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyToken returns (bool success) {
251 		return ledger.transferFrom(_spender, _from, _to, _value);
252 	}
253 
254 	function approve(address _owner, address _spender, uint _value) onlyToken returns (bool success) {
255 		return ledger.approve(_owner, _spender, _value);
256 	}
257 
258 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyToken returns (bool success) {
259 		return ledger.increaseApproval(_owner, _spender, _addedValue);
260 	}
261 
262 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyToken returns (bool success) {
263 		return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
264 	}
265 
266 	function burn(address _owner, uint _amount) onlyToken {
267 		ledger.burn(_owner, _amount);
268 	}
269 }
270 
271 contract Ledger is Owned, SafeMath, Finalizable, TokenReceivable {
272 	Controller public controller;
273 	mapping(address => uint) public balanceOf;
274 	mapping (address => mapping (address => uint)) public allowance;
275 	uint public totalSupply;
276 	uint public mintingNonce;
277 	bool public mintingStopped;
278 
279 	// functions below this line are onlyOwner
280 
281 	function Ledger() {
282 	}
283 
284 	function setController(address _controller) onlyOwner notFinalized {
285 		controller = Controller(_controller);
286 	}
287 
288 	function stopMinting() onlyOwner {
289 		mintingStopped = true;
290 	}
291 
292 	function multiMint(uint nonce, uint256[] bits) external onlyOwner {
293 		require(!mintingStopped);
294 		if (nonce != mintingNonce) return;
295 		mintingNonce += 1;
296 		uint256 lomask = (1 << 96) - 1;
297 		uint created = 0;
298 		for (uint i=0; i<bits.length; i++) {
299 			address a = address(bits[i]>>96);
300 			uint value = bits[i]&lomask;
301 			balanceOf[a] = balanceOf[a] + value;
302 			controller.ledgerTransfer(0, a, value);
303 			created += value;
304 		}
305 		totalSupply += created;
306 	}
307 
308 	// functions below this line are onlyController
309 
310 	modifier onlyController() {
311 		require(msg.sender == address(controller));
312 		_;
313 	}
314 
315 	function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
316 		if (balanceOf[_from] < _value) return false;
317 
318 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
319 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
320 		return true;
321 	}
322 
323 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
324 		if (balanceOf[_from] < _value) return false;
325 
326 		var allowed = allowance[_from][_spender];
327 		if (allowed < _value) return false;
328 
329 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
330 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
331 		allowance[_from][_spender] = safeSub(allowed, _value);
332 		return true;
333 	}
334 
335 	function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
336 		if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
337 			return false;
338 		}
339 
340 		allowance[_owner][_spender] = _value;
341 		return true;
342 	}
343 
344 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyController returns (bool success) {
345 		uint oldValue = allowance[_owner][_spender];
346 		allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
347 		return true;
348 	}
349 
350 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyController returns (bool success) {
351 		uint oldValue = allowance[_owner][_spender];
352 		if (_subtractedValue > oldValue) {
353 			allowance[_owner][_spender] = 0;
354 		} else {
355 			allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
356 		}
357 		return true;
358 	}
359 
360 	function burn(address _owner, uint _amount) onlyController {
361 		balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
362 		totalSupply = safeSub(totalSupply, _amount);
363 	}
364 }