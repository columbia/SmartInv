1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // BokkyPooBah's Token Teleportation Service v1.10
5 //
6 // https://github.com/bokkypoobah/BokkyPooBahsTokenTeleportationServiceSmartContract
7 //
8 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 // ERC Token Standard #20 Interface
14 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
15 // ----------------------------------------------------------------------------
16 contract ERC20Interface {
17     function totalSupply() public view returns (uint);
18     function balanceOf(address tokenOwner) public view returns (uint balance);
19     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
20     function transfer(address to, uint tokens) public returns (bool success);
21     function approve(address spender, uint tokens) public returns (bool success);
22     function transferFrom(address from, address to, uint tokens) public returns (bool success);
23 
24     event Transfer(address indexed from, address indexed to, uint tokens);
25     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
26 }
27 
28 
29 // ----------------------------------------------------------------------------
30 // Contracts that can have tokens approved, and then a function executed
31 // ----------------------------------------------------------------------------
32 contract ApproveAndCallFallBack {
33     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // BokkyPooBah's Token Teleportation Service Interface v1.10
39 //
40 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
41 // ----------------------------------------------------------------------------
42 contract BTTSTokenInterface is ERC20Interface {
43     uint public constant bttsVersion = 110;
44 
45     bytes public constant signingPrefix = "\x19Ethereum Signed Message:\n32";
46     bytes4 public constant signedTransferSig = "\x75\x32\xea\xac";
47     bytes4 public constant signedApproveSig = "\xe9\xaf\xa7\xa1";
48     bytes4 public constant signedTransferFromSig = "\x34\x4b\xcc\x7d";
49     bytes4 public constant signedApproveAndCallSig = "\xf1\x6f\x9b\x53";
50 
51     event OwnershipTransferred(address indexed from, address indexed to);
52     event MinterUpdated(address from, address to);
53     event Mint(address indexed tokenOwner, uint tokens, bool lockAccount);
54     event MintingDisabled();
55     event TransfersEnabled();
56     event AccountUnlocked(address indexed tokenOwner);
57 
58     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success);
59 
60     // ------------------------------------------------------------------------
61     // signed{X} functions
62     // ------------------------------------------------------------------------
63     function signedTransferHash(address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
64     function signedTransferCheck(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
65     function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
66 
67     function signedApproveHash(address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
68     function signedApproveCheck(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
69     function signedApprove(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
70 
71     function signedTransferFromHash(address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
72     function signedTransferFromCheck(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
73     function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
74 
75     function signedApproveAndCallHash(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce) public view returns (bytes32 hash);
76     function signedApproveAndCallCheck(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
77     function signedApproveAndCall(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
78 
79     function mint(address tokenOwner, uint tokens, bool lockAccount) public returns (bool success);
80     function unlockAccount(address tokenOwner) public;
81     function disableMinting() public;
82     function enableTransfers() public;
83 
84     // ------------------------------------------------------------------------
85     // signed{X}Check return status
86     // ------------------------------------------------------------------------
87     enum CheckResult {
88         Success,                           // 0 Success
89         NotTransferable,                   // 1 Tokens not transferable yet
90         AccountLocked,                     // 2 Account locked
91         SignerMismatch,                    // 3 Mismatch in signing account
92         InvalidNonce,                      // 4 Invalid nonce
93         InsufficientApprovedTokens,        // 5 Insufficient approved tokens
94         InsufficientApprovedTokensForFees, // 6 Insufficient approved tokens for fees
95         InsufficientTokens,                // 7 Insufficient tokens
96         InsufficientTokensForFees,         // 8 Insufficient tokens for fees
97         OverflowError                      // 9 Overflow error
98     }
99 }
100 
101 
102 // ----------------------------------------------------------------------------
103 // BokkyPooBah's Token Teleportation Service Library v1.00
104 //
105 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
106 // ----------------------------------------------------------------------------
107 library BTTSLib {
108     struct Data {
109         bool initialised;
110 
111         // Ownership
112         address owner;
113         address newOwner;
114 
115         // Minting and management
116         address minter;
117         bool mintable;
118         bool transferable;
119         mapping(address => bool) accountLocked;
120 
121         // Token
122         string symbol;
123         string name;
124         uint8 decimals;
125         uint totalSupply;
126         mapping(address => uint) balances;
127         mapping(address => mapping(address => uint)) allowed;
128         mapping(address => uint) nextNonce;
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Constants
134     // ------------------------------------------------------------------------
135     uint public constant bttsVersion = 110;
136     bytes public constant signingPrefix = "\x19Ethereum Signed Message:\n32";
137     bytes4 public constant signedTransferSig = "\x75\x32\xea\xac";
138     bytes4 public constant signedApproveSig = "\xe9\xaf\xa7\xa1";
139     bytes4 public constant signedTransferFromSig = "\x34\x4b\xcc\x7d";
140     bytes4 public constant signedApproveAndCallSig = "\xf1\x6f\x9b\x53";
141 
142     // ------------------------------------------------------------------------
143     // Event
144     // ------------------------------------------------------------------------
145     event OwnershipTransferred(address indexed from, address indexed to);
146     event MinterUpdated(address from, address to);
147     event Mint(address indexed tokenOwner, uint tokens, bool lockAccount);
148     event MintingDisabled();
149     event TransfersEnabled();
150     event AccountUnlocked(address indexed tokenOwner);
151     event Transfer(address indexed from, address indexed to, uint tokens);
152     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
153 
154 
155     // ------------------------------------------------------------------------
156     // Initialisation
157     // ------------------------------------------------------------------------
158     function init(Data storage self, address owner, string symbol, string name, uint8 decimals, uint initialSupply, bool mintable, bool transferable) public {
159         require(!self.initialised);
160         self.initialised = true;
161         self.owner = owner;
162         self.symbol = symbol;
163         self.name = name;
164         self.decimals = decimals;
165         if (initialSupply > 0) {
166             self.balances[owner] = initialSupply;
167             self.totalSupply = initialSupply;
168             Mint(self.owner, initialSupply, false);
169             Transfer(address(0), self.owner, initialSupply);
170         }
171         self.mintable = mintable;
172         self.transferable = transferable;
173     }
174 
175     // ------------------------------------------------------------------------
176     // Safe maths, inspired by OpenZeppelin
177     // ------------------------------------------------------------------------
178     function safeAdd(uint a, uint b) internal pure returns (uint c) {
179         c = a + b;
180         require(c >= a);
181     }
182     function safeSub(uint a, uint b) internal pure returns (uint c) {
183         require(b <= a);
184         c = a - b;
185     }
186     function safeMul(uint a, uint b) internal pure returns (uint c) {
187         c = a * b;
188         require(a == 0 || c / a == b);
189     }
190     function safeDiv(uint a, uint b) internal pure returns (uint c) {
191         require(b > 0);
192         c = a / b;
193     }
194 
195     // ------------------------------------------------------------------------
196     // Ownership
197     // ------------------------------------------------------------------------
198     function transferOwnership(Data storage self, address newOwner) public {
199         require(msg.sender == self.owner);
200         self.newOwner = newOwner;
201     }
202     function acceptOwnership(Data storage self) public {
203         require(msg.sender == self.newOwner);
204         OwnershipTransferred(self.owner, self.newOwner);
205         self.owner = self.newOwner;
206         self.newOwner = address(0);
207     }
208     function transferOwnershipImmediately(Data storage self, address newOwner) public {
209         require(msg.sender == self.owner);
210         OwnershipTransferred(self.owner, newOwner);
211         self.owner = newOwner;
212         self.newOwner = address(0);
213     }
214 
215     // ------------------------------------------------------------------------
216     // Minting and management
217     // ------------------------------------------------------------------------
218     function setMinter(Data storage self, address minter) public {
219         require(msg.sender == self.owner);
220         require(self.mintable);
221         MinterUpdated(self.minter, minter);
222         self.minter = minter;
223     }
224     function mint(Data storage self, address tokenOwner, uint tokens, bool lockAccount) public returns (bool success) {
225         require(self.mintable);
226         require(msg.sender == self.minter || msg.sender == self.owner);
227         if (lockAccount) {
228             self.accountLocked[tokenOwner] = true;
229         }
230         self.balances[tokenOwner] = safeAdd(self.balances[tokenOwner], tokens);
231         self.totalSupply = safeAdd(self.totalSupply, tokens);
232         Mint(tokenOwner, tokens, lockAccount);
233         Transfer(address(0), tokenOwner, tokens);
234         return true;
235     }
236     function unlockAccount(Data storage self, address tokenOwner) public {
237         require(msg.sender == self.owner);
238         require(self.accountLocked[tokenOwner]);
239         self.accountLocked[tokenOwner] = false;
240         AccountUnlocked(tokenOwner);
241     }
242     function disableMinting(Data storage self) public {
243         require(self.mintable);
244         require(msg.sender == self.minter || msg.sender == self.owner);
245         self.mintable = false;
246         if (self.minter != address(0)) {
247             MinterUpdated(self.minter, address(0));
248             self.minter = address(0);
249         }
250         MintingDisabled();
251     }
252     function enableTransfers(Data storage self) public {
253         require(msg.sender == self.owner);
254         require(!self.transferable);
255         self.transferable = true;
256         TransfersEnabled();
257     }
258 
259     // ------------------------------------------------------------------------
260     // Other functions
261     // ------------------------------------------------------------------------
262     function transferAnyERC20Token(Data storage self, address tokenAddress, uint tokens) public returns (bool success) {
263         require(msg.sender == self.owner);
264         return ERC20Interface(tokenAddress).transfer(self.owner, tokens);
265     }
266 
267     // ------------------------------------------------------------------------
268     // ecrecover from a signature rather than the signature in parts [v, r, s]
269     // The signature format is a compact form {bytes32 r}{bytes32 s}{uint8 v}.
270     // Compact means, uint8 is not padded to 32 bytes.
271     //
272     // An invalid signature results in the address(0) being returned, make
273     // sure that the returned result is checked to be non-zero for validity
274     //
275     // Parts from https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
276     // ------------------------------------------------------------------------
277     function ecrecoverFromSig(bytes32 hash, bytes sig) public pure returns (address recoveredAddress) {
278         bytes32 r;
279         bytes32 s;
280         uint8 v;
281         if (sig.length != 65) return address(0);
282         assembly {
283             r := mload(add(sig, 32))
284             s := mload(add(sig, 64))
285             // Here we are loading the last 32 bytes. We exploit the fact that 'mload' will pad with zeroes if we overread.
286             // There is no 'mload8' to do this, but that would be nicer.
287             v := byte(0, mload(add(sig, 96)))
288         }
289         // Albeit non-transactional signatures are not specified by the YP, one would expect it to match the YP range of [27, 28]
290         // geth uses [0, 1] and some clients have followed. This might change, see https://github.com/ethereum/go-ethereum/issues/2053
291         if (v < 27) {
292           v += 27;
293         }
294         if (v != 27 && v != 28) return address(0);
295         return ecrecover(hash, v, r, s);
296     }
297 
298     // ------------------------------------------------------------------------
299     // Get CheckResult message
300     // ------------------------------------------------------------------------
301     function getCheckResultMessage(Data storage /*self*/, BTTSTokenInterface.CheckResult result) public pure returns (string) {
302         if (result == BTTSTokenInterface.CheckResult.Success) {
303             return "Success";
304         } else if (result == BTTSTokenInterface.CheckResult.NotTransferable) {
305             return "Tokens not transferable yet";
306         } else if (result == BTTSTokenInterface.CheckResult.AccountLocked) {
307             return "Account locked";
308         } else if (result == BTTSTokenInterface.CheckResult.SignerMismatch) {
309             return "Mismatch in signing account";
310         } else if (result == BTTSTokenInterface.CheckResult.InvalidNonce) {
311             return "Invalid nonce";
312         } else if (result == BTTSTokenInterface.CheckResult.InsufficientApprovedTokens) {
313             return "Insufficient approved tokens";
314         } else if (result == BTTSTokenInterface.CheckResult.InsufficientApprovedTokensForFees) {
315             return "Insufficient approved tokens for fees";
316         } else if (result == BTTSTokenInterface.CheckResult.InsufficientTokens) {
317             return "Insufficient tokens";
318         } else if (result == BTTSTokenInterface.CheckResult.InsufficientTokensForFees) {
319             return "Insufficient tokens for fees";
320         } else if (result == BTTSTokenInterface.CheckResult.OverflowError) {
321             return "Overflow error";
322         } else {
323             return "Unknown error";
324         }
325     }
326 
327     // ------------------------------------------------------------------------
328     // Token functions
329     // ------------------------------------------------------------------------
330     function transfer(Data storage self, address to, uint tokens) public returns (bool success) {
331         // Owner and minter can move tokens before the tokens are transferable
332         require(self.transferable || (self.mintable && (msg.sender == self.owner  || msg.sender == self.minter)));
333         require(!self.accountLocked[msg.sender]);
334         self.balances[msg.sender] = safeSub(self.balances[msg.sender], tokens);
335         self.balances[to] = safeAdd(self.balances[to], tokens);
336         Transfer(msg.sender, to, tokens);
337         return true;
338     }
339     function approve(Data storage self, address spender, uint tokens) public returns (bool success) {
340         require(!self.accountLocked[msg.sender]);
341         self.allowed[msg.sender][spender] = tokens;
342         Approval(msg.sender, spender, tokens);
343         return true;
344     }
345     function transferFrom(Data storage self, address from, address to, uint tokens) public returns (bool success) {
346         require(self.transferable);
347         require(!self.accountLocked[from]);
348         self.balances[from] = safeSub(self.balances[from], tokens);
349         self.allowed[from][msg.sender] = safeSub(self.allowed[from][msg.sender], tokens);
350         self.balances[to] = safeAdd(self.balances[to], tokens);
351         Transfer(from, to, tokens);
352         return true;
353     }
354     function approveAndCall(Data storage self, address spender, uint tokens, bytes data) public returns (bool success) {
355         require(!self.accountLocked[msg.sender]);
356         self.allowed[msg.sender][spender] = tokens;
357         Approval(msg.sender, spender, tokens);
358         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
359         return true;
360     }
361 
362     // ------------------------------------------------------------------------
363     // Signed function
364     // ------------------------------------------------------------------------
365     function signedTransferHash(Data storage /*self*/, address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
366         hash = keccak256(signedTransferSig, address(this), tokenOwner, to, tokens, fee, nonce);
367     }
368     function signedTransferCheck(Data storage self, address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (BTTSTokenInterface.CheckResult result) {
369         if (!self.transferable) return BTTSTokenInterface.CheckResult.NotTransferable;
370         bytes32 hash = signedTransferHash(self, tokenOwner, to, tokens, fee, nonce);
371         if (tokenOwner == address(0) || tokenOwner != ecrecoverFromSig(keccak256(signingPrefix, hash), sig)) return BTTSTokenInterface.CheckResult.SignerMismatch;
372         if (self.accountLocked[tokenOwner]) return BTTSTokenInterface.CheckResult.AccountLocked;
373         if (self.nextNonce[tokenOwner] != nonce) return BTTSTokenInterface.CheckResult.InvalidNonce;
374         uint total = safeAdd(tokens, fee);
375         if (self.balances[tokenOwner] < tokens) return BTTSTokenInterface.CheckResult.InsufficientTokens;
376         if (self.balances[tokenOwner] < total) return BTTSTokenInterface.CheckResult.InsufficientTokensForFees;
377         if (self.balances[to] + tokens < self.balances[to]) return BTTSTokenInterface.CheckResult.OverflowError;
378         if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return BTTSTokenInterface.CheckResult.OverflowError;
379         return BTTSTokenInterface.CheckResult.Success;
380     }
381     function signedTransfer(Data storage self, address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
382         require(self.transferable);
383         bytes32 hash = signedTransferHash(self, tokenOwner, to, tokens, fee, nonce);
384         require(tokenOwner != address(0) && tokenOwner == ecrecoverFromSig(keccak256(signingPrefix, hash), sig));
385         require(!self.accountLocked[tokenOwner]);
386         require(self.nextNonce[tokenOwner] == nonce);
387         self.nextNonce[tokenOwner] = nonce + 1;
388         self.balances[tokenOwner] = safeSub(self.balances[tokenOwner], tokens);
389         self.balances[to] = safeAdd(self.balances[to], tokens);
390         Transfer(tokenOwner, to, tokens);
391         self.balances[tokenOwner] = safeSub(self.balances[tokenOwner], fee);
392         self.balances[feeAccount] = safeAdd(self.balances[feeAccount], fee);
393         Transfer(tokenOwner, feeAccount, fee);
394         return true;
395     }
396     function signedApproveHash(Data storage /*self*/, address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
397         hash = keccak256(signedApproveSig, address(this), tokenOwner, spender, tokens, fee, nonce);
398     }
399     function signedApproveCheck(Data storage self, address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (BTTSTokenInterface.CheckResult result) {
400         if (!self.transferable) return BTTSTokenInterface.CheckResult.NotTransferable;
401         bytes32 hash = signedApproveHash(self, tokenOwner, spender, tokens, fee, nonce);
402         if (tokenOwner == address(0) || tokenOwner != ecrecoverFromSig(keccak256(signingPrefix, hash), sig)) return BTTSTokenInterface.CheckResult.SignerMismatch;
403         if (self.accountLocked[tokenOwner]) return BTTSTokenInterface.CheckResult.AccountLocked;
404         if (self.nextNonce[tokenOwner] != nonce) return BTTSTokenInterface.CheckResult.InvalidNonce;
405         if (self.balances[tokenOwner] < fee) return BTTSTokenInterface.CheckResult.InsufficientTokensForFees;
406         if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return BTTSTokenInterface.CheckResult.OverflowError;
407         return BTTSTokenInterface.CheckResult.Success;
408     }
409     function signedApprove(Data storage self, address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
410         require(self.transferable);
411         bytes32 hash = signedApproveHash(self, tokenOwner, spender, tokens, fee, nonce);
412         require(tokenOwner != address(0) && tokenOwner == ecrecoverFromSig(keccak256(signingPrefix, hash), sig));
413         require(!self.accountLocked[tokenOwner]);
414         require(self.nextNonce[tokenOwner] == nonce);
415         self.nextNonce[tokenOwner] = nonce + 1;
416         self.allowed[tokenOwner][spender] = tokens;
417         Approval(tokenOwner, spender, tokens);
418         self.balances[tokenOwner] = safeSub(self.balances[tokenOwner], fee);
419         self.balances[feeAccount] = safeAdd(self.balances[feeAccount], fee);
420         Transfer(tokenOwner, feeAccount, fee);
421         return true;
422     }
423     function signedTransferFromHash(Data storage /*self*/, address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
424         hash = keccak256(signedTransferFromSig, address(this), spender, from, to, tokens, fee, nonce);
425     }
426     function signedTransferFromCheck(Data storage self, address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (BTTSTokenInterface.CheckResult result) {
427         if (!self.transferable) return BTTSTokenInterface.CheckResult.NotTransferable;
428         bytes32 hash = signedTransferFromHash(self, spender, from, to, tokens, fee, nonce);
429         if (spender == address(0) || spender != ecrecoverFromSig(keccak256(signingPrefix, hash), sig)) return BTTSTokenInterface.CheckResult.SignerMismatch;
430         if (self.accountLocked[from]) return BTTSTokenInterface.CheckResult.AccountLocked;
431         if (self.nextNonce[spender] != nonce) return BTTSTokenInterface.CheckResult.InvalidNonce;
432         uint total = safeAdd(tokens, fee);
433         if (self.allowed[from][spender] < tokens) return BTTSTokenInterface.CheckResult.InsufficientApprovedTokens;
434         if (self.allowed[from][spender] < total) return BTTSTokenInterface.CheckResult.InsufficientApprovedTokensForFees;
435         if (self.balances[from] < tokens) return BTTSTokenInterface.CheckResult.InsufficientTokens;
436         if (self.balances[from] < total) return BTTSTokenInterface.CheckResult.InsufficientTokensForFees;
437         if (self.balances[to] + tokens < self.balances[to]) return BTTSTokenInterface.CheckResult.OverflowError;
438         if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return BTTSTokenInterface.CheckResult.OverflowError;
439         return BTTSTokenInterface.CheckResult.Success;
440     }
441     function signedTransferFrom(Data storage self, address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
442         require(self.transferable);
443         bytes32 hash = signedTransferFromHash(self, spender, from, to, tokens, fee, nonce);
444         require(spender != address(0) && spender == ecrecoverFromSig(keccak256(signingPrefix, hash), sig));
445         require(!self.accountLocked[from]);
446         require(self.nextNonce[spender] == nonce);
447         self.nextNonce[spender] = nonce + 1;
448         self.balances[from] = safeSub(self.balances[from], tokens);
449         self.allowed[from][spender] = safeSub(self.allowed[from][spender], tokens);
450         self.balances[to] = safeAdd(self.balances[to], tokens);
451         Transfer(from, to, tokens);
452         self.balances[from] = safeSub(self.balances[from], fee);
453         self.allowed[from][spender] = safeSub(self.allowed[from][spender], fee);
454         self.balances[feeAccount] = safeAdd(self.balances[feeAccount], fee);
455         Transfer(from, feeAccount, fee);
456         return true;
457     }
458     function signedApproveAndCallHash(Data storage /*self*/, address tokenOwner, address spender, uint tokens, bytes data, uint fee, uint nonce) public view returns (bytes32 hash) {
459         hash = keccak256(signedApproveAndCallSig, address(this), tokenOwner, spender, tokens, data, fee, nonce);
460     }
461     function signedApproveAndCallCheck(Data storage self, address tokenOwner, address spender, uint tokens, bytes data, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (BTTSTokenInterface.CheckResult result) {
462         if (!self.transferable) return BTTSTokenInterface.CheckResult.NotTransferable;
463         bytes32 hash = signedApproveAndCallHash(self, tokenOwner, spender, tokens, data, fee, nonce);
464         if (tokenOwner == address(0) || tokenOwner != ecrecoverFromSig(keccak256(signingPrefix, hash), sig)) return BTTSTokenInterface.CheckResult.SignerMismatch;
465         if (self.accountLocked[tokenOwner]) return BTTSTokenInterface.CheckResult.AccountLocked;
466         if (self.nextNonce[tokenOwner] != nonce) return BTTSTokenInterface.CheckResult.InvalidNonce;
467         if (self.balances[tokenOwner] < fee) return BTTSTokenInterface.CheckResult.InsufficientTokensForFees;
468         if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return BTTSTokenInterface.CheckResult.OverflowError;
469         return BTTSTokenInterface.CheckResult.Success;
470     }
471     function signedApproveAndCall(Data storage self, address tokenOwner, address spender, uint tokens, bytes data, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
472         require(self.transferable);
473         bytes32 hash = signedApproveAndCallHash(self, tokenOwner, spender, tokens, data, fee, nonce);
474         require(tokenOwner != address(0) && tokenOwner == ecrecoverFromSig(keccak256(signingPrefix, hash), sig));
475         require(!self.accountLocked[tokenOwner]);
476         require(self.nextNonce[tokenOwner] == nonce);
477         self.nextNonce[tokenOwner] = nonce + 1;
478         self.allowed[tokenOwner][spender] = tokens;
479         Approval(tokenOwner, spender, tokens);
480         self.balances[tokenOwner] = safeSub(self.balances[tokenOwner], fee);
481         self.balances[feeAccount] = safeAdd(self.balances[feeAccount], fee);
482         Transfer(tokenOwner, feeAccount, fee);
483         ApproveAndCallFallBack(spender).receiveApproval(tokenOwner, tokens, address(this), data);
484         return true;
485     }
486 }
487 
488 
489 // ----------------------------------------------------------------------------
490 // BokkyPooBah's Token Teleportation Service Token v1.10
491 //
492 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
493 // ----------------------------------------------------------------------------
494 contract BTTSToken is BTTSTokenInterface {
495     using BTTSLib for BTTSLib.Data;
496 
497     BTTSLib.Data data;
498 
499     // ------------------------------------------------------------------------
500     // Constructor
501     // ------------------------------------------------------------------------
502     function BTTSToken(address owner, string symbol, string name, uint8 decimals, uint initialSupply, bool mintable, bool transferable) public {
503         data.init(owner, symbol, name, decimals, initialSupply, mintable, transferable);
504     }
505 
506     // ------------------------------------------------------------------------
507     // Ownership
508     // ------------------------------------------------------------------------
509     function owner() public view returns (address) {
510         return data.owner;
511     }
512     function newOwner() public view returns (address) {
513         return data.newOwner;
514     }
515     function transferOwnership(address _newOwner) public {
516         data.transferOwnership(_newOwner);
517     }
518     function acceptOwnership() public {
519         data.acceptOwnership();
520     }
521     function transferOwnershipImmediately(address _newOwner) public {
522         data.transferOwnershipImmediately(_newOwner);
523     }
524 
525     // ------------------------------------------------------------------------
526     // Token
527     // ------------------------------------------------------------------------
528     function symbol() public view returns (string) {
529         return data.symbol;
530     }
531     function name() public view returns (string) {
532         return data.name;
533     }
534     function decimals() public view returns (uint8) {
535         return data.decimals;
536     }
537 
538     // ------------------------------------------------------------------------
539     // Minting and management
540     // ------------------------------------------------------------------------
541     function minter() public view returns (address) {
542         return data.minter;
543     }
544     function setMinter(address _minter) public {
545         data.setMinter(_minter);
546     }
547     function mint(address tokenOwner, uint tokens, bool lockAccount) public returns (bool success) {
548         return data.mint(tokenOwner, tokens, lockAccount);
549     }
550     function accountLocked(address tokenOwner) public view returns (bool) {
551         return data.accountLocked[tokenOwner];
552     }
553     function unlockAccount(address tokenOwner) public {
554         data.unlockAccount(tokenOwner);
555     }
556     function mintable() public view returns (bool) {
557         return data.mintable;
558     }
559     function transferable() public view returns (bool) {
560         return data.transferable;
561     }
562     function disableMinting() public {
563         data.disableMinting();
564     }
565     function enableTransfers() public {
566         data.enableTransfers();
567     }
568     function nextNonce(address spender) public view returns (uint) {
569         return data.nextNonce[spender];
570     }
571 
572     // ------------------------------------------------------------------------
573     // Other functions
574     // ------------------------------------------------------------------------
575     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
576         return data.transferAnyERC20Token(tokenAddress, tokens);
577     }
578 
579     // ------------------------------------------------------------------------
580     // Don't accept ethers
581     // ------------------------------------------------------------------------
582     function () public payable {
583         revert();
584     }
585 
586     // ------------------------------------------------------------------------
587     // Token functions
588     // ------------------------------------------------------------------------
589     function totalSupply() public view returns (uint) {
590         return data.totalSupply - data.balances[address(0)];
591     }
592     function balanceOf(address tokenOwner) public view returns (uint balance) {
593         return data.balances[tokenOwner];
594     }
595     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
596         return data.allowed[tokenOwner][spender];
597     }
598     function transfer(address to, uint tokens) public returns (bool success) {
599         return data.transfer(to, tokens);
600     }
601     function approve(address spender, uint tokens) public returns (bool success) {
602         return data.approve(spender, tokens);
603     }
604     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
605         return data.transferFrom(from, to, tokens);
606     }
607     function approveAndCall(address spender, uint tokens, bytes _data) public returns (bool success) {
608         return data.approveAndCall(spender, tokens, _data);
609     }
610 
611     // ------------------------------------------------------------------------
612     // Signed function
613     // ------------------------------------------------------------------------
614     function signedTransferHash(address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
615         return data.signedTransferHash(tokenOwner, to, tokens, fee, nonce);
616     }
617     function signedTransferCheck(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result) {
618         return data.signedTransferCheck(tokenOwner, to, tokens, fee, nonce, sig, feeAccount);
619     }
620     function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
621         return data.signedTransfer(tokenOwner, to, tokens, fee, nonce, sig, feeAccount);
622     }
623     function signedApproveHash(address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
624         return data.signedApproveHash(tokenOwner, spender, tokens, fee, nonce);
625     }
626     function signedApproveCheck(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result) {
627         return data.signedApproveCheck(tokenOwner, spender, tokens, fee, nonce, sig, feeAccount);
628     }
629     function signedApprove(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
630         return data.signedApprove(tokenOwner, spender, tokens, fee, nonce, sig, feeAccount);
631     }
632     function signedTransferFromHash(address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
633         return data.signedTransferFromHash(spender, from, to, tokens, fee, nonce);
634     }
635     function signedTransferFromCheck(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result) {
636         return data.signedTransferFromCheck(spender, from, to, tokens, fee, nonce, sig, feeAccount);
637     }
638     function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
639         return data.signedTransferFrom(spender, from, to, tokens, fee, nonce, sig, feeAccount);
640     }
641     function signedApproveAndCallHash(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce) public view returns (bytes32 hash) {
642         return data.signedApproveAndCallHash(tokenOwner, spender, tokens, _data, fee, nonce);
643     }
644     function signedApproveAndCallCheck(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result) {
645         return data.signedApproveAndCallCheck(tokenOwner, spender, tokens, _data, fee, nonce, sig, feeAccount);
646     }
647     function signedApproveAndCall(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success) {
648         return data.signedApproveAndCall(tokenOwner, spender, tokens, _data, fee, nonce, sig, feeAccount);
649     }
650 }
651 
652 // ----------------------------------------------------------------------------
653 // Owned contract
654 // ----------------------------------------------------------------------------
655 contract Owned {
656     address public owner;
657     address public newOwner;
658     event OwnershipTransferred(address indexed _from, address indexed _to);
659 
660     function Owned() public {
661         owner = msg.sender;
662     }
663     modifier onlyOwner {
664         require(msg.sender == owner);
665         _;
666     }
667     function transferOwnership(address _newOwner) public onlyOwner {
668         newOwner = _newOwner;
669     }
670     function acceptOwnership() public {
671         require(msg.sender == newOwner);
672         OwnershipTransferred(owner, newOwner);
673         owner = newOwner;
674         newOwner = address(0);
675     }
676     function transferOwnershipImmediately(address _newOwner) public onlyOwner {
677         OwnershipTransferred(owner, _newOwner);
678         owner = _newOwner;
679         newOwner = address(0);
680     }
681 }
682 
683 
684 // ----------------------------------------------------------------------------
685 // BokkyPooBah's Token Teleportation Service Token Factory v1.10
686 //
687 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
688 // ----------------------------------------------------------------------------
689 contract BTTSTokenFactory is Owned {
690 
691     // ------------------------------------------------------------------------
692     // Internal data
693     // ------------------------------------------------------------------------
694     mapping(address => bool) _verify;
695     address[] public deployedTokens;
696 
697     // ------------------------------------------------------------------------
698     // Event
699     // ------------------------------------------------------------------------
700     event BTTSTokenListing(address indexed ownerAddress,
701         address indexed bttsTokenAddress,
702         string symbol, string name, uint8 decimals,
703         uint initialSupply, bool mintable, bool transferable);
704 
705 
706     // ------------------------------------------------------------------------
707     // Anyone can call this method to verify whether the bttsToken contract at
708     // the specified address was deployed using this factory
709     //
710     // Parameters:
711     //   tokenContract  the bttsToken contract address
712     //
713     // Return values:
714     //   valid          did this BTTSTokenFactory create the BTTSToken contract?
715     //   decimals       number of decimal places for the token contract
716     //   initialSupply  the token initial supply
717     //   mintable       is the token mintable after deployment?
718     //   transferable   are the tokens transferable after deployment?
719     // ------------------------------------------------------------------------
720     function verify(address tokenContract) public view returns (
721         bool    valid,
722         address owner,
723         uint    decimals,
724         bool    mintable,
725         bool    transferable
726     ) {
727         valid = _verify[tokenContract];
728         if (valid) {
729             BTTSToken t = BTTSToken(tokenContract);
730             owner        = t.owner();
731             decimals     = t.decimals();
732             mintable     = t.mintable();
733             transferable = t.transferable();
734         }
735     }
736 
737 
738     // ------------------------------------------------------------------------
739     // Any account can call this method to deploy a new BTTSToken contract.
740     // The owner of the BTTSToken contract will be the calling account
741     //
742     // Parameters:
743     //   symbol         symbol
744     //   name           name
745     //   decimals       number of decimal places for the token contract
746     //   initialSupply  the token initial supply
747     //   mintable       is the token mintable after deployment?
748     //   transferable   are the tokens transferable after deployment?
749     //
750     // For example, deploying a BTTSToken contract with `initialSupply` of
751     // 1,000.000000000000000000 tokens:
752     //   symbol         "ME"
753     //   name           "My Token"
754     //   decimals       18
755     //   initialSupply  10000000000000000000000 = 1,000.000000000000000000
756     //                  tokens
757     //   mintable       can tokens be minted after deployment?
758     //   transferable   are the tokens transferable after deployment?
759     //
760     // The BTTSTokenListing() event is logged with the following parameters
761     //   owner          the account that execute this transaction
762     //   symbol         symbol
763     //   name           name
764     //   decimals       number of decimal places for the token contract
765     //   initialSupply  the token initial supply
766     //   mintable       can tokens be minted after deployment?
767     //   transferable   are the tokens transferable after deployment?
768     // ------------------------------------------------------------------------
769     function deployBTTSTokenContract(
770         string symbol,
771         string name,
772         uint8 decimals,
773         uint initialSupply,
774         bool mintable,
775         bool transferable
776     ) public returns (address bttsTokenAddress) {
777         bttsTokenAddress = new BTTSToken(
778             msg.sender,
779             symbol,
780             name,
781             decimals,
782             initialSupply,
783             mintable,
784             transferable);
785         // Record that this factory created the trader
786         _verify[bttsTokenAddress] = true;
787         deployedTokens.push(bttsTokenAddress);
788         BTTSTokenListing(msg.sender, bttsTokenAddress, symbol, name, decimals,
789             initialSupply, mintable, transferable);
790     }
791 
792 
793     // ------------------------------------------------------------------------
794     // Number of deployed tokens
795     // ------------------------------------------------------------------------
796     function numberOfDeployedTokens() public view returns (uint) {
797         return deployedTokens.length;
798     }
799 
800     // ------------------------------------------------------------------------
801     // Factory owner can transfer out any accidentally sent ERC20 tokens
802     //
803     // Parameters:
804     //   tokenAddress  contract address of the token contract being withdrawn
805     //                 from
806     //   tokens        number of tokens
807     // ------------------------------------------------------------------------
808     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
809         return ERC20Interface(tokenAddress).transfer(owner, tokens);
810     }
811 
812     // ------------------------------------------------------------------------
813     // Don't accept ethers
814     // ------------------------------------------------------------------------
815     function () public payable {
816         revert();
817     }
818 }