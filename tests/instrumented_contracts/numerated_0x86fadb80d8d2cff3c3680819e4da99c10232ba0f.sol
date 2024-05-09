1 pragma solidity ^0.5.7;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address who) external view returns (uint256);
6     function allowance(address owner, address spender) external view returns (uint256);
7 
8     function transfer(address to, uint256 value) external returns (bool);
9     function approve(address spender, uint256 value) external returns (bool);
10     function transferFrom(address from, address to, uint256 value) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 interface IERC223 {
17     function name() external view returns (string memory);
18     function symbol() external view returns (string memory);
19     function decimals() external view returns (uint8);
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address who) external view returns (uint);
23 
24     function transfer(address to, uint value) external returns (bool);
25     function transfer(address to, uint value, bytes calldata data) external returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
28 }
29 
30 contract ContractReceiver {
31     function tokenFallback(address _from, uint _value, bytes memory _data) public {
32 
33     }
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Unsigned math operations with safety checks that revert on error.
39  */
40 library SafeMath {
41     /**
42       * @dev Multiplies two unsigned integers, reverts on overflow.
43       */
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46         // benefit is lost if 'b' is also tested.
47         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48         if (a == 0) {
49             return 0;
50         }
51 
52         uint256 c = a * b;
53         require(c / a == b);
54 
55         return c;
56     }
57 
58     /**
59       * @dev Integer division of two unsigned integers truncating the quotient,
60       * reverts on division by zero.
61       */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Solidity only automatically asserts when dividing by 0
64         require(b > 0);
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     /**
72       * @dev Subtracts two unsigned integers, reverts on overflow
73       * (i.e. if subtrahend is greater than minuend).
74       */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b <= a);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83       * @dev Adds two unsigned integers, reverts on overflow.
84       */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a);
88 
89         return c;
90     }
91 
92     /**
93       * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
94       * reverts when dividing by zero.
95       */
96     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97         require(b != 0);
98         return a % b;
99     }
100 }
101 
102 /**
103  * @title Ownable
104  * @dev The Ownable contract has an owner address, and provides basic authorization control
105  * functions, this simplifies the implementation of "user permissions".
106  */
107 contract Ownable {
108     address public owner;
109 
110 
111     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113 
114     /**
115      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116      * account.
117      */
118     constructor() public {
119         owner = msg.sender;
120     }
121 
122 
123     /**
124      * @dev Throws if called by any account other than the owner.
125      */
126     modifier onlyOwner() {
127         require(msg.sender == owner);
128         _;
129     }
130 
131 
132     /**
133      * @dev Allows the current owner to transfer control of the contract to a newOwner.
134      * @param newOwner The address to transfer ownership to.
135      */
136     function transferOwnership(address newOwner) onlyOwner public {
137         require(newOwner != address(0));
138         emit OwnershipTransferred(owner, newOwner);
139         owner = newOwner;
140     }
141 
142 }
143 
144 /**
145  * @title Pausable
146  * @dev Base contract which allows children to implement an emergency stop mechanism.
147  */
148 contract Pausable is Ownable {
149     event Pause();
150     event Unpause();
151 
152     bool public paused = false;
153 
154 
155     /**
156     * @dev Modifier to make a function callable only when the contract is not paused.
157     */
158     modifier whenNotPaused() {
159         require(!paused);
160         _;
161     }
162 
163     /**
164     * @dev Modifier to make a function callable only when the contract is paused.
165     */
166     modifier whenPaused() {
167         require(paused);
168         _;
169     }
170 
171     /**
172     * @dev called by the owner to pause, triggers stopped state
173     */
174     function pause() public onlyOwner whenNotPaused {
175         paused = true;
176         emit Pause();
177     }
178 
179     /**
180     * @dev called by the owner to unpause, returns to normal state
181     */
182     function unpause() public onlyOwner whenPaused {
183         paused = false;
184         emit Unpause();
185     }
186 }
187 
188 /**
189  * @title Blacklistable Token
190  * @dev Allows accounts to be blacklisted by a "blacklister" role
191 */
192 contract Blacklistable is Pausable {
193 
194     address public blacklister;
195     mapping(address => bool) internal blacklisted;
196 
197     event Blacklisted(address indexed _account);
198     event UnBlacklisted(address indexed _account);
199     event BlacklisterChanged(address indexed newBlacklister);
200 
201     constructor() public {
202         blacklister = msg.sender;
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the blacklister
207     */
208     modifier onlyBlacklister() {
209         require(msg.sender == blacklister);
210         _;
211     }
212 
213     /**
214      * @dev Throws if argument account is blacklisted
215      * @param _account The address to check
216     */
217     modifier notBlacklisted(address _account) {
218         require(blacklisted[_account] == false);
219         _;
220     }
221 
222     /**
223      * @dev Checks if account is blacklisted
224      * @param _account The address to check
225     */
226     function isBlacklisted(address _account) public view returns (bool) {
227         return blacklisted[_account];
228     }
229 
230     /**
231      * @dev Adds account to blacklist
232      * @param _account The address to blacklist
233     */
234     function blacklist(address _account) public onlyBlacklister {
235         blacklisted[_account] = true;
236         emit Blacklisted(_account);
237     }
238 
239     /**
240      * @dev Removes account from blacklist
241      * @param _account The address to remove from the blacklist
242     */
243     function unBlacklist(address _account) public onlyBlacklister {
244         blacklisted[_account] = false;
245         emit UnBlacklisted(_account);
246     }
247 
248     function updateBlacklister(address _newBlacklister) public onlyOwner {
249         require(_newBlacklister != address(0));
250         blacklister = _newBlacklister;
251         emit BlacklisterChanged(blacklister);
252     }
253 }
254 
255 
256 contract StandardToken is IERC20, IERC223, Pausable, Blacklistable {
257     uint256 public totalSupply;
258 
259     using SafeMath for uint;
260 
261     mapping (address => uint256) internal balances;
262     mapping (address => mapping (address => uint256)) internal allowed;
263 
264     function balanceOf(address _owner) public view returns (uint256 balance) {
265         return balances[_owner];
266     }
267 
268     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused notBlacklisted(_to) notBlacklisted(msg.sender) notBlacklisted(_from) public returns (bool) {
269         require(_to != address(0));
270         require(_value <= balances[_from]);
271         require(_value <= allowed[_from][msg.sender]);
272         balances[_from] = balances[_from].sub(_value);
273         balances[_to] = balances[_to].add(_value);
274         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
275         emit Transfer(_from, _to, _value);
276         return true;
277     }
278 
279     function approve(address _spender, uint256 _value) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_spender) public returns (bool) {
280         allowed[msg.sender][_spender] = _value;
281         emit Approval(msg.sender, _spender, _value);
282         return true;
283     }
284 
285     function allowance(address _owner, address _spender) public view returns (uint256) {
286         return allowed[_owner][_spender];
287     }
288 
289     function increaseApproval(address _spender, uint _addedValue) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_spender) public returns (bool) {
290         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
291         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292         return true;
293     }
294 
295     function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_spender) public returns (bool) {
296         uint oldValue = allowed[msg.sender][_spender];
297         if (_subtractedValue > oldValue) {
298             allowed[msg.sender][_spender] = 0;
299         } else {
300             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301         }
302         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303         return true;
304     }
305 
306     // Function that is called when a user or another contract wants to transfer funds.
307     function transfer(address _to, uint _value, bytes memory _data) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_to) public returns (bool success) {
308         if (isContract(_to)) {
309             return transferToContract(_to, _value, _data);
310         } else {
311             return transferToAddress(_to, _value, _data);
312         }
313     }
314 
315     // Standard function transfer similar to ERC20 transfer with no _data.
316     // Added due to backwards compatibility reasons.
317     function transfer(address _to, uint _value) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_to) public returns (bool success) {
318         bytes memory empty;
319         if (isContract(_to)) {
320             return transferToContract(_to, _value, empty);
321         } else {
322             return transferToAddress(_to, _value, empty);
323         }
324     }
325 
326     // Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
327     function isContract(address _addr) private view returns (bool is_contract) {
328         uint length;
329         require(_addr != address(0));
330         assembly {
331             //retrieve the size of the code on target address, this needs assembly
332             length := extcodesize(_addr)
333         }
334         return (length > 0);
335     }
336 
337     // Function that is called when transaction target is an address.
338     function transferToAddress(address _to, uint _value, bytes memory _data) private returns (bool success) {
339         require(balances[msg.sender] >= _value);
340         balances[msg.sender] = balances[msg.sender].sub(_value);
341         balances[_to] = balances[_to].add(_value);
342         emit Transfer(msg.sender, _to, _value);
343         emit Transfer(msg.sender, _to, _value, _data);
344         return true;
345     }
346 
347     // Function that is called when transaction target is a contract.
348     function transferToContract(address _to, uint _value, bytes memory _data) private returns (bool success) {
349         require(balances[msg.sender] >= _value);
350         balances[msg.sender] = balances[msg.sender].sub(_value);
351         balances[_to] = balances[_to].add(_value);
352         ContractReceiver receiver = ContractReceiver(_to);
353         receiver.tokenFallback(msg.sender, _value, _data);
354         emit Transfer(msg.sender, _to, _value);
355         emit Transfer(msg.sender, _to, _value, _data);
356         return true;
357     }
358 }
359 
360 /**
361  * @title Mintable token
362  * @dev Simple ERC20 Token example, with mintable token creation
363  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
364  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
365  */
366 contract MintableToken is StandardToken {
367     event Mint(address indexed to, uint256 amount);
368     event MintFinished();
369 
370     bool public mintingFinished = false;
371 
372 
373     modifier canMint() {
374         require(!mintingFinished);
375         _;
376     }
377 
378     /**
379      * @dev Function to mint tokens
380      * @param _to The address that will receive the minted tokens.
381      * @param _amount The amount of tokens to mint.
382      * @return A boolean that indicates if the operation was successful.
383      */
384     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
385         totalSupply = totalSupply.add(_amount);
386         balances[_to] = balances[_to].add(_amount);
387         emit Mint(_to, _amount);
388         emit Transfer(address(0), _to, _amount);
389         return true;
390     }
391 
392     /**
393      * @dev Function to stop minting new tokens.
394      * @return True if the operation was successful.
395      */
396     function finishMinting() onlyOwner canMint public returns (bool) {
397         mintingFinished = true;
398         emit MintFinished();
399         return true;
400     }
401 }
402 
403 /**
404  * @title Burnable Token
405  * @dev Token that can be irreversibly burned (destroyed).
406  */
407 contract BurnableToken is MintableToken {
408 
409   event Burn(address indexed burner, uint256 value);
410 
411   /**
412    * @dev Burns a specific amount of tokens.
413    * @param _value The amount of token to be burned.
414    */
415   function burn(uint256 _value) public {
416     _burn(msg.sender, _value);
417   }
418 
419   function _burn(address _who, uint256 _value) internal {
420     require(_value <= balances[_who]);
421     // no need to require value <= totalSupply, since that would imply the
422     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
423 
424     balances[_who] = balances[_who].sub(_value);
425     totalSupply = totalSupply.sub(_value);
426     emit Burn(_who, _value);
427     emit Transfer(_who, address(0), _value);
428   }
429 }
430 
431 contract EBASE is BurnableToken {
432     string public constant name = "EURBASE Stablecoin";
433     string public constant symbol = "EBASE";
434     uint8 public constant decimals = 18;
435     uint256 public constant initialSupply = 1000000 * 10 ** uint256(decimals);
436 
437     constructor () public {
438         totalSupply = initialSupply;
439         balances[msg.sender] = initialSupply;
440     }
441 }