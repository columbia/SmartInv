1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6 // ----------------------------------------------------------------------------
7 contract ERC20Interface {
8     function totalSupply() public constant returns (uint);
9     function balanceOf(address tokenOwner) public constant returns (uint balance);
10     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 
20 // ----------------------------------------------------------------------------
21 // Contracts that can have tokens approved, and then a function execute
22 // ----------------------------------------------------------------------------
23 contract ApproveAndCallFallBack {
24     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
25 }
26 
27 
28 // ----------------------------------------------------------------------------
29 // BokkyPooBah's Token Teleportation Service Interface v1.00
30 //
31 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
32 // ----------------------------------------------------------------------------
33 contract BTTSTokenInterface is ERC20Interface {
34     uint public constant bttsVersion = 100;
35 
36     bytes public constant signingPrefix = "\x19Ethereum Signed Message:\n32";
37     bytes4 public constant signedTransferSig = "\x75\x32\xea\xac";
38     bytes4 public constant signedApproveSig = "\xe9\xaf\xa7\xa1";
39     bytes4 public constant signedTransferFromSig = "\x34\x4b\xcc\x7d";
40     bytes4 public constant signedApproveAndCallSig = "\xf1\x6f\x9b\x53";
41 
42     event OwnershipTransferred(address indexed from, address indexed to);
43     event MinterUpdated(address from, address to);
44     event Mint(address indexed tokenOwner, uint tokens, bool lockAccount);
45     event MintingDisabled();
46     event TransfersEnabled();
47     event AccountUnlocked(address indexed tokenOwner);
48 
49     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success);
50 
51     // ------------------------------------------------------------------------
52     // signed{X} functions
53     // ------------------------------------------------------------------------
54     function signedTransferHash(address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
55     function signedTransferCheck(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
56     function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
57 
58     function signedApproveHash(address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
59     function signedApproveCheck(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
60     function signedApprove(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
61 
62     function signedTransferFromHash(address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
63     function signedTransferFromCheck(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
64     function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
65 
66     function signedApproveAndCallHash(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce) public view returns (bytes32 hash);
67     function signedApproveAndCallCheck(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
68     function signedApproveAndCall(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
69 
70     function mint(address tokenOwner, uint tokens, bool lockAccount) public returns (bool success);
71     function unlockAccount(address tokenOwner) public;
72     function disableMinting() public;
73     function enableTransfers() public;
74 
75     // ------------------------------------------------------------------------
76     // signed{X}Check return status
77     // ------------------------------------------------------------------------
78     enum CheckResult {
79         Success,                           // 0 Success
80         NotTransferable,                   // 1 Tokens not transferable yet
81         AccountLocked,                     // 2 Account locked
82         SignerMismatch,                    // 3 Mismatch in signing account
83         AlreadyExecuted,                   // 4 Transfer already executed
84         InsufficientApprovedTokens,        // 5 Insufficient approved tokens
85         InsufficientApprovedTokensForFees, // 6 Insufficient approved tokens for fees
86         InsufficientTokens,                // 7 Insufficient tokens
87         InsufficientTokensForFees,         // 8 Insufficient tokens for fees
88         OverflowError                      // 9 Overflow error
89     }
90 }
91 
92 
93 // ----------------------------------------------------------------------------
94 // BokkyPooBah's Token Teleportation Service Library v1.00
95 //
96 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
97 // ----------------------------------------------------------------------------
98 library BTTSLib {
99     struct Data {
100         // Ownership
101         address owner;
102         address newOwner;
103 
104         // Minting and management
105         address minter;
106         bool mintable;
107         bool transferable;
108         mapping(address => bool) accountLocked;
109 
110         // Token
111         string symbol;
112         string name;
113         uint8 decimals;
114         uint totalSupply;
115         mapping(address => uint) balances;
116         mapping(address => mapping(address => uint)) allowed;
117         mapping(address => mapping(bytes32 => bool)) executed;
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // Constants
123     // ------------------------------------------------------------------------
124     uint public constant bttsVersion = 100;
125     bytes public constant signingPrefix = "\x19Ethereum Signed Message:\n32";
126     bytes4 public constant signedTransferSig = "\x75\x32\xea\xac";
127     bytes4 public constant signedApproveSig = "\xe9\xaf\xa7\xa1";
128     bytes4 public constant signedTransferFromSig = "\x34\x4b\xcc\x7d";
129     bytes4 public constant signedApproveAndCallSig = "\xf1\x6f\x9b\x53";
130 
131     // ------------------------------------------------------------------------
132     // Event
133     // ------------------------------------------------------------------------
134     event OwnershipTransferred(address indexed from, address indexed to);
135     event MinterUpdated(address from, address to);
136     event Mint(address indexed tokenOwner, uint tokens, bool lockAccount);
137     event MintingDisabled();
138     event TransfersEnabled();
139     event AccountUnlocked(address indexed tokenOwner);
140     event Transfer(address indexed from, address indexed to, uint tokens);
141     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
142 
143 
144     // ------------------------------------------------------------------------
145     // Initialisation
146     // ------------------------------------------------------------------------
147     function init(Data storage self, address owner, string symbol, string name, uint8 decimals, uint initialSupply, bool mintable, bool transferable) public {
148         require(self.owner == address(0));
149         self.owner = owner;
150         self.symbol = symbol;
151         self.name = name;
152         self.decimals = decimals;
153         if (initialSupply > 0) {
154             self.balances[owner] = initialSupply;
155             self.totalSupply = initialSupply;
156             Mint(self.owner, initialSupply, false);
157             Transfer(address(0), self.owner, initialSupply);
158         }
159         self.mintable = mintable;
160         self.transferable = transferable;
161     }
162 
163     // ------------------------------------------------------------------------
164     // Safe maths
165     // ------------------------------------------------------------------------
166     function safeAdd(uint a, uint b) internal pure returns (uint c) {
167         c = a + b;
168         require(c >= a);
169     }
170     function safeSub(uint a, uint b) internal pure returns (uint c) {
171         require(b <= a);
172         c = a - b;
173     }
174     function safeMul(uint a, uint b) internal pure returns (uint c) {
175         c = a * b;
176         require(a == 0 || c / a == b);
177     }
178     function safeDiv(uint a, uint b) internal pure returns (uint c) {
179         require(b > 0);
180         c = a / b;
181     }
182 
183     // ------------------------------------------------------------------------
184     // Ownership
185     // ------------------------------------------------------------------------
186     function transferOwnership(Data storage self, address newOwner) public {
187         require(msg.sender == self.owner);
188         self.newOwner = newOwner;
189     }
190     function acceptOwnership(Data storage self) public {
191         require(msg.sender == self.newOwner);
192         OwnershipTransferred(self.owner, self.newOwner);
193         self.owner = self.newOwner;
194         self.newOwner = address(0);
195     }
196     function transferOwnershipImmediately(Data storage self, address newOwner) public {
197         require(msg.sender == self.owner);
198         OwnershipTransferred(self.owner, newOwner);
199         self.owner = newOwner;
200         self.newOwner = address(0);
201     }
202 
203     // ------------------------------------------------------------------------
204     // Minting and management
205     // ------------------------------------------------------------------------
206     function setMinter(Data storage self, address minter) public {
207         require(msg.sender == self.owner);
208         require(self.mintable);
209         MinterUpdated(self.minter, minter);
210         self.minter = minter;
211     }
212     function mint(Data storage self, address tokenOwner, uint tokens, bool lockAccount) public returns (bool success) {
213         require(self.mintable);
214         require(msg.sender == self.minter || msg.sender == self.owner);
215         if (lockAccount) {
216             self.accountLocked[tokenOwner] = true;
217         }
218         self.balances[tokenOwner] = safeAdd(self.balances[tokenOwner], tokens);
219         self.totalSupply = safeAdd(self.totalSupply, tokens);
220         Mint(tokenOwner, tokens, lockAccount);
221         Transfer(address(0), tokenOwner, tokens);
222         return true;
223     }
224     function unlockAccount(Data storage self, address tokenOwner) public {
225         require(msg.sender == self.owner);
226         require(self.accountLocked[tokenOwner]);
227         self.accountLocked[tokenOwner] = false;
228         AccountUnlocked(tokenOwner);
229     }
230     function disableMinting(Data storage self) public {
231         require(self.mintable);
232         require(msg.sender == self.minter || msg.sender == self.owner);
233         self.mintable = false;
234         if (self.minter != address(0)) {
235             MinterUpdated(self.minter, address(0));
236             self.minter = address(0);
237         }
238         MintingDisabled();
239     }
240     function enableTransfers(Data storage self) public {
241         require(msg.sender == self.owner);
242         require(!self.transferable);
243         self.transferable = true;
244         TransfersEnabled();
245     }
246 
247     // ------------------------------------------------------------------------
248     // Other functions
249     // ------------------------------------------------------------------------
250     function transferAnyERC20Token(Data storage self, address tokenAddress, uint tokens) public returns (bool success) {
251         require(msg.sender == self.owner);
252         return ERC20Interface(tokenAddress).transfer(self.owner, tokens);
253     }
254 
255     // ------------------------------------------------------------------------
256     // ecrecover from a signature rather than the signature in parts [v, r, s]
257     // The signature format is a compact form {bytes32 r}{bytes32 s}{uint8 v}.
258     // Compact means, uint8 is not padded to 32 bytes.
259     //
260     // An invalid signature results in the address(0) being returned, make
261     // sure that the returned result is checked to be non-zero for validity
262     //
263     // Parts from https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
264     // ------------------------------------------------------------------------
265     function ecrecoverFromSig(Data storage /*self*/, bytes32 hash, bytes sig) public pure returns (address recoveredAddress) {
266         bytes32 r;
267         bytes32 s;
268         uint8 v;
269         if (sig.length != 65) return address(0);
270         assembly {
271             r := mload(add(sig, 32))
272             s := mload(add(sig, 64))
273             // Here we are loading the last 32 bytes. We exploit the fact that 'mload' will pad with zeroes if we overread.
274             // There is no 'mload8' to do this, but that would be nicer.
275             v := byte(0, mload(add(sig, 96)))
276         }
277         // Albeit non-transactional signatures are not specified by the YP, one would expect it to match the YP range of [27, 28]
278         // geth uses [0, 1] and some clients have followed. This might change, see https://github.com/ethereum/go-ethereum/issues/2053
279         if (v < 27) {
280           v += 27;
281         }
282         if (v != 27 && v != 28) return address(0);
283         return ecrecover(hash, v, r, s);
284     }
285 
286     // ------------------------------------------------------------------------
287     // Get CheckResult message
288     // ------------------------------------------------------------------------
289     function getCheckResultMessage(Data storage /*self*/, BTTSTokenInterface.CheckResult result) public pure returns (string) {
290         if (result == BTTSTokenInterface.CheckResult.Success) {
291             return "Success";
292         } else if (result == BTTSTokenInterface.CheckResult.NotTransferable) {
293             return "Tokens not transferable yet";
294         } else if (result == BTTSTokenInterface.CheckResult.AccountLocked) {
295             return "Account locked";
296         } else if (result == BTTSTokenInterface.CheckResult.SignerMismatch) {
297             return "Mismatch in signing account";
298         } else if (result == BTTSTokenInterface.CheckResult.AlreadyExecuted) {
299             return "Transfer already executed";
300         } else if (result == BTTSTokenInterface.CheckResult.InsufficientApprovedTokens) {
301             return "Insufficient approved tokens";
302         } else if (result == BTTSTokenInterface.CheckResult.InsufficientApprovedTokensForFees) {
303             return "Insufficient approved tokens for fees";
304         } else if (result == BTTSTokenInterface.CheckResult.InsufficientTokens) {
305             return "Insufficient tokens";
306         } else if (result == BTTSTokenInterface.CheckResult.InsufficientTokensForFees) {
307             return "Insufficient tokens for fees";
308         } else if (result == BTTSTokenInterface.CheckResult.OverflowError) {
309             return "Overflow error";
310         } else {
311             return "Unknown error";
312         }
313     }
314 
315     // ------------------------------------------------------------------------
316     // Token functions
317     // ------------------------------------------------------------------------
318     function transfer(Data storage self, address to, uint tokens) public returns (bool success) {
319         // Owner and minter can move tokens before the tokens are transferable 
320         require(self.transferable || (self.mintable && (msg.sender == self.owner  || msg.sender == self.minter)));
321         require(!self.accountLocked[msg.sender]);
322         self.balances[msg.sender] = safeSub(self.balances[msg.sender], tokens);
323         self.balances[to] = safeAdd(self.balances[to], tokens);
324         Transfer(msg.sender, to, tokens);
325         return true;
326     }
327     function approve(Data storage self, address spender, uint tokens) public returns (bool success) {
328         require(!self.accountLocked[msg.sender]);
329         self.allowed[msg.sender][spender] = tokens;
330         Approval(msg.sender, spender, tokens);
331         return true;
332     }
333     function transferFrom(Data storage self, address from, address to, uint tokens) public returns (bool success) {
334         require(self.transferable);
335         require(!self.accountLocked[from]);
336         self.balances[from] = safeSub(self.balances[from], tokens);
337         self.allowed[from][msg.sender] = safeSub(self.allowed[from][msg.sender], tokens);
338         self.balances[to] = safeAdd(self.balances[to], tokens);
339         Transfer(from, to, tokens);
340         return true;
341     }
342     function approveAndCall(Data storage self, address tokenContract, address spender, uint tokens, bytes data) public returns (bool success) {
343         require(!self.accountLocked[msg.sender]);
344         self.allowed[msg.sender][spender] = tokens;
345         Approval(msg.sender, spender, tokens);
346         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, tokenContract, data);
347         return true;
348     }
349 
350     // ------------------------------------------------------------------------
351     // Signed function
352     // ------------------------------------------------------------------------
353     function signedTransferHash(Data storage /*self*/, address tokenContract, address tokenOwner, address to, uint tokens, uint fee, uint nonce) public pure returns (bytes32 hash) {
354         hash = keccak256(signedTransferSig, tokenContract, tokenOwner, to, tokens, fee, nonce);
355     }
356     function signedTransferCheck(Data storage self, address tokenContract, address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (BTTSTokenInterface.CheckResult result) {
357         if (!self.transferable) return BTTSTokenInterface.CheckResult.NotTransferable;
358         bytes32 hash = signedTransferHash(self, tokenContract, tokenOwner, to, tokens, fee, nonce);
359         if (tokenOwner == address(0) || tokenOwner != ecrecoverFromSig(self, keccak256(signingPrefix, hash), sig)) return BTTSTokenInterface.CheckResult.SignerMismatch;
360         if (self.accountLocked[tokenOwner]) return BTTSTokenInterface.CheckResult.AccountLocked;
361         if (self.executed[tokenOwner][hash]) return BTTSTokenInterface.CheckResult.AlreadyExecuted;
362         uint total = safeAdd(tokens, fee);
363         if (self.balances[tokenOwner] < tokens) return BTTSTokenInterface.CheckResult.InsufficientTokens;
364         if (self.balances[tokenOwner] < total) return BTTSTokenInterface.CheckResult.InsufficientTokensForFees;
365         if (self.balances[to] + tokens < self.balances[to]) return BTTSTokenInterface.CheckResult.OverflowError;
366         if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return BTTSTokenInterface.CheckResult.OverflowError;
367         return BTTSTokenInterface.CheckResult.Success;
368     }
369     function signedTransfer(Data storage self, address tokenContract, address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
370         require(self.transferable);
371         bytes32 hash = signedTransferHash(self, tokenContract, tokenOwner, to, tokens, fee, nonce);
372         require(tokenOwner != address(0) && tokenOwner == ecrecoverFromSig(self, keccak256(signingPrefix, hash), sig));
373         require(!self.accountLocked[tokenOwner]);
374         require(!self.executed[tokenOwner][hash]);
375         self.executed[tokenOwner][hash] = true;
376         self.balances[tokenOwner] = safeSub(self.balances[tokenOwner], tokens);
377         self.balances[to] = safeAdd(self.balances[to], tokens);
378         Transfer(tokenOwner, to, tokens);
379         self.balances[tokenOwner] = safeSub(self.balances[tokenOwner], fee);
380         self.balances[feeAccount] = safeAdd(self.balances[feeAccount], fee);
381         Transfer(tokenOwner, feeAccount, fee);
382         return true;
383     }
384     function signedApproveHash(Data storage /*self*/, address tokenContract, address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public pure returns (bytes32 hash) {
385         hash = keccak256(signedApproveSig, tokenContract, tokenOwner, spender, tokens, fee, nonce);
386     }
387     function signedApproveCheck(Data storage self, address tokenContract, address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (BTTSTokenInterface.CheckResult result) {
388         if (!self.transferable) return BTTSTokenInterface.CheckResult.NotTransferable;
389         bytes32 hash = signedApproveHash(self, tokenContract, tokenOwner, spender, tokens, fee, nonce);
390         if (tokenOwner == address(0) || tokenOwner != ecrecoverFromSig(self, keccak256(signingPrefix, hash), sig)) return BTTSTokenInterface.CheckResult.SignerMismatch;
391         if (self.accountLocked[tokenOwner]) return BTTSTokenInterface.CheckResult.AccountLocked;
392         if (self.executed[tokenOwner][hash]) return BTTSTokenInterface.CheckResult.AlreadyExecuted;
393         if (self.balances[tokenOwner] < fee) return BTTSTokenInterface.CheckResult.InsufficientTokensForFees;
394         if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return BTTSTokenInterface.CheckResult.OverflowError;
395         return BTTSTokenInterface.CheckResult.Success;
396     }
397     function signedApprove(Data storage self, address tokenContract, address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
398         require(self.transferable);
399         bytes32 hash = signedApproveHash(self, tokenContract, tokenOwner, spender, tokens, fee, nonce);
400         require(tokenOwner != address(0) && tokenOwner == ecrecoverFromSig(self, keccak256(signingPrefix, hash), sig));
401         require(!self.accountLocked[tokenOwner]);
402         require(!self.executed[tokenOwner][hash]);
403         self.executed[tokenOwner][hash] = true;
404         self.allowed[tokenOwner][spender] = tokens;
405         Approval(tokenOwner, spender, tokens);
406         self.balances[tokenOwner] = safeSub(self.balances[tokenOwner], fee);
407         self.balances[feeAccount] = safeAdd(self.balances[feeAccount], fee);
408         Transfer(tokenOwner, feeAccount, fee);
409         return true;
410     }
411     function signedTransferFromHash(Data storage /*self*/, address tokenContract, address spender, address from, address to, uint tokens, uint fee, uint nonce) public pure returns (bytes32 hash) {
412         hash = keccak256(signedTransferFromSig, tokenContract, spender, from, to, tokens, fee, nonce);
413     }
414     function signedTransferFromCheck(Data storage self, address tokenContract, address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (BTTSTokenInterface.CheckResult result) {
415         if (!self.transferable) return BTTSTokenInterface.CheckResult.NotTransferable;
416         bytes32 hash = signedTransferFromHash(self, tokenContract, spender, from, to, tokens, fee, nonce);
417         if (spender == address(0) || spender != ecrecoverFromSig(self, keccak256(signingPrefix, hash), sig)) return BTTSTokenInterface.CheckResult.SignerMismatch;
418         if (self.accountLocked[from]) return BTTSTokenInterface.CheckResult.AccountLocked;
419         if (self.executed[spender][hash]) return BTTSTokenInterface.CheckResult.AlreadyExecuted;
420         uint total = safeAdd(tokens, fee);
421         if (self.allowed[from][spender] < tokens) return BTTSTokenInterface.CheckResult.InsufficientApprovedTokens;
422         if (self.allowed[from][spender] < total) return BTTSTokenInterface.CheckResult.InsufficientApprovedTokensForFees;
423         if (self.balances[from] < tokens) return BTTSTokenInterface.CheckResult.InsufficientTokens;
424         if (self.balances[from] < total) return BTTSTokenInterface.CheckResult.InsufficientTokensForFees;
425         if (self.balances[to] + tokens < self.balances[to]) return BTTSTokenInterface.CheckResult.OverflowError;
426         if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return BTTSTokenInterface.CheckResult.OverflowError;
427         return BTTSTokenInterface.CheckResult.Success;
428     }
429     function signedTransferFrom(Data storage self, address tokenContract, address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
430         require(self.transferable);
431         bytes32 hash = signedTransferFromHash(self, tokenContract, spender, from, to, tokens, fee, nonce);
432         require(spender != address(0) && spender == ecrecoverFromSig(self, keccak256(signingPrefix, hash), sig));
433         require(!self.accountLocked[from]);
434         require(!self.executed[spender][hash]);
435         self.executed[spender][hash] = true;
436         self.balances[from] = safeSub(self.balances[from], tokens);
437         self.allowed[from][spender] = safeSub(self.allowed[from][spender], tokens);
438         self.balances[to] = safeAdd(self.balances[to], tokens);
439         Transfer(from, to, tokens);
440         self.balances[from] = safeSub(self.balances[from], fee);
441         self.allowed[from][spender] = safeSub(self.allowed[from][spender], fee);
442         self.balances[feeAccount] = safeAdd(self.balances[feeAccount], fee);
443         Transfer(from, feeAccount, fee);
444         return true;
445     }
446     function signedApproveAndCallHash(Data storage /*self*/, address tokenContract, address tokenOwner, address spender, uint tokens, bytes data, uint fee, uint nonce) public pure returns (bytes32 hash) {
447         hash = keccak256(signedApproveAndCallSig, tokenContract, tokenOwner, spender, tokens, data, fee, nonce);
448     }
449     function signedApproveAndCallCheck(Data storage self, address tokenContract, address tokenOwner, address spender, uint tokens, bytes data, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (BTTSTokenInterface.CheckResult result) {
450         if (!self.transferable) return BTTSTokenInterface.CheckResult.NotTransferable;
451         bytes32 hash = signedApproveAndCallHash(self, tokenContract, tokenOwner, spender, tokens, data, fee, nonce);
452         if (tokenOwner == address(0) || tokenOwner != ecrecoverFromSig(self, keccak256(signingPrefix, hash), sig)) return BTTSTokenInterface.CheckResult.SignerMismatch;
453         if (self.accountLocked[tokenOwner]) return BTTSTokenInterface.CheckResult.AccountLocked;
454         if (self.executed[tokenOwner][hash]) return BTTSTokenInterface.CheckResult.AlreadyExecuted;
455         if (self.balances[tokenOwner] < fee) return BTTSTokenInterface.CheckResult.InsufficientTokensForFees;
456         if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return BTTSTokenInterface.CheckResult.OverflowError;
457         return BTTSTokenInterface.CheckResult.Success;
458     }
459     function signedApproveAndCall(Data storage self, address tokenContract, address tokenOwner, address spender, uint tokens, bytes data, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
460         require(self.transferable);
461         bytes32 hash = signedApproveAndCallHash(self, tokenContract, tokenOwner, spender, tokens, data, fee, nonce);
462         require(tokenOwner != address(0) && tokenOwner == ecrecoverFromSig(self, keccak256(signingPrefix, hash), sig));
463         require(!self.accountLocked[tokenOwner]);
464         require(!self.executed[tokenOwner][hash]);
465         self.executed[tokenOwner][hash] = true;
466         self.allowed[tokenOwner][spender] = tokens;
467         Approval(tokenOwner, spender, tokens);
468         self.balances[tokenOwner] = safeSub(self.balances[tokenOwner], fee);
469         self.balances[feeAccount] = safeAdd(self.balances[feeAccount], fee);
470         Transfer(tokenOwner, feeAccount, fee);
471         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, tokenContract, data);
472         return true;
473     }
474 }
475 
476 
477 // ----------------------------------------------------------------------------
478 // BokkyPooBah's Token Teleportation Service Token Factory v1.00
479 //
480 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
481 // ----------------------------------------------------------------------------
482 contract BTTSToken is BTTSTokenInterface {
483     using BTTSLib for BTTSLib.Data;
484 
485     BTTSLib.Data data;
486 
487     // ------------------------------------------------------------------------
488     // Constructor
489     // ------------------------------------------------------------------------
490     function BTTSToken(address owner, string symbol, string name, uint8 decimals, uint initialSupply, bool mintable, bool transferable) public {
491         data.init(owner, symbol, name, decimals, initialSupply, mintable, transferable);
492     }
493 
494     // ------------------------------------------------------------------------
495     // Ownership
496     // ------------------------------------------------------------------------
497     function owner() public view returns (address) {
498         return data.owner;
499     }
500     function newOwner() public view returns (address) {
501         return data.newOwner;
502     }
503     function transferOwnership(address _newOwner) public {
504         data.transferOwnership(_newOwner);
505     }
506     function acceptOwnership() public {
507         data.acceptOwnership();
508     }
509     function transferOwnershipImmediately(address _newOwner) public {
510         data.transferOwnershipImmediately(_newOwner);
511     }
512 
513     // ------------------------------------------------------------------------
514     // Token
515     // ------------------------------------------------------------------------
516     function symbol() public view returns (string) {
517         return data.symbol;
518     }
519     function name() public view returns (string) {
520         return data.name;
521     }
522     function decimals() public view returns (uint8) {
523         return data.decimals;
524     }
525 
526     // ------------------------------------------------------------------------
527     // Minting and management
528     // ------------------------------------------------------------------------
529     function minter() public view returns (address) {
530         return data.minter;
531     }
532     function setMinter(address _minter) public {
533         data.setMinter(_minter);
534     }
535     function mint(address tokenOwner, uint tokens, bool lockAccount) public returns (bool success) {
536         return data.mint(tokenOwner, tokens, lockAccount);
537     }
538     function unlockAccount(address tokenOwner) public {
539         return data.unlockAccount(tokenOwner);
540     }
541     function mintable() public view returns (bool) {
542         return data.mintable;
543     }
544     function transferable() public view returns (bool) {
545         return data.transferable;
546     }
547     function disableMinting() public {
548         data.disableMinting();
549     }
550     function enableTransfers() public {
551         data.enableTransfers();
552     }
553 
554     // ------------------------------------------------------------------------
555     // Other functions
556     // ------------------------------------------------------------------------
557     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
558         return data.transferAnyERC20Token(tokenAddress, tokens);
559     }
560 
561     // ------------------------------------------------------------------------
562     // Don't accept ethers
563     // ------------------------------------------------------------------------
564     function () public payable {
565         revert();
566     }
567 
568     // ------------------------------------------------------------------------
569     // Token functions
570     // ------------------------------------------------------------------------
571     function totalSupply() public constant returns (uint) {
572         return data.totalSupply - data.balances[address(0)];
573     }
574     function balanceOf(address tokenOwner) public constant returns (uint balance) {
575         return data.balances[tokenOwner];
576     }
577     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
578         return data.allowed[tokenOwner][spender];
579     }
580     function transfer(address to, uint tokens) public returns (bool success) {
581         return data.transfer(to, tokens);
582     }
583     function approve(address spender, uint tokens) public returns (bool success) {
584         return data.approve(spender, tokens);
585     }
586     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
587         return data.transferFrom(from, to, tokens);
588     }
589     function approveAndCall(address spender, uint tokens, bytes _data) public returns (bool success) {
590         success = data.approveAndCall(this, spender, tokens, _data);
591     }
592 
593     // ------------------------------------------------------------------------
594     // Signed function
595     // ------------------------------------------------------------------------
596     function signedTransferHash(address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
597         return data.signedTransferHash(address(this), tokenOwner, to, tokens, fee, nonce);
598     }
599     function signedTransferCheck(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result) {
600         return data.signedTransferCheck(address(this), tokenOwner, to, tokens, fee, nonce, sig, feeAccount);
601     }
602     function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
603         return data.signedTransfer(address(this), tokenOwner, to, tokens, fee, nonce, sig, feeAccount);
604     }
605     function signedApproveHash(address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
606         return data.signedApproveHash(address(this), tokenOwner, spender, tokens, fee, nonce);
607     }
608     function signedApproveCheck(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result) {
609         return data.signedApproveCheck(address(this), tokenOwner, spender, tokens, fee, nonce, sig, feeAccount);
610     }
611     function signedApprove(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
612         return data.signedApprove(address(this), tokenOwner, spender, tokens, fee, nonce, sig, feeAccount);
613     }
614     function signedTransferFromHash(address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
615         return data.signedTransferFromHash(address(this), spender, from, to, tokens, fee, nonce);
616     }
617     function signedTransferFromCheck(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result) {
618         return data.signedTransferFromCheck(address(this), spender, from, to, tokens, fee, nonce, sig, feeAccount);
619     }
620     function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
621         return data.signedTransferFrom(address(this), spender, from, to, tokens, fee, nonce, sig, feeAccount);
622     }
623     function signedApproveAndCallHash(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce) public view returns (bytes32 hash) {
624         return data.signedApproveAndCallHash(address(this), tokenOwner, spender, tokens, _data, fee, nonce);
625     }
626     function signedApproveAndCallCheck(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result) {
627         return data.signedApproveAndCallCheck(address(this), tokenOwner, spender, tokens, _data, fee, nonce, sig, feeAccount);
628     }
629     function signedApproveAndCall(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
630         return data.signedApproveAndCall(address(this), tokenOwner, spender, tokens, _data, fee, nonce, sig, feeAccount);
631     }
632 }
633 
634 // ----------------------------------------------------------------------------
635 // Owned contract
636 // ----------------------------------------------------------------------------
637 contract Owned {
638     address public owner;
639     address public newOwner;
640     event OwnershipTransferred(address indexed _from, address indexed _to);
641 
642     function Owned() public {
643         owner = msg.sender;
644     }
645     modifier onlyOwner {
646         require(msg.sender == owner);
647         _;
648     }
649     function transferOwnership(address _newOwner) public onlyOwner {
650         newOwner = _newOwner;
651     }
652     function acceptOwnership() public {
653         require(msg.sender == newOwner);
654         OwnershipTransferred(owner, newOwner);
655         owner = newOwner;
656         newOwner = address(0);
657     }
658     function transferOwnershipImmediately(address _newOwner) public onlyOwner {
659         OwnershipTransferred(owner, _newOwner);
660         owner = _newOwner;
661         newOwner = address(0);
662     }
663 }
664 
665 
666 // ----------------------------------------------------------------------------
667 // BokkyPooBah's Token Teleportation Service Token Factory v1.00
668 //
669 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
670 // ----------------------------------------------------------------------------
671 contract BTTSTokenFactory is Owned {
672 
673     // ------------------------------------------------------------------------
674     // Internal data
675     // ------------------------------------------------------------------------
676     mapping(address => bool) _verify;
677 
678     // ------------------------------------------------------------------------
679     // Event
680     // ------------------------------------------------------------------------
681     event BTTSTokenListing(address indexed ownerAddress,
682         address indexed bttsTokenAddress, 
683         string symbol, string name, uint8 decimals, 
684         uint initialSupply, bool mintable, bool transferable);
685 
686 
687     // ------------------------------------------------------------------------
688     // Anyone can call this method to verify whether the bttsToken contract at
689     // the specified address was deployed using this factory
690     //
691     // Parameters:
692     //   tokenContract  the bttsToken contract address
693     //
694     // Return values:
695     //   valid          did this BTTSTokenFactory create the BTTSToken contract?
696     //   decimals       number of decimal places for the token contract
697     //   initialSupply  the token initial supply
698     //   mintable       is the token mintable after deployment?
699     //   transferable   are the tokens transferable after deployment?
700     // ------------------------------------------------------------------------
701     function verify(address tokenContract) public view returns (
702         bool    valid,
703         address owner,
704         uint    decimals,
705         bool    mintable,
706         bool    transferable
707     ) {
708         valid = _verify[tokenContract];
709         if (valid) {
710             BTTSToken t = BTTSToken(tokenContract);
711             owner        = t.owner();
712             decimals     = t.decimals();
713             mintable     = t.mintable();
714             transferable = t.transferable();
715         }
716     }
717 
718 
719     // ------------------------------------------------------------------------
720     // Any account can call this method to deploy a new BTTSToken contract.
721     // The owner of the BTTSToken contract will be the calling account
722     //
723     // Parameters:
724     //   symbol         symbol
725     //   name           name
726     //   decimals       number of decimal places for the token contract
727     //   initialSupply  the token initial supply
728     //   mintable       is the token mintable after deployment?
729     //   transferable   are the tokens transferable after deployment?
730     //
731     // For example, deploying a BTTSToken contract with `initialSupply` of
732     // 1,000.000000000000000000 tokens:
733     //   symbol         "ME"
734     //   name           "My Token"
735     //   decimals       18
736     //   initialSupply  10000000000000000000000 = 1,000.000000000000000000
737     //                  tokens
738     //   mintable       can tokens be minted after deployment?
739     //   transferable   are the tokens transferable after deployment?
740     //
741     // The BTTSTokenListing() event is logged with the following parameters
742     //   owner          the account that execute this transaction
743     //   symbol         symbol
744     //   name           name
745     //   decimals       number of decimal places for the token contract
746     //   initialSupply  the token initial supply
747     //   mintable       can tokens be minted after deployment?
748     //   transferable   are the tokens transferable after deployment?
749     // ------------------------------------------------------------------------
750     function deployBTTSTokenContract(
751         string symbol,
752         string name,
753         uint8 decimals,
754         uint initialSupply,
755         bool mintable,
756         bool transferable
757     ) public returns (address bttsTokenAddress) {
758         bttsTokenAddress = new BTTSToken(
759             msg.sender,
760             symbol,
761             name,
762             decimals,
763             initialSupply,
764             mintable,
765             transferable);
766         // Record that this factory created the trader
767         _verify[bttsTokenAddress] = true;
768         BTTSTokenListing(msg.sender, bttsTokenAddress, symbol, name, decimals, 
769             initialSupply, mintable, transferable);
770     }
771 
772 
773     // ------------------------------------------------------------------------
774     // Factory owner can transfer out any accidentally sent ERC20 tokens
775     //
776     // Parameters:
777     //   tokenAddress  contract address of the token contract being withdrawn
778     //                 from
779     //   tokens        number of tokens
780     // ------------------------------------------------------------------------
781     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
782         return ERC20Interface(tokenAddress).transfer(owner, tokens);
783     }
784 
785     // ------------------------------------------------------------------------
786     // Don't accept ethers
787     // ------------------------------------------------------------------------
788     function () public payable {
789         revert();
790     }
791 }