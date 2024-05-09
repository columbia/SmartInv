1 pragma solidity ^0.5.0;
2 
3 interface SwapInterface {
4     // Public variables
5     function brokerFees(address _broker) external view returns (uint256);
6     function redeemedAt(bytes32 _swapID) external view returns(uint256);
7 
8     /// @notice Initiates the atomic swap.
9     ///
10     /// @param _swapID The unique atomic swap id.
11     /// @param _spender The address of the withdrawing trader.
12     /// @param _secretLock The hash of the secret (Hash Lock).
13     /// @param _timelock The unix timestamp when the swap expires.
14     /// @param _value The value of the atomic swap.
15     function initiate(
16         bytes32 _swapID,
17         address payable _spender,
18         bytes32 _secretLock,
19         uint256 _timelock,
20         uint256 _value
21     ) external payable;
22 
23     /// @notice Initiates the atomic swap with broker fees.
24     ///
25     /// @param _swapID The unique atomic swap id.
26     /// @param _spender The address of the withdrawing trader.
27     /// @param _broker The address of the broker.
28     /// @param _brokerFee The fee to be paid to the broker on success.
29     /// @param _secretLock The hash of the secret (Hash Lock).
30     /// @param _timelock The unix timestamp when the swap expires.
31     /// @param _value The value of the atomic swap.
32     function initiateWithFees(
33         bytes32 _swapID,
34         address payable _spender,
35         address payable _broker,
36         uint256 _brokerFee,
37         bytes32 _secretLock,
38         uint256 _timelock,
39         uint256 _value
40     ) external payable;
41 
42     /// @notice Redeems an atomic swap.
43     ///
44     /// @param _swapID The unique atomic swap id.
45     /// @param _receiver The receiver's address.
46     /// @param _secretKey The secret of the atomic swap.
47     function redeem(bytes32 _swapID, address payable _receiver, bytes32 _secretKey) external;
48 
49     /// @notice Redeems an atomic swap to the spender. Can be called by anyone.
50     ///
51     /// @param _swapID The unique atomic swap id.
52     /// @param _secretKey The secret of the atomic swap.
53     function redeemToSpender(bytes32 _swapID, bytes32 _secretKey) external;
54 
55     /// @notice Refunds an atomic swap.
56     ///
57     /// @param _swapID The unique atomic swap id.
58     function refund(bytes32 _swapID) external;
59 
60     /// @notice Allows broker fee withdrawals.
61     ///
62     /// @param _amount The withdrawal amount.
63     function withdrawBrokerFees(uint256 _amount) external;
64 
65     /// @notice Audits an atomic swap.
66     ///
67     /// @param _swapID The unique atomic swap id.
68     function audit(
69         bytes32 _swapID
70     ) external view returns (
71         uint256 timelock,
72         uint256 value,
73         address to, uint256 brokerFee,
74         address broker,
75         address from,
76         bytes32 secretLock
77     );
78 
79     /// @notice Audits the secret of an atomic swap.
80     ///
81     /// @param _swapID The unique atomic swap id.
82     function auditSecret(bytes32 _swapID) external view  returns (bytes32 secretKey);
83 
84     /// @notice Checks whether a swap is refundable or not.
85     ///
86     /// @param _swapID The unique atomic swap id.
87     function refundable(bytes32 _swapID) external view returns (bool);
88 
89     /// @notice Checks whether a swap is initiatable or not.
90     ///
91     /// @param _swapID The unique atomic swap id.
92     function initiatable(bytes32 _swapID) external view returns (bool);
93 
94     /// @notice Checks whether a swap is redeemable or not.
95     ///
96     /// @param _swapID The unique atomic swap id.
97     function redeemable(bytes32 _swapID) external view returns (bool);
98 
99     /// @notice Generates a deterministic swap id using initiate swap details.
100     ///
101     /// @param _secretLock The hash of the secret.
102     /// @param _timelock The expiry timestamp.
103     function swapID(bytes32 _secretLock, uint256 _timelock) external pure returns (bytes32);
104 }
105 
106 contract BaseSwap is SwapInterface {
107     string public VERSION; // Passed in as a constructor parameter.
108 
109     struct Swap {
110         uint256 timelock;
111         uint256 value;
112         uint256 brokerFee;
113         bytes32 secretLock;
114         bytes32 secretKey;
115         address payable funder;
116         address payable spender;
117         address payable broker;
118     }
119 
120     enum States {
121         INVALID,
122         OPEN,
123         CLOSED,
124         EXPIRED
125     }
126 
127     // Events
128     event LogOpen(bytes32 _swapID, address _spender, bytes32 _secretLock);
129     event LogExpire(bytes32 _swapID);
130     event LogClose(bytes32 _swapID, bytes32 _secretKey);
131 
132     // Storage
133     mapping (bytes32 => Swap) internal swaps;
134     mapping (bytes32 => States) private _swapStates;
135     mapping (address => uint256) private _brokerFees;
136     mapping (bytes32 => uint256) private _redeemedAt;
137 
138     /// @notice Throws if the swap is not invalid (i.e. has already been opened)
139     modifier onlyInvalidSwaps(bytes32 _swapID) {
140         require(_swapStates[_swapID] == States.INVALID, "swap opened previously");
141         _;
142     }
143 
144     /// @notice Throws if the swap is not open.
145     modifier onlyOpenSwaps(bytes32 _swapID) {
146         require(_swapStates[_swapID] == States.OPEN, "swap not open");
147         _;
148     }
149 
150     /// @notice Throws if the swap is not closed.
151     modifier onlyClosedSwaps(bytes32 _swapID) {
152         require(_swapStates[_swapID] == States.CLOSED, "swap not redeemed");
153         _;
154     }
155 
156     /// @notice Throws if the swap is not expirable.
157     modifier onlyExpirableSwaps(bytes32 _swapID) {
158         /* solium-disable-next-line security/no-block-members */
159         require(now >= swaps[_swapID].timelock, "swap not expirable");
160         _;
161     }
162 
163     /// @notice Throws if the secret key is not valid.
164     modifier onlyWithSecretKey(bytes32 _swapID, bytes32 _secretKey) {
165         require(swaps[_swapID].secretLock == sha256(abi.encodePacked(_secretKey)), "invalid secret");
166         _;
167     }
168 
169     /// @notice Throws if the caller is not the authorized spender.
170     modifier onlySpender(bytes32 _swapID, address _spender) {
171         require(swaps[_swapID].spender == _spender, "unauthorized spender");
172         _;
173     }
174 
175     /// @notice The contract constructor.
176     ///
177     /// @param _VERSION A string defining the contract version.
178     constructor(string memory _VERSION) public {
179         VERSION = _VERSION;
180     }
181 
182     /// @notice Initiates the atomic swap.
183     ///
184     /// @param _swapID The unique atomic swap id.
185     /// @param _spender The address of the withdrawing trader.
186     /// @param _secretLock The hash of the secret (Hash Lock).
187     /// @param _timelock The unix timestamp when the swap expires.
188     /// @param _value The value of the atomic swap.
189     function initiate(
190         bytes32 _swapID,
191         address payable _spender,
192         bytes32 _secretLock,
193         uint256 _timelock,
194         uint256 _value
195     ) public onlyInvalidSwaps(_swapID) payable {
196         // Store the details of the swap.
197         Swap memory swap = Swap({
198             timelock: _timelock,
199             brokerFee: 0,
200             value: _value,
201             funder: msg.sender,
202             spender: _spender,
203             broker: address(0x0),
204             secretLock: _secretLock,
205             secretKey: 0x0
206         });
207         swaps[_swapID] = swap;
208         _swapStates[_swapID] = States.OPEN;
209 
210         // Logs open event
211         emit LogOpen(_swapID, _spender, _secretLock);
212     }
213 
214     /// @notice Initiates the atomic swap with fees.
215     ///
216     /// @param _swapID The unique atomic swap id.
217     /// @param _spender The address of the withdrawing trader.
218     /// @param _broker The address of the broker.
219     /// @param _brokerFee The fee to be paid to the broker on success.
220     /// @param _secretLock The hash of the secret (Hash Lock).
221     /// @param _timelock The unix timestamp when the swap expires.
222     /// @param _value The value of the atomic swap.
223     function initiateWithFees(
224         bytes32 _swapID,
225         address payable _spender,
226         address payable _broker,
227         uint256 _brokerFee,
228         bytes32 _secretLock,
229         uint256 _timelock,
230         uint256 _value
231     ) public onlyInvalidSwaps(_swapID) payable {
232         require(_value >= _brokerFee, "fee must be less than value");
233 
234         // Store the details of the swap.
235         Swap memory swap = Swap({
236             timelock: _timelock,
237             brokerFee: _brokerFee,
238             value: _value - _brokerFee,
239             funder: msg.sender,
240             spender: _spender,
241             broker: _broker,
242             secretLock: _secretLock,
243             secretKey: 0x0
244         });
245         swaps[_swapID] = swap;
246         _swapStates[_swapID] = States.OPEN;
247 
248         // Logs open event
249         emit LogOpen(_swapID, _spender, _secretLock);
250     }
251 
252     /// @notice Redeems an atomic swap.
253     ///
254     /// @param _swapID The unique atomic swap id.
255     /// @param _receiver The receiver's address.
256     /// @param _secretKey The secret of the atomic swap.
257     function redeem(bytes32 _swapID, address payable _receiver, bytes32 _secretKey) public onlyOpenSwaps(_swapID) onlyWithSecretKey(_swapID, _secretKey) onlySpender(_swapID, msg.sender) {
258         require(_receiver != address(0x0), "invalid receiver");
259 
260         // Close the swap.
261         swaps[_swapID].secretKey = _secretKey;
262         _swapStates[_swapID] = States.CLOSED;
263         /* solium-disable-next-line security/no-block-members */
264         _redeemedAt[_swapID] = now;
265 
266         // Update the broker fees to the broker.
267         _brokerFees[swaps[_swapID].broker] += swaps[_swapID].brokerFee;
268 
269         // Logs close event
270         emit LogClose(_swapID, _secretKey);
271     }
272 
273     /// @notice Redeems an atomic swap to the spender. Can be called by anyone.
274     ///
275     /// @param _swapID The unique atomic swap id.
276     /// @param _secretKey The secret of the atomic swap.
277     function redeemToSpender(bytes32 _swapID, bytes32 _secretKey) public onlyOpenSwaps(_swapID) onlyWithSecretKey(_swapID, _secretKey) {
278         // Close the swap.
279         swaps[_swapID].secretKey = _secretKey;
280         _swapStates[_swapID] = States.CLOSED;
281         /* solium-disable-next-line security/no-block-members */
282         _redeemedAt[_swapID] = now;
283 
284         // Update the broker fees to the broker.
285         _brokerFees[swaps[_swapID].broker] += swaps[_swapID].brokerFee;
286 
287         // Logs close event
288         emit LogClose(_swapID, _secretKey);
289     }
290 
291     /// @notice Refunds an atomic swap.
292     ///
293     /// @param _swapID The unique atomic swap id.
294     function refund(bytes32 _swapID) public onlyOpenSwaps(_swapID) onlyExpirableSwaps(_swapID) {
295         // Expire the swap.
296         _swapStates[_swapID] = States.EXPIRED;
297 
298         // Logs expire event
299         emit LogExpire(_swapID);
300     }
301 
302     /// @notice Allows broker fee withdrawals.
303     ///
304     /// @param _amount The withdrawal amount.
305     function withdrawBrokerFees(uint256 _amount) public {
306         require(_amount <= _brokerFees[msg.sender], "insufficient withdrawable fees");
307         _brokerFees[msg.sender] -= _amount;
308     }
309 
310     /// @notice Audits an atomic swap.
311     ///
312     /// @param _swapID The unique atomic swap id.
313     function audit(bytes32 _swapID) external view returns (uint256 timelock, uint256 value, address to, uint256 brokerFee, address broker, address from, bytes32 secretLock) {
314         Swap memory swap = swaps[_swapID];
315         return (
316             swap.timelock,
317             swap.value,
318             swap.spender,
319             swap.brokerFee,
320             swap.broker,
321             swap.funder,
322             swap.secretLock
323         );
324     }
325 
326     /// @notice Audits the secret of an atomic swap.
327     ///
328     /// @param _swapID The unique atomic swap id.
329     function auditSecret(bytes32 _swapID) external view onlyClosedSwaps(_swapID) returns (bytes32 secretKey) {
330         return swaps[_swapID].secretKey;
331     }
332 
333     /// @notice Checks whether a swap is refundable or not.
334     ///
335     /// @param _swapID The unique atomic swap id.
336     function refundable(bytes32 _swapID) external view returns (bool) {
337         /* solium-disable-next-line security/no-block-members */
338         return (now >= swaps[_swapID].timelock && _swapStates[_swapID] == States.OPEN);
339     }
340 
341     /// @notice Checks whether a swap is initiatable or not.
342     ///
343     /// @param _swapID The unique atomic swap id.
344     function initiatable(bytes32 _swapID) external view returns (bool) {
345         return (_swapStates[_swapID] == States.INVALID);
346     }
347 
348     /// @notice Checks whether a swap is redeemable or not.
349     ///
350     /// @param _swapID The unique atomic swap id.
351     function redeemable(bytes32 _swapID) external view returns (bool) {
352         return (_swapStates[_swapID] == States.OPEN);
353     }
354 
355     function redeemedAt(bytes32 _swapID) external view returns (uint256) {
356         return _redeemedAt[_swapID];
357     }
358 
359     function brokerFees(address _broker) external view returns (uint256) {
360         return _brokerFees[_broker];
361     }
362 
363     /// @notice Generates a deterministic swap id using initiate swap details.
364     ///
365     /// @param _secretLock The hash of the secret.
366     /// @param _timelock The expiry timestamp.
367     function swapID(bytes32 _secretLock, uint256 _timelock) external pure returns (bytes32) {
368         return keccak256(abi.encodePacked(_secretLock, _timelock));
369     }
370 }
371 
372 /// @notice EthSwap implements the RenEx atomic swapping interface
373 /// for Ether values. Does not support ERC20 tokens.
374 contract EthSwap is SwapInterface, BaseSwap {
375 
376     constructor(string memory _VERSION) BaseSwap(_VERSION) public {
377     }
378     
379     /// @notice Initiates the atomic swap.
380     ///
381     /// @param _swapID The unique atomic swap id.
382     /// @param _spender The address of the withdrawing trader.
383     /// @param _secretLock The hash of the secret (Hash Lock).
384     /// @param _timelock The unix timestamp when the swap expires.
385     /// @param _value The value of the atomic swap.
386     function initiate(
387         bytes32 _swapID,
388         address payable _spender,
389         bytes32 _secretLock,
390         uint256 _timelock,
391         uint256 _value
392     ) public payable {
393         require(_value == msg.value, "eth amount must match value");
394         require(_spender != address(0x0), "spender must not be zero");
395 
396         BaseSwap.initiate(
397             _swapID,
398             _spender,
399             _secretLock,
400             _timelock,
401             _value
402         );
403     }
404 
405     /// @notice Initiates the atomic swap with fees.
406     ///
407     /// @param _swapID The unique atomic swap id.
408     /// @param _spender The address of the withdrawing trader.
409     /// @param _broker The address of the broker.
410     /// @param _brokerFee The fee to be paid to the broker on success.
411     /// @param _secretLock The hash of the secret (Hash Lock).
412     /// @param _timelock The unix timestamp when the swap expires.
413     /// @param _value The value of the atomic swap.
414     function initiateWithFees(
415         bytes32 _swapID,
416         address payable _spender,
417         address payable _broker,
418         uint256 _brokerFee,
419         bytes32 _secretLock,
420         uint256 _timelock,
421         uint256 _value
422     ) public payable {
423         require(_value == msg.value, "eth amount must match value");
424         require(_spender != address(0x0), "spender must not be zero");
425 
426         BaseSwap.initiateWithFees(
427             _swapID,
428             _spender,
429             _broker,
430             _brokerFee,
431             _secretLock,
432             _timelock,
433             _value
434         );
435     }
436 
437     /// @notice Redeems an atomic swap.
438     ///
439     /// @param _swapID The unique atomic swap id.
440     /// @param _receiver The receiver's address.
441     /// @param _secretKey The secret of the atomic swap.
442     function redeem(bytes32 _swapID, address payable _receiver, bytes32 _secretKey) public {
443         BaseSwap.redeem(
444             _swapID,
445             _receiver,
446             _secretKey
447         );
448 
449         // Transfer the ETH funds from this contract to the receiver.
450         _receiver.transfer(BaseSwap.swaps[_swapID].value);
451     }
452 
453     /// @notice Redeems an atomic swap to the spender. Can be called by anyone.
454     ///
455     /// @param _swapID The unique atomic swap id.
456     /// @param _secretKey The secret of the atomic swap.
457     function redeemToSpender(bytes32 _swapID, bytes32 _secretKey) public {
458         BaseSwap.redeemToSpender(
459             _swapID,
460             _secretKey
461         );
462 
463         // Transfer the ETH funds from this contract to the receiver.
464         swaps[_swapID].spender.transfer(BaseSwap.swaps[_swapID].value);
465     }
466 
467     /// @notice Refunds an atomic swap.
468     ///
469     /// @param _swapID The unique atomic swap id.
470     function refund(bytes32 _swapID) public {
471         BaseSwap.refund(_swapID);
472 
473         // Transfer the ETH value from this contract back to the ETH trader.
474         BaseSwap.swaps[_swapID].funder.transfer(
475             BaseSwap.swaps[_swapID].value + BaseSwap.swaps[_swapID].brokerFee
476         );
477     }
478 
479     /// @notice Allows broker fee withdrawals.
480     ///
481     /// @param _amount The withdrawal amount.
482     function withdrawBrokerFees(uint256 _amount) public {
483         BaseSwap.withdrawBrokerFees(_amount);
484         msg.sender.transfer(_amount);
485     }
486 }