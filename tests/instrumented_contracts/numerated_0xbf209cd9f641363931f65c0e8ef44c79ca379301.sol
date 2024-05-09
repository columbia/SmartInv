1 /*
2   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
3   Licensed under the Apache License, Version 2.0 (the "License");
4   you may not use this file except in compliance with the License.
5   You may obtain a copy of the License at
6   http://www.apache.org/licenses/LICENSE-2.0
7   Unless required by applicable law or agreed to in writing, software
8   distributed under the License is distributed on an "AS IS" BASIS,
9   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
10   See the License for the specific language governing permissions and
11   limitations under the License.
12 */
13 pragma solidity 0.4.21;
14 /// @title Utility Functions for address
15 /// @author Daniel Wang - <daniel@loopring.org>
16 library AddressUtil {
17     function isContract(address addr)
18         internal
19         view
20         returns (bool)
21     {
22         if (addr == 0x0) {
23             return false;
24         } else {
25             uint size;
26             assembly { size := extcodesize(addr) }
27             return size > 0;
28         }
29     }
30 }
31 /*
32   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
33   Licensed under the Apache License, Version 2.0 (the "License");
34   you may not use this file except in compliance with the License.
35   You may obtain a copy of the License at
36   http://www.apache.org/licenses/LICENSE-2.0
37   Unless required by applicable law or agreed to in writing, software
38   distributed under the License is distributed on an "AS IS" BASIS,
39   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
40   See the License for the specific language governing permissions and
41   limitations under the License.
42 */
43 /*
44     Copyright 2017 Loopring Project Ltd (Loopring Foundation).
45     Licensed under the Apache License, Version 2.0 (the "License");
46     you may not use this file except in compliance with the License.
47     You may obtain a copy of the License at
48     http://www.apache.org/licenses/LICENSE-2.0
49     Unless required by applicable law or agreed to in writing, software
50     distributed under the License is distributed on an "AS IS" BASIS,
51     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
52     See the License for the specific language governing permissions and
53     limitations under the License.
54 */
55 /*
56   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
57   Licensed under the Apache License, Version 2.0 (the "License");
58   you may not use this file except in compliance with the License.
59   You may obtain a copy of the License at
60   http://www.apache.org/licenses/LICENSE-2.0
61   Unless required by applicable law or agreed to in writing, software
62   distributed under the License is distributed on an "AS IS" BASIS,
63   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
64   See the License for the specific language governing permissions and
65   limitations under the License.
66 */
67 /// @title ERC20 Token Interface
68 /// @dev see https://github.com/ethereum/EIPs/issues/20
69 /// @author Daniel Wang - <daniel@loopring.org>
70 contract ERC20 {
71     function balanceOf(address who) view public returns (uint256);
72     function allowance(address owner, address spender) view public returns (uint256);
73     function transfer(address to, uint256 value) public returns (bool);
74     function transferFrom(address from, address to, uint256 value) public returns (bool);
75     function approve(address spender, uint256 value) public returns (bool);
76 }
77 /*
78   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
79   Licensed under the Apache License, Version 2.0 (the "License");
80   you may not use this file except in compliance with the License.
81   You may obtain a copy of the License at
82   http://www.apache.org/licenses/LICENSE-2.0
83   Unless required by applicable law or agreed to in writing, software
84   distributed under the License is distributed on an "AS IS" BASIS,
85   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
86   See the License for the specific language governing permissions and
87   limitations under the License.
88 */
89 /// @title Utility Functions for uint
90 /// @author Daniel Wang - <daniel@loopring.org>
91 library MathUint {
92     function mul(uint a, uint b) internal pure returns (uint c) {
93         c = a * b;
94         require(a == 0 || c / a == b);
95     }
96     function sub(uint a, uint b) internal pure returns (uint) {
97         require(b <= a);
98         return a - b;
99     }
100     function add(uint a, uint b) internal pure returns (uint c) {
101         c = a + b;
102         require(c >= a);
103     }
104     function tolerantSub(uint a, uint b) internal pure returns (uint c) {
105         return (a >= b) ? a - b : 0;
106     }
107     /// @dev calculate the square of Coefficient of Variation (CV)
108     /// https://en.wikipedia.org/wiki/Coefficient_of_variation
109     function cvsquare(
110         uint[] arr,
111         uint scale
112         )
113         internal
114         pure
115         returns (uint)
116     {
117         uint len = arr.length;
118         require(len > 1);
119         require(scale > 0);
120         uint avg = 0;
121         for (uint i = 0; i < len; i++) {
122             avg += arr[i];
123         }
124         avg = avg / len;
125         if (avg == 0) {
126             return 0;
127         }
128         uint cvs = 0;
129         uint s;
130         uint item;
131         for (i = 0; i < len; i++) {
132             item = arr[i];
133             s = item > avg ? item - avg : avg - item;
134             cvs += mul(s, s);
135         }
136         return ((mul(mul(cvs, scale), scale) / avg) / avg) / (len - 1);
137     }
138 }
139 /// @title ERC20 Token Implementation
140 /// @dev see https://github.com/ethereum/EIPs/issues/20
141 ///      This ERC20 token will give the designated tokenTransferDelegate a max allowance.
142 /// @author Daniel Wang - <daniel@loopring.org>
143 contract ERC20Token is ERC20 {
144     using MathUint for uint;
145     using AddressUtil for address;
146     string  public name;
147     string  public symbol;
148     uint8   public decimals;
149     uint    public totalSupply_;
150     address public tokenTransferDelegate;
151     mapping (address => uint256) balances;
152     mapping (address => mapping (address => uint256)) internal allowed;
153     event Transfer(address indexed from, address indexed to, uint256 value);
154     event Approval(address indexed owner, address indexed spender, uint256 value);
155     function ERC20Token(
156         string  _name,
157         string  _symbol,
158         uint8   _decimals,
159         uint    _totalSupply,
160         address _firstHolder,
161         address _tokenTransferDelegate
162         )
163         public
164     {
165         require(bytes(_name).length > 0);
166         require(bytes(_symbol).length > 0);
167         require(_totalSupply > 0);
168         require(_firstHolder != 0x0);
169         require(_tokenTransferDelegate.isContract());
170         name = _name;
171         symbol = _symbol;
172         decimals = _decimals;
173         totalSupply_ = _totalSupply;
174         tokenTransferDelegate = _tokenTransferDelegate;
175         balances[_firstHolder] = totalSupply_;
176     }
177     function () payable public
178     {
179         revert();
180     }
181     /**
182     * @dev total number of tokens in existence
183     */
184     function totalSupply() public view returns (uint256) {
185         return totalSupply_;
186     }
187     /**
188     * @dev transfer token for a specified address
189     * @param _to The address to transfer to.
190     * @param _value The amount to be transferred.
191     */
192     function transfer(
193         address _to,
194         uint256 _value
195         )
196         public
197         returns (bool)
198     {
199         require(_to != address(0));
200         require(_value <= balances[msg.sender]);
201         // SafeMath.sub will throw if there is not enough balance.
202         balances[msg.sender] = balances[msg.sender].sub(_value);
203         balances[_to] = balances[_to].add(_value);
204         emit Transfer(msg.sender, _to, _value);
205         return true;
206     }
207     /**
208     * @dev Gets the balance of the specified address.
209     * @param _owner The address to query the the balance of.
210     * @return An uint256 representing the amount owned by the passed address.
211     */
212     function balanceOf(address _owner)
213         public
214         view
215         returns (uint256 balance)
216     {
217         return balances[_owner];
218     }
219     /**
220      * @dev Transfer tokens from one address to another
221      * @param _from address The address which you want to send tokens from
222      * @param _to address The address which you want to transfer to
223      * @param _value uint256 the amount of tokens to be transferred
224      */
225     function transferFrom(
226         address _from,
227         address _to,
228         uint256 _value
229         )
230         public
231         returns (bool)
232     {
233         require(_to != address(0));
234         require(_value <= balances[_from]);
235         require(_value <= allowed[_from][msg.sender]);
236         balances[_from] = balances[_from].sub(_value);
237         balances[_to] = balances[_to].add(_value);
238         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
239         emit Transfer(_from, _to, _value);
240         return true;
241     }
242     /**
243      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
244      *
245      * Beware that changing an allowance with this method brings the risk that someone may use both the old
246      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
247      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
248      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249      * @param _spender The address which will spend the funds.
250      * @param _value The amount of tokens to be spent.
251      */
252     function approve(
253         address _spender,
254         uint256 _value
255         )
256         public
257         returns (bool)
258     {
259         allowed[msg.sender][_spender] = _value;
260         emit Approval(msg.sender, _spender, _value);
261         return true;
262     }
263     /**
264      * @dev Function to check the amount of tokens that an owner allowed to a spender.
265      * @param _owner address The address which owns the funds.
266      * @param _spender address The address which will spend the funds.
267      * @return A uint256 specifying the amount of tokens still available for the spender.
268      */
269     function allowance(
270         address _owner,
271         address _spender)
272         public
273         view
274         returns (uint256)
275     {
276         if (_spender == tokenTransferDelegate) {
277             return totalSupply_;
278         } else {
279             return allowed[_owner][_spender];
280         }
281     }
282     /**
283      * @dev Increase the amount of tokens that an owner allowed to a spender.
284      *
285      * approve should be called when allowed[_spender] == 0. To increment
286      * allowed value is better to use this function to avoid 2 calls (and wait until
287      * the first transaction is mined)
288      * From MonolithDAO Token.sol
289      * @param _spender The address which will spend the funds.
290      * @param _addedValue The amount of tokens to increase the allowance by.
291      */
292     function increaseApproval(
293         address _spender,
294         uint _addedValue
295         )
296         public
297         returns (bool)
298     {
299         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
300         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301         return true;
302     }
303     /**
304      * @dev Decrease the amount of tokens that an owner allowed to a spender.
305      *
306      * approve should be called when allowed[_spender] == 0. To decrement
307      * allowed value is better to use this function to avoid 2 calls (and wait until
308      * the first transaction is mined)
309      * From MonolithDAO Token.sol
310      * @param _spender The address which will spend the funds.
311      * @param _subtractedValue The amount of tokens to decrease the allowance by.
312      */
313     function decreaseApproval(
314         address _spender,
315         uint _subtractedValue
316         )
317         public
318         returns (bool)
319     {
320         uint oldValue = allowed[msg.sender][_spender];
321         if (_subtractedValue > oldValue) {
322             allowed[msg.sender][_spender] = 0;
323         } else {
324             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
325         }
326         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
327         return true;
328     }
329 }
330 /*
331   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
332   Licensed under the Apache License, Version 2.0 (the "License");
333   you may not use this file except in compliance with the License.
334   You may obtain a copy of the License at
335   http://www.apache.org/licenses/LICENSE-2.0
336   Unless required by applicable law or agreed to in writing, software
337   distributed under the License is distributed on an "AS IS" BASIS,
338   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
339   See the License for the specific language governing permissions and
340   limitations under the License.
341 */
342 /*
343   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
344   Licensed under the Apache License, Version 2.0 (the "License");
345   you may not use this file except in compliance with the License.
346   You may obtain a copy of the License at
347   http://www.apache.org/licenses/LICENSE-2.0
348   Unless required by applicable law or agreed to in writing, software
349   distributed under the License is distributed on an "AS IS" BASIS,
350   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
351   See the License for the specific language governing permissions and
352   limitations under the License.
353 */
354 /*
355   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
356   Licensed under the Apache License, Version 2.0 (the "License");
357   you may not use this file except in compliance with the License.
358   You may obtain a copy of the License at
359   http://www.apache.org/licenses/LICENSE-2.0
360   Unless required by applicable law or agreed to in writing, software
361   distributed under the License is distributed on an "AS IS" BASIS,
362   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
363   See the License for the specific language governing permissions and
364   limitations under the License.
365 */
366 /// @title Ownable
367 /// @dev The Ownable contract has an owner address, and provides basic
368 ///      authorization control functions, this simplifies the implementation of
369 ///      "user permissions".
370 contract Ownable {
371     address public owner;
372     event OwnershipTransferred(
373         address indexed previousOwner,
374         address indexed newOwner
375     );
376     /// @dev The Ownable constructor sets the original `owner` of the contract
377     ///      to the sender.
378     function Ownable() public {
379         owner = msg.sender;
380     }
381     /// @dev Throws if called by any account other than the owner.
382     modifier onlyOwner() {
383         require(msg.sender == owner);
384         _;
385     }
386     /// @dev Allows the current owner to transfer control of the contract to a
387     ///      newOwner.
388     /// @param newOwner The address to transfer ownership to.
389     function transferOwnership(address newOwner) onlyOwner public {
390         require(newOwner != 0x0);
391         emit OwnershipTransferred(owner, newOwner);
392         owner = newOwner;
393     }
394 }
395 /// @title Claimable
396 /// @dev Extension for the Ownable contract, where the ownership needs
397 ///      to be claimed. This allows the new owner to accept the transfer.
398 contract Claimable is Ownable {
399     address public pendingOwner;
400     /// @dev Modifier throws if called by any account other than the pendingOwner.
401     modifier onlyPendingOwner() {
402         require(msg.sender == pendingOwner);
403         _;
404     }
405     /// @dev Allows the current owner to set the pendingOwner address.
406     /// @param newOwner The address to transfer ownership to.
407     function transferOwnership(address newOwner) onlyOwner public {
408         require(newOwner != 0x0 && newOwner != owner);
409         pendingOwner = newOwner;
410     }
411     /// @dev Allows the pendingOwner address to finalize the transfer.
412     function claimOwnership() onlyPendingOwner public {
413         emit OwnershipTransferred(owner, pendingOwner);
414         owner = pendingOwner;
415         pendingOwner = 0x0;
416     }
417 }
418 /// @title Token Register Contract
419 /// @dev This contract maintains a list of tokens the Protocol supports.
420 /// @author Kongliang Zhong - <kongliang@loopring.org>,
421 /// @author Daniel Wang - <daniel@loopring.org>.
422 contract TokenRegistry is Claimable {
423     using AddressUtil for address;
424     address tokenMintAddr;
425     address[] public addresses;
426     mapping (address => TokenInfo) addressMap;
427     mapping (string => address) symbolMap;
428     ////////////////////////////////////////////////////////////////////////////
429     /// Structs                                                              ///
430     ////////////////////////////////////////////////////////////////////////////
431     struct TokenInfo {
432         uint   pos;      // 0 mens unregistered; if > 0, pos + 1 is the
433                          // token's position in `addresses`.
434         string symbol;   // Symbol of the token
435     }
436     ////////////////////////////////////////////////////////////////////////////
437     /// Events                                                               ///
438     ////////////////////////////////////////////////////////////////////////////
439     event TokenRegistered(address addr, string symbol);
440     event TokenUnregistered(address addr, string symbol);
441     ////////////////////////////////////////////////////////////////////////////
442     /// Public Functions                                                     ///
443     ////////////////////////////////////////////////////////////////////////////
444     /// @dev Disable default function.
445     function () payable public {
446         revert();
447     }
448     function TokenRegistry(address _tokenMintAddr) public
449     {
450         require(_tokenMintAddr.isContract());
451         tokenMintAddr = _tokenMintAddr;
452     }
453     function registerToken(
454         address addr,
455         string  symbol
456         )
457         external
458         onlyOwner
459     {
460         registerTokenInternal(addr, symbol);
461     }
462     function registerMintedToken(
463         address addr,
464         string  symbol
465         )
466         external
467     {
468         require(msg.sender == tokenMintAddr);
469         registerTokenInternal(addr, symbol);
470     }
471     function unregisterToken(
472         address addr,
473         string  symbol
474         )
475         external
476         onlyOwner
477     {
478         require(addr != 0x0);
479         require(symbolMap[symbol] == addr);
480         delete symbolMap[symbol];
481         uint pos = addressMap[addr].pos;
482         require(pos != 0);
483         delete addressMap[addr];
484         // We will replace the token we need to unregister with the last token
485         // Only the pos of the last token will need to be updated
486         address lastToken = addresses[addresses.length - 1];
487         // Don't do anything if the last token is the one we want to delete
488         if (addr != lastToken) {
489             // Swap with the last token and update the pos
490             addresses[pos - 1] = lastToken;
491             addressMap[lastToken].pos = pos;
492         }
493         addresses.length--;
494         emit TokenUnregistered(addr, symbol);
495     }
496     function areAllTokensRegistered(address[] addressList)
497         external
498         view
499         returns (bool)
500     {
501         for (uint i = 0; i < addressList.length; i++) {
502             if (addressMap[addressList[i]].pos == 0) {
503                 return false;
504             }
505         }
506         return true;
507     }
508     function getAddressBySymbol(string symbol)
509         external
510         view
511         returns (address)
512     {
513         return symbolMap[symbol];
514     }
515     function isTokenRegisteredBySymbol(string symbol)
516         public
517         view
518         returns (bool)
519     {
520         return symbolMap[symbol] != 0x0;
521     }
522     function isTokenRegistered(address addr)
523         public
524         view
525         returns (bool)
526     {
527         return addressMap[addr].pos != 0;
528     }
529     function getTokens(
530         uint start,
531         uint count
532         )
533         public
534         view
535         returns (address[] addressList)
536     {
537         uint num = addresses.length;
538         if (start >= num) {
539             return;
540         }
541         uint end = start + count;
542         if (end > num) {
543             end = num;
544         }
545         if (start == num) {
546             return;
547         }
548         addressList = new address[](end - start);
549         for (uint i = start; i < end; i++) {
550             addressList[i - start] = addresses[i];
551         }
552     }
553     function registerTokenInternal(
554         address addr,
555         string  symbol
556         )
557         internal
558     {
559         require(0x0 != addr);
560         require(bytes(symbol).length > 0);
561         require(0x0 == symbolMap[symbol]);
562         require(0 == addressMap[addr].pos);
563         addresses.push(addr);
564         symbolMap[symbol] = addr;
565         addressMap[addr] = TokenInfo(addresses.length, symbol);
566         emit TokenRegistered(addr, symbol);
567     }
568 }
569 /// @title ERC20 Token Mint
570 /// @dev This contract deploys ERC20 token contract and registered the contract
571 ///      so the token can be traded with Loopring Protocol.
572 /// @author Kongliang Zhong - <kongliang@loopring.org>,
573 /// @author Daniel Wang - <daniel@loopring.org>.
574 contract TokenCreator {
575     using AddressUtil for address;
576     address[] public tokens;
577     address   public tokenRegistry;
578     address   public tokenTransferDelegate;
579     event TokenCreated(
580         address indexed addr,
581         string  name,
582         string  symbol,
583         uint8   decimals,
584         uint    totalSupply,
585         address firstHolder,
586         address tokenTransferDelegate
587     );
588     /// @dev Disable default function.
589     function () payable public
590     {
591         revert();
592     }
593     /// @dev Initialize TokenRegistry address.
594     ///      This method sjhall be called immediately upon deployment.
595     function initialize(
596         address _tokenRegistry,
597         address _tokenTransferDelegate
598         )
599         public
600     {
601         require(tokenRegistry == 0x0 && _tokenRegistry.isContract());
602         tokenRegistry = _tokenRegistry;
603         require(tokenTransferDelegate == 0x0 && _tokenTransferDelegate.isContract());
604         tokenTransferDelegate = _tokenTransferDelegate;
605     }
606     /// @dev Deploy an ERC20 token contract, register it with TokenRegistry,
607     ///      and returns the new token's address.
608     /// @param name The name of the token
609     /// @param symbol The symbol of the token.
610     /// @param decimals The decimals of the token.
611     /// @param totalSupply The total supply of the token.
612     function createToken(
613         string  name,
614         string  symbol,
615         uint8   decimals,
616         uint    totalSupply
617         )
618         public
619         returns (address addr)
620     {
621         require(tokenRegistry != 0x0);
622         require(tokenTransferDelegate != 0x0);
623         ERC20Token token = new ERC20Token(
624             name,
625             symbol,
626             decimals,
627             totalSupply,
628             tx.origin,
629             tokenTransferDelegate
630         );
631         addr = address(token);
632         TokenRegistry(tokenRegistry).registerMintedToken(addr, symbol);
633         tokens.push(addr);
634         emit TokenCreated(
635             addr,
636             name,
637             symbol,
638             decimals,
639             totalSupply,
640             tx.origin,
641             tokenTransferDelegate
642         );
643     }
644 }