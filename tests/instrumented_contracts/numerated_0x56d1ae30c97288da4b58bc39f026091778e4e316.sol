1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public view returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   uint256 totalSupply_;
102   
103   /**
104   * @dev total number of tokens in existence
105   */
106   function totalSupply() public view returns (uint256) {
107     return totalSupply_;
108   }
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115  
116   function transfer(address _to, uint256 _value) public  returns (bool) {
117       
118   
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121     // SafeMath.sub will throw if there is not enough balance.
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256 balance) {
134     return balances[_owner];
135   }
136 
137 }
138 
139 contract StandardToken is ERC20, BasicToken {
140 
141   mapping (address => mapping (address => uint256)) internal allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amount of tokens to be transferred
149    */
150   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
151     require(_to != address(0));
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154 
155     balances[_from] = balances[_from].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158     Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    *
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(address _owner, address _spender) public view returns (uint256) {
185     return allowed[_owner][_spender];
186   }
187 
188   /**
189    * @dev Increase the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To increment
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _addedValue The amount of tokens to increase the allowance by.
197    */
198   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
199     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
200     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204   /**
205    * @dev Decrease the amount of tokens that an owner allowed to a spender.
206    *
207    * approve should be called when allowed[_spender] == 0. To decrement
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _subtractedValue The amount of tokens to decrease the allowance by.
213    */
214   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 
228 contract MintableToken is StandardToken, Ownable {
229   event Mint(address indexed to, uint256 amount);
230   event MintFinished();
231 
232   bool public mintingFinished = false;
233 
234 
235   modifier canMint() {
236     require(!mintingFinished);
237     _;
238   }
239 
240   /**
241    * @dev Function to mint tokens
242    * @param _to The address that will receive the minted tokens.
243    * @param _amount The amount of tokens to mint.
244    * @return A boolean that indicates if the operation was successful.
245    */
246   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
247     totalSupply_ = totalSupply_.add(_amount);
248     balances[_to] = balances[_to].add(_amount);
249     Mint(_to, _amount);
250     Transfer(address(0), _to, _amount);
251     return true;
252   }
253 
254   /**
255    * @dev Function to stop minting new tokens.
256    * @return True if the operation was successful.
257    */
258   function finishMinting() onlyOwner canMint public returns (bool) {
259     mintingFinished = true;
260     MintFinished();
261     return true;
262   }
263 }
264 
265 contract Pausable is Ownable {
266   event Pause();
267   event Unpause();
268 
269   bool public paused = false;
270 
271 
272   /**
273    * @dev Modifier to make a function callable only when the contract is not paused.
274    */
275   modifier whenNotPaused() {
276     require(!paused);
277     _;
278   }
279 
280   /**
281    * @dev Modifier to make a function callable only when the contract is paused.
282    */
283   modifier whenPaused() {
284     require(paused);
285     _;
286   }
287 
288   /**
289    * @dev called by the owner to pause, triggers stopped state
290    */
291   function pause() onlyOwner whenNotPaused public {
292     paused = true;
293     Pause();
294   }
295 
296   /**
297    * @dev called by the owner to unpause, returns to normal state
298    */
299   function unpause() onlyOwner whenPaused public {
300     paused = false;
301     Unpause();
302   }
303 }
304 
305 contract PausableToken is StandardToken, Pausable {
306 
307   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
308     return super.transfer(_to, _value);
309   }
310 
311   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
312     return super.transferFrom(_from, _to, _value);
313   }
314 
315   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
316     return super.approve(_spender, _value);
317   }
318 
319   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
320     return super.increaseApproval(_spender, _addedValue);
321   }
322 
323   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
324     return super.decreaseApproval(_spender, _subtractedValue);
325   }
326 }
327 
328 contract Dagt is MintableToken, PausableToken {
329     string public constant version = "1.1";
330     string public constant name = "DAGT Crypto Platform";
331     string public constant symbol = "DAGT";
332     uint8 public constant decimals = 18;
333 
334     event MintMasterTransferred(address indexed previousMaster, address indexed newMaster);
335 
336     address public mintMaster;
337 
338     modifier onlyMintMasterOrOwner() {
339         require(msg.sender == mintMaster || msg.sender == owner);
340         _;
341     }
342 
343     function Dagt() public {
344         mintMaster = msg.sender;
345     }
346 
347     function transferMintMaster(address newMaster) onlyOwner public {
348         require(newMaster != address(0));
349         MintMasterTransferred(mintMaster, newMaster);
350         mintMaster = newMaster;
351     }
352 
353     function mintToAddresses(address[] addresses, uint256 amount) public onlyMintMasterOrOwner canMint {
354         for (uint i = 0; i < addresses.length; i++) {
355             require(mint(addresses[i], amount));
356         }
357     }
358 
359     function mintToAddressesAndAmounts(address[] addresses, uint256[] amounts) public onlyMintMasterOrOwner canMint {
360         require(addresses.length == amounts.length);
361         for (uint i = 0; i < addresses.length; i++) {
362             require(mint(addresses[i], amounts[i]));
363         }
364     }
365     /**
366      * @dev Function to mint tokens
367      * @param _to The address that will receive the minted tokens.
368      * @param _amount The amount of tokens to mint.
369      * @return A boolean that indicates if the operation was successful.
370      */
371     function mint(address _to, uint256 _amount) onlyMintMasterOrOwner canMint public returns (bool) {
372         
373       
374         address oldOwner = owner;
375         owner = msg.sender;
376         bool result = super.mint(_to, _amount);
377         owner = oldOwner;
378         return result;
379     }
380     
381     
382 
383 
384 }