1 pragma solidity ^0.4.17;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41     address public owner;
42 
43     /**
44       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45       * account.
46       */
47     function Ownable() public {
48         owner = msg.sender;
49     }
50 
51     /**
52       * @dev Throws if called by any account other than the owner.
53       */
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     /**
60     * @dev Allows the current owner to transfer control of the contract to a newOwner.
61     * @param newOwner The address to transfer ownership to.
62     */
63     function transferOwnership(address newOwner) public onlyOwner {
64         if (newOwner != address(0)) {
65             owner = newOwner;
66         }
67     }
68 
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
80     function transfer(address to, uint value) public returns (bool success);
81     event Transfer(address indexed from, address indexed to, uint value);
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89     function allowance(address owner, address spender) public constant returns (uint);
90     function transferFrom(address from, address to, uint value) public returns (bool success);
91     function approve(address spender, uint value) public returns (bool success);
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
121     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) returns (bool success) {
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
134         return true;
135     }
136 
137     /**
138     * @dev Gets the balance of the specified address.
139     * @param _owner The address to query the the balance of.
140     * @return An uint representing the amount owned by the passed address.
141     */
142     function balanceOf(address _owner) public constant returns (uint balance) {
143         return balances[_owner];
144     }
145 
146 }
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * @dev https://github.com/ethereum/EIPs/issues/20
153  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is BasicToken, ERC20 {
156 
157     mapping (address => mapping (address => uint)) public allowed;
158 
159     uint public constant MAX_UINT = 2**256 - 1;
160 
161     /**
162     * @dev Transfer tokens from one address to another
163     * @param _from address The address which you want to send tokens from
164     * @param _to address The address which you want to transfer to
165     * @param _value uint the amount of tokens to be transferred
166     */
167     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) returns (bool success){
168         var _allowance = allowed[_from][msg.sender];
169 
170         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
171         // if (_value > _allowance) throw;
172 
173         uint fee = (_value.mul(basisPointsRate)).div(10000);
174         if (fee > maximumFee) {
175             fee = maximumFee;
176         }
177         if (_allowance < MAX_UINT) {
178             allowed[_from][msg.sender] = _allowance.sub(_value);
179         }
180         uint sendAmount = _value.sub(fee);
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(sendAmount);
183         if (fee > 0) {
184             balances[owner] = balances[owner].add(fee);
185             Transfer(_from, owner, fee);
186         }
187         Transfer(_from, _to, sendAmount);
188         return true;
189     }
190 
191     /**
192     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193     * @param _spender The address which will spend the funds.
194     * @param _value The amount of tokens to be spent.
195     */
196     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) returns (bool success){
197 
198         // To change the approve amount you first have to reduce the addresses`
199         //  allowance to zero by calling `approve(_spender, 0)` if it is not
200         //  already 0 to mitigate the race condition described here:
201         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
203 
204         allowed[msg.sender][_spender] = _value;
205         Approval(msg.sender, _spender, _value);
206         return true;
207     }
208 
209     /**
210     * @dev Function to check the amount of tokens than an owner allowed to a spender.
211     * @param _owner address The address which owns the funds.
212     * @param _spender address The address which will spend the funds.
213     * @return A uint specifying the amount of tokens still available for the spender.
214     */
215     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
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
266 contract BlackList is Ownable, BasicToken {
267 
268     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
269     function getBlackListStatus(address _maker) external constant returns (bool) {
270         return isBlackListed[_maker];
271     }
272 
273     function getOwner() external constant returns (address) {
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
305 contract UpgradedStandardToken is StandardToken{
306     // those methods are called by the legacy contract
307     // and they must ensure msg.sender to be the contract address
308     function transferByLegacy(address from, address to, uint value) public returns (bool success);
309     function transferFromByLegacy(address sender, address from, address spender, uint value) public returns (bool success);
310     function approveByLegacy(address from, address spender, uint value) public returns (bool success);
311 }
312 
313 contract EpayToken is Pausable, StandardToken, BlackList {
314 
315     string public name;
316     string public symbol;
317     uint8 public decimals;
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
328     function EpayToken(uint _initialSupply, string _name, string _symbol, uint8 _decimals) public {
329         _totalSupply = _initialSupply;
330         name = _name;
331         symbol = _symbol;
332         decimals = _decimals;
333         balances[owner] = _initialSupply;
334         deprecated = false;
335     }
336 
337     // Forward ERC20 methods to upgraded contract if this one is deprecated
338     function transfer(address _to, uint _value) public whenNotPaused returns (bool success){
339         require(!isBlackListed[msg.sender]);
340         require(!isBlackListed[_to]);
341         if (deprecated) {
342             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
343         } else {
344             return super.transfer(_to, _value);
345         }
346     }
347 
348     // Forward ERC20 methods to upgraded contract if this one is deprecated
349     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool success){
350         require(!isBlackListed[_from]);
351         require(!isBlackListed[_to]);
352         if (deprecated) {
353             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
354         } else {
355             return super.transferFrom(_from, _to, _value);
356         }
357     }
358 
359     // Forward ERC20 methods to upgraded contract if this one is deprecated
360     function balanceOf(address who) public constant returns (uint) {
361         if (deprecated) {
362             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
363         } else {
364             return super.balanceOf(who);
365         }
366     }
367 
368     // Forward ERC20 methods to upgraded contract if this one is deprecated
369     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) returns (bool success){
370         if (deprecated) {
371             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
372         } else {
373             return super.approve(_spender, _value);
374         }
375     }
376 
377     // Forward ERC20 methods to upgraded contract if this one is deprecated
378     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
379         if (deprecated) {
380             return UpgradedStandardToken(upgradedAddress).allowance(_owner, _spender);
381         } else {
382             return super.allowance(_owner, _spender);
383         }
384     }
385 
386     // deprecate current contract in favour of a new one
387     function deprecate(address _upgradedAddress) public onlyOwner {
388         deprecated = true;
389         upgradedAddress = _upgradedAddress;
390         Deprecate(_upgradedAddress);
391     }
392 
393     // deprecate current contract if favour of a new one
394     function totalSupply() public constant returns (uint) {
395         if (deprecated) {
396             return UpgradedStandardToken(upgradedAddress).totalSupply();
397         } else {
398             return _totalSupply;
399         }
400     }
401 
402     // Issue a new amount of tokens
403     // these tokens are deposited into the owner address
404     //
405     // @param _amount Number of tokens to be issued
406     function issue(uint amount) public onlyOwner {
407         require(_totalSupply + amount > _totalSupply);
408         require(balances[owner] + amount > balances[owner]);
409 
410         balances[owner] += amount;
411         _totalSupply += amount;
412         Issue(amount);
413     }
414 
415     // Redeem tokens.
416     // These tokens are withdrawn from the owner address
417     // if the balance must be enough to cover the redeem
418     // or the call will fail.
419     // @param _amount Number of tokens to be issued
420     function redeem(uint amount) public onlyOwner {
421         require(_totalSupply >= amount);
422         require(balances[owner] >= amount);
423 
424         _totalSupply -= amount;
425         balances[owner] -= amount;
426         Redeem(amount);
427     }
428 
429     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
430         // Ensure transparency by hardcoding limit beyond which fees can never be added
431         require(newBasisPoints < 20);
432         require(newMaxFee < 50);
433 
434         basisPointsRate = newBasisPoints;
435         maximumFee = newMaxFee.mul(10**uint256(decimals));
436 
437         Params(basisPointsRate, maximumFee);
438     }
439 
440     // Called when new token are issued
441     event Issue(uint amount);
442 
443     // Called when tokens are redeemed
444     event Redeem(uint amount);
445 
446     // Called when contract is deprecated
447     event Deprecate(address newAddress);
448 
449     // Called if contract ever adds fees
450     event Params(uint feeBasisPoints, uint maxFee);
451 }