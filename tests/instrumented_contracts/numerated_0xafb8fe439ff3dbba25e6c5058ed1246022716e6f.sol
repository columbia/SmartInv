1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * It will not be possible to call the functions with the `onlyOwner`
47      * modifier anymore.
48      * @notice Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 /**
76  * @title SafeMath
77  * @dev Unsigned math operations with safety checks that revert on error
78  */
79 library SafeMath {
80     /**
81      * @dev Multiplies two unsigned integers, reverts on overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b);
93 
94         return c;
95     }
96 
97     /**
98      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Solidity only automatically asserts when dividing by 0
102         require(b > 0);
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b <= a);
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     /**
120      * @dev Adds two unsigned integers, reverts on overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a);
125 
126         return c;
127     }
128 
129     /**
130      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
131      * reverts when dividing by zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b != 0);
135         return a % b;
136     }
137 }
138 
139 /**
140  * Utility library of inline functions on addresses
141  */
142 library Address {
143     /**
144      * Returns whether the target address is a contract
145      * @dev This function will return false if invoked during the constructor of a contract,
146      * as the code is not actually created until after the constructor finishes.
147      * @param account address of the account to check
148      * @return whether the target address is a contract
149      */
150     function isContract(address account) internal view returns (bool) {
151         uint256 size;
152         // XXX Currently there is no better way to check if there is a contract in an address
153         // than to check the size of the code at that address.
154         // See https://ethereum.stackexchange.com/a/14016/36603
155         // for more details about how this works.
156         // TODO Check this again before the Serenity release, because all addresses will be
157         // contracts then.
158         // solhint-disable-next-line no-inline-assembly
159         assembly { size := extcodesize(account) }
160         return size > 0;
161     }
162 }
163 
164 /**
165  * @title Helps contracts guard against reentrancy attacks.
166  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
167  * @dev If you mark a function `nonReentrant`, you should also
168  * mark it `external`.
169  */
170 contract ReentrancyGuard {
171     /// @dev counter to allow mutex lock with only one SSTORE operation
172     uint256 private _guardCounter;
173 
174     constructor () internal {
175         // The counter starts at one to prevent changing it from zero to a non-zero
176         // value, which is a more expensive operation.
177         _guardCounter = 1;
178     }
179 
180     /**
181      * @dev Prevents a contract from calling itself, directly or indirectly.
182      * Calling a `nonReentrant` function from another `nonReentrant`
183      * function is not supported. It is possible to prevent this from happening
184      * by making the `nonReentrant` function external, and make it call a
185      * `private` function that does the actual work.
186      */
187     modifier nonReentrant() {
188         _guardCounter += 1;
189         uint256 localCounter = _guardCounter;
190         _;
191         require(localCounter == _guardCounter);
192     }
193 }
194 
195 /**
196  * Phat Cats - Crypto-Cards
197  *  - https://crypto-cards.io
198  *  - https://phatcats.co
199  *
200  * Copyright 2019 (c) Phat Cats, Inc.
201  */
202 
203 /**
204  * @title Crypto-Cards Payroll
205  */
206 contract CryptoCardsPayroll is Ownable, ReentrancyGuard {
207     using SafeMath for uint256;
208 
209     event PayeeAdded(address account, uint256 shares);
210     event PayeeUpdated(address account, uint256 sharesAdded, uint256 totalShares);
211     event PaymentReleased(address to, uint256 amount);
212     event PaymentReceived(address from, uint256 amount);
213 
214     uint256 private _totalShares;
215     uint256 private _totalReleased;
216     uint256 private _totalReleasedAllTime;
217 
218     mapping(address => uint256) private _shares;
219     mapping(address => uint256) private _released;
220     address[] private _payees;
221 
222     /**
223      * @dev Constructor
224      */
225     constructor () public {}
226 
227     /**
228      * @dev payable fallback
229      */
230     function () external payable {
231         emit PaymentReceived(msg.sender, msg.value);
232     }
233 
234     /**
235      * @return the total shares of the contract.
236      */
237     function totalShares() public view returns (uint256) {
238         return _totalShares;
239     }
240 
241     /**
242      * @return the total amount already released.
243      */
244     function totalReleased() public view returns (uint256) {
245         return _totalReleased;
246     }
247 
248     /**
249      * @return the total amount already released.
250      */
251     function totalReleasedAllTime() public view returns (uint256) {
252         return _totalReleasedAllTime;
253     }
254 
255     /**
256      * @return the total amount of funds in the contract.
257      */
258     function totalFunds() public view returns (uint256) {
259         return address(this).balance;
260     }
261 
262     /**
263      * @return the shares of an account.
264      */
265     function shares(address account) public view returns (uint256) {
266         return _shares[account];
267     }
268 
269     /**
270      * @return the shares of an account.
271      */
272     function sharePercentage(address account) public view returns (uint256) {
273         if (_totalShares == 0 || _shares[account] == 0) { return 0; }
274         return _shares[account].mul(100).div(_totalShares);
275     }
276 
277     /**
278      * @return the amount already released to an account.
279      */
280     function released(address account) public view returns (uint256) {
281         return _released[account];
282     }
283 
284     /**
285      * @return the amount available for release to an account.
286      */
287     function available(address account) public view returns (uint256) {
288         uint256 totalReceived = address(this).balance.add(_totalReleased);
289         uint256 totalCut = totalReceived.mul(_shares[account]).div(_totalShares);
290         if (totalCut < _released[account]) { return 0; }
291         return totalCut.sub(_released[account]);
292     }
293 
294     /**
295      * @return the address of a payee.
296      */
297     function payee(uint256 index) public view returns (address) {
298         return _payees[index];
299     }
300 
301     /**
302      * @dev Release payee's proportional payment.
303      */
304     function release() external nonReentrant {
305         address payable account = address(uint160(msg.sender));
306         require(_shares[account] > 0, "Account not eligible for payroll");
307 
308         uint256 payment = available(account);
309         require(payment != 0, "No payment available for account");
310 
311         _release(account, payment);
312     }
313 
314     /**
315      * @dev Release payment for all payees and reset state
316      */
317     function releaseAll() public onlyOwner {
318         _releaseAll();
319         _resetAll();
320     }
321 
322     /**
323      * @dev Add a new payee to the contract.
324      * @param account The address of the payee to add.
325      * @param shares_ The number of shares owned by the payee.
326      */
327     function addNewPayee(address account, uint256 shares_) public onlyOwner {
328         require(account != address(0), "Invalid account");
329         require(Address.isContract(account) == false, "Account cannot be a contract");
330         require(shares_ > 0, "Shares must be greater than zero");
331         require(_shares[account] == 0, "Payee already exists");
332         require(_totalReleased == 0, "Must release all existing payments first");
333 
334         _payees.push(account);
335         _shares[account] = shares_;
336         _totalShares = _totalShares.add(shares_);
337         emit PayeeAdded(account, shares_);
338     }
339 
340     /**
341      * @dev Increase he shares of an existing payee
342      * @param account The address of the payee to increase.
343      * @param shares_ The number of shares to add to the payee.
344      */
345     function increasePayeeShares(address account, uint256 shares_) public onlyOwner {
346         require(account != address(0), "Invalid account");
347         require(shares_ > 0, "Shares must be greater than zero");
348         require(_shares[account] > 0, "Payee does not exist");
349         require(_totalReleased == 0, "Must release all existing payments first");
350 
351         _shares[account] = _shares[account].add(shares_);
352         _totalShares = _totalShares.add(shares_);
353         emit PayeeUpdated(account, shares_, _shares[account]);
354     }
355 
356     /**
357      * @dev Release one of the payee's proportional payment.
358      * @param account Whose payments will be released.
359      */
360     function _release(address payable account, uint256 payment) private {
361         _released[account] = _released[account].add(payment);
362         _totalReleased = _totalReleased.add(payment);
363         _totalReleasedAllTime = _totalReleasedAllTime.add(payment);
364 
365         account.transfer(payment);
366         emit PaymentReleased(account, payment);
367     }
368 
369     /**
370      * @dev Release payment for all payees
371      */
372     function _releaseAll() private {
373         for (uint256 i = 0; i < _payees.length; i++) {
374             _release(address(uint160(_payees[i])), available(_payees[i]));
375         }
376     }
377 
378     /**
379      * @dev Reset state of released payments for all payees
380      */
381     function _resetAll() private {
382         for (uint256 i = 0; i < _payees.length; i++) {
383             _released[_payees[i]] = 0;
384         }
385         _totalReleased = 0;
386     }
387 }