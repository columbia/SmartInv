1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     /*
14     event OwnershipRenounced(address indexed previousOwner);
15     */
16     event OwnershipTransferred(
17         address indexed previousOwner,
18         address indexed newOwner
19     );
20 
21 
22     /**
23      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24      * account.
25      */
26     constructor() public {
27         owner = msg.sender;
28     }
29 
30     /**
31      * @dev Throws if called by any account other than the owner.
32      */
33     modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37 
38     /**
39      * @dev Allows the current owner to relinquish control of the contract.
40      * @notice Renouncing to ownership will leave the contract without an owner.
41      * It will not be possible to call the functions with the `onlyOwner`
42      * modifier anymore.
43      */
44     /*
45     function renounceOwnership() public onlyOwner {
46         emit OwnershipRenounced(owner);
47         owner = address(0);
48     }
49     */
50 
51     /**
52      * @dev Allows the current owner to transfer control of the contract to a newOwner.
53      * @param _newOwner The address to transfer ownership to.
54      */
55     function transferOwnership(address _newOwner) public onlyOwner {
56         _transferOwnership(_newOwner);
57     }
58 
59     /**
60      * @dev Transfers control of the contract to a newOwner.
61      * @param _newOwner The address to transfer ownership to.
62      */
63     function _transferOwnership(address _newOwner) internal {
64         require(_newOwner != address(0));
65         emit OwnershipTransferred(owner, _newOwner);
66         owner = _newOwner;
67     }
68 }
69 
70 
71 contract EternalStorage is Ownable {
72 
73     struct Storage {
74         mapping(uint256 => uint256) _uint;
75         mapping(uint256 => address) _address;
76         mapping(address => uint256) _allowed;
77     }
78 
79     Storage internal s;
80 
81     constructor(uint _rF,
82         address _r,
83         address _f,
84         address _a,
85         address _t,
86         uint _sF)
87 
88     public {
89         setAddress(0, _a);
90         setAddress(1, _r);
91         setUint(1, _rF);
92         setAddress(2, _f);
93         setUint(2, _sF);
94         setAddress(3, _t);
95     }
96 
97     modifier onlyAllowed() {
98         require(msg.sender == owner || s._allowed[msg.sender] == uint256(1));
99         _;
100     }
101 
102     function identify(address _address) external onlyOwner {
103         s._allowed[_address] = uint256(1);
104     }
105 
106     function revoke(address _address) external onlyOwner {
107         s._allowed[_address] = uint256(0);
108     }
109 
110     /**
111      * @dev Allows the current owner to transfer control of the contract to a
112      * newOwner.
113      * @param newOwner The address to transfer ownership to.
114      */
115     function transferOwnership(address newOwner) public onlyOwner {
116         Ownable.transferOwnership(newOwner);
117     }
118 
119     /**
120      * @dev Allows the owner to set a value for an unsigned integer variable.
121      * @param i Unsigned integer variable key
122      * @param v The value to be stored
123      */
124     function setUint(uint256 i, uint256 v) public onlyOwner {
125         s._uint[i] = v;
126     }
127 
128     /**
129      * @dev Allows the owner to set a value for a address variable.
130      * @param i Unsigned integer variable key
131      * @param v The value to be stored
132      */
133     function setAddress(uint256 i, address v) public onlyOwner {
134         s._address[i] = v;
135     }
136 
137     /**
138      * @dev Get the value stored of a uint variable by the hash name
139      * @param i Unsigned integer variable key
140      */
141     function getUint(uint256 i) external view onlyAllowed returns (uint256) {
142         return s._uint[i];
143     }
144 
145     /**
146      * @dev Get the value stored of a address variable by the hash name
147      * @param i Unsigned integer variable key
148      */
149     function getAddress(uint256 i) external view onlyAllowed returns (address) {
150         return s._address[i];
151     }
152 
153     function getAllowedStatus(address a) external view onlyAllowed returns (uint) {
154         return s._allowed[a];
155     }
156 
157     function selfDestruct () external onlyOwner {
158         selfdestruct(owner);
159     }
160 }
161 
162 
163 /**
164  * @title ERC20 interface
165  * @dev see https://github.com/ethereum/EIPs/issues/20
166  */
167 contract ERC20 {
168     function totalSupply() public view returns (uint256);
169 
170     function balanceOf(address _who) public view returns (uint256);
171 
172     function allowance(address _owner, address _spender)
173     public view returns (uint256);
174 
175     function transfer(address _to, uint256 _value) public returns (bool);
176 
177     function approve(address _spender, uint256 _value)
178     public returns (bool);
179 
180     function transferFrom(address _from, address _to, uint256 _value)
181     public returns (bool);
182 
183     event Transfer(
184         address indexed from,
185         address indexed to,
186         uint256 value
187     );
188 
189     event Approval(
190         address indexed owner,
191         address indexed spender,
192         uint256 value
193     );
194 }
195 
196 
197 contract Escrow is Ownable {
198 
199     enum transactionStatus {
200         Default,
201         Pending,
202         PendingR1,
203         PendingR2,
204         Completed,
205         Canceled}
206 
207     struct Transaction {
208         transactionStatus status;
209         uint baseAmt;
210         uint txnAmt;
211         uint sellerFee;
212         uint buyerFee;
213         uint buyerBalance;
214         address buyer;
215         uint token;
216     }
217 
218     mapping(address => Transaction) transactions;
219     mapping(address => uint) balance;
220     ERC20 base;
221     ERC20 token;
222     EternalStorage eternal;
223     uint rF;
224     address r;
225     address reserve;
226 
227     constructor(ERC20 _base, address _s) public {
228 
229         base = _base;
230         eternal = EternalStorage(_s);
231 
232     }
233 
234     modifier onlyAllowed() {
235         require(msg.sender == owner || msg.sender == eternal.getAddress(0));
236         _;
237     }
238 
239     function userRecover(address _origin, address _destination, uint _baseAmt) external {
240 
241         transactions[_origin] =
242         Transaction(
243             transactionStatus.PendingR1,
244             _baseAmt,
245             0,
246             eternal.getUint(2),
247             0,
248             0,
249             _destination,
250             0);
251 
252         Transaction storage transaction = transactions[_origin];
253         base.transferFrom(_origin, owner, transaction.sellerFee);
254         base.transferFrom(_origin, reserve, rF);
255         uint destinationAmt = _baseAmt - (transaction.sellerFee + rF);
256         base.transferFrom(_origin, _destination, destinationAmt);
257         recovery(_origin);
258     }
259 
260     function createTransaction (
261 
262         address _tag,
263         uint _baseAmt,
264         uint _txnAmt,
265         uint _sellerFee,
266         uint _buyerFee) external payable {
267 
268         Transaction storage transaction = transactions[_tag];
269         require(transaction.buyer == 0x0);
270         transactions[_tag] =
271         Transaction(
272             transactionStatus.Pending,
273             _baseAmt,
274             _txnAmt,
275             _sellerFee,
276             _buyerFee,
277             0,
278             msg.sender,
279             0);
280 
281         uint buyerTotal = _txnAmt + _buyerFee;
282         require(transaction.buyerBalance + msg.value == buyerTotal);
283         transaction.buyerBalance += msg.value;
284         balance[msg.sender] += msg.value;
285     }
286 
287     function createTokenTransaction (
288 
289         address _tag,
290         uint _baseAmt,
291         uint _txnAmt,
292         uint _sellerFee,
293         uint _buyerFee,
294         address _buyer,
295         uint _token) external onlyAllowed {
296 
297         require(_token != 0);
298         require(eternal.getAddress(_token) != 0x0);
299         Transaction storage transaction = transactions[_tag];
300         require(transaction.buyer == 0x0);
301         transactions[_tag] =
302         Transaction(
303             transactionStatus.Pending,
304             _baseAmt,
305             _txnAmt,
306             _sellerFee,
307             _buyerFee,
308             0,
309             _buyer,
310             _token);
311 
312         uint buyerTotal = _txnAmt + _buyerFee;
313         token = ERC20(eternal.getAddress(_token));
314         token.transferFrom(_buyer, address(this), buyerTotal);
315         transaction.buyerBalance += buyerTotal;
316     }
317 
318     function release(address _tag) external onlyAllowed {
319         releaseFunds(_tag);
320     }
321 
322     function releaseFunds (address _tag) private {
323         Transaction storage transaction = transactions[_tag];
324         require(transaction.status == transactionStatus.Pending);
325         uint buyerTotal = transaction.txnAmt + transaction.buyerFee;
326         uint buyerBalance = transaction.buyerBalance;
327         transaction.buyerBalance = 0;
328         require(buyerTotal == buyerBalance);
329         base.transferFrom(_tag, transaction.buyer, transaction.baseAmt);
330         uint totalFees = transaction.buyerFee + transaction.sellerFee;
331         uint sellerTotal = transaction.txnAmt - transaction.sellerFee;
332         transaction.txnAmt = 0;
333         transaction.sellerFee = 0;
334         if (transaction.token == 0) {
335             _tag.transfer(sellerTotal);
336             owner.transfer(totalFees);
337         } else {
338             token = ERC20(eternal.getAddress(transaction.token));
339             token.transfer(_tag, sellerTotal);
340             token.transfer(owner, totalFees);
341         }
342 
343         transaction.status = transactionStatus.PendingR1;
344         recovery(_tag);
345     }
346 
347     function recovery(address _tag) private {
348         r1(_tag);
349         r2(_tag);
350     }
351 
352     function r1 (address _tag) private {
353         Transaction storage transaction = transactions[_tag];
354         require(transaction.status == transactionStatus.PendingR1);
355         transaction.status = transactionStatus.PendingR2;
356         base.transferFrom(reserve, _tag, rF);
357     }
358 
359     function r2 (address _tag) private {
360         Transaction storage transaction = transactions[_tag];
361         require(transaction.status == transactionStatus.PendingR2);
362         transaction.buyer = 0x0;
363         transaction.status = transactionStatus.Completed;
364         base.transferFrom(_tag, r, rF);
365     }
366 
367     function cancel (address _tag) external onlyAllowed {
368         Transaction storage transaction = transactions[_tag];
369         if (transaction.token == 0) {
370             cancelTransaction(_tag);
371         } else {
372             cancelTokenTransaction(_tag);
373         }
374     }
375 
376     function cancelTransaction (address _tag) private {
377         Transaction storage transaction = transactions[_tag];
378         require(transaction.status == transactionStatus.Pending);
379         uint refund = transaction.buyerBalance;
380         transaction.buyerBalance = 0;
381         address buyer = transaction.buyer;
382         transaction.buyer = 0x0;
383         buyer.transfer(refund);
384         transaction.status = transactionStatus.Canceled;
385     }
386 
387     function cancelTokenTransaction (address _tag) private {
388         Transaction storage transaction = transactions[_tag];
389         require(transaction.status == transactionStatus.Pending);
390         token = ERC20(eternal.getAddress(transaction.token));
391         uint refund = transaction.buyerBalance;
392         transaction.buyerBalance = 0;
393         address buyer = transaction.buyer;
394         transaction.buyer = 0x0;
395         token.transfer(buyer, refund);
396         transaction.status = transactionStatus.Canceled;
397     }
398 
399     function resync () external onlyOwner {
400         rF = eternal.getUint(1);
401         r = eternal.getAddress(1);
402         reserve = eternal.getAddress(2);
403     }
404 
405     function Eternal (address _s) external onlyOwner {
406         eternal = EternalStorage(_s);
407     }
408 
409     function selfDestruct () external onlyOwner {
410         selfdestruct(owner);
411     }
412 
413     function status (address _tag) external view onlyOwner returns (
414         transactionStatus _status,
415         uint _baseAmt,
416         uint _txnAmt,
417         uint _sellerFee,
418         uint _buyerFee,
419         uint _buyerBalance,
420         address _buyer,
421         uint _token) {
422 
423         Transaction storage transaction = transactions[_tag];
424         return (
425         transaction.status,
426         transaction.baseAmt,
427         transaction.txnAmt,
428         transaction.sellerFee,
429         transaction.buyerFee,
430         transaction.buyerBalance,
431         transaction.buyer,
432         transaction.token
433         );
434     }
435 
436     function variables () external view onlyAllowed returns (
437         address,
438         address,
439         address,
440         uint) {
441 
442         address p = eternal.getAddress(0);
443         return (p, r, reserve, rF);
444     }
445 }