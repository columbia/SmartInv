1 pragma solidity ^0.5.0;
2 
3 
4 
5 /// @title SelfAuthorized - authorizes current contract to perform actions
6 /// @author Richard Meissner - <richard@gnosis.pm>
7 contract SelfAuthorized {
8     modifier authorized() {
9         require(msg.sender == address(this), "Method can only be called from this contract");
10         _;
11     }
12 }
13 
14 
15 /// @title MasterCopy - Base for master copy contracts (should always be first super contract)
16 /// @author Richard Meissner - <richard@gnosis.pm>
17 contract MasterCopy is SelfAuthorized {
18   // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.
19   // It should also always be ensured that the address is stored alone (uses a full word)
20     address masterCopy;
21 
22   /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.
23   /// @param _masterCopy New contract address.
24     function changeMasterCopy(address _masterCopy)
25         public
26         authorized
27     {
28         // Master copy address cannot be null.
29         require(_masterCopy != address(0), "Invalid master copy address provided");
30         masterCopy = _masterCopy;
31     }
32 }
33 
34 
35 /// @title Enum - Collection of enums
36 /// @author Richard Meissner - <richard@gnosis.pm>
37 contract Enum {
38     enum Operation {
39         Call,
40         DelegateCall,
41         Create
42     }
43 }
44 
45 
46 /// @title EtherPaymentFallback - A contract that has a fallback to accept ether payments
47 /// @author Richard Meissner - <richard@gnosis.pm>
48 contract EtherPaymentFallback {
49 
50     /// @dev Fallback function accepts Ether transactions.
51     function ()
52         external
53         payable
54     {
55 
56     }
57 }
58 
59 
60 /// @title Executor - A contract that can execute transactions
61 /// @author Richard Meissner - <richard@gnosis.pm>
62 contract Executor is EtherPaymentFallback {
63 
64     event ContractCreation(address newContract);
65 
66     function execute(address to, uint256 value, bytes memory data, Enum.Operation operation, uint256 txGas)
67         internal
68         returns (bool success)
69     {
70         if (operation == Enum.Operation.Call)
71             success = executeCall(to, value, data, txGas);
72         else if (operation == Enum.Operation.DelegateCall)
73             success = executeDelegateCall(to, data, txGas);
74         else {
75             address newContract = executeCreate(data);
76             success = newContract != address(0);
77             emit ContractCreation(newContract);
78         }
79     }
80 
81     function executeCall(address to, uint256 value, bytes memory data, uint256 txGas)
82         internal
83         returns (bool success)
84     {
85         // solium-disable-next-line security/no-inline-assembly
86         assembly {
87             success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
88         }
89     }
90 
91     function executeDelegateCall(address to, bytes memory data, uint256 txGas)
92         internal
93         returns (bool success)
94     {
95         // solium-disable-next-line security/no-inline-assembly
96         assembly {
97             success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
98         }
99     }
100 
101     function executeCreate(bytes memory data)
102         internal
103         returns (address newContract)
104     {
105         // solium-disable-next-line security/no-inline-assembly
106         assembly {
107             newContract := create(0, add(data, 0x20), mload(data))
108         }
109     }
110 }
111 
112 
113 /// @title Module Manager - A contract that manages modules that can execute transactions via this contract
114 /// @author Stefan George - <stefan@gnosis.pm>
115 /// @author Richard Meissner - <richard@gnosis.pm>
116 contract ModuleManager is SelfAuthorized, Executor {
117 
118     event EnabledModule(Module module);
119     event DisabledModule(Module module);
120 
121     address public constant SENTINEL_MODULES = address(0x1);
122 
123     mapping (address => address) internal modules;
124     
125     function setupModules(address to, bytes memory data)
126         internal
127     {
128         require(modules[SENTINEL_MODULES] == address(0), "Modules have already been initialized");
129         modules[SENTINEL_MODULES] = SENTINEL_MODULES;
130         if (to != address(0))
131             // Setup has to complete successfully or transaction fails.
132             require(executeDelegateCall(to, data, gasleft()), "Could not finish initialization");
133     }
134 
135     /// @dev Allows to add a module to the whitelist.
136     ///      This can only be done via a Safe transaction.
137     /// @param module Module to be whitelisted.
138     function enableModule(Module module)
139         public
140         authorized
141     {
142         // Module address cannot be null or sentinel.
143         require(address(module) != address(0) && address(module) != SENTINEL_MODULES, "Invalid module address provided");
144         // Module cannot be added twice.
145         require(modules[address(module)] == address(0), "Module has already been added");
146         modules[address(module)] = modules[SENTINEL_MODULES];
147         modules[SENTINEL_MODULES] = address(module);
148         emit EnabledModule(module);
149     }
150 
151     /// @dev Allows to remove a module from the whitelist.
152     ///      This can only be done via a Safe transaction.
153     /// @param prevModule Module that pointed to the module to be removed in the linked list
154     /// @param module Module to be removed.
155     function disableModule(Module prevModule, Module module)
156         public
157         authorized
158     {
159         // Validate module address and check that it corresponds to module index.
160         require(address(module) != address(0) && address(module) != SENTINEL_MODULES, "Invalid module address provided");
161         require(modules[address(prevModule)] == address(module), "Invalid prevModule, module pair provided");
162         modules[address(prevModule)] = modules[address(module)];
163         modules[address(module)] = address(0);
164         emit DisabledModule(module);
165     }
166 
167     /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
168     /// @param to Destination address of module transaction.
169     /// @param value Ether value of module transaction.
170     /// @param data Data payload of module transaction.
171     /// @param operation Operation type of module transaction.
172     function execTransactionFromModule(address to, uint256 value, bytes memory data, Enum.Operation operation)
173         public
174         returns (bool success)
175     {
176         // Only whitelisted modules are allowed.
177         require(msg.sender != SENTINEL_MODULES && modules[msg.sender] != address(0), "Method can only be called from an enabled module");
178         // Execute transaction without further confirmations.
179         success = execute(to, value, data, operation, gasleft());
180     }
181 
182     /// @dev Returns array of modules.
183     /// @return Array of modules.
184     function getModules()
185         public
186         view
187         returns (address[] memory)
188     {
189         // Calculate module count
190         uint256 moduleCount = 0;
191         address currentModule = modules[SENTINEL_MODULES];
192         while(currentModule != SENTINEL_MODULES) {
193             currentModule = modules[currentModule];
194             moduleCount ++;
195         }
196         address[] memory array = new address[](moduleCount);
197 
198         // populate return array
199         moduleCount = 0;
200         currentModule = modules[SENTINEL_MODULES];
201         while(currentModule != SENTINEL_MODULES) {
202             array[moduleCount] = currentModule;
203             currentModule = modules[currentModule];
204             moduleCount ++;
205         }
206         return array;
207     }
208 }
209 
210 
211 /// @title Module - Base class for modules.
212 /// @author Stefan George - <stefan@gnosis.pm>
213 /// @author Richard Meissner - <richard@gnosis.pm>
214 contract Module is MasterCopy {
215 
216     ModuleManager public manager;
217 
218     modifier authorized() {
219         require(msg.sender == address(manager), "Method can only be called from manager");
220         _;
221     }
222 
223     function setManager()
224         internal
225     {
226         // manager can only be 0 at initalization of contract.
227         // Check ensures that setup function can only be called once.
228         require(address(manager) == address(0), "Manager has already been set");
229         manager = ModuleManager(msg.sender);
230     }
231 }
232 
233 interface SM {
234 
235     function isValidSubscription(
236         bytes32 subscriptionHash,
237         bytes calldata signatures
238     ) external view returns (bool);
239 
240     function execSubscription (
241         address to,
242         uint256 value,
243         bytes calldata data,
244         Enum.Operation operation,
245         uint256 safeTxGas,
246         uint256 dataGas,
247         uint256 gasPrice,
248         address gasToken,
249         address payable refundReceiver,
250         bytes calldata meta,
251         bytes calldata signatures) external returns (bool);
252 
253     function cancelSubscriptionAsRecipient(
254         address to,
255         uint256 value,
256         bytes calldata data,
257         Enum.Operation operation,
258         uint256 safeTxGas,
259         uint256 dataGas,
260         uint256 gasPrice,
261         address gasToken,
262         address payable refundReceiver,
263         bytes calldata meta,
264         bytes calldata signatures) external returns (bool);
265 }
266 /// math.sol -- mixin for inline numerical wizardry
267 
268 // This program is free software: you can redistribute it and/or modify
269 // it under the terms of the GNU General Public License as published by
270 // the Free Software Foundation, either version 3 of the License, or
271 // (at your option) any later version.
272 
273 // This program is distributed in the hope that it will be useful,
274 // but WITHOUT ANY WARRANTY; without even the implied warranty of
275 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
276 // GNU General Public License for more details.
277 
278 // You should have received a copy of the GNU General Public License
279 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
280 
281 
282 library DSMath {
283     function add(uint x, uint y) internal pure returns (uint z) {
284         require((z = x + y) >= x);
285     }
286     function sub(uint x, uint y) internal pure returns (uint z) {
287         require((z = x - y) <= x);
288     }
289     function mul(uint x, uint y) internal pure returns (uint z) {
290         require(y == 0 || (z = x * y) / y == x);
291     }
292 
293     function min(uint x, uint y) internal pure returns (uint z) {
294         return x <= y ? x : y;
295     }
296     function max(uint x, uint y) internal pure returns (uint z) {
297         return x >= y ? x : y;
298     }
299     function imin(int x, int y) internal pure returns (int z) {
300         return x <= y ? x : y;
301     }
302     function imax(int x, int y) internal pure returns (int z) {
303         return x >= y ? x : y;
304     }
305 
306     uint constant WAD = 10 ** 18;
307     uint constant RAY = 10 ** 27;
308 
309     function wmul(uint x, uint y) internal pure returns (uint z) {
310         z = add(mul(x, y), WAD / 2) / WAD;
311     }
312     function rmul(uint x, uint y) internal pure returns (uint z) {
313         z = add(mul(x, y), RAY / 2) / RAY;
314     }
315     function wdiv(uint x, uint y) internal pure returns (uint z) {
316         z = add(mul(x, WAD), y / 2) / y;
317     }
318     function rdiv(uint x, uint y) internal pure returns (uint z) {
319         z = add(mul(x, RAY), y / 2) / y;
320     }
321 
322     function tmul(uint x, uint y, uint z) internal pure returns (uint a) {
323         require(z != 0);
324         a = add(mul(x, y), z / 2) / z;
325     }
326 
327     function tdiv(uint x, uint y, uint z) internal pure returns (uint a) {
328         a = add(mul(x, z), y / 2) / y;
329     }
330 
331     // This famous algorithm is called "exponentiation by squaring"
332     // and calculates x^n with x as fixed-point and n as regular unsigned.
333     //
334     // It's O(log n), instead of O(n) for naive repeated multiplication.
335     //
336     // These facts are why it works:
337     //
338     //  If n is even, then x^n = (x^2)^(n/2).
339     //  If n is odd,  then x^n = x * x^(n-1),
340     //   and applying the equation for even x gives
341     //    x^n = x * (x^2)^((n-1) / 2).
342     //
343     //  Also, EVM division is flooring and
344     //    floor[(n-1) / 2] = floor[n / 2].
345     //
346     function rpow(uint x, uint n) internal pure returns (uint z) {
347         z = n % 2 != 0 ? x : RAY;
348 
349         for (n /= 2; n != 0; n /= 2) {
350             x = rmul(x, x);
351 
352             if (n % 2 != 0) {
353                 z = rmul(z, x);
354             }
355         }
356     }
357 }
358 
359 
360 interface OracleRegistry {
361 
362     function read(
363         uint256 currencyPair
364     ) external view returns (bytes32);
365 
366     function getNetworkExecutor()
367     external
368     view
369     returns (address);
370 
371     function getNetworkWallet()
372     external
373     view
374     returns (address payable);
375 
376     function getNetworkFee(address asset)
377     external
378     view
379     returns (uint256 fee);
380 }
381 
382 
383 /// @title SecuredTokenTransfer - Secure token transfer
384 /// @author Richard Meissner - <richard@gnosis.pm>
385 contract SecuredTokenTransfer {
386 
387     /// @dev Transfers a token and returns if it was a success
388     /// @param token Token that should be transferred
389     /// @param receiver Receiver to whom the token should be transferred
390     /// @param amount The amount of tokens that should be transferred
391     function transferToken (
392         address token, 
393         address receiver,
394         uint256 amount
395     )
396         internal
397         returns (bool transferred)
398     {
399         bytes memory data = abi.encodeWithSignature("transfer(address,uint256)", receiver, amount);
400         // solium-disable-next-line security/no-inline-assembly
401         assembly {
402             let success := call(sub(gas, 10000), token, 0, add(data, 0x20), mload(data), 0, 0)
403             let ptr := mload(0x40)
404             returndatacopy(ptr, 0, returndatasize)
405             switch returndatasize 
406             case 0 { transferred := success }
407             case 0x20 { transferred := iszero(or(iszero(success), iszero(mload(ptr)))) }
408             default { transferred := 0 }
409         }
410     }
411 }
412 
413 interface ERC20 {
414     function totalSupply() external view returns (uint256 supply);
415 
416     function balanceOf(address _owner) external view returns (uint256 balance);
417 
418     function transfer(address _to, uint256 _value) external returns (bool success);
419 
420     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
421 
422     function approve(address _spender, uint256 _value) external returns (bool success);
423 
424     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
425 
426     function decimals() external view returns (uint256 digits);
427 
428     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
429 }
430 
431 
432 contract MerchantModule is Module, SecuredTokenTransfer {
433 
434     using DSMath for uint256;
435 
436     OracleRegistry public oracleRegistry;
437 
438     event IncomingPayment(uint256 payment);
439     event PaymentSent(address asset, address receiver, uint256 payment);
440 
441 
442     function setup(address _oracleRegistry)
443     public
444     {
445         setManager();
446         require(
447             address(oracleRegistry) == address(0),
448             "MerchantModule::setup: INVALID_STATE: ORACLE_REGISTRY_SET"
449         );
450         oracleRegistry = OracleRegistry(_oracleRegistry);
451     }
452 
453     function()
454     payable
455     external
456     {
457         emit IncomingPayment(msg.value);
458     }
459 
460     function split(
461         address tokenAddress
462     )
463     public
464     returns (bool)
465     {
466         require(
467             msg.sender == oracleRegistry.getNetworkExecutor(),
468             "MerchantModule::split: INVALID_DATA: MSG_SENDER_NOT_EXECUTOR"
469         );
470 
471         address payable networkWallet = oracleRegistry.getNetworkWallet();
472         address payable merchantWallet = address(manager);
473 
474         if (tokenAddress == address(0)) {
475 
476             uint256 splitterBalanceStart = address(this).balance;
477             if (splitterBalanceStart == 0) return false;
478             //
479             uint256 fee = oracleRegistry.getNetworkFee(address(0));
480 
481 
482             uint256 networkBalanceStart = networkWallet.balance;
483 
484             uint256 merchantBalanceStart = merchantWallet.balance;
485 
486 
487             uint256 networkSplit = splitterBalanceStart.wmul(fee);
488 
489             uint256 merchantSplit = splitterBalanceStart.sub(networkSplit);
490 
491 
492             require(merchantSplit > networkSplit, "Split Math is Wrong");
493             //pay network
494 
495             networkWallet.transfer(networkSplit);
496             emit PaymentSent(address(0x0), networkWallet, networkSplit);
497             //pay merchant
498 
499             merchantWallet.transfer(merchantSplit);
500             emit PaymentSent(address(0x0), merchantWallet, merchantSplit);
501 
502             require(
503                 (networkBalanceStart.add(networkSplit) == networkWallet.balance)
504                 &&
505                 (merchantBalanceStart.add(merchantSplit) == merchantWallet.balance),
506                 "MerchantModule::withdraw: INVALID_EXEC SPLIT_PAYOUT"
507             );
508         } else {
509 
510             ERC20 token = ERC20(tokenAddress);
511 
512             uint256 splitterBalanceStart = token.balanceOf(address(this));
513 
514 
515             if (splitterBalanceStart == 0) return false;
516 
517             uint256 fee = oracleRegistry.getNetworkFee(address(token));
518 
519 
520             uint256 merchantBalanceStart = token.balanceOf(merchantWallet);
521 
522 
523             uint256 networkSplit = splitterBalanceStart.wmul(fee);
524 
525 
526             uint256 merchantSplit = splitterBalanceStart.sub(networkSplit);
527 
528 
529             require(
530                 networkSplit.add(merchantSplit) == splitterBalanceStart,
531                 "MerchantModule::withdraw: INVALID_EXEC TOKEN_SPLIT"
532             );
533 
534             //pay network
535 
536             require(
537                 transferToken(address(token), networkWallet, networkSplit),
538                 "MerchantModule::withdraw: INVALID_EXEC TOKEN_NETWORK_PAYOUT"
539             );
540 
541             emit PaymentSent(address(token), networkWallet, networkSplit);
542 
543             //pay merchant
544             require(
545                 transferToken(address(token), merchantWallet, merchantSplit),
546                 "MerchantModule::withdraw: INVALID_EXEC TOKEN_MERCHANT_PAYOUT"
547             );
548             emit PaymentSent(address(token), merchantWallet, merchantSplit);
549         }
550         return true;
551     }
552 
553 
554     function cancelCXSubscription(
555         address customer,
556         address to,
557         uint256 value,
558         bytes memory data,
559         Enum.Operation operation,
560         uint256 safeTxGas,
561         uint256 dataGas,
562         uint256 gasPrice,
563         address gasToken,
564         address payable refundReceiver,
565         bytes memory meta,
566         bytes memory signatures
567     )
568     public
569     authorized
570     {
571         SM(customer).cancelSubscriptionAsRecipient(
572             to,
573             value,
574             data,
575             operation,
576             safeTxGas,
577             dataGas,
578             gasPrice,
579             gasToken,
580             refundReceiver,
581             meta,
582             signatures
583         );
584     }
585 
586 }