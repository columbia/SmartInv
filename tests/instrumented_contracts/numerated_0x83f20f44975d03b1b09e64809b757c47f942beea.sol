1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 /// SavingsDai.sol -- A tokenized representation DAI in the DSR (pot)
4 
5 // Copyright (C) 2017, 2018, 2019 dbrock, rain, mrchico
6 // Copyright (C) 2021-2022 Dai Foundation
7 //
8 // This program is free software: you can redistribute it and/or modify
9 // it under the terms of the GNU Affero General Public License as published by
10 // the Free Software Foundation, either version 3 of the License, or
11 // (at your option) any later version.
12 //
13 // This program is distributed in the hope that it will be useful,
14 // but WITHOUT ANY WARRANTY; without even the implied warranty of
15 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
16 // GNU Affero General Public License for more details.
17 //
18 // You should have received a copy of the GNU Affero General Public License
19 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
20 
21 pragma solidity ^0.8.17;
22 
23 interface IERC1271 {
24     function isValidSignature(
25         bytes32,
26         bytes memory
27     ) external view returns (bytes4);
28 }
29 
30 interface VatLike {
31     function hope(address) external;
32 }
33 
34 interface PotLike {
35     function chi() external view returns (uint256);
36     function rho() external view returns (uint256);
37     function dsr() external view returns (uint256);
38     function drip() external returns (uint256);
39     function join(uint256) external;
40     function exit(uint256) external;
41 }
42 
43 interface DaiJoinLike {
44     function vat() external view returns (address);
45     function dai() external view returns (address);
46     function join(address, uint256) external;
47     function exit(address, uint256) external;
48 }
49 
50 interface DaiLike {
51     function transferFrom(address, address, uint256) external returns (bool);
52     function approve(address, uint256) external returns (bool);
53 }
54 
55 contract SavingsDai {
56 
57     // --- ERC20 Data ---
58     string  public constant name     = "Savings Dai";
59     string  public constant symbol   = "sDAI";
60     string  public constant version  = "1";
61     uint8   public constant decimals = 18;
62     uint256 public totalSupply;
63 
64     mapping (address => uint256)                      public balanceOf;
65     mapping (address => mapping (address => uint256)) public allowance;
66     mapping (address => uint256)                      public nonces;
67 
68     // --- Data ---
69     VatLike     public immutable vat;
70     DaiJoinLike public immutable daiJoin;
71     DaiLike     public immutable dai;
72     PotLike     public immutable pot;
73 
74     // --- Events ---
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);
78     event Withdraw(address indexed sender, address indexed receiver, address indexed owner, uint256 assets, uint256 shares);
79 
80     // --- EIP712 niceties ---
81     uint256 public immutable deploymentChainId;
82     bytes32 private immutable _DOMAIN_SEPARATOR;
83     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
84     
85     uint256 private constant RAY = 10 ** 27;
86 
87     constructor(address _daiJoin, address _pot) {
88         daiJoin = DaiJoinLike(_daiJoin);
89         vat = VatLike(daiJoin.vat());
90         dai = DaiLike(daiJoin.dai());
91         pot = PotLike(_pot);
92 
93         deploymentChainId = block.chainid;
94         _DOMAIN_SEPARATOR = _calculateDomainSeparator(block.chainid);
95 
96         vat.hope(address(daiJoin));
97         vat.hope(address(pot));
98 
99         dai.approve(address(daiJoin), type(uint256).max);
100     }
101 
102     function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
103         return keccak256(
104             abi.encode(
105                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
106                 keccak256(bytes(name)),
107                 keccak256(bytes(version)),
108                 chainId,
109                 address(this)
110             )
111         );
112     }
113 
114     function DOMAIN_SEPARATOR() external view returns (bytes32) {
115         return block.chainid == deploymentChainId ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(block.chainid);
116     }
117 
118     function _rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
119         assembly {
120             switch x case 0 {switch n case 0 {z := RAY} default {z := 0}}
121             default {
122                 switch mod(n, 2) case 0 { z := RAY } default { z := x }
123                 let half := div(RAY, 2)  // for rounding.
124                 for { n := div(n, 2) } n { n := div(n,2) } {
125                     let xx := mul(x, x)
126                     if iszero(eq(div(xx, x), x)) { revert(0,0) }
127                     let xxRound := add(xx, half)
128                     if lt(xxRound, xx) { revert(0,0) }
129                     x := div(xxRound, RAY)
130                     if mod(n,2) {
131                         let zx := mul(z, x)
132                         if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
133                         let zxRound := add(zx, half)
134                         if lt(zxRound, zx) { revert(0,0) }
135                         z := div(zxRound, RAY)
136                     }
137                 }
138             }
139         }
140     }
141 
142     function _divup(uint256 x, uint256 y) internal pure returns (uint256 z) {
143         unchecked {
144             z = x != 0 ? ((x - 1) / y) + 1 : 0;
145         }
146     }
147 
148     // --- ERC20 Mutations ---
149 
150     function transfer(address to, uint256 value) external returns (bool) {
151         require(to != address(0) && to != address(this), "SavingsDai/invalid-address");
152         uint256 balance = balanceOf[msg.sender];
153         require(balance >= value, "SavingsDai/insufficient-balance");
154 
155         unchecked {
156             balanceOf[msg.sender] = balance - value;
157             balanceOf[to] += value;
158         }
159 
160         emit Transfer(msg.sender, to, value);
161 
162         return true;
163     }
164 
165     function transferFrom(address from, address to, uint256 value) external returns (bool) {
166         require(to != address(0) && to != address(this), "SavingsDai/invalid-address");
167         uint256 balance = balanceOf[from];
168         require(balance >= value, "SavingsDai/insufficient-balance");
169 
170         if (from != msg.sender) {
171             uint256 allowed = allowance[from][msg.sender];
172             if (allowed != type(uint256).max) {
173                 require(allowed >= value, "SavingsDai/insufficient-allowance");
174 
175                 unchecked {
176                     allowance[from][msg.sender] = allowed - value;
177                 }
178             }
179         }
180 
181         unchecked {
182             balanceOf[from] = balance - value;
183             balanceOf[to] += value;
184         }
185 
186         emit Transfer(from, to, value);
187 
188         return true;
189     }
190 
191     function approve(address spender, uint256 value) external returns (bool) {
192         allowance[msg.sender][spender] = value;
193 
194         emit Approval(msg.sender, spender, value);
195 
196         return true;
197     }
198 
199     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
200         uint256 newValue = allowance[msg.sender][spender] + addedValue;
201         allowance[msg.sender][spender] = newValue;
202 
203         emit Approval(msg.sender, spender, newValue);
204 
205         return true;
206     }
207 
208     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
209         uint256 allowed = allowance[msg.sender][spender];
210         require(allowed >= subtractedValue, "SavingsDai/insufficient-allowance");
211         unchecked{
212             allowed = allowed - subtractedValue;
213         }
214         allowance[msg.sender][spender] = allowed;
215 
216         emit Approval(msg.sender, spender, allowed);
217 
218         return true;
219     }
220 
221     // --- Mint/Burn Internal ---
222 
223     function _mint(uint256 assets, uint256 shares, address receiver) internal {
224         require(receiver != address(0) && receiver != address(this), "SavingsDai/invalid-address");
225 
226         dai.transferFrom(msg.sender, address(this), assets);
227         daiJoin.join(address(this), assets);
228         pot.join(shares);
229 
230         // note: we don't need an overflow check here b/c shares totalSupply will always be <= dai totalSupply
231         unchecked {
232             balanceOf[receiver] = balanceOf[receiver] + shares;
233             totalSupply = totalSupply + shares;
234         }
235 
236         emit Deposit(msg.sender, receiver, assets, shares);
237     }
238 
239     function _burn(uint256 assets, uint256 shares, address receiver, address owner) internal {
240         uint256 balance = balanceOf[owner];
241         require(balance >= shares, "SavingsDai/insufficient-balance");
242 
243         if (owner != msg.sender) {
244             uint256 allowed = allowance[owner][msg.sender];
245             if (allowed != type(uint256).max) {
246                 require(allowed >= shares, "SavingsDai/insufficient-allowance");
247 
248                 unchecked {
249                     allowance[owner][msg.sender] = allowed - shares;
250                 }
251             }
252         }
253 
254         unchecked {
255             balanceOf[owner] = balance - shares; // note: we don't need overflow checks b/c require(balance >= value) and balance <= totalSupply
256             totalSupply      = totalSupply - shares;
257         }
258 
259         pot.exit(shares);
260         daiJoin.exit(receiver, assets);
261 
262         emit Withdraw(msg.sender, receiver, owner, assets, shares);
263     }
264 
265     // --- ERC-4626 ---
266 
267     function asset() external view returns (address) {
268         return address(dai);
269     }
270 
271     function totalAssets() external view returns (uint256) {
272         return convertToAssets(totalSupply);
273     }
274 
275     function convertToShares(uint256 assets) public view returns (uint256) {
276         uint256 rho = pot.rho();
277         uint256 chi = (block.timestamp > rho) ? _rpow(pot.dsr(), block.timestamp - rho) * pot.chi() / RAY : pot.chi();
278         return assets * RAY / chi;
279     }
280 
281     function convertToAssets(uint256 shares) public view returns (uint256) {
282         uint256 rho = pot.rho();
283         uint256 chi = (block.timestamp > rho) ? _rpow(pot.dsr(), block.timestamp - rho) * pot.chi() / RAY : pot.chi();
284         return shares * chi / RAY;
285     }
286 
287     function maxDeposit(address) external pure returns (uint256) {
288         return type(uint256).max;
289     }
290 
291     function previewDeposit(uint256 assets) external view returns (uint256) {
292         return convertToShares(assets);
293     }
294 
295     function deposit(uint256 assets, address receiver) external returns (uint256 shares) {
296         uint256 chi = (block.timestamp > pot.rho()) ? pot.drip() : pot.chi();
297         shares = assets * RAY / chi;
298         _mint(assets, shares, receiver);
299     }
300 
301     function maxMint(address) external pure returns (uint256) {
302         return type(uint256).max;
303     }
304 
305     function previewMint(uint256 shares) external view returns (uint256) {
306         uint256 rho = pot.rho();
307         uint256 chi = (block.timestamp > rho) ? _rpow(pot.dsr(), block.timestamp - rho) * pot.chi() / RAY : pot.chi();
308         return _divup(shares * chi, RAY);
309     }
310 
311     function mint(uint256 shares, address receiver) external returns (uint256 assets) {
312         uint256 chi = (block.timestamp > pot.rho()) ? pot.drip() : pot.chi();
313         assets = _divup(shares * chi, RAY);
314         _mint(assets, shares, receiver);
315     }
316 
317     function maxWithdraw(address owner) external view returns (uint256) {
318         return convertToAssets(balanceOf[owner]);
319     }
320 
321     function previewWithdraw(uint256 assets) external view returns (uint256) {
322         uint256 rho = pot.rho();
323         uint256 chi = (block.timestamp > rho) ? _rpow(pot.dsr(), block.timestamp - rho) * pot.chi() / RAY : pot.chi();
324         return _divup(assets * RAY, chi);
325     }
326 
327     function withdraw(uint256 assets, address receiver, address owner) external returns (uint256 shares) {
328         uint256 chi = (block.timestamp > pot.rho()) ? pot.drip() : pot.chi();
329         shares = _divup(assets * RAY, chi);
330         _burn(assets, shares, receiver, owner);
331     }
332 
333     function maxRedeem(address owner) external view returns (uint256) {
334         return balanceOf[owner];
335     }
336 
337     function previewRedeem(uint256 shares) external view returns (uint256) {
338         return convertToAssets(shares);
339     }
340 
341     function redeem(uint256 shares, address receiver, address owner) external returns (uint256 assets) {
342         uint256 chi = (block.timestamp > pot.rho()) ? pot.drip() : pot.chi();
343         assets = shares * chi / RAY;
344         _burn(assets, shares, receiver, owner);
345     }
346 
347     // --- Approve by signature ---
348 
349     function _isValidSignature(
350         address signer,
351         bytes32 digest,
352         bytes memory signature
353     ) internal view returns (bool) {
354         if (signature.length == 65) {
355             bytes32 r;
356             bytes32 s;
357             uint8 v;
358             assembly {
359                 r := mload(add(signature, 0x20))
360                 s := mload(add(signature, 0x40))
361                 v := byte(0, mload(add(signature, 0x60)))
362             }
363             if (signer == ecrecover(digest, v, r, s)) {
364                 return true;
365             }
366         }
367 
368         (bool success, bytes memory result) = signer.staticcall(
369             abi.encodeWithSelector(IERC1271.isValidSignature.selector, digest, signature)
370         );
371         return (success &&
372             result.length == 32 &&
373             abi.decode(result, (bytes4)) == IERC1271.isValidSignature.selector);
374     }
375 
376     function permit(
377         address owner,
378         address spender,
379         uint256 value,
380         uint256 deadline,
381         bytes memory signature
382     ) public {
383         require(block.timestamp <= deadline, "SavingsDai/permit-expired");
384         require(owner != address(0), "SavingsDai/invalid-owner");
385 
386         uint256 nonce;
387         unchecked { nonce = nonces[owner]++; }
388 
389         bytes32 digest =
390             keccak256(abi.encodePacked(
391                 "\x19\x01",
392                 block.chainid == deploymentChainId ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(block.chainid),
393                 keccak256(abi.encode(
394                     PERMIT_TYPEHASH,
395                     owner,
396                     spender,
397                     value,
398                     nonce,
399                     deadline
400                 ))
401             ));
402 
403         require(_isValidSignature(owner, digest, signature), "SavingsDai/invalid-permit");
404 
405         allowance[owner][spender] = value;
406         emit Approval(owner, spender, value);
407     }
408 
409     function permit(
410         address owner,
411         address spender,
412         uint256 value,
413         uint256 deadline,
414         uint8 v,
415         bytes32 r,
416         bytes32 s
417     ) external {
418         permit(owner, spender, value, deadline, abi.encodePacked(r, s, v));
419     }
420 
421 }