1 pragma solidity 0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public view returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) internal balances;
82 
83   uint256 internal totalSupply_;
84 
85   /**
86   * @dev total number of tokens in existence
87   */
88   function totalSupply() public view returns (uint256) {
89     return totalSupply_;
90   }
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_to != address(this));
100     require(_value <= balances[msg.sender]);
101 
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     emit Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256) {
114     return balances[_owner];
115   }
116 
117 }
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128   mapping (address => mapping (address => uint256)) internal allowed;
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint256 the amount of tokens to be transferred
135    */
136   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_to != address(this));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     emit Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     emit Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public view returns (uint256) {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * @dev Increase the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191   /**
192    * @dev Decrease the amount of tokens that an owner allowed to a spender.
193    *
194    * approve should be called when allowed[_spender] == 0. To decrement
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 }
212 
213 /**
214  * @title Ownable
215  * @dev The Ownable contract has an owner address, and provides basic authorization control
216  * functions, this simplifies the implementation of "user permissions".
217  */
218 contract Ownable {
219   address public owner;
220 
221 
222   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223 
224 
225   /**
226    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
227    * account.
228    */
229   function Ownable() public {
230     owner = msg.sender;
231   }
232 
233   /**
234    * @dev Throws if called by any account other than the owner.
235    */
236   modifier onlyOwner() {
237     require(msg.sender == owner);
238     _;
239   }
240 
241   /**
242    * @dev Allows the current owner to transfer control of the contract to a newOwner.
243    * @param newOwner The address to transfer ownership to.
244    */
245   function transferOwnership(address newOwner) public onlyOwner {
246     require(newOwner != address(0));
247     emit OwnershipTransferred(owner, newOwner);
248     owner = newOwner;
249   }
250 
251 }
252 
253 
254 /**
255  * @title Pausable
256  * @dev Base contract which allows children to implement an emergency stop mechanism.
257  */
258 contract Pausable is Ownable {
259   event Pause();
260   event Unpause();
261 
262   bool public paused = false;
263 
264 
265   /**
266    * @dev Modifier to make a function callable only when the contract is not paused.
267    */
268   modifier whenNotPaused() {
269     require(!paused || owner == msg.sender);
270     _;
271   }
272 
273   /**
274    * @dev Modifier to make a function callable only when the contract is paused.
275    */
276   modifier whenPaused() {
277     require(paused);
278     _;
279   }
280 
281   /**
282    * @dev called by the owner to pause, triggers stopped state
283    */
284   function pause() onlyOwner whenNotPaused public {
285     paused = true;
286     emit Pause();
287   }
288 
289   /**
290    * @dev called by the owner to unpause, returns to normal state
291    */
292   function unpause() onlyOwner whenPaused public {
293     paused = false;
294     emit Unpause();
295   }
296 }
297 
298 
299 /**
300  * @title Pausable token
301  * @dev StandardToken modified with pausable transfers.
302  **/
303 contract PausableToken is StandardToken, Pausable {
304 
305   modifier onlyPayloadSize(uint256 numWords) {
306       require(msg.data.length >= numWords * 32 + 4, "Message payload is undersized");
307       _;
308   }
309 
310   function transfer(address _to, uint256 _value) public whenNotPaused onlyPayloadSize(2) returns (bool) {
311     return super.transfer(_to, _value);
312   }
313 
314   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused onlyPayloadSize(3) returns (bool) {
315     return super.transferFrom(_from, _to, _value);
316   }
317 
318   function approve(address _spender, uint256 _value) public whenNotPaused onlyPayloadSize(2) returns (bool) {
319     return super.approve(_spender, _value);
320   }
321 
322   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused onlyPayloadSize(2) returns (bool success) {
323     return super.increaseApproval(_spender, _addedValue);
324   }
325 
326   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused onlyPayloadSize(2) returns (bool success) {
327     return super.decreaseApproval(_spender, _subtractedValue);
328   }
329   
330   // fallback function reverts transaction
331   function() public payable {
332     revert();
333   }
334 
335   function batchTransfer(address[] _recipients, uint256[] _values) external onlyOwner whenNotPaused returns (uint256, bool) {
336      require(_recipients.length == _values.length);
337      address target;
338      uint256 amount;
339      bool success;
340      for (uint256 i = 0; i < _recipients.length; i++) {
341          target = _recipients[i];
342          amount = _values[i];
343          success = transfer(target,amount);
344          if(success == false) return (i, false);
345      }
346      return (i, true);
347   }
348 }
349 
350 contract LaborCryptoToken is PausableToken {
351 
352   string public constant name = "Laborcrypto";
353   string public constant symbol = "LBR";
354   uint8 public constant decimals = 18;
355 
356   constructor(uint256 _totalSupply) public {
357     totalSupply_ = _totalSupply;
358     balances[msg.sender] = _totalSupply;
359     emit Transfer(address(0), msg.sender, _totalSupply);
360   }
361 }