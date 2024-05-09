1 pragma solidity 0.4.17;
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
81     function transfer(address to, uint value) public returns (bool);
82     event Transfer(address indexed from, address indexed to, uint value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90     function allowance(address owner, address spender) public constant returns (uint);
91     function transferFrom(address from, address to, uint value) public returns (bool);
92     function approve(address spender, uint value) public returns (bool);
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
122     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) returns (bool) {
123         require(_to != address(0));
124         uint fee = (_value.mul(basisPointsRate)).div(10000);
125         if (fee > maximumFee) {
126             fee = maximumFee;
127         }
128         uint sendAmount = _value.sub(fee);
129         balances[msg.sender] = balances[msg.sender].sub(_value);
130         balances[_to] = balances[_to].add(sendAmount);
131         if (fee > 0) {
132             balances[owner] = balances[owner].add(fee);
133             Transfer(msg.sender, owner, fee);
134         }
135         Transfer(msg.sender, _to, sendAmount);
136         return true;
137     }
138 
139     /**
140     * @dev Gets the balance of the specified address.
141     * @param _owner The address to query the the balance of.
142     * @return An uint representing the amount owned by the passed address.
143     */
144     function balanceOf(address _owner) public constant returns (uint balance) {
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
157 contract StandardToken is BasicToken, ERC20 {
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
169     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) returns (bool) {
170         require(_to != address(0));
171         var _allowance = allowed[_from][msg.sender];
172 
173         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
174         // if (_value > _allowance) throw;
175 
176         uint fee = (_value.mul(basisPointsRate)).div(10000);
177         if (fee > maximumFee) {
178             fee = maximumFee;
179         }
180         if (_allowance < MAX_UINT) {
181             allowed[_from][msg.sender] = _allowance.sub(_value);
182         }
183         uint sendAmount = _value.sub(fee);
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(sendAmount);
186         if (fee > 0) {
187             balances[owner] = balances[owner].add(fee);
188             Transfer(_from, owner, fee);
189         }
190         Transfer(_from, _to, sendAmount);
191         return true;
192     }
193 
194     /**
195     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196     * @param _spender The address which will spend the funds.
197     * @param _value The amount of tokens to be spent.
198     */
199     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) returns (bool) {
200 
201         // To change the approve amount you first have to reduce the addresses`
202         //  allowance to zero by calling `approve(_spender, 0)` if it is not
203         //  already 0 to mitigate the race condition described here:
204         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
206 
207         allowed[msg.sender][_spender] = _value;
208         Approval(msg.sender, _spender, _value);
209         return true;
210     }
211 
212     /**
213     * @dev Function to check the amount of tokens than an owner allowed to a spender.
214     * @param _owner address The address which owns the funds.
215     * @param _spender address The address which will spend the funds.
216     * @return A uint specifying the amount of tokens still available for the spender.
217     */
218     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
219         return allowed[_owner][_spender];
220     }
221 
222 }
223 
224 
225 /**
226  * @title Pausable
227  * @dev Base contract which allows children to implement an emergency stop mechanism.
228  */
229 contract Pausable is Ownable {
230   event Pause();
231   event Unpause();
232 
233   bool public paused = false;
234 
235 
236   /**
237    * @dev Modifier to make a function callable only when the contract is not paused.
238    */
239   modifier whenNotPaused() {
240     require(!paused);
241     _;
242   }
243 
244   /**
245    * @dev Modifier to make a function callable only when the contract is paused.
246    */
247   modifier whenPaused() {
248     require(paused);
249     _;
250   }
251 
252   /**
253    * @dev called by the owner to pause, triggers stopped state
254    */
255   function pause() onlyOwner whenNotPaused public {
256     paused = true;
257     Pause();
258   }
259 
260   /**
261    * @dev called by the owner to unpause, returns to normal state
262    */
263   function unpause() onlyOwner whenPaused public {
264     paused = false;
265     Unpause();
266   }
267 }
268 
269 contract BlackList is Ownable, BasicToken {
270     using SafeMath for uint;
271     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded new token) ///////
272     function getBlackListStatus(address _maker) external constant returns (bool) {
273         return isBlackListed[_maker];
274     }
275 
276     function getOwner() external constant returns (address) {
277         return owner;
278     }
279 
280     mapping (address => bool) public isBlackListed;
281     
282     function addBlackList (address _evilUser) public onlyOwner {
283         isBlackListed[_evilUser] = true;
284         AddedBlackList(_evilUser);
285     }
286 
287     function removeBlackList (address _clearedUser) public onlyOwner {
288         isBlackListed[_clearedUser] = false;
289         RemovedBlackList(_clearedUser);
290     }
291 
292     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
293         require(isBlackListed[_blackListedUser]);
294         uint dirtyFunds = balances[_blackListedUser];
295         balances[_blackListedUser] = 0;
296         _totalSupply = _totalSupply.sub(dirtyFunds);
297         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
298     }
299 
300     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
301 
302     event AddedBlackList(address _user);
303 
304     event RemovedBlackList(address _user);
305 
306 }
307 
308 contract UpgradedStandardToken is StandardToken{
309     // those methods are called by the legacy contract
310     // and they must ensure msg.sender to be the contract address
311     function transferByLegacy(address from, address to, uint value) public returns (bool);
312     function transferFromByLegacy(address sender, address from, address spender, uint value) public returns (bool); 
313     function approveByLegacy(address from, address spender, uint value) public returns (bool);
314 }
315 
316 contract NewToken is Pausable, StandardToken, BlackList {
317 
318     string public name;
319     string public symbol;
320     uint8 public decimals;
321     address public upgradedAddress;
322     bool public deprecated;
323 
324     //  The contract can be initialized with a number of tokens
325     //  All the tokens are deposited to the owner address
326     //
327     // @param _balance Initial supply of the contract
328     // @param _name Token Name
329     // @param _symbol Token symbol
330     // @param _decimals Token decimals
331     function NewToken(uint _initialSupply, string _name, string _symbol, uint8 _decimals) public {
332         _totalSupply = _initialSupply;
333         name = _name;
334         symbol = _symbol;
335         decimals = _decimals;
336         balances[owner] = _initialSupply;
337         deprecated = false;
338     }
339 
340     // Forward ERC20 methods to upgraded contract if this one is deprecated
341     function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
342         require(!isBlackListed[msg.sender]);
343         require(!isBlackListed[_to]);
344         if (deprecated) {
345             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
346         } else {
347             return super.transfer(_to, _value);
348         }
349     }
350 
351     // Forward ERC20 methods to upgraded contract if this one is deprecated
352     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
353         require(!isBlackListed[msg.sender]);
354         require(!isBlackListed[_from]);
355         require(!isBlackListed[_to]);
356         if (deprecated) {
357             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
358         } else {
359             return super.transferFrom(_from, _to, _value);
360         }
361     }
362 
363     // Forward ERC20 methods to upgraded contract if this one is deprecated
364     function balanceOf(address who) public constant returns (uint) {
365         if (deprecated) {
366             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
367         } else {
368             return super.balanceOf(who);
369         }
370     }
371 
372     // Forward ERC20 methods to upgraded contract if this one is deprecated
373     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) returns (bool) {
374         if (deprecated) {
375             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
376         } else {
377             return super.approve(_spender, _value);
378         }
379     }
380 
381     // Forward ERC20 methods to upgraded contract if this one is deprecated
382     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
383         if (deprecated) {
384             return StandardToken(upgradedAddress).allowance(_owner, _spender);
385         } else {
386             return super.allowance(_owner, _spender);
387         }
388     }
389 
390     // deprecate current contract in favour of a new one
391     function deprecate(address _upgradedAddress) public onlyOwner {
392         deprecated = true;
393         upgradedAddress = _upgradedAddress;
394         Deprecate(_upgradedAddress);
395     }
396 
397     // deprecate current contract if favour of a new one
398     function totalSupply() public constant returns (uint) {
399         if (deprecated) {
400             return StandardToken(upgradedAddress).totalSupply();
401         } else {
402             return _totalSupply;
403         }
404     }
405 
406     // Issue a new amount of tokens
407     // these tokens are deposited into the owner address
408     //
409     // @param _amount Number of tokens to be issued
410     function issue(uint amount) public onlyOwner {
411         require(_totalSupply.add(amount) > _totalSupply);
412         require(balances[owner].add(amount) > balances[owner]);
413 
414         balances[owner] = balances[owner].add(amount);
415         _totalSupply = _totalSupply.add(amount);
416         Issue(amount);
417     }
418 
419     // Redeem tokens.
420     // These tokens are withdrawn from the owner address
421     // if the balance must be enough to cover the redeem
422     // or the call will fail.
423     // @param _amount Number of tokens to be issued
424     function redeem(uint amount) public onlyOwner {
425         require(_totalSupply >= amount);
426         require(balances[owner] >= amount);
427 
428         _totalSupply = _totalSupply.sub(amount);
429         balances[owner] = balances[owner].sub(amount);
430         Redeem(amount);
431     }
432 
433     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
434         require(deprecated);
435         return super.destroyBlackFunds(_blackListedUser);
436     }
437 
438     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
439         // Ensure transparency by hardcoding limit beyond which fees can never be added
440         require(newBasisPoints < 20);
441         require(newMaxFee < 50);
442 
443         basisPointsRate = newBasisPoints;
444         maximumFee = newMaxFee.mul(10**uint(decimals));
445 
446         Params(basisPointsRate, maximumFee);
447     }
448 
449     // Called when new token are issued
450     event Issue(uint amount);
451 
452     // Called when tokens are redeemed
453     event Redeem(uint amount);
454 
455     // Called when contract is deprecated
456     event Deprecate(address newAddress);
457 
458     // Called if contract ever adds fees
459     event Params(uint feeBasisPoints, uint maxFee);
460 }