1 pragma solidity ^0.4.24;
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
13     event OwnershipRenounced(address indexed previousOwner);
14     event OwnershipTransferred(
15         address indexed previousOwner,
16         address indexed newOwner
17     );
18 
19 
20     /**
21      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22      * account.
23      */
24     constructor() public {
25         owner = msg.sender;
26     }
27 
28     /**
29      * @dev Throws if called by any account other than the owner.
30      */
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     /**
37      * @dev Allows the current owner to relinquish control of the contract.
38      * @notice Renouncing to ownership will leave the contract without an owner.
39      * It will not be possible to call the functions with the `onlyOwner`
40      * modifier anymore.
41      */
42     function renounceOwnership() public onlyOwner {
43         emit OwnershipRenounced(owner);
44         owner = address(0);
45     }
46 
47     /**
48      * @dev Allows the current owner to transfer control of the contract to a newOwner.
49      * @param _newOwner The address to transfer ownership to.
50      */
51     function transferOwnership(address _newOwner) public onlyOwner {
52         _transferOwnership(_newOwner);
53     }
54 
55     /**
56      * @dev Transfers control of the contract to a newOwner.
57      * @param _newOwner The address to transfer ownership to.
58      */
59     function _transferOwnership(address _newOwner) internal {
60         require(_newOwner != address(0));
61         emit OwnershipTransferred(owner, _newOwner);
62         owner = _newOwner;
63     }
64 }
65 
66 
67 contract EternalStorage is Ownable {
68 
69     struct Storage {
70         mapping(uint256 => uint256) _uint;
71         mapping(uint256 => address) _address;
72     }
73 
74     Storage internal s;
75     address allowed;
76 
77     constructor(uint _rF, address _r, address _f, address _a, address _t)
78 
79     public {
80         setAddress(0, _a);
81         setAddress(1, _r);
82         setUint(1, _rF);
83         setAddress(2, _f);
84         setAddress(3, _t);
85     }
86 
87     modifier onlyAllowed() {
88         require(msg.sender == owner || msg.sender == allowed);
89         _;
90     }
91 
92     function identify(address _address) external onlyOwner {
93         allowed = _address;
94     }
95 
96     /**
97      * @dev Allows the current owner to transfer control of the contract to a
98      * newOwner.
99      * @param newOwner The address to transfer ownership to.
100      */
101     function transferOwnership(address newOwner) public onlyOwner {
102         Ownable.transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Allows the owner to set a value for an unsigned integer variable.
107      * @param i Unsigned integer variable key
108      * @param v The value to be stored
109      */
110     function setUint(uint256 i, uint256 v) public onlyOwner {
111         s._uint[i] = v;
112     }
113 
114     /**
115      * @dev Allows the owner to set a value for a address variable.
116      * @param i Unsigned integer variable key
117      * @param v The value to be stored
118      */
119     function setAddress(uint256 i, address v) public onlyOwner {
120         s._address[i] = v;
121     }
122 
123     /**
124      * @dev Get the value stored of a uint variable by the hash name
125      * @param i Unsigned integer variable key
126      */
127     function getUint(uint256 i) external view onlyAllowed returns (uint256) {
128         return s._uint[i];
129     }
130 
131     /**
132      * @dev Get the value stored of a address variable by the hash name
133      * @param i Unsigned integer variable key
134      */
135     function getAddress(uint256 i) external view onlyAllowed returns (address) {
136         return s._address[i];
137     }
138 
139     function selfDestruct () external onlyOwner {
140         selfdestruct(owner);
141     }
142 }
143 
144 
145 /**
146  * @title ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/20
148  */
149 contract ERC20 {
150     function totalSupply() public view returns (uint256);
151 
152     function balanceOf(address _who) public view returns (uint256);
153 
154     function allowance(address _owner, address _spender)
155     public view returns (uint256);
156 
157     function transfer(address _to, uint256 _value) public returns (bool);
158 
159     function approve(address _spender, uint256 _value)
160     public returns (bool);
161 
162     function transferFrom(address _from, address _to, uint256 _value)
163     public returns (bool);
164 
165     event Transfer(
166         address indexed from,
167         address indexed to,
168         uint256 value
169     );
170 
171     event Approval(
172         address indexed owner,
173         address indexed spender,
174         uint256 value
175     );
176 }
177 
178 
179 contract Escrow is Ownable {
180 
181     enum transactionStatus {
182         Default,
183         Pending,
184         PendingR1,
185         PendingR2,
186         Completed,
187         Canceled}
188 
189     struct Transaction {
190         transactionStatus status;
191         uint baseAmt;
192         uint txnAmt;
193         uint sellerFee;
194         uint buyerFee;
195         uint buyerBalance;
196         address buyer;
197         uint token;
198     }
199 
200     mapping(address => Transaction) transactions;
201     mapping(address => uint) balance;
202     ERC20 base;
203     ERC20 token;
204     EternalStorage eternal;
205     uint rF;
206     address r;
207     address reserve;
208 
209     constructor(ERC20 _base, address _s) public {
210 
211         base = _base;
212         eternal = EternalStorage(_s);
213 
214     }
215 
216     modifier onlyAllowed() {
217         require(msg.sender == owner || msg.sender == eternal.getAddress(0));
218         _;
219     }
220 
221     function createTransaction (
222 
223         address _tag,
224         uint _baseAmt,
225         uint _txnAmt,
226         uint _sellerFee,
227         uint _buyerFee) external payable {
228 
229         Transaction storage transaction = transactions[_tag];
230         require(transaction.buyer == 0x0);
231         transactions[_tag] =
232         Transaction(
233             transactionStatus.Pending,
234             _baseAmt,
235             _txnAmt,
236             _sellerFee,
237             _buyerFee,
238             0,
239             msg.sender,
240             0);
241 
242         uint buyerTotal = _txnAmt + _buyerFee;
243         require(transaction.buyerBalance + msg.value == buyerTotal);
244         transaction.buyerBalance += msg.value;
245         balance[msg.sender] += msg.value;
246     }
247 
248     function createTokenTransaction (
249 
250         address _tag,
251         uint _baseAmt,
252         uint _txnAmt,
253         uint _sellerFee,
254         uint _buyerFee,
255         address _buyer,
256         uint _token) external onlyAllowed {
257 
258         require(_token != 0);
259         require(eternal.getAddress(_token) != 0x0);
260         Transaction storage transaction = transactions[_tag];
261         require(transaction.buyer == 0x0);
262         transactions[_tag] =
263         Transaction(
264             transactionStatus.Pending,
265             _baseAmt,
266             _txnAmt,
267             _sellerFee,
268             _buyerFee,
269             0,
270             _buyer,
271             _token);
272 
273         uint buyerTotal = _txnAmt + _buyerFee;
274         token = ERC20(eternal.getAddress(_token));
275         token.transferFrom(_buyer, address(this), buyerTotal);
276         transaction.buyerBalance += buyerTotal;
277     }
278 
279     function release(address _tag) external onlyAllowed {
280         releaseFunds(_tag);
281     }
282 
283     function releaseFunds (address _tag) private {
284         Transaction storage transaction = transactions[_tag];
285         require(transaction.status == transactionStatus.Pending);
286         uint buyerTotal = transaction.txnAmt + transaction.buyerFee;
287         uint buyerBalance = transaction.buyerBalance;
288         transaction.buyerBalance = 0;
289         require(buyerTotal == buyerBalance);
290         base.transferFrom(_tag, transaction.buyer, transaction.baseAmt);
291         uint totalFees = transaction.buyerFee + transaction.sellerFee;
292         uint sellerTotal = transaction.txnAmt - transaction.sellerFee;
293         transaction.txnAmt = 0;
294         transaction.sellerFee = 0;
295         if (transaction.token == 0) {
296             _tag.transfer(sellerTotal);
297             owner.transfer(totalFees);
298         } else {
299             token = ERC20(eternal.getAddress(transaction.token));
300             token.transfer(_tag, sellerTotal);
301             token.transfer(owner, totalFees);
302         }
303 
304         transaction.status = transactionStatus.PendingR1;
305         recovery(_tag);
306     }
307 
308     function recovery(address _tag) private {
309         r1(_tag);
310         r2(_tag);
311     }
312 
313     function r1 (address _tag) private {
314         Transaction storage transaction = transactions[_tag];
315         require(transaction.status == transactionStatus.PendingR1);
316         transaction.status = transactionStatus.PendingR2;
317         base.transferFrom(reserve, _tag, rF);
318     }
319 
320     function r2 (address _tag) private {
321         Transaction storage transaction = transactions[_tag];
322         require(transaction.status == transactionStatus.PendingR2);
323         transaction.buyer = 0x0;
324         transaction.status = transactionStatus.Completed;
325         base.transferFrom(_tag, r, rF);
326     }
327 
328     function cancel (address _tag) external onlyAllowed {
329         Transaction storage transaction = transactions[_tag];
330         if (transaction.token == 0) {
331             cancelTransaction(_tag);
332         } else {
333             cancelTokenTransaction(_tag);
334         }
335     }
336 
337     function cancelTransaction (address _tag) private {
338         Transaction storage transaction = transactions[_tag];
339         require(transaction.status == transactionStatus.Pending);
340         uint refund = transaction.buyerBalance;
341         transaction.buyerBalance = 0;
342         address buyer = transaction.buyer;
343         transaction.buyer = 0x0;
344         buyer.transfer(refund);
345         transaction.status = transactionStatus.Canceled;
346     }
347 
348     function cancelTokenTransaction (address _tag) private {
349         Transaction storage transaction = transactions[_tag];
350         require(transaction.status == transactionStatus.Pending);
351         token = ERC20(eternal.getAddress(transaction.token));
352         uint refund = transaction.buyerBalance;
353         transaction.buyerBalance = 0;
354         address buyer = transaction.buyer;
355         transaction.buyer = 0x0;
356         token.transfer(buyer, refund);
357         transaction.status = transactionStatus.Canceled;
358     }
359 
360     function resync () external onlyOwner {
361         rF = eternal.getUint(1);
362         r = eternal.getAddress(1);
363         reserve = eternal.getAddress(2);
364     }
365 
366     function selfDestruct () external onlyOwner {
367         selfdestruct(owner);
368     }
369 
370     function status (address _tag) external view onlyOwner returns (
371         transactionStatus _status,
372         uint _baseAmt,
373         uint _txnAmt,
374         uint _sellerFee,
375         uint _buyerFee,
376         uint _buyerBalance,
377         address _buyer,
378         uint _token) {
379 
380         Transaction storage transaction = transactions[_tag];
381         return (
382         transaction.status,
383         transaction.baseAmt,
384         transaction.txnAmt,
385         transaction.sellerFee,
386         transaction.buyerFee,
387         transaction.buyerBalance,
388         transaction.buyer,
389         transaction.token
390         );
391     }
392 
393     function getAddress (uint i) external view onlyAllowed returns (address) {
394         return eternal.getAddress(i);
395     }
396 
397     function variables () external view onlyAllowed returns (
398         address,
399         address,
400         address,
401         uint) {
402 
403         address p = eternal.getAddress(0);
404         return (p, r, reserve, rF);
405     }
406 
407 }