1 /**
2  *Submitted for verification at Etherscan.io on 2017-11-28
3 */
4 
5 pragma solidity ^0.4.17;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46     address public owner;
47 
48     /**
49       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50       * account.
51       */
52     function Ownable() public {
53         owner = msg.sender;
54     }
55 
56     /**
57       * @dev Throws if called by any account other than the owner.
58       */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     /**
65     * @dev Allows the current owner to transfer control of the contract to a newOwner.
66     * @param newOwner The address to transfer ownership to.
67     */
68     function transferOwnership(address newOwner) public onlyOwner {
69         if (newOwner != address(0)) {
70             owner = newOwner;
71         }
72     }
73 
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20Basic {
82     uint public _totalSupply;
83     function totalSupply() public constant returns (uint);
84     function balanceOf(address who) public constant returns (uint);
85     function transfer(address to, uint value) public;
86     event Transfer(address indexed from, address indexed to, uint value);
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) public constant returns (uint);
95     function transferFrom(address from, address to, uint value) public;
96     function approve(address spender, uint value) public;
97     event Approval(address indexed owner, address indexed spender, uint value);
98 }
99 
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  */
104 contract BasicToken is Ownable, ERC20Basic {
105     using SafeMath for uint;
106 
107     mapping(address => uint) public balances;
108 
109     // additional variables for use if transaction fees ever became necessary
110     uint public basisPointsRate = 0;
111     uint public maximumFee = 0;
112 
113     /**
114     * @dev Fix for the ERC20 short address attack.
115     */
116     modifier onlyPayloadSize(uint size) {
117         require(!(msg.data.length < size + 4));
118         _;
119     }
120 
121     /**
122     * @dev transfer token for a specified address
123     * @param _to The address to transfer to.
124     * @param _value The amount to be transferred.
125     */
126     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
127         uint fee = (_value.mul(basisPointsRate)).div(10000);
128         if (fee > maximumFee) {
129             fee = maximumFee;
130         }
131         uint sendAmount = _value.sub(fee);
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(sendAmount);
134         if (fee > 0) {
135             balances[owner] = balances[owner].add(fee);
136             Transfer(msg.sender, owner, fee);
137         }
138         Transfer(msg.sender, _to, sendAmount);
139     }
140 
141     /**
142     * @dev Gets the balance of the specified address.
143     * @param _owner The address to query the the balance of.
144     * @return An uint representing the amount owned by the passed address.
145     */
146     function balanceOf(address _owner) public constant returns (uint balance) {
147         return balances[_owner];
148     }
149 
150 }
151 
152 /**
153  * @title Standard ERC20 token
154  *
155  * @dev Implementation of the basic standard token.
156  * @dev https://github.com/ethereum/EIPs/issues/20
157  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
158  */
159 contract StandardToken is BasicToken, ERC20 {
160 
161     mapping (address => mapping (address => uint)) public allowed;
162 
163     uint public constant MAX_UINT = 2**256 - 1;
164 
165     /**
166     * @dev Transfer tokens from one address to another
167     * @param _from address The address which you want to send tokens from
168     * @param _to address The address which you want to transfer to
169     * @param _value uint the amount of tokens to be transferred
170     */
171     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
172         var _allowance = allowed[_from][msg.sender];
173 
174         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
175         // if (_value > _allowance) throw;
176 
177         uint fee = (_value.mul(basisPointsRate)).div(10000);
178         if (fee > maximumFee) {
179             fee = maximumFee;
180         }
181         if (_allowance < MAX_UINT) {
182             allowed[_from][msg.sender] = _allowance.sub(_value);
183         }
184         uint sendAmount = _value.sub(fee);
185         balances[_from] = balances[_from].sub(_value);
186         balances[_to] = balances[_to].add(sendAmount);
187         if (fee > 0) {
188             balances[owner] = balances[owner].add(fee);
189             Transfer(_from, owner, fee);
190         }
191         Transfer(_from, _to, sendAmount);
192     }
193 
194     /**
195     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196     * @param _spender The address which will spend the funds.
197     * @param _value The amount of tokens to be spent.
198     */
199     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
200 
201         // To change the approve amount you first have to reduce the addresses`
202         //  allowance to zero by calling `approve(_spender, 0)` if it is not
203         //  already 0 to mitigate the race condition described here:
204         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
206 
207         allowed[msg.sender][_spender] = _value;
208         Approval(msg.sender, _spender, _value);
209     }
210 
211     /**
212     * @dev Function to check the amount of tokens than an owner allowed to a spender.
213     * @param _owner address The address which owns the funds.
214     * @param _spender address The address which will spend the funds.
215     * @return A uint specifying the amount of tokens still available for the spender.
216     */
217     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
218         return allowed[_owner][_spender];
219     }
220 
221 }
222 
223 
224 /**
225  * @title Pausable
226  * @dev Base contract which allows children to implement an emergency stop mechanism.
227  */
228 contract Pausable is Ownable {
229   event Pause();
230   event Unpause();
231 
232   bool public paused = false;
233 
234 
235   /**
236    * @dev Modifier to make a function callable only when the contract is not paused.
237    */
238   modifier whenNotPaused() {
239     require(!paused);
240     _;
241   }
242 
243   /**
244    * @dev Modifier to make a function callable only when the contract is paused.
245    */
246   modifier whenPaused() {
247     require(paused);
248     _;
249   }
250 
251   /**
252    * @dev called by the owner to pause, triggers stopped state
253    */
254   function pause() onlyOwner whenNotPaused public {
255     paused = true;
256     Pause();
257   }
258 
259   /**
260    * @dev called by the owner to unpause, returns to normal state
261    */
262   function unpause() onlyOwner whenPaused public {
263     paused = false;
264     Unpause();
265   }
266 }
267 
268 contract BlackList is Ownable, BasicToken {
269 
270     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
271     function getBlackListStatus(address _maker) external constant returns (bool) {
272         return isBlackListed[_maker];
273     }
274 
275     function getOwner() external constant returns (address) {
276         return owner;
277     }
278 
279     mapping (address => bool) public isBlackListed;
280     
281     function addBlackList (address _evilUser) public onlyOwner {
282         isBlackListed[_evilUser] = true;
283         AddedBlackList(_evilUser);
284     }
285 
286     function removeBlackList (address _clearedUser) public onlyOwner {
287         isBlackListed[_clearedUser] = false;
288         RemovedBlackList(_clearedUser);
289     }
290 
291     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
292         require(isBlackListed[_blackListedUser]);
293         uint dirtyFunds = balanceOf(_blackListedUser);
294         balances[_blackListedUser] = 0;
295         _totalSupply -= dirtyFunds;
296         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
297     }
298 
299     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
300 
301     event AddedBlackList(address _user);
302 
303     event RemovedBlackList(address _user);
304 
305 }
306 
307 contract UpgradedStandardToken is StandardToken{
308     // those methods are called by the legacy contract
309     // and they must ensure msg.sender to be the contract address
310     function transferByLegacy(address from, address to, uint value) public;
311     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
312     function approveByLegacy(address from, address spender, uint value) public;
313 }
314 
315 contract CoinWindToken is Pausable, StandardToken, BlackList {
316 
317     string public name;
318     string public symbol;
319     uint public decimals;
320     address public upgradedAddress;
321     bool public deprecated;
322 
323     //  The contract can be initialized with a number of tokens
324     //  All the tokens are deposited to the owner address
325     //
326     // @param _balance Initial supply of the contract
327     // @param _name Token Name
328     // @param _symbol Token symbol
329     // @param _decimals Token decimals
330     function CoinWindToken(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
331         _totalSupply = _initialSupply;
332         name = _name;
333         symbol = _symbol;
334         decimals = _decimals;
335         balances[owner] = _initialSupply;
336         deprecated = false;
337 
338         Transfer(address(0), owner, _initialSupply);
339     }
340 
341     // Forward ERC20 methods to upgraded contract if this one is deprecated
342     function transfer(address _to, uint _value) public whenNotPaused {
343         require(_to != address(this));
344         require(_to != address(0));
345 
346         require(!isBlackListed[msg.sender]);
347         if (deprecated) {
348             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
349         } else {
350             return super.transfer(_to, _value);
351         }
352     }
353 
354     // Forward ERC20 methods to upgraded contract if this one is deprecated
355     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
356         require(_from != address(0));
357 
358         require(_to != address(this));
359         require(_to != address(0));
360 
361         require(!isBlackListed[_from]);
362         if (deprecated) {
363             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
364         } else {
365             return super.transferFrom(_from, _to, _value);
366         }
367     }
368 
369     // Forward ERC20 methods to upgraded contract if this one is deprecated
370     function balanceOf(address who) public constant returns (uint) {
371         if (deprecated) {
372             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
373         } else {
374             return super.balanceOf(who);
375         }
376     }
377 
378     // Forward ERC20 methods to upgraded contract if this one is deprecated
379     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
380         if (deprecated) {
381             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
382         } else {
383             return super.approve(_spender, _value);
384         }
385     }
386 
387     // Forward ERC20 methods to upgraded contract if this one is deprecated
388     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
389         if (deprecated) {
390             return StandardToken(upgradedAddress).allowance(_owner, _spender);
391         } else {
392             return super.allowance(_owner, _spender);
393         }
394     }
395 
396     // deprecate current contract in favour of a new one
397     function deprecate(address _upgradedAddress) public onlyOwner {
398         deprecated = true;
399         upgradedAddress = _upgradedAddress;
400         Deprecate(_upgradedAddress);
401     }
402 
403     // deprecate current contract if favour of a new one
404     function totalSupply() public constant returns (uint) {
405         if (deprecated) {
406             return StandardToken(upgradedAddress).totalSupply();
407         } else {
408             return _totalSupply;
409         }
410     }
411 
412     // Issue a new amount of tokens
413     // these tokens are deposited into the owner address
414     //
415     // @param _amount Number of tokens to be issued
416     function issue(uint amount) public onlyOwner {
417         require(_totalSupply + amount > _totalSupply);
418         require(balances[owner] + amount > balances[owner]);
419 
420         balances[owner] += amount;
421         _totalSupply += amount;
422         Issue(amount);
423 
424         Transfer(address(0), owner, amount);
425     }
426 
427     // Redeem tokens.
428     // These tokens are withdrawn from the owner address
429     // if the balance must be enough to cover the redeem
430     // or the call will fail.
431     // @param _amount Number of tokens to be issued
432     function redeem(uint amount) public onlyOwner {
433         require(_totalSupply >= amount);
434         require(balances[owner] >= amount);
435 
436         _totalSupply -= amount;
437         balances[owner] -= amount;
438         Redeem(amount);
439 
440         Transfer(owner, address(0), amount);
441     }
442 
443     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
444         // Ensure transparency by hardcoding limit beyond which fees can never be added
445         require(newBasisPoints < 20);
446         require(newMaxFee < 50);
447 
448         basisPointsRate = newBasisPoints;
449         maximumFee = newMaxFee.mul(10**decimals);
450 
451         Params(basisPointsRate, maximumFee);
452     }
453 
454     // Called when new token are issued
455     event Issue(uint amount);
456 
457     // Called when tokens are redeemed
458     event Redeem(uint amount);
459 
460     // Called when contract is deprecated
461     event Deprecate(address newAddress);
462 
463     // Called if contract ever adds fees
464     event Params(uint feeBasisPoints, uint maxFee);
465 }