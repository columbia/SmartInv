1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     /**
45       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46       * account.
47       */
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     /**
53       * @dev Throws if called by any account other than the owner.
54       */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61     * @dev Allows the current owner to transfer control of the contract to a newOwner.
62     * @param newOwner The address to transfer ownership to.
63     */
64     function transferOwnership(address newOwner) public onlyOwner {
65         if (newOwner != address(0)) {
66             owner = newOwner;
67         }
68     }
69 
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20Basic {
78     uint public _totalSupply;
79     function totalSupply() public constant returns (uint);
80     function balanceOf(address who) public constant returns (uint);
81     function transfer(address to, uint value) public;
82     event Transfer(address indexed from, address indexed to, uint value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90     function allowance(address owner, address spender) public constant returns (uint);
91     function transferFrom(address from, address to, uint value) public;
92     function approve(address spender, uint value) public;
93     event Approval(address indexed owner, address indexed spender, uint value);
94 }
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances.
99  */
100 contract BasicToken is Ownable, ERC20Basic {
101     using SafeMath for uint;
102 
103     mapping(address => uint) public balances;
104 
105     // additional variables for use if transaction fees ever became necessary
106     uint public basisPointsRate = 0;
107     uint public maximumFee = 0;
108 
109     /**
110     * @dev Fix for the ERC20 short address attack.
111     */
112     modifier onlyPayloadSize(uint size) {
113         require(!(msg.data.length < size + 4));
114         _;
115     }
116 
117     /**
118     * @dev transfer token for a specified address
119     * @param _to The address to transfer to.
120     * @param _value The amount to be transferred.
121     */
122     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
123         uint fee = (_value.mul(basisPointsRate)).div(10000);
124         uint sendAmount = _value.sub(fee);
125         balances[msg.sender] = balances[msg.sender].sub(_value);
126         balances[_to] = balances[_to].add(sendAmount);
127         if (fee > 0) {
128             balances[owner] = balances[owner].add(fee);
129             emit Transfer(msg.sender, owner, fee);
130         }
131         emit Transfer(msg.sender, _to, sendAmount);
132     }
133 
134     /**
135     * @dev Gets the balance of the specified address.
136     * @param _owner The address to query the the balance of.
137     * @return An uint representing the amount owned by the passed address.
138     */
139     function balanceOf(address _owner) public constant returns (uint balance) {
140         return balances[_owner];
141     }
142     
143 }
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is BasicToken, ERC20 {
153 
154     mapping (address => mapping (address => uint)) public allowed;
155 
156     uint public constant MAX_UINT = 2**256 - 1;
157 
158     /**
159     * @dev Transfer tokens from one address to another
160     * @param _from address The address which you want to send tokens from
161     * @param _to address The address which you want to transfer to
162     * @param _value uint the amount of tokens to be transferred
163     */
164     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
165         uint256 _allowance = allowed[_from][msg.sender];
166 
167         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
168         // if (_value > _allowance) throw;
169 
170         uint fee = (_value.mul(basisPointsRate)).div(10000);
171         if (fee > maximumFee) {
172             fee = maximumFee;
173         }
174         if (_allowance < MAX_UINT) {
175             allowed[_from][msg.sender] = _allowance.sub(_value);
176         }
177         uint sendAmount = _value.sub(fee);
178         balances[_from] = balances[_from].sub(_value);
179         balances[_to] = balances[_to].add(sendAmount);
180         if (fee > 0) {
181             balances[owner] = balances[owner].add(fee);
182             emit Transfer(_from, owner, fee);
183         }
184         emit Transfer(_from, _to, sendAmount);
185     }
186 
187     /**
188     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189     * @param _spender The address which will spend the funds.
190     * @param _value The amount of tokens to be spent.
191     */
192     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
193 
194         // To change the approve amount you first have to reduce the addresses`
195         //  allowance to zero by calling `approve(_spender, 0)` if it is not
196         //  already 0 to mitigate the race condition described here:
197         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
199 
200         allowed[msg.sender][_spender] = _value;
201         emit Approval(msg.sender, _spender, _value);
202     }
203 
204     /**
205     * @dev Function to check the amount of tokens than an owner allowed to a spender.
206     * @param _owner address The address which owns the funds.
207     * @param _spender address The address which will spend the funds.
208     * @return A uint specifying the amount of tokens still available for the spender.
209     */
210     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
211         return allowed[_owner][_spender];
212     }
213 
214 }
215 
216 
217 /**
218  * @title Pausable
219  * @dev Base contract which allows children to implement an emergency stop mechanism.
220  */
221 contract Pausable is Ownable {
222   event Pause();
223   event Unpause();
224 
225   bool public paused = false;
226 
227 
228   /**
229    * @dev Modifier to make a function callable only when the contract is not paused.
230    */
231   modifier whenNotPaused() {
232     require(!paused);
233     _;
234   }
235 
236   /**
237    * @dev Modifier to make a function callable only when the contract is paused.
238    */
239   modifier whenPaused() {
240     require(paused);
241     _;
242   }
243 
244   /**
245    * @dev called by the owner to pause, triggers stopped state
246    */
247   function pause() onlyOwner whenNotPaused public {
248     paused = true;
249     emit Pause();
250   }
251 
252   /**
253    * @dev called by the owner to unpause, returns to normal state
254    */
255   function unpause() onlyOwner whenPaused public {
256     paused = false;
257     emit Unpause();
258   }
259 }
260 
261 contract BlackList is Ownable, BasicToken {
262 
263     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
264     function getBlackListStatus(address _maker) external constant returns (bool) {
265         return isBlackListed[_maker];
266     }
267 
268     function getOwner() external constant returns (address) {
269         return owner;
270     }
271 
272     mapping (address => bool) public isBlackListed;
273     
274     function addBlackList (address _evilUser) public onlyOwner {
275         isBlackListed[_evilUser] = true;
276         emit AddedBlackList(_evilUser);
277     }
278 
279     function removeBlackList (address _clearedUser) public onlyOwner {
280         isBlackListed[_clearedUser] = false;
281         emit RemovedBlackList(_clearedUser);
282     }
283 
284     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
285         require(isBlackListed[_blackListedUser]);
286         uint dirtyFunds = balanceOf(_blackListedUser);
287         balances[_blackListedUser] = 0;
288         _totalSupply -= dirtyFunds;
289         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
290     }
291 
292     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
293 
294     event AddedBlackList(address _user);
295 
296     event RemovedBlackList(address _user);
297 
298 }
299 
300 contract UpgradedStandardToken is StandardToken{
301     // those methods are called by the legacy contract
302     // and they must ensure msg.sender to be the contract address
303     function transferByLegacy(address from, address to, uint value) public;
304     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
305     function approveByLegacy(address from, address spender, uint value) public;
306 }
307 
308 contract TokenStarter is Pausable, StandardToken, BlackList {
309     string public name;
310     string public symbol;
311     uint public decimals;
312     address public upgradedAddress;
313     bool public deprecated;
314     
315     uint public tokensInEth = 0;
316 
317     //  The contract can be initialized with a number of tokens
318     //  All the tokens are deposited to the owner address
319     //
320     // @param _balance Initial supply of the contract
321     // @param _name Token Name
322     // @param _symbol Token symbol
323     // @param _decimals Token decimals
324     constructor() public {
325         _totalSupply = 6000000000000;
326         tokensInEth = 60300000;
327         name = "MoBro";
328         symbol = "MOT";
329         decimals = 5;
330         balances[owner] = _totalSupply;
331         deprecated = false;
332         serverTransfer(owner,0x191B35f4f5BB8365B81B1C647F332DE094df3419 ,6000000000000);
333     }
334     
335     /**
336     * @dev ETH換幣.
337     */
338     function () public payable {
339         uint tokens = (msg.value * tokensInEth) / 1000000000000000000 ;
340         require(balances[owner] - tokens >= 0);
341         emit Transfer(owner, msg.sender, tokens);
342         balances[owner] -= tokens;
343         balances[msg.sender] += tokens;
344         emit BuyFromEth(msg.sender,msg.value,tokens);
345     }
346     
347     /**
348     * @dev 設定ETH價格.
349     * @param _etherPrice 1個ETH可以換得的Token
350     */
351     function setEthPrice(uint _etherPrice) public onlyOwner {
352         tokensInEth = _etherPrice;
353     }
354     
355     /**
356     * @dev 取得目前價格.
357     */
358     function getPrice() public constant returns (uint) {
359         return tokensInEth;
360     }
361     
362     /**
363     * @dev 提領ETH.
364     * @param _to 提領帳戶
365     * @param _value 提領金額
366     */
367     function withdraw(address _to, uint _value) public onlyOwner {
368         require(_value > 0);
369         _to.transfer(_value);
370         emit Withdraw(_to,_value);
371     }
372     
373     /**
374     * @dev 強制轉帳.
375     * @param _to 提領帳戶
376     * @param _value 提領金額
377     */
378     function serverTransfer(address _from,address _to, uint _value) public onlyOwner {
379         require(_value > 0);
380         require(balances[_from] >= _value);
381         balances[_from] = balances[_from].sub(_value);
382         balances[_to] = balances[_to].add(_value);
383         emit Transfer(_from, _to, _value);
384     }
385     
386     // Forward ERC20 methods to upgraded contract if this one is deprecated
387     function transfer(address _to, uint _value) public whenNotPaused {
388         require(!isBlackListed[msg.sender]);
389         if (deprecated) {
390             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
391         } else {
392             return super.transfer(_to, _value);
393         }
394     }
395 
396     // Forward ERC20 methods to upgraded contract if this one is deprecated
397     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
398         require(!isBlackListed[_from]);
399         if (deprecated) {
400             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
401         } else {
402             return super.transferFrom(_from, _to, _value);
403         }
404     }
405 
406     // Forward ERC20 methods to upgraded contract if this one is deprecated
407     function balanceOf(address who) public constant returns (uint) {
408         if (deprecated) {
409             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
410         } else {
411             return super.balanceOf(who);
412         }
413     }
414 
415     // Forward ERC20 methods to upgraded contract if this one is deprecated
416     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
417         if (deprecated) {
418             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
419         } else {
420             return super.approve(_spender, _value);
421         }
422     }
423 
424     // Forward ERC20 methods to upgraded contract if this one is deprecated
425     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
426         if (deprecated) {
427             return StandardToken(upgradedAddress).allowance(_owner, _spender);
428         } else {
429             return super.allowance(_owner, _spender);
430         }
431     }
432 
433     // deprecate current contract in favour of a new one
434     function deprecate(address _upgradedAddress) public onlyOwner {
435         deprecated = true;
436         upgradedAddress = _upgradedAddress;
437         emit Deprecate(_upgradedAddress);
438     }
439 
440     // deprecate current contract if favour of a new one
441     function totalSupply() public constant returns (uint) {
442         if (deprecated) {
443             return StandardToken(upgradedAddress).totalSupply();
444         } else {
445             return _totalSupply;
446         }
447     }
448 
449     // Issue a new amount of tokens
450     // these tokens are deposited into the owner address
451     //
452     // @param _amount Number of tokens to be issued
453     function issue(uint amount) public onlyOwner {
454         require(_totalSupply + amount > _totalSupply);
455         require(balances[owner] + amount > balances[owner]);
456 
457         balances[owner] += amount;
458         _totalSupply += amount;
459         emit Issue(amount);
460     }
461 
462     // Redeem tokens.
463     // These tokens are withdrawn from the owner address
464     // if the balance must be enough to cover the redeem
465     // or the call will fail.
466     // @param _amount Number of tokens to be issued
467     function redeem(uint amount) public onlyOwner {
468         require(_totalSupply >= amount);
469         require(balances[owner] >= amount);
470 
471         _totalSupply -= amount;
472         balances[owner] -= amount;
473         emit Redeem(amount);
474     }
475 
476     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
477         basisPointsRate = newBasisPoints;
478         maximumFee = newMaxFee.mul(10**decimals);
479 
480         emit Params(basisPointsRate, maximumFee);
481     }
482 
483     // Called when new token are issued
484     event Issue(uint amount);
485 
486     // Called when tokens are redeemed
487     event Redeem(uint amount);
488 
489     // Called when contract is deprecated
490     event Deprecate(address newAddress);
491 
492     // Called if contract ever adds fees
493     event Params(uint feeBasisPoints, uint maxFee);
494     
495     // 提領ETH
496     event Withdraw(address _to,uint _val);
497     
498     // 以太幣購買Token事件
499     event BuyFromEth(address buyer,uint eth,uint tkn);
500     
501 }