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
42     
43     address public owner;
44 
45     /**
46       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47       * account.
48       */
49     constructor() public {
50         owner = msg.sender;
51     }
52 
53     /**
54       * @dev Throws if called by any account other than the owner.
55       */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     /**
62     * @dev Allows the current owner to transfer control of the contract to a newOwner.
63     * @param newOwner The address to transfer ownership to.
64     */
65     function transferOwnership(address newOwner) public onlyOwner {
66         if (newOwner != address(0)) {
67             owner = newOwner;
68         }
69     }
70 
71 }
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/20
77  */
78 contract ERC20Basic {
79     uint public _totalSupply;
80     function totalSupply() public view returns (uint);
81     function balanceOf(address who) public view returns (uint);
82     function transfer(address to, uint value) public;
83     event Transfer(address indexed from, address indexed to, uint value);
84 }
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) public view returns (uint);
92     function transferFrom(address from, address to, uint value) public;
93     function approve(address spender, uint value) public;
94     event Approval(address indexed owner, address indexed spender, uint value);
95 }
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances.
100  */
101 contract BasicToken is Ownable, ERC20Basic {
102     using SafeMath for uint;
103 
104     mapping(address => uint) public balances;
105 
106     // additional variables for use if transaction fees ever became necessary
107     uint public basisPointsRate = 0;
108     uint public maximumFee = 0;
109 
110     /**
111     * @dev Fix for the ERC20 short address attack.
112     */
113     modifier onlyPayloadSize(uint size) {
114         require(!(msg.data.length < size + 4));
115         _;
116     }
117 
118     /**
119     * @dev transfer token for a specified address
120     * @param _to The address to transfer to.
121     * @param _value The amount to be transferred.
122     */
123     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
124         uint fee = (_value.mul(basisPointsRate)).div(10000);
125         if (fee > maximumFee) {
126             fee = maximumFee;
127         }
128         uint sendAmount = _value.sub(fee);
129         balances[msg.sender] = balances[msg.sender].sub(_value);
130         balances[_to] = balances[_to].add(sendAmount);
131         if (fee > 0) {
132             balances[owner] = balances[owner].add(fee);
133             emit Transfer(msg.sender, owner, fee);
134         }
135         emit Transfer(msg.sender, _to, sendAmount);
136     }
137 
138     /**
139     * @dev Gets the balance of the specified address.
140     * @param _owner The address to query the the balance of.
141     * @return An uint representing the amount owned by the passed address.
142     */
143     function balanceOf(address _owner) public view returns (uint balance) {
144         return balances[_owner];
145     }
146 
147 }
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is BasicToken, ERC20 {
157 
158     mapping (address => mapping (address => uint)) public allowed;
159 
160     uint public constant MAX_UINT = 2**256 - 1;
161 
162     /**
163     * @dev Transfer tokens from one address to another
164     * @param _from address The address which you want to send tokens from
165     * @param _to address The address which you want to transfer to
166     * @param _value uint the amount of tokens to be transferred
167     */
168     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
169         uint _allowance = allowed[_from][msg.sender];
170 
171         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
172         // if (_value > _allowance) throw;
173 
174         uint fee = (_value.mul(basisPointsRate)).div(10000);
175         if (fee > maximumFee) {
176             fee = maximumFee;
177         }
178         if (_allowance < MAX_UINT) {
179             allowed[_from][msg.sender] = _allowance.sub(_value);
180         }
181         uint sendAmount = _value.sub(fee);
182         balances[_from] = balances[_from].sub(_value);
183         balances[_to] = balances[_to].add(sendAmount);
184         if (fee > 0) {
185             balances[owner] = balances[owner].add(fee);
186             emit Transfer(_from, owner, fee);
187         }
188         emit Transfer(_from, _to, sendAmount);
189     }
190 
191     /**
192     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193     * @param _spender The address which will spend the funds.
194     * @param _value The amount of tokens to be spent.
195     */
196     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
197 
198         // To change the approve amount you first have to reduce the addresses`
199         //  allowance to zero by calling `approve(_spender, 0)` if it is not
200         //  already 0 to mitigate the race condition described here:
201         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
203 
204         allowed[msg.sender][_spender] = _value;
205         emit Approval(msg.sender, _spender, _value);
206     }
207 
208     /**
209     * @dev Function to check the amount of tokens than an owner allowed to a spender.
210     * @param _owner address The address which owns the funds.
211     * @param _spender address The address which will spend the funds.
212     * @return A uint specifying the amount of tokens still available for the spender.
213     */
214     function allowance(address _owner, address _spender) public view returns (uint remaining) {
215         return allowed[_owner][_spender];
216     }
217 
218 }
219 
220 
221 /**
222  * @title Pausable
223  * @dev Base contract which allows children to implement an emergency stop mechanism.
224  */
225 contract Pausable is Ownable {
226     event Pause();
227     event Unpause();
228 
229     bool public paused = false;
230 
231 
232   /**
233    * @dev Modifier to make a function callable only when the contract is not paused.
234    */
235     modifier whenNotPaused() {
236         require(!paused);
237         _;
238     }
239 
240   /**
241    * @dev Modifier to make a function callable only when the contract is paused.
242    */
243     modifier whenPaused() {
244         require(paused);
245         _;
246     }
247 
248   /**
249    * @dev called by the owner to pause, triggers stopped state
250    */
251     function pause() onlyOwner whenNotPaused public {
252         paused = true;
253         emit Pause();
254     }
255 
256   /**
257    * @dev called by the owner to unpause, returns to normal state
258    */
259     function unpause() onlyOwner whenPaused public {
260         paused = false;
261         emit Unpause();
262     }
263 }
264 
265 contract BlackList is Ownable, BasicToken {
266 
267     /**
268      * Getters to allow the same blacklist to be used also by other contracts 
269      */
270     function getBlackListStatus(address _maker) external view returns (bool) {
271         return isBlackListed[_maker];
272     }
273 
274     function getOwner() external view returns (address) {
275         return owner;
276     }
277 
278     mapping (address => bool) public isBlackListed;
279     
280     function addBlackList (address _evilUser) public onlyOwner {
281         isBlackListed[_evilUser] = true;
282         emit AddedBlackList(_evilUser);
283     }
284 
285     function removeBlackList (address _clearedUser) public onlyOwner {
286         isBlackListed[_clearedUser] = false;
287         emit RemovedBlackList(_clearedUser);
288     }
289 
290     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
291         require(isBlackListed[_blackListedUser]);
292         uint dirtyFunds = balanceOf(_blackListedUser);
293         balances[_blackListedUser] = 0;
294         _totalSupply -= dirtyFunds;
295         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
296     }
297 
298     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
299 
300     event AddedBlackList(address _user);
301 
302     event RemovedBlackList(address _user);
303 
304 }
305 
306 contract UpgradedStandardToken is StandardToken{
307     // those methods are called by the legacy contract
308     // and they must ensure msg.sender to be the contract address
309     function transferByLegacy(address from, address to, uint value) public;
310     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
311     function approveByLegacy(address from, address spender, uint value) public;
312 }
313 /**
314  * Proof of Stake Token
315  */
316 contract POSToken is Pausable, StandardToken, BlackList {
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
327     // @param _name Token Name
328     // @param _symbol Token symbol
329     // @param _balance Initial supply of the contract
330     // @param _decimals Token decimals
331     constructor(string _name, string _symbol, uint _initialSupply, uint _decimals) public {
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
361     function balanceOf(address who) public view returns (uint) {
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
379     function allowance(address _owner, address _spender) public view returns (uint remaining) {
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
391         emit Deprecate(_upgradedAddress);
392     }
393 
394     // deprecate current contract if favour of a new one
395     function totalSupply() public view returns (uint) {
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
413         emit Issue(amount);
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
427         emit Redeem(amount);
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
438         emit Params(basisPointsRate, maximumFee);
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