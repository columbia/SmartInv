1 pragma solidity ^0.4.23;
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
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 pragma solidity ^0.4.23;
56 
57 
58 /**
59  * @title ERC20Basic
60  * @dev Simpler version of ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/179
62  */
63 contract ERC20Basic {
64   function totalSupply() public view returns (uint256);
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 pragma solidity ^0.4.23;
71 
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender)
79     public view returns (uint256);
80 
81   function transferFrom(address from, address to, uint256 value)
82     public returns (bool);
83 
84   function approve(address spender, uint256 value) public returns (bool);
85   event Approval(
86     address indexed owner,
87     address indexed spender,
88     uint256 value
89   );
90 }
91 
92 pragma solidity ^0.4.23;
93 
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   uint256 totalSupply_;
105 
106   /**
107   * @dev total number of tokens in existence
108   */
109   function totalSupply() public view returns (uint256) {
110     return totalSupply_;
111   }
112 
113   /**
114   * @dev transfer token for a specified address
115   * @param _to The address to transfer to.
116   * @param _value The amount to be transferred.
117   */
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121 
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     emit Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256) {
134     return balances[_owner];
135   }
136 
137 }
138 
139 pragma solidity ^0.4.23;
140 
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * @dev https://github.com/ethereum/EIPs/issues/20
147  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is ERC20, BasicToken {
150 
151   mapping (address => mapping (address => uint256)) internal allowed;
152 
153 
154   /**
155    * @dev Transfer tokens from one address to another
156    * @param _from address The address which you want to send tokens from
157    * @param _to address The address which you want to transfer to
158    * @param _value uint256 the amount of tokens to be transferred
159    */
160   function transferFrom(
161     address _from,
162     address _to,
163     uint256 _value
164   )
165     public
166     returns (bool)
167   {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     emit Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     emit Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(
202     address _owner,
203     address _spender
204    )
205     public
206     view
207     returns (uint256)
208   {
209     return allowed[_owner][_spender];
210   }
211 
212   /**
213    * @dev Increase the amount of tokens that an owner allowed to a spender.
214    *
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(
223     address _spender,
224     uint _addedValue
225   )
226     public
227     returns (bool)
228   {
229     allowed[msg.sender][_spender] = (
230       allowed[msg.sender][_spender].add(_addedValue));
231     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    *
238    * approve should be called when allowed[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseApproval(
246     address _spender,
247     uint _subtractedValue
248   )
249     public
250     returns (bool)
251   {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 pragma solidity ^0.4.23;
265 
266 
267 /**
268  * @title Ownable
269  * @dev The Ownable contract has an owner address, and provides basic authorization control
270  * functions, this simplifies the implementation of "user permissions".
271  */
272 contract Ownable {
273   address public owner;
274 
275 
276   event OwnershipRenounced(address indexed previousOwner);
277   event OwnershipTransferred(
278     address indexed previousOwner,
279     address indexed newOwner
280   );
281 
282 
283   /**
284    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
285    * account.
286    */
287   constructor() public {
288     owner = msg.sender;
289   }
290 
291   /**
292    * @dev Throws if called by any account other than the owner.
293    */
294   modifier onlyOwner() {
295     require(msg.sender == owner);
296     _;
297   }
298 
299   /**
300    * @dev Allows the current owner to relinquish control of the contract.
301    */
302   function renounceOwnership() public onlyOwner {
303     emit OwnershipRenounced(owner);
304     owner = address(0);
305   }
306 
307   /**
308    * @dev Allows the current owner to transfer control of the contract to a newOwner.
309    * @param _newOwner The address to transfer ownership to.
310    */
311   function transferOwnership(address _newOwner) public onlyOwner {
312     _transferOwnership(_newOwner);
313   }
314 
315   /**
316    * @dev Transfers control of the contract to a newOwner.
317    * @param _newOwner The address to transfer ownership to.
318    */
319   function _transferOwnership(address _newOwner) internal {
320     require(_newOwner != address(0));
321     emit OwnershipTransferred(owner, _newOwner);
322     owner = _newOwner;
323   }
324 }
325 
326 
327 pragma solidity ^0.4.23;
328 
329 /**
330  * @title Mintable token
331  * @dev Simple ERC20 Token example, with mintable token creation
332  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
333  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
334  */
335 contract MintableToken is StandardToken, Ownable {
336   event Mint(address indexed to, uint256 amount);
337   event MintFinished();
338 
339   bool public mintingFinished = false;
340 
341 
342   modifier canMint() {
343     require(!mintingFinished);
344     _;
345   }
346 
347   modifier hasMintPermission() {
348     require(msg.sender == owner);
349     _;
350   }
351 
352   /**
353    * @dev Function to mint tokens
354    * @param _to The address that will receive the minted tokens.
355    * @param _amount The amount of tokens to mint.
356    * @return A boolean that indicates if the operation was successful.
357    */
358   function mint(
359     address _to,
360     uint256 _amount
361   )
362     hasMintPermission
363     canMint
364     public
365     returns (bool)
366   {
367     totalSupply_ = totalSupply_.add(_amount);
368     balances[_to] = balances[_to].add(_amount);
369     emit Mint(_to, _amount);
370     emit Transfer(address(0), _to, _amount);
371     return true;
372   }
373 
374   /**
375    * @dev Function to stop minting new tokens.
376    * @return True if the operation was successful.
377    */
378   function finishMinting() onlyOwner canMint public returns (bool) {
379     mintingFinished = true;
380     emit MintFinished();
381     return true;
382   }
383 }
384 
385 
386 pragma solidity ^0.4.18;
387 
388 contract vtesttoken is MintableToken {
389     
390     string public constant name = "27v Token";
391     string public constant symbol = "27v";
392     uint8 public constant decimals = 18;
393 
394 }