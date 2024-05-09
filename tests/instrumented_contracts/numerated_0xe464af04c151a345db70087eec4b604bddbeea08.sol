1 // Unattributed material copyright New Alchemy Limited, 2017. All rights reserved.
2 pragma solidity >=0.4.10;
3 
4 contract SafeMath {
5     function safeMul(uint a, uint b) internal returns (uint) {
6         uint c = a * b;
7         require(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeSub(uint a, uint b) internal returns (uint) {
12         require(b <= a);
13         return a - b;
14     }
15 
16     function safeAdd(uint a, uint b) internal returns (uint) {
17         uint c = a + b;
18         require(c>=a && c>=b);
19         return c;
20     }
21 }
22 
23 contract Owned {
24 	address public owner;
25 	address newOwner;
26 
27 	function Owned() {
28 		owner = msg.sender;
29 	}
30 
31 	modifier onlyOwner() {
32 		require(msg.sender == owner);
33 		_;
34 	}
35 
36 	function changeOwner(address _newOwner) onlyOwner {
37 		newOwner = _newOwner;
38 	}
39 
40 	function acceptOwnership() {
41 		if (msg.sender == newOwner) {
42 			owner = newOwner;
43 		}
44 	}
45 }
46 
47 contract Pausable is Owned {
48 	bool public paused;
49 
50 	function pause() onlyOwner {
51 		paused = true;
52 	}
53 
54 	function unpause() onlyOwner {
55 		paused = false;
56 	}
57 
58 	modifier notPaused() {
59 		require(!paused);
60 		_;
61 	}
62 }
63 
64 contract Finalizable is Owned {
65 	bool public finalized;
66 
67 	function finalize() onlyOwner {
68 		finalized = true;
69 	}
70 
71 	modifier notFinalized() {
72 		require(!finalized);
73 		_;
74 	}
75 }
76 
77 contract IToken {
78 	function transfer(address _to, uint _value) returns (bool);
79 	function balanceOf(address owner) returns(uint);
80 }
81 
82 contract TokenReceivable is Owned {
83 	function claimTokens(address _token, address _to) onlyOwner returns (bool) {
84 		IToken token = IToken(_token);
85 		return token.transfer(_to, token.balanceOf(this));
86 	}
87 }
88 
89 contract EventDefinitions {
90 	event Transfer(address indexed from, address indexed to, uint value);
91 	event Approval(address indexed owner, address indexed spender, uint value);
92 }
93 
94 contract Token is Finalizable, TokenReceivable, SafeMath, EventDefinitions, Pausable {
95 	string constant public name = "ZeroSum Token";
96 	uint8 constant public decimals = 4;
97 	string constant public symbol = "ZFX";
98 	Controller public controller;
99 	string public motd;
100 	event Motd(string message);
101 
102 	// functions below this line are onlyOwner
103 
104 	function setMotd(string _m) onlyOwner {
105 		motd = _m;
106 		Motd(_m);
107 	}
108 
109 	function setController(address _c) onlyOwner notFinalized {
110 		controller = Controller(_c);
111 	}
112 
113 	// functions below this line are public
114 
115 	function balanceOf(address a) constant returns (uint) {
116 		return controller.balanceOf(a);
117 	}
118 
119 	function totalSupply() constant returns (uint) {
120 		return controller.totalSupply();
121 	}
122 
123 	function allowance(address _owner, address _spender) constant returns (uint) {
124 		return controller.allowance(_owner, _spender);
125 	}
126 
127 	function transfer(address _to, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
128 		if (controller.transfer(msg.sender, _to, _value)) {
129 			Transfer(msg.sender, _to, _value);
130 			return true;
131 		}
132 		return false;
133 	}
134 
135 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3) notPaused returns (bool success) {
136 		if (controller.transferFrom(msg.sender, _from, _to, _value)) {
137 			Transfer(_from, _to, _value);
138 			return true;
139 		}
140 		return false;
141 	}
142 
143 	function approve(address _spender, uint _value) onlyPayloadSize(2) notPaused returns (bool success) {
144 		if (controller.approve(msg.sender, _spender, _value)) {
145 			Approval(msg.sender, _spender, _value);
146 			return true;
147 		}
148 		return false;
149 	}
150 
151 	function increaseApproval (address _spender, uint _addedValue) onlyPayloadSize(2) notPaused returns (bool success) {
152 		if (controller.increaseApproval(msg.sender, _spender, _addedValue)) {
153 			uint newval = controller.allowance(msg.sender, _spender);
154 			Approval(msg.sender, _spender, newval);
155 			return true;
156 		}
157 		return false;
158 	}
159 
160 	function decreaseApproval (address _spender, uint _subtractedValue) onlyPayloadSize(2) notPaused returns (bool success) {
161 		if (controller.decreaseApproval(msg.sender, _spender, _subtractedValue)) {
162 			uint newval = controller.allowance(msg.sender, _spender);
163 			Approval(msg.sender, _spender, newval);
164 			return true;
165 		}
166 		return false;
167 	}
168 
169 	modifier onlyPayloadSize(uint numwords) {
170 		assert(msg.data.length >= numwords * 32 + 4);
171 		_;
172 	}
173 
174 	function burn(uint _amount) notPaused {
175 		controller.burn(msg.sender, _amount);
176 		Transfer(msg.sender, 0x0, _amount);
177 	}
178 
179 	// functions below this line are onlyController
180 
181 	modifier onlyController() {
182 		assert(msg.sender == address(controller));
183 		_;
184 	}
185 
186 	function controllerTransfer(address _from, address _to, uint _value) onlyController {
187 		Transfer(_from, _to, _value);
188 	}
189 
190 	function controllerApprove(address _owner, address _spender, uint _value) onlyController {
191 		Approval(_owner, _spender, _value);
192 	}
193 }
194 
195 contract Controller is Owned, Finalizable {
196 	Ledger public ledger;
197 	Token public token;
198 
199 	function Controller() {
200 	}
201 
202 	// functions below this line are onlyOwner
203 
204 	function setToken(address _token) onlyOwner {
205 		token = Token(_token);
206 	}
207 
208 	function setLedger(address _ledger) onlyOwner {
209 		ledger = Ledger(_ledger);
210 	}
211 
212 	modifier onlyToken() {
213 		require(msg.sender == address(token));
214 		_;
215 	}
216 
217 	modifier onlyLedger() {
218 		require(msg.sender == address(ledger));
219 		_;
220 	}
221 
222 	// public functions
223 
224 	function totalSupply() constant returns (uint) {
225 		return ledger.totalSupply();
226 	}
227 
228 	function balanceOf(address _a) constant returns (uint) {
229 		return ledger.balanceOf(_a);
230 	}
231 
232 	function allowance(address _owner, address _spender) constant returns (uint) {
233 		return ledger.allowance(_owner, _spender);
234 	}
235 
236 	// functions below this line are onlyLedger
237 
238 	function ledgerTransfer(address from, address to, uint val) onlyLedger {
239 		token.controllerTransfer(from, to, val);
240 	}
241 
242 	// functions below this line are onlyToken
243 
244 	function transfer(address _from, address _to, uint _value) onlyToken returns (bool success) {
245 		return ledger.transfer(_from, _to, _value);
246 	}
247 
248 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyToken returns (bool success) {
249 		return ledger.transferFrom(_spender, _from, _to, _value);
250 	}
251 
252 	function approve(address _owner, address _spender, uint _value) onlyToken returns (bool success) {
253 		return ledger.approve(_owner, _spender, _value);
254 	}
255 
256 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyToken returns (bool success) {
257 		return ledger.increaseApproval(_owner, _spender, _addedValue);
258 	}
259 
260 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyToken returns (bool success) {
261 		return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
262 	}
263 
264 	function burn(address _owner, uint _amount) onlyToken {
265 		ledger.burn(_owner, _amount);
266 	}
267 }
268 
269 contract Ledger is Owned, SafeMath, Finalizable {
270 	Controller public controller;
271 	mapping(address => uint) public balanceOf;
272 	mapping (address => mapping (address => uint)) public allowance;
273 	uint public totalSupply;
274 	uint public mintingNonce;
275 	bool public mintingStopped;
276 
277 	// functions below this line are onlyOwner
278 
279 	function Ledger() {
280 	}
281 
282 	function setController(address _controller) onlyOwner notFinalized {
283 		controller = Controller(_controller);
284 	}
285 
286 	function stopMinting() onlyOwner {
287 		mintingStopped = true;
288 	}
289 
290 	function multiMint(uint nonce, uint256[] bits) onlyOwner {
291 		require(!mintingStopped);
292 		if (nonce != mintingNonce) return;
293 		mintingNonce += 1;
294 		uint256 lomask = (1 << 96) - 1;
295 		uint created = 0;
296 		for (uint i=0; i<bits.length; i++) {
297 			address a = address(bits[i]>>96);
298 			uint value = bits[i]&lomask;
299 			balanceOf[a] = balanceOf[a] + value;
300 			controller.ledgerTransfer(0, a, value);
301 			created += value;
302 		}
303 		totalSupply += created;
304 	}
305 
306 	// functions below this line are onlyController
307 
308 	modifier onlyController() {
309 		require(msg.sender == address(controller));
310 		_;
311 	}
312 
313 	function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
314 		if (balanceOf[_from] < _value) return false;
315 
316 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
317 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
318 		return true;
319 	}
320 
321 	function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
322 		if (balanceOf[_from] < _value) return false;
323 
324 		var allowed = allowance[_from][_spender];
325 		if (allowed < _value) return false;
326 
327 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
328 		balanceOf[_from] = safeSub(balanceOf[_from], _value);
329 		allowance[_from][_spender] = safeSub(allowed, _value);
330 		return true;
331 	}
332 
333 	function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
334 		if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
335 			return false;
336 		}
337 
338 		allowance[_owner][_spender] = _value;
339 		return true;
340 	}
341 
342 	function increaseApproval (address _owner, address _spender, uint _addedValue) onlyController returns (bool success) {
343 		uint oldValue = allowance[_owner][_spender];
344 		allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
345 		return true;
346 	}
347 
348 	function decreaseApproval (address _owner, address _spender, uint _subtractedValue) onlyController returns (bool success) {
349 		uint oldValue = allowance[_owner][_spender];
350 		if (_subtractedValue > oldValue) {
351 			allowance[_owner][_spender] = 0;
352 		} else {
353 			allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
354 		}
355 		return true;
356 	}
357 
358 	function burn(address _owner, uint _amount) onlyController {
359 		balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
360 		totalSupply = safeSub(totalSupply, _amount);
361 	}
362 }