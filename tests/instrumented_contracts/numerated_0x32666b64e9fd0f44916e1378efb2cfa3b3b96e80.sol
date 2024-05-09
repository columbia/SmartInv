1 /**
2 
3 Deployed by Ren Project, https://renproject.io
4 
5 Commit hash: 9068f80
6 Repository: https://github.com/renproject/darknode-sol
7 Issues: https://github.com/renproject/darknode-sol/issues
8 
9 Licenses
10 @openzeppelin/contracts: (MIT) https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/LICENSE
11 darknode-sol: (GNU GPL V3) https://github.com/renproject/darknode-sol/blob/master/LICENSE
12 
13 */
14 
15 pragma solidity 0.5.16;
16 
17 
18 contract Initializable {
19 
20   
21   bool private initialized;
22 
23   
24   bool private initializing;
25 
26   
27   modifier initializer() {
28     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
29 
30     bool isTopLevelCall = !initializing;
31     if (isTopLevelCall) {
32       initializing = true;
33       initialized = true;
34     }
35 
36     _;
37 
38     if (isTopLevelCall) {
39       initializing = false;
40     }
41   }
42 
43   
44   function isConstructor() private view returns (bool) {
45     
46     
47     
48     
49     
50     address self = address(this);
51     uint256 cs;
52     assembly { cs := extcodesize(self) }
53     return cs == 0;
54   }
55 
56   
57   uint256[50] private ______gap;
58 }
59 
60 contract IRelayRecipient {
61     
62     function getHubAddr() public view returns (address);
63 
64     
65     function acceptRelayedCall(
66         address relay,
67         address from,
68         bytes calldata encodedFunction,
69         uint256 transactionFee,
70         uint256 gasPrice,
71         uint256 gasLimit,
72         uint256 nonce,
73         bytes calldata approvalData,
74         uint256 maxPossibleCharge
75     )
76         external
77         view
78         returns (uint256, bytes memory);
79 
80     
81     function preRelayedCall(bytes calldata context) external returns (bytes32);
82 
83     
84     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
85 }
86 
87 contract IRelayHub {
88     
89 
90     
91     function stake(address relayaddr, uint256 unstakeDelay) external payable;
92 
93     
94     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
95 
96     
97     function registerRelay(uint256 transactionFee, string memory url) public;
98 
99     
100     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
101 
102     
103     function removeRelayByOwner(address relay) public;
104 
105     
106     event RelayRemoved(address indexed relay, uint256 unstakeTime);
107 
108     
109     function unstake(address relay) public;
110 
111     
112     event Unstaked(address indexed relay, uint256 stake);
113 
114     
115     enum RelayState {
116         Unknown, 
117         Staked, 
118         Registered, 
119         Removed    
120     }
121 
122     
123     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
124 
125     
126 
127     
128     function depositFor(address target) public payable;
129 
130     
131     event Deposited(address indexed recipient, address indexed from, uint256 amount);
132 
133     
134     function balanceOf(address target) external view returns (uint256);
135 
136     
137     function withdraw(uint256 amount, address payable dest) public;
138 
139     
140     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
141 
142     
143 
144     
145     function canRelay(
146         address relay,
147         address from,
148         address to,
149         bytes memory encodedFunction,
150         uint256 transactionFee,
151         uint256 gasPrice,
152         uint256 gasLimit,
153         uint256 nonce,
154         bytes memory signature,
155         bytes memory approvalData
156     ) public view returns (uint256 status, bytes memory recipientContext);
157 
158     
159     enum PreconditionCheck {
160         OK,                         
161         WrongSignature,             
162         WrongNonce,                 
163         AcceptRelayedCallReverted,  
164         InvalidRecipientStatusCode  
165     }
166 
167     
168     function relayCall(
169         address from,
170         address to,
171         bytes memory encodedFunction,
172         uint256 transactionFee,
173         uint256 gasPrice,
174         uint256 gasLimit,
175         uint256 nonce,
176         bytes memory signature,
177         bytes memory approvalData
178     ) public;
179 
180     
181     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
182 
183     
184     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
185 
186     
187     enum RelayCallStatus {
188         OK,                      
189         RelayedCallFailed,       
190         PreRelayedFailed,        
191         PostRelayedFailed,       
192         RecipientBalanceChanged  
193     }
194 
195     
196     function requiredGas(uint256 relayedCallStipend) public view returns (uint256);
197 
198     
199     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) public view returns (uint256);
200 
201      
202      
203     
204     
205 
206     
207     function penalizeRepeatedNonce(bytes memory unsignedTx1, bytes memory signature1, bytes memory unsignedTx2, bytes memory signature2) public;
208 
209     
210     function penalizeIllegalTransaction(bytes memory unsignedTx, bytes memory signature) public;
211 
212     
213     event Penalized(address indexed relay, address sender, uint256 amount);
214 
215     
216     function getNonce(address from) external view returns (uint256);
217 }
218 
219 contract Context is Initializable {
220     
221     
222     constructor () internal { }
223     
224 
225     function _msgSender() internal view returns (address payable) {
226         return msg.sender;
227     }
228 
229     function _msgData() internal view returns (bytes memory) {
230         this; 
231         return msg.data;
232     }
233 }
234 
235 contract GSNRecipient is Initializable, IRelayRecipient, Context {
236     function initialize() public initializer {
237         if (_relayHub == address(0)) {
238             setDefaultRelayHub();
239         }
240     }
241 
242     function setDefaultRelayHub() public {
243         _upgradeRelayHub(0xD216153c06E857cD7f72665E0aF1d7D82172F494);
244     }
245 
246     
247     address private _relayHub;
248 
249     uint256 constant private RELAYED_CALL_ACCEPTED = 0;
250     uint256 constant private RELAYED_CALL_REJECTED = 11;
251 
252     
253     uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;
254 
255     
256     event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);
257 
258     
259     function getHubAddr() public view returns (address) {
260         return _relayHub;
261     }
262 
263     
264     function _upgradeRelayHub(address newRelayHub) internal {
265         address currentRelayHub = _relayHub;
266         require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
267         require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");
268 
269         emit RelayHubChanged(currentRelayHub, newRelayHub);
270 
271         _relayHub = newRelayHub;
272     }
273 
274     
275     
276     
277     function relayHubVersion() public view returns (string memory) {
278         this; 
279         return "1.0.0";
280     }
281 
282     
283     function _withdrawDeposits(uint256 amount, address payable payee) internal {
284         IRelayHub(_relayHub).withdraw(amount, payee);
285     }
286 
287     
288     
289     
290     
291 
292     
293     function _msgSender() internal view returns (address payable) {
294         if (msg.sender != _relayHub) {
295             return msg.sender;
296         } else {
297             return _getRelayedCallSender();
298         }
299     }
300 
301     
302     function _msgData() internal view returns (bytes memory) {
303         if (msg.sender != _relayHub) {
304             return msg.data;
305         } else {
306             return _getRelayedCallData();
307         }
308     }
309 
310     
311     
312 
313     
314     function preRelayedCall(bytes calldata context) external returns (bytes32) {
315         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
316         return _preRelayedCall(context);
317     }
318 
319     
320     function _preRelayedCall(bytes memory context) internal returns (bytes32);
321 
322     
323     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
324         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
325         _postRelayedCall(context, success, actualCharge, preRetVal);
326     }
327 
328     
329     function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;
330 
331     
332     function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
333         return _approveRelayedCall("");
334     }
335 
336     
337     function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
338         return (RELAYED_CALL_ACCEPTED, context);
339     }
340 
341     
342     function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
343         return (RELAYED_CALL_REJECTED + errorCode, "");
344     }
345 
346     
347     function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
348         
349         
350         return (gas * gasPrice * (100 + serviceFee)) / 100;
351     }
352 
353     function _getRelayedCallSender() private pure returns (address payable result) {
354         
355         
356         
357         
358         
359 
360         
361         
362 
363         
364         bytes memory array = msg.data;
365         uint256 index = msg.data.length;
366 
367         
368         assembly {
369             
370             result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
371         }
372         return result;
373     }
374 
375     function _getRelayedCallData() private pure returns (bytes memory) {
376         
377         
378 
379         uint256 actualDataLength = msg.data.length - 20;
380         bytes memory actualData = new bytes(actualDataLength);
381 
382         for (uint256 i = 0; i < actualDataLength; ++i) {
383             actualData[i] = msg.data[i];
384         }
385 
386         return actualData;
387     }
388 }
389 
390 interface IMintGateway {
391     function mint(
392         bytes32 _pHash,
393         uint256 _amount,
394         bytes32 _nHash,
395         bytes calldata _sig
396     ) external returns (uint256);
397     function mintFee() external view returns (uint256);
398 }
399 
400 interface IBurnGateway {
401     function burn(bytes calldata _to, uint256 _amountScaled)
402         external
403         returns (uint256);
404     function burnFee() external view returns (uint256);
405 }
406 
407 interface IGateway {
408     
409     function mint(
410         bytes32 _pHash,
411         uint256 _amount,
412         bytes32 _nHash,
413         bytes calldata _sig
414     ) external returns (uint256);
415     function mintFee() external view returns (uint256);
416     
417     function burn(bytes calldata _to, uint256 _amountScaled)
418         external
419         returns (uint256);
420     function burnFee() external view returns (uint256);
421 }
422 
423 interface IERC20 {
424     
425     function totalSupply() external view returns (uint256);
426 
427     
428     function balanceOf(address account) external view returns (uint256);
429 
430     
431     function transfer(address recipient, uint256 amount) external returns (bool);
432 
433     
434     function allowance(address owner, address spender) external view returns (uint256);
435 
436     
437     function approve(address spender, uint256 amount) external returns (bool);
438 
439     
440     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
441 
442     
443     event Transfer(address indexed from, address indexed to, uint256 value);
444 
445     
446     event Approval(address indexed owner, address indexed spender, uint256 value);
447 }
448 
449 interface IGatewayRegistry {
450     
451     
452     event LogGatewayRegistered(
453         string _symbol,
454         string indexed _indexedSymbol,
455         address indexed _tokenAddress,
456         address indexed _gatewayAddress
457     );
458     event LogGatewayDeregistered(
459         string _symbol,
460         string indexed _indexedSymbol,
461         address indexed _tokenAddress,
462         address indexed _gatewayAddress
463     );
464     event LogGatewayUpdated(
465         address indexed _tokenAddress,
466         address indexed _currentGatewayAddress,
467         address indexed _newGatewayAddress
468     );
469 
470     
471     function getGateways(address _start, uint256 _count)
472         external
473         view
474         returns (address[] memory);
475 
476     
477     function getRenTokens(address _start, uint256 _count)
478         external
479         view
480         returns (address[] memory);
481 
482     
483     
484     
485     
486     function getGatewayByToken(address _tokenAddress)
487         external
488         view
489         returns (IGateway);
490 
491     
492     
493     
494     
495     function getGatewayBySymbol(string calldata _tokenSymbol)
496         external
497         view
498         returns (IGateway);
499 
500     
501     
502     
503     
504     function getTokenBySymbol(string calldata _tokenSymbol)
505         external
506         view
507         returns (IERC20);
508 }
509 
510 contract BasicAdapter is GSNRecipient {
511     IGatewayRegistry registry;
512 
513     constructor(IGatewayRegistry _registry) public {
514         GSNRecipient.initialize();
515         registry = _registry;
516     }
517 
518     function mint(
519         
520         string calldata _symbol,
521         address _recipient,
522         
523         uint256 _amount,
524         bytes32 _nHash,
525         bytes calldata _sig
526     ) external {
527         bytes32 payloadHash = keccak256(abi.encode(_symbol, _recipient));
528         uint256 amount = registry.getGatewayBySymbol(_symbol).mint(
529             payloadHash,
530             _amount,
531             _nHash,
532             _sig
533         );
534         registry.getTokenBySymbol(_symbol).transfer(_recipient, amount);
535     }
536 
537     function burn(string calldata _symbol, bytes calldata _to, uint256 _amount)
538         external
539     {
540         require(
541             registry.getTokenBySymbol(_symbol).transferFrom(
542                 _msgSender(),
543                 address(this),
544                 _amount
545             ),
546             "token transfer failed"
547         );
548         registry.getGatewayBySymbol(_symbol).burn(_to, _amount);
549     }
550 
551     
552 
553     function acceptRelayedCall(
554         address relay,
555         address from,
556         bytes calldata encodedFunction,
557         uint256 transactionFee,
558         uint256 gasPrice,
559         uint256 gasLimit,
560         uint256 nonce,
561         bytes calldata approvalData,
562         uint256 maxPossibleCharge
563     ) external view returns (uint256, bytes memory) {
564         return _approveRelayedCall();
565     }
566 
567     
568     function _preRelayedCall(bytes memory context) internal returns (bytes32) {}
569 
570     function _postRelayedCall(
571         bytes memory context,
572         bool,
573         uint256 actualCharge,
574         bytes32
575     ) internal {}
576 }