1 // hevm: flattened sources of src/DrillTakeBack.sol
2 pragma solidity >0.4.13 >=0.4.23 >=0.6.0 <0.7.0 >=0.6.7 <0.7.0;
3 
4 ////// lib/ds-auth/src/auth.sol
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU General Public License for more details.
14 
15 // You should have received a copy of the GNU General Public License
16 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
17 
18 /* pragma solidity >=0.4.23; */
19 
20 interface DSAuthority {
21     function canCall(
22         address src, address dst, bytes4 sig
23     ) external view returns (bool);
24 }
25 
26 contract DSAuthEvents {
27     event LogSetAuthority (address indexed authority);
28     event LogSetOwner     (address indexed owner);
29 }
30 
31 contract DSAuth is DSAuthEvents {
32     DSAuthority  public  authority;
33     address      public  owner;
34 
35     constructor() public {
36         owner = msg.sender;
37         emit LogSetOwner(msg.sender);
38     }
39 
40     function setOwner(address owner_)
41         public
42         auth
43     {
44         owner = owner_;
45         emit LogSetOwner(owner);
46     }
47 
48     function setAuthority(DSAuthority authority_)
49         public
50         auth
51     {
52         authority = authority_;
53         emit LogSetAuthority(address(authority));
54     }
55 
56     modifier auth {
57         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
58         _;
59     }
60 
61     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
62         if (src == address(this)) {
63             return true;
64         } else if (src == owner) {
65             return true;
66         } else if (authority == DSAuthority(0)) {
67             return false;
68         } else {
69             return authority.canCall(src, address(this), sig);
70         }
71     }
72 }
73 
74 ////// lib/ds-math/src/math.sol
75 /// math.sol -- mixin for inline numerical wizardry
76 
77 // This program is free software: you can redistribute it and/or modify
78 // it under the terms of the GNU General Public License as published by
79 // the Free Software Foundation, either version 3 of the License, or
80 // (at your option) any later version.
81 
82 // This program is distributed in the hope that it will be useful,
83 // but WITHOUT ANY WARRANTY; without even the implied warranty of
84 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
85 // GNU General Public License for more details.
86 
87 // You should have received a copy of the GNU General Public License
88 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
89 
90 /* pragma solidity >0.4.13; */
91 
92 contract DSMath {
93     function add(uint x, uint y) internal pure returns (uint z) {
94         require((z = x + y) >= x, "ds-math-add-overflow");
95     }
96     function sub(uint x, uint y) internal pure returns (uint z) {
97         require((z = x - y) <= x, "ds-math-sub-underflow");
98     }
99     function mul(uint x, uint y) internal pure returns (uint z) {
100         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
101     }
102 
103     function min(uint x, uint y) internal pure returns (uint z) {
104         return x <= y ? x : y;
105     }
106     function max(uint x, uint y) internal pure returns (uint z) {
107         return x >= y ? x : y;
108     }
109     function imin(int x, int y) internal pure returns (int z) {
110         return x <= y ? x : y;
111     }
112     function imax(int x, int y) internal pure returns (int z) {
113         return x >= y ? x : y;
114     }
115 
116     uint constant WAD = 10 ** 18;
117     uint constant RAY = 10 ** 27;
118 
119     //rounds to zero if x*y < WAD / 2
120     function wmul(uint x, uint y) internal pure returns (uint z) {
121         z = add(mul(x, y), WAD / 2) / WAD;
122     }
123     //rounds to zero if x*y < WAD / 2
124     function rmul(uint x, uint y) internal pure returns (uint z) {
125         z = add(mul(x, y), RAY / 2) / RAY;
126     }
127     //rounds to zero if x*y < WAD / 2
128     function wdiv(uint x, uint y) internal pure returns (uint z) {
129         z = add(mul(x, WAD), y / 2) / y;
130     }
131     //rounds to zero if x*y < RAY / 2
132     function rdiv(uint x, uint y) internal pure returns (uint z) {
133         z = add(mul(x, RAY), y / 2) / y;
134     }
135 
136     // This famous algorithm is called "exponentiation by squaring"
137     // and calculates x^n with x as fixed-point and n as regular unsigned.
138     //
139     // It's O(log n), instead of O(n) for naive repeated multiplication.
140     //
141     // These facts are why it works:
142     //
143     //  If n is even, then x^n = (x^2)^(n/2).
144     //  If n is odd,  then x^n = x * x^(n-1),
145     //   and applying the equation for even x gives
146     //    x^n = x * (x^2)^((n-1) / 2).
147     //
148     //  Also, EVM division is flooring and
149     //    floor[(n-1) / 2] = floor[n / 2].
150     //
151     function rpow(uint x, uint n) internal pure returns (uint z) {
152         z = n % 2 != 0 ? x : RAY;
153 
154         for (n /= 2; n != 0; n /= 2) {
155             x = rmul(x, x);
156 
157             if (n % 2 != 0) {
158                 z = rmul(z, x);
159             }
160         }
161     }
162 }
163 
164 ////// lib/ds-stop/lib/ds-note/src/note.sol
165 /// note.sol -- the `note' modifier, for logging calls as events
166 
167 // This program is free software: you can redistribute it and/or modify
168 // it under the terms of the GNU General Public License as published by
169 // the Free Software Foundation, either version 3 of the License, or
170 // (at your option) any later version.
171 
172 // This program is distributed in the hope that it will be useful,
173 // but WITHOUT ANY WARRANTY; without even the implied warranty of
174 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
175 // GNU General Public License for more details.
176 
177 // You should have received a copy of the GNU General Public License
178 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
179 
180 /* pragma solidity >=0.4.23; */
181 
182 contract DSNote {
183     event LogNote(
184         bytes4   indexed  sig,
185         address  indexed  guy,
186         bytes32  indexed  foo,
187         bytes32  indexed  bar,
188         uint256           wad,
189         bytes             fax
190     ) anonymous;
191 
192     modifier note {
193         bytes32 foo;
194         bytes32 bar;
195         uint256 wad;
196 
197         assembly {
198             foo := calldataload(4)
199             bar := calldataload(36)
200             wad := callvalue()
201         }
202 
203         _;
204 
205         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
206     }
207 }
208 
209 ////// lib/ds-stop/src/stop.sol
210 /// stop.sol -- mixin for enable/disable functionality
211 
212 // Copyright (C) 2017  DappHub, LLC
213 
214 // This program is free software: you can redistribute it and/or modify
215 // it under the terms of the GNU General Public License as published by
216 // the Free Software Foundation, either version 3 of the License, or
217 // (at your option) any later version.
218 
219 // This program is distributed in the hope that it will be useful,
220 // but WITHOUT ANY WARRANTY; without even the implied warranty of
221 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
222 // GNU General Public License for more details.
223 
224 // You should have received a copy of the GNU General Public License
225 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
226 
227 /* pragma solidity >=0.4.23; */
228 
229 /* import "ds-auth/auth.sol"; */
230 /* import "ds-note/note.sol"; */
231 
232 contract DSStop is DSNote, DSAuth {
233     bool public stopped;
234 
235     modifier stoppable {
236         require(!stopped, "ds-stop-is-stopped");
237         _;
238     }
239     function stop() public auth note {
240         stopped = true;
241     }
242     function start() public auth note {
243         stopped = false;
244     }
245 
246 }
247 
248 ////// lib/zeppelin-solidity/src/token/ERC20/IERC20.sol
249 // SPDX-License-Identifier: MIT
250 
251 /* pragma solidity ^0.6.0; */
252 
253 /**
254  * @dev Interface of the ERC20 standard as defined in the EIP.
255  */
256 interface IERC20 {
257     /**
258      * @dev Returns the amount of tokens in existence.
259      */
260     function totalSupply() external view returns (uint256);
261 
262     /**
263      * @dev Returns the amount of tokens owned by `account`.
264      */
265     function balanceOf(address account) external view returns (uint256);
266 
267     /**
268      * @dev Moves `amount` tokens from the caller's account to `recipient`.
269      *
270      * Returns a boolean value indicating whether the operation succeeded.
271      *
272      * Emits a {Transfer} event.
273      */
274     function transfer(address recipient, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Returns the remaining number of tokens that `spender` will be
278      * allowed to spend on behalf of `owner` through {transferFrom}. This is
279      * zero by default.
280      *
281      * This value changes when {approve} or {transferFrom} are called.
282      */
283     function allowance(address owner, address spender) external view returns (uint256);
284 
285     /**
286      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
287      *
288      * Returns a boolean value indicating whether the operation succeeded.
289      *
290      * IMPORTANT: Beware that changing an allowance with this method brings the risk
291      * that someone may use both the old and the new allowance by unfortunate
292      * transaction ordering. One possible solution to mitigate this race
293      * condition is to first reduce the spender's allowance to 0 and set the
294      * desired value afterwards:
295      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
296      *
297      * Emits an {Approval} event.
298      */
299     function approve(address spender, uint256 amount) external returns (bool);
300 
301     /**
302      * @dev Moves `amount` tokens from `sender` to `recipient` using the
303      * allowance mechanism. `amount` is then deducted from the caller's
304      * allowance.
305      *
306      * Returns a boolean value indicating whether the operation succeeded.
307      *
308      * Emits a {Transfer} event.
309      */
310     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
311 
312     /**
313      * @dev Emitted when `value` tokens are moved from one account (`from`) to
314      * another (`to`).
315      *
316      * Note that `value` may be zero.
317      */
318     event Transfer(address indexed from, address indexed to, uint256 value);
319 
320     /**
321      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
322      * a call to {approve}. `value` is the new allowance.
323      */
324     event Approval(address indexed owner, address indexed spender, uint256 value);
325 }
326 
327 ////// src/interfaces/IDrillBase.sol
328 /* pragma solidity ^0.6.7; */
329 
330 interface IDrillBase {
331 	function createDrill(uint16 grade, address to) external returns (uint256);
332 
333     function destroyDrill(address to, uint256 tokenId) external;
334 }
335 
336 ////// src/interfaces/ISettingsRegistry.sol
337 /* pragma solidity ^0.6.7; */
338 
339 interface ISettingsRegistry {
340     enum SettingsValueTypes { NONE, UINT, STRING, ADDRESS, BYTES, BOOL, INT }
341 
342     function uintOf(bytes32 _propertyName) external view returns (uint256);
343 
344     function stringOf(bytes32 _propertyName) external view returns (string memory);
345 
346     function addressOf(bytes32 _propertyName) external view returns (address);
347 
348     function bytesOf(bytes32 _propertyName) external view returns (bytes memory);
349 
350     function boolOf(bytes32 _propertyName) external view returns (bool);
351 
352     function intOf(bytes32 _propertyName) external view returns (int);
353 
354     function setUintProperty(bytes32 _propertyName, uint _value) external;
355 
356     function setStringProperty(bytes32 _propertyName, string calldata _value) external;
357 
358     function setAddressProperty(bytes32 _propertyName, address _value) external;
359 
360     function setBytesProperty(bytes32 _propertyName, bytes calldata _value) external;
361 
362     function setBoolProperty(bytes32 _propertyName, bool _value) external;
363 
364     function setIntProperty(bytes32 _propertyName, int _value) external;
365 
366     function getValueTypeOf(bytes32 _propertyName) external view returns (uint /* SettingsValueTypes */ );
367 
368     event ChangeProperty(bytes32 indexed _propertyName, uint256 _type);
369 }
370 
371 ////// src/DrillTakeBack.sol
372 /* pragma solidity ^0.6.7; */
373 
374 /* import "ds-stop/stop.sol"; */
375 /* import "ds-math/math.sol"; */
376 /* import "zeppelin-solidity/token/ERC20/IERC20.sol"; */
377 /* import "./interfaces/ISettingsRegistry.sol"; */
378 /* import "./interfaces/IDrillBase.sol"; */
379 
380 contract DrillTakeBack is DSMath, DSStop {
381 	event TakeBackDrill(
382 		address indexed user,
383 		uint256 indexed id,
384 		uint256 tokenId
385 	);
386 	event OpenBox(
387 		address indexed user,
388 		uint256 indexed id,
389 		uint256 tokenId,
390 		uint256 value
391 	);
392 	event ClaimedTokens(
393 		address indexed token,
394 		address indexed to,
395 		uint256 amount
396 	);
397 
398 	// 0x434f4e54524143545f52494e475f45524332305f544f4b454e00000000000000
399 	bytes32 public constant CONTRACT_RING_ERC20_TOKEN =
400 		"CONTRACT_RING_ERC20_TOKEN";
401 
402 	// 0x434f4e54524143545f4954454d5f424153450000000000000000000000000000
403 	bytes32 public constant CONTRACT_DRILL_BASE = "CONTRACT_DRILL_BASE";
404 
405 	address public supervisor;
406 
407 	uint256 public networkId;
408 
409 	mapping(uint256 => bool) public ids;
410 
411 	ISettingsRegistry public registry;
412 
413 	modifier isHuman() {
414 		// solhint-disable-next-line avoid-tx-origin
415 		require(msg.sender == tx.origin, "robot is not permitted");
416 		_;
417 	}
418 
419 	constructor(
420 		address _registry,
421 		address _supervisor,
422 		uint256 _networkId
423 	) public {
424 		supervisor = _supervisor;
425 		networkId = _networkId;
426 		registry = ISettingsRegistry(_registry);
427 	}
428 
429 	// _hashmessage = hash("${address(this)}{_user}${networkId}${ids[]}${grade[]}")
430 	// _v, _r, _s are from supervisor's signature on _hashmessage
431 	// takeBack(...) is invoked by the user who want to clain drill.
432 	// while the _hashmessage is signed by supervisor
433 	function takeBack(
434 		uint256[] memory _ids,
435 		uint16[] memory _grades,
436 		bytes32 _hashmessage,
437 		uint8 _v,
438 		bytes32 _r,
439 		bytes32 _s
440 	) public isHuman stoppable {
441 		address _user = msg.sender;
442 		// verify the _hashmessage is signed by supervisor
443 		require(
444 			supervisor == _verify(_hashmessage, _v, _r, _s),
445 			"verify failed"
446 		);
447 		// verify that the address(this), _user, networkId, _ids, _grades are exactly what they should be
448 		require(
449 			keccak256(
450 				abi.encodePacked(address(this), _user, networkId, _ids, _grades)
451 			) == _hashmessage,
452 			"hash invaild"
453 		);
454 		require(_ids.length == _grades.length, "length invalid.");
455 		require(_grades.length > 0, "no drill.");
456 		for (uint256 i = 0; i < _ids.length; i++) {
457 			uint256 id = _ids[i];
458 			require(ids[id] == false, "already taked back.");
459 			uint16 grade = _grades[i];
460 			uint256 tokenId = _rewardDrill(grade, _user);
461 			ids[id] = true;
462 			emit TakeBackDrill(_user, id, tokenId);
463 		}
464 	}
465 
466 	// _hashmessage = hash("${address(this)}${_user}${networkId}${boxId[]}${amount[]}")
467 	function openBoxes(
468 		uint256[] memory _ids,
469 		uint256[] memory _amounts,
470 		bytes32 _hashmessage,
471 		uint8 _v,
472 		bytes32 _r,
473 		bytes32 _s
474 	) public isHuman stoppable {
475 		address _user = msg.sender;
476 		// verify the _hashmessage is signed by supervisor
477 		require(
478 			supervisor == _verify(_hashmessage, _v, _r, _s),
479 			"verify failed"
480 		);
481 		// verify that the _user, _value are exactly what they should be
482 		require(
483 			keccak256(
484 				abi.encodePacked(
485 					address(this),
486 					_user,
487 					networkId,
488 					_ids,
489 					_amounts
490 				)
491 			) == _hashmessage,
492 			"hash invaild"
493 		);
494 		require(_ids.length == _amounts.length, "length invalid.");
495 		require(_ids.length > 0, "no box.");
496 		for (uint256 i = 0; i < _ids.length; i++) {
497 			uint256 id = _ids[i];
498 			require(ids[id] == false, "box already opened.");
499 			_openBox(_user, id, _amounts[i]);
500 			ids[id] = true;
501 		}
502 	}
503 
504 	function _openBox(
505 		address _user,
506 		uint256 _boxId,
507 		uint256 _amount
508 	) internal {
509 		(uint256 prizeDrill, uint256 prizeRing) = _random(_boxId);
510 		uint256 tokenId;
511 		uint256 value;
512 		uint256 boxType = _boxId >> 255;
513 		if (boxType == 1) {
514 			// gold box
515 			if (prizeRing == 1 && _amount > 1) {
516 				address ring = registry.addressOf(CONTRACT_RING_ERC20_TOKEN);
517 				value = _amount / 2;
518 				IERC20(ring).transfer(_user, value);
519 			}
520 			if (prizeDrill < 10) {
521 				tokenId = _rewardDrill(3, _user);
522 			} else {
523 				tokenId = _rewardDrill(2, _user);
524 			}
525 		} else {
526 			// silver box
527 			if (prizeDrill == 0) {
528 				tokenId = _rewardDrill(3, _user);
529 			} else if (prizeDrill < 10) {
530 				tokenId = _rewardDrill(2, _user);
531 			} else {
532 				tokenId = _rewardDrill(1, _user);
533 			}
534 		}
535 		emit OpenBox(_user, _boxId, tokenId, value);
536 	}
537 
538 	function _rewardDrill(uint16 _grade, address _owner)
539 		internal
540 		returns (uint256)
541 	{
542 		address drill = registry.addressOf(CONTRACT_DRILL_BASE);
543 		return IDrillBase(drill).createDrill(_grade, _owner);
544 	}
545 
546 	// random algorithm
547 	function _random(uint256 _boxId) internal view returns (uint256, uint256) {
548 		uint256 seed =
549 			uint256(
550 				keccak256(
551 					abi.encodePacked(
552 						blockhash(block.number),
553 						block.timestamp, // solhint-disable-line not-rely-on-time
554 						block.difficulty,
555 						_boxId
556 					)
557 				)
558 			);
559 		return (seed % 100, seed >> 255);
560 	}
561 
562 	function _verify(
563 		bytes32 _hashmessage,
564 		uint8 _v,
565 		bytes32 _r,
566 		bytes32 _s
567 	) internal pure returns (address) {
568 		bytes memory prefix = "\x19EvolutionLand Signed Message:\n32";
569 		bytes32 prefixedHash =
570 			keccak256(abi.encodePacked(prefix, _hashmessage));
571 		address signer = ecrecover(prefixedHash, _v, _r, _s);
572 		return signer;
573 	}
574 
575 	function changeSupervisor(address _newSupervisor) public auth {
576 		supervisor = _newSupervisor;
577 	}
578 
579 	//////////
580 	// Safety Methods
581 	//////////
582 
583 	/// @notice This method can be used by the controller to extract mistakenly
584 	///  sent tokens to this contract.
585 	/// @param _token The address of the token contract that you want to recover
586 	///  set to 0 in case you want to extract ether.
587 	function claimTokens(address _token) public auth {
588 		if (_token == address(0)) {
589 			_makePayable(owner).transfer(address(this).balance);
590 			return;
591 		}
592 		IERC20 token = IERC20(_token);
593 		uint256 balance = token.balanceOf(address(this));
594 		token.transfer(owner, balance);
595 		emit ClaimedTokens(_token, owner, balance);
596 	}
597 
598 	function _makePayable(address x) internal pure returns (address payable) {
599 		return address(uint160(x));
600 	}
601 }