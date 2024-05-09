1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) public onlyOwner {
74     require(newOwner != address(0));
75     emit OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 
82 
83 contract ERC20Basic {
84   function totalSupply() public view returns (uint256);
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 contract ERC20 is ERC20Basic {
91   function allowance(address owner, address spender) public view returns (uint256);
92   function transferFrom(address from, address to, uint256 value) public returns (bool);
93   function approve(address spender, uint256 value) public returns (bool);
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   uint256 totalSupply_;
103 
104   /**
105   * @dev total number of tokens in existence
106   */
107   function totalSupply() public view returns (uint256) {
108     return totalSupply_;
109   }
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[msg.sender]);
119 
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     emit Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) internal allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[_from]);
152     require(_value <= allowed[_from][msg.sender]);
153 
154     balances[_from] = balances[_from].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157     emit Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    *
164    * Beware that changing an allowance with this method brings the risk that someone may use both the old
165    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168    * @param _spender The address which will spend the funds.
169    * @param _value The amount of tokens to be spent.
170    */
171   function approve(address _spender, uint256 _value) public returns (bool) {
172     allowed[msg.sender][_spender] = _value;
173     emit Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(address _owner, address _spender) public view returns (uint256) {
184     return allowed[_owner][_spender];
185   }
186 
187   /**
188    * @dev Increase the amount of tokens that an owner allowed to a spender.
189    *
190    * approve should be called when allowed[_spender] == 0. To increment
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    * @param _spender The address which will spend the funds.
195    * @param _addedValue The amount of tokens to increase the allowance by.
196    */
197   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
198     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203   /**
204    * @dev Decrease the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To decrement
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _subtractedValue The amount of tokens to decrease the allowance by.
212    */
213   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
214     uint oldValue = allowed[msg.sender][_spender];
215     if (_subtractedValue > oldValue) {
216       allowed[msg.sender][_spender] = 0;
217     } else {
218       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219     }
220     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224 }
225 
226 contract MintableToken is StandardToken, Ownable {
227   event Mint(address indexed to, uint256 amount);
228   event MintFinished();
229 
230   bool public mintingFinished = false;
231 
232 
233   modifier canMint() {
234     require(!mintingFinished);
235     _;
236   }
237 
238   /**
239    * @dev Function to mint tokens
240    * @param _to The address that will receive the minted tokens.
241    * @param _amount The amount of tokens to mint.
242    * @return A boolean that indicates if the operation was successful.
243    */
244   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
245     totalSupply_ = totalSupply_.add(_amount);
246     balances[_to] = balances[_to].add(_amount);
247     emit Mint(_to, _amount);
248     emit Transfer(address(0), _to, _amount);
249     return true;
250   }
251 
252   /**
253    * @dev Function to stop minting new tokens.
254    * @return True if the operation was successful.
255    */
256   function finishMinting() onlyOwner canMint public returns (bool) {
257     mintingFinished = true;
258     emit MintFinished();
259     return true;
260   }
261 }
262 
263 contract ERC827 is ERC20 {
264   function approveAndCall( address _spender, uint256 _value, bytes _data) public payable returns (bool);
265   function transferAndCall( address _to, uint256 _value, bytes _data) public payable returns (bool);
266   function transferFromAndCall(
267     address _from,
268     address _to,
269     uint256 _value,
270     bytes _data
271   )
272     public
273     payable
274     returns (bool);
275 }
276 
277 contract ERC827Token is ERC827, StandardToken {
278 
279   /**
280    * @dev Addition to ERC20 token methods. It allows to
281    * @dev approve the transfer of value and execute a call with the sent data.
282    *
283    * @dev Beware that changing an allowance with this method brings the risk that
284    * @dev someone may use both the old and the new allowance by unfortunate
285    * @dev transaction ordering. One possible solution to mitigate this race condition
286    * @dev is to first reduce the spender's allowance to 0 and set the desired value
287    * @dev afterwards:
288    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
289    *
290    * @param _spender The address that will spend the funds.
291    * @param _value The amount of tokens to be spent.
292    * @param _data ABI-encoded contract call to call `_to` address.
293    *
294    * @return true if the call function was executed successfully
295    */
296   function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
297     require(_spender != address(this));
298 
299     super.approve(_spender, _value);
300 
301     // solium-disable-next-line security/no-call-value
302     require(_spender.call.value(msg.value)(_data));
303 
304     return true;
305   }
306 
307   /**
308    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
309    * @dev address and execute a call with the sent data on the same transaction
310    *
311    * @param _to address The address which you want to transfer to
312    * @param _value uint256 the amout of tokens to be transfered
313    * @param _data ABI-encoded contract call to call `_to` address.
314    *
315    * @return true if the call function was executed successfully
316    */
317   function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
318     require(_to != address(this));
319 
320     super.transfer(_to, _value);
321 
322     // solium-disable-next-line security/no-call-value
323     require(_to.call.value(msg.value)(_data));
324     return true;
325   }
326 
327   /**
328    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
329    * @dev another and make a contract call on the same transaction
330    *
331    * @param _from The address which you want to send tokens from
332    * @param _to The address which you want to transfer to
333    * @param _value The amout of tokens to be transferred
334    * @param _data ABI-encoded contract call to call `_to` address.
335    *
336    * @return true if the call function was executed successfully
337    */
338   function transferFromAndCall(
339     address _from,
340     address _to,
341     uint256 _value,
342     bytes _data
343   )
344     public payable returns (bool)
345   {
346     require(_to != address(this));
347 
348     super.transferFrom(_from, _to, _value);
349 
350     // solium-disable-next-line security/no-call-value
351     require(_to.call.value(msg.value)(_data));
352     return true;
353   }
354 
355   /**
356    * @dev Addition to StandardToken methods. Increase the amount of tokens that
357    * @dev an owner allowed to a spender and execute a call with the sent data.
358    *
359    * @dev approve should be called when allowed[_spender] == 0. To increment
360    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
361    * @dev the first transaction is mined)
362    * @dev From MonolithDAO Token.sol
363    *
364    * @param _spender The address which will spend the funds.
365    * @param _addedValue The amount of tokens to increase the allowance by.
366    * @param _data ABI-encoded contract call to call `_spender` address.
367    */
368   function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
369     require(_spender != address(this));
370 
371     super.increaseApproval(_spender, _addedValue);
372 
373     // solium-disable-next-line security/no-call-value
374     require(_spender.call.value(msg.value)(_data));
375 
376     return true;
377   }
378 
379   /**
380    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
381    * @dev an owner allowed to a spender and execute a call with the sent data.
382    *
383    * @dev approve should be called when allowed[_spender] == 0. To decrement
384    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
385    * @dev the first transaction is mined)
386    * @dev From MonolithDAO Token.sol
387    *
388    * @param _spender The address which will spend the funds.
389    * @param _subtractedValue The amount of tokens to decrease the allowance by.
390    * @param _data ABI-encoded contract call to call `_spender` address.
391    */
392   function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
393     require(_spender != address(this));
394 
395     super.decreaseApproval(_spender, _subtractedValue);
396 
397     // solium-disable-next-line security/no-call-value
398     require(_spender.call.value(msg.value)(_data));
399 
400     return true;
401   }
402 
403 }
404 
405 
406 contract MeditToken is MintableToken, ERC827Token {
407 
408   string public constant name = "MeditToken";
409   string public constant symbol = "MDT";
410   uint8 public constant decimals = 18;
411 
412   uint256 public constant INITIAL_SUPPLY = (10 ** 10) * (10 ** uint256(decimals));
413 
414   constructor () public {
415     totalSupply_ = INITIAL_SUPPLY;
416     balances[msg.sender] = INITIAL_SUPPLY;
417     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
418   }
419   
420 }