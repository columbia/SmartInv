1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of /nix/store/nwn3cgggcciwhpp3b8nhns36sk2pgm19-ds-token/dapp/ds-token/src/delegate.sol
4 pragma solidity >0.4.13 >0.4.20 >=0.4.23 >=0.5.13 >=0.6.7;
5 
6 ////// /nix/store/4ql2pcn6rjabbv77m0rkssc6rnlcw80i-ds-math/dapp/ds-math/src/math.sol
7 /// math.sol -- mixin for inline numerical wizardry
8 
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU General Public License as published by
11 // the Free Software Foundation, either version 3 of the License, or
12 // (at your option) any later version.
13 
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU General Public License for more details.
18 
19 // You should have received a copy of the GNU General Public License
20 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
21 
22 /* pragma solidity >0.4.13; */
23 
24 contract DSMath {
25     function add(uint x, uint y) internal pure returns (uint z) {
26         require((z = x + y) >= x, "ds-math-add-overflow");
27     }
28     function sub(uint x, uint y) internal pure returns (uint z) {
29         require((z = x - y) <= x, "ds-math-sub-underflow");
30     }
31     function mul(uint x, uint y) internal pure returns (uint z) {
32         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
33     }
34 
35     function min(uint x, uint y) internal pure returns (uint z) {
36         return x <= y ? x : y;
37     }
38     function max(uint x, uint y) internal pure returns (uint z) {
39         return x >= y ? x : y;
40     }
41     function imin(int x, int y) internal pure returns (int z) {
42         return x <= y ? x : y;
43     }
44     function imax(int x, int y) internal pure returns (int z) {
45         return x >= y ? x : y;
46     }
47 
48     uint constant WAD = 10 ** 18;
49     uint constant RAY = 10 ** 27;
50 
51     //rounds to zero if x*y < WAD / 2
52     function wmul(uint x, uint y) internal pure returns (uint z) {
53         z = add(mul(x, y), WAD / 2) / WAD;
54     }
55     //rounds to zero if x*y < WAD / 2
56     function rmul(uint x, uint y) internal pure returns (uint z) {
57         z = add(mul(x, y), RAY / 2) / RAY;
58     }
59     //rounds to zero if x*y < WAD / 2
60     function wdiv(uint x, uint y) internal pure returns (uint z) {
61         z = add(mul(x, WAD), y / 2) / y;
62     }
63     //rounds to zero if x*y < RAY / 2
64     function rdiv(uint x, uint y) internal pure returns (uint z) {
65         z = add(mul(x, RAY), y / 2) / y;
66     }
67 
68     // This famous algorithm is called "exponentiation by squaring"
69     // and calculates x^n with x as fixed-point and n as regular unsigned.
70     //
71     // It's O(log n), instead of O(n) for naive repeated multiplication.
72     //
73     // These facts are why it works:
74     //
75     //  If n is even, then x^n = (x^2)^(n/2).
76     //  If n is odd,  then x^n = x * x^(n-1),
77     //   and applying the equation for even x gives
78     //    x^n = x * (x^2)^((n-1) / 2).
79     //
80     //  Also, EVM division is flooring and
81     //    floor[(n-1) / 2] = floor[n / 2].
82     //
83     function rpow(uint x, uint n) internal pure returns (uint z) {
84         z = n % 2 != 0 ? x : RAY;
85 
86         for (n /= 2; n != 0; n /= 2) {
87             x = rmul(x, x);
88 
89             if (n % 2 != 0) {
90                 z = rmul(z, x);
91             }
92         }
93     }
94 }
95 
96 ////// /nix/store/bzb8sqrf2s1bw565m06rimpqj7mwyi42-ds-note/dapp/ds-note/src/note.sol
97 /// note.sol -- the `note' modifier, for logging calls as events
98 
99 // This program is free software: you can redistribute it and/or modify
100 // it under the terms of the GNU General Public License as published by
101 // the Free Software Foundation, either version 3 of the License, or
102 // (at your option) any later version.
103 
104 // This program is distributed in the hope that it will be useful,
105 // but WITHOUT ANY WARRANTY; without even the implied warranty of
106 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
107 // GNU General Public License for more details.
108 
109 // You should have received a copy of the GNU General Public License
110 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
111 
112 /* pragma solidity >=0.4.23; */
113 
114 contract DSNote {
115     event LogNote(
116         bytes4   indexed  sig,
117         address  indexed  guy,
118         bytes32  indexed  foo,
119         bytes32  indexed  bar,
120         uint256           wad,
121         bytes             fax
122     ) anonymous;
123 
124     modifier note {
125         bytes32 foo;
126         bytes32 bar;
127         uint256 wad;
128 
129         assembly {
130             foo := calldataload(4)
131             bar := calldataload(36)
132             wad := callvalue()
133         }
134 
135         _;
136 
137         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
138     }
139 }
140 
141 ////// /nix/store/s34fzrzqaqxbi1s0ljplsk62qapsr70y-ds-auth/dapp/ds-auth/src/auth.sol
142 // This program is free software: you can redistribute it and/or modify
143 // it under the terms of the GNU General Public License as published by
144 // the Free Software Foundation, either version 3 of the License, or
145 // (at your option) any later version.
146 
147 // This program is distributed in the hope that it will be useful,
148 // but WITHOUT ANY WARRANTY; without even the implied warranty of
149 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
150 // GNU General Public License for more details.
151 
152 // You should have received a copy of the GNU General Public License
153 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
154 
155 /* pragma solidity >=0.6.7; */
156 
157 interface DSAuthority {
158     function canCall(
159         address src, address dst, bytes4 sig
160     ) external view returns (bool);
161 }
162 
163 abstract contract DSAuthEvents {
164     event LogSetAuthority (address indexed authority);
165     event LogSetOwner     (address indexed owner);
166 }
167 
168 contract DSAuth is DSAuthEvents {
169     DSAuthority  public  authority;
170     address      public  owner;
171 
172     constructor() public {
173         owner = msg.sender;
174         emit LogSetOwner(msg.sender);
175     }
176 
177     function setOwner(address owner_)
178         virtual
179         public
180         auth
181     {
182         owner = owner_;
183         emit LogSetOwner(owner);
184     }
185 
186     function setAuthority(DSAuthority authority_)
187         virtual
188         public
189         auth
190     {
191         authority = authority_;
192         emit LogSetAuthority(address(authority));
193     }
194 
195     modifier auth {
196         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
197         _;
198     }
199 
200     function isAuthorized(address src, bytes4 sig) virtual internal view returns (bool) {
201         if (src == address(this)) {
202             return true;
203         } else if (src == owner) {
204             return true;
205         } else if (authority == DSAuthority(0)) {
206             return false;
207         } else {
208             return authority.canCall(src, address(this), sig);
209         }
210     }
211 }
212 
213 ////// /nix/store/568a43l8z72c0fll5rnyz8gxz8d8j3y3-ds-stop/dapp/ds-stop/src/stop.sol
214 /// stop.sol -- mixin for enable/disable functionality
215 
216 // Copyright (C) 2017  DappHub, LLC
217 
218 // This program is free software: you can redistribute it and/or modify
219 // it under the terms of the GNU General Public License as published by
220 // the Free Software Foundation, either version 3 of the License, or
221 // (at your option) any later version.
222 
223 // This program is distributed in the hope that it will be useful,
224 // but WITHOUT ANY WARRANTY; without even the implied warranty of
225 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
226 // GNU General Public License for more details.
227 
228 // You should have received a copy of the GNU General Public License
229 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
230 
231 /* pragma solidity >=0.4.23; */
232 
233 /* import "ds-auth/auth.sol"; */
234 /* import "ds-note/note.sol"; */
235 
236 contract DSStop is DSNote, DSAuth {
237     bool public stopped;
238 
239     modifier stoppable {
240         require(!stopped, "ds-stop-is-stopped");
241         _;
242     }
243     function stop() public auth note {
244         stopped = true;
245     }
246     function start() public auth note {
247         stopped = false;
248     }
249 
250 }
251 
252 ////// /nix/store/wk93hb6yfayd5l2yjgw1zy2a5cnfvc8p-erc20/dapp/erc20/src/erc20.sol
253 /// erc20.sol -- API for the ERC20 token standard
254 
255 // See <https://github.com/ethereum/EIPs/issues/20>.
256 
257 // This file likely does not meet the threshold of originality
258 // required for copyright to apply.  As a result, this is free and
259 // unencumbered software belonging to the public domain.
260 
261 /* pragma solidity >0.4.20; */
262 
263 abstract contract ERC20Events {
264     event Approval(address indexed src, address indexed guy, uint wad);
265     event Transfer(address indexed src, address indexed dst, uint wad);
266 }
267 
268 abstract contract ERC20 is ERC20Events {
269     function totalSupply() virtual public view returns (uint);
270     function balanceOf(address guy) virtual public view returns (uint);
271     function allowance(address src, address guy) virtual public view returns (uint);
272 
273     function approve(address guy, uint wad) virtual public returns (bool);
274     function transfer(address dst, uint wad) virtual public returns (bool);
275     function transferFrom(
276         address src, address dst, uint wad
277     ) virtual public returns (bool);
278 }
279 
280 ////// /nix/store/nwn3cgggcciwhpp3b8nhns36sk2pgm19-ds-token/dapp/ds-token/src/base.sol
281 /// base.sol -- basic ERC20 implementation
282 
283 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
284 
285 // This program is free software: you can redistribute it and/or modify
286 // it under the terms of the GNU General Public License as published by
287 // the Free Software Foundation, either version 3 of the License, or
288 // (at your option) any later version.
289 
290 // This program is distributed in the hope that it will be useful,
291 // but WITHOUT ANY WARRANTY; without even the implied warranty of
292 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
293 // GNU General Public License for more details.
294 
295 // You should have received a copy of the GNU General Public License
296 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
297 
298 /* pragma solidity >=0.4.23; */
299 
300 /* import "erc20/erc20.sol"; */
301 /* import "ds-math/math.sol"; */
302 
303 contract DSTokenBase is ERC20, DSMath {
304     uint256                                            _supply;
305     mapping (address => uint256)                       _balances;
306     mapping (address => mapping (address => uint256))  _approvals;
307 
308     constructor(uint supply) public {
309         _balances[msg.sender] = supply;
310         _supply = supply;
311     }
312 
313     function totalSupply() override public view returns (uint) {
314         return _supply;
315     }
316     function balanceOf(address src) override public view returns (uint) {
317         return _balances[src];
318     }
319     function allowance(address src, address guy) override public view returns (uint) {
320         return _approvals[src][guy];
321     }
322 
323     function transfer(address dst, uint wad) override public returns (bool) {
324         return transferFrom(msg.sender, dst, wad);
325     }
326 
327     function transferFrom(address src, address dst, uint wad)
328         override
329         virtual
330         public
331         returns (bool)
332     {
333         if (src != msg.sender) {
334             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
335             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
336         }
337 
338         require(_balances[src] >= wad, "ds-token-insufficient-balance");
339         _balances[src] = sub(_balances[src], wad);
340         _balances[dst] = add(_balances[dst], wad);
341 
342         emit Transfer(src, dst, wad);
343 
344         return true;
345     }
346 
347     function approve(address guy, uint wad) virtual override public returns (bool) {
348         _approvals[msg.sender][guy] = wad;
349 
350         emit Approval(msg.sender, guy, wad);
351 
352         return true;
353     }
354 }
355 
356 ////// /nix/store/nwn3cgggcciwhpp3b8nhns36sk2pgm19-ds-token/dapp/ds-token/src/delegate.sol
357 /* pragma solidity >=0.5.13; */
358 
359 /* import "ds-stop/stop.sol"; */
360 /* import "./base.sol"; */
361 
362 contract DSDelegateToken is DSTokenBase(0), DSStop {
363     // --- Variables ---
364     // @notice The coin's symbol
365     string public symbol;
366     // @notice The coin's name
367     string public name;
368     /// @notice Standard token precision. Override to customize
369     uint256 public decimals = 18;
370     /// @notice A record of each accounts delegate
371     mapping (address => address) public delegates;
372     /// @notice A record of votes checkpoints for each account, by index
373     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
374     /// @notice The number of checkpoints for each account
375     mapping (address => uint32) public numCheckpoints;
376     /// @notice A record of states for signing / validating signatures
377     mapping (address => uint) public nonces;
378 
379     // --- Structs ---
380     /// @notice A checkpoint for marking number of votes from a given block
381     struct Checkpoint {
382         uint256 fromBlock;
383         uint256 votes;
384     }
385 
386     // --- Constants ---
387     /// @notice The EIP-712 typehash for the contract's domain
388     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
389     /// @notice The EIP-712 typehash for the delegation struct used by the contract
390     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
391 
392     // --- Events ---
393     /// @notice An event that's emitted when the contract mints tokens
394     event Mint(address indexed guy, uint wad);
395     /// @notice An event that's emitted when the contract burns tokens
396     event Burn(address indexed guy, uint wad);
397     /// @notice An event that's emitted when an account changes its delegate
398     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
399     /// @notice An event that's emitted when a delegate account's vote balance changes
400     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
401 
402     constructor(string memory name_, string memory symbol_) public {
403         name   = name_;
404         symbol = symbol_;
405     }
406 
407     // --- Functionality ---
408     /**
409      * @notice Approve an address to transfer all of your tokens
410      * @param guy The address to give approval to
411      */
412     function approve(address guy) public stoppable returns (bool) {
413         return super.approve(guy, uint(-1));
414     }
415     /**
416      * @notice Approve an address to transfer part of your tokens
417      * @param guy The address to give approval to
418      * @param wad The amount of tokens to approve
419      */
420     function approve(address guy, uint wad) override public stoppable returns (bool) {
421         return super.approve(guy, wad);
422     }
423 
424     /**
425      * @notice Transfer tokens from src to dst
426      * @param src The address to transfer tokens from
427      * @param dst The address to transfer tokens to
428      * @param wad The amount of tokens to transfer
429      */
430     function transferFrom(address src, address dst, uint wad)
431         override
432         public
433         stoppable
434         returns (bool)
435     {
436         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
437             require(_approvals[src][msg.sender] >= wad, "ds-delegate-token-insufficient-approval");
438             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
439         }
440 
441         require(_balances[src] >= wad, "ds-delegate-token-insufficient-balance");
442         _balances[src] = sub(_balances[src], wad);
443         _balances[dst] = add(_balances[dst], wad);
444 
445         emit Transfer(src, dst, wad);
446 
447         _moveDelegates(delegates[src], delegates[dst], wad);
448 
449         return true;
450     }
451     /**
452      * @notice Transfer tokens to dst
453      * @param dst The address to transfer tokens to
454      * @param wad The amount of tokens to transfer
455      */
456     function push(address dst, uint wad) public {
457         transferFrom(msg.sender, dst, wad);
458     }
459     /**
460      * @notice Transfer tokens from src to yourself
461      * @param src The address to transfer tokens frpom
462      * @param wad The amount of tokens to transfer
463      */
464     function pull(address src, uint wad) public {
465         transferFrom(src, msg.sender, wad);
466     }
467     /**
468      * @notice Transfer tokens between two addresses
469      * @param src The address to transfer tokens from
470      * @param dst The address to transfer tokens to
471      * @param wad The amount of tokens to transfer
472      */
473     function move(address src, address dst, uint wad) public {
474         transferFrom(src, dst, wad);
475     }
476 
477     /**
478      * @notice Mint tokens for yourself
479      * @param wad The amount of tokens to mint
480      */
481     function mint(uint wad) public {
482         mint(msg.sender, wad);
483     }
484     /**
485      * @notice Burn your own tokens
486      * @param wad The amount of tokens to burn
487      */
488     function burn(uint wad) public {
489         burn(msg.sender, wad);
490     }
491     /**
492      * @notice Mint tokens for guy
493      * @param guy The address to mint tokens for
494      * @param wad The amount of tokens to mint
495      */
496     function mint(address guy, uint wad) public auth stoppable {
497         _balances[guy] = add(_balances[guy], wad);
498         _supply = add(_supply, wad);
499         emit Mint(guy, wad);
500 
501         _moveDelegates(delegates[address(0)], delegates[guy], wad);
502     }
503     /**
504      * @notice Burn guy's tokens
505      * @param guy The address to burn tokens from
506      * @param wad The amount of tokens to burn
507      */
508     function burn(address guy, uint wad) public auth stoppable {
509         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
510             require(_approvals[guy][msg.sender] >= wad, "ds-delegate-token-insufficient-approval");
511             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
512         }
513 
514         require(_balances[guy] >= wad, "ds-delegate-token-insufficient-balance");
515         _balances[guy] = sub(_balances[guy], wad);
516         _supply = sub(_supply, wad);
517         emit Burn(guy, wad);
518 
519         _moveDelegates(delegates[guy], delegates[address(0)], wad);
520     }
521 
522     /**
523      * @notice Delegate votes from `msg.sender` to `delegatee`
524      * @param delegatee The address to delegate votes to
525      */
526     function delegate(address delegatee) public {
527         return _delegate(msg.sender, delegatee);
528     }
529     /**
530      * @notice Delegates votes from signatory to `delegatee`
531      * @param delegatee The address to delegate votes to
532      * @param nonce The contract state required to match the signature
533      * @param expiry The time at which to expire the signature
534      * @param v The recovery byte of the signature
535      * @param r Half of the ECDSA signature pair
536      * @param s Half of the ECDSA signature pair
537      */
538     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
539         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(abi.encodePacked(name)), getChainId(), address(this)));
540         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
541         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
542         address signatory = ecrecover(digest, v, r, s);
543         require(signatory != address(0), "ds-delegate-token-invalid-signature");
544         require(nonce == nonces[signatory]++, "ds-delegate-token-invalid-nonce");
545         require(now <= expiry, "ds-delegate-token-signature-expired");
546         return _delegate(signatory, delegatee);
547     }
548     /**
549      * @notice Internal function to delegate votes from `delegator` to `delegatee`
550      * @param delegator The address that delegates its votes
551      * @param delegatee The address to delegate votes to
552      */
553     function _delegate(address delegator, address delegatee) internal {
554         address currentDelegate = delegates[delegator];
555         delegates[delegator]    = delegatee;
556 
557         emit DelegateChanged(delegator, currentDelegate, delegatee);
558 
559         _moveDelegates(currentDelegate, delegatee, balanceOf(delegator));
560     }
561     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
562         if (srcRep != dstRep && amount > 0) {
563             if (srcRep != address(0)) {
564                 uint32 srcRepNum  = numCheckpoints[srcRep];
565                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
566                 uint256 srcRepNew = sub(srcRepOld, amount);
567                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
568             }
569 
570             if (dstRep != address(0)) {
571                 uint32 dstRepNum  = numCheckpoints[dstRep];
572                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
573                 uint256 dstRepNew = add(dstRepOld, amount);
574                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
575             }
576         }
577     }
578     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {
579         uint blockNumber = block.number;
580 
581         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
582             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
583         } else {
584             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
585             numCheckpoints[delegatee] = nCheckpoints + 1;
586         }
587 
588         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
589     }
590 
591     /**
592      * @notice Gets the current votes balance for `account`
593      * @param account The address to get votes balance
594      * @return The number of current votes for `account`
595      */
596     function getCurrentVotes(address account) external view returns (uint256) {
597         uint32 nCheckpoints = numCheckpoints[account];
598         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
599     }
600 
601     /**
602      * @notice Determine the prior number of votes for an account as of a block number
603      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
604      * @param account The address of the account to check
605      * @param blockNumber The block number to get the vote balance at
606      * @return The number of votes the account had as of the given block
607      */
608     function getPriorVotes(address account, uint blockNumber) public view returns (uint256) {
609         require(blockNumber < block.number, "ds-delegate-token-not-yet-determined");
610 
611         uint32 nCheckpoints = numCheckpoints[account];
612         if (nCheckpoints == 0) {
613             return 0;
614         }
615 
616         // First check most recent balance
617         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
618             return checkpoints[account][nCheckpoints - 1].votes;
619         }
620 
621         // Next check implicit zero balance
622         if (checkpoints[account][0].fromBlock > blockNumber) {
623             return 0;
624         }
625 
626         uint32 lower = 0;
627         uint32 upper = nCheckpoints - 1;
628         while (upper > lower) {
629             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
630             Checkpoint memory cp = checkpoints[account][center];
631             if (cp.fromBlock == blockNumber) {
632                 return cp.votes;
633             } else if (cp.fromBlock < blockNumber) {
634                 lower = center;
635             } else {
636                 upper = center - 1;
637             }
638         }
639         return checkpoints[account][lower].votes;
640     }
641 
642     /**
643     * @notice Fetch the chain ID
644     **/
645     function getChainId() internal pure returns (uint) {
646         uint256 chainId;
647         assembly { chainId := chainid() }
648         return chainId;
649     }
650 }
