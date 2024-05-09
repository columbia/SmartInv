1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-10
3  *Token contract of MGToken
4 */
5 
6 pragma solidity ^0.4.17;
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control
44  * functions, this simplifies the implementation of "user permissions".
45  */
46 contract Ownable {
47     address public owner;
48 
49     /**
50       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51       * account.
52       */
53     function Ownable() public {
54         owner = msg.sender;
55     }
56 
57     /**
58       * @dev Throws if called by any account other than the owner.
59       */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66     * @dev Allows the current owner to transfer control of the contract to a newOwner.
67     * @param newOwner The address to transfer ownership to.
68     */
69     function transferOwnership(address newOwner) public onlyOwner {
70         if (newOwner != address(0)) {
71             owner = newOwner;
72         }
73     }
74 
75 }
76 
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20Basic {
83     uint public _totalSupply;
84     function totalSupply() public constant returns (uint);
85     function balanceOf(address who) public constant returns (uint);
86     function transfer(address to, uint value) public;
87     event Transfer(address indexed from, address indexed to, uint value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95     function allowance(address owner, address spender) public constant returns (uint);
96     function transferFrom(address from, address to, uint value) public;
97     function approve(address spender, uint value) public;
98     event Approval(address indexed owner, address indexed spender, uint value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is Ownable, ERC20Basic {
106     using SafeMath for uint;
107 
108     mapping(address => uint) public balances;
109 
110     // additional variables for use if transaction fees ever became necessary
111     uint public basisPointsRate = 0;
112     uint public maximumFee = 0;
113 
114     /**
115     * @dev Fix for the ERC20 short address attack.
116     */
117     modifier onlyPayloadSize(uint size) {
118         require(!(msg.data.length < size + 4));
119         _;
120     }
121 
122     /**
123     * @dev transfer token for a specified address
124     * @param _to The address to transfer to.
125     * @param _value The amount to be transferred.
126     */
127     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
128         uint fee = (_value.mul(basisPointsRate)).div(10000);
129         if (fee > maximumFee) {
130             fee = maximumFee;
131         }
132         uint sendAmount = _value.sub(fee);
133         balances[msg.sender] = balances[msg.sender].sub(_value);
134         balances[_to] = balances[_to].add(sendAmount);
135         if (fee > 0) {
136             balances[owner] = balances[owner].add(fee);
137             Transfer(msg.sender, owner, fee);
138         }
139         Transfer(msg.sender, _to, sendAmount);
140     }
141 
142     /**
143     * @dev Gets the balance of the specified address.
144     * @param _owner The address to query the the balance of.
145     * @return An uint representing the amount owned by the passed address.
146     */
147     function balanceOf(address _owner) public constant returns (uint balance) {
148         return balances[_owner];
149     }
150 
151 }
152 
153 /**
154  * @title Standard ERC20 token
155  *
156  * @dev Implementation of the basic standard token.
157  * @dev https://github.com/ethereum/EIPs/issues/20
158  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
159  */
160 contract StandardToken is BasicToken, ERC20 {
161 
162     mapping (address => mapping (address => uint)) public allowed;
163 
164     uint public constant MAX_UINT = 2**256 - 1;
165 
166     /**
167     * @dev Transfer tokens from one address to another
168     * @param _from address The address which you want to send tokens from
169     * @param _to address The address which you want to transfer to
170     * @param _value uint the amount of tokens to be transferred
171     */
172     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
173         var _allowance = allowed[_from][msg.sender];
174 
175         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
176         // if (_value > _allowance) throw;
177 
178         uint fee = (_value.mul(basisPointsRate)).div(10000);
179         if (fee > maximumFee) {
180             fee = maximumFee;
181         }
182         if (_allowance < MAX_UINT) {
183             allowed[_from][msg.sender] = _allowance.sub(_value);
184         }
185         uint sendAmount = _value.sub(fee);
186         balances[_from] = balances[_from].sub(_value);
187         balances[_to] = balances[_to].add(sendAmount);
188         if (fee > 0) {
189             balances[owner] = balances[owner].add(fee);
190             Transfer(_from, owner, fee);
191         }
192         Transfer(_from, _to, sendAmount);
193     }
194 
195     /**
196     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197     * @param _spender The address which will spend the funds.
198     * @param _value The amount of tokens to be spent.
199     */
200     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
201 
202         // To change the approve amount you first have to reduce the addresses`
203         //  allowance to zero by calling `approve(_spender, 0)` if it is not
204         //  already 0 to mitigate the race condition described here:
205         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
207 
208         allowed[msg.sender][_spender] = _value;
209         Approval(msg.sender, _spender, _value);
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
270 
271     // Getters to allow the same blacklist to be used also by other contracts
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
294         uint dirtyFunds = balanceOf(_blackListedUser);
295         balances[_blackListedUser] = 0;
296         _totalSupply -= dirtyFunds;
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
311     function transferByLegacy(address from, address to, uint value) public;
312     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
313     function approveByLegacy(address from, address spender, uint value) public;
314 }
315 
316 contract MGToken is Pausable, StandardToken, BlackList {
317 
318     string public name;
319     string public symbol;
320     uint public decimals;
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
331     function MGToken(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
332         _totalSupply = _initialSupply;
333         name = _name;
334         symbol = _symbol;
335         decimals = _decimals;
336         balances[owner] = _initialSupply;
337         deprecated = false;
338     }
339 
340     // Forward ERC20 methods to upgraded contract if this one is deprecated
341     function transfer(address _to, uint _value) public whenNotPaused {
342         require(!isBlackListed[msg.sender]);
343         if (deprecated) {
344             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
345         } else {
346             return super.transfer(_to, _value);
347         }
348     }
349 
350     // Forward ERC20 methods to upgraded contract if this one is deprecated
351     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
352         require(!isBlackListed[_from]);
353         if (deprecated) {
354             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
355         } else {
356             return super.transferFrom(_from, _to, _value);
357         }
358     }
359 
360     // Forward ERC20 methods to upgraded contract if this one is deprecated
361     function balanceOf(address who) public constant returns (uint) {
362         if (deprecated) {
363             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
364         } else {
365             return super.balanceOf(who);
366         }
367     }
368 
369     // Forward ERC20 methods to upgraded contract if this one is deprecated
370     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
371         if (deprecated) {
372             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
373         } else {
374             return super.approve(_spender, _value);
375         }
376     }
377 
378     // Forward ERC20 methods to upgraded contract if this one is deprecated
379     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
380         if (deprecated) {
381             return StandardToken(upgradedAddress).allowance(_owner, _spender);
382         } else {
383             return super.allowance(_owner, _spender);
384         }
385     }
386 
387     // deprecate current contract in favour of a new one
388     function deprecate(address _upgradedAddress) public onlyOwner {
389         deprecated = true;
390         upgradedAddress = _upgradedAddress;
391         Deprecate(_upgradedAddress);
392     }
393 
394     // deprecate current contract if favour of a new one
395     function totalSupply() public constant returns (uint) {
396         if (deprecated) {
397             return StandardToken(upgradedAddress).totalSupply();
398         } else {
399             return _totalSupply;
400         }
401     }
402 
403     // Issue a new amount of tokens
404     // these tokens are deposited into the owner address
405     //
406     // @param _amount Number of tokens to be issued
407     function issue(uint amount) public onlyOwner {
408         require(_totalSupply + amount > _totalSupply);
409         require(balances[owner] + amount > balances[owner]);
410 
411         balances[owner] += amount;
412         _totalSupply += amount;
413         Issue(amount);
414     }
415 
416     // Redeem tokens.
417     // These tokens are withdrawn from the owner address
418     // if the balance must be enough to cover the redeem
419     // or the call will fail.
420     // @param _amount Number of tokens to be issued
421     function redeem(uint amount) public onlyOwner {
422         require(_totalSupply >= amount);
423         require(balances[owner] >= amount);
424 
425         _totalSupply -= amount;
426         balances[owner] -= amount;
427         Redeem(amount);
428     }
429 
430     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
431         // Ensure transparency by hardcoding limit beyond which fees can never be added
432         require(newBasisPoints < 20);
433         require(newMaxFee < 50);
434 
435         basisPointsRate = newBasisPoints;
436         maximumFee = newMaxFee.mul(10**decimals);
437 
438         Params(basisPointsRate, maximumFee);
439     }
440 
441     // Called when new token are issued
442     event Issue(uint amount);
443 
444     // Called when tokens are redeemed
445     event Redeem(uint amount);
446 
447     // Called when contract is deprecated
448     event Deprecate(address newAddress);
449 
450     // Called if contract ever adds fees
451     event Params(uint feeBasisPoints, uint maxFee);
452 }