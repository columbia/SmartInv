1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-11
3 */
4 
5 pragma solidity >=0.4.22 <0.6.0;
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://eips.ethereum.org/EIPS/eip-20
10  */
11 interface IERC20 {
12     function transfer(address to, uint256 value) external returns (bool);
13     function approve(address spender, uint256 value) external returns (bool);
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address who) external view returns (uint256);
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 
24 /**
25  * @title SafeMath
26  * @dev Unsigned math operations with safety checks that revert on error
27  */
28 library SafeMath {
29     /**
30      * @dev Multiplies two unsigned integers, reverts on overflow.
31      */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34         // benefit is lost if 'b' is also tested.
35         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b);
42 
43         return c;
44     }
45 
46     /**
47      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
48      */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     /**
59      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
60      */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b <= a);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Adds two unsigned integers, reverts on overflow.
70      */
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a);
74 
75         return c;
76     }
77 
78     /**
79      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
80      * reverts when dividing by zero.
81      */
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b != 0);
84         return a % b;
85     }
86 }
87 
88 
89 
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token
96  */
97 contract ERC20 is IERC20 {
98     using SafeMath for uint256;
99 
100     mapping (address => uint256) public _balances;
101 
102     mapping (address => mapping (address => uint256)) private _allowed;
103 
104     uint256 private _totalSupply =  0;
105     
106     
107     
108 
109     /**
110      * @dev Total number of tokens in existence
111      */
112     function totalSupply() public view returns (uint256) {
113         return _totalSupply;
114     }
115 
116     /**
117      * @dev Gets the balance of the specified address.
118      * @param owner The address to query the balance of.
119      * @return A uint256 representing the amount owned by the passed address.
120      */
121     function balanceOf(address owner) public view returns (uint256) {
122         return _balances[owner];
123     }
124 
125     /**
126      * @dev Function to check the amount of tokens that an owner allowed to a spender.
127      * @param owner address The address which owns the funds.
128      * @param spender address The address which will spend the funds.
129      * @return A uint256 specifying the amount of tokens still available for the spender.
130      */
131     function allowance(address owner, address spender) public view returns (uint256) {
132         return _allowed[owner][spender];
133     }
134 
135     /**
136      * @dev Transfer token to a specified address
137      * @param to The address to transfer to.
138      * @param value The amount to be transferred.
139      */
140     function transfer(address to, uint256 value) public returns (bool) {
141         _transfer(msg.sender, to, value);
142         return true;
143     }
144  
145  
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      * Beware that changing an allowance with this method brings the risk that someone may use both the old
149      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards
151      * @param spender The address which will spend the funds.
152      * @param value The amount of tokens to be spent.
153      */
154     function approve(address spender, uint256 value) public returns (bool) {
155         _approve(msg.sender, spender, value);
156         return true;
157     }
158 
159     /**
160      * @dev Transfer tokens from one address to another.
161      * Note that while this function emits an Approval event, this is not required as per the specification,
162      * and other compliant implementations may not emit the event.
163      * @param from address The address which you want to send tokens from
164      * @param to address The address which you want to transfer to
165      * @param value uint256 the amount of tokens to be transferred
166      */
167     function transferFrom(address from, address to, uint256 value) public returns (bool) {
168         _transfer(from, to, value);
169         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
170         return true;
171     }
172 
173     /**
174      * @dev Increase the amount of tokens that an owner allowed to a spender.
175      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
176      * allowed value is better to use this function to avoid 2 calls (and wait until
177      * the first transaction is mined)
178      * Emits an Approval event.
179      * @param spender The address which will spend the funds.
180      * @param addedValue The amount of tokens to increase the allowance by.
181      */
182     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
183         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
184         return true;
185     }
186 
187     /**
188      * @dev Decrease the amount of tokens that an owner allowed to a spender.
189      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
190      * allowed value is better to use this function to avoid 2 calls (and wait until
191      * the first transaction is mined)
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param subtractedValue The amount of tokens to decrease the allowance by.
195      */
196     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Transfer token for a specified addresses
203      * @param from The address to transfer from.
204      * @param to The address to transfer to.
205      * @param value The amount to be transferred.
206      */
207     function _transfer(address from, address to, uint256 value) internal {
208         require(to != address(0));
209 
210         _balances[from] = _balances[from].sub(value);
211         _balances[to] = _balances[to].add(value);
212         emit Transfer(from, to, value);
213     }
214 
215     /**
216      * @dev Internal function that mints an amount of the token and assigns it to
217      * an account. This encapsulates the modification of balances such that the
218      * proper events are emitted.
219      * @param account The account that will receive the created tokens.
220      * @param value The amount that will be created.
221      */
222     function _mint(address account, uint256 value) internal {
223         require(account != address(0));
224 
225         _totalSupply = _totalSupply.add(value);
226         _balances[account] = _balances[account].add(value);
227         emit Transfer(address(0), account, value);
228     }
229 
230     /**
231      * @dev Internal function that burns an amount of the token of a given
232      * account.
233      * @param account The account whose tokens will be burnt.
234      * @param value The amount that will be burnt.
235      */
236     function _burn(address account, uint256 value) internal {
237         require(account != address(0));
238         require(value <= _balances[account]);
239         _totalSupply = _totalSupply.sub(value);
240         _balances[account] = _balances[account].sub(value);
241         emit Transfer(account, address(0), value);
242     }
243 
244 
245     /**
246      * @dev Approve an address to spend another addresses' tokens.
247      * @param owner The address that owns the tokens.
248      * @param spender The address that will spend the tokens.
249      * @param value The number of tokens that can be spent.
250      */
251     function _approve(address owner, address spender, uint256 value) internal {
252         require(spender != address(0));
253         require(owner != address(0));
254 
255         _allowed[owner][spender] = value;
256         emit Approval(owner, spender, value);
257     }
258 
259     /**
260      * @dev Internal function that burns an amount of the token of a given
261      * account, deducting from the sender's allowance for said account. Uses the
262      * internal burn function.
263      * Emits an Approval event (reflecting the reduced allowance).
264      * @param account The account whose tokens will be burnt.
265      * @param value The amount that will be burnt.
266      */
267     function _burnFrom(address account, uint256 value) internal {
268         _burn(account, value);
269         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
270     }
271 }
272 
273 
274 /**
275  * @title Ownable
276  * @dev The Ownable contract has an owner address, and provides basic authorization control
277  * functions, this simplifies the implementation of "user permissions".
278  */
279 contract Ownable {
280     address private _owner;
281     
282     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
283 
284     /**
285      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
286      * account.
287      */
288     constructor () internal {
289         _owner = msg.sender;
290         emit OwnershipTransferred(address(0), _owner);
291     }
292 
293     /**
294      * @return the address of the owner.
295      */
296     function owner() public view returns (address) {
297         return _owner;
298     }
299 
300     /**
301      * @dev Throws if called by any account other than the owner.
302      */
303     modifier onlyOwner() {
304         require(isOwner());
305         _;
306     }
307 
308     /**
309      * @return true if `msg.sender` is the owner of the contract.
310      */
311     function isOwner() public view returns (bool) {
312         return msg.sender == _owner;
313     }
314 
315     /**
316      * @dev Allows the current owner to relinquish control of the contract.
317      * It will not be possible to call the functions with the `onlyOwner`
318      * modifier anymore.
319      * @notice Renouncing ownership will leave the contract without an owner,
320      * thereby removing any functionality that is only available to the owner.
321      */
322     function renounceOwnership() public onlyOwner {
323         emit OwnershipTransferred(_owner, address(0));
324         _owner = address(0);
325     }
326 
327     /**
328      * @dev Allows the current owner to transfer control of the contract to a newOwner.
329      * @param newOwner The address to transfer ownership to.
330      */
331     function transferOwnership(address newOwner) public onlyOwner {
332         _transferOwnership(newOwner);
333     }
334 
335     /**
336      * @dev Transfers control of the contract to a newOwner.
337      * @param newOwner The address to transfer ownership to.
338      */
339     function _transferOwnership(address newOwner) internal {
340         require(newOwner != address(0));
341         emit OwnershipTransferred(_owner, newOwner);
342         _owner = newOwner;
343     }
344     
345 
346 }
347 
348 
349 
350 
351 /**
352  * @title ERC20Detailed token
353  * @dev The decimals are only for visualization purposes.
354  * All the operations are done using the smallest and indivisible token unit,
355  * just as on Ethereum all the operations are done in wei.
356  */
357 contract ERC20Detailed is IERC20 {
358     string private _name;
359     string private _symbol;
360     uint8 private _decimals;
361 
362     constructor (string memory name, string memory symbol, uint8 decimals) public {
363         _name = name;
364         _symbol = symbol;
365         _decimals = decimals;
366     }
367 
368     /**
369      * @return the name of the token.
370      */
371     function name() public view returns (string memory) {
372         return _name;
373     }
374 
375     /**
376      * @return the symbol of the token.
377      */
378     function symbol() public view returns (string memory) {
379         return _symbol;
380     }
381 
382     /**
383      * @return the number of decimals of the token.
384      */
385     function decimals() public view returns (uint8) {
386         return _decimals;
387     }
388 }
389 
390 
391 
392 contract OlaCoin is ERC20, Ownable, ERC20Detailed {
393     
394 	address teamWallet = 0x4dEE638D625263Df7ed7cb52113DFFB4D5dfF887;
395     address serviceWallet = 0xc9411424D95dEbDd257f7Dff811a76916b66A3b7;
396     address partnerWallet = 0x2D6c412C55DfA4318B9AC4f92EbDEA7b6f741Ab8;
397     address bountyWallet = 0xD4D3C8A12D1bb23865c58C4Eaac35610112d9f15;
398     
399     uint256 private totalCoins; 
400     
401     struct LockItem {
402         uint256  releaseDate;
403         uint256  amount;
404     }
405     
406     mapping (address => LockItem[]) public lockList;
407     mapping (uint => uint) public quarterMap;
408     address [] private lockedAddressList; // list of addresses that have some fund currently or previously locked
409     
410     
411 	constructor() public ERC20Detailed("Ola Coin", "OLC", 6) {  
412 	        
413         quarterMap[1]=1609459200;//=Fri, 01 Jan 2021 00:00:00 GMT
414         quarterMap[2]=1617235200;//=Thu, 01 Apr 2021 00:00:00 GMT
415         quarterMap[3]=1625097600;//=Thu, 01 Jul 2021 00:00:00 GMT
416         quarterMap[4]=1633046400;//=Fri, 01 Oct 2021 00:00:00 GMT
417         quarterMap[5]=1640995200;//=Sat, 01 Jan 2022 00:00:00 GMT
418         quarterMap[6]=1648771200;//=Fri, 01 Apr 2022 00:00:00 GMT
419         quarterMap[7]=1656633600;//=Fri, 01 Jul 2022 00:00:00 GMT
420         quarterMap[8]=1664582400;//=Sat, 01 Oct 2022 00:00:00 GMT
421         quarterMap[9]=1672531200;//=Sun, 01 Jan 2023 00:00:00 GMT
422         quarterMap[10]=1680307200;//=Sat, 01 Apr 2023 00:00:00 GMT
423         quarterMap[11]=1688169600;//=Sat, 01 Jul 2023 00:00:00 GMT
424         quarterMap[12]=1696118400;//=Sun, 01 Oct 2023 00:00:00 GMT
425         quarterMap[13]=1704067200;//=Mon, 01 Jan 2024 00:00:00 GMT
426         quarterMap[14]=1711929600;//=Mon, 01 Apr 2024 00:00:00 GMT
427         quarterMap[15]=1719792000;//=Mon, 01 Jul 2024 00:00:00 GMT
428         quarterMap[16]=1727740800;//=Tue, 01 Oct 2024 00:00:00 GMT
429         quarterMap[17]=1735689600;//=Wed, 01 Jan 2025 00:00:00 GMT
430         quarterMap[18]=1743465600;//=Tue, 01 Apr 2025 00:00:00 GMT
431         quarterMap[19]=1751328000;//=Tue, 01 Jul 2025 00:00:00 GMT
432         quarterMap[20]=1759276800;//=Wed, 01 Oct 2025 00:00:00 GMT
433         quarterMap[21]=1767225600;//=Thu, 01 Jan 2026 00:00:00 GMT
434         quarterMap[22]=1775001600;//=Wed, 01 Apr 2026 00:00:00 GMT
435         quarterMap[23]=1782864000;//=Wed, 01 Jul 2026 00:00:00 GMT
436         quarterMap[24]=1790812800;//=Thu, 01 Oct 2026 00:00:00 GMT
437         quarterMap[25]=1798761600;//=Fri, 01 Jan 2027 00:00:00 GMT
438         quarterMap[26]=1806537600;//=Thu, 01 Apr 2027 00:00:00 GMT
439         quarterMap[27]=1814400000;//=Thu, 01 Jul 2027 00:00:00 GMT
440         quarterMap[28]=1822348800;//=Fri, 01 Oct 2027 00:00:00 GMT
441         quarterMap[29]=1830297600;//=Sat, 01 Jan 2028 00:00:00 GMT
442         quarterMap[30]=1838160000;//=Sat, 01 Apr 2028 00:00:00 GMT
443         quarterMap[31]=1846022400;//=Sat, 01 Jul 2028 00:00:00 GMT
444         quarterMap[32]=1853971200;//=Sun, 01 Oct 2028 00:00:00 GMT
445         quarterMap[33]=1861920000;//=Mon, 01 Jan 2029 00:00:00 GMT
446         quarterMap[34]=1869696000;//=Sun, 01 Apr 2029 00:00:00 GMT
447         quarterMap[35]=1877558400;//=Sun, 01 Jul 2029 00:00:00 GMT
448         quarterMap[36]=1885507200;//=Mon, 01 Oct 2029 00:00:00 GMT
449         quarterMap[37]=1893456000;//=Tue, 01 Jan 2030 00:00:00 GMT
450         quarterMap[38]=1901232000;//=Mon, 01 Apr 2030 00:00:00 GMT
451         quarterMap[39]=1909094400;//=Mon, 01 Jul 2030 00:00:00 GMT
452         
453         totalCoins = 100000000000 * 10 ** uint256(decimals());
454         _mint(owner(), totalCoins); // total supply fixed at 100 billion coins
455         
456         ERC20.transfer(teamWallet, 9000000000 * 10 ** uint256(decimals()));  
457         ERC20.transfer(partnerWallet, 9000000000 * 10 ** uint256(decimals()));
458         ERC20.transfer(serviceWallet, 2000000000 * 10 ** uint256(decimals()));
459         ERC20.transfer(bountyWallet, 2000000000 * 10 ** uint256(decimals()));
460 
461         for(uint i = 1; i<= 39;i++) {
462             transferAndLock(serviceWallet, 2000000000 * 10 ** uint256(decimals()), quarterMap[i]);
463         }
464         
465     }
466 	
467 	
468      /**
469      * @dev transfer of token to another address.
470      * always require the sender has enough balance
471      * @return the bool true if success. 
472      * @param _receiver The address to transfer to.
473      * @param _amount The amount to be transferred.
474      */
475      
476 	function transfer(address _receiver, uint256 _amount) public returns (bool success) {
477 	    require(_receiver != address(0)); 
478 	    require(_amount <= getAvailableBalance(msg.sender));
479         return ERC20.transfer(_receiver, _amount);
480 	}
481 	
482 	/**
483      * @dev transfer of token on behalf of the owner to another address. 
484      * always require the owner has enough balance and the sender is allowed to transfer the given amount
485      * @return the bool true if success. 
486      * @param _from The address to transfer from.
487      * @param _receiver The address to transfer to.
488      * @param _amount The amount to be transferred.
489      */
490     function transferFrom(address _from, address _receiver, uint256 _amount) public returns (bool) {
491         require(_from != address(0));
492         require(_receiver != address(0));
493         require(_amount <= allowance(_from, msg.sender));
494         require(_amount <= getAvailableBalance(_from));
495         return ERC20.transferFrom(_from, _receiver, _amount);
496     }
497 
498     /**
499      * @dev transfer to a given address a given amount and lock this fund until a given time
500      * used for sending fund to team members, partners, or for owner to lock service fund over time
501      * @return the bool true if success.
502      * @param _receiver The address to transfer to.
503      * @param _amount The amount to transfer.
504      * @param _releaseDate The date to release token.
505      */
506 	
507 	function transferAndLock(address _receiver, uint256 _amount, uint256 _releaseDate) public returns (bool success) {
508 	    require(msg.sender == teamWallet || msg.sender == partnerWallet || msg.sender == owner());
509         ERC20._transfer(msg.sender,_receiver,_amount);
510     	
511     	if (lockList[_receiver].length==0) lockedAddressList.push(_receiver);
512 		
513     	LockItem memory item = LockItem({amount:_amount, releaseDate:_releaseDate});
514 		lockList[_receiver].push(item);
515 		
516         return true;
517 	}
518 	
519 	
520     /**
521      * @return the total amount of locked funds of a given address.
522      * @param lockedAddress The address to check.
523      */
524 	function getLockedAmount(address lockedAddress) public view returns(uint256 _amount) {
525 	    uint256 lockedAmount =0;
526 	    for(uint256 j = 0; j<lockList[lockedAddress].length; j++) {
527 	        if(now < lockList[lockedAddress][j].releaseDate) {
528 	            uint256 temp = lockList[lockedAddress][j].amount;
529 	            lockedAmount += temp;
530 	        }
531 	    }
532 	    return lockedAmount;
533 	}
534 	
535 	/**
536      * @return the total amount of locked funds of a given address.
537      * @param lockedAddress The address to check.
538      */
539 	function getAvailableBalance(address lockedAddress) public view returns(uint256 _amount) {
540 	    uint256 bal = balanceOf(lockedAddress);
541 	    uint256 locked = getLockedAmount(lockedAddress);
542 	    return bal.sub(locked);
543 	}
544 	
545 	/**
546      * @dev function that burns an amount of the token of a given account.
547      * @param _amount The amount that will be burnt.
548      */
549     function burn(uint256 _amount) public {
550         _burn(msg.sender, _amount);
551     }
552     
553     function () payable external {   
554         revert();
555     }
556     
557     
558     // the following functions are useful for frontend dApps
559 	
560 	/**
561      * @return the list of all addresses that have at least a fund locked currently or in the past
562      */
563 	function getLockedAddresses() public view returns (address[] memory) {
564 	    return lockedAddressList;
565 	}
566 	
567 	/**
568      * @return the number of addresses that have at least a fund locked currently or in the past
569      */
570 	function getNumberOfLockedAddresses() public view returns (uint256 _count) {
571 	    return lockedAddressList.length;
572 	}
573 	    
574 	    
575 	/**
576      * @return the number of addresses that have at least a fund locked currently
577      */
578 	function getNumberOfLockedAddressesCurrently() public view returns (uint256 _count) {
579 	    uint256 count=0;
580 	    for(uint256 i = 0; i<lockedAddressList.length; i++) {
581 	        if (getLockedAmount(lockedAddressList[i])>0) count++;
582 	    }
583 	    return count;
584 	}
585 	    
586 	/**
587      * @return the list of all addresses that have at least a fund locked currently
588      */
589 	function getLockedAddressesCurrently() public view returns (address[] memory) {
590 	    address [] memory list = new address[](getNumberOfLockedAddressesCurrently());
591 	    uint256 j = 0;
592 	    for(uint256 i = 0; i<lockedAddressList.length; i++) {
593 	        if (getLockedAmount(lockedAddressList[i])>0) {
594 	            list[j] = lockedAddressList[i];
595 	            j++;
596 	        }
597 	    }
598 	    
599         return list;
600     }
601     
602     
603 	/**
604      * @return the total amount of locked funds at the current time
605      */
606 	function getLockedAmountTotal() public view returns(uint256 _amount) {
607 	    uint256 sum =0;
608 	    for(uint256 i = 0; i<lockedAddressList.length; i++) {
609 	        uint256 lockedAmount = getLockedAmount(lockedAddressList[i]);
610     	    sum = sum.add(lockedAmount);
611 	    }
612 	    return sum;
613 	}
614 	    
615 	    
616 	    
617 	/**
618 	 * @return the total amount of circulating coins that are not locked at the current time
619 	 * 
620 	 */
621 	function getCirculatingSupplyTotal() public view returns(uint256 _amount) {
622 	    return totalSupply().sub(getLockedAmountTotal());
623 	}
624     
625     /**
626 	 * @return the total amount of burned coins
627 	 * 
628 	 */
629 	function getBurnedAmountTotal() public view returns(uint256 _amount) {
630 	    return totalCoins.sub(totalSupply());
631 	}
632     
633 }