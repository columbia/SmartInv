1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40     address public owner;
41 
42     /**
43       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44       * account.
45       */
46     function Ownable() public {
47         owner = msg.sender;
48     }
49 
50     /**
51       * @dev Throws if called by any account other than the owner.
52       */
53     modifier onlyOwner() {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     /**
59     * @dev Allows the current owner to transfer control of the contract to a newOwner.
60     * @param newOwner The address to transfer ownership to.
61     */
62     function transferOwnership(address newOwner) public onlyOwner {
63         if (newOwner != address(0)) {
64             owner = newOwner;
65         }
66     }
67 
68 }
69 
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20Basic {
76     uint public _totalSupply;
77     function totalSupply() public constant returns (uint);
78     function balanceOf(address who) public constant returns (uint);
79     function transfer(address to, uint value) public;
80     event Transfer(address indexed from, address indexed to, uint value);
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88     function allowance(address owner, address spender) public constant returns (uint);
89     function transferFrom(address from, address to, uint value) public;
90     function approve(address spender, uint value) public;
91     event Approval(address indexed owner, address indexed spender, uint value);
92 }
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is Ownable, ERC20Basic {
99     using SafeMath for uint;
100 
101     mapping(address => uint) public balances;
102 
103     // additional variables for use if transaction fees ever became necessary
104     uint public basisPointsRate = 0;
105     uint public maximumFee = 0;
106 
107     /**
108     * @dev Fix for the ERC20 short address attack.
109     */
110     modifier onlyPayloadSize(uint size) {
111         require(!(msg.data.length < size + 4));
112         _;
113     }
114 
115     /**
116     * @dev transfer token for a specified address
117     * @param _to The address to transfer to.
118     * @param _value The amount to be transferred.
119     */
120     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
121         uint fee = (_value.mul(basisPointsRate)).div(10000);
122         if (fee > maximumFee) {
123             fee = maximumFee;
124         }
125         uint sendAmount = _value.sub(fee);
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         balances[_to] = balances[_to].add(sendAmount);
128         if (fee > 0) {
129             balances[owner] = balances[owner].add(fee);
130             Transfer(msg.sender, owner, fee);
131         }
132         Transfer(msg.sender, _to, sendAmount);
133     }
134 
135     /**
136     * @dev Gets the balance of the specified address.
137     * @param _owner The address to query the the balance of.
138     * @return An uint representing the amount owned by the passed address.
139     */
140     function balanceOf(address _owner) public constant returns (uint balance) {
141         return balances[_owner];
142     }
143 
144 }
145 
146 /**
147  * @title Standard ERC20 token
148  *
149  * @dev Implementation of the basic standard token.
150  * @dev https://github.com/ethereum/EIPs/issues/20
151  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is BasicToken, ERC20 {
154 
155     mapping (address => mapping (address => uint)) public allowed;
156 
157     uint public constant MAX_UINT = 2**256 - 1;
158 
159     /**
160     * @dev Transfer tokens from one address to another
161     * @param _from address The address which you want to send tokens from
162     * @param _to address The address which you want to transfer to
163     * @param _value uint the amount of tokens to be transferred
164     */
165     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
166         var _allowance = allowed[_from][msg.sender];
167 
168         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
169         // if (_value > _allowance) throw;
170 
171         uint fee = (_value.mul(basisPointsRate)).div(10000);
172         if (fee > maximumFee) {
173             fee = maximumFee;
174         }
175         if (_allowance < MAX_UINT) {
176             allowed[_from][msg.sender] = _allowance.sub(_value);
177         }
178         uint sendAmount = _value.sub(fee);
179         balances[_from] = balances[_from].sub(_value);
180         balances[_to] = balances[_to].add(sendAmount);
181         if (fee > 0) {
182             balances[owner] = balances[owner].add(fee);
183             Transfer(_from, owner, fee);
184         }
185         Transfer(_from, _to, sendAmount);
186     }
187 
188     /**
189     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190     * @param _spender The address which will spend the funds.
191     * @param _value The amount of tokens to be spent.
192     */
193     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
194 
195         // To change the approve amount you first have to reduce the addresses`
196         //  allowance to zero by calling `approve(_spender, 0)` if it is not
197         //  already 0 to mitigate the race condition described here:
198         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
200 
201         allowed[msg.sender][_spender] = _value;
202         Approval(msg.sender, _spender, _value);
203     }
204 
205     /**
206     * @dev Function to check the amount of tokens than an owner allowed to a spender.
207     * @param _owner address The address which owns the funds.
208     * @param _spender address The address which will spend the funds.
209     * @return A uint specifying the amount of tokens still available for the spender.
210     */
211     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
212         return allowed[_owner][_spender];
213     }
214 
215 }
216 
217 
218 /**
219  * @title Pausable
220  * @dev Base contract which allows children to implement an emergency stop mechanism.
221  */
222 contract Pausable is Ownable {
223   event Pause();
224   event Unpause();
225 
226   bool public paused = false;
227 
228 
229   /**
230    * @dev Modifier to make a function callable only when the contract is not paused.
231    */
232   modifier whenNotPaused() {
233     require(!paused);
234     _;
235   }
236 
237   /**
238    * @dev Modifier to make a function callable only when the contract is paused.
239    */
240   modifier whenPaused() {
241     require(paused);
242     _;
243   }
244 
245   /**
246    * @dev called by the owner to pause, triggers stopped state
247    */
248   function pause() onlyOwner whenNotPaused public {
249     paused = true;
250     Pause();
251   }
252 
253   /**
254    * @dev called by the owner to unpause, returns to normal state
255    */
256   function unpause() onlyOwner whenPaused public {
257     paused = false;
258     Unpause();
259   }
260 }
261 
262 contract BlackList is Ownable, BasicToken {
263 
264     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
265     function getBlackListStatus(address _maker) external constant returns (bool) {
266         return isBlackListed[_maker];
267     }
268 
269     function getOwner() external constant returns (address) {
270         return owner;
271     }
272 
273     mapping (address => bool) public isBlackListed;
274     
275     function addBlackList (address _evilUser) public onlyOwner {
276         isBlackListed[_evilUser] = true;
277         AddedBlackList(_evilUser);
278     }
279 
280     function removeBlackList (address _clearedUser) public onlyOwner {
281         isBlackListed[_clearedUser] = false;
282         RemovedBlackList(_clearedUser);
283     }
284 
285     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
286         require(isBlackListed[_blackListedUser]);
287         uint dirtyFunds = balanceOf(_blackListedUser);
288         balances[_blackListedUser] = 0;
289         _totalSupply -= dirtyFunds;
290         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
291     }
292 
293     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
294 
295     event AddedBlackList(address _user);
296 
297     event RemovedBlackList(address _user);
298 
299 }
300 
301 contract UpgradedStandardToken is StandardToken{
302     // those methods are called by the legacy contract
303     // and they must ensure msg.sender to be the contract address
304     function transferByLegacy(address from, address to, uint value) public;
305     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
306     function approveByLegacy(address from, address spender, uint value) public;
307 }
308 
309 contract AKKRUSD is Pausable, StandardToken, BlackList {
310 
311     string public name;
312     string public symbol;
313     uint public decimals;
314     address public upgradedAddress;
315     bool public deprecated;
316 
317     //  The contract can be initialized with a number of tokens
318     //  All the tokens are deposited to the owner address
319     //
320     // @param _balance Initial supply of the contract
321     // @param _name Token Name
322     // @param _symbol Token symbol
323     // @param _decimals Token decimals
324     function AKKRUSD(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
325         _totalSupply = _initialSupply;
326         name = _name;
327         symbol = _symbol;
328         decimals = _decimals;
329         balances[owner] = _initialSupply;
330         deprecated = false;
331     }
332 
333     // Forward ERC20 methods to upgraded contract if this one is deprecated
334     function transfer(address _to, uint _value) public whenNotPaused {
335         require(!isBlackListed[msg.sender]);
336         if (deprecated) {
337             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
338         } else {
339             return super.transfer(_to, _value);
340         }
341     }
342 
343     // Forward ERC20 methods to upgraded contract if this one is deprecated
344     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
345         require(!isBlackListed[_from]);
346         if (deprecated) {
347             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
348         } else {
349             return super.transferFrom(_from, _to, _value);
350         }
351     }
352 
353     // Forward ERC20 methods to upgraded contract if this one is deprecated
354     function balanceOf(address who) public constant returns (uint) {
355         if (deprecated) {
356             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
357         } else {
358             return super.balanceOf(who);
359         }
360     }
361 
362     // Forward ERC20 methods to upgraded contract if this one is deprecated
363     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
364         if (deprecated) {
365             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
366         } else {
367             return super.approve(_spender, _value);
368         }
369     }
370 
371     // Forward ERC20 methods to upgraded contract if this one is deprecated
372     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
373         if (deprecated) {
374             return StandardToken(upgradedAddress).allowance(_owner, _spender);
375         } else {
376             return super.allowance(_owner, _spender);
377         }
378     }
379 
380     // deprecate current contract in favour of a new one
381     function deprecate(address _upgradedAddress) public onlyOwner {
382         deprecated = true;
383         upgradedAddress = _upgradedAddress;
384         Deprecate(_upgradedAddress);
385     }
386 
387     // deprecate current contract if favour of a new one
388     function totalSupply() public constant returns (uint) {
389         if (deprecated) {
390             return StandardToken(upgradedAddress).totalSupply();
391         } else {
392             return _totalSupply;
393         }
394     }
395 
396     // Issue a new amount of tokens
397     // these tokens are deposited into the owner address
398     //
399     // @param _amount Number of tokens to be issued
400     function issue(uint amount) public onlyOwner {
401         require(_totalSupply + amount > _totalSupply);
402         require(balances[owner] + amount > balances[owner]);
403 
404         balances[owner] += amount;
405         _totalSupply += amount;
406         Issue(amount);
407     }
408 
409     // Redeem tokens.
410     // These tokens are withdrawn from the owner address
411     // if the balance must be enough to cover the redeem
412     // or the call will fail.
413     // @param _amount Number of tokens to be issued
414     function redeem(uint amount) public onlyOwner {
415         require(_totalSupply >= amount);
416         require(balances[owner] >= amount);
417 
418         _totalSupply -= amount;
419         balances[owner] -= amount;
420         Redeem(amount);
421     }
422 
423     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
424         // Ensure transparency by hardcoding limit beyond which fees can never be added
425         require(newBasisPoints < 20);
426         require(newMaxFee < 50);
427 
428         basisPointsRate = newBasisPoints;
429         maximumFee = newMaxFee.mul(10**decimals);
430 
431         Params(basisPointsRate, maximumFee);
432     }
433 
434     // Called when new token are issued
435     event Issue(uint amount);
436 
437     // Called when tokens are redeemed
438     event Redeem(uint amount);
439 
440     // Called when contract is deprecated
441     event Deprecate(address newAddress);
442 
443     // Called if contract ever adds fees
444     event Params(uint feeBasisPoints, uint maxFee);
445 }