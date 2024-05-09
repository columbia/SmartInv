1 pragma solidity 0.4.18;
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
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 
77 /**
78  * @title Pausable
79  * @dev Base contract which allows children to implement an emergency stop mechanism.
80  */
81 contract Pausable is Ownable {
82   event Pause();
83   event Unpause();
84 
85   bool public paused = false;
86 
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is not paused.
90    */
91   modifier whenNotPaused() {
92     require(!paused);
93     _;
94   }
95 
96   /**
97    * @dev Modifier to make a function callable only when the contract is paused.
98    */
99   modifier whenPaused() {
100     require(paused);
101     _;
102   }
103 
104   /**
105    * @dev called by the owner to pause, triggers stopped state
106    */
107   function pause() onlyOwner whenNotPaused public {
108     paused = true;
109     Pause();
110   }
111 
112   /**
113    * @dev called by the owner to unpause, returns to normal state
114    */
115   function unpause() onlyOwner whenPaused public {
116     paused = false;
117     Unpause();
118   }
119 }
120 
121 
122 /**
123  * @title ERC20Basic
124  * @dev Simpler version of ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/179
126  */
127 contract ERC20Basic {
128   uint256 public totalSupply;
129   function balanceOf(address who) public view returns (uint256);
130   function transfer(address to, uint256 value) public returns (bool);
131   event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) balances;
143 
144   /**
145   * @dev transfer token for a specified address
146   * @param _to The address to transfer to.
147   * @param _value The amount to be transferred.
148   */
149   function transfer(address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[msg.sender]);
152 
153     // SafeMath.sub will throw if there is not enough balance.
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256 balance) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 
172 /**
173  * @title ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/20
175  */
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender) public view returns (uint256);
178   function transferFrom(address from, address to, uint256 value) public returns (bool);
179   function approve(address spender, uint256 value) public returns (bool);
180   event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 
184 
185 /**
186  * @title Standard ERC20 token
187  *
188  * @dev Implementation of the basic standard token.
189  * @dev https://github.com/ethereum/EIPs/issues/20
190  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
191  */
192 contract StandardToken is ERC20, BasicToken {
193 
194   mapping (address => mapping (address => uint256)) internal allowed;
195 
196 
197   /**
198    * @dev Transfer tokens from one address to another
199    * @param _from address The address which you want to send tokens from
200    * @param _to address The address which you want to transfer to
201    * @param _value uint256 the amount of tokens to be transferred
202    */
203   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
204     require(_to != address(0));
205     require(_value <= balances[_from]);
206     require(_value <= allowed[_from][msg.sender]);
207 
208     balances[_from] = balances[_from].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211     Transfer(_from, _to, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217    *
218    * Beware that changing an allowance with this method brings the risk that someone may use both the old
219    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    * @param _spender The address which will spend the funds.
223    * @param _value The amount of tokens to be spent.
224    */
225   function approve(address _spender, uint256 _value) public returns (bool) {
226     allowed[msg.sender][_spender] = _value;
227     Approval(msg.sender, _spender, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Function to check the amount of tokens that an owner allowed to a spender.
233    * @param _owner address The address which owns the funds.
234    * @param _spender address The address which will spend the funds.
235    * @return A uint256 specifying the amount of tokens still available for the spender.
236    */
237   function allowance(address _owner, address _spender) public view returns (uint256) {
238     return allowed[_owner][_spender];
239   }
240 
241   /**
242    * approve should be called when allowed[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    */
247   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
248     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
254     uint oldValue = allowed[msg.sender][_spender];
255     if (_subtractedValue > oldValue) {
256       allowed[msg.sender][_spender] = 0;
257     } else {
258       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259     }
260     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 
264 }
265 
266 
267 /**
268  * @title Pausable token
269  *
270  * @dev StandardToken modified with pausable transfers.
271  **/
272 
273 contract PausableToken is StandardToken, Pausable {
274 
275   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
276     return super.transfer(_to, _value);
277   }
278 
279   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
280     return super.transferFrom(_from, _to, _value);
281   }
282 
283   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
284     return super.approve(_spender, _value);
285   }
286 
287   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
288     return super.increaseApproval(_spender, _addedValue);
289   }
290 
291   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
292     return super.decreaseApproval(_spender, _subtractedValue);
293   }
294 }
295 
296 contract CostumeToken is PausableToken {
297   using SafeMath for uint256;
298 
299   // Token Details
300   string public constant name = 'Costume Token';
301   string public constant symbol = 'COST';
302   uint8 public constant decimals = 18;
303 
304   // 200 Million Total Supply
305   uint256 public constant totalSupply = 200e24;
306 
307   // 120 Million - Supply not for Crowdsale
308   uint256 public initialSupply = 120e24;
309 
310   // 80 Million - Crowdsale limit
311   uint256 public limitCrowdsale = 80e24;
312 
313   // Tokens Distributed - Crowdsale Buyers
314   uint256 public tokensDistributedCrowdsale = 0;
315 
316   // The address of the crowdsale
317   address public crowdsale;
318 
319   // -- MODIFIERS
320 
321   // Modifier, must be called from Crowdsale contract
322   modifier onlyCrowdsale() {
323     require(msg.sender == crowdsale);
324     _;
325   }
326 
327   // Constructor - send initial supply to owner
328   function CostumeToken() public {
329     balances[msg.sender] = initialSupply;
330   }
331 
332   // Set crowdsale address, only by owner
333   // @param - crowdsale address
334   function setCrowdsaleAddress(address _crowdsale) external onlyOwner whenNotPaused {
335     require(crowdsale == address(0));
336     require(_crowdsale != address(0));
337     crowdsale = _crowdsale;
338   }
339 
340   // Distribute tokens, only by crowdsale
341   // @param _buyer The buyer address
342   // @param tokens The amount of tokens to send to that address
343   function distributeCrowdsaleTokens(address _buyer, uint tokens) external onlyCrowdsale whenNotPaused {
344     require(_buyer != address(0));
345     require(tokens > 0);
346 
347     require(tokensDistributedCrowdsale < limitCrowdsale);
348     require(tokensDistributedCrowdsale.add(tokens) <= limitCrowdsale);
349 
350     // Tick up the distributed amount
351     tokensDistributedCrowdsale = tokensDistributedCrowdsale.add(tokens);
352 
353     // Add the funds to buyer address
354     balances[_buyer] = balances[_buyer].add(tokens);
355   }
356 
357 }