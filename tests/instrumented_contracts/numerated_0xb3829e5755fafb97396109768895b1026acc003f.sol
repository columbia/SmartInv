1 /**
2  *Submitted for verification at Etherscan.io on 2017-11-28
3 */
4 
5 pragma solidity ^0.4.17;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46     address public owner;
47 
48     /**
49       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50       * account.
51       */
52     function Ownable() public {
53         owner = msg.sender;
54     }
55 
56     /**
57       * @dev Throws if called by any account other than the owner.
58       */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     /**
65     * @dev Allows the current owner to transfer control of the contract to a newOwner.
66     * @param newOwner The address to transfer ownership to.
67     */
68     function transferOwnership(address newOwner) public onlyOwner {
69         if (newOwner != address(0)) {
70             owner = newOwner;
71         }
72     }
73 
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20Basic {
82     uint public _totalSupply;
83     function totalSupply() public constant returns (uint);
84     function balanceOf(address who) public constant returns (uint);
85     function transfer(address to, uint value) public;
86     event Transfer(address indexed from, address indexed to, uint value);
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) public constant returns (uint);
95     function transferFrom(address from, address to, uint value) public;
96     function approve(address spender, uint value) public;
97     event Approval(address indexed owner, address indexed spender, uint value);
98 }
99 
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  */
104 contract BasicToken is Ownable, ERC20Basic {
105     using SafeMath for uint;
106 
107     mapping(address => uint) public balances;
108 
109     // additional variables for use if transaction fees ever became necessary
110     uint public basisPointsRate = 0;
111     uint public maximumFee = 0;
112 
113     /**
114     * @dev Fix for the ERC20 short address attack.
115     */
116     modifier onlyPayloadSize(uint size) {
117         require(!(msg.data.length < size + 4));
118         _;
119     }
120 
121     /**
122     * @dev transfer token for a specified address
123     * @param _to The address to transfer to.
124     * @param _value The amount to be transferred.
125     */
126     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
127         uint fee = (_value.mul(basisPointsRate)).div(10000);
128         if (fee > maximumFee) {
129             fee = maximumFee;
130         }
131         uint sendAmount = _value.sub(fee);
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(sendAmount);
134         if (fee > 0) {
135             balances[owner] = balances[owner].add(fee);
136             Transfer(msg.sender, owner, fee);
137         }
138         Transfer(msg.sender, _to, sendAmount);
139     }
140 
141     /**
142     * @dev Gets the balance of the specified address.
143     * @param _owner The address to query the the balance of.
144     * @return An uint representing the amount owned by the passed address.
145     */
146     function balanceOf(address _owner) public constant returns (uint balance) {
147         return balances[_owner];
148     }
149 
150 }
151 
152 /**
153  * @title Standard ERC20 token
154  *
155  * @dev Implementation of the basic standard token.
156  * @dev https://github.com/ethereum/EIPs/issues/20
157  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
158  */
159 contract StandardToken is BasicToken, ERC20 {
160 
161     mapping (address => mapping (address => uint)) public allowed;
162 
163     uint public constant MAX_UINT = 2**256 - 1;
164 
165     /**
166     * @dev Transfer tokens from one address to another
167     * @param _from address The address which you want to send tokens from
168     * @param _to address The address which you want to transfer to
169     * @param _value uint the amount of tokens to be transferred
170     */
171     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
172         var _allowance = allowed[_from][msg.sender];
173 
174         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
175         // if (_value > _allowance) throw;
176 
177         uint fee = (_value.mul(basisPointsRate)).div(10000);
178         if (fee > maximumFee) {
179             fee = maximumFee;
180         }
181         if (_allowance < MAX_UINT) {
182             allowed[_from][msg.sender] = _allowance.sub(_value);
183         }
184         uint sendAmount = _value.sub(fee);
185         balances[_from] = balances[_from].sub(_value);
186         balances[_to] = balances[_to].add(sendAmount);
187         if (fee > 0) {
188             balances[owner] = balances[owner].add(fee);
189             Transfer(_from, owner, fee);
190         }
191         Transfer(_from, _to, sendAmount);
192     }
193 
194     /**
195     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196     * @param _spender The address which will spend the funds.
197     * @param _value The amount of tokens to be spent.
198     */
199     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
200 
201         // To change the approve amount you first have to reduce the addresses`
202         //  allowance to zero by calling `approve(_spender, 0)` if it is not
203         //  already 0 to mitigate the race condition described here:
204         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
206 
207         allowed[msg.sender][_spender] = _value;
208         Approval(msg.sender, _spender, _value);
209     }
210 
211     /**
212     * @dev Function to check the amount of tokens than an owner allowed to a spender.
213     * @param _owner address The address which owns the funds.
214     * @param _spender address The address which will spend the funds.
215     * @return A uint specifying the amount of tokens still available for the spender.
216     */
217     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
218         return allowed[_owner][_spender];
219     }
220 
221 }
222 
223 
224 /**
225  * @title Pausable
226  * @dev Base contract which allows children to implement an emergency stop mechanism.
227  */
228 contract Pausable is Ownable {
229     event Pause();
230     event Unpause();
231 
232     bool public paused = false;
233 
234 
235     /**
236      * @dev Modifier to make a function callable only when the contract is not paused.
237      */
238     modifier whenNotPaused() {
239         require(!paused);
240         _;
241     }
242 
243     /**
244      * @dev Modifier to make a function callable only when the contract is paused.
245      */
246     modifier whenPaused() {
247         require(paused);
248         _;
249     }
250 
251     /**
252      * @dev called by the owner to pause, triggers stopped state
253      */
254     function pause() onlyOwner whenNotPaused public {
255         paused = true;
256         Pause();
257     }
258 
259     /**
260      * @dev called by the owner to unpause, returns to normal state
261      */
262     function unpause() onlyOwner whenPaused public {
263         paused = false;
264         Unpause();
265     }
266 }
267 
268 contract BlackList is Ownable, BasicToken {
269 
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
309     function transferByLegacy(address from, address to, uint value) public;
310     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
311     function approveByLegacy(address from, address spender, uint value) public;
312 }
313 
314 contract Bcoin is Pausable, StandardToken, BlackList {
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
329     function Bcoin(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
330         _totalSupply = _initialSupply;
331         name = _name;
332         symbol = _symbol;
333         decimals = _decimals;
334         balances[owner] = _initialSupply;
335         deprecated = false;
336     }
337 
338     // Forward ERC20 methods to upgraded contract if this one is deprecated
339     function transfer(address _to, uint _value) public whenNotPaused {
340         require(!isBlackListed[msg.sender]);
341         if (deprecated) {
342             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
343         } else {
344             return super.transfer(_to, _value);
345         }
346     }
347 
348     // Forward ERC20 methods to upgraded contract if this one is deprecated
349     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
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
368     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
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