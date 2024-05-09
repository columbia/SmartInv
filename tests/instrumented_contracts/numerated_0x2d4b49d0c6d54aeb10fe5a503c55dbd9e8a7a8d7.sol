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
123         uint fee = (_value.mul(basisPointsRate)).div(10000);
124         if (fee > maximumFee) {
125             fee = maximumFee;
126         }
127         uint sendAmount = _value.sub(fee);
128         balances[msg.sender] = balances[msg.sender].sub(_value);
129         balances[_to] = balances[_to].add(sendAmount);
130         if (fee > 0) {
131             balances[owner] = balances[owner].add(fee);
132             Transfer(msg.sender, owner, fee);
133         }
134         Transfer(msg.sender, _to, sendAmount);
135         return true;
136     }
137 
138     /**
139     * @dev Gets the balance of the specified address.
140     * @param _owner The address to query the the balance of.
141     * @return An uint representing the amount owned by the passed address.
142     */
143     function balanceOf(address _owner) public constant returns (uint balance) {
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
168     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) returns (bool) {
169         var _allowance = allowed[_from][msg.sender];
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
186             Transfer(_from, owner, fee);
187         }
188         Transfer(_from, _to, sendAmount);
189         return true;
190     }
191 
192     /**
193     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194     * @param _spender The address which will spend the funds.
195     * @param _value The amount of tokens to be spent.
196     */
197     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) returns (bool) {
198 
199         // To change the approve amount you first have to reduce the addresses`
200         //  allowance to zero by calling `approve(_spender, 0)` if it is not
201         //  already 0 to mitigate the race condition described here:
202         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
204 
205         allowed[msg.sender][_spender] = _value;
206         Approval(msg.sender, _spender, _value);
207         return true;
208     }
209 
210     /**
211     * @dev Function to check the amount of tokens than an owner allowed to a spender.
212     * @param _owner address The address which owns the funds.
213     * @param _spender address The address which will spend the funds.
214     * @return A uint specifying the amount of tokens still available for the spender.
215     */
216     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
217         return allowed[_owner][_spender];
218     }
219 
220 }
221 
222 
223 /**
224  * @title Pausable
225  * @dev Base contract which allows children to implement an emergency stop mechanism.
226  */
227 contract Pausable is Ownable {
228   event Pause();
229   event Unpause();
230 
231   bool public paused = false;
232 
233 
234   /**
235    * @dev Modifier to make a function callable only when the contract is not paused.
236    */
237   modifier whenNotPaused() {
238     require(!paused);
239     _;
240   }
241 
242   /**
243    * @dev Modifier to make a function callable only when the contract is paused.
244    */
245   modifier whenPaused() {
246     require(paused);
247     _;
248   }
249 
250   /**
251    * @dev called by the owner to pause, triggers stopped state
252    */
253   function pause() onlyOwner whenNotPaused public {
254     paused = true;
255     Pause();
256   }
257 
258   /**
259    * @dev called by the owner to unpause, returns to normal state
260    */
261   function unpause() onlyOwner whenPaused public {
262     paused = false;
263     Unpause();
264   }
265 }
266 
267 contract BlackList is Ownable, BasicToken {
268 
269     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded HO) ///////
270     function getBlackListStatus(address _maker) external constant returns (bool) {
271         return isBlackListed[_maker];
272     }
273 
274     function getOwner() external constant returns (address) {
275         return owner;
276     }
277 
278     mapping (address => bool) public isBlackListed;
279     
280     function addBlackList (address _evilUser) public onlyOwner {
281         isBlackListed[_evilUser] = true;
282         AddedBlackList(_evilUser);
283     }
284 
285     function removeBlackList (address _clearedUser) public onlyOwner {
286         isBlackListed[_clearedUser] = false;
287         RemovedBlackList(_clearedUser);
288     }
289 
290     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
291         require(isBlackListed[_blackListedUser]);
292         uint dirtyFunds = balanceOf(_blackListedUser);
293         balances[_blackListedUser] = 0;
294         _totalSupply -= dirtyFunds;
295         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
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
309     function transferByLegacy(address from, address to, uint value) public  returns (bool);
310     function transferFromByLegacy(address sender, address from, address spender, uint value) public  returns (bool);
311     function approveByLegacy(address from, address spender, uint value) public returns (bool);
312 }
313 
314 contract HOToken is Pausable, StandardToken, BlackList {
315 
316     string public name;
317     string public symbol;
318     uint public decimals;
319     address public upgradedAddress;
320     bool public deprecated;
321 
322     //  The contract can be initialized with a number of tokens
323     //  All the tokens are deposited to the owner address
324     //
325     // @param _balance Initial supply of the contract
326     // @param _name Token Name
327     // @param _symbol Token symbol
328     // @param _decimals Token decimals
329     function HOToken(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
330         _totalSupply = _initialSupply;
331         name = _name;
332         symbol = _symbol;
333         decimals = _decimals;
334         balances[owner] = _initialSupply;
335         deprecated = false;
336     }
337 
338     // Forward ERC20 methods to upgraded contract if this one is deprecated
339     function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
340         require(!isBlackListed[msg.sender]);
341         if (deprecated) {
342             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
343         } else {
344             return super.transfer(_to, _value);
345         }
346     }
347 
348     // Forward ERC20 methods to upgraded contract if this one is deprecated
349     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
350         require(!isBlackListed[_from]);
351         if (deprecated) {
352             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
353         } else {
354             return super.transferFrom(_from, _to, _value);
355         }
356     }
357 
358     // Forward ERC20 methods to upgraded contract if this one is deprecated
359     function balanceOf(address who) public constant returns (uint) {
360         if (deprecated) {
361             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
362         } else {
363             return super.balanceOf(who);
364         }
365     }
366 
367     // Forward ERC20 methods to upgraded contract if this one is deprecated
368     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) returns (bool) {
369         if (deprecated) {
370             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
371         } else {
372             return super.approve(_spender, _value);
373         }
374     }
375 
376     // Forward ERC20 methods to upgraded contract if this one is deprecated
377     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
378         if (deprecated) {
379             return StandardToken(upgradedAddress).allowance(_owner, _spender);
380         } else {
381             return super.allowance(_owner, _spender);
382         }
383     }
384 
385     // deprecate current contract in favour of a new one
386     function deprecate(address _upgradedAddress) public onlyOwner {
387         deprecated = true;
388         upgradedAddress = _upgradedAddress;
389         Deprecate(_upgradedAddress);
390     }
391 
392     // deprecate current contract if favour of a new one
393     function totalSupply() public constant returns (uint) {
394         if (deprecated) {
395             return StandardToken(upgradedAddress).totalSupply();
396         } else {
397             return _totalSupply;
398         }
399     }
400 
401     // Issue a new amount of tokens
402     // these tokens are deposited into the owner address
403     //
404     // @param _amount Number of tokens to be issued
405     function issue(uint amount) public onlyOwner {
406         require(_totalSupply + amount > _totalSupply);
407         require(balances[owner] + amount > balances[owner]);
408 
409         balances[owner] += amount;
410         _totalSupply += amount;
411         Issue(amount);
412     }
413 
414     // Redeem tokens.
415     // These tokens are withdrawn from the owner address
416     // if the balance must be enough to cover the redeem
417     // or the call will fail.
418     // @param _amount Number of tokens to be issued
419     function redeem(uint amount) public onlyOwner {
420         require(_totalSupply >= amount);
421         require(balances[owner] >= amount);
422 
423         _totalSupply -= amount;
424         balances[owner] -= amount;
425         Redeem(amount);
426     }
427 
428     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
429         // Ensure transparency by hardcoding limit beyond which fees can never be added
430         require(newBasisPoints < 20);
431         require(newMaxFee < 50);
432 
433         basisPointsRate = newBasisPoints;
434         maximumFee = newMaxFee.mul(10**decimals);
435 
436         Params(basisPointsRate, maximumFee);
437     }
438 
439     // Called when new token are issued
440     event Issue(uint amount);
441 
442     // Called when tokens are redeemed
443     event Redeem(uint amount);
444 
445     // Called when contract is deprecated
446     event Deprecate(address newAddress);
447 
448     // Called if contract ever adds fees
449     event Params(uint feeBasisPoints, uint maxFee);
450 }