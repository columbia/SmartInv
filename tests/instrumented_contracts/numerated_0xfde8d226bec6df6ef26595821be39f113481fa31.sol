1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28     // benefit is lost if 'b' is also tested.
29     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30     if (a == 0) {
31       return 0;
32     }
33 
34     c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     // uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return a / b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61     c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   /**
78   * @dev Transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85 
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     emit Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of.
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) public view returns (uint256 balance) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     emit Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     emit Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * approve should be called when allowed[_spender] == 0. To increment
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    */
179   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
180     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
186     uint oldValue = allowed[msg.sender][_spender];
187     if (_subtractedValue > oldValue) {
188       allowed[msg.sender][_spender] = 0;
189     } else {
190       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191     }
192     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196 }
197 
198 /**
199  * @title Ownable
200  * @dev The Ownable contract has an owner address, and provides basic authorization control
201  * functions, this simplifies the implementation of "user permissions".
202  */
203 contract Ownable {
204   address public owner;
205 
206 
207   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208 
209 
210   /**
211    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
212    * account.
213    */
214   constructor() public {
215     owner = msg.sender;
216   }
217 
218   /**
219    * @dev Throws if called by any account other than the owner.
220    */
221   modifier onlyOwner() {
222     require(msg.sender == owner);
223     _;
224   }
225 
226 
227   /**
228    * @dev Allows the current owner to transfer control of the contract to a newOwner.
229    * @param newOwner The address to transfer ownership to.
230    */
231   function transferOwnership(address newOwner) public onlyOwner {
232     require(newOwner != address(0));
233     emit OwnershipTransferred(owner, newOwner);
234     owner = newOwner;
235   }
236 
237 }
238 
239 
240 // custom Pausable implementation for DGAS
241 
242 /**
243  * @title Pausable
244  * @dev Base contract which allows children to implement an emergency stop mechanism.
245  */
246 contract Pausable is Ownable {
247   event PausePublic(bool newState);
248   event PauseOwnerAdmin(bool newState);
249 
250   bool public pausedPublic = true;
251   bool public pausedOwnerAdmin = false;
252 
253   address public admin;
254 
255   /**
256    * @dev Modifier to make a function callable based on pause states.
257    */
258   modifier whenNotPaused() {
259     if(pausedPublic) {
260       if(!pausedOwnerAdmin) {
261         require(msg.sender == admin || msg.sender == owner);
262       } else {
263         revert();
264       }
265     }
266     _;
267   }
268 
269   /**
270    * @dev called by the owner to set new pause flags
271    * pausedPublic can't be false while pausedOwnerAdmin is true
272    */
273   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
274     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
275 
276     pausedPublic = newPausedPublic;
277     pausedOwnerAdmin = newPausedOwnerAdmin;
278 
279     emit PausePublic(newPausedPublic);
280     emit PauseOwnerAdmin(newPausedOwnerAdmin);
281   }
282 }
283 
284 
285 /**
286  * @title Mintable token
287  * @dev Simple ERC20 Token example, with mintable token creation
288  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
289  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
290  */
291 contract MintableToken is StandardToken, Pausable {
292   event Mint(address indexed to, uint256 amount);
293   event MintFinished();
294 
295   bool public mintingFinished = false;
296 
297 
298   modifier canMint() {
299     require(!mintingFinished);
300     _;
301   }
302 
303   modifier hasMintPermission() {
304     require(msg.sender == owner);
305     _;
306   }
307 
308   /**
309    * @dev Function to mint tokens
310    * @param _to The address that will receive the minted tokens.
311    * @param _amount The amount of tokens to mint.
312    * @return A boolean that indicates if the operation was successful.
313    */
314   function mint(
315     address _to,
316     uint256 _amount
317   )
318     hasMintPermission
319     canMint
320     public
321     returns (bool)
322   {
323     totalSupply = totalSupply.add(_amount);
324     balances[_to] = balances[_to].add(_amount);
325     emit Mint(_to, _amount);
326     emit Transfer(address(0), _to, _amount);
327     return true;
328   }
329 
330   /**
331    * @dev Function to stop minting new tokens.
332    * @return True if the operation was successful.
333    */
334   function finishMinting() onlyOwner canMint public returns (bool) {
335     mintingFinished = true;
336     emit MintFinished();
337     return true;
338   }
339 }
340 
341 /**
342  * @title Pausable token
343  *
344  * @dev MintableToken
345  **/
346 
347 contract PausableToken is MintableToken {
348 
349   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
350     return super.transfer(_to, _value);
351   }
352 
353   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
354     return super.transferFrom(_from, _to, _value);
355   }
356 
357   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
358     return super.approve(_spender, _value);
359   }
360 
361   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
362     return super.increaseApproval(_spender, _addedValue);
363   }
364 
365   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
366     return super.decreaseApproval(_spender, _subtractedValue);
367   }
368 }
369 
370 contract DGASToken is PausableToken {
371     string  public  constant name = "DGAS Token";
372     string  public  constant symbol = "DGAS";
373     uint8   public  constant decimals = 18;
374 
375     modifier validDestination( address to )
376     {
377         require(to != address(0x0));
378         require(to != address(this));
379         _;
380     }
381     constructor( address _admin, uint _totalTokenAmount ) public
382     {
383         // assign the admin account
384         admin = _admin;
385 
386         // assign the total tokens to DGAS
387         totalSupply = _totalTokenAmount;
388         balances[msg.sender] = _totalTokenAmount;
389         emit Transfer(address(0x0), msg.sender, _totalTokenAmount);
390     }
391 
392     function transfer(address _to, uint _value) validDestination(_to) public returns (bool) 
393     {
394         return super.transfer(_to, _value);
395     }
396 
397     function transferFrom(address _from, address _to, uint _value) validDestination(_to) public returns (bool) 
398     {
399         return super.transferFrom(_from, _to, _value);
400     }
401 
402     event Burn(address indexed _burner, uint _value);
403 
404     function burn(uint _value) public returns (bool)
405     {
406         balances[msg.sender] = balances[msg.sender].sub(_value);
407         totalSupply = totalSupply.sub(_value);
408         emit Burn(msg.sender, _value);
409         emit Transfer(msg.sender, address(0x0), _value);
410         return true;
411     }
412 
413     // save some gas by making only one contract call
414     function burnFrom(address _from, uint256 _value) public returns (bool) 
415     {
416         assert( transferFrom( _from, msg.sender, _value ) );
417         return burn(_value);
418     }
419 
420     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner public {
421         // owner can drain tokens that are sent here by mistake
422         token.transfer( owner, amount );
423     }
424 
425     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
426 
427     function changeAdmin(address newAdmin) onlyOwner public {
428         // owner can re-assign the admin
429         emit AdminTransferred(admin, newAdmin);
430         admin = newAdmin;
431     }
432 }