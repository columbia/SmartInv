1 pragma solidity ^0.4.24;
2  
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract Erc20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14  
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  * @dev (from OpenZeppelin)
19  */
20 library LibSafeMath {
21     /**
22      * @dev Multiplies two numbers, throws on overflow.
23      */
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         assert(c / a == b);
30         return c;
31     }
32  
33     /**
34      * @dev Integer division of two numbers, truncating the quotient.
35      */
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         // assert(b > 0); // Solidity automatically throws when dividing by 0
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return c;
41     }
42  
43     /**
44      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         assert(b <= a);
48         return a - b;
49     }
50  
51     /**
52      * @dev Adds two numbers, throws on overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         assert(c >= a);
57         return c;
58     }
59  
60     /**
61      * @dev Safe a * b / c
62      */
63     function mulDiv(uint256 a, uint256 b, uint256 c) internal pure returns (uint256) {
64         uint256 d = mul(a, b);
65         return div(d, c);
66     }
67 }
68  
69  
70 contract OwnedToken {
71     using LibSafeMath for uint256;
72    
73     /**
74      * ERC20 info
75      */
76     string public name = 'Altty';
77     string public symbol = 'LTT';
78     uint8 public decimals = 18;
79     /**
80      * Allowence list
81      */
82     mapping (address => mapping (address => uint256)) private allowed;
83     /**
84      * Count of token at each account
85      */
86     mapping(address => uint256) private shares;
87     /**
88      * Total amount
89      */
90     uint256 private shareCount_;
91     /**
92      * Owner (main admin)
93      */
94     address public owner = msg.sender;
95     /**
96      * List of admins
97      */
98     mapping(address => bool) public isAdmin;
99     /**
100      * List of address on hold
101      */
102     mapping(address => bool) public holded;
103  
104     /**
105      * Events
106      */
107     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108     event Transfer(address indexed from, address indexed to, uint256 value);
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110     event Burn(address indexed owner, uint256 amount);
111     event Mint(address indexed to, uint256 amount);
112  
113     /**
114      * @dev Throws if called by any account other than the owner.
115      */
116     modifier onlyOwner() {
117         require(msg.sender == owner);
118         _;
119     }
120     /**
121      * @dev Throws if not admin
122      */
123     modifier onlyAdmin() {
124         require(isAdmin[msg.sender]);
125         _;
126     }
127  
128     /**
129      * @dev Allows the current owner to transfer control of the contract to a newOwner
130      * @param newOwner The address to transfer ownership to
131      */
132     function transferOwnership(address newOwner) onlyOwner public {
133         require(newOwner != address(0)); // if omittet addres, default is 0
134         emit OwnershipTransferred(owner, newOwner);
135         owner = newOwner;
136     }
137     /**
138      * Empower/fire admin
139      */
140     function empowerAdmin(address _user) onlyOwner public {
141         isAdmin[_user] = true;
142     }
143     function fireAdmin(address _user) onlyOwner public {
144         isAdmin[_user] = false;
145     }
146     /**
147      * Hold account
148      */
149     function hold(address _user) onlyOwner public {
150         holded[_user] = true;
151     }
152     /**
153      * Unhold account
154      */
155     function unhold(address _user) onlyOwner public {
156         holded[_user] = false;
157     }
158    
159     /**
160      * Edit token info
161      */
162     function setName(string _name)  onlyOwner public {
163         name = _name;
164     }
165     function setSymbol(string _symbol)  onlyOwner public {
166         symbol = _symbol;
167     }
168     function setDecimals(uint8 _decimals)  onlyOwner public {
169         decimals = _decimals;
170     }
171  
172     /**
173      * @dev total number of tokens in existence
174      */
175     function totalSupply() public view returns (uint256) {
176         return shareCount_;
177     }
178  
179     /**
180      * @dev Gets the balance of the specified address
181      * @param _owner The address to query the the balance of
182      * @return An uint256 representing the amount owned by the passed address
183      */
184     function balanceOf(address _owner) public view returns (uint256 balance) {
185         return shares[_owner];
186     }
187  
188     /**
189      * @dev Internal transfer tokens from one address to another
190      * @dev if adress is zero - mint or destroy tokens
191      * @param _from address The address which you want to send tokens from
192      * @param _to address The address which you want to transfer to
193      * @param _value uint256 the amount of tokens to be transferred
194      */
195     function shareTransfer(address _from, address _to, uint256 _value) internal returns (bool) {
196         require(!holded[_from]);
197         if(_from == address(0)) {
198             emit Mint(_to, _value);
199             shareCount_ =shareCount_.add(_value);
200         } else {
201             require(_value <= shares[_from]);
202             shares[_from] = shares[_from].sub(_value);
203         }
204         if(_to == address(0)) {
205             emit Burn(msg.sender, _value);
206             shareCount_ =shareCount_.sub(_value);
207         } else {
208             shares[_to] =shares[_to].add(_value);
209         }
210         emit Transfer(_from, _to, _value);
211         return true;
212     }
213  
214     /**
215      * @dev transfer token for a specified address
216      * @param _to The address to transfer to
217      * @param _value The amount to be transferred
218      */
219     function transfer(address _to, uint256 _value) public returns (bool) {
220         return shareTransfer(msg.sender, _to, _value);
221     }
222  
223     /**
224      * @dev Transfer tokens from one address to another
225      * @param _from address The address which you want to send tokens from
226      * @param _to address The address which you want to transfer to
227      * @param _value uint256 the amount of tokens to be transferred
228      */
229     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
230         require(_value <= allowed[_from][msg.sender]);
231         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232         return shareTransfer(_from, _to, _value);
233     }
234  
235     /**
236      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237      *
238      * Beware that changing an allowance with this method brings the risk that someone may use both the old
239      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242      * @param _spender The address which will spend the funds.
243      * @param _value The amount of tokens to be spent.
244      */
245     function approve(address _spender, uint256 _value) public returns (bool) {
246         allowed[msg.sender][_spender] = _value;
247         emit Approval(msg.sender, _spender, _value);
248         return true;
249     }
250  
251     /**
252      * @dev Function to check the amount of tokens that an owner allowed to a spender.
253      * @param _owner address The address which owns the funds.
254      * @param _spender address The address which will spend the funds.
255      * @return A uint256 specifying the amount of tokens still available for the spender.
256      */
257     function allowance(address _owner, address _spender) public view returns (uint256) {
258         return allowed[_owner][_spender];
259     }
260  
261     /**
262      * @dev Increase the amount of tokens that an owner allowed to a spender.
263      *
264      * approve should be called when allowed[_spender] == 0. To increment
265      * allowed value is better to use this function to avoid 2 calls (and wait until
266      * the first transaction is mined)
267      * From MonolithDAO Token.sol
268      * @param _spender The address which will spend the funds.
269      * @param _addedValue The amount of tokens to increase the allowance by.
270      */
271     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
272         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
273         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274         return true;
275     }
276  
277     /**
278      * @dev Decrease the amount of tokens that an owner allowed to a spender.
279      *
280      * approve should be called when allowed[_spender] == 0. To decrement
281      * allowed value is better to use this function to avoid 2 calls (and wait until
282      * the first transaction is mined)
283      * From MonolithDAO Token.sol
284      * @param _spender The address which will spend the funds.
285      * @param _subtractedValue The amount of tokens to decrease the allowance by.
286      */
287     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
288         uint oldValue = allowed[msg.sender][_spender];
289         if (_subtractedValue > oldValue) {
290             allowed[msg.sender][_spender] = 0;
291         } else {
292             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293         }
294         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295         return true;
296     }
297    
298     /**
299      * @dev Withdraw ethereum for a specified address
300      * @param _to The address to transfer to
301      * @param _value The amount to be transferred
302      */
303     function withdraw(address _to, uint256 _value) onlyOwner public returns (bool) {
304         require(_to != address(0));
305         require(_value <= address(this).balance);
306         _to.transfer(_value);
307         return true;
308     }
309    
310     /**
311      * @dev Withdraw token (assets of our contract) for a specified address
312      * @param token The address of token for transfer
313      * @param _to The address to transfer to
314      * @param amount The amount to be transferred
315      */
316     function withdrawToken(address token, address _to, uint256 amount) onlyOwner public returns (bool) {
317         require(token != address(0));
318         require(Erc20Basic(token).balanceOf(address(this)) >= amount);
319         bool transferOk = Erc20Basic(token).transfer(_to, amount);
320         require(transferOk);
321         return true;
322     }
323 }
324  
325 contract TenderToken is OwnedToken {
326     // dividends
327     uint256 public price = 3 ether / 1000000;
328     uint256 public sellComission = 2900; // 2.9%
329     uint256 public buyComission = 2900; // 2.9%
330    
331     // dividers
332     uint256 public priceUnits = 1 ether;
333     uint256 public sellComissionUnits = 100000;
334     uint256 public buyComissionUnits = 100000;
335    
336     /**
337      * Orders structs
338      */
339     struct SellOrder {
340         address user;
341         uint256 shareNumber;
342     }
343     struct BuyOrder {
344         address user;
345         uint256 amountWei;
346     }
347    
348     /**
349      * Current orders list and total amounts in order
350      */
351     SellOrder[] public sellOrder;
352     BuyOrder[] public buyOrder;
353     uint256 public sellOrderTotal;
354     uint256 public buyOrderTotal;
355    
356  
357     /**
358      * Magic buy-order create
359      * NB!!! big gas cost (non standart), see docs
360      */
361     function() public payable {
362         if(!isAdmin[msg.sender]) {
363             buyOrder.push(BuyOrder(msg.sender, msg.value));
364             buyOrderTotal += msg.value;
365         }
366     }
367  
368     /**
369      * Magic sell-order create
370      */
371     function shareTransfer(address _from, address _to, uint256 _value) internal returns (bool) {
372         if(_to == address(this)) {
373             sellOrder.push(SellOrder(msg.sender, _value));
374             sellOrderTotal += _value;
375         }
376         return super.shareTransfer(_from, _to, _value);
377     }
378  
379     /**
380      * Configurate current price/comissions
381      */
382     function setPrice(uint256 _price) onlyAdmin public {
383         price = _price;
384     }
385     function setSellComission(uint _sellComission) onlyOwner public {
386         sellComission = _sellComission;
387     }
388     function setBuyComission(uint _buyComission) onlyOwner public {
389         buyComission = _buyComission;
390     }
391     function setPriceUnits(uint256 _priceUnits) onlyOwner public {
392         priceUnits = _priceUnits;
393     }
394     function setSellComissionUnits(uint _sellComissionUnits) onlyOwner public {
395         sellComissionUnits = _sellComissionUnits;
396     }
397     function setBuyComissionUnits(uint _buyComissionUnits) onlyOwner public {
398         buyComissionUnits = _buyComissionUnits;
399     }
400    
401     /**
402      * @dev Calculate default price for selected number of shares
403      * @param shareNumber number of shares
404      * @return amount
405      */
406     function shareToWei(uint256 shareNumber) public view returns (uint256) {
407         uint256 amountWei = shareNumber.mulDiv(price, priceUnits);
408         uint256 comissionWei = amountWei.mulDiv(sellComission, sellComissionUnits);
409         return amountWei.sub(comissionWei);
410     }
411  
412     /**
413      * @dev Calculate count of shares what can buy with selected amount for default price
414      * @param amountWei amount for buy share
415      * @return number of shares
416      */
417     function weiToShare(uint256 amountWei) public view returns (uint256) {
418         uint256 shareNumber = amountWei.mulDiv(priceUnits, price);
419         uint256 comissionShare = shareNumber.mulDiv(buyComission, buyComissionUnits);
420         return shareNumber.sub(comissionShare);
421     }
422    
423     /**
424      * Confirm all buys/sells
425      */
426     function confirmAllBuys() external onlyAdmin {
427         while(buyOrder.length > 0) {
428             _confirmOneBuy();
429         }
430     }
431     function confirmAllSells() external onlyAdmin {
432         while(sellOrder.length > 0) {
433             _confirmOneSell();
434         }
435     }
436    
437     /**
438      * Confirm one sell/buy (for problems fix)
439      */
440     function confirmOneBuy() external onlyAdmin {
441         if(buyOrder.length > 0) {
442             _confirmOneBuy();
443         }
444     }
445     function confirmOneSell() external onlyAdmin {
446         _confirmOneSell();
447     }
448     /**
449      * Cancel one sell (for problem fix)
450      */
451     function cancelOneSell() internal {
452         uint256 i = sellOrder.length-1;
453         shareTransfer(address(this), sellOrder[i].user, sellOrder[i].shareNumber);
454         sellOrderTotal -= sellOrder[i].shareNumber;
455         delete sellOrder[sellOrder.length-1];
456         sellOrder.length--;
457     }
458    
459     /**
460      * Internal buy/sell
461      */
462     function _confirmOneBuy() internal {
463         uint256 i = buyOrder.length-1;
464         uint256 amountWei = buyOrder[i].amountWei;
465         uint256 shareNumber = weiToShare(amountWei);
466         address user = buyOrder[i].user;
467         shareTransfer(address(0), user, shareNumber);
468         buyOrderTotal -= amountWei;
469         delete buyOrder[buyOrder.length-1];
470         buyOrder.length--;
471     }
472     function _confirmOneSell() internal {
473         uint256 i = sellOrder.length-1;
474         uint256 shareNumber = sellOrder[i].shareNumber;
475         uint256 amountWei = shareToWei(shareNumber);
476         address user = sellOrder[i].user;
477         shareTransfer(address(this), address(0), shareNumber);
478         sellOrderTotal -= shareNumber;
479         user.transfer(amountWei);
480         delete sellOrder[sellOrder.length-1];
481         sellOrder.length--;
482     }
483 }