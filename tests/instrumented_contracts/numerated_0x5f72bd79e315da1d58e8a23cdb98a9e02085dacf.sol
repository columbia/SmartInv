1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 
50 contract Ownable {
51   address public owner;
52 
53 
54   event OwnershipRenounced(address indexed previousOwner);
55   event OwnershipTransferred(
56     address indexed previousOwner,
57     address indexed newOwner
58   );
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   constructor() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to relinquish control of the contract.
79    * @notice Renouncing to ownership will leave the contract without an owner.
80    * It will not be possible to call the functions with the `onlyOwner`
81    * modifier anymore.
82    */
83   function renounceOwnership() public onlyOwner {
84     emit OwnershipRenounced(owner);
85     owner = address(0);
86   }
87 
88   /**
89    * @dev Allows the current owner to transfer control of the contract to a newOwner.
90    * @param _newOwner The address to transfer ownership to.
91    */
92   function transferOwnership(address _newOwner) public onlyOwner {
93     _transferOwnership(_newOwner);
94   }
95 
96   /**
97    * @dev Transfers control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function _transferOwnership(address _newOwner) internal {
101     require(_newOwner != address(0));
102     emit OwnershipTransferred(owner, _newOwner);
103     owner = _newOwner;
104   }
105 }
106 
107 
108 contract ERC20Basic {
109   function totalSupply() public view returns (uint256);
110   function balanceOf(address _who) public view returns (uint256);
111   function transfer(address _to, uint256 _value) public returns (bool);
112   event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 contract ERC20 is ERC20Basic {
116   function allowance(address _owner, address _spender)
117     public view returns (uint256);
118 
119   function transferFrom(address _from, address _to, uint256 _value)
120     public returns (bool);
121 
122   function approve(address _spender, uint256 _value) public returns (bool);
123   event Approval(
124     address indexed owner,
125     address indexed spender,
126     uint256 value
127   );
128 }
129 
130 
131 contract Arbitration {
132     function requestArbitration(
133         bytes32 id,
134         uint256 tokens,
135         address supplier,
136         address purchaser
137     )
138         external;
139 }
140 
141 contract Payments is Ownable {
142     struct Details {
143         bool active;
144         address supplier;
145         uint64 cancelDeadline;
146         address purchaser;
147         uint64 disputeDeadline;
148         uint256 price;
149         uint256 deposit;
150         uint256 cancellationFee;
151     }
152 
153     event Invoice (
154         bytes32 id,
155         address supplier,
156         address purchaser,
157         uint256 price,
158         uint256 deposit,
159         uint256 cancellationFee,
160         uint64 cancelDeadline,
161         uint64 disputeDeadline
162     );
163     event Payout (
164         bytes32 id,
165         address supplier,
166         address purchaser,
167         uint256 price,
168         uint256 deposit
169     );
170     event Cancel (
171         bytes32 id,
172         address supplier,
173         address purchaser,
174         uint256 price,
175         uint256 deposit,
176         uint256 cancellationFee
177     );
178     event Refund (
179         bytes32 id,
180         address supplier,
181         address purchaser,
182         uint256 price,
183         uint256 deposit
184     );
185     event Dispute (
186         bytes32 id,
187         address arbitration,
188         address disputant,
189         address supplier,
190         address purchaser,
191         uint256 price,
192         uint256 deposit
193     );
194 
195     modifier onlyPurchaser(bytes32 id) {
196         require(msg.sender == details[id].purchaser, "Purchaser only.");
197         _;
198     }
199 
200     modifier onlySupplier(bytes32 id) {
201         require(msg.sender == details[id].supplier, "Supplier only.");
202         _;        
203     }
204 
205     modifier onlyOwnerOrSupplier(bytes32 id) {
206         require(
207             msg.sender == owner ||
208             msg.sender == details[id].supplier,
209             "Owner or supplier only."
210         );
211         _;
212     }
213 
214     modifier onlyParticipant(bytes32 id) {
215         require(
216             msg.sender == details[id].supplier ||
217             msg.sender == details[id].purchaser,
218             "Participant only."
219         );
220         _;
221     }
222 
223     modifier deactivates(bytes32 id) {
224         require(details[id].active, "Unknown id.");
225         details[id].active = false;
226         _;
227     }
228 
229     modifier invoices(bytes32 id) {
230         require(details[id].supplier == 0x0, "Given id already exists.");
231         _;
232         emit Invoice(
233             id,
234             details[id].supplier,
235             details[id].purchaser,
236             details[id].price,
237             details[id].deposit,
238             details[id].cancellationFee,
239             details[id].cancelDeadline,
240             details[id].disputeDeadline
241         );
242     }
243 
244     modifier pays(bytes32 id) {
245         /* solium-disable-next-line security/no-block-members */
246         require(now > details[id].disputeDeadline, "Dispute deadline not met.");
247         _;
248         emit Payout(
249             id,
250             details[id].supplier,
251             details[id].purchaser,
252             details[id].price,
253             details[id].deposit
254         );
255     }
256 
257     modifier cancels(bytes32 id) {
258         /* solium-disable-next-line security/no-block-members */
259         require(now < details[id].cancelDeadline, "Cancel deadline passed.");
260         _;
261         emit Cancel(
262             id,
263             details[id].supplier,
264             details[id].purchaser,
265             details[id].price,
266             details[id].deposit,
267             details[id].cancellationFee
268         );
269     }
270 
271     modifier refunds(bytes32 id) {
272         _;
273         emit Refund(
274             id,
275             details[id].supplier,
276             details[id].purchaser,
277             details[id].price,
278             details[id].deposit
279         );
280     }
281 
282     modifier disputes(bytes32 id) {
283         /* solium-disable-next-line security/no-block-members */
284         require(now < details[id].disputeDeadline, "Dispute deadline passed.");
285         _;
286         emit Dispute(
287             id,
288             arbitration,
289             msg.sender,
290             details[id].supplier,
291             details[id].purchaser,
292             details[id].price,
293             details[id].deposit
294         );
295     }
296 
297     mapping(bytes32 => Details) public details;
298     Arbitration public arbitration;
299 }
300 
301 contract TokenPayments is Payments {
302     using SafeMath for uint256;
303 
304     ERC20 public token;
305     uint64 public cancelPeriod;
306     uint64 public disputePeriod;
307 
308     constructor(
309         address _token,
310         address _arbitration,
311         uint64 _cancelPeriod,
312         uint64 _disputePeriod
313     )
314         public
315     {
316         token = ERC20(_token);
317         arbitration = Arbitration(_arbitration);
318         cancelPeriod = _cancelPeriod;
319         disputePeriod = _disputePeriod;
320     }
321 
322     function invoice(
323         bytes32 id,
324         address supplier,
325         address purchaser,
326         uint256 price,
327         uint256 deposit,
328         uint256 cancellationFee,
329         uint64 cancelDeadline,
330         uint64 disputeDeadline
331     )
332         external
333         invoices(id)
334     {
335         require(
336             supplier != address(0x0),
337             "Must provide a valid supplier address."
338         );
339         require(
340             purchaser != address(0x0),
341             "Must provide a valid purchaser address."
342         );
343         require(
344             /* solium-disable-next-line security/no-block-members */
345             cancelDeadline > now.add(cancelPeriod),
346             "Cancel deadline too soon."
347         );
348         require(
349             disputeDeadline > uint256(cancelDeadline).add(disputePeriod),
350             "Dispute deadline too soon."
351         );
352         require(
353             price.add(deposit) >= cancellationFee,
354             "Cancellation fee exceeds total."
355         );
356         details[id] = Details({
357             active: true,
358             supplier: supplier,
359             cancelDeadline: cancelDeadline,
360             purchaser: purchaser,
361             disputeDeadline: disputeDeadline,
362             price: price,
363             deposit: deposit,
364             cancellationFee: cancellationFee
365         });
366         uint256 expectedBalance = getTotal(id)
367             .add(token.balanceOf(address(this)));
368         require(
369             token.transferFrom(purchaser, address(this), getTotal(id)),
370             "Transfer failed during invoice."
371         );
372         require(
373             token.balanceOf(address(this)) == expectedBalance,
374             "Transfer appears incomplete during invoice."
375         );
376     }
377 
378     function cancel(bytes32 id) 
379         external
380         onlyPurchaser(id)
381         deactivates(id)
382         cancels(id)
383     {
384         uint256 fee = details[id].cancellationFee;
385         uint256 refund = getTotal(id).sub(fee);
386         transfer(details[id].purchaser, refund);
387         transfer(details[id].supplier, fee);
388     }
389 
390     function payout(bytes32 id)
391         external
392         onlySupplier(id)
393         deactivates(id)
394         pays(id)
395     {
396         transfer(details[id].supplier, details[id].price);
397         transfer(details[id].purchaser, details[id].deposit);
398     }
399 
400     function refund(bytes32 id)
401         external
402         onlyOwnerOrSupplier(id)
403         deactivates(id)
404         refunds(id)
405     {
406         transfer(details[id].purchaser, getTotal(id));
407     }
408 
409     function dispute(bytes32 id)
410         external
411         onlyParticipant(id)
412         deactivates(id)
413         disputes(id)
414     {
415         require(
416             token.approve(arbitration, getTotal(id)),
417             "Approval for transfer failed during dispute."
418         );
419         arbitration.requestArbitration(
420             id,
421             getTotal(id),
422             details[id].supplier,
423             details[id].purchaser
424         );
425     }
426 
427     function getTotal(bytes32 id) private view returns (uint256) {
428         return details[id].price.add(details[id].deposit);
429     }
430 
431     function transfer(address to, uint256 amount) internal {
432         uint256 expectedBalance = token.balanceOf(address(this)).sub(amount);
433         uint256 expectedRecipientBalance = token.balanceOf(to).add(amount);
434         require(token.transfer(to, amount), "Transfer failed.");
435         require(
436             token.balanceOf(address(this)) == expectedBalance,
437             "Post-transfer validation of contract funds failed."
438         );
439         require(
440             token.balanceOf(to) == expectedRecipientBalance,
441             "Post-transfer validation of recipient funds failed."
442         );
443     }
444 }