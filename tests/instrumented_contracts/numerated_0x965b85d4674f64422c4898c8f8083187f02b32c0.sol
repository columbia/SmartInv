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
60     
61 
62 }
63 
64 /**
65  * @title ERC20Basic
66  * @dev Simpler version of ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20Basic {
70     uint public _totalSupply;
71     function totalSupply() public constant returns (uint);
72     function balanceOf(address who) public constant returns (uint);
73     function transfer(address to, uint value) public;
74     event Transfer(address indexed from, address indexed to, uint value);
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82     function allowance(address owner, address spender) public constant returns (uint);
83     function transferFrom(address from, address to, uint value) public;
84     function approve(address spender, uint value) public;
85     event Approval(address indexed owner, address indexed spender, uint value);
86 }
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is Ownable, ERC20Basic {
93     using SafeMath for uint;
94 
95     mapping(address => uint) public balances;
96 
97     // additional variables for use if transaction fees ever became necessary
98     uint public basisPointsRate = 0;
99     uint public maximumFee = 0;
100 
101     /**
102     * @dev Fix for the ERC20 short address attack.
103     */
104     modifier onlyPayloadSize(uint size) {
105         require(!(msg.data.length < size + 4));
106         _;
107     }
108 
109     /**
110     * @dev transfer token for a specified address
111     * @param _to The address to transfer to.
112     * @param _value The amount to be transferred.
113     */
114     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
115         uint fee = (_value.mul(basisPointsRate)).div(10000);
116         if (fee > maximumFee) {
117             fee = maximumFee;
118         }
119         uint sendAmount = _value.sub(fee);
120         balances[msg.sender] = balances[msg.sender].sub(_value);
121         balances[_to] = balances[_to].add(sendAmount);
122         if (fee > 0) {
123             balances[owner] = balances[owner].add(fee);
124             emit Transfer(msg.sender, owner, fee);
125         }
126         emit Transfer(msg.sender, _to, sendAmount);
127     }
128 
129     /**
130     * @dev Gets the balance of the specified address.
131     * @param _owner The address to query the the balance of.
132     * @return An uint representing the amount owned by the passed address.
133     */
134     function balanceOf(address _owner) public constant returns (uint balance) {
135         return balances[_owner];
136     }
137 
138 }
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is BasicToken, ERC20 {
148 
149     mapping (address => mapping (address => uint)) public allowed;
150 
151     uint public constant MAX_UINT = 2**256 - 1;
152 
153     /**
154     * @dev Transfer tokens from one address to another
155     * @param _from address The address which you want to send tokens from
156     * @param _to address The address which you want to transfer to
157     * @param _value uint the amount of tokens to be transferred
158     */
159     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
160         uint _allowance = allowed[_from][msg.sender];
161 
162         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
163         // if (_value > _allowance) throw;
164 
165         uint fee = (_value.mul(basisPointsRate)).div(10000);
166         if (fee > maximumFee) {
167             fee = maximumFee;
168         }
169         if (_allowance < MAX_UINT) {
170             allowed[_from][msg.sender] = _allowance.sub(_value);
171         }
172         uint sendAmount = _value.sub(fee);
173         balances[_from] = balances[_from].sub(_value);
174         balances[_to] = balances[_to].add(sendAmount);
175         if (fee > 0) {
176             balances[owner] = balances[owner].add(fee);
177             emit Transfer(_from, owner, fee);
178         }
179         emit Transfer(_from, _to, sendAmount);
180     }
181 
182     /**
183     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
184     * @param _spender The address which will spend the funds.
185     * @param _value The amount of tokens to be spent.
186     */
187     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
188 
189         // To change the approve amount you first have to reduce the addresses`
190         //  allowance to zero by calling `approve(_spender, 0)` if it is not
191         //  already 0 to mitigate the race condition described here:
192         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
194 
195         allowed[msg.sender][_spender] = _value;
196         emit Approval(msg.sender, _spender, _value);
197     }
198 
199     /**
200     * @dev Function to check the amount of tokens than an owner allowed to a spender.
201     * @param _owner address The address which owns the funds.
202     * @param _spender address The address which will spend the funds.
203     * @return A uint specifying the amount of tokens still available for the spender.
204     */
205     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
206         return allowed[_owner][_spender];
207     }
208 
209 }
210 
211 
212 /**
213  * @title Pausable
214  * @dev Base contract which allows children to implement an emergency stop mechanism.
215  */
216 contract Pausable is Ownable {
217   event Pause();
218   event Unpause();
219 
220   bool public paused = false;
221 
222 
223   /**
224    * @dev Modifier to make a function callable only when the contract is not paused.
225    */
226   modifier whenNotPaused() {
227     require(!paused);
228     _;
229   }
230 
231   /**
232    * @dev Modifier to make a function callable only when the contract is paused.
233    */
234   modifier whenPaused() {
235     require(paused);
236     _;
237   }
238 
239   /**
240    * @dev called by the owner to pause, triggers stopped state
241    */
242   function pause() onlyOwner whenNotPaused public {
243     paused = true;
244     emit Pause();
245   }
246 
247   /**
248    * @dev called by the owner to unpause, returns to normal state
249    */
250   function unpause() onlyOwner whenPaused public {
251     paused = false;
252     emit Unpause();
253   }
254 }
255 
256 contract BlackList is Ownable, BasicToken {
257 
258     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
259     function getBlackListStatus(address _maker) external constant returns (bool) {
260         return isBlackListed[_maker];
261     }
262 
263     function getOwner() external constant returns (address) {
264         return owner;
265     }
266 
267     mapping (address => bool) public isBlackListed;
268     
269     function addBlackList (address _evilUser) public onlyOwner {
270         isBlackListed[_evilUser] = true;
271         emit AddedBlackList(_evilUser);
272     }
273 
274     function removeBlackList (address _clearedUser) public onlyOwner {
275         isBlackListed[_clearedUser] = false;
276         emit RemovedBlackList(_clearedUser);
277     }
278 
279     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
280         require(isBlackListed[_blackListedUser]);
281         uint dirtyFunds = balanceOf(_blackListedUser);
282         balances[_blackListedUser] = 0;
283         _totalSupply -= dirtyFunds;
284         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
285     }
286 
287     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
288 
289     event AddedBlackList(address _user);
290 
291     event RemovedBlackList(address _user);
292 
293 }
294 
295 contract UpgradedStandardToken is StandardToken{
296     // those methods are called by the legacy contract
297     // and they must ensure msg.sender to be the contract address
298     function transferByLegacy(address from, address to, uint value) public;
299     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
300     function approveByLegacy(address from, address spender, uint value) public;
301 }
302 
303 contract SFilToken is Pausable, StandardToken, BlackList {
304 
305     string public name;
306     string public symbol;
307     uint public decimals;
308     address public upgradedAddress;
309     bool public deprecated;
310 
311     //  The contract can be initialized with a number of tokens
312     //  All the tokens are deposited to the owner address
313     //
314     // @param _balance Initial supply of the contract
315     // @param _name Token Name
316     // @param _symbol Token symbol
317     // @param _decimals Token decimals
318     constructor(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
319         _totalSupply = _initialSupply;
320         name = _name;
321         symbol = _symbol;
322         decimals = _decimals;
323         balances[owner] = _initialSupply;
324         deprecated = false;
325     }
326 
327     // Forward ERC20 methods to upgraded contract if this one is deprecated
328     function transfer(address _to, uint _value) public whenNotPaused {
329         require(!isBlackListed[msg.sender]);
330         if (deprecated) {
331             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
332         } else {
333             return super.transfer(_to, _value);
334         }
335     }
336 
337     // Forward ERC20 methods to upgraded contract if this one is deprecated
338     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
339         require(!isBlackListed[_from]);
340         if (deprecated) {
341             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
342         } else {
343             return super.transferFrom(_from, _to, _value);
344         }
345     }
346 
347     // Forward ERC20 methods to upgraded contract if this one is deprecated
348     function balanceOf(address who) public constant returns (uint) {
349         if (deprecated) {
350             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
351         } else {
352             return super.balanceOf(who);
353         }
354     }
355 
356     // Forward ERC20 methods to upgraded contract if this one is deprecated
357     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
358         if (deprecated) {
359             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
360         } else {
361             return super.approve(_spender, _value);
362         }
363     }
364 
365     // Forward ERC20 methods to upgraded contract if this one is deprecated
366     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
367         if (deprecated) {
368             return StandardToken(upgradedAddress).allowance(_owner, _spender);
369         } else {
370             return super.allowance(_owner, _spender);
371         }
372     }
373 
374     // deprecate current contract in favour of a new one
375     function deprecate(address _upgradedAddress) public onlyOwner {
376         deprecated = true;
377         upgradedAddress = _upgradedAddress;
378         emit Deprecate(_upgradedAddress);
379     }
380 
381     // deprecate current contract if favour of a new one
382     function totalSupply() public constant returns (uint) {
383         if (deprecated) {
384             return StandardToken(upgradedAddress).totalSupply();
385         } else {
386             return _totalSupply;
387         }
388     }
389 
390     // Issue a new amount of tokens
391     // these tokens are deposited into the owner address
392     //
393     // @param _amount Number of tokens to be issued
394     function issue(uint amount) public onlyOwner {
395         require(_totalSupply + amount > _totalSupply);
396         require(balances[owner] + amount > balances[owner]);
397 
398         balances[owner] += amount;
399         _totalSupply += amount;
400         emit Issue(amount);
401     }
402 
403     // Redeem tokens.
404     // These tokens are withdrawn from the owner address
405     // if the balance must be enough to cover the redeem
406     // or the call will fail.
407     // @param _amount Number of tokens to be issued
408     function redeem(uint amount) public onlyOwner {
409         require(_totalSupply >= amount);
410         require(balances[owner] >= amount);
411 
412         _totalSupply -= amount;
413         balances[owner] -= amount;
414         emit Redeem(amount);
415     }
416 
417     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
418         // Ensure transparency by hardcoding limit beyond which fees can never be added
419         require(newBasisPoints < 20);
420         require(newMaxFee < 50);
421 
422         basisPointsRate = newBasisPoints;
423         maximumFee = newMaxFee.mul(10**decimals);
424 
425         emit Params(basisPointsRate, maximumFee);
426     }
427 
428     // Called when new token are issued
429     event Issue(uint amount);
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