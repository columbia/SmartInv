1 /**
2  * Source Code first verified at https://etherscan.io on Friday, April 26, 2019
3  (UTC) */
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
84     function totalSupply() public view returns (uint);
85     function balanceOf(address who) public view returns (uint);
86     function transfer(address to, uint value) public;
87     event Transfer(address indexed from, address indexed to, uint value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95     function allowance(address owner, address spender) public view returns (uint);
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
124     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
125         balances[msg.sender] = balances[msg.sender].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         Transfer(msg.sender, _to, _value);
128     }
129 
130     /**
131     * @dev Gets the balance of the specified address.
132     * @param _owner The address to query the the balance of.
133     * @return An uint representing the amount owned by the passed address.
134     */
135     function balanceOf(address _owner) public view returns (uint balance) {
136         return balances[_owner];
137     }
138 
139 }
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * @dev https://github.com/ethereum/EIPs/issues/20
146  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 contract StandardToken is BasicToken, ERC20 {
149 
150     mapping (address => mapping (address => uint)) public allowed;
151 
152     uint public constant MAX_UINT = 2**256 - 1;
153 
154     /**
155     * @dev Transfer tokens from one address to another
156     * @param _from address The address which you want to send tokens from
157     * @param _to address The address which you want to transfer to
158     * @param _value uint the amount of tokens to be transferred
159     */
160     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
161         var _allowance = allowed[_from][msg.sender];
162 
163         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
164         // if (_value > _allowance) throw;
165 
166 
167         if (_allowance < MAX_UINT) {
168             allowed[_from][msg.sender] = _allowance.sub(_value);
169         }
170         balances[_from] = balances[_from].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172 
173         Transfer(_from, _to, _value);
174     }
175 
176     /**
177     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178     * @param _spender The address which will spend the funds.
179     * @param _value The amount of tokens to be spent.
180     */
181     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
182 
183         // To change the approve amount you first have to reduce the addresses`
184         //  allowance to zero by calling `approve(_spender, 0)` if it is not
185         //  already 0 to mitigate the race condition described here:
186         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
188 
189         allowed[msg.sender][_spender] = _value;
190         Approval(msg.sender, _spender, _value);
191     }
192 
193     /**
194     * @dev Function to check the amount of tokens than an owner allowed to a spender.
195     * @param _owner address The address which owns the funds.
196     * @param _spender address The address which will spend the funds.
197     * @return A uint specifying the amount of tokens still available for the spender.
198     */
199     function allowance(address _owner, address _spender) public view returns (uint remaining) {
200         return allowed[_owner][_spender];
201     }
202 
203 }
204 
205 
206 /**
207  * @title Pausable
208  * @dev Base contract which allows children to implement an emergency stop mechanism.
209  */
210 contract Pausable is Ownable {
211   event Pause();
212   event Unpause();
213 
214   bool public paused = false;
215 
216 
217   /**
218    * @dev Modifier to make a function callable only when the contract is not paused.
219    */
220   modifier whenNotPaused() {
221     require(!paused);
222     _;
223   }
224 
225   /**
226    * @dev Modifier to make a function callable only when the contract is paused.
227    */
228   modifier whenPaused() {
229     require(paused);
230     _;
231   }
232 
233   /**
234    * @dev called by the owner to pause, triggers stopped state
235    */
236   function pause() onlyOwner whenNotPaused public {
237     paused = true;
238     Pause();
239   }
240 
241   /**
242    * @dev called by the owner to unpause, returns to normal state
243    */
244   function unpause() onlyOwner whenPaused public {
245     paused = false;
246     Unpause();
247   }
248 }
249 
250 contract BlackList is Ownable, BasicToken {
251 
252     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
253     function getBlackListStatus(address _maker) external view returns (bool) {
254         return isBlackListed[_maker];
255     }
256 
257     function getOwner() external view returns (address) {
258         return owner;
259     }
260 
261     mapping (address => bool) public isBlackListed;
262     
263     function addBlackList (address _evilUser) public onlyOwner {
264         isBlackListed[_evilUser] = true;
265         AddedBlackList(_evilUser);
266     }
267 
268     function removeBlackList (address _clearedUser) public onlyOwner {
269         isBlackListed[_clearedUser] = false;
270         RemovedBlackList(_clearedUser);
271     }
272 
273     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
274         require(isBlackListed[_blackListedUser]);
275         uint dirtyFunds = balanceOf(_blackListedUser);
276         balances[_blackListedUser] = 0;
277         _totalSupply -= dirtyFunds;
278         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
279     }
280 
281     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
282 
283     event AddedBlackList(address _user);
284 
285     event RemovedBlackList(address _user);
286 
287 }
288 
289 contract UpgradedStandardToken is StandardToken{
290     // those methods are called by the legacy contract
291     // and they must ensure msg.sender to be the contract address
292     function transferByLegacy(address from, address to, uint value) public;
293     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
294     function approveByLegacy(address from, address spender, uint value) public;
295 }
296 
297 contract WenboToken is Pausable, StandardToken, BlackList {
298 
299     string public constant name = "WBT_1_1";
300     string public constant symbol = "WBT_1_1";
301     uint public constant decimals = 18;
302     address public upgradedAddress;
303     bool public deprecated;
304 
305     //  The contract can be initialized with a number of tokens
306     //  All the tokens are deposited to the owner address
307     //
308     // @param _balance Initial supply of the contract
309     // @param _name Token Name
310     // @param _symbol Token symbol
311     // @param _decimals Token decimals
312     function WenboToken() public {
313         uint _initialSupply = 10000 * (10 ** 18); 
314         _totalSupply = _initialSupply;
315         balances[owner] = _initialSupply;
316         deprecated = false;
317     }
318 
319     // Forward ERC20 methods to upgraded contract if this one is deprecated
320     function transfer(address _to, uint _value) public whenNotPaused {
321         require(!isBlackListed[msg.sender]);
322         if (deprecated) {
323             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
324         } else {
325             return super.transfer(_to, _value);
326         }
327     }
328 
329     // Forward ERC20 methods to upgraded contract if this one is deprecated
330     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
331         require(!isBlackListed[_from]);
332         if (deprecated) {
333             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
334         } else {
335             return super.transferFrom(_from, _to, _value);
336         }
337     }
338 
339     // Forward ERC20 methods to upgraded contract if this one is deprecated
340     function balanceOf(address who) public view returns (uint) {
341         if (deprecated) {
342             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
343         } else {
344             return super.balanceOf(who);
345         }
346     }
347 
348     // Forward ERC20 methods to upgraded contract if this one is deprecated
349     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
350         if (deprecated) {
351             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
352         } else {
353             return super.approve(_spender, _value);
354         }
355     }
356 
357     // Forward ERC20 methods to upgraded contract if this one is deprecated
358     function allowance(address _owner, address _spender) public view returns (uint remaining) {
359         if (deprecated) {
360             return StandardToken(upgradedAddress).allowance(_owner, _spender);
361         } else {
362             return super.allowance(_owner, _spender);
363         }
364     }
365 
366     // deprecate current contract in favour of a new one
367     function deprecate(address _upgradedAddress) public onlyOwner {
368         deprecated = true;
369         upgradedAddress = _upgradedAddress;
370         Deprecate(_upgradedAddress);
371     }
372 
373     // deprecate current contract if favour of a new one
374     function totalSupply() public view returns (uint) {
375         if (deprecated) {
376             return StandardToken(upgradedAddress).totalSupply();
377         } else {
378             return _totalSupply;
379         }
380     }
381 
382     // Issue a new amount of tokens
383     // these tokens are deposited into the owner address
384     //
385     // @param _amount Number of tokens to be issued
386     function issue(uint amount) public onlyOwner {
387         require(_totalSupply + amount > _totalSupply);
388         require(balances[owner] + amount > balances[owner]);
389 
390         balances[owner] += amount;
391         _totalSupply += amount;
392         Issue(amount);
393     }
394 
395     // Redeem tokens.
396     // These tokens are withdrawn from the owner address
397     // if the balance must be enough to cover the redeem
398     // or the call will fail.
399     // @param _amount Number of tokens to be issued
400     function redeem(uint amount) public onlyOwner {
401         require(_totalSupply >= amount);
402         require(balances[owner] >= amount);
403 
404         _totalSupply -= amount;
405         balances[owner] -= amount;
406         Redeem(amount);
407     }
408 
409     // Called when new token are issued
410     event Issue(uint amount);
411 
412     // Called when tokens are redeemed
413     event Redeem(uint amount);
414 
415     // Called when contract is deprecated
416     event Deprecate(address newAddress);
417 
418 }