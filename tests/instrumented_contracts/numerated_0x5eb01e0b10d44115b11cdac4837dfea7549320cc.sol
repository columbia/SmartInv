1 /**
2  *Submitted for verification at Etherscan.io on 2020-02-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2017-11-28
7 */
8 
9 pragma solidity ^0.4.17;
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 /**
45  * @title Ownable
46  * @dev The Ownable contract has an owner address, and provides basic authorization control
47  * functions, this simplifies the implementation of "user permissions".
48  */
49 contract Ownable {
50     address public owner;
51 
52     /**
53       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54       * account.
55       */
56     function Ownable() public {
57         owner = msg.sender;
58     }
59 
60     /**
61       * @dev Throws if called by any account other than the owner.
62       */
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     /**
69     * @dev Allows the current owner to transfer control of the contract to a newOwner.
70     * @param newOwner The address to transfer ownership to.
71     */
72     function transferOwnership(address newOwner) public onlyOwner {
73         if (newOwner != address(0)) {
74             owner = newOwner;
75         }
76     }
77 
78 }
79 
80 /**
81  * @title ERC20Basic
82  * @dev Simpler version of ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20Basic {
86     uint public _totalSupply;
87     function totalSupply() public constant returns (uint);
88     function balanceOf(address who) public constant returns (uint);
89     function transfer(address to, uint value) public;
90     event Transfer(address indexed from, address indexed to, uint value);
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98     function allowance(address owner, address spender) public constant returns (uint);
99     function transferFrom(address from, address to, uint value) public;
100     function approve(address spender, uint value) public;
101     event Approval(address indexed owner, address indexed spender, uint value);
102 }
103 
104 /**
105  * @title Basic token
106  * @dev Basic version of StandardToken, with no allowances.
107  */
108 contract BasicToken is Ownable, ERC20Basic {
109     using SafeMath for uint;
110 
111     mapping(address => uint) public balances;
112 
113     // additional variables for use if transaction fees ever became necessary
114     uint public basisPointsRate = 0;
115     uint public maximumFee = 0;
116 
117     /**
118     * @dev Fix for the ERC20 short address attack.
119     */
120     modifier onlyPayloadSize(uint size) {
121         require(!(msg.data.length < size + 4));
122         _;
123     }
124 
125     /**
126     * @dev transfer token for a specified address
127     * @param _to The address to transfer to.
128     * @param _value The amount to be transferred.
129     */
130     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
131         uint fee = (_value.mul(basisPointsRate)).div(10000);
132         if (fee > maximumFee) {
133             fee = maximumFee;
134         }
135         uint sendAmount = _value.sub(fee);
136         balances[msg.sender] = balances[msg.sender].sub(_value);
137         balances[_to] = balances[_to].add(sendAmount);
138         if (fee > 0) {
139             balances[owner] = balances[owner].add(fee);
140             Transfer(msg.sender, owner, fee);
141         }
142         Transfer(msg.sender, _to, sendAmount);
143     }
144 
145     /**
146     * @dev Gets the balance of the specified address.
147     * @param _owner The address to query the the balance of.
148     * @return An uint representing the amount owned by the passed address.
149     */
150     function balanceOf(address _owner) public constant returns (uint balance) {
151         return balances[_owner];
152     }
153 
154 }
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is BasicToken, ERC20 {
164 
165     mapping (address => mapping (address => uint)) public allowed;
166 
167     uint public constant MAX_UINT = 2**256 - 1;
168 
169     /**
170     * @dev Transfer tokens from one address to another
171     * @param _from address The address which you want to send tokens from
172     * @param _to address The address which you want to transfer to
173     * @param _value uint the amount of tokens to be transferred
174     */
175     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
176         var _allowance = allowed[_from][msg.sender];
177 
178         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
179         // if (_value > _allowance) throw;
180 
181         uint fee = (_value.mul(basisPointsRate)).div(10000);
182         if (fee > maximumFee) {
183             fee = maximumFee;
184         }
185         if (_allowance < MAX_UINT) {
186             allowed[_from][msg.sender] = _allowance.sub(_value);
187         }
188         uint sendAmount = _value.sub(fee);
189         balances[_from] = balances[_from].sub(_value);
190         balances[_to] = balances[_to].add(sendAmount);
191         if (fee > 0) {
192             balances[owner] = balances[owner].add(fee);
193             Transfer(_from, owner, fee);
194         }
195         Transfer(_from, _to, sendAmount);
196     }
197 
198     /**
199     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200     * @param _spender The address which will spend the funds.
201     * @param _value The amount of tokens to be spent.
202     */
203     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
204 
205         // To change the approve amount you first have to reduce the addresses`
206         //  allowance to zero by calling `approve(_spender, 0)` if it is not
207         //  already 0 to mitigate the race condition described here:
208         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
210 
211         allowed[msg.sender][_spender] = _value;
212         Approval(msg.sender, _spender, _value);
213     }
214 
215     /**
216     * @dev Function to check the amount of tokens than an owner allowed to a spender.
217     * @param _owner address The address which owns the funds.
218     * @param _spender address The address which will spend the funds.
219     * @return A uint specifying the amount of tokens still available for the spender.
220     */
221     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
222         return allowed[_owner][_spender];
223     }
224 
225 }
226 
227 
228 /**
229  * @title Pausable
230  * @dev Base contract which allows children to implement an emergency stop mechanism.
231  */
232 contract Pausable is Ownable {
233   event Pause();
234   event Unpause();
235 
236   bool public paused = false;
237 
238 
239   /**
240    * @dev Modifier to make a function callable only when the contract is not paused.
241    */
242   modifier whenNotPaused() {
243     require(!paused);
244     _;
245   }
246 
247   /**
248    * @dev Modifier to make a function callable only when the contract is paused.
249    */
250   modifier whenPaused() {
251     require(paused);
252     _;
253   }
254 
255   /**
256    * @dev called by the owner to pause, triggers stopped state
257    */
258   function pause() onlyOwner whenNotPaused public {
259     paused = true;
260     Pause();
261   }
262 
263   /**
264    * @dev called by the owner to unpause, returns to normal state
265    */
266   function unpause() onlyOwner whenPaused public {
267     paused = false;
268     Unpause();
269   }
270 }
271 
272 contract BlackList is Ownable, BasicToken {
273 
274     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
275     function getBlackListStatus(address _maker) external constant returns (bool) {
276         return isBlackListed[_maker];
277     }
278 
279     function getOwner() external constant returns (address) {
280         return owner;
281     }
282 
283     mapping (address => bool) public isBlackListed;
284     
285     function addBlackList (address _evilUser) public onlyOwner {
286         isBlackListed[_evilUser] = true;
287         AddedBlackList(_evilUser);
288     }
289 
290     function removeBlackList (address _clearedUser) public onlyOwner {
291         isBlackListed[_clearedUser] = false;
292         RemovedBlackList(_clearedUser);
293     }
294 
295     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
296         require(isBlackListed[_blackListedUser]);
297         uint dirtyFunds = balanceOf(_blackListedUser);
298         balances[_blackListedUser] = 0;
299         _totalSupply -= dirtyFunds;
300         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
301     }
302 
303     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
304 
305     event AddedBlackList(address _user);
306 
307     event RemovedBlackList(address _user);
308 
309 }
310 
311 contract UpgradedStandardToken is StandardToken{
312     // those methods are called by the legacy contract
313     // and they must ensure msg.sender to be the contract address
314     function transferByLegacy(address from, address to, uint value) public;
315     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
316     function approveByLegacy(address from, address spender, uint value) public;
317 }
318 
319 contract  LODToken is Pausable, StandardToken, BlackList {
320 
321     string public name;
322     string public symbol;
323     uint public decimals;
324     address public upgradedAddress;
325     bool public deprecated;
326 
327     //  The contract can be initialized with a number of tokens
328     //  All the tokens are deposited to the owner address
329     //
330     // @param _balance Initial supply of the contract
331     // @param _name Token Name
332     // @param _symbol Token symbol
333     // @param _decimals Token decimals
334     function LODToken(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
335         _totalSupply = _initialSupply;
336         name = _name;
337         symbol = _symbol;
338         decimals = _decimals;
339         balances[owner] = _initialSupply;
340         deprecated = false;
341     }
342 
343     // Forward ERC20 methods to upgraded contract if this one is deprecated
344     function transfer(address _to, uint _value) public whenNotPaused {
345         require(!isBlackListed[msg.sender]);
346         if (deprecated) {
347             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
348         } else {
349             return super.transfer(_to, _value);
350         }
351     }
352 
353     // Forward ERC20 methods to upgraded contract if this one is deprecated
354     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
355         require(!isBlackListed[_from]);
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
373     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
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
406     // Redeem tokens.
407     // These tokens are withdrawn from the owner address
408     // if the balance must be enough to cover the redeem
409     // or the call will fail.
410     // @param _amount Number of tokens to be issued
411     function redeem(uint amount) public onlyOwner {
412         require(_totalSupply >= amount);
413         require(balances[owner] >= amount);
414 
415         _totalSupply -= amount;
416         balances[owner] -= amount;
417         Redeem(amount);
418     }
419 
420     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
421         // Ensure transparency by hardcoding limit beyond which fees can never be added
422         require(newBasisPoints < 20);
423         require(newMaxFee < 50);
424 
425         basisPointsRate = newBasisPoints;
426         maximumFee = newMaxFee.mul(10**decimals);
427 
428         Params(basisPointsRate, maximumFee);
429     }
430 
431     // Called when tokens are redeemed
432     event Redeem(uint amount);
433 
434     // Called when contract is deprecated
435     event Deprecate(address newAddress);
436 
437     // Called if contract ever adds fees
438     event Params(uint feeBasisPoints, uint maxFee);
439 }