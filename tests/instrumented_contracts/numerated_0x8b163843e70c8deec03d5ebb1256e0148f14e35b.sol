1 // CHAINPAY -- BRINGING CRYPTO TO A [N]eighbor[H]ood NEAR YOU 
2 
3 
4 pragma solidity ^0.4.18;
5 
6 
7 contract ERC223Receiver {
8 
9 	function tokenFallback(address _from, uint _value, bytes _data) public;
10 }
11 
12 
13 library SafeMath {
14 
15   
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a / b;
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54  
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   function transferOwnership(address newOwner) public onlyOwner {
61     require(newOwner != address(0));
62     OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 
66 }
67 
68 
69 contract Claimable is Ownable {
70   address public pendingOwner;
71 
72   modifier onlyPendingOwner() {
73     require(msg.sender == pendingOwner);
74     _;
75   }
76 
77  
78   function transferOwnership(address newOwner) onlyOwner public {
79     pendingOwner = newOwner;
80   }
81 
82   function claimOwnership() onlyPendingOwner public {
83     OwnershipTransferred(owner, pendingOwner);
84     owner = pendingOwner;
85     pendingOwner = address(0);
86   }
87 }
88 
89 
90 contract ERC20Basic {
91   function totalSupply() public view returns (uint256);
92   function balanceOf(address who) public view returns (uint256);
93   function transfer(address to, uint256 value) public returns (bool);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   uint256 totalSupply_;
104 
105   
106   function totalSupply() public view returns (uint256) {
107     return totalSupply_;
108   }
109 
110  
111   function transfer(address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[msg.sender]);
114 
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   
122   function balanceOf(address _owner) public view returns (uint256 balance) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 
129 contract ERC20 is ERC20Basic {
130   function allowance(address owner, address spender) public view returns (uint256);
131   function transferFrom(address from, address to, uint256 value) public returns (bool);
132   function approve(address spender, uint256 value) public returns (bool);
133   event Approval(address indexed owner, address indexed spender, uint256 value);
134 }
135 
136 
137 contract StandardToken is ERC20, BasicToken {
138 
139   mapping (address => mapping (address => uint256)) internal allowed;
140 
141 
142   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[_from]);
145     require(_value <= allowed[_from][msg.sender]);
146 
147     balances[_from] = balances[_from].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150     Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   function allowance(address _owner, address _spender) public view returns (uint256) {
162     return allowed[_owner][_spender];
163   }
164 
165   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
166     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   
172   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
173     uint oldValue = allowed[msg.sender][_spender];
174     if (_subtractedValue > oldValue) {
175       allowed[msg.sender][_spender] = 0;
176     } else {
177       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178     }
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183 }
184 
185 
186 contract ERC223Token is StandardToken, Claimable {
187 	using SafeMath for uint256;
188 
189 	bool public erc223Activated;
190 
191 	mapping (address => bool) public whiteListContracts;
192 
193 	
194 	mapping (address => mapping (address => bool) ) public userWhiteListContracts;
195 
196 	function setERC223Activated(bool _activate) public onlyOwner {
197 		erc223Activated = _activate;
198 	}
199 	function setWhiteListContract(address _addr, bool f) public onlyOwner {
200 		whiteListContracts[_addr] = f;
201 	}
202 	function setUserWhiteListContract(address _addr, bool f) public {
203 		userWhiteListContracts[msg.sender][_addr] = f;
204 	}
205 
206 	function checkAndInvokeReceiver(address _to, uint256 _value, bytes _data) internal {
207 		uint codeLength;
208 
209 		assembly {
210 			
211 			codeLength := extcodesize(_to)
212 		}
213 
214 		if (codeLength>0) {
215 			ERC223Receiver receiver = ERC223Receiver(_to);
216 			receiver.tokenFallback(msg.sender, _value, _data);
217 		}
218 	}
219 
220 	function transfer(address _to, uint256 _value) public returns (bool) {
221 		bool ok = super.transfer(_to, _value);
222 		if (erc223Activated
223 			&& whiteListContracts[_to] ==false
224 			&& userWhiteListContracts[msg.sender][_to] ==false) {
225 			bytes memory empty;
226 			checkAndInvokeReceiver(_to, _value, empty);
227 		}
228 		return ok;
229 	}
230 
231 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
232 		bool ok = super.transfer(_to, _value);
233 		if (erc223Activated
234 			&& whiteListContracts[_to] ==false
235 			&& userWhiteListContracts[msg.sender][_to] ==false) {
236 			checkAndInvokeReceiver(_to, _value, _data);
237 		}
238 		return ok;
239 	}
240 
241 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
242 		bool ok = super.transferFrom(_from, _to, _value);
243 		if (erc223Activated
244 			&& whiteListContracts[_to] ==false
245 			&& userWhiteListContracts[_from][_to] ==false
246 			&& userWhiteListContracts[msg.sender][_to] ==false) {
247 			bytes memory empty;
248 			checkAndInvokeReceiver(_to, _value, empty);
249 		}
250 		return ok;
251 	}
252 
253 	function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
254 		bool ok = super.transferFrom(_from, _to, _value);
255 		if (erc223Activated
256 			&& whiteListContracts[_to] ==false
257 			&& userWhiteListContracts[_from][_to] ==false
258 			&& userWhiteListContracts[msg.sender][_to] ==false) {
259 			checkAndInvokeReceiver(_to, _value, _data);
260 		}
261 		return ok;
262 	}
263 
264 }
265 
266 contract BurnableToken is ERC223Token {
267 	using SafeMath for uint256;
268 
269 
270 	event Burn(address indexed burner, uint256 value);
271 
272 
273 	function burnTokenBurn(uint256 _value) public onlyOwner {
274 		require(_value <= balances[msg.sender]);
275 
276 		address burner = msg.sender;
277 		balances[burner] = balances[burner].sub(_value);
278 		totalSupply_ = totalSupply_.sub(_value);
279 		Burn(burner, _value);
280 	}
281 }
282 
283 contract HoldersToken is BurnableToken {
284 	using SafeMath for uint256;
285 
286 
287 	mapping (address => bool) public isHolder;
288 	address [] public holders;
289 
290 	function addHolder(address _addr) internal returns (bool) {
291 		if (isHolder[_addr] != true) {
292 			holders[holders.length++] = _addr;
293 			isHolder[_addr] = true;
294 			return true;
295 		}
296 		return false;
297 	}
298 
299 	function transfer(address _to, uint256 _value) public returns (bool) {
300 		require(_to != address(this)); // Prevent sending coin to contract... ya dig?
301 		bool ok = super.transfer(_to, _value);
302 		addHolder(_to);
303 		return ok;
304 	}
305 
306 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
307 		require(_to != address(this)); 
308 		bool ok = super.transfer(_to, _value, _data);
309 		addHolder(_to);
310 		return ok;
311 	}
312 
313 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
314 		require(_to != address(this)); 
315 		bool ok = super.transferFrom(_from, _to, _value);
316 		addHolder(_to);
317 		return ok;
318 	}
319 
320 	function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
321 		require(_to != address(this)); // Prevent transfer to contract itself
322 		bool ok = super.transferFrom(_from, _to, _value, _data);
323 		addHolder(_to);
324 		return ok;
325 	}
326 
327 }
328 
329 
330 contract MigrationAgent {
331 	function migrateFrom(address from, uint256 value) public returns (bool);
332 }
333 
334 contract MigratoryToken is HoldersToken {
335 	using SafeMath for uint256;
336 
337 	address public migrationAgent;
338 
339 	uint256 public migrationCountComplete;
340 
341 	
342 	function setMigrationAgent(address agent) public onlyOwner {
343 		migrationAgent = agent;
344 	}
345 
346 	function migrate() public returns (bool) {
347 		require(migrationAgent != 0x0);
348 		uint256 value = balances[msg.sender];
349 		balances[msg.sender] = balances[msg.sender].sub(value);
350 		totalSupply_ = totalSupply_.sub(value);
351 		MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
352 	
353 		Migrate(msg.sender, value);
354 		return true;
355 	}
356 
357 	function migrateHolders(uint256 count) public onlyOwner returns (bool) {
358 		require(count > 0);
359 		require(migrationAgent != 0x0);
360 		
361 		count = migrationCountComplete.add(count);
362 		if (count > holders.length) {
363 			count = holders.length;
364 		}
365 		for (uint256 i = migrationCountComplete; i < count; i++) {
366 			address holder = holders[i];
367 			uint value = balances[holder];
368 			balances[holder] = balances[holder].sub(value);
369 			totalSupply_ = totalSupply_.sub(value);
370 			MigrationAgent(migrationAgent).migrateFrom(holder, value);
371 			
372 			Migrate(holder, value);
373 		}
374 		migrationCountComplete = count;
375 		return true;
376 	}
377 
378 	event Migrate(address indexed owner, uint256 value);
379 }
380 
381 // File: contracts/ChainPay.sol
382 
383 contract ChainPay is MigratoryToken {
384 	using SafeMath for uint256;
385 
386 	// TOKEN NAME :: CHAINPAY :: LINKING DIGITAL PAYMENTS + EVERYDAY LIFE
387 	string public name;
388 	// TOKEN SYMBOL :: CIP :: CR_P IN PEACE NIP 
389 	string public symbol;
390 	//! Token decimals, 18
391 	uint8 public decimals;
392 
393 	/*!	Contructor
394 	 */
395 	function ChainPay() public {
396 		name = "ChainPay";
397 		symbol = "CIP";
398 		decimals = 18;
399 		totalSupply_ = 6060660000000000000000000; //six million, sixty thousand, six hundred sixty 
400 		// SIX-O
401 		balances[owner] = totalSupply_;
402 		holders[holders.length++] = owner;
403 		isHolder[owner] = true;
404 	}
405 
406 	address public migrationGate;
407 
408 	
409 	function setMigrationGate(address _addr) public onlyOwner {
410 		migrationGate = _addr;
411 	}
412 
413 
414 	modifier onlyMigrationGate() {
415 		require(msg.sender == migrationGate);
416 		_;
417 	}
418 
419 
420 	function transferMulti(address [] _tos, uint256 [] _values) public onlyMigrationGate returns (string) {
421 		require(_tos.length == _values.length);
422 		bytes memory return_values = new bytes(_tos.length);
423 
424 		for (uint256 i = 0; i < _tos.length; i++) {
425 			address _to = _tos[i];
426 			uint256 _value = _values[i];
427 			return_values[i] = byte(48); //'0'
428 
429 			if (_to != address(0) &&
430 				_value <= balances[msg.sender]) {
431 
432 				bool ok = transfer(_to, _value);
433 				if (ok) {
434 					return_values[i] = byte(49); //'1'
435 				}
436 			}
437 		}
438 		return string(return_values);
439 	}
440 
441 // DONT ACCEPT INCOMMING CRYPTO TO CONTRACT 
442 
443 	function() public payable {
444 		revert();
445 	}
446 }
447 
448 //cryptocurrency allows you to control your wealth usingtechnology, never in history was that possible.
449 //we are forever prolific 
450 // (the marathon continues)
451 //six million, sixty thousand, six hundred sixty #LLNH