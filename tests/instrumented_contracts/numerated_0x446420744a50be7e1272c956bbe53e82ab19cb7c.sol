1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-26
3 */
4 
5 pragma solidity ^0.5.16;
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13     address public owner;
14 
15     /**
16       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17       * account.
18       */
19     constructor () public {
20         owner = msg.sender;
21     }
22 
23     /**
24       * @dev Throws if called by any account other than the owner.
25       */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32     * @dev Allows the current owner to transfer control of the contract to a newOwner.
33     * @param newOwner The address to transfer ownership to.
34     */
35     function transferOwnership(address newOwner) public onlyOwner {
36         if (newOwner != address(0)) {
37             owner = newOwner;
38         }
39     }
40 
41 }
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * See https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49     function totalSupply() public view returns (uint256);
50     function balanceOf(address who) public view returns (uint256);
51     function transfer(address to, uint256 value) public returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 /**
56  * @title Basic token
57  * @dev Basic version of StandardToken, with no allowances.
58  */
59 contract BasicToken is ERC20Basic {
60     using SafeMath for uint256;
61 
62     mapping(address => uint256) balances;
63 
64     uint256 totalSupply_;
65 
66     /**
67     * @dev Total number of tokens in existence
68     */
69     function totalSupply() public view returns (uint256) {
70         return totalSupply_;
71     }
72 
73     /**
74     * @dev Transfer token for a specified address
75     * @param _to The address to transfer to.
76     * @param _value The amount to be transferred.
77     */
78     function transfer(address _to, uint256 _value) public returns (bool) {
79         require(_to != address(0), "Address must not be zero.");
80         require(_value <= balances[msg.sender], "There is no enough balance.");
81 
82         balances[msg.sender] = balances[msg.sender].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         emit Transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     /**
89     * @dev Gets the balance of the specified address.
90     * @param _owner The address to query the the balance of.
91     * @return An uint256 representing the amount owned by the passed address.
92     */
93     function balanceOf(address _owner) public view returns (uint256) {
94         return balances[_owner];
95     }
96 
97 }
98 
99 /**
100  * @title ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/20
102  */
103 contract ERC20 is ERC20Basic {
104     function allowance(address owner, address spender)
105         public view returns (uint256);
106 
107     function transferFrom(address from, address to, uint256 value)
108         public returns (bool);
109 
110     function approve(address spender, uint256 value) public returns (bool);
111     event Approval(
112         address indexed owner,
113         address indexed spender,
114         uint256 value
115     );
116 }
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  * https://github.com/ethereum/EIPs/issues/20
123  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is ERC20, BasicToken {
126 
127     mapping (address => mapping (address => uint256)) internal allowed;
128 
129 
130     /**
131     * @dev Transfer tokens from one address to another
132     * @param _from address The address which you want to send tokens from
133     * @param _to address The address which you want to transfer to
134     * @param _value uint256 the amount of tokens to be transferred
135     */
136     function transferFrom(
137         address _from,
138         address _to,
139         uint256 _value
140     )
141         public
142         returns (bool)
143     {
144         require(_to != address(0), "Address must not be zero.");
145         require(_value <= balances[_from], "There is no enough balance.");
146         require(_value <= allowed[_from][msg.sender], "There is no enough allowed balance.");
147 
148         balances[_from] = balances[_from].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151         emit Transfer(_from, _to, _value);
152         return true;
153     }
154 
155     /**
156     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157     * Beware that changing an allowance with this method brings the risk that someone may use both the old
158     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161     * @param _spender The address which will spend the funds.
162     * @param _value The amount of tokens to be spent.
163     */
164     function approve(address _spender, uint256 _value) public returns (bool) {
165         allowed[msg.sender][_spender] = _value;
166         emit Approval(msg.sender, _spender, _value);
167         return true;
168     }
169 
170     /**
171     * @dev Function to check the amount of tokens that an owner allowed to a spender.
172     * @param _owner address The address which owns the funds.
173     * @param _spender address The address which will spend the funds.
174     * @return A uint256 specifying the amount of tokens still available for the spender.
175     */
176     function allowance(
177         address _owner,
178         address _spender
179     )
180         public
181         view
182         returns (uint256)
183     {
184         return allowed[_owner][_spender];
185     }
186 
187     /**
188     * @dev Increase the amount of tokens that an owner allowed to a spender.
189     * approve should be called when allowed[_spender] == 0. To increment
190     * allowed value is better to use this function to avoid 2 calls (and wait until
191     * the first transaction is mined)
192     * From MonolithDAO Token.sol
193     * @param _spender The address which will spend the funds.
194     * @param _addedValue The amount of tokens to increase the allowance by.
195     */
196     function increaseApproval(
197         address _spender,
198         uint256 _addedValue
199     )
200         public
201         returns (bool)
202     {
203         allowed[msg.sender][_spender] = (
204         allowed[msg.sender][_spender].add(_addedValue));
205         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206         return true;
207     }
208 
209     /**
210     * @dev Decrease the amount of tokens that an owner allowed to a spender.
211     * approve should be called when allowed[_spender] == 0. To decrement
212     * allowed value is better to use this function to avoid 2 calls (and wait until
213     * the first transaction is mined)
214     * From MonolithDAO Token.sol
215     * @param _spender The address which will spend the funds.
216     * @param _subtractedValue The amount of tokens to decrease the allowance by.
217     */
218     function decreaseApproval(
219         address _spender,
220         uint256 _subtractedValue
221     )
222         public
223         returns (bool)
224     {
225         uint256 oldValue = allowed[msg.sender][_spender];
226         if (_subtractedValue > oldValue) {
227             allowed[msg.sender][_spender] = 0;
228         } else {
229             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
230         }
231         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232         return true;
233     }
234 
235 }
236 
237 /**
238  * @title Pausable
239  * @dev Base contract which allows children to implement an emergency stop mechanism.
240  */
241 contract Pausable is Ownable {
242   event Pause();
243   event Unpause();
244 
245   bool public paused = false;
246 
247 
248   /**
249    * @dev Modifier to make a function callable only when the contract is not paused.
250    */
251   modifier whenNotPaused() {
252     require(!paused);
253     _;
254   }
255 
256   /**
257    * @dev Modifier to make a function callable only when the contract is paused.
258    */
259   modifier whenPaused() {
260     require(paused);
261     _;
262   }
263 
264   /**
265    * @dev called by the owner to pause, triggers stopped state
266    */
267   function pause() onlyOwner whenNotPaused public {
268     paused = true;
269     emit Pause();
270   }
271 
272   /**
273    * @dev called by the owner to unpause, returns to normal state
274    */
275   function unpause() onlyOwner whenPaused public {
276     paused = false;
277     emit Unpause();
278   }
279 }
280 
281 contract UpgradedStandardToken is StandardToken{
282     // those methods are called by the legacy contract
283     // and they must ensure msg.sender to be the contract address
284     function transferByLegacy(address from, address to, uint256 value) public returns (bool);
285     function transferFromByLegacy(address sender, address from, address spender, uint256 value) public returns (bool);
286     function approveByLegacy(address from, address spender, uint256 value) public returns (bool);
287 }
288 
289 contract BlackList is Ownable, BasicToken {
290 
291     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
292     function getBlackListStatus(address _maker) external view returns (bool) {
293         return isBlackListed[_maker];
294     }
295 
296     function getOwner() external view returns (address) {
297         return owner;
298     }
299 
300     mapping (address => bool) public isBlackListed;
301 
302     function addBlackList (address _evilUser) public onlyOwner {
303         isBlackListed[_evilUser] = true;
304         emit AddedBlackList(_evilUser);
305     }
306 
307     function removeBlackList (address _clearedUser) public onlyOwner {
308         isBlackListed[_clearedUser] = false;
309         emit RemovedBlackList(_clearedUser);
310     }
311 
312     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
313         require(isBlackListed[_blackListedUser]);
314         uint256 dirtyFunds = balanceOf(_blackListedUser);
315         balances[_blackListedUser] = 0;
316         totalSupply_ -= dirtyFunds;
317         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
318     }
319 
320     event DestroyedBlackFunds(address _blackListedUser, uint256 _balance);
321 
322     event AddedBlackList(address _user);
323 
324     event RemovedBlackList(address _user);
325 
326 }
327 
328 /**
329  * @title SafeMath
330  * @dev Math operations with safety checks that throw on error
331  */
332 library SafeMath {
333 
334     /**
335     * @dev Multiplies two numbers, throws on overflow.
336     */
337     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
338         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
339         // benefit is lost if 'b' is also tested.
340         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
341         if (a == 0) {
342             return 0;
343         }
344 
345         c = a * b;
346         assert(c / a == b);
347         return c;
348     }
349 
350     /**
351     * @dev Integer division of two numbers, truncating the quotient.
352     */
353     function div(uint256 a, uint256 b) internal pure returns (uint256) {
354         // assert(b > 0); // Solidity automatically throws when dividing by 0
355         // uint256 c = a / b;
356         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
357         return a / b;
358     }
359 
360     /**
361     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
362     */
363     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
364         assert(b <= a);
365         return a - b;
366     }
367 
368     /**
369     * @dev Adds two numbers, throws on overflow.
370     */
371     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
372         c = a + b;
373         assert(c >= a);
374         return c;
375     }
376 }
377 
378 contract XAL is Pausable, StandardToken, BlackList {
379     string public name = "XWallet Token";
380     string public symbol = "XAL";
381     uint8 public decimals = 18;
382     uint256 public init_Supply = 10000000000 * (10 ** uint256(decimals));
383     address public upgradedAddress;
384     bool public deprecated;
385 
386     constructor() public {
387         totalSupply_ = init_Supply;
388         balances[msg.sender] = totalSupply_;
389         deprecated = false;
390     }
391 
392     // Forward ERC20 methods to upgraded contract if this one is deprecated
393     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
394         require(!isBlackListed[msg.sender]);
395         require(!isBlackListed[_to]);
396         if (deprecated) {
397             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
398         } else {
399             return super.transfer(_to, _value);
400         }
401     }
402 
403     // Forward ERC20 methods to upgraded contract if this one is deprecated
404     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
405         require(!isBlackListed[msg.sender]);
406         require(!isBlackListed[_from]);
407         require(!isBlackListed[_to]);
408         if (deprecated) {
409             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
410         } else {
411             return super.transferFrom(_from, _to, _value);
412         }
413     }
414 
415     // Forward ERC20 methods to upgraded contract if this one is deprecated
416     function approve(address _spender, uint256 _value) public returns (bool) {
417         require(!isBlackListed[msg.sender]);
418         require(!isBlackListed[_spender]);
419         if (deprecated) {
420             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
421         } else {
422             return super.approve(_spender, _value);
423         }
424     }
425 
426     // Forward ERC20 methods to upgraded contract if this one is deprecated
427     function allowance(address _owner, address _spender) public view  returns (uint256) {
428         if (deprecated) {
429             return StandardToken(upgradedAddress).allowance(_owner, _spender);
430         } else {
431             return super.allowance(_owner, _spender);
432         }
433     }
434 
435     // Forward ERC20 methods to upgraded contract if this one is deprecated
436     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
437         if (deprecated) {
438             return StandardToken(upgradedAddress).increaseApproval(_spender, _addedValue);
439         } else {
440             return super.increaseApproval(_spender, _addedValue);
441         }
442     }
443 
444     // Forward ERC20 methods to upgraded contract if this one is deprecated
445     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
446         if (deprecated) {
447             return StandardToken(upgradedAddress).increaseApproval(_spender, _subtractedValue);
448         } else {
449             return super.decreaseApproval(_spender, _subtractedValue);
450         }
451     }
452 
453     // deprecate current contract in favour of a new one
454     function deprecate(address _upgradedAddress) public onlyOwner {
455         deprecated = true;
456         upgradedAddress = _upgradedAddress;
457         emit Deprecate(_upgradedAddress);
458     }
459 
460     // Called when contract is deprecated
461     event Deprecate(address newAddress);
462 }