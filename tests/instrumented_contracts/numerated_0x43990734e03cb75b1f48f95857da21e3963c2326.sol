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
15 /// @author Kongliang Zhong - <kongliang@loopring.org>
16 library StringUtil {
17     function stringToBytes12(string str)
18         internal
19         pure
20         returns (bytes12 result)
21     {
22         assembly {
23             result := mload(add(str, 32))
24         }
25     }
26     function stringToBytes10(string str)
27         internal
28         pure
29         returns (bytes10 result)
30     {
31         assembly {
32             result := mload(add(str, 32))
33         }
34     }
35     /// check length >= min && <= max
36     function checkStringLength(string name, uint min, uint max)
37         internal
38         pure
39         returns (bool)
40     {
41         bytes memory temp = bytes(name);
42         return temp.length >= min && temp.length <= max;
43     }
44 }
45 /*
46   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
47   Licensed under the Apache License, Version 2.0 (the "License");
48   you may not use this file except in compliance with the License.
49   You may obtain a copy of the License at
50   http://www.apache.org/licenses/LICENSE-2.0
51   Unless required by applicable law or agreed to in writing, software
52   distributed under the License is distributed on an "AS IS" BASIS,
53   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
54   See the License for the specific language governing permissions and
55   limitations under the License.
56 */
57 /// @title Utility Functions for address
58 /// @author Daniel Wang - <daniel@loopring.org>
59 library AddressUtil {
60     function isContract(address addr)
61         internal
62         view
63         returns (bool)
64     {
65         if (addr == 0x0) {
66             return false;
67         } else {
68             uint size;
69             assembly { size := extcodesize(addr) }
70             return size > 0;
71         }
72     }
73 }
74 /*
75   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
76   Licensed under the Apache License, Version 2.0 (the "License");
77   you may not use this file except in compliance with the License.
78   You may obtain a copy of the License at
79   http://www.apache.org/licenses/LICENSE-2.0
80   Unless required by applicable law or agreed to in writing, software
81   distributed under the License is distributed on an "AS IS" BASIS,
82   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
83   See the License for the specific language governing permissions and
84   limitations under the License.
85 */
86 /*
87     Copyright 2017 Loopring Project Ltd (Loopring Foundation).
88     Licensed under the Apache License, Version 2.0 (the "License");
89     you may not use this file except in compliance with the License.
90     You may obtain a copy of the License at
91     http://www.apache.org/licenses/LICENSE-2.0
92     Unless required by applicable law or agreed to in writing, software
93     distributed under the License is distributed on an "AS IS" BASIS,
94     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
95     See the License for the specific language governing permissions and
96     limitations under the License.
97 */
98 /*
99   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
100   Licensed under the Apache License, Version 2.0 (the "License");
101   you may not use this file except in compliance with the License.
102   You may obtain a copy of the License at
103   http://www.apache.org/licenses/LICENSE-2.0
104   Unless required by applicable law or agreed to in writing, software
105   distributed under the License is distributed on an "AS IS" BASIS,
106   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
107   See the License for the specific language governing permissions and
108   limitations under the License.
109 */
110 /// @title ERC20 Token Interface
111 /// @dev see https://github.com/ethereum/EIPs/issues/20
112 /// @author Daniel Wang - <daniel@loopring.org>
113 contract ERC20 {
114     function balanceOf(address who) view public returns (uint256);
115     function allowance(address owner, address spender) view public returns (uint256);
116     function transfer(address to, uint256 value) public returns (bool);
117     function transferFrom(address from, address to, uint256 value) public returns (bool);
118     function approve(address spender, uint256 value) public returns (bool);
119 }
120 /*
121   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
122   Licensed under the Apache License, Version 2.0 (the "License");
123   you may not use this file except in compliance with the License.
124   You may obtain a copy of the License at
125   http://www.apache.org/licenses/LICENSE-2.0
126   Unless required by applicable law or agreed to in writing, software
127   distributed under the License is distributed on an "AS IS" BASIS,
128   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
129   See the License for the specific language governing permissions and
130   limitations under the License.
131 */
132 /// @title Utility Functions for uint
133 /// @author Daniel Wang - <daniel@loopring.org>
134 library MathUint {
135     function mul(uint a, uint b) internal pure returns (uint c) {
136         c = a * b;
137         require(a == 0 || c / a == b);
138     }
139     function sub(uint a, uint b) internal pure returns (uint) {
140         require(b <= a);
141         return a - b;
142     }
143     function add(uint a, uint b) internal pure returns (uint c) {
144         c = a + b;
145         require(c >= a);
146     }
147     function tolerantSub(uint a, uint b) internal pure returns (uint c) {
148         return (a >= b) ? a - b : 0;
149     }
150     /// @dev calculate the square of Coefficient of Variation (CV)
151     /// https://en.wikipedia.org/wiki/Coefficient_of_variation
152     function cvsquare(
153         uint[] arr,
154         uint scale
155         )
156         internal
157         pure
158         returns (uint)
159     {
160         uint len = arr.length;
161         require(len > 1);
162         require(scale > 0);
163         uint avg = 0;
164         for (uint i = 0; i < len; i++) {
165             avg += arr[i];
166         }
167         avg = avg / len;
168         if (avg == 0) {
169             return 0;
170         }
171         uint cvs = 0;
172         uint s;
173         uint item;
174         for (i = 0; i < len; i++) {
175             item = arr[i];
176             s = item > avg ? item - avg : avg - item;
177             cvs += mul(s, s);
178         }
179         return ((mul(mul(cvs, scale), scale) / avg) / avg) / (len - 1);
180     }
181 }
182 /// @title ERC20 Token Implementation
183 /// @dev see https://github.com/ethereum/EIPs/issues/20
184 /// @author Daniel Wang - <daniel@loopring.org>
185 contract ERC20Token is ERC20 {
186     using MathUint for uint;
187     string  public name;
188     string  public symbol;
189     uint8   public decimals;
190     uint    public totalSupply_;
191     mapping (address => uint256) balances;
192     mapping (address => mapping (address => uint256)) internal allowed;
193     event Transfer(address indexed from, address indexed to, uint256 value);
194     event Approval(address indexed owner, address indexed spender, uint256 value);
195     function ERC20Token(
196         string  _name,
197         string  _symbol,
198         uint8   _decimals,
199         uint    _totalSupply,
200         address _firstHolder
201         )
202         public
203     {
204         require(bytes(_name).length > 0);
205         require(bytes(_symbol).length > 0);
206         require(_totalSupply > 0);
207         require(_firstHolder != 0x0);
208         name = _name;
209         symbol = _symbol;
210         decimals = _decimals;
211         totalSupply_ = _totalSupply;
212         balances[_firstHolder] = totalSupply_;
213     }
214     function () payable public
215     {
216         revert();
217     }
218     /**
219     * @dev total number of tokens in existence
220     */
221     function totalSupply() public view returns (uint256) {
222         return totalSupply_;
223     }
224     /**
225     * @dev transfer token for a specified address
226     * @param _to The address to transfer to.
227     * @param _value The amount to be transferred.
228     */
229     function transfer(
230         address _to,
231         uint256 _value
232         )
233         public
234         returns (bool)
235     {
236         require(_to != address(0));
237         require(_value <= balances[msg.sender]);
238         // SafeMath.sub will throw if there is not enough balance.
239         balances[msg.sender] = balances[msg.sender].sub(_value);
240         balances[_to] = balances[_to].add(_value);
241         emit Transfer(msg.sender, _to, _value);
242         return true;
243     }
244     /**
245     * @dev Gets the balance of the specified address.
246     * @param _owner The address to query the the balance of.
247     * @return An uint256 representing the amount owned by the passed address.
248     */
249     function balanceOf(address _owner)
250         public
251         view
252         returns (uint256 balance)
253     {
254         return balances[_owner];
255     }
256     /**
257      * @dev Transfer tokens from one address to another
258      * @param _from address The address which you want to send tokens from
259      * @param _to address The address which you want to transfer to
260      * @param _value uint256 the amount of tokens to be transferred
261      */
262     function transferFrom(
263         address _from,
264         address _to,
265         uint256 _value
266         )
267         public
268         returns (bool)
269     {
270         require(_to != address(0));
271         require(_value <= balances[_from]);
272         require(_value <= allowed[_from][msg.sender]);
273         balances[_from] = balances[_from].sub(_value);
274         balances[_to] = balances[_to].add(_value);
275         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
276         emit Transfer(_from, _to, _value);
277         return true;
278     }
279     /**
280      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
281      *
282      * Beware that changing an allowance with this method brings the risk that someone may use both the old
283      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
284      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
285      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
286      * @param _spender The address which will spend the funds.
287      * @param _value The amount of tokens to be spent.
288      */
289     function approve(
290         address _spender,
291         uint256 _value
292         )
293         public
294         returns (bool)
295     {
296         allowed[msg.sender][_spender] = _value;
297         emit Approval(msg.sender, _spender, _value);
298         return true;
299     }
300     /**
301      * @dev Function to check the amount of tokens that an owner allowed to a spender.
302      * @param _owner address The address which owns the funds.
303      * @param _spender address The address which will spend the funds.
304      * @return A uint256 specifying the amount of tokens still available for the spender.
305      */
306     function allowance(
307         address _owner,
308         address _spender)
309         public
310         view
311         returns (uint256)
312     {
313         return allowed[_owner][_spender];
314     }
315     /**
316      * @dev Increase the amount of tokens that an owner allowed to a spender.
317      *
318      * approve should be called when allowed[_spender] == 0. To increment
319      * allowed value is better to use this function to avoid 2 calls (and wait until
320      * the first transaction is mined)
321      * From MonolithDAO Token.sol
322      * @param _spender The address which will spend the funds.
323      * @param _addedValue The amount of tokens to increase the allowance by.
324      */
325     function increaseApproval(
326         address _spender,
327         uint _addedValue
328         )
329         public
330         returns (bool)
331     {
332         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
333         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
334         return true;
335     }
336     /**
337      * @dev Decrease the amount of tokens that an owner allowed to a spender.
338      *
339      * approve should be called when allowed[_spender] == 0. To decrement
340      * allowed value is better to use this function to avoid 2 calls (and wait until
341      * the first transaction is mined)
342      * From MonolithDAO Token.sol
343      * @param _spender The address which will spend the funds.
344      * @param _subtractedValue The amount of tokens to decrease the allowance by.
345      */
346     function decreaseApproval(
347         address _spender,
348         uint _subtractedValue
349         )
350         public
351         returns (bool)
352     {
353         uint oldValue = allowed[msg.sender][_spender];
354         if (_subtractedValue > oldValue) {
355             allowed[msg.sender][_spender] = 0;
356         } else {
357             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
358         }
359         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
360         return true;
361     }
362 }
363 /*
364   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
365   Licensed under the Apache License, Version 2.0 (the "License");
366   you may not use this file except in compliance with the License.
367   You may obtain a copy of the License at
368   http://www.apache.org/licenses/LICENSE-2.0
369   Unless required by applicable law or agreed to in writing, software
370   distributed under the License is distributed on an "AS IS" BASIS,
371   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
372   See the License for the specific language governing permissions and
373   limitations under the License.
374 */
375 /*
376   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
377   Licensed under the Apache License, Version 2.0 (the "License");
378   you may not use this file except in compliance with the License.
379   You may obtain a copy of the License at
380   http://www.apache.org/licenses/LICENSE-2.0
381   Unless required by applicable law or agreed to in writing, software
382   distributed under the License is distributed on an "AS IS" BASIS,
383   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
384   See the License for the specific language governing permissions and
385   limitations under the License.
386 */
387 /*
388   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
389   Licensed under the Apache License, Version 2.0 (the "License");
390   you may not use this file except in compliance with the License.
391   You may obtain a copy of the License at
392   http://www.apache.org/licenses/LICENSE-2.0
393   Unless required by applicable law or agreed to in writing, software
394   distributed under the License is distributed on an "AS IS" BASIS,
395   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
396   See the License for the specific language governing permissions and
397   limitations under the License.
398 */
399 /// @title Ownable
400 /// @dev The Ownable contract has an owner address, and provides basic
401 ///      authorization control functions, this simplifies the implementation of
402 ///      "user permissions".
403 contract Ownable {
404     address public owner;
405     event OwnershipTransferred(
406         address indexed previousOwner,
407         address indexed newOwner
408     );
409     /// @dev The Ownable constructor sets the original `owner` of the contract
410     ///      to the sender.
411     function Ownable() public {
412         owner = msg.sender;
413     }
414     /// @dev Throws if called by any account other than the owner.
415     modifier onlyOwner() {
416         require(msg.sender == owner);
417         _;
418     }
419     /// @dev Allows the current owner to transfer control of the contract to a
420     ///      newOwner.
421     /// @param newOwner The address to transfer ownership to.
422     function transferOwnership(address newOwner) onlyOwner public {
423         require(newOwner != 0x0);
424         emit OwnershipTransferred(owner, newOwner);
425         owner = newOwner;
426     }
427 }
428 /// @title Claimable
429 /// @dev Extension for the Ownable contract, where the ownership needs
430 ///      to be claimed. This allows the new owner to accept the transfer.
431 contract Claimable is Ownable {
432     address public pendingOwner;
433     /// @dev Modifier throws if called by any account other than the pendingOwner.
434     modifier onlyPendingOwner() {
435         require(msg.sender == pendingOwner);
436         _;
437     }
438     /// @dev Allows the current owner to set the pendingOwner address.
439     /// @param newOwner The address to transfer ownership to.
440     function transferOwnership(address newOwner) onlyOwner public {
441         require(newOwner != 0x0 && newOwner != owner);
442         pendingOwner = newOwner;
443     }
444     /// @dev Allows the pendingOwner address to finalize the transfer.
445     function claimOwnership() onlyPendingOwner public {
446         emit OwnershipTransferred(owner, pendingOwner);
447         owner = pendingOwner;
448         pendingOwner = 0x0;
449     }
450 }
451 /// @title Token Register Contract
452 /// @dev This contract maintains a list of tokens the Protocol supports.
453 /// @author Kongliang Zhong - <kongliang@loopring.org>,
454 /// @author Daniel Wang - <daniel@loopring.org>.
455 contract TokenRegistry is Claimable {
456     using AddressUtil for address;
457     address tokenMintAddr;
458     address[] public addresses;
459     mapping (address => TokenInfo) addressMap;
460     mapping (string => address) symbolMap;
461     ////////////////////////////////////////////////////////////////////////////
462     /// Structs                                                              ///
463     ////////////////////////////////////////////////////////////////////////////
464     struct TokenInfo {
465         uint   pos;      // 0 mens unregistered; if > 0, pos + 1 is the
466                          // token's position in `addresses`.
467         string symbol;   // Symbol of the token
468     }
469     ////////////////////////////////////////////////////////////////////////////
470     /// Events                                                               ///
471     ////////////////////////////////////////////////////////////////////////////
472     event TokenRegistered(address addr, string symbol);
473     event TokenUnregistered(address addr, string symbol);
474     ////////////////////////////////////////////////////////////////////////////
475     /// Public Functions                                                     ///
476     ////////////////////////////////////////////////////////////////////////////
477     /// @dev Disable default function.
478     function () payable public {
479         revert();
480     }
481     function TokenRegistry(address _tokenMintAddr) public
482     {
483         require(_tokenMintAddr.isContract());
484         tokenMintAddr = _tokenMintAddr;
485     }
486     function registerToken(
487         address addr,
488         string  symbol
489         )
490         external
491         onlyOwner
492     {
493         registerTokenInternal(addr, symbol);
494     }
495     function registerMintedToken(
496         address addr,
497         string  symbol
498         )
499         external
500     {
501         require(msg.sender == tokenMintAddr);
502         registerTokenInternal(addr, symbol);
503     }
504     function unregisterToken(
505         address addr,
506         string  symbol
507         )
508         external
509         onlyOwner
510     {
511         require(addr != 0x0);
512         require(symbolMap[symbol] == addr);
513         delete symbolMap[symbol];
514         uint pos = addressMap[addr].pos;
515         require(pos != 0);
516         delete addressMap[addr];
517         // We will replace the token we need to unregister with the last token
518         // Only the pos of the last token will need to be updated
519         address lastToken = addresses[addresses.length - 1];
520         // Don't do anything if the last token is the one we want to delete
521         if (addr != lastToken) {
522             // Swap with the last token and update the pos
523             addresses[pos - 1] = lastToken;
524             addressMap[lastToken].pos = pos;
525         }
526         addresses.length--;
527         emit TokenUnregistered(addr, symbol);
528     }
529     function areAllTokensRegistered(address[] addressList)
530         external
531         view
532         returns (bool)
533     {
534         for (uint i = 0; i < addressList.length; i++) {
535             if (addressMap[addressList[i]].pos == 0) {
536                 return false;
537             }
538         }
539         return true;
540     }
541     function getAddressBySymbol(string symbol)
542         external
543         view
544         returns (address)
545     {
546         return symbolMap[symbol];
547     }
548     function isTokenRegisteredBySymbol(string symbol)
549         public
550         view
551         returns (bool)
552     {
553         return symbolMap[symbol] != 0x0;
554     }
555     function isTokenRegistered(address addr)
556         public
557         view
558         returns (bool)
559     {
560         return addressMap[addr].pos != 0;
561     }
562     function getTokens(
563         uint start,
564         uint count
565         )
566         public
567         view
568         returns (address[] addressList)
569     {
570         uint num = addresses.length;
571         if (start >= num) {
572             return;
573         }
574         uint end = start + count;
575         if (end > num) {
576             end = num;
577         }
578         if (start == num) {
579             return;
580         }
581         addressList = new address[](end - start);
582         for (uint i = start; i < end; i++) {
583             addressList[i - start] = addresses[i];
584         }
585     }
586     function registerTokenInternal(
587         address addr,
588         string  symbol
589         )
590         internal
591     {
592         require(0x0 != addr);
593         require(bytes(symbol).length > 0);
594         require(0x0 == symbolMap[symbol]);
595         require(0 == addressMap[addr].pos);
596         addresses.push(addr);
597         symbolMap[symbol] = addr;
598         addressMap[addr] = TokenInfo(addresses.length, symbol);
599         emit TokenRegistered(addr, symbol);
600     }
601 }
602 /// @title ERC20 Token Mint
603 /// @dev This contract deploys ERC20 token contract and registered the contract
604 ///      so the token can be traded with Loopring Protocol.
605 /// @author Kongliang Zhong - <kongliang@loopring.org>,
606 /// @author Daniel Wang - <daniel@loopring.org>.
607 contract TokenFactory {
608     using AddressUtil for address;
609     using StringUtil for string;
610     mapping(bytes10 => address) public tokens;
611     address   public tokenRegistry;
612     event TokenCreated(
613         address indexed addr,
614         string  name,
615         string  symbol,
616         uint8   decimals,
617         uint    totalSupply,
618         address firstHolder
619     );
620     /// @dev Disable default function.
621     function () payable public
622     {
623         revert();
624     }
625     /// @dev Initialize TokenRegistry address.
626     ///      This method shall be called immediately upon deployment.
627     function initialize(address _tokenRegistry)
628         public
629     {
630         require(tokenRegistry == 0x0 && _tokenRegistry.isContract());
631         tokenRegistry = _tokenRegistry;
632     }
633     /// @dev Deploy an ERC20 token contract, register it with TokenRegistry,
634     ///      and returns the new token's address.
635     /// @param name The name of the token
636     /// @param symbol The symbol of the token.
637     /// @param decimals The decimals of the token.
638     /// @param totalSupply The total supply of the token.
639     function createToken(
640         string  name,
641         string  symbol,
642         uint8   decimals,
643         uint    totalSupply
644         )
645         public
646         returns (address addr)
647     {
648         require(tokenRegistry != 0x0);
649         require(symbol.checkStringLength(3, 10));
650         bytes10 symbolBytes = symbol.stringToBytes10();
651         require(tokens[symbolBytes] == 0x0);
652         ERC20Token token = new ERC20Token(
653             name,
654             symbol,
655             decimals,
656             totalSupply,
657             tx.origin
658         );
659         addr = address(token);
660         TokenRegistry(tokenRegistry).registerMintedToken(addr, symbol);
661         tokens[symbolBytes] = addr;
662         emit TokenCreated(
663             addr,
664             name,
665             symbol,
666             decimals,
667             totalSupply,
668             tx.origin
669         );
670     }
671 }