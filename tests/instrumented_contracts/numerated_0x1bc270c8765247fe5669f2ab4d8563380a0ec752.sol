1 pragma solidity ^0.4.17;
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
48     function Ownable() public {
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
69 }
70   
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20Basic {
77     uint public _totalSupply;
78     function totalSupply() public constant returns (uint);
79     function balanceOf(address who) public constant returns (uint);
80     function transfer(address to, uint value) public;
81     event Transfer(address indexed from, address indexed to, uint value);
82 }
83   
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89     function allowance(address owner, address spender) public constant returns (uint);
90     function transferFrom(address from, address to, uint value) public;
91     function approve(address spender, uint value) public;
92     event Approval(address indexed owner, address indexed spender, uint value);
93 }
94   
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is Ownable, ERC20Basic {
100     using SafeMath for uint;
101   
102     mapping(address => uint) public balances;
103   
104     // additional variables for use if transaction fees ever became necessary
105     uint public basisPointsRate = 0;
106     uint public maximumFee = 0;
107   
108     /**
109     * @dev Fix for the ERC20 short address attack.
110     */
111     modifier onlyPayloadSize(uint size) {
112         require(!(msg.data.length < size + 4));
113         _;
114     }
115   
116     /**
117     * @dev transfer token for a specified address
118     * @param _to The address to transfer to.
119     * @param _value The amount to be transferred.
120     */
121     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
122         uint fee = (_value.mul(basisPointsRate)).div(10000);
123         if (fee > maximumFee) {
124             fee = maximumFee;
125         }
126         uint sendAmount = _value.sub(fee);
127         balances[msg.sender] = balances[msg.sender].sub(_value);
128         balances[_to] = balances[_to].add(sendAmount);
129         if (fee > 0) {
130             balances[owner] = balances[owner].add(fee);
131             Transfer(msg.sender, owner, fee);
132         }
133         Transfer(msg.sender, _to, sendAmount);
134     }
135   
136     /**
137     * @dev Gets the balance of the specified address.
138     * @param _owner The address to query the the balance of.
139     * @return An uint representing the amount owned by the passed address.
140     */
141     function balanceOf(address _owner) public constant returns (uint balance) {
142         return balances[_owner];
143     }
144   
145 }
146   
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * @dev https://github.com/ethereum/EIPs/issues/20
152  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract StandardToken is BasicToken, ERC20 {
155   
156     mapping (address => mapping (address => uint)) public allowed;
157   
158     uint public constant MAX_UINT = 2**256 - 1;
159   
160     /**
161     * @dev Transfer tokens from one address to another
162     * @param _from address The address which you want to send tokens from
163     * @param _to address The address which you want to transfer to
164     * @param _value uint the amount of tokens to be transferred
165     */
166     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
167         var _allowance = allowed[_from][msg.sender];
168   
169         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
170         // if (_value > _allowance) throw;
171   
172         uint fee = (_value.mul(basisPointsRate)).div(10000);
173         if (fee > maximumFee) {
174             fee = maximumFee;
175         }
176         if (_allowance < MAX_UINT) {
177             allowed[_from][msg.sender] = _allowance.sub(_value);
178         }
179         uint sendAmount = _value.sub(fee);
180         balances[_from] = balances[_from].sub(_value);
181         balances[_to] = balances[_to].add(sendAmount);
182         if (fee > 0) {
183             balances[owner] = balances[owner].add(fee);
184             Transfer(_from, owner, fee);
185         }
186         Transfer(_from, _to, sendAmount);
187     }
188   
189     /**
190     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191     * @param _spender The address which will spend the funds.
192     * @param _value The amount of tokens to be spent.
193     */
194     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
195   
196         // To change the approve amount you first have to reduce the addresses`
197         //  allowance to zero by calling `approve(_spender, 0)` if it is not
198         //  already 0 to mitigate the race condition described here:
199         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
201   
202         allowed[msg.sender][_spender] = _value;
203         Approval(msg.sender, _spender, _value);
204     }
205   
206     /**
207     * @dev Function to check the amount of tokens than an owner allowed to a spender.
208     * @param _owner address The address which owns the funds.
209     * @param _spender address The address which will spend the funds.
210     * @return A uint specifying the amount of tokens still available for the spender.
211     */
212     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
213         return allowed[_owner][_spender];
214     }
215   
216 }
217   
218   
219 /**
220  * @title Pausable
221  * @dev Base contract which allows children to implement an emergency stop mechanism.
222  */
223 contract Pausable is Ownable {
224   event Pause();
225   event Unpause();
226   
227   bool public paused = false;
228   
229   
230   /**
231    * @dev Modifier to make a function callable only when the contract is not paused.
232    */
233   modifier whenNotPaused() {
234     require(!paused);
235     _;
236   }
237   
238   /**
239    * @dev Modifier to make a function callable only when the contract is paused.
240    */
241   modifier whenPaused() {
242     require(paused);
243     _;
244   }
245   
246   /**
247    * @dev called by the owner to pause, triggers stopped state
248    */
249   function pause() onlyOwner whenNotPaused public {
250     paused = true;
251     Pause();
252   }
253   
254   /**
255    * @dev called by the owner to unpause, returns to normal state
256    */
257   function unpause() onlyOwner whenPaused public {
258     paused = false;
259     Unpause();
260   }
261 }
262   
263 contract BlackList is Ownable, BasicToken {
264   
265     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded EUROQUINNToken) ///////
266     function getBlackListStatus(address _maker) external constant returns (bool) {
267         return isBlackListed[_maker];
268     }
269   
270     function getOwner() external constant returns (address) {
271         return owner;
272     }
273   
274     mapping (address => bool) public isBlackListed;
275       
276     function addBlackList (address _evilUser) public onlyOwner {
277         isBlackListed[_evilUser] = true;
278         AddedBlackList(_evilUser);
279     }
280   
281     function removeBlackList (address _clearedUser) public onlyOwner {
282         isBlackListed[_clearedUser] = false;
283         RemovedBlackList(_clearedUser);
284     }
285   
286     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
287         require(isBlackListed[_blackListedUser]);
288         uint dirtyFunds = balanceOf(_blackListedUser);
289         balances[_blackListedUser] = 0;
290         _totalSupply -= dirtyFunds;
291         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
292     }
293   
294     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
295   
296     event AddedBlackList(address _user);
297   
298     event RemovedBlackList(address _user);
299   
300 }
301   
302 contract UpgradedStandardToken is StandardToken{
303     // those methods are called by the legacy contract
304     // and they must ensure msg.sender to be the contract address
305     function transferByLegacy(address from, address to, uint value) public;
306     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
307     function approveByLegacy(address from, address spender, uint value) public;
308 }
309   
310 contract HGBPToken is Pausable, StandardToken, BlackList {
311   
312     string public name;
313     string public symbol;
314     uint public decimals;
315     address public upgradedAddress;
316     bool public deprecated;
317   
318     //  The contract can be initialized with a number of tokens
319     //  All the tokens are deposited to the owner address
320     //
321     // @param _balance Initial supply of the contract
322     // @param _name Token Name
323     // @param _symbol Token symbol
324     // @param _decimals Token decimals
325     function HGBPToken(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
326         _totalSupply = _initialSupply;
327         name = _name;
328         symbol = _symbol;
329         decimals = _decimals;
330         balances[owner] = _initialSupply;
331         deprecated = false;
332     }
333   
334     // Forward ERC20 methods to upgraded contract if this one is deprecated
335     function transfer(address _to, uint _value) public whenNotPaused {
336         require(!isBlackListed[msg.sender]);
337         if (deprecated) {
338             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
339         } else {
340             return super.transfer(_to, _value);
341         }
342     }
343   
344     // Forward ERC20 methods to upgraded contract if this one is deprecated
345     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
346         require(!isBlackListed[_from]);
347         if (deprecated) {
348             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
349         } else {
350             return super.transferFrom(_from, _to, _value);
351         }
352     }
353   
354     // Forward ERC20 methods to upgraded contract if this one is deprecated
355     function balanceOf(address who) public constant returns (uint) {
356         if (deprecated) {
357             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
358         } else {
359             return super.balanceOf(who);
360         }
361     }
362   
363     // Forward ERC20 methods to upgraded contract if this one is deprecated
364     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
365         if (deprecated) {
366             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
367         } else {
368             return super.approve(_spender, _value);
369         }
370     }
371   
372     // Forward ERC20 methods to upgraded contract if this one is deprecated
373     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
374         if (deprecated) {
375             return StandardToken(upgradedAddress).allowance(_owner, _spender);
376         } else {
377             return super.allowance(_owner, _spender);
378         }
379     }
380   
381     // deprecate current contract in favour of a new one
382     function deprecate(address _upgradedAddress) public onlyOwner {
383         deprecated = true;
384         upgradedAddress = _upgradedAddress;
385         Deprecate(_upgradedAddress);
386     }
387   
388     // deprecate current contract if favour of a new one
389     function totalSupply() public constant returns (uint) {
390         if (deprecated) {
391             return StandardToken(upgradedAddress).totalSupply();
392         } else {
393             return _totalSupply;
394         }
395     }
396   
397     // Issue a new amount of tokens
398     // these tokens are deposited into the owner address
399     //
400     // @param _amount Number of tokens to be issuedi
401     function issue(uint amount) public onlyOwner {
402         require(_totalSupply + amount > _totalSupply);
403         require(balances[owner] + amount > balances[owner]);
404   
405         balances[owner] += amount;
406         _totalSupply += amount;
407         Issue(amount);
408     }
409   
410     // Redeem tokens.
411     // These tokens are withdrawn from the owner address
412     // if the balance must be enough to cover the redeem
413     // or the call will fail.
414     // @param _amount Number of tokens to be issued
415     function redeem(uint amount) public onlyOwner {
416         require(_totalSupply >= amount);
417         require(balances[owner] >= amount);
418   
419         _totalSupply -= amount;
420         balances[owner] -= amount;
421         Redeem(amount);
422     }
423   
424     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
425         // Ensure transparency by hardcoding limit beyond which fees can never be added
426         require(newBasisPoints < 20);
427         require(newMaxFee < 50);
428   
429         basisPointsRate = newBasisPoints;
430         maximumFee = newMaxFee.mul(10**decimals);
431   
432         Params(basisPointsRate, maximumFee);
433     }
434   
435     // Called when new token are issued
436     event Issue(uint amount);
437   
438     // Called when tokens are redeemed
439     event Redeem(uint amount);
440   
441     // Called when contract is deprecated
442     event Deprecate(address newAddress);
443   
444     // Called if contract ever adds fees
445     event Params(uint feeBasisPoints, uint maxFee);
446 }