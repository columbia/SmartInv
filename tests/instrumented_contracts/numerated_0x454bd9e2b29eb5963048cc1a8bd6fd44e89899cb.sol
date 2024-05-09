1 // SPDX-License-Identifier: MIXED
2 
3 // File @boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol@v1.2.1
4 // License-Identifier: MIT
5 pragma solidity 0.6.12;
6 
7 /// @notice A library for performing overflow-/underflow-safe math,
8 /// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).
9 library BoringMath {
10     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         require((c = a + b) >= b, "BoringMath: Add Overflow");
12     }
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         require((c = a - b) <= a, "BoringMath: Underflow");
16     }
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
20     }
21 
22     function to128(uint256 a) internal pure returns (uint128 c) {
23         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
24         c = uint128(a);
25     }
26 
27     function to64(uint256 a) internal pure returns (uint64 c) {
28         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
29         c = uint64(a);
30     }
31 
32     function to32(uint256 a) internal pure returns (uint32 c) {
33         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
34         c = uint32(a);
35     }
36 }
37 
38 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
39 library BoringMath128 {
40     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
41         require((c = a + b) >= b, "BoringMath: Add Overflow");
42     }
43 
44     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
45         require((c = a - b) <= a, "BoringMath: Underflow");
46     }
47 }
48 
49 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.
50 library BoringMath64 {
51     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
52         require((c = a + b) >= b, "BoringMath: Add Overflow");
53     }
54 
55     function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {
56         require((c = a - b) <= a, "BoringMath: Underflow");
57     }
58 }
59 
60 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
61 library BoringMath32 {
62     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
63         require((c = a + b) >= b, "BoringMath: Add Overflow");
64     }
65 
66     function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {
67         require((c = a - b) <= a, "BoringMath: Underflow");
68     }
69 }
70 
71 // File @boringcrypto/boring-solidity/contracts/Domain.sol@v1.2.1
72 // License-Identifier: MIT
73 // Based on code and smartness by Ross Campbell and Keno
74 // Uses immutable to store the domain separator to reduce gas usage
75 // If the chain id changes due to a fork, the forked chain will calculate on the fly.
76 pragma solidity 0.6.12;
77 
78 // solhint-disable no-inline-assembly
79 
80 contract Domain {
81     bytes32 private constant DOMAIN_SEPARATOR_SIGNATURE_HASH = keccak256("EIP712Domain(uint256 chainId,address verifyingContract)");
82     // See https://eips.ethereum.org/EIPS/eip-191
83     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
84 
85     // solhint-disable var-name-mixedcase
86     bytes32 private immutable _DOMAIN_SEPARATOR;
87     uint256 private immutable DOMAIN_SEPARATOR_CHAIN_ID;    
88 
89     /// @dev Calculate the DOMAIN_SEPARATOR
90     function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
91         return keccak256(
92             abi.encode(
93                 DOMAIN_SEPARATOR_SIGNATURE_HASH,
94                 chainId,
95                 address(this)
96             )
97         );
98     }
99 
100     constructor() public {
101         uint256 chainId; assembly {chainId := chainid()}
102         _DOMAIN_SEPARATOR = _calculateDomainSeparator(DOMAIN_SEPARATOR_CHAIN_ID = chainId);
103     }
104 
105     /// @dev Return the DOMAIN_SEPARATOR
106     // It's named internal to allow making it public from the contract that uses it by creating a simple view function
107     // with the desired public name, such as DOMAIN_SEPARATOR or domainSeparator.
108     // solhint-disable-next-line func-name-mixedcase
109     function _domainSeparator() internal view returns (bytes32) {
110         uint256 chainId; assembly {chainId := chainid()}
111         return chainId == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);
112     }
113 
114     function _getDigest(bytes32 dataHash) internal view returns (bytes32 digest) {
115         digest =
116             keccak256(
117                 abi.encodePacked(
118                     EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA,
119                     _domainSeparator(),
120                     dataHash
121                 )
122             );
123     }
124 }
125 
126 // File contracts/interfaces/IERC20.sol
127 //License-Identifier: MIT
128 pragma solidity ^0.6.12;
129 
130 interface IERC20 {
131     function totalSupply() external view returns (uint256);
132 
133     function balanceOf(address account) external view returns (uint256);
134 
135     function allowance(address owner, address spender)
136         external
137         view
138         returns (uint256);
139 
140     function approve(address spender, uint256 amount) external returns (bool);
141 
142     function transfer(address to, uint256 amount) external returns (bool);
143 
144     function transferFrom(
145         address from,
146         address to,
147         uint256 amount
148     ) external returns (bool);
149 
150     event Transfer(address indexed from, address indexed to, uint256 value);
151     event Approval(
152         address indexed owner,
153         address indexed spender,
154         uint256 value
155     );
156 
157     /// @notice EIP 2612
158     function permit(
159         address owner,
160         address spender,
161         uint256 value,
162         uint256 deadline,
163         uint8 v,
164         bytes32 r,
165         bytes32 s
166     ) external;
167 }
168 
169 // File contracts/DictatorDAO.sol
170 //License-Identifier: MIT
171 pragma solidity ^0.6.12;
172 pragma experimental ABIEncoderV2;
173 
174 
175 // DAO code/operator management/dutch auction, etc by BoringCrypto
176 // Staking in DictatorDAO inspired by Chef Nomi's SushiBar (heavily modified) - MIT license (originally WTFPL)
177 // TimeLock functionality Copyright 2020 Compound Labs, Inc. - BSD 3-Clause "New" or "Revised" License
178 contract DictatorDAO is IERC20, Domain {
179     using BoringMath for uint256;
180     using BoringMath128 for uint128;
181 
182     string public symbol;
183     string public name;
184     uint8 public constant decimals = 18;
185     uint256 public override totalSupply;
186 
187     IERC20 public immutable token;
188     address public operator;
189 
190     mapping(address => address) public userVote;
191     mapping(address => uint256) public votes;
192 
193     constructor(
194         string memory sharesSymbol,
195         string memory sharesName,
196         IERC20 token_,
197         address initialOperator
198     ) public {
199         symbol = sharesSymbol;
200         name = sharesName;
201         token = token_;
202         operator = initialOperator;
203     }
204 
205     struct User {
206         uint128 balance;
207         uint128 lockedUntil;
208     }
209 
210     /// @notice owner > balance mapping.
211     mapping(address => User) public users;
212     /// @notice owner > spender > allowance mapping.
213     mapping(address => mapping(address => uint256)) public override allowance;
214     /// @notice owner > nonce mapping. Used in `permit`.
215     mapping(address => uint256) public nonces;
216 
217     function balanceOf(address user)
218         public
219         view
220         override
221         returns (uint256 balance)
222     {
223         return users[user].balance;
224     }
225 
226     function _transfer(
227         address from,
228         address to,
229         uint256 shares
230     ) internal {
231         User memory fromUser = users[from];
232         require(block.timestamp >= fromUser.lockedUntil, "Locked");
233         if (shares != 0) {
234             require(fromUser.balance >= shares, "Low balance");
235             if (from != to) {
236                 require(to != address(0), "Zero address"); // Moved down so other failed calls save some gas
237                 User memory toUser = users[to];
238 
239                 address userVoteTo = userVote[to];
240                 address userVoteFrom = userVote[from];
241 
242                 users[from].balance = fromUser.balance - shares.to128(); // Underflow is checked
243                 users[to].balance = toUser.balance + shares.to128(); // Can't overflow because totalSupply would be greater than 2^256-1
244 
245                 // The "from" user's nominee started with at least that user's
246                 // votes, and votes correspond to 1:1 to balances. By the
247                 // "Low balance" check above this will not underflow.
248                 votes[userVoteFrom] -= shares;
249 
250                 // The "to" user's nominee started with at most `totalSupply`
251                 // votes. By the above, they have at least `shares` fewer now.
252                 // It follows that there can be no overflow.
253                 votes[userVoteTo] += shares;
254             }
255         }
256         emit Transfer(from, to, shares);
257     }
258 
259     function _useAllowance(address from, uint256 shares) internal {
260         if (msg.sender == from) {
261             return;
262         }
263         uint256 spenderAllowance = allowance[from][msg.sender];
264         // If allowance is infinite, don't decrease it to save on gas (breaks with EIP-20).
265         if (spenderAllowance != type(uint256).max) {
266             require(spenderAllowance >= shares, "Low allowance");
267             allowance[from][msg.sender] = spenderAllowance - shares; // Underflow is checked
268         }
269     }
270 
271     /// @notice Transfers `shares` tokens from `msg.sender` to `to`.
272     /// @param to The address to move the tokens.
273     /// @param shares of the tokens to move.
274     /// @return (bool) Returns True if succeeded.
275     function transfer(address to, uint256 shares)
276         external
277         override
278         returns (bool)
279     {
280         _transfer(msg.sender, to, shares);
281         return true;
282     }
283 
284     /// @notice Transfers `shares` tokens from `from` to `to`. Caller needs approval for `from`.
285     /// @param from Address to draw tokens from.
286     /// @param to The address to move the tokens.
287     /// @param shares The token shares to move.
288     /// @return (bool) Returns True if succeeded.
289     function transferFrom(
290         address from,
291         address to,
292         uint256 shares
293     ) external override returns (bool) {
294         _useAllowance(from, shares);
295         _transfer(from, to, shares);
296         return true;
297     }
298 
299     /// @notice Approves `amount` from sender to be spend by `spender`.
300     /// @param spender Address of the party that can draw from msg.sender's account.
301     /// @param amount The maximum collective amount that `spender` can draw.
302     /// @return (bool) Returns True if approved.
303     function approve(address spender, uint256 amount)
304         external
305         override
306         returns (bool)
307     {
308         allowance[msg.sender][spender] = amount;
309         emit Approval(msg.sender, spender, amount);
310         return true;
311     }
312 
313     // solhint-disable-next-line func-name-mixedcase
314     function DOMAIN_SEPARATOR() external view returns (bytes32) {
315         return _domainSeparator();
316     }
317 
318     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
319     bytes32 private constant PERMIT_SIGNATURE_HASH =
320         0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
321 
322     /// @notice Approves `value` from `owner_` to be spend by `spender`.
323     /// @param owner_ Address of the owner.
324     /// @param spender The address of the spender that gets approved to draw from `owner_`.
325     /// @param value The maximum collective amount that `spender` can draw.
326     /// @param deadline This permit must be redeemed before this deadline (UTC timestamp in seconds).
327     function permit(
328         address owner_,
329         address spender,
330         uint256 value,
331         uint256 deadline,
332         uint8 v,
333         bytes32 r,
334         bytes32 s
335     ) external override {
336         require(owner_ != address(0), "Zero owner");
337         require(block.timestamp < deadline, "Expired");
338         require(
339             ecrecover(
340                 _getDigest(
341                     keccak256(
342                         abi.encode(
343                             PERMIT_SIGNATURE_HASH,
344                             owner_,
345                             spender,
346                             value,
347                             nonces[owner_]++,
348                             deadline
349                         )
350                     )
351                 ),
352                 v,
353                 r,
354                 s
355             ) == owner_,
356             "Invalid Sig"
357         );
358         allowance[owner_][spender] = value;
359         emit Approval(owner_, spender, value);
360     }
361 
362     // Operator Setting
363     address public pendingOperator;
364     uint256 public pendingOperatorTime;
365 
366     // Condition for safe math: totalSupply < 2^255, so that the doubling fits.
367     // A sufficient condition is for this to hold for token.totalSupply.
368     function setOperator(address newOperator) public {
369         require(newOperator != address(0), "Zero operator");
370         uint256 netVotes = totalSupply - votes[address(0)];
371         if (newOperator != pendingOperator) {
372             require(votes[newOperator] * 2 > netVotes, "Not enough votes");
373             pendingOperator = newOperator;
374             pendingOperatorTime = block.timestamp + 7 days;
375         } else {
376             if (votes[newOperator] * 2 > netVotes) {
377                 require(block.timestamp >= pendingOperatorTime, "Wait longer");
378                 operator = pendingOperator;
379             }
380             // If there aren't enough votes, then the pending operator failed
381             // to maintain a majority. If there are, then they are now the
382             // operator. In either situation:
383             pendingOperator = address(0);
384             pendingOperatorTime = 0;
385         }
386     }
387 
388     /// math is ok, because amount, totalSupply and shares is always 0 <= amount <= 100.000.000 * 10^18
389     /// theoretically you can grow the amount/share ratio, but it's not practical and useless
390     function mint(uint256 amount, address operatorVote) public returns (bool) {
391         require(msg.sender != address(0), "Zero address");
392         User memory user = users[msg.sender];
393 
394         uint256 totalTokens = token.balanceOf(address(this));
395         uint256 shares =
396             totalSupply == 0 ? amount : (amount * totalSupply) / totalTokens;
397 
398         // Did we change our vote? Do this while we know our previous total:
399         address currentVote = userVote[msg.sender];
400         uint256 extraVotes = shares;
401         if (currentVote != operatorVote) {
402             if (user.balance > 0) {
403                 // Safe, because the user must have added their balance before
404                 votes[currentVote] -= user.balance;
405                 extraVotes += user.balance;
406             }
407             userVote[msg.sender] = operatorVote;
408         }
409         votes[operatorVote] += extraVotes;
410 
411         user.balance += shares.to128();
412         user.lockedUntil = (block.timestamp + 24 hours).to128();
413         users[msg.sender] = user;
414         totalSupply += shares;
415 
416         token.transferFrom(msg.sender, address(this), amount);
417 
418         emit Transfer(address(0), msg.sender, shares);
419         return true;
420     }
421 
422     // Change your vote. Does not lock tokens.
423     function vote(address operatorVote) public returns (bool) {
424         address currentVote = userVote[msg.sender];
425         if (currentVote != operatorVote) {
426             User memory user = users[msg.sender];
427             if (user.balance > 0) {
428                 votes[currentVote] -= user.balance;
429                 votes[operatorVote] += user.balance;
430             }
431             userVote[msg.sender] = operatorVote;
432         }
433         return true;
434     }
435 
436     function _burn(
437         address from,
438         address to,
439         uint256 shares
440     ) internal {
441         require(to != address(0), "Zero address");
442         User memory user = users[from];
443         require(block.timestamp >= user.lockedUntil, "Locked");
444         uint256 amount =
445             (shares * token.balanceOf(address(this))) / totalSupply;
446         users[from].balance = user.balance.sub(shares.to128()); // Must check underflow
447         totalSupply -= shares;
448         votes[userVote[from]] -= shares;
449 
450         token.transfer(to, amount);
451 
452         emit Transfer(from, address(0), shares);
453     }
454 
455     function burn(address to, uint256 shares) public returns (bool) {
456         _burn(msg.sender, to, shares);
457         return true;
458     }
459 
460     function burnFrom(
461         address from,
462         address to,
463         uint256 shares
464     ) public returns (bool) {
465         _useAllowance(from, shares);
466         _burn(from, to, shares);
467         return true;
468     }
469 
470     event QueueTransaction(
471         bytes32 indexed txHash,
472         address indexed target,
473         uint256 value,
474         bytes data,
475         uint256 eta
476     );
477     event CancelTransaction(
478         bytes32 indexed txHash,
479         address indexed target,
480         uint256 value,
481         bytes data
482     );
483     event ExecuteTransaction(
484         bytes32 indexed txHash,
485         address indexed target,
486         uint256 value,
487         bytes data
488     );
489 
490     uint256 public constant GRACE_PERIOD = 14 days;
491     uint256 public constant DELAY = 2 days;
492     mapping(bytes32 => uint256) public queuedTransactions;
493 
494     function queueTransaction(
495         address target,
496         uint256 value,
497         bytes memory data
498     ) public returns (bytes32) {
499         require(msg.sender == operator, "Operator only");
500         require(votes[operator] * 2 > totalSupply, "Not enough votes");
501 
502         bytes32 txHash = keccak256(abi.encode(target, value, data));
503         uint256 eta = block.timestamp + DELAY;
504         queuedTransactions[txHash] = eta;
505 
506         emit QueueTransaction(txHash, target, value, data, eta);
507         return txHash;
508     }
509 
510     function cancelTransaction(
511         address target,
512         uint256 value,
513         bytes memory data
514     ) public {
515         require(msg.sender == operator, "Operator only");
516 
517         bytes32 txHash = keccak256(abi.encode(target, value, data));
518         queuedTransactions[txHash] = 0;
519 
520         emit CancelTransaction(txHash, target, value, data);
521     }
522 
523     function executeTransaction(
524         address target,
525         uint256 value,
526         bytes memory data
527     ) public payable returns (bytes memory) {
528         require(msg.sender == operator, "Operator only");
529         require(votes[operator] * 2 > totalSupply, "Not enough votes");
530 
531         bytes32 txHash = keccak256(abi.encode(target, value, data));
532         uint256 eta = queuedTransactions[txHash];
533         require(block.timestamp >= eta, "Too early");
534         require(block.timestamp <= eta + GRACE_PERIOD, "Tx stale");
535 
536         queuedTransactions[txHash] = 0;
537 
538         // solium-disable-next-line security/no-call-value
539         (bool success, bytes memory returnData) =
540             target.call{value: value}(data);
541         require(success, "Tx reverted :(");
542 
543         emit ExecuteTransaction(txHash, target, value, data);
544 
545         return returnData;
546     }
547 }