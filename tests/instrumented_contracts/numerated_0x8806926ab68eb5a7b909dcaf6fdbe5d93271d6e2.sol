1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44     address public owner;
45 
46     /**
47       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48       * account.
49       */
50     constructor() public {
51         owner = msg.sender;
52     }
53 
54     /**
55       * @dev Throws if called by any account other than the owner.
56       */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     /**
63     * @dev Allows the current owner to transfer control of the contract to a newOwner.
64     * @param newOwner The address to transfer ownership to.
65     */
66     function transferOwnership(address newOwner) public onlyOwner {
67         if (newOwner != address(0)) {
68             owner = newOwner;
69         }
70     }
71 
72 }
73 
74 /**
75  * @title ERC20Basic
76  * @dev Simpler version of ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/20
78  */
79 abstract contract ERC20Basic {
80     uint public _totalSupply;
81     function totalSupply() public virtual view returns (uint);
82     function balanceOf(address who) public virtual view returns (uint);
83     function transfer(address to, uint value) public virtual;
84     event Transfer(address indexed from, address indexed to, uint value);
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 abstract contract ERC20 is ERC20Basic {
92     function allowance(address owner, address spender) public virtual view returns (uint);
93     function transferFrom(address from, address to, uint value) public virtual;
94     function approve(address spender, uint value) public virtual;
95     event Approval(address indexed owner, address indexed spender, uint value);
96 }
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 abstract contract BasicToken is Ownable, ERC20Basic {
103     using SafeMath for uint;
104 
105     mapping(address => uint) public balances;
106 
107     // additional variables for use if transaction fees ever became necessary
108     uint public basisPointsRate = 0;
109     uint public maximumFee = 0;
110 
111     /**
112     * @dev Fix for the ERC20 short address attack.
113     */
114     modifier onlyPayloadSize(uint size) {
115         require(!(msg.data.length < size + 4));
116         _;
117     }
118 
119     /**
120     * @dev transfer token for a specified address
121     * @param _to The address to transfer to.
122     * @param _value The amount to be transferred.
123     */
124     function transfer(address _to, uint _value) public override virtual onlyPayloadSize(2 * 32) {
125         uint fee = (_value.mul(basisPointsRate)).div(10000);
126         if (fee > maximumFee) {
127             fee = maximumFee;
128         }
129         uint sendAmount = _value.sub(fee);
130         balances[msg.sender] = balances[msg.sender].sub(_value);
131         balances[_to] = balances[_to].add(sendAmount);
132         if (fee > 0) {
133             balances[owner] = balances[owner].add(fee);
134             emit Transfer(msg.sender, owner, fee);
135         }
136         emit Transfer(msg.sender, _to, sendAmount);
137     }
138 
139     /**
140     * @dev Gets the balance of the specified address.
141     * @param _owner The address to query the the balance of.
142     * @return balance uint An uint representing the amount owned by the passed address.
143     */
144     function balanceOf(address _owner) public override virtual view returns (uint balance) {
145         return balances[_owner];
146     }
147 
148 }
149 
150 /**
151  * @title Standard ERC20 token
152  *
153  * @dev Implementation of the basic standard token.
154  * @dev https://github.com/ethereum/EIPs/issues/20
155  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156  */
157 abstract contract StandardToken is BasicToken, ERC20 {
158 
159     mapping (address => mapping (address => uint)) public allowed;
160 
161     uint public constant MAX_UINT = 2**256 - 1;
162 
163     /**
164     * @dev Transfer tokens from one address to another
165     * @param _from address The address which you want to send tokens from
166     * @param _to address The address which you want to transfer to
167     * @param _value uint the amount of tokens to be transferred
168     */
169     function transferFrom(address _from, address _to, uint _value) public  override virtual onlyPayloadSize(3 * 32) {
170         uint256 _allowance = allowed[_from][msg.sender];
171 
172         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
173         // if (_value > _allowance) throw;
174 
175         uint fee = (_value.mul(basisPointsRate)).div(10000);
176         if (fee > maximumFee) {
177             fee = maximumFee;
178         }
179         if (_allowance < MAX_UINT) {
180             allowed[_from][msg.sender] = _allowance.sub(_value);
181         }
182         uint sendAmount = _value.sub(fee);
183         balances[_from] = balances[_from].sub(_value);
184         balances[_to] = balances[_to].add(sendAmount);
185         if (fee > 0) {
186             balances[owner] = balances[owner].add(fee);
187             emit Transfer(_from, owner, fee);
188         }
189         emit Transfer(_from, _to, sendAmount);
190     }
191 
192     /**
193     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194     * @param _spender The address which will spend the funds.
195     * @param _value The amount of tokens to be spent.
196     */
197     function approve(address _spender, uint _value) public override virtual onlyPayloadSize(2 * 32) {
198 
199         // To change the approve amount you first have to reduce the addresses`
200         //  allowance to zero by calling `approve(_spender, 0)` if it is not
201         //  already 0 to mitigate the race condition described here:
202         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
204 
205         allowed[msg.sender][_spender] = _value;
206         Approval(msg.sender, _spender, _value);
207     }
208 
209     /**
210     * @dev Function to check the amount of tokens than an owner allowed to a spender.
211     * @param _owner address The address which owns the funds.
212     * @param _spender address The address which will spend the funds.
213     * @return remaining uint A uint specifying the amount of tokens still available for the spender.
214     */
215     function allowance(address _owner, address _spender) public override virtual view returns (uint remaining) {
216         return allowed[_owner][_spender];
217     }
218 
219 }
220 
221 
222 /**
223  * @title Pausable
224  * @dev Base contract which allows children to implement an emergency stop mechanism.
225  */
226 contract Pausable is Ownable {
227   event Pause();
228   event Unpause();
229 
230   bool public paused = false;
231 
232 
233   /**
234    * @dev Modifier to make a function callable only when the contract is not paused.
235    */
236   modifier whenNotPaused() {
237     require(!paused);
238     _;
239   }
240 
241   /**
242    * @dev Modifier to make a function callable only when the contract is paused.
243    */
244   modifier whenPaused() {
245     require(paused);
246     _;
247   }
248 
249   /**
250    * @dev called by the owner to pause, triggers stopped state
251    */
252   function pause() onlyOwner whenNotPaused public {
253     paused = true;
254     Pause();
255   }
256 
257   /**
258    * @dev called by the owner to unpause, returns to normal state
259    */
260   function unpause() onlyOwner whenPaused public {
261     paused = false;
262     Unpause();
263   }
264 }
265 
266 abstract contract BlackList is Ownable, BasicToken {
267 
268     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
269     function getBlackListStatus(address _maker) external view returns (bool) {
270         return isBlackListed[_maker];
271     }
272 
273     function getOwner() external view returns (address) {
274         return owner;
275     }
276 
277     mapping (address => bool) public isBlackListed;
278     
279     function addBlackList (address _evilUser) public onlyOwner {
280         isBlackListed[_evilUser] = true;
281         AddedBlackList(_evilUser);
282     }
283 
284     function removeBlackList (address _clearedUser) public onlyOwner {
285         isBlackListed[_clearedUser] = false;
286         RemovedBlackList(_clearedUser);
287     }
288 
289     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
290         require(isBlackListed[_blackListedUser]);
291         uint dirtyFunds = balanceOf(_blackListedUser);
292         balances[_blackListedUser] = 0;
293         _totalSupply -= dirtyFunds;
294         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
295     }
296 
297     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
298 
299     event AddedBlackList(address _user);
300 
301     event RemovedBlackList(address _user);
302 
303 }
304 
305 abstract contract UpgradedStandardToken is StandardToken{
306     // those methods are called by the legacy contract
307     // and they must ensure msg.sender to be the contract address
308     function transferByLegacy(address from, address to, uint value) virtual public;
309     function transferFromByLegacy(address sender, address from, address spender, uint value) virtual public;
310     function approveByLegacy(address from, address spender, uint value) virtual public;
311 }
312 
313 contract UquidCoin is Pausable, StandardToken, BlackList {
314 
315     string public name;
316     string public symbol;
317     uint public decimals;
318     address public upgradedAddress;
319     bool public deprecated;
320 
321     //  The contract can be initialized with a number of tokens
322     //  All the tokens are deposited to the owner address
323     //
324     // @param _balance Initial supply of the contract
325     // @param _name Token Name
326     // @param _symbol Token symbol
327     // @param _decimals Token decimals
328     constructor (uint _initialSupply, string memory _name, string memory _symbol, uint _decimals) public {
329         _totalSupply = _initialSupply;
330         name = _name;
331         symbol = _symbol;
332         decimals = _decimals;
333         balances[owner] = _initialSupply;
334         deprecated = false;
335     }
336 
337     // Forward ERC20 methods to upgraded contract if this one is deprecated
338     function transfer(address _to, uint _value) public override whenNotPaused {
339         require(!isBlackListed[msg.sender]);
340         if (deprecated) {
341             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
342         } else {
343             return super.transfer(_to, _value);
344         }
345     }
346 
347     // Forward ERC20 methods to upgraded contract if this one is deprecated
348     function transferFrom(address _from, address _to, uint _value) public override whenNotPaused {
349         require(!isBlackListed[_from]);
350         if (deprecated) {
351             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
352         } else {
353             return super.transferFrom(_from, _to, _value);
354         }
355     }
356 
357     // Forward ERC20 methods to upgraded contract if this one is deprecated
358     function balanceOf(address who) public override view returns (uint) {
359         if (deprecated) {
360             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
361         } else {
362             return super.balanceOf(who);
363         }
364     }
365 
366     // Forward ERC20 methods to upgraded contract if this one is deprecated
367     function approve(address _spender, uint _value) public override onlyPayloadSize(2 * 32) {
368         if (deprecated) {
369             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
370         } else {
371             return super.approve(_spender, _value);
372         }
373     }
374 
375     // Forward ERC20 methods to upgraded contract if this one is deprecated
376     function allowance(address _owner, address _spender) public override view returns (uint remaining) {
377         if (deprecated) {
378             return StandardToken(upgradedAddress).allowance(_owner, _spender);
379         } else {
380             return super.allowance(_owner, _spender);
381         }
382     }
383 
384     // deprecate current contract in favour of a new one
385     function deprecate(address _upgradedAddress) public onlyOwner {
386         deprecated = true;
387         upgradedAddress = _upgradedAddress;
388         Deprecate(_upgradedAddress);
389     }
390 
391     // deprecate current contract if favour of a new one
392     function totalSupply() public override view returns (uint) {
393         if (deprecated) {
394             return StandardToken(upgradedAddress).totalSupply();
395         } else {
396             return _totalSupply;
397         }
398     }
399 
400     // Issue a new amount of tokens
401     // these tokens are deposited into the owner address
402     //
403     // @param _amount Number of tokens to be issued
404     function issue(uint amount) public onlyOwner {
405         require(_totalSupply + amount > _totalSupply);
406         require(balances[owner] + amount > balances[owner]);
407 
408         balances[owner] += amount;
409         _totalSupply += amount;
410         Issue(amount);
411     }
412 
413     // Redeem tokens.
414     // These tokens are withdrawn from the owner address
415     // if the balance must be enough to cover the redeem
416     // or the call will fail.
417     // @param _amount Number of tokens to be issued
418     function redeem(uint amount) public onlyOwner {
419         require(_totalSupply >= amount);
420         require(balances[owner] >= amount);
421 
422         _totalSupply -= amount;
423         balances[owner] -= amount;
424         Redeem(amount);
425     }
426 
427     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
428         // Ensure transparency by hardcoding limit beyond which fees can never be added
429         require(newBasisPoints < 20);
430         require(newMaxFee < 50);
431 
432         basisPointsRate = newBasisPoints;
433         maximumFee = newMaxFee.mul(10**decimals);
434 
435         Params(basisPointsRate, maximumFee);
436     }
437 
438     // Called when new token are issued
439     event Issue(uint amount);
440 
441     // Called when tokens are redeemed
442     event Redeem(uint amount);
443 
444     // Called when contract is deprecated
445     event Deprecate(address newAddress);
446 
447     // Called if contract ever adds fees
448     event Params(uint feeBasisPoints, uint maxFee);
449 }