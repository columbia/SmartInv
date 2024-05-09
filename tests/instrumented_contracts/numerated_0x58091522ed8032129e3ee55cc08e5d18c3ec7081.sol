1 pragma solidity ^0.4.21;
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
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
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
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
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
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     emit Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   function multisend(address[] dests, uint256[] values) public returns (uint256);
115 
116   
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     emit Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     emit Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To decrement
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _subtractedValue The amount of tokens to decrease the allowance by.
202    */
203   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204     uint oldValue = allowed[msg.sender][_spender];
205     if (_subtractedValue > oldValue) {
206       allowed[msg.sender][_spender] = 0;
207     } else {
208       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209     }
210     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213   
214     function multisend(address[] dests, uint256[] values) public returns (uint256) {
215         uint256 i = 0;
216         while (i < dests.length) {
217            transfer(dests[i], values[i]);
218            i += 1;
219         }
220         return(i);
221     }
222 
223 }
224 
225 
226 /**
227  * @title Ownable
228  * @dev The Ownable contract has an owner address, and provides basic authorization control
229  * functions, this simplifies the implementation of "user permissions".
230  */
231 contract Ownable {
232   address public owner;
233 
234 
235   event OwnershipRenounced(address indexed previousOwner);
236   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238 
239   /**
240    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
241    * account.
242    */
243   function Ownable() public {
244     owner = msg.sender;
245   }
246 
247   /**
248    * @dev Throws if called by any account other than the owner.
249    */
250   modifier onlyOwner() {
251     require(msg.sender == owner);
252     _;
253   }
254 
255   /**
256    * @dev Allows the current owner to transfer control of the contract to a newOwner.
257    * @param newOwner The address to transfer ownership to.
258    */
259   function transferOwnership(address newOwner) public onlyOwner {
260     require(newOwner != address(0));
261     emit OwnershipTransferred(owner, newOwner);
262     owner = newOwner;
263   }
264 
265   /**
266    * @dev Allows the current owner to relinquish control of the contract.
267    */
268   function renounceOwnership() public onlyOwner {
269     emit OwnershipRenounced(owner);
270     owner = address(0);
271   }
272 }
273 
274 /**
275  * @title Pausable
276  * @dev Base contract which allows children to implement an emergency stop mechanism.
277  */
278 contract Pausable is Ownable {
279   event Pause();
280   event Unpause();
281 
282   bool public paused = false;
283 
284 
285   /**
286    * @dev Modifier to make a function callable only when the contract is not paused.
287    */
288   modifier whenNotPaused() {
289     require(!paused);
290     _;
291   }
292 
293   /**
294    * @dev Modifier to make a function callable only when the contract is paused.
295    */
296   modifier whenPaused() {
297     require(paused);
298     _;
299   }
300 
301   /**
302    * @dev called by the owner to pause, triggers stopped state
303    */
304   function pause() onlyOwner whenNotPaused public {
305     paused = true;
306     emit Pause();
307   }
308 
309   /**
310    * @dev called by the owner to unpause, returns to normal state
311    */
312   function unpause() onlyOwner whenPaused public {
313     paused = false;
314     emit Unpause();
315   }
316 }
317 
318 /**
319  * @title Pausable token
320  * @dev StandardToken modified with pausable transfers.
321  **/
322 contract PausableToken is StandardToken, Pausable {
323 
324   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
325     return super.transfer(_to, _value);
326   }
327 
328   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
329     return super.transferFrom(_from, _to, _value);
330   }
331 
332   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
333     return super.approve(_spender, _value);
334   }
335 
336   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
337     return super.increaseApproval(_spender, _addedValue);
338   }
339 
340   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
341     return super.decreaseApproval(_spender, _subtractedValue);
342   }
343 }
344 
345 contract WeGoldToken is StandardToken, Ownable, PausableToken {
346     string public constant name = "WeGold Token";
347     string public constant symbol = "WGD";
348     uint public constant decimals = 18;
349     uint public totalSupply;
350     
351     // there is no problem in using * here instead of .mul()
352     uint256 public constant initialSupply = 10000000000 * (10 ** uint256(decimals));
353 
354     // Constructors
355     function WeGoldToken () public {
356         totalSupply = initialSupply;
357         balances[msg.sender] = initialSupply; // Send all tokens to owner
358         emit Transfer(0x0, msg.sender, initialSupply);
359         
360     }   
361     
362 }