1 pragma solidity ^0.6.12;
2 /*
3  * SPDX-License-Identifier: MIT
4  */
5 pragma experimental ABIEncoderV2;
6 
7 
8 contract Verify {
9 
10   function recoverSigner(bytes32 message, bytes memory sig)
11        public
12        pure
13        returns (address)
14     {
15        uint8 v;
16        bytes32 r;
17        bytes32 s;
18 
19        (v, r, s) = splitSignature(sig);
20 
21        if (v != 27 && v != 28) {
22            return (address(0));
23        } else {
24            // solium-disable-next-line arg-overflow
25            return ecrecover(message, v, r, s);
26        }
27   }
28 
29   function splitSignature(bytes memory sig)
30        public
31        pure
32        returns (uint8, bytes32, bytes32)
33    {
34        require(sig.length == 65);
35 
36        bytes32 r;
37        bytes32 s;
38        uint8 v;
39 
40        assembly {
41            // first 32 bytes, after the length prefix
42            r := mload(add(sig, 32))
43            // second 32 bytes
44            s := mload(add(sig, 64))
45            // final byte (first byte of the next 32 bytes)
46            v := byte(0, mload(add(sig, 96)))
47        }
48 
49        if (v < 27)
50            v += 27;
51 
52        return (v, r, s);
53    }
54 }
55 
56 
57 library Endian {
58     /* https://ethereum.stackexchange.com/questions/83626/how-to-reverse-byte-order-in-uint256-or-bytes32 */
59     function reverse64(uint64 input) internal pure returns (uint64 v) {
60         v = input;
61 
62         // swap bytes
63         v = ((v & 0xFF00FF00FF00FF00) >> 8) |
64             ((v & 0x00FF00FF00FF00FF) << 8);
65 
66         // swap 2-byte long pairs
67         v = ((v & 0xFFFF0000FFFF0000) >> 16) |
68             ((v & 0x0000FFFF0000FFFF) << 16);
69 
70         // swap 4-byte long pairs
71         v = (v >> 32) | (v << 32);
72     }
73     function reverse32(uint32 input) internal pure returns (uint32 v) {
74         v = input;
75 
76         // swap bytes
77         v = ((v & 0xFF00FF00) >> 8) |
78             ((v & 0x00FF00FF) << 8);
79 
80         // swap 2-byte long pairs
81         v = (v >> 16) | (v << 16);
82     }
83     function reverse16(uint16 input) internal pure returns (uint16 v) {
84         v = input;
85 
86         // swap bytes
87         v = (v >> 8) | (v << 8);
88     }
89 }
90 
91 // ----------------------------------------------------------------------------
92 // Safe maths
93 // ----------------------------------------------------------------------------
94 library SafeMath {
95     function add(uint a, uint b) internal pure returns (uint c) {
96         c = a + b;
97         require(c >= a);
98     }
99     function sub(uint a, uint b) internal pure returns (uint c) {
100         require(b <= a);
101         c = a - b;
102     }
103     function mul(uint a, uint b) internal pure returns (uint c) {
104         c = a * b;
105         require(a == 0 || c / a == b);
106     }
107     function div(uint a, uint b) internal pure returns (uint c) {
108         require(b > 0);
109         c = a / b;
110     }
111 }
112 
113 
114 // ----------------------------------------------------------------------------
115 // ERC Token Standard #20 Interface
116 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
117 // ----------------------------------------------------------------------------
118 abstract contract ERC20Interface {
119     function totalSupply() virtual public view returns (uint);
120     function balanceOf(address tokenOwner) virtual public view returns (uint balance);
121     function allowance(address tokenOwner, address spender) virtual public view returns (uint remaining);
122     function transfer(address to, uint tokens) virtual public returns (bool success);
123     function approve(address spender, uint tokens) virtual public returns (bool success);
124     function transferFrom(address from, address to, uint tokens) virtual public returns (bool success);
125 
126     event Transfer(address indexed from, address indexed to, uint tokens);
127     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
128 }
129 
130 
131 // ----------------------------------------------------------------------------
132 // Contract function to receive approval and execute function in one call
133 //
134 // Borrowed from MiniMeToken
135 // ----------------------------------------------------------------------------
136 abstract contract ApproveAndCallFallBack {
137     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) virtual public;
138 }
139 
140 
141 // ----------------------------------------------------------------------------
142 // Owned contract
143 // ----------------------------------------------------------------------------
144 contract Owned {
145     address public owner;
146     address public newOwner;
147 
148     event OwnershipTransferred(address indexed _from, address indexed _to);
149 
150     constructor() public {
151         owner = msg.sender;
152     }
153 
154     modifier onlyOwner {
155         require(msg.sender == owner);
156         _;
157     }
158 
159     function transferOwnership(address _newOwner) public onlyOwner {
160         newOwner = _newOwner;
161     }
162 
163     function acceptOwnership() public {
164         require(msg.sender == newOwner);
165         emit OwnershipTransferred(owner, newOwner);
166         owner = newOwner;
167         newOwner = address(0);
168     }
169 }
170 
171 
172 contract Oracled is Owned {
173     mapping(address => bool) public oracles;
174 
175     modifier onlyOracle {
176         require(oracles[msg.sender] == true, "Account is not a registered oracle");
177 
178         _;
179     }
180 
181     function regOracle(address _newOracle) public onlyOwner {
182         require(!oracles[_newOracle], "Oracle is already registered");
183 
184         oracles[_newOracle] = true;
185     }
186 
187     function unregOracle(address _remOracle) public onlyOwner {
188         require(oracles[_remOracle] == true, "Oracle is not registered");
189 
190         delete oracles[_remOracle];
191     }
192 }
193 
194 // ----------------------------------------------------------------------------
195 // ERC20 Token, with the addition of symbol, name and decimals and an
196 // initial fixed supply, added teleport method
197 // ----------------------------------------------------------------------------
198 contract TeleportToken is ERC20Interface, Owned, Oracled, Verify {
199     using SafeMath for uint;
200 
201     string public symbol;
202     string public  name;
203     uint8 public decimals;
204     uint public _totalSupply;
205     uint8 public threshold;
206     uint8 public thisChainId;
207 
208     mapping(address => uint) balances;
209     mapping(address => mapping(address => uint)) allowed;
210 
211     mapping(uint64 => mapping(address => bool)) signed;
212     mapping(uint64 => bool) public claimed;
213 
214     event Teleport(address indexed from, string to, uint tokens, uint chainId);
215     event Claimed(uint64 id, address to, uint tokens);
216 
217     struct TeleportData {
218         uint64 id;
219         uint32 ts;
220         uint64 fromAddr;
221         uint64 quantity;
222         uint64 symbolRaw;
223         uint8 chainId;
224         address toAddress;
225     }
226 
227     // ------------------------------------------------------------------------
228     // Constructor
229     // ------------------------------------------------------------------------
230     constructor() public {
231         symbol = "TLM";
232         name = "Alien Worlds Trilium";
233         decimals = 4;
234         _totalSupply = 10000000000 * 10**uint(decimals);
235         balances[address(0)] = _totalSupply;
236         threshold = 3;
237         thisChainId = 1;
238     }
239 
240 
241     // ------------------------------------------------------------------------
242     // Total supply
243     // ------------------------------------------------------------------------
244     function totalSupply() override public view returns (uint) {
245         return _totalSupply - balances[address(0)];
246     }
247 
248 
249     // ------------------------------------------------------------------------
250     // Get the token balance for account `tokenOwner`
251     // ------------------------------------------------------------------------
252     function balanceOf(address tokenOwner) override public view returns (uint balance) {
253         return balances[tokenOwner];
254     }
255 
256 
257     // ------------------------------------------------------------------------
258     // Transfer the balance from token owner's account to `to` account
259     // - Owner's account must have sufficient balance to transfer
260     // - 0 value transfers are allowed
261     // ------------------------------------------------------------------------
262     function transfer(address to, uint tokens) override public returns (bool success) {
263         balances[msg.sender] = balances[msg.sender].sub(tokens);
264         balances[to] = balances[to].add(tokens);
265         emit Transfer(msg.sender, to, tokens);
266         return true;
267     }
268 
269 
270     // ------------------------------------------------------------------------
271     // Token owner can approve for `spender` to transferFrom(...) `tokens`
272     // from the token owner's account
273     //
274     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
275     // recommends that there are no checks for the approval double-spend attack
276     // as this should be implemented in user interfaces
277     // ------------------------------------------------------------------------
278     function approve(address spender, uint tokens) override public returns (bool success) {
279         allowed[msg.sender][spender] = tokens;
280         emit Approval(msg.sender, spender, tokens);
281         return true;
282     }
283 
284 
285     // ------------------------------------------------------------------------
286     // Transfer `tokens` from the `from` account to the `to` account
287     //
288     // The calling account must already have sufficient tokens approve(...)-d
289     // for spending from the `from` account and
290     // - From account must have sufficient balance to transfer
291     // - Spender must have sufficient allowance to transfer
292     // - 0 value transfers are allowed
293     // ------------------------------------------------------------------------
294     function transferFrom(address from, address to, uint tokens) override public returns (bool success) {
295         balances[from] = balances[from].sub(tokens);
296         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
297         balances[to] = balances[to].add(tokens);
298         emit Transfer(from, to, tokens);
299         return true;
300     }
301 
302 
303     // ------------------------------------------------------------------------
304     // Returns the amount of tokens approved by the owner that can be
305     // transferred to the spender's account
306     // ------------------------------------------------------------------------
307     function allowance(address tokenOwner, address spender) override public view returns (uint remaining) {
308         return allowed[tokenOwner][spender];
309     }
310 
311 
312     // ------------------------------------------------------------------------
313     // Token owner can approve for `spender` to transferFrom(...) `tokens`
314     // from the token owner's account. The `spender` contract function
315     // `receiveApproval(...)` is then executed
316     // ------------------------------------------------------------------------
317     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
318         allowed[msg.sender][spender] = tokens;
319         emit Approval(msg.sender, spender, tokens);
320         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
321         return true;
322     }
323 
324 
325     // ------------------------------------------------------------------------
326     // Moves tokens to the inaccessible account and then sends event for the oracles
327     // to monitor and issue on other chain
328     // to : EOS address
329     // tokens : number of tokens in satoshis
330     // chainId : The chain id that they will be sent to
331     // ------------------------------------------------------------------------
332 
333     function teleport(string memory to, uint tokens, uint chainid) public returns (bool success) {
334         balances[msg.sender] = balances[msg.sender].sub(tokens);
335         balances[address(0)] = balances[address(0)].add(tokens);
336         emit Teleport(msg.sender, to, tokens, chainid);
337 
338         return true;
339     }
340 
341 
342     // ------------------------------------------------------------------------
343     // Claim tokens sent using signatures supplied to the other chain
344     // ------------------------------------------------------------------------
345 
346 
347     function verifySigData(bytes memory sigData) private returns (TeleportData memory) {
348         TeleportData memory td;
349 
350         uint64 id;
351         uint32 ts;
352         uint64 fromAddr;
353         uint64 quantity;
354         uint64 symbolRaw;
355         uint8 chainId;
356         address toAddress;
357 
358         assembly {
359             id := mload(add(add(sigData, 0x8), 0))
360             ts := mload(add(add(sigData, 0x4), 8))
361             fromAddr := mload(add(add(sigData, 0x8), 12))
362             quantity := mload(add(add(sigData, 0x8), 20))
363             symbolRaw := mload(add(add(sigData, 0x8), 28))
364             chainId := mload(add(add(sigData, 0x1), 36))
365             toAddress := mload(add(add(sigData, 0x14), 37))
366         }
367 
368         td.id = Endian.reverse64(id);
369         td.ts = Endian.reverse32(ts);
370         td.fromAddr = Endian.reverse64(fromAddr);
371         td.quantity = Endian.reverse64(quantity);
372         td.symbolRaw = Endian.reverse64(symbolRaw);
373         td.chainId = chainId;
374         td.toAddress = toAddress;
375 
376         require(thisChainId == td.chainId, "Invalid Chain ID");
377         require(block.timestamp < SafeMath.add(td.ts, (60 * 60 * 24 * 30)), "Teleport has expired");
378 
379         require(!claimed[td.id], "Already Claimed");
380 
381         claimed[td.id] = true;
382 
383         return td;
384     }
385 
386     function claim(bytes memory sigData, bytes[] calldata signatures) public returns (address toAddress) {
387         TeleportData memory td = verifySigData(sigData);
388 
389         // verify signatures
390         require(sigData.length == 69, "Signature data is the wrong size");
391         require(signatures.length <= 10, "Maximum of 10 signatures can be provided");
392 
393         bytes32 message = keccak256(sigData);
394 
395         uint8 numberSigs = 0;
396 
397         for (uint8 i = 0; i < signatures.length; i++){
398             address potential = Verify.recoverSigner(message, signatures[i]);
399 
400             // Check that they are an oracle and they haven't signed twice
401             if (oracles[potential] && !signed[td.id][potential]){
402                 signed[td.id][potential] = true;
403                 numberSigs++;
404 
405                 if (numberSigs >= 10){
406                     break;
407                 }
408             }
409         }
410 
411         require(numberSigs >= threshold, "Not enough valid signatures provided");
412 
413         balances[address(0)] = balances[address(0)].sub(td.quantity);
414         balances[td.toAddress] = balances[td.toAddress].add(td.quantity);
415 
416         emit Claimed(td.id, td.toAddress, td.quantity);
417         emit Transfer(address(0), td.toAddress, td.quantity);
418 
419         return td.toAddress;
420     }
421 
422     function updateThreshold(uint8 newThreshold) public onlyOwner returns (bool success) {
423         if (newThreshold > 0){
424             require(newThreshold <= 10, "Threshold has maximum of 10");
425 
426             threshold = newThreshold;
427 
428             return true;
429         }
430 
431         return false;
432     }
433 
434     function updateChainId(uint8 newChainId) public onlyOwner returns (bool success) {
435         if (newChainId > 0){
436             require(newChainId <= 100, "ChainID is too big");
437             thisChainId = newChainId;
438 
439             return true;
440         }
441 
442         return false;
443     }
444 
445     // ------------------------------------------------------------------------
446     // Don't accept ETH
447     // ------------------------------------------------------------------------
448     receive () external payable {
449         revert();
450     }
451 
452 
453     // ------------------------------------------------------------------------
454     // Owner can transfer out any accidentally sent ERC20 tokens
455     // ------------------------------------------------------------------------
456     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
457         return ERC20Interface(tokenAddress).transfer(owner, tokens);
458     }
459 }