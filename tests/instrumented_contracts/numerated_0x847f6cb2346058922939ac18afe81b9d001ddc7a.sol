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
168 
169     /**
170      * @dev total number of tokens in existence
171      */
172     function totalSupply() public view returns (uint256) {
173         return shareCount_;
174     }
175 
176     /**
177      * @dev Gets the balance of the specified address
178      * @param _owner The address to query the the balance of
179      * @return An uint256 representing the amount owned by the passed address
180      */
181     function balanceOf(address _owner) public view returns (uint256 balance) {
182         return shares[_owner];
183     }
184 
185     /**
186      * @dev Internal transfer tokens from one address to another
187      * @dev if adress is zero - mint or destroy tokens
188      * @param _from address The address which you want to send tokens from
189      * @param _to address The address which you want to transfer to
190      * @param _value uint256 the amount of tokens to be transferred
191      */
192     function shareTransfer(address _from, address _to, uint256 _value) internal returns (bool) {
193         require(!holded[_from]);
194         if(_from == address(0)) {
195             emit Mint(_to, _value);
196             shareCount_ =shareCount_.add(_value);
197         } else {
198             require(_value <= shares[_from]);
199             shares[_from] = shares[_from].sub(_value);
200         }
201         if(_to == address(0)) {
202             emit Burn(msg.sender, _value);
203             shareCount_ =shareCount_.sub(_value);
204         } else {
205             shares[_to] =shares[_to].add(_value);
206         }
207         emit Transfer(_from, _to, _value);
208         return true;
209     }
210 
211     /**
212      * @dev transfer token for a specified address
213      * @param _to The address to transfer to
214      * @param _value The amount to be transferred
215      */
216     function transfer(address _to, uint256 _value) public returns (bool) {
217         return shareTransfer(msg.sender, _to, _value);
218     }
219 
220     /**
221      * @dev Transfer tokens from one address to another
222      * @param _from address The address which you want to send tokens from
223      * @param _to address The address which you want to transfer to
224      * @param _value uint256 the amount of tokens to be transferred
225      */
226     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
227         require(_value <= allowed[_from][msg.sender]);
228         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229         return shareTransfer(_from, _to, _value);
230     }
231  
232     /**
233      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234      *
235      * Beware that changing an allowance with this method brings the risk that someone may use both the old
236      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      * @param _spender The address which will spend the funds.
240      * @param _value The amount of tokens to be spent.
241      */
242     function approve(address _spender, uint256 _value) public returns (bool) {
243         allowed[msg.sender][_spender] = _value;
244         emit Approval(msg.sender, _spender, _value);
245         return true;
246     }
247 
248     /**
249      * @dev Function to check the amount of tokens that an owner allowed to a spender.
250      * @param _owner address The address which owns the funds.
251      * @param _spender address The address which will spend the funds.
252      * @return A uint256 specifying the amount of tokens still available for the spender.
253      */
254     function allowance(address _owner, address _spender) public view returns (uint256) {
255         return allowed[_owner][_spender];
256     }
257 
258     /**
259      * @dev Increase the amount of tokens that an owner allowed to a spender.
260      *
261      * approve should be called when allowed[_spender] == 0. To increment
262      * allowed value is better to use this function to avoid 2 calls (and wait until
263      * the first transaction is mined)
264      * From MonolithDAO Token.sol
265      * @param _spender The address which will spend the funds.
266      * @param _addedValue The amount of tokens to increase the allowance by.
267      */
268     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
269         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
270         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271         return true;
272     }
273 
274     /**
275      * @dev Decrease the amount of tokens that an owner allowed to a spender.
276      *
277      * approve should be called when allowed[_spender] == 0. To decrement
278      * allowed value is better to use this function to avoid 2 calls (and wait until
279      * the first transaction is mined)
280      * From MonolithDAO Token.sol
281      * @param _spender The address which will spend the funds.
282      * @param _subtractedValue The amount of tokens to decrease the allowance by.
283      */
284     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
285         uint oldValue = allowed[msg.sender][_spender];
286         if (_subtractedValue > oldValue) {
287             allowed[msg.sender][_spender] = 0;
288         } else {
289             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
290         }
291         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292         return true;
293     }
294     
295     /**
296      * @dev Withdraw ethereum for a specified address
297      * @param _to The address to transfer to
298      * @param _value The amount to be transferred
299      */
300     function withdraw(address _to, uint256 _value) onlyOwner public returns (bool) {
301         require(_to != address(0));
302         require(_value <= address(this).balance);
303         _to.transfer(_value);
304         return true;
305     }
306     
307     /**
308      * @dev Withdraw token (assets of our contract) for a specified address
309      * @param token The address of token for transfer
310      * @param _to The address to transfer to
311      * @param amount The amount to be transferred
312      */
313     function withdrawToken(address token, address _to, uint256 amount) onlyOwner public returns (bool) {
314         require(token != address(0));
315         require(Erc20Basic(token).balanceOf(address(this)) >= amount);
316         bool transferOk = Erc20Basic(token).transfer(_to, amount);
317         require(transferOk);
318         return true;
319     }
320 }
321 
322 contract TenderToken is OwnedToken {
323     // dividends
324     uint256 public price = 1 ether;
325     uint256 public sellComission = 2900; // 2.9%
326     uint256 public buyComission = 2900; // 2.9%
327     
328     // dividers
329     uint256 public priceUnits = 3 ether / 1000000; 
330     uint256 public sellComissionUnits = 100000;
331     uint256 public buyComissionUnits = 100000;
332     
333     /**
334      * Orders structs
335      */
336     struct SellOrder {
337         address user; 
338         uint256 shareNumber;
339     }
340     struct BuyOrder {
341         address user; 
342         uint256 amountWei;
343     }
344     
345     /**
346      * Current orders list and total amounts in order
347      */
348     SellOrder[] internal sellOrder;
349     BuyOrder[] internal buyOrder;
350     uint256 public sellOrderTotal;
351     uint256 public buyOrderTotal;
352     
353 
354     /**
355      * Magic buy-order create
356      * NB!!! big gas cost (non standart), see docs
357      */
358     function() public payable {
359         if(!isAdmin[msg.sender]) {
360             buyOrder.push(BuyOrder(msg.sender, msg.value));
361             buyOrderTotal += msg.value;
362         }
363     }
364 
365     /**
366      * Magic sell-order create
367      */
368     function shareTransfer(address _from, address _to, uint256 _value) internal returns (bool) {
369         if(_to == address(this)) {
370             sellOrder.push(SellOrder(msg.sender, _value));
371             sellOrderTotal += _value;
372         }
373         return super.shareTransfer(_from, _to, _value);
374     }
375 
376     /**
377      * Configurate current price/comissions
378      */
379     function setPrice(uint256 _price) onlyAdmin public {
380         price = _price;
381     }
382     function setSellComission(uint _sellComission) onlyOwner public {
383         sellComission = _sellComission;
384     }
385     function setBuyComission(uint _buyComission) onlyOwner public {
386         buyComission = _buyComission;
387     }
388     
389     /**
390      * @dev Calculate default price for selected number of shares
391      * @param shareNumber number of shares
392      * @return amount
393      */
394     function shareToWei(uint256 shareNumber) public view returns (uint256) {
395         uint256 amountWei = shareNumber.mulDiv(price, priceUnits);
396         uint256 comissionWei = amountWei.mulDiv(sellComission, sellComissionUnits);
397         return amountWei.sub(comissionWei);
398     }
399 
400     /**
401      * @dev Calculate count of shares what can buy with selected amount for default price
402      * @param amountWei amount for buy share
403      * @return number of shares
404      */
405     function weiToShare(uint256 amountWei) public view returns (uint256) {
406         uint256 shareNumber = amountWei.mulDiv(priceUnits, price);
407         uint256 comissionShare = shareNumber.mulDiv(buyComission, buyComissionUnits);
408         return shareNumber.sub(comissionShare);
409     }
410     
411     /**
412      * Confirm all buys
413      */
414     function confirmAllBuys() external onlyAdmin {
415         while(buyOrder.length > 0) {
416             _confirmOneBuy();
417         }
418     }
419     
420     /**
421      * Confirm all sells
422      */
423     function confirmAllSells() external onlyAdmin {
424         while(sellOrder.length > 0) {
425             _confirmOneSell();
426         }
427     }
428     
429     /**
430      * Confirm one sell/buy (for problems fix)
431      */
432     function confirmOneBuy() external onlyAdmin {
433         if(buyOrder.length > 0) {
434             _confirmOneBuy();
435         }
436     }
437     function confirmOneSell() external onlyAdmin {
438         _confirmOneSell();
439     }
440     
441     /**
442      * Cancel one sell (for problem fix)
443      */
444     function cancelOneSell() internal {
445         uint256 i = sellOrder.length-1;
446         shareTransfer(address(this), sellOrder[i].user, sellOrder[i].shareNumber);
447         sellOrderTotal -= sellOrder[i].shareNumber;
448         delete sellOrder[sellOrder.length-1];
449         sellOrder.length--;
450     }
451     
452     /**
453      * Internal buy/sell
454      */
455     function _confirmOneBuy() internal {
456         uint256 i = buyOrder.length-1;
457         uint256 amountWei = buyOrder[i].amountWei;
458         uint256 shareNumber = weiToShare(amountWei);
459         address user = buyOrder[i].user;
460         shareTransfer(address(0), user, shareNumber);
461         buyOrderTotal -= amountWei;
462         delete buyOrder[buyOrder.length-1];
463         buyOrder.length--;
464     }
465     function _confirmOneSell() internal {
466         uint256 i = sellOrder.length-1;
467         uint256 shareNumber = sellOrder[i].shareNumber;
468         uint256 amountWei = shareToWei(shareNumber);
469         address user = sellOrder[i].user;
470         shareTransfer(address(this), address(0), shareNumber);
471         sellOrderTotal -= shareNumber;
472         user.transfer(amountWei);
473         delete sellOrder[sellOrder.length-1];
474         sellOrder.length--;
475     }
476 }