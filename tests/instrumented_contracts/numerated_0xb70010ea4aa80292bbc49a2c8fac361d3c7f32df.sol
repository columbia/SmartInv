1 // hevm: flattened sources of src/LightPoolWrapper.sol
2 pragma solidity ^0.4.21;
3 
4 ////// lib/ds-roles/lib/ds-auth/src/auth.sol
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
18 /* pragma solidity ^0.4.13; */
19 
20 contract DSAuthority {
21     function canCall(
22         address src, address dst, bytes4 sig
23     ) public view returns (bool);
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
35     function DSAuth() public {
36         owner = msg.sender;
37         LogSetOwner(msg.sender);
38     }
39 
40     function setOwner(address owner_)
41         public
42         auth
43     {
44         owner = owner_;
45         LogSetOwner(owner);
46     }
47 
48     function setAuthority(DSAuthority authority_)
49         public
50         auth
51     {
52         authority = authority_;
53         LogSetAuthority(authority);
54     }
55 
56     modifier auth {
57         require(isAuthorized(msg.sender, msg.sig));
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
69             return authority.canCall(src, this, sig);
70         }
71     }
72 }
73 
74 ////// lib/lightpool-contracts/src/interfaces/ERC20.sol
75 /* pragma solidity ^0.4.21; */
76 
77 contract ERC20Events {
78     event Approval(address indexed src, address indexed guy, uint wad);
79     event Transfer(address indexed src, address indexed dst, uint wad);
80 }
81 
82 contract ERC20 is ERC20Events {
83     function decimals() public view returns (uint);
84     function totalSupply() public view returns (uint);
85     function balanceOf(address guy) public view returns (uint);
86     function allowance(address src, address guy) public view returns (uint);
87 
88     function approve(address guy, uint wad) public returns (bool);
89     function transfer(address dst, uint wad) public returns (bool);
90     function transferFrom(address src, address dst, uint wad) public returns (bool);
91 }
92 
93 ////// lib/lightpool-contracts/src/interfaces/PriceSanityInterface.sol
94 /* pragma solidity ^0.4.21; */
95 
96 contract PriceSanityInterface {
97     function checkPrice(address base, address quote, bool buy, uint256 baseAmount, uint256 quoteAmount) external view returns (bool result);
98 }
99 
100 ////// lib/lightpool-contracts/src/interfaces/WETHInterface.sol
101 /* pragma solidity ^0.4.21; */
102 
103 /* import "./ERC20.sol"; */
104 
105 contract WETHInterface is ERC20 {
106   function() external payable;
107   function deposit() external payable;
108   function withdraw(uint wad) external;
109 }
110 
111 ////// lib/lightpool-contracts/src/LightPool.sol
112 /* pragma solidity ^0.4.21; */
113 
114 /* import "./interfaces/WETHInterface.sol"; */
115 /* import "./interfaces/PriceSanityInterface.sol"; */
116 /* import "./interfaces/ERC20.sol"; */
117 
118 contract LightPool {
119     uint16 constant public EXTERNAL_QUERY_GAS_LIMIT = 4999;    // Changes to state require at least 5000 gas
120 
121     struct TokenData {
122         address walletAddress;
123         PriceSanityInterface priceSanityContract;
124     }
125 
126     // key = keccak256(token, base, walletAddress)
127     mapping(bytes32 => TokenData)       public markets;
128     mapping(address => bool)            public traders;
129     address                             public owner;
130 
131     modifier onlyOwner() {
132         require(msg.sender == owner);
133         _;
134     }
135 
136     modifier onlyWalletAddress(address base, address quote) {
137         bytes32 key = keccak256(base, quote, msg.sender);
138         require(markets[key].walletAddress == msg.sender);
139         _;
140     }
141 
142     modifier onlyTrader() {
143         require(traders[msg.sender]);
144         _;
145     }
146 
147     function LightPool() public {
148         owner = msg.sender;
149     }
150 
151     function setTrader(address trader, bool enabled) onlyOwner external {
152         traders[trader] = enabled;
153     }
154 
155     function setOwner(address _owner) onlyOwner external {
156         require(_owner != address(0));
157         owner = _owner;
158     }
159 
160     event AddMarket(address indexed base, address indexed quote, address indexed walletAddress, address priceSanityContract);
161     function addMarket(ERC20 base, ERC20 quote, PriceSanityInterface priceSanityContract) external {
162         require(base != address(0));
163         require(quote != address(0));
164 
165         // Make sure there's no such configured token
166         bytes32 tokenHash = keccak256(base, quote, msg.sender);
167         require(markets[tokenHash].walletAddress == address(0));
168 
169         // Initialize token pool data
170         markets[tokenHash] = TokenData(msg.sender, priceSanityContract);
171         emit AddMarket(base, quote, msg.sender, priceSanityContract);
172     }
173 
174     event RemoveMarket(address indexed base, address indexed quote, address indexed walletAddress);
175     function removeMarket(ERC20 base, ERC20 quote) onlyWalletAddress(base, quote) external {
176         bytes32 tokenHash = keccak256(base, quote, msg.sender);
177         TokenData storage tokenData = markets[tokenHash];
178 
179         emit RemoveMarket(base, quote, tokenData.walletAddress);
180         delete markets[tokenHash];
181     }
182 
183     event ChangePriceSanityContract(address indexed base, address indexed quote, address indexed walletAddress, address priceSanityContract);
184     function changePriceSanityContract(ERC20 base, ERC20 quote, PriceSanityInterface _priceSanityContract) onlyWalletAddress(base, quote) external {
185         bytes32 tokenHash = keccak256(base, quote, msg.sender);
186         TokenData storage tokenData = markets[tokenHash];
187         tokenData.priceSanityContract = _priceSanityContract;
188         emit ChangePriceSanityContract(base, quote, msg.sender, _priceSanityContract);
189     }
190 
191     event Trade(address indexed trader, address indexed baseToken, address indexed quoteToken, address walletAddress, bool buy, uint256 baseAmount, uint256 quoteAmount);
192     function trade(ERC20 base, ERC20 quote, address walletAddress, bool buy, uint256 baseAmount, uint256 quoteAmount) onlyTrader external {
193         bytes32 tokenHash = keccak256(base, quote, walletAddress);
194         TokenData storage tokenData = markets[tokenHash];
195         require(tokenData.walletAddress != address(0));
196         if (tokenData.priceSanityContract != address(0)) {
197             require(tokenData.priceSanityContract.checkPrice.gas(EXTERNAL_QUERY_GAS_LIMIT)(base, quote, buy, baseAmount, quoteAmount)); // Limit gas to prevent reentrancy
198         }
199         ERC20 takenToken;
200         ERC20 givenToken;
201         uint256 takenTokenAmount;
202         uint256 givenTokenAmount;
203         if (buy) {
204             takenToken = quote;
205             givenToken = base;
206             takenTokenAmount = quoteAmount;
207             givenTokenAmount = baseAmount;
208         } else {
209             takenToken = base;
210             givenToken = quote;
211             takenTokenAmount = baseAmount;
212             givenTokenAmount = quoteAmount;
213         }
214         require(takenTokenAmount != 0 && givenTokenAmount != 0);
215 
216         // Swap!
217         require(takenToken.transferFrom(msg.sender, tokenData.walletAddress, takenTokenAmount));
218         require(givenToken.transferFrom(tokenData.walletAddress, msg.sender, givenTokenAmount));
219         emit Trade(msg.sender, base, quote, walletAddress, buy, baseAmount, quoteAmount);
220     }
221 }
222 
223 ////// lib/lpc/lib/ds-token/lib/ds-math/src/math.sol
224 /// math.sol -- mixin for inline numerical wizardry
225 
226 // This program is free software: you can redistribute it and/or modify
227 // it under the terms of the GNU General Public License as published by
228 // the Free Software Foundation, either version 3 of the License, or
229 // (at your option) any later version.
230 
231 // This program is distributed in the hope that it will be useful,
232 // but WITHOUT ANY WARRANTY; without even the implied warranty of
233 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
234 // GNU General Public License for more details.
235 
236 // You should have received a copy of the GNU General Public License
237 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
238 
239 /* pragma solidity ^0.4.13; */
240 
241 contract DSMath {
242     function add(uint x, uint y) internal pure returns (uint z) {
243         require((z = x + y) >= x);
244     }
245     function sub(uint x, uint y) internal pure returns (uint z) {
246         require((z = x - y) <= x);
247     }
248     function mul(uint x, uint y) internal pure returns (uint z) {
249         require(y == 0 || (z = x * y) / y == x);
250     }
251 
252     function min(uint x, uint y) internal pure returns (uint z) {
253         return x <= y ? x : y;
254     }
255     function max(uint x, uint y) internal pure returns (uint z) {
256         return x >= y ? x : y;
257     }
258     function imin(int x, int y) internal pure returns (int z) {
259         return x <= y ? x : y;
260     }
261     function imax(int x, int y) internal pure returns (int z) {
262         return x >= y ? x : y;
263     }
264 
265     uint constant WAD = 10 ** 18;
266     uint constant RAY = 10 ** 27;
267 
268     function wmul(uint x, uint y) internal pure returns (uint z) {
269         z = add(mul(x, y), WAD / 2) / WAD;
270     }
271     function rmul(uint x, uint y) internal pure returns (uint z) {
272         z = add(mul(x, y), RAY / 2) / RAY;
273     }
274     function wdiv(uint x, uint y) internal pure returns (uint z) {
275         z = add(mul(x, WAD), y / 2) / y;
276     }
277     function rdiv(uint x, uint y) internal pure returns (uint z) {
278         z = add(mul(x, RAY), y / 2) / y;
279     }
280 
281     // This famous algorithm is called "exponentiation by squaring"
282     // and calculates x^n with x as fixed-point and n as regular unsigned.
283     //
284     // It's O(log n), instead of O(n) for naive repeated multiplication.
285     //
286     // These facts are why it works:
287     //
288     //  If n is even, then x^n = (x^2)^(n/2).
289     //  If n is odd,  then x^n = x * x^(n-1),
290     //   and applying the equation for even x gives
291     //    x^n = x * (x^2)^((n-1) / 2).
292     //
293     //  Also, EVM division is flooring and
294     //    floor[(n-1) / 2] = floor[n / 2].
295     //
296     function rpow(uint x, uint n) internal pure returns (uint z) {
297         z = n % 2 != 0 ? x : RAY;
298 
299         for (n /= 2; n != 0; n /= 2) {
300             x = rmul(x, x);
301 
302             if (n % 2 != 0) {
303                 z = rmul(z, x);
304             }
305         }
306     }
307 }
308 
309 ////// lib/lpc/lib/ds-token/lib/ds-stop/lib/ds-note/src/note.sol
310 /// note.sol -- the `note' modifier, for logging calls as events
311 
312 // This program is free software: you can redistribute it and/or modify
313 // it under the terms of the GNU General Public License as published by
314 // the Free Software Foundation, either version 3 of the License, or
315 // (at your option) any later version.
316 
317 // This program is distributed in the hope that it will be useful,
318 // but WITHOUT ANY WARRANTY; without even the implied warranty of
319 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
320 // GNU General Public License for more details.
321 
322 // You should have received a copy of the GNU General Public License
323 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
324 
325 /* pragma solidity ^0.4.13; */
326 
327 contract DSNote {
328     event LogNote(
329         bytes4   indexed  sig,
330         address  indexed  guy,
331         bytes32  indexed  foo,
332         bytes32  indexed  bar,
333         uint              wad,
334         bytes             fax
335     ) anonymous;
336 
337     modifier note {
338         bytes32 foo;
339         bytes32 bar;
340 
341         assembly {
342             foo := calldataload(4)
343             bar := calldataload(36)
344         }
345 
346         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
347 
348         _;
349     }
350 }
351 
352 ////// lib/lpc/lib/ds-value/lib/ds-thing/src/thing.sol
353 // thing.sol - `auth` with handy mixins. your things should be DSThings
354 
355 // Copyright (C) 2017  DappHub, LLC
356 
357 // This program is free software: you can redistribute it and/or modify
358 // it under the terms of the GNU General Public License as published by
359 // the Free Software Foundation, either version 3 of the License, or
360 // (at your option) any later version.
361 
362 // This program is distributed in the hope that it will be useful,
363 // but WITHOUT ANY WARRANTY; without even the implied warranty of
364 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
365 // GNU General Public License for more details.
366 
367 // You should have received a copy of the GNU General Public License
368 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
369 
370 /* pragma solidity ^0.4.13; */
371 
372 /* import 'ds-auth/auth.sol'; */
373 /* import 'ds-note/note.sol'; */
374 /* import 'ds-math/math.sol'; */
375 
376 contract DSThing is DSAuth, DSNote, DSMath {
377 
378     function S(string s) internal pure returns (bytes4) {
379         return bytes4(keccak256(s));
380     }
381 
382 }
383 
384 ////// src/LightPoolWrapper.sol
385 /* pragma solidity ^0.4.21; */
386 
387 /* import "ds-thing/thing.sol"; */
388 /* import "lightpool-contracts/LightPool.sol"; */
389 
390 contract WETH is WETHInterface { }
391 
392 contract LightPoolWrapper is DSThing {
393     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
394 
395     address public reserve;
396     LightPool public lightpool;
397     mapping(address => bool) public whitelistedWallets;
398 
399     function LightPoolWrapper(address reserve_, LightPool lightpool_) public {
400         assert(address(reserve_) != 0);
401         assert(address(lightpool_) != 0);
402 
403         reserve = reserve_;
404         lightpool = lightpool_;
405     }
406 
407     function switchLightPool(LightPool lightpool_) public note auth {
408         assert(address(lightpool_) != 0);
409         lightpool = lightpool_;
410     }
411 
412     function switchReserve(address reserve_) public note auth {
413         assert(address(reserve_) != 0);
414         reserve = reserve_;
415     }
416 
417     function approveToken(ERC20 token, address spender, uint amount) public note auth {
418         require(token.approve(spender, amount));
419     }
420 
421     function setWhitelistedWallet(address walletAddress_, bool whitelisted) public note auth {
422         whitelistedWallets[walletAddress_] = whitelisted;
423     }
424 
425     event Trade(
426         address indexed origin,
427         address indexed srcToken,
428         uint srcAmount,
429         address indexed destToken,
430         uint destAmount,
431         address destAddress
432     );
433 
434     function trade(ERC20 base, ERC20 quote, address walletAddress, bool buy, uint256 baseAmount, uint256 quoteAmount) public auth {
435         require(whitelistedWallets[walletAddress]);
436 
437         ERC20 takenToken;
438         uint takenAmount;
439         ERC20 givenToken;
440         uint givenAmount;
441 
442         if (buy) {
443             takenToken = base;
444             takenAmount = baseAmount;
445             givenToken = quote;
446             givenAmount = quoteAmount;
447         } else {
448             takenToken = quote;
449             takenAmount = quoteAmount;
450             givenToken = base;
451             givenAmount = baseAmount;
452         }
453 
454         require(givenToken.transferFrom(reserve, this, givenAmount));
455         lightpool.trade(base, quote, walletAddress, buy, baseAmount, quoteAmount);
456         require(takenToken.transfer(reserve, takenAmount));
457 
458         emit Trade(reserve, givenToken, givenAmount, takenToken, takenAmount, walletAddress);
459     }
460 
461     function withdraw(ERC20 token, uint amount, address destination) public note auth {
462         if (token == ETH_TOKEN_ADDRESS) {
463             destination.transfer(amount);
464         } else {
465             require(token.transfer(destination, amount));
466         }
467     }
468 }