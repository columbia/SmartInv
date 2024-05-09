1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amount of tokens to be transferred
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) public view returns (uint256) {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To decrement
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _subtractedValue The amount of tokens to decrease the allowance by.
197    */
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 /**
212  * @title Ownable
213  * @dev The Ownable contract has an owner address, and provides basic authorization control
214  * functions, this simplifies the implementation of "user permissions".
215  */
216 contract Ownable {
217   address public owner;
218 
219 
220   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
221 
222 
223   /**
224    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
225    * account.
226    */
227   constructor() public {
228     owner = msg.sender;
229   }
230 
231   /**
232    * @dev Throws if called by any account other than the owner.
233    */
234   modifier onlyOwner() {
235     require(msg.sender == owner);
236     _;
237   }
238 
239   /**
240    * @dev Allows the current owner to transfer control of the contract to a newOwner.
241    * @param newOwner The address to transfer ownership to.
242    */
243   function transferOwnership(address newOwner) public onlyOwner {
244     require(newOwner != address(0));
245     emit OwnershipTransferred(owner, newOwner);
246     owner = newOwner;
247   }
248 
249 }
250 
251 /**
252  * @title Pausable
253  * @dev Base contract which allows children to implement an emergency stop mechanism.
254  */
255 contract Pausable is Ownable {
256   event PausePublic(bool newState);
257   event PauseOwnerAdmin(bool newState);
258 
259   bool public pausedPublic = true;
260   bool public pausedOwnerAdmin = false;
261 
262   /**
263    * @dev Modifier to make a function callable based on pause states.
264    */
265   modifier whenNotPaused() {
266     if(pausedPublic) {
267       if(!pausedOwnerAdmin) {
268         require(msg.sender == owner || msg.sender == owner);
269       } else {
270         revert();
271       }
272     }
273     _;
274   }
275 
276   /**
277    * @dev called by the owner to set new pause flags
278    * pausedPublic can't be false while pausedOwnerAdmin is true
279    */
280   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
281     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
282 
283     pausedPublic = newPausedPublic;
284     pausedOwnerAdmin = newPausedOwnerAdmin;
285 
286     emit PausePublic(newPausedPublic);
287     emit PauseOwnerAdmin(newPausedOwnerAdmin);
288   }
289 }
290 
291 contract PausableToken is StandardToken, Pausable {
292 
293   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
294     return super.transfer(_to, _value);
295   }
296 
297   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
298     return super.transferFrom(_from, _to, _value);
299   }
300 
301   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
302     return super.approve(_spender, _value);
303   }
304 
305   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
306     return super.increaseApproval(_spender, _addedValue);
307   }
308 
309   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
310     return super.decreaseApproval(_spender, _subtractedValue);
311   }
312 }
313 
314 /**
315  * @title Mintable token
316  * @dev Simple ERC20 Token example, with mintable token creation
317  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
318  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
319  */
320 contract MintableToken is StandardToken, Ownable {
321   event Mint(address indexed to, uint256 amount);
322   event MintFinished();
323 
324   bool public mintingFinished = false;
325 
326 
327   modifier canMint() {
328     require(!mintingFinished);
329     _;
330   }
331 
332   /**
333    * @dev Function to mint tokens
334    * @param _to The address that will receive the minted tokens.
335    * @param _amount The amount of tokens to mint.
336    * @return A boolean that indicates if the operation was successful.
337    */
338   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
339     totalSupply_ = totalSupply_.add(_amount);
340     balances[_to] = balances[_to].add(_amount);
341     emit Mint(_to, _amount);
342     emit Transfer(address(0), _to, _amount);
343     return true;
344   }
345 
346   /**
347    * @dev Function to stop minting new tokens.
348    * @return True if the operation was successful.
349    */
350   function finishMinting() onlyOwner canMint public returns (bool) {
351     mintingFinished = true;
352     emit MintFinished();
353     return true;
354   }
355 }
356 
357 contract Cellpinda is PausableToken, MintableToken {
358     string public name = "Cellpinda";
359     string public symbol = "CPD";
360     uint256 public decimals = 8;
361     uint256 public INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
362   
363     constructor() public 
364     {
365         // assign the admin account
366         owner = msg.sender;
367         // assign the total tokens to owner
368         totalSupply_ = INITIAL_SUPPLY;
369         balances[msg.sender] = totalSupply_;
370         emit Transfer(address(0x0), msg.sender, totalSupply_);
371 
372     }
373 
374     event Burn(address indexed _burner, uint _value);
375 
376     function burn(uint _value) public returns (bool)
377     {
378         balances[msg.sender] = balances[msg.sender].sub(_value);
379         totalSupply_ = totalSupply_.sub(_value);
380         emit Burn(msg.sender, _value);
381         emit Transfer(msg.sender, address(0x0), _value);
382         return true;
383     }
384 
385     // save some gas by making only one contract call
386     function burnFrom(address _from, uint256 _value) public returns (bool) 
387     {
388         assert( transferFrom( _from, msg.sender, _value ) );
389         return burn(_value);
390     }
391 
392 }