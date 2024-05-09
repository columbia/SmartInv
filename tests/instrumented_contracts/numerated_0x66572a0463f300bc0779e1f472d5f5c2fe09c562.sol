1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public supply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78     require(balances[_to] + _value >= balances[_to]);
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     emit Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92 
93   function balanceOf(address _owner) public view returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97 }
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * @dev https://github.com/ethereum/EIPs/issues/20
104  */
105 contract StandardToken is ERC20, BasicToken {
106 
107   mapping (address => mapping (address => uint256)) internal allowed;
108 
109   
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amount of tokens to be transferred
115    */
116   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[_from]);
119     require(_value <= allowed[_from][msg.sender]);
120 
121     balances[_from] = balances[_from].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124     emit Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130    *
131    * Beware that changing an allowance with this method brings the risk that someone may use both the old
132    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135    * @param _spender The address which will spend the funds.
136    * @param _value The amount of tokens to be spent.
137    */
138   function approve(address _spender, uint256 _value) public returns (bool) {
139     allowed[msg.sender][_spender] = _value;
140     emit Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param _owner address The address which owns the funds.
147    * @param _spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(address _owner, address _spender) public view returns (uint256) {
151     return allowed[_owner][_spender];
152   }
153 
154   /**
155    * approve should be called when allowed[_spender] == 0. To increment
156    * allowed value is better to use this function to avoid 2 calls (and wait until
157    * the first transaction is mined)
158    */
159   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176 }
177 
178 /**
179  * @title Ownable
180  * @dev The Ownable contract has an owner address, and provides basic authorization control
181  * functions, this simplifies the implementation of "user permissions".
182  */
183 contract Ownable {
184   address public owner;
185 
186 
187   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189 
190   /**
191    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
192    * account.
193    */
194   function Ownable() public {
195     owner = msg.sender;
196   }
197 
198 
199   /**
200    * @dev Throws if called by any account other than the owner.
201    */
202   modifier onlyOwner() {
203     require(msg.sender == owner);
204     _;
205   }
206 
207 
208   /**
209    * @dev Allows the current owner to transfer control of the contract to a newOwner.
210    * @param newOwner The address to transfer ownership to.
211    */
212   function transferOwnership(address newOwner) public onlyOwner {
213     require(newOwner != address(0));
214     emit OwnershipTransferred(owner, newOwner);
215     owner = newOwner;
216   }
217 
218 }
219 
220 /**
221  * @title Pausable
222  * @dev Base contract which allows children to implement an emergency stop mechanism.
223  */
224 contract Pausable is Ownable {
225   event Pause(bool newState);
226   event Unpause(bool newState);
227 
228   bool public paused = false;
229 
230 
231   /**
232    * Modifier to make a function callable only when the contract is not paused.
233    */
234   modifier whenNotPaused() {
235     require(!paused);
236     _;
237   }
238 
239   /**
240    * Modifier to make a function callable only when the contract is paused.
241    */
242   modifier whenPaused() {
243     require(paused);
244     _;
245   }
246 
247   /**
248    * called by the owner to pause, triggers stopped state
249    */
250   function pause() onlyOwner whenNotPaused public {
251     paused = true;
252     emit Pause(true);
253   }
254 
255   /**
256    * called by the owner to unpause, returns to normal state
257    */
258   function unpause() onlyOwner whenPaused public {
259     paused = false;
260     emit Unpause(false);
261   }
262 }
263 
264 contract PausableToken is StandardToken, Pausable {
265 
266   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
267     return super.transfer(_to, _value);
268   }
269 
270   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
271     return super.transferFrom(_from, _to, _value);
272   }
273 
274   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
275     return super.approve(_spender, _value);
276   }
277 
278   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
279     return super.increaseApproval(_spender, _addedValue);
280   }
281 
282   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
283     return super.decreaseApproval(_spender, _subtractedValue);
284   }
285 }
286 
287 
288 contract CIFCoin is PausableToken {
289     string  public  constant name = "CIFCoin";
290     string  public  constant symbol = "CIF";
291     uint8   public  constant decimals = 18;
292     uint256 public constant INITIAL_SUPPLY = 41500000e18; //41.5 million
293 
294     modifier validDestination( address to )
295     {
296         require(to != address(0x0));
297         require(to != address(this));
298         _;
299     }
300 
301     mapping(address => bool) frozen;
302 
303     function CIFCoin() public
304     {
305         
306         // assign the total tokens to CrowdIF
307         supply = INITIAL_SUPPLY;
308         balances[msg.sender] = INITIAL_SUPPLY;
309         emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
310     }
311 
312     function totalSupply() constant public returns (uint256) {
313         return supply;
314     }
315     
316 
317     function transfer(address _to, uint _value) validDestination(_to) public returns (bool) 
318     {
319       require(!isFrozen(msg.sender));
320       require(!isFrozen(_to));
321       return super.transfer(_to, _value);
322     }
323 
324     function transferFrom(address _from, address _to, uint _value) validDestination(_to) public returns (bool) 
325     {
326       require(!isFrozen(msg.sender));
327       require(!isFrozen(_from));
328       require(!isFrozen(_to));
329       return super.transferFrom(_from, _to, _value);
330     }
331 
332     event Burn(address indexed _burner, uint _value);
333 
334     function burn(uint _value) public returns (bool) 
335     {
336         balances[msg.sender] = balances[msg.sender].sub(_value);
337         supply = supply.sub(_value);
338         emit Burn(msg.sender, _value);
339         emit Transfer(msg.sender, address(0x0), _value);
340         return true;
341     }
342 
343     // save some gas by making only one contract call
344     function burnFrom(address _from, uint256 _value) public returns (bool) 
345     {
346         assert( transferFrom( _from, msg.sender, _value ) );
347         return burn(_value);
348     }
349 
350     function customExchangeSecure(address _from, address _to, uint256 _value) onlyOwner whenNotPaused public returns (bool)  {
351         require(_to != address(0));
352         require(balances[_from] >= _value);
353         require(balances[_to].add(_value) >= balances[_to]);
354         
355 
356         balances[_from] = balances[_from].sub(_value);
357         balances[_to] = balances[_to].add(_value);
358         emit Transfer(_from, _to, _value);
359         
360         return true;
361     }
362 
363     function customExchange(address _from, address _to, uint256 _value) onlyOwner public returns (bool)  {
364         require(_to != address(0));
365         require(balances[_from] >= _value);
366         require(balances[_to].add(_value) >= balances[_to]);
367 
368         balances[_from] = balances[_from].sub(_value);
369         balances[_to] = balances[_to].add(_value);
370         emit Transfer(_from, _to, _value);
371         
372         return true;
373     }
374 
375     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner public {
376         // owner can drain tokens that are sent here by mistake
377         token.transfer( owner, amount );
378     }
379 
380     
381 
382     /* This notifies clients about the amount frozen */
383     event Freeze(address indexed addr);
384   
385   /* This notifies clients about the amount unfrozen */
386     event Unfreeze(address indexed addr);
387 
388 
389      /**
390        * check if given address is frozen.
391        */
392     function isFrozen(address _addr) constant public returns (bool)  {
393           return frozen[_addr];
394       }
395 
396       /**
397        * Freezes address (no transfer can be made from or to this address).
398        */
399     function freeze(address _addr) onlyOwner public {
400           frozen[_addr] = true;
401       }
402 
403       /**
404        * Unfreezes frozen address.
405        */
406     function unfreeze(address _addr) onlyOwner public {
407           frozen[_addr] = false;
408     }
409 
410     event Mint(address indexed to, uint256 amount);
411     event MintFinished();
412 
413     bool public mintingFinished = false;
414 
415     modifier canMint() {
416         require(!mintingFinished);
417         _;
418     }
419 
420     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
421         supply = supply.add(_amount);
422         balances[_to] = balances[_to].add(_amount);
423         emit Mint(_to, _amount);
424         emit Transfer(address(0), _to, _amount);
425         return true;
426     }
427 
428     function finishMinting() onlyOwner canMint public returns (bool) {
429         mintingFinished = true;
430         emit MintFinished();
431         return true;
432     }
433 
434       // transfer balance to owner
435       function withdrawEther(uint256 amount) onlyOwner public {
436         require(msg.sender == owner);
437         owner.transfer(amount);
438       }
439       
440       // can accept ether
441       function() payable public {
442         }
443 
444 }