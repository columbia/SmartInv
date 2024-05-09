1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-02
3 */
4 
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
18 pragma solidity >=0.6.7;
19 
20 contract DSNote {
21     event LogNote(
22         bytes4   indexed  sig,
23         address  indexed  guy,
24         bytes32  indexed  foo,
25         bytes32  indexed  bar,
26         uint256           wad,
27         bytes             fax
28     ) anonymous;
29 
30     modifier note {
31         bytes32 foo;
32         bytes32 bar;
33         uint256 wad;
34 
35         assembly {
36             foo := calldataload(4)
37             bar := calldataload(36)
38             wad := callvalue()
39         }
40 
41         _;
42 
43         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
44     }
45 }
46 
47 interface DSAuthority {
48     function canCall(
49         address src, address dst, bytes4 sig
50     ) external view returns (bool);
51 }
52 
53 abstract contract DSAuthEvents {
54     event LogSetAuthority (address indexed authority);
55     event LogSetOwner     (address indexed owner);
56 }
57 
58 contract DSAuth is DSAuthEvents {
59     DSAuthority  public  authority;
60     address      public  owner;
61 
62     constructor() public {
63         owner = msg.sender;
64         emit LogSetOwner(msg.sender);
65     }
66 
67     function setOwner(address owner_)
68         virtual
69         public
70         auth
71     {
72         owner = owner_;
73         emit LogSetOwner(owner);
74     }
75 
76     function setAuthority(DSAuthority authority_)
77         virtual
78         public
79         auth
80     {
81         authority = authority_;
82         emit LogSetAuthority(address(authority));
83     }
84 
85     modifier auth {
86         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
87         _;
88     }
89 
90     function isAuthorized(address src, bytes4 sig) virtual internal view returns (bool) {
91         if (src == address(this)) {
92             return true;
93         } else if (src == owner) {
94             return true;
95         } else if (authority == DSAuthority(0)) {
96             return false;
97         } else {
98             return authority.canCall(src, address(this), sig);
99         }
100     }
101 }
102 
103 contract DSStop is DSNote, DSAuth {
104     bool public stopped;
105 
106     modifier stoppable {
107         require(!stopped, "ds-stop-is-stopped");
108         _;
109     }
110     function stop() public auth note {
111         stopped = true;
112     }
113     function start() public auth note {
114         stopped = false;
115     }
116 
117 }
118 
119 contract DSMath {
120     function add(uint x, uint y) internal pure returns (uint z) {
121         require((z = x + y) >= x, "ds-math-add-overflow");
122     }
123     function sub(uint x, uint y) internal pure returns (uint z) {
124         require((z = x - y) <= x, "ds-math-sub-underflow");
125     }
126     function mul(uint x, uint y) internal pure returns (uint z) {
127         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
128     }
129 
130     function min(uint x, uint y) internal pure returns (uint z) {
131         return x <= y ? x : y;
132     }
133     function max(uint x, uint y) internal pure returns (uint z) {
134         return x >= y ? x : y;
135     }
136     function imin(int x, int y) internal pure returns (int z) {
137         return x <= y ? x : y;
138     }
139     function imax(int x, int y) internal pure returns (int z) {
140         return x >= y ? x : y;
141     }
142 
143     uint constant WAD = 10 ** 18;
144     uint constant RAY = 10 ** 27;
145 
146     //rounds to zero if x*y < WAD / 2
147     function wmul(uint x, uint y) internal pure returns (uint z) {
148         z = add(mul(x, y), WAD / 2) / WAD;
149     }
150     //rounds to zero if x*y < WAD / 2
151     function rmul(uint x, uint y) internal pure returns (uint z) {
152         z = add(mul(x, y), RAY / 2) / RAY;
153     }
154     //rounds to zero if x*y < WAD / 2
155     function wdiv(uint x, uint y) internal pure returns (uint z) {
156         z = add(mul(x, WAD), y / 2) / y;
157     }
158     //rounds to zero if x*y < RAY / 2
159     function rdiv(uint x, uint y) internal pure returns (uint z) {
160         z = add(mul(x, RAY), y / 2) / y;
161     }
162 
163     // This famous algorithm is called "exponentiation by squaring"
164     // and calculates x^n with x as fixed-point and n as regular unsigned.
165     //
166     // It's O(log n), instead of O(n) for naive repeated multiplication.
167     //
168     // These facts are why it works:
169     //
170     //  If n is even, then x^n = (x^2)^(n/2).
171     //  If n is odd,  then x^n = x * x^(n-1),
172     //   and applying the equation for even x gives
173     //    x^n = x * (x^2)^((n-1) / 2).
174     //
175     //  Also, EVM division is flooring and
176     //    floor[(n-1) / 2] = floor[n / 2].
177     //
178     function rpow(uint x, uint n) internal pure returns (uint z) {
179         z = n % 2 != 0 ? x : RAY;
180 
181         for (n /= 2; n != 0; n /= 2) {
182             x = rmul(x, x);
183 
184             if (n % 2 != 0) {
185                 z = rmul(z, x);
186             }
187         }
188     }
189 }
190 
191 abstract contract ERC20Events {
192     event Approval(address indexed src, address indexed guy, uint wad);
193     event Transfer(address indexed src, address indexed dst, uint wad);
194 }
195 
196 abstract contract ERC20 is ERC20Events {
197     function totalSupply() virtual public view returns (uint);
198     function balanceOf(address guy) virtual public view returns (uint);
199     function allowance(address src, address guy) virtual public view returns (uint);
200 
201     function approve(address guy, uint wad) virtual public returns (bool);
202     function transfer(address dst, uint wad) virtual public returns (bool);
203     function transferFrom(
204         address src, address dst, uint wad
205     ) virtual public returns (bool);
206 }
207 
208 contract DSTokenBase is ERC20, DSMath {
209     uint256                                            _supply;
210     mapping (address => uint256)                       _balances;
211     mapping (address => mapping (address => uint256))  _approvals;
212 
213     constructor(uint supply) public {
214         _balances[msg.sender] = supply;
215         _supply = supply;
216     }
217 
218     function totalSupply() override public view returns (uint) {
219         return _supply;
220     }
221     function balanceOf(address src) override public view returns (uint) {
222         return _balances[src];
223     }
224     function allowance(address src, address guy) override public view returns (uint) {
225         return _approvals[src][guy];
226     }
227 
228     function transfer(address dst, uint wad) override public returns (bool) {
229         return transferFrom(msg.sender, dst, wad);
230     }
231 
232     function transferFrom(address src, address dst, uint wad)
233         override
234         virtual
235         public
236         returns (bool)
237     {
238         if (src != msg.sender) {
239             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
240             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
241         }
242 
243         require(_balances[src] >= wad, "ds-token-insufficient-balance");
244         _balances[src] = sub(_balances[src], wad);
245         _balances[dst] = add(_balances[dst], wad);
246 
247         emit Transfer(src, dst, wad);
248 
249         return true;
250     }
251 
252     function approve(address guy, uint wad) virtual override public returns (bool) {
253         _approvals[msg.sender][guy] = wad;
254 
255         emit Approval(msg.sender, guy, wad);
256 
257         return true;
258     }
259 }
260 
261 contract DSDelegateToken is DSTokenBase(0), DSStop {
262     // --- Variables ---
263     // @notice The coin's symbol
264     string public symbol;
265     // @notice The coin's name
266     string public name;
267     /// @notice Standard token precision. Override to customize
268     uint256 public decimals = 18;
269     /// @notice A record of each accounts delegate
270     mapping (address => address) public delegates;
271     /// @notice A record of votes checkpoints for each account, by index
272     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
273     /// @notice The number of checkpoints for each account
274     mapping (address => uint32) public numCheckpoints;
275     /// @notice A record of states for signing / validating signatures
276     mapping (address => uint) public nonces;
277 
278     // --- Structs ---
279     /// @notice A checkpoint for marking number of votes from a given block
280     struct Checkpoint {
281         uint256 fromBlock;
282         uint256 votes;
283     }
284 
285     // --- Constants ---
286     /// @notice The EIP-712 typehash for the contract's domain
287     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
288     /// @notice The EIP-712 typehash for the delegation struct used by the contract
289     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
290 
291     // --- Events ---
292     /// @notice An event that's emitted when the contract mints tokens
293     event Mint(address indexed guy, uint wad);
294     /// @notice An event that's emitted when the contract burns tokens
295     event Burn(address indexed guy, uint wad);
296     /// @notice An event that's emitted when an account changes its delegate
297     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
298     /// @notice An event that's emitted when a delegate account's vote balance changes
299     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
300 
301     constructor(string memory name_, string memory symbol_) public {
302         name   = name_;
303         symbol = symbol_;
304     }
305 
306     // --- Functionality ---
307     /**
308      * @notice Approve an address to transfer all of your tokens
309      * @param guy The address to give approval to
310      */
311     function approve(address guy) public stoppable returns (bool) {
312         return super.approve(guy, uint(-1));
313     }
314     /**
315      * @notice Approve an address to transfer part of your tokens
316      * @param guy The address to give approval to
317      * @param wad The amount of tokens to approve
318      */
319     function approve(address guy, uint wad) override public stoppable returns (bool) {
320         return super.approve(guy, wad);
321     }
322 
323     /**
324      * @notice Transfer tokens from src to dst
325      * @param src The address to transfer tokens from
326      * @param dst The address to transfer tokens to
327      * @param wad The amount of tokens to transfer
328      */
329     function transferFrom(address src, address dst, uint wad)
330         override
331         public
332         stoppable
333         returns (bool)
334     {
335         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
336             require(_approvals[src][msg.sender] >= wad, "ds-delegate-token-insufficient-approval");
337             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
338         }
339 
340         require(_balances[src] >= wad, "ds-delegate-token-insufficient-balance");
341         _balances[src] = sub(_balances[src], wad);
342         _balances[dst] = add(_balances[dst], wad);
343 
344         emit Transfer(src, dst, wad);
345 
346         _moveDelegates(delegates[src], delegates[dst], wad);
347 
348         return true;
349     }
350     /**
351      * @notice Transfer tokens to dst
352      * @param dst The address to transfer tokens to
353      * @param wad The amount of tokens to transfer
354      */
355     function push(address dst, uint wad) public {
356         transferFrom(msg.sender, dst, wad);
357     }
358     /**
359      * @notice Transfer tokens from src to yourself
360      * @param src The address to transfer tokens frpom
361      * @param wad The amount of tokens to transfer
362      */
363     function pull(address src, uint wad) public {
364         transferFrom(src, msg.sender, wad);
365     }
366     /**
367      * @notice Transfer tokens between two addresses
368      * @param src The address to transfer tokens from
369      * @param dst The address to transfer tokens to
370      * @param wad The amount of tokens to transfer
371      */
372     function move(address src, address dst, uint wad) public {
373         transferFrom(src, dst, wad);
374     }
375 
376     /**
377      * @notice Mint tokens for yourself
378      * @param wad The amount of tokens to mint
379      */
380     function mint(uint wad) public {
381         mint(msg.sender, wad);
382     }
383     /**
384      * @notice Burn your own tokens
385      * @param wad The amount of tokens to burn
386      */
387     function burn(uint wad) public {
388         burn(msg.sender, wad);
389     }
390     /**
391      * @notice Mint tokens for guy
392      * @param guy The address to mint tokens for
393      * @param wad The amount of tokens to mint
394      */
395     function mint(address guy, uint wad) public auth stoppable {
396         _balances[guy] = add(_balances[guy], wad);
397         _supply = add(_supply, wad);
398         emit Mint(guy, wad);
399 
400         _moveDelegates(delegates[address(0)], delegates[guy], wad);
401     }
402     /**
403      * @notice Burn guy's tokens
404      * @param guy The address to burn tokens from
405      * @param wad The amount of tokens to burn
406      */
407     function burn(address guy, uint wad) public auth stoppable {
408         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
409             require(_approvals[guy][msg.sender] >= wad, "ds-delegate-token-insufficient-approval");
410             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
411         }
412 
413         require(_balances[guy] >= wad, "ds-delegate-token-insufficient-balance");
414         _balances[guy] = sub(_balances[guy], wad);
415         _supply = sub(_supply, wad);
416         emit Burn(guy, wad);
417 
418         _moveDelegates(delegates[guy], delegates[address(0)], wad);
419     }
420 
421     /**
422      * @notice Delegate votes from `msg.sender` to `delegatee`
423      * @param delegatee The address to delegate votes to
424      */
425     function delegate(address delegatee) public {
426         return _delegate(msg.sender, delegatee);
427     }
428     /**
429      * @notice Delegates votes from signatory to `delegatee`
430      * @param delegatee The address to delegate votes to
431      * @param nonce The contract state required to match the signature
432      * @param expiry The time at which to expire the signature
433      * @param v The recovery byte of the signature
434      * @param r Half of the ECDSA signature pair
435      * @param s Half of the ECDSA signature pair
436      */
437     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
438         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(abi.encodePacked(name)), getChainId(), address(this)));
439         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
440         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
441         address signatory = ecrecover(digest, v, r, s);
442         require(signatory != address(0), "ds-delegate-token-invalid-signature");
443         require(nonce == nonces[signatory]++, "ds-delegate-token-invalid-nonce");
444         require(now <= expiry, "ds-delegate-token-signature-expired");
445         return _delegate(signatory, delegatee);
446     }
447     /**
448      * @notice Internal function to delegate votes from `delegator` to `delegatee`
449      * @param delegator The address that delegates its votes
450      * @param delegatee The address to delegate votes to
451      */
452     function _delegate(address delegator, address delegatee) internal {
453         address currentDelegate = delegates[delegator];
454         delegates[delegator]    = delegatee;
455 
456         emit DelegateChanged(delegator, currentDelegate, delegatee);
457 
458         _moveDelegates(currentDelegate, delegatee, balanceOf(delegator));
459     }
460     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
461         if (srcRep != dstRep && amount > 0) {
462             if (srcRep != address(0)) {
463                 uint32 srcRepNum  = numCheckpoints[srcRep];
464                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
465                 uint256 srcRepNew = sub(srcRepOld, amount);
466                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
467             }
468 
469             if (dstRep != address(0)) {
470                 uint32 dstRepNum  = numCheckpoints[dstRep];
471                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
472                 uint256 dstRepNew = add(dstRepOld, amount);
473                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
474             }
475         }
476     }
477     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {
478         uint blockNumber = block.number;
479 
480         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
481             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
482         } else {
483             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
484             numCheckpoints[delegatee] = nCheckpoints + 1;
485         }
486 
487         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
488     }
489 
490     /**
491      * @notice Gets the current votes balance for `account`
492      * @param account The address to get votes balance
493      * @return The number of current votes for `account`
494      */
495     function getCurrentVotes(address account) external view returns (uint256) {
496         uint32 nCheckpoints = numCheckpoints[account];
497         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
498     }
499 
500     /**
501      * @notice Determine the prior number of votes for an account as of a block number
502      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
503      * @param account The address of the account to check
504      * @param blockNumber The block number to get the vote balance at
505      * @return The number of votes the account had as of the given block
506      */
507     function getPriorVotes(address account, uint blockNumber) public view returns (uint256) {
508         require(blockNumber < block.number, "ds-delegate-token-not-yet-determined");
509 
510         uint32 nCheckpoints = numCheckpoints[account];
511         if (nCheckpoints == 0) {
512             return 0;
513         }
514 
515         // First check most recent balance
516         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
517             return checkpoints[account][nCheckpoints - 1].votes;
518         }
519 
520         // Next check implicit zero balance
521         if (checkpoints[account][0].fromBlock > blockNumber) {
522             return 0;
523         }
524 
525         uint32 lower = 0;
526         uint32 upper = nCheckpoints - 1;
527         while (upper > lower) {
528             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
529             Checkpoint memory cp = checkpoints[account][center];
530             if (cp.fromBlock == blockNumber) {
531                 return cp.votes;
532             } else if (cp.fromBlock < blockNumber) {
533                 lower = center;
534             } else {
535                 upper = center - 1;
536             }
537         }
538         return checkpoints[account][lower].votes;
539     }
540 
541     /**
542     * @notice Fetch the chain ID
543     **/
544     function getChainId() internal pure returns (uint) {
545         uint256 chainId;
546         assembly { chainId := chainid() }
547         return chainId;
548     }
549 }