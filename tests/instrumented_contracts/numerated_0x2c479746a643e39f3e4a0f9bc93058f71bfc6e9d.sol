1 pragma solidity ^0.4.24;
2 
3 // File: contracts\ERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address _who) public view returns (uint256);
12     function transfer(address _to, uint256 _value) public returns (bool);
13     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
14     function approve(address _spender, uint256 _value) public returns (bool);
15     function allowance(address _owner, address _spender) public view returns (uint256);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 // File: contracts\SafeMath.sol
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 // File: contracts\StandardToken.sol
74 
75 /**
76  * @title Standard ERC20 token
77  *
78  * @dev Implementation of the basic standard token.
79  * https://github.com/ethereum/EIPs/issues/20
80  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
81  */
82 contract StandardToken is ERC20 {
83     using SafeMath for uint256;
84 
85     mapping(address => uint256) balances;
86     mapping(address => mapping (address => uint256)) internal allowed;
87 
88     uint256 totalSupply_;
89 
90     /**
91      * @dev Total number of tokens in existence
92      */
93     function totalSupply() public view returns (uint256) {
94         return totalSupply_;
95     }
96    /* function totalSupply() constant returns (uint256 totalSupply) {
97         totalSupply = totalSupply_;
98     }*/
99 
100     /**
101      * @dev Gets the balance of the specified address.
102      * @param _owner The address to query the the balance of.
103      * @return An uint256 representing the amount owned by the passed address.
104      */
105     function balanceOf(address _owner) public view returns (uint256) {
106         return balances[_owner];
107     }
108 
109     /**
110      * @dev Function to check the amount of tokens that an owner allowed to a spender.
111      * @param _owner address The address which owns the funds.
112      * @param _spender address The address which will spend the funds.
113      * @return A uint256 specifying the amount of tokens still available for the spender.
114      */
115     function allowance(address _owner, address _spender) public view returns (uint256) {
116         return allowed[_owner][_spender];
117     }
118 
119     /**
120      * @dev Transfer token for a specified address
121      * @param _to The address to transfer to.
122      * @param _value The amount to be transferred.
123      */
124     function transfer(address _to, uint256 _value) public returns (bool) {
125         require(_value <= balances[msg.sender]);
126         require(_to != address(0));
127 
128         balances[msg.sender] = balances[msg.sender].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         emit Transfer(msg.sender, _to, _value);
131         return true;
132     }
133 
134     /**
135      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136      * Beware that changing an allowance with this method brings the risk that someone may use both the old
137      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
138      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
139      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140      * @param _spender The address which will spend the funds.
141      * @param _value The amount of tokens to be spent.
142      */
143     function approve(address _spender, uint256 _value) public returns (bool) {
144         allowed[msg.sender][_spender] = _value;
145         emit Approval(msg.sender, _spender, _value);
146         return true;
147     }
148 
149     /**
150      * @dev Transfer tokens from one address to another
151      * @param _from address The address which you want to send tokens from
152      * @param _to address The address which you want to transfer to
153      * @param _value uint256 the amount of tokens to be transferred
154      */
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156         require(_value <= balances[_from]);
157         require(_value <= allowed[_from][msg.sender]);
158         require(_to != address(0));
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         emit Transfer(_from, _to, _value);
164 
165         return true;
166     }
167 
168     /**
169      * @dev Increase the amount of tokens that an owner allowed to a spender.
170      * approve should be called when allowed[_spender] == 0. To increment
171      * allowed value is better to use this function to avoid 2 calls (and wait until
172      * the first transaction is mined)
173      * From MonolithDAO Token.sol
174      * @param _spender The address which will spend the funds.
175      * @param _addedValue The amount of tokens to increase the allowance by.
176      */
177     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
178         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
179         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180 
181         return true;
182     }
183 
184     /**
185      * @dev Decrease the amount of tokens that an owner allowed to a spender.
186      * approve should be called when allowed[_spender] == 0. To decrement
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * @param _spender The address which will spend the funds.
191      * @param _subtractedValue The amount of tokens to decrease the allowance by
192      */
193     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
194         uint256 oldValue = allowed[msg.sender][_spender];
195         if (_subtractedValue >= oldValue) {
196             allowed[msg.sender][_spender] = 0;
197         } else {
198             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199         }
200         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201 
202         return true;
203     }
204 }
205 
206 // File: contracts\Ownable.sol
207 
208 /**
209  * @title Ownable
210  * @dev The Ownable contract has an owner address, and provides basic authorization control
211  * functions, this simplifies the implementation of "user permissions".
212  */
213 contract Ownable {
214   address public owner;
215 
216 
217   event OwnershipRenounced(address indexed previousOwner);
218   event OwnershipTransferred(
219     address indexed previousOwner,
220     address indexed newOwner
221   );
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   constructor() public {
229     owner = msg.sender;
230   }
231 
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240   /**
241    * @dev Allows the current owner to relinquish control of the contract.
242    * @notice Renouncing to ownership will leave the contract without an owner.
243    * It will not be possible to call the functions with the `onlyOwner`
244    * modifier anymore.
245    */
246   function renounceOwnership() public onlyOwner {
247     emit OwnershipRenounced(owner);
248     owner = address(0);
249   }
250 
251   /**
252    * @dev Allows the current owner to transfer control of the contract to a newOwner.
253    * @param _newOwner The address to transfer ownership to.
254    */
255   function transferOwnership(address _newOwner) public onlyOwner {
256     _transferOwnership(_newOwner);
257   }
258 
259   /**
260    * @dev Transfers control of the contract to a newOwner.
261    * @param _newOwner The address to transfer ownership to.
262    */
263   function _transferOwnership(address _newOwner) internal {
264     require(_newOwner != address(0));
265     emit OwnershipTransferred(owner, _newOwner);
266     owner = _newOwner;
267   }
268 }
269 
270 // File: contracts\TokenTransferHelper.sol
271 
272 /**
273  * @title Pausable token
274  * @dev StandardToken modified with pausable transfers.
275  **/
276 contract TokenTransferHelper is StandardToken, Ownable {
277     event Pause();
278     event Unpause();
279     event Mint(address indexed to, uint256 amount);
280     event MintFinished();
281     event Burn(address indexed burner, uint256 value);
282 
283     bool public paused = true;
284     bool public mintingFinished = false;
285 
286     mapping (address => bool) public isLock;
287 
288     modifier canMint() {
289         require(!mintingFinished);
290         _;
291     }
292 
293     modifier hasMintPermission() {
294         require(msg.sender == owner);
295         _;
296     }
297 
298     /**
299      * @dev called by the owner to pause, triggers stopped state
300      */
301     function pause() public onlyOwner {
302         require(!paused);
303         paused = true;
304         emit Pause();
305     }
306 
307     /**
308      * @dev called by the owner to resume, returns to normal state
309      */
310     function resume() public onlyOwner {
311         require(paused);
312         paused = false;
313         emit Unpause();
314     }
315 
316     function transfer(address _to, uint256 _value) public returns (bool) {
317         if(msg.sender != owner) {
318             require(!paused);
319         }
320         require(!isLock[msg.sender]);
321         return super.transfer(_to, _value);
322     }
323 
324     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
325         if(msg.sender != owner) {
326             require(!paused);
327         }
328         require(!isLock[msg.sender]);
329         return super.transferFrom(_from, _to, _value);
330     }
331 
332     function approve(address _spender, uint256 _value) public returns (bool) {
333         if(msg.sender != owner) {
334             require(!paused);
335         }
336         return super.approve(_spender, _value);
337     }
338 
339     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
340         if(msg.sender != owner) {
341             require(!paused);
342         }
343         return super.increaseApproval(_spender, _addedValue);
344     }
345 
346     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
347         if(msg.sender != owner) {
348             require(!paused);
349         }
350         return super.decreaseApproval(_spender, _subtractedValue);
351     }
352 
353     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
354         totalSupply_ = totalSupply_.add(_amount);
355         balances[_to] = balances[_to].add(_amount);
356         emit Mint(_to, _amount);
357         emit Transfer(address(0), _to, _amount);
358         return true;
359     }
360 
361     /**
362      * @dev Function to stop minting new tokens.
363      * @return True if the operation was successful.
364      */
365     function finishMinting() public onlyOwner canMint returns (bool) {
366         mintingFinished = true;
367         emit MintFinished();
368         return true;
369     }
370 
371      /**
372      * @dev Burns a specific amount of tokens.
373      * @param _value The amount of token to be burned.
374      */
375     function burn(uint256 _value) public {
376         _burn(msg.sender, _value);
377     }
378 
379     /**
380      * @dev Burns a specific amount of tokens from the target address and decrements allowance
381      * @param _from address The address which you want to send tokens from
382      * @param _value uint256 The amount of token to be burned
383      */
384     function burnFrom(address _from, uint256 _value) public onlyOwner {
385         _burn(_from, _value);
386     }
387 
388     function _burn(address _who, uint256 _value) internal {
389         require(_value <= balances[_who]);
390         balances[_who] = balances[_who].sub(_value);
391         totalSupply_ = totalSupply_.sub(_value);
392         emit Burn(_who, _value);
393         emit Transfer(_who, address(0), _value);
394     }
395 
396     function lockAccount(address _to) public onlyOwner returns (bool) {
397         isLock[_to] = true;
398         return true;
399     }
400 
401     function unLockAccount(address _to) public onlyOwner returns (bool) {
402         isLock[_to] = false;
403         return true;
404     }
405 }
406 
407 // File: contracts\JGXToken.sol
408 
409 contract JGXToken is TokenTransferHelper {
410     string public constant name = "JGXToken";
411     string public constant symbol = "JGX";
412     uint8 public constant decimals = 18;
413 
414     uint256 public constant initial_supply = 5000000000 * (10 ** uint256(decimals)); // totalsupply
415 
416     /**
417      * @dev Constructor that gives msg.sender all of existing tokens.
418      */
419     constructor() public {
420         totalSupply_ = initial_supply;
421         balances[msg.sender] = initial_supply;
422         emit Transfer(address(0), msg.sender, initial_supply);
423     }
424 }