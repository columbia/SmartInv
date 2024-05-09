1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    * @notice Renouncing to ownership will leave the contract without an owner.
90    * It will not be possible to call the functions with the `onlyOwner`
91    * modifier anymore.
92    */
93   function renounceOwnership() public onlyOwner {
94     emit OwnershipRenounced(owner);
95     owner = address(0);
96   }
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param _newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address _newOwner) public onlyOwner {
103     _transferOwnership(_newOwner);
104   }
105 
106   /**
107    * @dev Transfers control of the contract to a newOwner.
108    * @param _newOwner The address to transfer ownership to.
109    */
110   function _transferOwnership(address _newOwner) internal {
111     require(_newOwner != address(0));
112     emit OwnershipTransferred(owner, _newOwner);
113     owner = _newOwner;
114   }
115 }
116 
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * See https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address _who) public view returns (uint256);
126   function transfer(address _to, uint256 _value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address _owner, address _spender)
138     public view returns (uint256);
139 
140   function transferFrom(address _from, address _to, uint256 _value)
141     public returns (bool);
142 
143   function approve(address _spender, uint256 _value) public returns (bool);
144   event Approval(
145     address indexed owner,
146     address indexed spender,
147     uint256 value
148   );
149 }
150 
151 
152 
153 contract Arbitration {
154     function requestArbitration(
155         bytes32 id,
156         uint256 tokens,
157         address supplier,
158         address purchaser
159     )
160         external;
161 }
162 
163 contract TestArbitration is Arbitration, Ownable {
164     event Arbitrate(
165         bytes32 id,
166         uint256 tokens,
167         address supplier,
168         address purchaser
169     );
170 
171     function requestArbitration(
172         bytes32 id,
173         uint256 tokens,
174         address supplier,
175         address purchaser
176     )
177         external
178     {
179         emit Arbitrate(id, tokens, supplier, purchaser);
180     }
181 }
182 
183 
184 contract Whitelist is Ownable {
185     mapping(address => bool) public whitelisted;
186 
187     function whitelist(address caller) public onlyOwner {
188         whitelisted[caller] = true;
189     }
190 
191     function blacklist(address caller) public onlyOwner {
192         whitelisted[caller] = false;
193     }
194 
195     modifier onlyWhitelisted() {
196         require(whitelisted[msg.sender], "Approved callers only.");
197         _;
198     }
199 }
200 
201 contract Payments is Ownable {
202     struct Details {
203         bool active;
204         address supplier;
205         uint64 cancelDeadline;
206         address purchaser;
207         uint64 disputeDeadline;
208         uint256 price;
209         uint256 deposit;
210         uint256 cancellationFee;
211     }
212 
213     event Invoice (
214         bytes32 id,
215         address supplier,
216         address purchaser,
217         uint256 price,
218         uint256 deposit,
219         uint256 cancellationFee,
220         uint64 cancelDeadline,
221         uint64 disputeDeadline
222     );
223     event Payout (
224         bytes32 id,
225         address supplier,
226         address purchaser,
227         uint256 price,
228         uint256 deposit
229     );
230     event Cancel (
231         bytes32 id,
232         address supplier,
233         address purchaser,
234         uint256 price,
235         uint256 deposit,
236         uint256 cancellationFee
237     );
238     event Refund (
239         bytes32 id,
240         address supplier,
241         address purchaser,
242         uint256 price,
243         uint256 deposit
244     );
245     event Dispute (
246         bytes32 id,
247         address arbitration,
248         address disputant,
249         address supplier,
250         address purchaser,
251         uint256 price,
252         uint256 deposit
253     );
254 
255     modifier onlyPurchaser(bytes32 id) {
256         require(msg.sender == details[id].purchaser, "Purchaser only.");
257         _;
258     }
259 
260     modifier onlySupplier(bytes32 id) {
261         require(msg.sender == details[id].supplier, "Supplier only.");
262         _;        
263     }
264 
265     modifier onlyOwnerOrSupplier(bytes32 id) {
266         require(
267             msg.sender == owner ||
268             msg.sender == details[id].supplier,
269             "Owner or supplier only."
270         );
271         _;
272     }
273 
274     modifier onlyParticipant(bytes32 id) {
275         require(
276             msg.sender == details[id].supplier ||
277             msg.sender == details[id].purchaser,
278             "Participant only."
279         );
280         _;
281     }
282 
283     modifier deactivates(bytes32 id) {
284         require(details[id].active, "Unknown id.");
285         details[id].active = false;
286         _;
287     }
288 
289     modifier invoices(bytes32 id) {
290         require(details[id].supplier == 0x0, "Given id already exists.");
291         _;
292         emit Invoice(
293             id,
294             details[id].supplier,
295             details[id].purchaser,
296             details[id].price,
297             details[id].deposit,
298             details[id].cancellationFee,
299             details[id].cancelDeadline,
300             details[id].disputeDeadline
301         );
302     }
303 
304     modifier pays(bytes32 id) {
305         /* solium-disable-next-line security/no-block-members */
306         require(now > details[id].disputeDeadline, "Dispute deadline not met.");
307         _;
308         emit Payout(
309             id,
310             details[id].supplier,
311             details[id].purchaser,
312             details[id].price,
313             details[id].deposit
314         );
315     }
316 
317     modifier cancels(bytes32 id) {
318         /* solium-disable-next-line security/no-block-members */
319         require(now < details[id].cancelDeadline, "Cancel deadline passed.");
320         _;
321         emit Cancel(
322             id,
323             details[id].supplier,
324             details[id].purchaser,
325             details[id].price,
326             details[id].deposit,
327             details[id].cancellationFee
328         );
329     }
330 
331     modifier refunds(bytes32 id) {
332         _;
333         emit Refund(
334             id,
335             details[id].supplier,
336             details[id].purchaser,
337             details[id].price,
338             details[id].deposit
339         );
340     }
341 
342     modifier disputes(bytes32 id) {
343         /* solium-disable-next-line security/no-block-members */
344         require(now < details[id].disputeDeadline, "Dispute deadline passed.");
345         _;
346         emit Dispute(
347             id,
348             arbitration,
349             msg.sender,
350             details[id].supplier,
351             details[id].purchaser,
352             details[id].price,
353             details[id].deposit
354         );
355     }
356 
357     mapping(bytes32 => Details) public details;
358     Arbitration public arbitration;
359 }
360 
361 contract TokenPayments is Whitelist, Payments {
362     using SafeMath for uint256;
363 
364     ERC20 public token;
365     uint64 public cancelPeriod;
366     uint64 public disputePeriod;
367 
368     constructor(
369         address _token,
370         address _arbitration,
371         uint64 _cancelPeriod,
372         uint64 _disputePeriod
373     )
374         public
375     {
376         token = ERC20(_token);
377         arbitration = Arbitration(_arbitration);
378         cancelPeriod = _cancelPeriod;
379         disputePeriod = _disputePeriod;
380     }
381 
382     function invoice(
383         bytes32 id,
384         address supplier,
385         address purchaser,
386         uint256 price,
387         uint256 deposit,
388         uint256 cancellationFee,
389         uint64 cancelDeadline,
390         uint64 disputeDeadline
391     )
392         external
393         onlyWhitelisted
394         invoices(id)
395     {
396         require(
397             supplier != address(0x0),
398             "Must provide a valid supplier address."
399         );
400         require(
401             purchaser != address(0x0),
402             "Must provide a valid purchaser address."
403         );
404         require(
405             /* solium-disable-next-line security/no-block-members */
406             cancelDeadline > now.add(cancelPeriod),
407             "Cancel deadline too soon."
408         );
409         require(
410             disputeDeadline > uint256(cancelDeadline).add(disputePeriod),
411             "Dispute deadline too soon."
412         );
413         require(
414             price.add(deposit) >= cancellationFee,
415             "Cancellation fee exceeds total."
416         );
417         details[id] = Details({
418             active: true,
419             supplier: supplier,
420             cancelDeadline: cancelDeadline,
421             purchaser: purchaser,
422             disputeDeadline: disputeDeadline,
423             price: price,
424             deposit: deposit,
425             cancellationFee: cancellationFee
426         });
427         uint256 expectedBalance = getTotal(id)
428             .add(token.balanceOf(address(this)));
429         require(
430             token.transferFrom(purchaser, address(this), getTotal(id)),
431             "Transfer failed during invoice."
432         );
433         require(
434             token.balanceOf(address(this)) == expectedBalance,
435             "Transfer appears incomplete during invoice."
436         );
437     }
438 
439     function cancel(bytes32 id) 
440         external
441         onlyPurchaser(id)
442         deactivates(id)
443         cancels(id)
444     {
445         uint256 fee = details[id].cancellationFee;
446         uint256 refund = getTotal(id).sub(fee);
447         transfer(details[id].purchaser, refund);
448         transfer(details[id].supplier, fee);
449     }
450 
451     function payout(bytes32 id)
452         external
453         onlySupplier(id)
454         deactivates(id)
455         pays(id)
456     {
457         transfer(details[id].supplier, details[id].price);
458         transfer(details[id].purchaser, details[id].deposit);
459     }
460 
461     function refund(bytes32 id)
462         external
463         onlyOwnerOrSupplier(id)
464         deactivates(id)
465         refunds(id)
466     {
467         transfer(details[id].purchaser, getTotal(id));
468     }
469 
470     function dispute(bytes32 id)
471         external
472         onlyParticipant(id)
473         deactivates(id)
474         disputes(id)
475     {
476         require(
477             token.approve(arbitration, getTotal(id)),
478             "Approval for transfer failed during dispute."
479         );
480         arbitration.requestArbitration(
481             id,
482             getTotal(id),
483             details[id].supplier,
484             details[id].purchaser
485         );
486     }
487 
488     function getTotal(bytes32 id) private view returns (uint256) {
489         return details[id].price.add(details[id].deposit);
490     }
491 
492     function transfer(address to, uint256 amount) internal {
493         uint256 expectedBalance = token.balanceOf(address(this)).sub(amount);
494         uint256 expectedRecipientBalance = token.balanceOf(to).add(amount);
495         require(token.transfer(to, amount), "Transfer failed.");
496         require(
497             token.balanceOf(address(this)) == expectedBalance,
498             "Post-transfer validation of contract funds failed."
499         );
500         require(
501             token.balanceOf(to) == expectedRecipientBalance,
502             "Post-transfer validation of recipient funds failed."
503         );
504     }
505 }