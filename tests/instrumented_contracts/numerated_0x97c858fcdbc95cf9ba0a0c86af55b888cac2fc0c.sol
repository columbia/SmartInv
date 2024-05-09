1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenERC20 {
6 	// Public variables of the token
7 	string public name;
8 	string public symbol;
9 	uint8 public decimals = 18;
10 	// 18 decimals is the strongly suggested default, avoid changing it
11 	uint256 public totalSupply;
12 
13 	// This creates an array with all balances
14 	mapping (address => uint256) public balanceOf;
15 	mapping (address => mapping (address => uint256)) public allowance;
16 
17 	// This generates a public event on the blockchain that will notify clients
18 	event Transfer(address indexed from, address indexed to, uint256 value);
19 
20 	// This generates a public event on the blockchain that will notify clients
21 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 
23 	// This notifies clients about the amount burnt
24 	event Burn(address indexed from, uint256 value);
25 
26 	/**
27 	 * Constructor function
28 	 *
29 	 * Initializes contract with initial supply tokens to the creator of the contract
30 	 */
31 	constructor(
32 		uint256 initialSupply,
33 		string tokenName,
34 		string tokenSymbol
35 	) public {
36 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
37 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
38 		name = tokenName;                                   // Set the name for display purposes
39 		symbol = tokenSymbol;                               // Set the symbol for display purposes
40 	}
41 
42 	/**
43 	 * Internal transfer, only can be called by this contract
44 	 */
45 	function _transfer(address _from, address _to, uint _value) internal {
46 		// Prevent transfer to 0x0 address. Use burn() instead
47 		require(_to != 0x0);
48 		// Check if the sender has enough
49 		require(balanceOf[_from] >= _value);
50 		// Check for overflows
51 		require(balanceOf[_to] + _value > balanceOf[_to]);
52 		// Save this for an assertion in the future
53 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
54 		// Subtract from the sender
55 		balanceOf[_from] -= _value;
56 		// Add the same to the recipient
57 		balanceOf[_to] += _value;
58 		emit Transfer(_from, _to, _value);
59 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
60 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
61 	}
62 
63 	/**
64 	 * Transfer tokens
65 	 *
66 	 * Send `_value` tokens to `_to` from your account
67 	 *
68 	 * @param _to The address of the recipient
69 	 * @param _value the amount to send
70 	 */
71 	function transfer(address _to, uint256 _value) public returns (bool success) {
72 		_transfer(msg.sender, _to, _value);
73 		return true;
74 	}
75 
76 	/**
77 	 * Transfer tokens from other address
78 	 *
79 	 * Send `_value` tokens to `_to` in behalf of `_from`
80 	 *
81 	 * @param _from The address of the sender
82 	 * @param _to The address of the recipient
83 	 * @param _value the amount to send
84 	 */
85 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
87 		allowance[_from][msg.sender] -= _value;
88 		_transfer(_from, _to, _value);
89 		return true;
90 	}
91 
92 	/**
93 	 * Set allowance for other address
94 	 *
95 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
96 	 *
97 	 * @param _spender The address authorized to spend
98 	 * @param _value the max amount they can spend
99 	 */
100 	function approve(address _spender, uint256 _value) public returns (bool success) {
101 		allowance[msg.sender][_spender] = _value;
102 		emit Approval(msg.sender, _spender, _value);
103 		return true;
104 	}
105 
106 	/**
107 	 * Set allowance for other address and notify
108 	 *
109 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
110 	 *
111 	 * @param _spender The address authorized to spend
112 	 * @param _value the max amount they can spend
113 	 * @param _extraData some extra information to send to the approved contract
114 	 */
115 	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
116 		public
117 		returns (bool success) {
118 		tokenRecipient spender = tokenRecipient(_spender);
119 		if (approve(_spender, _value)) {
120 			spender.receiveApproval(msg.sender, _value, this, _extraData);
121 			return true;
122 		}
123 	}
124 
125 	/**
126 	 * Destroy tokens
127 	 *
128 	 * Remove `_value` tokens from the system irreversibly
129 	 *
130 	 * @param _value the amount of money to burn
131 	 */
132 	function burn(uint256 _value) public returns (bool success) {
133 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
134 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
135 		totalSupply -= _value;                      // Updates totalSupply
136 		emit Burn(msg.sender, _value);
137 		return true;
138 	}
139 
140 	/**
141 	 * Destroy tokens from other account
142 	 *
143 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
144 	 *
145 	 * @param _from the address of the sender
146 	 * @param _value the amount of money to burn
147 	 */
148 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
149 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
150 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
151 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
152 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
153 		totalSupply -= _value;                              // Update totalSupply
154 		emit Burn(_from, _value);
155 		return true;
156 	}
157 }
158 
159 contract developed {
160 	address public developer;
161 
162 	/**
163 	 * Constructor
164 	 */
165 	constructor() public {
166 		developer = msg.sender;
167 	}
168 
169 	/**
170 	 * @dev Checks only developer address is calling
171 	 */
172 	modifier onlyDeveloper {
173 		require(msg.sender == developer);
174 		_;
175 	}
176 
177 	/**
178 	 * @dev Allows developer to switch developer address
179 	 * @param _developer The new developer address to be set
180 	 */
181 	function changeDeveloper(address _developer) public onlyDeveloper {
182 		developer = _developer;
183 	}
184 
185 	/**
186 	 * @dev Allows developer to withdraw ERC20 Token
187 	 */
188 	function withdrawToken(address tokenContractAddress) public onlyDeveloper {
189 		TokenERC20 _token = TokenERC20(tokenContractAddress);
190 		if (_token.balanceOf(this) > 0) {
191 			_token.transfer(developer, _token.balanceOf(this));
192 		}
193 	}
194 }
195 
196 /**
197  * @title ContractVerification
198  */
199 contract ContractVerification is developed {
200 	bool public contractKilled;
201 
202 	mapping(bytes32 => string) public stringSettings;  // Array containing all string settings
203 	mapping(bytes32 => uint256) public uintSettings;   // Array containing all uint256 settings
204 	mapping(bytes32 => bool) public boolSettings;      // Array containing all bool settings
205 
206 	/**
207 	 * @dev Setting variables
208 	 */
209 	struct Version {
210 		bool active;
211 		uint256[] hostIds;
212 		string settings;
213 	}
214 	struct Host {
215 		bool active;
216 		string settings;
217 	}
218 
219 	// mapping versionNum => Version
220 	mapping(uint256 => Version) public versions;
221 
222 	// mapping hostId => Host
223 	mapping(uint256 => Host) public hosts;
224 
225 	uint256 public totalVersionSetting;
226 	uint256 public totalHostSetting;
227 
228 	/**
229 	 * @dev Log dev updates string setting
230 	 */
231 	event LogUpdateStringSetting(bytes32 indexed name, string value);
232 
233 	/**
234 	 * @dev Log dev updates uint setting
235 	 */
236 	event LogUpdateUintSetting(bytes32 indexed name, uint256 value);
237 
238 	/**
239 	 * @dev Log dev updates bool setting
240 	 */
241 	event LogUpdateBoolSetting(bytes32 indexed name, bool value);
242 
243 	/**
244 	 * @dev Log dev deletes string setting
245 	 */
246 	event LogDeleteStringSetting(bytes32 indexed name);
247 
248 	/**
249 	 * @dev Log dev deletes uint setting
250 	 */
251 	event LogDeleteUintSetting(bytes32 indexed name);
252 
253 	/**
254 	 * @dev Log dev deletes bool setting
255 	 */
256 	event LogDeleteBoolSetting(bytes32 indexed name);
257 
258 	/**
259 	 * @dev Log dev add version setting
260 	 */
261 	event LogAddVersionSetting(uint256 indexed versionNum, bool active, uint256[] hostIds, string settings);
262 
263 	/**
264 	 * @dev Log dev delete version setting
265 	 */
266 	event LogDeleteVersionSetting(uint256 indexed versionNum);
267 
268 	/**
269 	 * @dev Log dev update version setting
270 	 */
271 	event LogUpdateVersionSetting(uint256 indexed versionNum, bool active, uint256[] hostIds, string settings);
272 
273 	/**
274 	 * @dev Log dev add host setting
275 	 */
276 	event LogAddHostSetting(uint256 indexed hostId, bool active, string settings);
277 
278 	/**
279 	 * @dev Log dev delete host setting
280 	 */
281 	event LogDeleteHostSetting(uint256 indexed hostId);
282 
283 	/**
284 	 * @dev Log dev update host setting
285 	 */
286 	event LogUpdateHostSetting(uint256 indexed hostId, bool active, string settings);
287 
288 	/**
289 	 * @dev Log dev add host to version
290 	 */
291 	event LogAddHostIdToVersion(uint256 indexed hostId, uint256 versionNum, bool success);
292 
293 	/**
294 	 * @dev Log dev remove host id at version
295 	 */
296 	event LogRemoveHostIdAtVersion(uint256 indexed hostId, uint256 versionNum, bool success);
297 
298 	/**
299 	 * @dev Log when emergency mode is on
300 	 */
301 	event LogEscapeHatch();
302 
303 	/**
304 	 * Constructor
305 	 */
306 	constructor() public {}
307 
308 	/******************************************/
309 	/*       DEVELOPER ONLY METHODS           */
310 	/******************************************/
311 
312 	/**
313 	 * @dev Allows dev to update string setting
314 	 * @param name The setting name to be set
315 	 * @param value The value to be set
316 	 */
317 	function updateStringSetting(bytes32 name, string value) public onlyDeveloper {
318 		stringSettings[name] = value;
319 		emit LogUpdateStringSetting(name, value);
320 	}
321 
322 	/**
323 	 * @dev Allows dev to set uint setting
324 	 * @param name The setting name to be set
325 	 * @param value The value to be set
326 	 */
327 	function updateUintSetting(bytes32 name, uint256 value) public onlyDeveloper {
328 		uintSettings[name] = value;
329 		emit LogUpdateUintSetting(name, value);
330 	}
331 
332 	/**
333 	 * @dev Allows dev to set bool setting
334 	 * @param name The setting name to be set
335 	 * @param value The value to be set
336 	 */
337 	function updateBoolSetting(bytes32 name, bool value) public onlyDeveloper {
338 		boolSettings[name] = value;
339 		emit LogUpdateBoolSetting(name, value);
340 	}
341 
342 	/**
343 	 * @dev Allows dev to delete string setting
344 	 * @param name The setting name to be deleted
345 	 */
346 	function deleteStringSetting(bytes32 name) public onlyDeveloper {
347 		delete stringSettings[name];
348 		emit LogDeleteStringSetting(name);
349 	}
350 
351 	/**
352 	 * @dev Allows dev to delete uint setting
353 	 * @param name The setting name to be deleted
354 	 */
355 	function deleteUintSetting(bytes32 name) public onlyDeveloper {
356 		delete uintSettings[name];
357 		emit LogDeleteUintSetting(name);
358 	}
359 
360 	/**
361 	 * @dev Allows dev to delete bool setting
362 	 * @param name The setting name to be deleted
363 	 */
364 	function deleteBoolSetting(bytes32 name) public onlyDeveloper {
365 		delete boolSettings[name];
366 		emit LogDeleteBoolSetting(name);
367 	}
368 
369 	/**
370 	 * @dev Allows dev to add version settings
371 	 * @param active The boolean value to be set
372 	 * @param hostIds An array of hostIds
373 	 * @param settings The settings string to be set
374 	 */
375 	function addVersionSetting(bool active, uint256[] hostIds, string settings) public onlyDeveloper {
376 		totalVersionSetting++;
377 
378 		// Make sure every ID in hostIds exists
379 		if (hostIds.length > 0) {
380 			for(uint256 i=0; i<hostIds.length; i++) {
381 				require (bytes(hosts[hostIds[i]].settings).length > 0);
382 			}
383 		}
384 		Version storage _version = versions[totalVersionSetting];
385 		_version.active = active;
386 		_version.hostIds = hostIds;
387 		_version.settings = settings;
388 
389 		emit LogAddVersionSetting(totalVersionSetting, _version.active, _version.hostIds, _version.settings);
390 	}
391 
392 	/**
393 	 * @dev Allows dev to delete version settings
394 	 * @param versionNum The version num
395 	 */
396 	function deleteVersionSetting(uint256 versionNum) public onlyDeveloper {
397 		delete versions[versionNum];
398 		emit LogDeleteVersionSetting(versionNum);
399 	}
400 
401 	/**
402 	 * @dev Allows dev to update version settings
403 	 * @param versionNum The version of this setting
404 	 * @param active The boolean value to be set
405 	 * @param hostIds The array of host ids
406 	 * @param settings The settings string to be set
407 	 */
408 	function updateVersionSetting(uint256 versionNum, bool active, uint256[] hostIds, string settings) public onlyDeveloper {
409 		// Make sure version setting of this versionNum exists
410 		require (bytes(versions[versionNum].settings).length > 0);
411 
412 		// Make sure every ID in hostIds exists
413 		if (hostIds.length > 0) {
414 			for(uint256 i=0; i<hostIds.length; i++) {
415 				require (bytes(hosts[hostIds[i]].settings).length > 0);
416 			}
417 		}
418 		Version storage _version = versions[versionNum];
419 		_version.active = active;
420 		_version.hostIds = hostIds;
421 		_version.settings = settings;
422 
423 		emit LogUpdateVersionSetting(versionNum, _version.active, _version.hostIds, _version.settings);
424 	}
425 
426 	/**
427 	 * @dev Allows dev to add host id to version hostIds
428 	 * @param hostId The host Id to be added
429 	 * @param versionNum The version num destination
430 	 */
431 	function addHostIdToVersion(uint256 hostId, uint256 versionNum) public onlyDeveloper {
432 		require (hosts[hostId].active == true);
433 		require (versions[versionNum].active == true);
434 
435 		Version storage _version = versions[versionNum];
436 		if (_version.hostIds.length == 0) {
437 			_version.hostIds.push(hostId);
438 			emit LogAddHostIdToVersion(hostId, versionNum, true);
439 		} else {
440 			bool exist = false;
441 			for (uint256 i=0; i < _version.hostIds.length; i++) {
442 				if (_version.hostIds[i] == hostId) {
443 					exist = true;
444 					break;
445 				}
446 			}
447 			if (!exist) {
448 				_version.hostIds.push(hostId);
449 				emit LogAddHostIdToVersion(hostId, versionNum, true);
450 			} else {
451 				emit LogAddHostIdToVersion(hostId, versionNum, false);
452 			}
453 		}
454 	}
455 
456 	/**
457 	 * @dev Allows dev to remove host id at version hostIds
458 	 * @param hostId The host Id to be removed
459 	 * @param versionNum The version num destination
460 	 */
461 	function removeHostIdAtVersion(uint256 hostId, uint256 versionNum) public onlyDeveloper {
462 		Version storage _version = versions[versionNum];
463 		require (versions[versionNum].active == true);
464 		uint256 hostIdCount = versions[versionNum].hostIds.length;
465 		require (hostIdCount > 0);
466 
467 		int256 position = -1;
468 		for (uint256 i=0; i < hostIdCount; i++) {
469 			if (_version.hostIds[i] == hostId) {
470 				position = int256(i);
471 				break;
472 			}
473 		}
474 		require (position >= 0);
475 
476 		for (i = uint256(position); i < hostIdCount-1; i++){
477 			_version.hostIds[i] = _version.hostIds[i+1];
478 		}
479 		delete _version.hostIds[hostIdCount-1];
480 		_version.hostIds.length--;
481 		emit LogRemoveHostIdAtVersion(hostId, versionNum, true);
482 	}
483 
484 	/**
485 	 * @dev Allows dev to add host settings
486 	 * @param active The boolean value to be set
487 	 * @param settings The settings string to be set
488 	 */
489 	function addHostSetting(bool active, string settings) public onlyDeveloper {
490 		totalHostSetting++;
491 
492 		Host storage _host = hosts[totalHostSetting];
493 		_host.active = active;
494 		_host.settings = settings;
495 
496 		emit LogAddHostSetting(totalHostSetting, _host.active, _host.settings);
497 	}
498 
499 	/**
500 	 * @dev Allows dev to delete host settings
501 	 * @param hostId The host ID
502 	 */
503 	function deleteHostSetting(uint256 hostId) public onlyDeveloper {
504 		require (bytes(hosts[hostId].settings).length > 0);
505 
506 		delete hosts[hostId];
507 		emit LogDeleteHostSetting(hostId);
508 	}
509 
510 	/**
511 	 * @dev Allows dev to update host settings
512 	 * @param hostId The host ID
513 	 * @param active The boolean value to be set
514 	 * @param settings The settings string to be set
515 	 */
516 	function updateHostSetting(uint256 hostId, bool active, string settings) public onlyDeveloper {
517 		require (bytes(hosts[hostId].settings).length > 0);
518 
519 		Host storage _host = hosts[hostId];
520 		_host.active = active;
521 		_host.settings = settings;
522 
523 		emit LogUpdateHostSetting(hostId, _host.active, _host.settings);
524 	}
525 
526 	/**
527 	 * @dev Allows developer to trigger emergency mode
528 	 */
529 	function escapeHatch() public onlyDeveloper {
530 		require (contractKilled == false);
531 		contractKilled = true;
532 		if (address(this).balance > 0) {
533 			developer.transfer(address(this).balance);
534 		}
535 		emit LogEscapeHatch();
536 	}
537 
538 	/******************************************/
539 	/*             PUBLIC METHODS             */
540 	/******************************************/
541 
542 	/**
543 	 * @dev Get version settings based on versionNum
544 	 * @param versionNum The version num
545 	 * @return Active state of this version
546 	 * @return Array of host Ids
547 	 * @return The settings string
548 	 */
549 	function getVersionSetting(uint256 versionNum) public constant returns (bool, uint256[], string) {
550 		Version memory _version = versions[versionNum];
551 		return (_version.active, _version.hostIds, _version.settings);
552 	}
553 
554 	/**
555 	 * @dev Get latest version settings
556 	 * @return Active state of the latest version
557 	 * @return Array of host Ids
558 	 * @return The settings string
559 	 */
560 	function getLatestVersionSetting() public constant returns (bool, uint256[], string) {
561 		Version memory _version = versions[totalVersionSetting];
562 		return (_version.active, _version.hostIds, _version.settings);
563 	}
564 }