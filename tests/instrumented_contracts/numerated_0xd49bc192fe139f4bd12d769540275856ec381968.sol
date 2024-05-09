1 /**
2  * Source Code first verified at https://etherscan.io on Tuesday, November 28, 2017 (UTC) 
3  * 
4  * Contract Name: BITY
5  * Compiler Version: v0.4.18+commit.9cf6e910
6  * Optimization Enabled: No with 0 runs
7  * Evm Version: default
8  */
9 
10 pragma solidity ^0.4.17;
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 /**
46  * @title Ownable
47  * @dev The Ownable contract has an owner address, and provides basic authorization control
48  * functions, this simplifies the implementation of "user permissions".
49  */
50 contract Ownable {
51     address public owner;
52 
53     /**
54       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55       * account.
56       */
57     function Ownable() public {
58         owner = msg.sender;
59     }
60 
61     /**
62       * @dev Throws if called by any account other than the owner.
63       */
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     /**
70     * @dev Allows the current owner to transfer control of the contract to a newOwner.
71     * @param newOwner The address to transfer ownership to.
72     */
73     function transferOwnership(address newOwner) public onlyOwner {
74         if (newOwner != address(0)) {
75             owner = newOwner;
76         }
77     }
78 
79 }
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20Basic {
87     uint public _totalSupply;
88     function totalSupply() public constant returns (uint);
89     function balanceOf(address who) public constant returns (uint);
90     function transfer(address to, uint value) public;
91     event Transfer(address indexed from, address indexed to, uint value);
92 }
93 
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20 is ERC20Basic {
99     function allowance(address owner, address spender) public constant returns (uint);
100     function transferFrom(address from, address to, uint value) public;
101     function approve(address spender, uint value) public;
102     event Approval(address indexed owner, address indexed spender, uint value);
103 }
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is Ownable, ERC20Basic {
110     using SafeMath for uint;
111 
112     mapping(address => uint) public balances;
113 
114     // additional variables for use if transaction fees ever became necessary
115     uint public basisPointsRate = 0;
116     uint public maximumFee = 0;
117 
118     /**
119     * @dev Fix for the ERC20 short address attack.
120     */
121     modifier onlyPayloadSize(uint size) {
122         require(!(msg.data.length < size + 4));
123         _;
124     }
125 
126     /**
127     * @dev transfer token for a specified address
128     * @param _to The address to transfer to.
129     * @param _value The amount to be transferred.
130     */
131     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
132         uint fee = (_value.mul(basisPointsRate)).div(10000);
133         if (fee > maximumFee) {
134             fee = maximumFee;
135         }
136         uint sendAmount = _value.sub(fee);
137         balances[msg.sender] = balances[msg.sender].sub(_value);
138         balances[_to] = balances[_to].add(sendAmount);
139         if (fee > 0) {
140             balances[owner] = balances[owner].add(fee);
141             Transfer(msg.sender, owner, fee);
142         }
143         Transfer(msg.sender, _to, sendAmount);
144     }
145 
146     /**
147     * @dev Gets the balance of the specified address.
148     * @param _owner The address to query the the balance of.
149     * @return An uint representing the amount owned by the passed address.
150     */
151     function balanceOf(address _owner) public constant returns (uint balance) {
152         return balances[_owner];
153     }
154 
155 }
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is BasicToken, ERC20 {
165 
166     mapping (address => mapping (address => uint)) public allowed;
167 
168     uint public constant MAX_UINT = 2**256 - 1;
169 
170     /**
171     * @dev Transfer tokens from one address to another
172     * @param _from address The address which you want to send tokens from
173     * @param _to address The address which you want to transfer to
174     * @param _value uint the amount of tokens to be transferred
175     */
176     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
177         var _allowance = allowed[_from][msg.sender];
178 
179         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
180         // if (_value > _allowance) throw;
181 
182         uint fee = (_value.mul(basisPointsRate)).div(10000);
183         if (fee > maximumFee) {
184             fee = maximumFee;
185         }
186         if (_allowance < MAX_UINT) {
187             allowed[_from][msg.sender] = _allowance.sub(_value);
188         }
189         uint sendAmount = _value.sub(fee);
190         balances[_from] = balances[_from].sub(_value);
191         balances[_to] = balances[_to].add(sendAmount);
192         if (fee > 0) {
193             balances[owner] = balances[owner].add(fee);
194             Transfer(_from, owner, fee);
195         }
196         Transfer(_from, _to, sendAmount);
197     }
198 
199     /**
200     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201     * @param _spender The address which will spend the funds.
202     * @param _value The amount of tokens to be spent.
203     */
204     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
205 
206         // To change the approve amount you first have to reduce the addresses`
207         //  allowance to zero by calling `approve(_spender, 0)` if it is not
208         //  already 0 to mitigate the race condition described here:
209         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
211 
212         allowed[msg.sender][_spender] = _value;
213         Approval(msg.sender, _spender, _value);
214     }
215 
216     /**
217     * @dev Function to check the amount of tokens than an owner allowed to a spender.
218     * @param _owner address The address which owns the funds.
219     * @param _spender address The address which will spend the funds.
220     * @return A uint specifying the amount of tokens still available for the spender.
221     */
222     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
223         return allowed[_owner][_spender];
224     }
225 
226 }
227 
228 
229 /**
230  * @title Pausable
231  * @dev Base contract which allows children to implement an emergency stop mechanism.
232  */
233 contract Pausable is Ownable {
234   event Pause();
235   event Unpause();
236 
237   bool public paused = false;
238 
239 
240   /**
241    * @dev Modifier to make a function callable only when the contract is not paused.
242    */
243   modifier whenNotPaused() {
244     require(!paused);
245     _;
246   }
247 
248   /**
249    * @dev Modifier to make a function callable only when the contract is paused.
250    */
251   modifier whenPaused() {
252     require(paused);
253     _;
254   }
255 
256   /**
257    * @dev called by the owner to pause, triggers stopped state
258    */
259   function pause() onlyOwner whenNotPaused public {
260     paused = true;
261     Pause();
262   }
263 
264   /**
265    * @dev called by the owner to unpause, returns to normal state
266    */
267   function unpause() onlyOwner whenPaused public {
268     paused = false;
269     Unpause();
270   }
271 }
272 
273 contract BlackList is Ownable, BasicToken {
274 
275     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
276     function getBlackListStatus(address _maker) external constant returns (bool) {
277         return isBlackListed[_maker];
278     }
279 
280     function getOwner() external constant returns (address) {
281         return owner;
282     }
283 
284     mapping (address => bool) public isBlackListed;
285     
286     function addBlackList (address _evilUser) public onlyOwner {
287         isBlackListed[_evilUser] = true;
288         AddedBlackList(_evilUser);
289     }
290 
291     function removeBlackList (address _clearedUser) public onlyOwner {
292         isBlackListed[_clearedUser] = false;
293         RemovedBlackList(_clearedUser);
294     }
295 
296     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
297         require(isBlackListed[_blackListedUser]);
298         uint dirtyFunds = balanceOf(_blackListedUser);
299         balances[_blackListedUser] = 0;
300         _totalSupply -= dirtyFunds;
301         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
302     }
303 
304     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
305 
306     event AddedBlackList(address _user);
307 
308     event RemovedBlackList(address _user);
309 
310 }
311 
312 contract UpgradedStandardToken is StandardToken{
313     // those methods are called by the legacy contract
314     // and they must ensure msg.sender to be the contract address
315     function transferByLegacy(address from, address to, uint value) public;
316     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
317     function approveByLegacy(address from, address spender, uint value) public;
318 }
319 
320 contract BITY is Pausable, StandardToken, BlackList {
321 
322     string public name;
323     string public symbol;
324     uint public decimals;
325     address public upgradedAddress;
326     bool public deprecated;
327 
328     //  The contract can be initialized with a number of tokens
329     //  All the tokens are deposited to the owner address
330     //
331     // @param _balance Initial supply of the contract
332     // @param _name Token Name
333     // @param _symbol Token symbol
334     // @param _decimals Token decimals
335     function BITY(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
336         _totalSupply = _initialSupply * 10 ** uint256(_decimals);
337         name = _name;
338         symbol = _symbol;
339         decimals = _decimals;
340         balances[owner] = _totalSupply;
341         deprecated = false;
342     }
343 
344     // Forward ERC20 methods to upgraded contract if this one is deprecated
345     function transfer(address _to, uint _value) public whenNotPaused {
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
356         require(!isBlackListed[_from]);
357         if (deprecated) {
358             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
359         } else {
360             return super.transferFrom(_from, _to, _value);
361         }
362     }
363 
364     // Forward ERC20 methods to upgraded contract if this one is deprecated
365     function balanceOf(address who) public constant returns (uint) {
366         if (deprecated) {
367             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
368         } else {
369             return super.balanceOf(who);
370         }
371     }
372 
373     // Forward ERC20 methods to upgraded contract if this one is deprecated
374     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
375         if (deprecated) {
376             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
377         } else {
378             return super.approve(_spender, _value);
379         }
380     }
381 
382     // Forward ERC20 methods to upgraded contract if this one is deprecated
383     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
384         if (deprecated) {
385             return StandardToken(upgradedAddress).allowance(_owner, _spender);
386         } else {
387             return super.allowance(_owner, _spender);
388         }
389     }
390 
391     // deprecate current contract in favour of a new one
392     function deprecate(address _upgradedAddress) public onlyOwner {
393         deprecated = true;
394         upgradedAddress = _upgradedAddress;
395         Deprecate(_upgradedAddress);
396     }
397 
398     // deprecate current contract if favour of a new one
399     function totalSupply() public constant returns (uint) {
400         if (deprecated) {
401             return StandardToken(upgradedAddress).totalSupply();
402         } else {
403             return _totalSupply;
404         }
405     }
406 
407     // Issue a new amount of tokens
408     // these tokens are deposited into the owner address
409     //
410     // @param _amount Number of tokens to be issued
411     function issue(uint amount) public onlyOwner {
412         require(_totalSupply + amount > _totalSupply);
413         require(balances[owner] + amount > balances[owner]);
414 
415         balances[owner] += amount;
416         _totalSupply += amount;
417         Issue(amount);
418     }
419 
420     // Redeem tokens.
421     // These tokens are withdrawn from the owner address
422     // if the balance must be enough to cover the redeem
423     // or the call will fail.
424     // @param _amount Number of tokens to be issued
425     function redeem(uint amount) public onlyOwner {
426         require(_totalSupply >= amount);
427         require(balances[owner] >= amount);
428 
429         _totalSupply -= amount;
430         balances[owner] -= amount;
431         Redeem(amount);
432     }
433 
434     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
435         // Ensure transparency by hardcoding limit beyond which fees can never be added
436         require(newBasisPoints < 20);
437         require(newMaxFee < 50);
438 
439         basisPointsRate = newBasisPoints;
440         maximumFee = newMaxFee.mul(10**decimals);
441 
442         Params(basisPointsRate, maximumFee);
443     }
444 
445     // Called when new token are issued
446     event Issue(uint amount);
447 
448     // Called when tokens are redeemed
449     event Redeem(uint amount);
450 
451     // Called when contract is deprecated
452     event Deprecate(address newAddress);
453 
454     // Called if contract ever adds fees
455     event Params(uint feeBasisPoints, uint maxFee);
456 }