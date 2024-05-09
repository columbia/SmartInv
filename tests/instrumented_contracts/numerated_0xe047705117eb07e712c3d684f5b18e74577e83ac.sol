1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.4.21 <0.7.0;
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      *
13      * - Addition cannot overflow.
14      */
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21 
22     /**
23      * @dev Returns the subtraction of two unsigned integers, reverting on
24      * overflow (when the result is negative).
25      *
26      * Counterpart to Solidity's `-` operator.
27      *
28      * Requirements:
29      *
30      * - Subtraction cannot overflow.
31      */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `*` operator.
58      *
59      * Requirements:
60      *
61      * - Multiplication cannot overflow.
62      */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the integer division of two unsigned integers. Reverts on
79      * division by zero. The result is rounded towards zero.
80      *
81      * Counterpart to Solidity's `/` operator. Note: this function uses a
82      * `revert` opcode (which leaves remaining gas untouched) while Solidity
83      * uses an invalid opcode to revert (consuming all remaining gas).
84      *
85      * Requirements:
86      *
87      * - The divisor cannot be zero.
88      */
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         return div(a, b, "SafeMath: division by zero");
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         require(b > 0, errorMessage);
107         uint256 c = a / b;
108         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
115      * Reverts when dividing by zero.
116      *
117      * Counterpart to Solidity's `%` operator. This function uses a `revert`
118      * opcode (which leaves remaining gas untouched) while Solidity uses an
119      * invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126         return mod(a, b, "SafeMath: modulo by zero");
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts with custom message when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b != 0, errorMessage);
143         return a % b;
144     }
145 }
146 
147 contract ReentrancyGuard {
148     // Booleans are more expensive than uint256 or any type that takes up a full
149     // word because each write operation emits an extra SLOAD to first read the
150     // slot's contents, replace the bits taken up by the boolean, and then write
151     // back. This is the compiler's defense against contract upgrades and
152     // pointer aliasing, and it cannot be disabled.
153 
154     // The values being non-zero value makes deployment a bit more expensive,
155     // but in exchange the refund on every call to nonReentrant will be lower in
156     // amount. Since refunds are capped to a percentage of the total
157     // transaction's gas, it is best to keep them low in cases like this one, to
158     // increase the likelihood of the full refund coming into effect.
159     uint256 private constant _NOT_ENTERED = 1;
160     uint256 private constant _ENTERED = 2;
161 
162     uint256 private _status;
163 
164     constructor () internal {
165         _status = _NOT_ENTERED;
166     }
167 
168     /**
169      * @dev Prevents a contract from calling itself, directly or indirectly.
170      * Calling a `nonReentrant` function from another `nonReentrant`
171      * function is not supported. It is possible to prevent this from happening
172      * by making the `nonReentrant` function external, and make it call a
173      * `private` function that does the actual work.
174      */
175     modifier nonReentrant() {
176         // On the first call to nonReentrant, _notEntered will be true
177         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
178 
179         // Any calls to nonReentrant after this point will fail
180         _status = _ENTERED;
181 
182         _;
183 
184         // By storing the original value once again, a refund is triggered (see
185         // https://eips.ethereum.org/EIPS/eip-2200)
186         _status = _NOT_ENTERED;
187     }
188 }
189 
190 
191 contract BitcashPay is ReentrancyGuard{
192 
193     using SafeMath for uint256;
194 
195     string public constant name          =           'BitcashPay';
196     string public constant symbol        =           'BCP';
197     uint public totalSupply;
198     uint8 public constant decimals       =           8;
199     address payable owner;
200     uint public buyPriceEth              =           100 szabo;
201     uint public sellPriceEth             =           100 szabo;
202     uint private constant MULTIPLIER     =           100000000;
203 
204     bool public directSellAllowed       =           false;
205     bool public directBuyAllowed        =           false;
206 
207     bool public directTransferAllowed   =           false;
208 
209     uint public reservedCoin            =           175000000;
210     address payable PresaleAddress;
211 
212     mapping(address => uint256) public balanceOf;
213     mapping(address => mapping(address => uint256)) public allowed;
214     
215     event Transfer(address indexed _from, address indexed _to, uint256 _value);
216     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
217 
218     uint private releaseTime = 1627776000;
219     
220     constructor() ReentrancyGuard() public {
221         uint _totalSupply = 850000000;
222         owner = msg.sender;
223         balanceOf[msg.sender] = _totalSupply.mul(MULTIPLIER);
224         totalSupply = _totalSupply.mul(MULTIPLIER);
225     }
226 
227     modifier ownerOnly {
228         if (msg.sender != owner && msg.sender != address(this)) revert("Access Denied!");
229         _;
230     }
231 
232     function burnToken(address account, uint256 amount) ownerOnly public returns (bool success) {
233         require(account != address(0), "ERC20: burn from the zero address");
234 
235         balanceOf[account] = balanceOf[account].sub(amount.mul(MULTIPLIER), "ERC20: burn amount exceeds balance");
236         totalSupply = totalSupply.sub(amount);
237         emit Transfer(account, address(0), amount);
238         return true;
239     }
240 
241     function transferEther(address payable _to, uint _amount) public ownerOnly returns (bool success)
242     {
243         uint amount = _amount * 10 ** 18;
244         _to.transfer(amount.div(1000));
245         return true;
246     }
247 
248     function setBuyPrice(uint buyPrice) public ownerOnly {
249         buyPriceEth = buyPrice;
250     }
251 
252     function setSellPrice(uint sellPrice) public ownerOnly {
253         sellPriceEth = sellPrice;
254     }
255 
256     function allowDirectBuy() private {
257         directBuyAllowed = true;
258     }
259 
260     function allowDirectSell() private {
261         directSellAllowed = true;
262     }
263 
264     function allowDirectTransfer() private {
265         directTransferAllowed = true;
266     }
267 
268     function denyDirectBuy() private {
269         directBuyAllowed = false;
270     }
271 
272     function denyDirectSell() private {
273         directSellAllowed = false;
274     }
275 
276     function denyDirectTransfer() private {
277         directTransferAllowed = false;
278     }
279 
280     function ownerAllowDirectBuy() public ownerOnly {
281         allowDirectBuy();
282     }
283 
284     function ownerAllowDirectSell() public ownerOnly {
285         allowDirectSell();
286     }
287 
288     function ownerAllowDirectTransfer() public ownerOnly {
289         allowDirectTransfer();
290     }
291 
292     function ownerDenyDirectBuy() public ownerOnly {
293         denyDirectBuy();
294     }
295 
296     function ownerDenyDirectSell() public ownerOnly {
297         denyDirectSell();
298     }
299 
300     function ownerDenyDirectTransfer() public ownerOnly {
301         denyDirectTransfer();
302     }
303 
304 
305     function setPresaleAddress(address payable _presaleAddress) public ownerOnly {
306         PresaleAddress = _presaleAddress;
307     }
308 
309 
310     function transfer(address _to, uint _amount) public nonReentrant returns (bool success){
311         if (msg.sender != owner && _to == address(this) && directSellAllowed) {
312             sellBitcashPayAgainstEther(_amount);                             
313             return true;
314         }
315         _transfer(msg.sender, _to, _amount);
316         return true;
317     }
318 
319     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
320         if (balanceOf[_from] >= _value && allowed[_from][msg.sender] >= _value && balanceOf[_to] + _value > balanceOf[_to]) {
321             balanceOf[_from] -= _value;
322             balanceOf[_to] += _value;
323             allowed[_from][msg.sender] -= _value;
324             emit Transfer(_from, _to, _value);
325             return true;
326         } else { return false; }
327     }
328 
329     function approve(address _spender, uint256 _value) public returns (bool success) {
330         allowed[msg.sender][_spender] = _value;
331         emit Approval(msg.sender, _spender, _value);
332         return true;
333     }
334 
335     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
336         return allowed[_owner][_spender];
337     }
338 
339     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
340         require(directTransferAllowed || releaseTime <= block.timestamp, "Direct Transfer is now allowed this time.");
341         require(balanceOf[sender] > amount, "Insufficient Balance");
342         if(msg.sender == address(this)) {
343             require(releaseTime <= block.timestamp, "Reserved token is still locked");
344         }
345 
346         require(sender != address(0), "ERC20: transfer from the zero address");
347         require(recipient != address(0), "ERC20: transfer to the zero address");
348 
349         balanceOf[sender] = balanceOf[sender].sub(amount, "ERC20: transfer amount exceeds balance");
350         balanceOf[recipient] = balanceOf[recipient].add(amount);
351         emit Transfer(sender, recipient, amount);
352     }
353 
354     function sellBitcashPayAgainstEther(uint amount) private nonReentrant returns (uint refund_amount) {
355         allowDirectTransfer();
356         refund_amount = (amount.div(MULTIPLIER)).mul(sellPriceEth);
357 
358         require(sellPriceEth != 0, "Sell price cannot be zero");
359         require(amount.div(MULTIPLIER) >= 100, "Minimum of 100 BCP is required.");
360         require(address(this).balance > refund_amount, "Contract Insuficient Balance");
361         
362         msg.sender.transfer(refund_amount);
363 
364         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount, "ERC20: transfer amount exceeds balance");
365         balanceOf[owner] = balanceOf[owner].add(amount);
366 
367         emit Transfer(address(this), msg.sender, amount);
368         denyDirectTransfer();
369         return refund_amount;
370     }
371 
372     event Bonus (address to, uint value);
373 
374     function getBonus(address _to, uint256 _value) public nonReentrant returns (uint bonus) {
375         require(msg.sender == PresaleAddress, "Access Denied!");
376         balanceOf[owner] = balanceOf[owner].sub(_value, "ERC20: transfer amount exceeds balance");
377         balanceOf[_to] = balanceOf[_to].add(_value);
378         
379         emit Bonus(_to, _value.div(MULTIPLIER));
380         return bonus;
381     }
382 
383     function airDropper(address[] memory _to, uint[] memory _value) public nonReentrant ownerOnly returns (uint) {
384         uint i = 0;
385         while (i < _to.length) {
386             balanceOf[owner] = balanceOf[owner].sub(_value[i].mul(MULTIPLIER), "ERC20: transfer amount exceeds balance");
387             balanceOf[_to[i]] = balanceOf[_to[i]].add(_value[i].mul(MULTIPLIER));
388             i += 1;
389         }
390         return i;
391     }
392 
393     event Sold(address _from, address _to, uint _amount);
394 
395     function buyBitcashPayAgainstEther(address payable _sender, uint256 _amount) public nonReentrant returns (uint amount_sold) {
396         allowDirectTransfer();
397         if(balanceOf[_sender] == 0) {
398             balanceOf[_sender] = balanceOf[_sender].add(MULTIPLIER);
399             balanceOf[_sender] = balanceOf[_sender].sub(MULTIPLIER);
400         }
401         amount_sold = _amount.div(buyPriceEth);
402         amount_sold = amount_sold.mul(MULTIPLIER);
403 
404         _transfer(owner, _sender, amount_sold);
405 
406         emit Sold(owner, _sender, amount_sold);
407         denyDirectTransfer();
408         return amount_sold;
409     }
410 
411     event Received(address _from, uint _amount);
412 
413     receive() external payable {
414         require(directBuyAllowed, "Direct buy to the contract is not available");
415         if (msg.sender != owner) {
416             buyBitcashPayAgainstEther(msg.sender, msg.value);
417         }
418         emit Received(msg.sender, msg.value);
419     }
420 
421 
422 
423 }