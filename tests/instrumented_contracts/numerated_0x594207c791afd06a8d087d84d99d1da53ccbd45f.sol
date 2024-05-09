1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public view returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * @dev https://github.com/ethereum/EIPs/issues/20
104  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
105  */
106 contract StandardToken is ERC20, BasicToken {
107 
108   mapping (address => mapping (address => uint256)) internal allowed;
109 
110 
111   /**
112    * @dev Transfer tokens from one address to another
113    * @param _from address The address which you want to send tokens from
114    * @param _to address The address which you want to transfer to
115    * @param _value uint256 the amount of tokens to be transferred
116    */
117   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    *
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public view returns (uint256) {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156    * @dev Increase the amount of tokens that an owner allowed to a spender.
157    *
158    * approve should be called when allowed[_spender] == 0. To increment
159    * allowed value is better to use this function to avoid 2 calls (and wait until
160    * the first transaction is mined)
161    * From MonolithDAO Token.sol
162    * @param _spender The address which will spend the funds.
163    * @param _addedValue The amount of tokens to increase the allowance by.
164    */
165   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
166     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   /**
172    * @dev Decrease the amount of tokens that an owner allowed to a spender.
173    *
174    * approve should be called when allowed[_spender] == 0. To decrement
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    * @param _spender The address which will spend the funds.
179    * @param _subtractedValue The amount of tokens to decrease the allowance by.
180    */
181   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
182     uint oldValue = allowed[msg.sender][_spender];
183     if (_subtractedValue > oldValue) {
184       allowed[msg.sender][_spender] = 0;
185     } else {
186       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187     }
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192 }
193 
194 
195 /**
196  * @title Ownable
197  * @dev The Ownable contract has an owner address, and provides basic authorization control
198  * functions, this simplifies the implementation of "user permissions".
199  */
200 contract Ownable {
201   address public owner;
202 
203 
204   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
205 
206 
207   /**
208    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
209    * account.
210    */
211   function Ownable() public {
212     owner = msg.sender;
213   }
214 
215 
216   /**
217    * @dev Throws if called by any account other than the owner.
218    */
219   modifier onlyOwner() {
220     require(msg.sender == owner);
221     _;
222   }
223 
224 
225   /**
226    * @dev Allows the current owner to transfer control of the contract to a newOwner.
227    * @param newOwner The address to transfer ownership to.
228    */
229   function transferOwnership(address newOwner) public onlyOwner {
230     require(newOwner != address(0));
231     OwnershipTransferred(owner, newOwner);
232     owner = newOwner;
233   }
234 
235 }
236 
237 
238 /**
239  * @title Pausable
240  * @dev Base contract which allows children to implement an emergency stop mechanism.
241  */
242 contract Pausable is Ownable {
243   event Pause();
244   event Unpause();
245 
246   bool public paused = false;
247 
248 
249   /**
250    * @dev Modifier to make a function callable only when the contract is not paused.
251    */
252   modifier whenNotPaused() {
253     require(!paused);
254     _;
255   }
256 
257   /**
258    * @dev Modifier to make a function callable only when the contract is paused.
259    */
260   modifier whenPaused() {
261     require(paused);
262     _;
263   }
264 
265   /**
266    * @dev called by the owner to pause, triggers stopped state
267    */
268   function pause() onlyOwner whenNotPaused public {
269     paused = true;
270     Pause();
271   }
272 
273   /**
274    * @dev called by the owner to unpause, returns to normal state
275    */
276   function unpause() onlyOwner whenPaused public {
277     paused = false;
278     Unpause();
279   }
280 }
281 
282 
283 /**
284  * @title Pausable token
285  *
286  * @dev StandardToken modified with pausable transfers.
287  **/
288 
289 contract PausableToken is StandardToken, Pausable {
290 
291   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
292     return super.transfer(_to, _value);
293   }
294 
295   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
296     return super.transferFrom(_from, _to, _value);
297   }
298 
299   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
300     return super.approve(_spender, _value);
301   }
302 
303   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
304     return super.increaseApproval(_spender, _addedValue);
305   }
306 
307   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
308     return super.decreaseApproval(_spender, _subtractedValue);
309   }
310 }
311 
312 contract BuzzShowToken is PausableToken {
313     //Token Details
314     string public name = "BuzzShow Token";
315     string public symbol = "GLDY";
316     uint8 public decimals = 3;
317     uint public initialSupply = 150000000000;
318 
319     
320     bool public initialized = false;
321     //Token can be traded only if finalized
322     bool public finalized = false;
323 
324     address private salesTokenContract;
325 
326     //
327     // Events
328     //
329     event Initialized();
330     event Finalized();
331 
332     /**
333    * @dev Constructor
334    */
335     function BuzzShowToken() public
336     {
337         owner = msg.sender;
338 
339         salesTokenContract = address(0);
340 
341         totalSupply = initialSupply;
342         balances[msg.sender] = initialSupply;
343 
344         Transfer(address(0), msg.sender, initialSupply);
345 
346         pause();
347     }
348 
349     /**
350    * @dev This function initializes the contract. Can be used only by owner
351    */
352     function init(address _salesTokenContract) external onlyOwner {
353         require(!initialized);
354         require(address(salesTokenContract) == address(0));
355         require(address(_salesTokenContract) != address(0));
356         require(address(_salesTokenContract) != address(this));
357         require(address(_salesTokenContract) != owner);
358 
359         salesTokenContract = _salesTokenContract;
360 
361         initialized = true;
362         Initialized();
363 
364         unpause();
365     }
366 
367     function finalize() external onlyOwner returns (bool) {
368         require(!finalized);
369 
370         finalized = true;
371 
372         Finalized();
373 
374         return true;
375     }
376 
377     function transfer(address _to, uint256 _value) public returns (bool success) {
378         validateTransfer(msg.sender, _to);
379 
380         return super.transfer(_to, _value);
381     }
382 
383     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
384         validateTransfer(msg.sender, _to);
385 
386         return super.transferFrom(_from, _to, _value);
387     }
388 
389     function validateTransfer(address _sender, address _to) private view {
390         require(_to != address(0));
391 
392         // Once the token is finalized, everybody can transfer tokens.
393         if (finalized) {
394             return;
395         }
396 
397         // Before the token is finalized, only the owner or the sales token contract 
398         // are allowed to transfers.
399         require(_sender == owner || _sender == salesTokenContract);
400     }
401 }