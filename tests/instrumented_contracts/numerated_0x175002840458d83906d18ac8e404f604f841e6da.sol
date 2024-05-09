1 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.5.16;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: zeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.5.16;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     if (a == 0) {
34       return 0;
35     }
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 pragma solidity ^0.5.16;
72 
73 
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   uint256 totalSupply_;
86 
87   /**
88   * @dev total number of tokens in existence
89   */
90   function totalSupply() public view returns (uint256) {
91     return totalSupply_;
92   }
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
121 
122 pragma solidity ^0.5.16;
123 
124 
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) public view returns (uint256);
132   function transferFrom(address from, address to, uint256 value) public returns (bool);
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
138 
139 pragma solidity ^0.5.16;
140 
141 
142 
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     emit Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * @dev Increase the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
211     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   /**
217    * @dev Decrease the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
227     uint oldValue = allowed[msg.sender][_spender];
228     if (_subtractedValue > oldValue) {
229       allowed[msg.sender][_spender] = 0;
230     } else {
231       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232     }
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237 }
238 
239 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
240 
241 pragma solidity ^0.5.16;
242 
243 
244 /**
245  * @title Ownable
246  * @dev The Ownable contract has an owner address, and provides basic authorization control
247  * functions, this simplifies the implementation of "user permissions".
248  */
249 contract Ownable {
250   address public owner;
251 
252 
253   event OwnershipRenounced(address indexed previousOwner);
254   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
255 
256 
257   /**
258    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
259    * account.
260    */
261   constructor() public {
262     owner = msg.sender;
263   }
264 
265   /**
266    * @dev Throws if called by any account other than the owner.
267    */
268   modifier onlyOwner() {
269     require(msg.sender == owner);
270     _;
271   }
272 
273   /**
274    * @dev Allows the current owner to transfer control of the contract to a newOwner.
275    * @param newOwner The address to transfer ownership to.
276    */
277   function transferOwnership(address newOwner) public onlyOwner {
278     require(newOwner != address(0));
279     emit OwnershipTransferred(owner, newOwner);
280     owner = newOwner;
281   }
282 
283   /**
284    * @dev Allows the current owner to relinquish control of the contract.
285    */
286   function renounceOwnership() public onlyOwner {
287     emit OwnershipRenounced(owner);
288     owner = address(0);
289   }
290 }
291 
292 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
293 
294 pragma solidity ^0.5.16;
295 
296 
297 
298 
299 /**
300  * @title Mintable token
301  * @dev Simple ERC20 Token example, with mintable token creation
302  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
303  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
304  */
305 contract MintableToken is StandardToken, Ownable {
306   event Mint(address indexed to, uint256 amount);
307   event MintFinished();
308 
309   bool public mintingFinished = false;
310 
311 
312   modifier canMint() {
313     require(!mintingFinished);
314     _;
315   }
316 
317   /**
318    * @dev Function to mint tokens
319    * @param _to The address that will receive the minted tokens.
320    * @param _amount The amount of tokens to mint.
321    * @return A boolean that indicates if the operation was successful.
322    */
323   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
324     totalSupply_ = totalSupply_.add(_amount);
325     balances[_to] = balances[_to].add(_amount);
326     emit Mint(_to, _amount);
327     emit Transfer(address(0), _to, _amount);
328     return true;
329   }
330 
331   /**
332    * @dev Function to stop minting new tokens.
333    * @return True if the operation was successful.
334    */
335   function finishMinting() onlyOwner canMint public returns (bool) {
336     mintingFinished = true;
337     emit MintFinished();
338     return true;
339   }
340 }
341 
342 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
343 
344 pragma solidity ^0.5.16;
345 
346 
347 
348 /**
349  * @title Burnable Token
350  * @dev Token that can be irreversibly burned (destroyed).
351  */
352 contract BurnableToken is BasicToken {
353 
354   event Burn(address indexed burner, uint256 value);
355 
356   /**
357    * @dev Burns a specific amount of tokens.
358    * @param _value The amount of token to be burned.
359    */
360   function burn(uint256 _value) public {
361     _burn(msg.sender, _value);
362   }
363 
364   function _burn(address _who, uint256 _value) internal {
365     require(_value <= balances[_who]);
366     // no need to require value <= totalSupply, since that would imply the
367     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
368 
369     balances[_who] = balances[_who].sub(_value);
370     totalSupply_ = totalSupply_.sub(_value);
371     emit Burn(_who, _value);
372     emit Transfer(_who, address(0), _value);
373   }
374 }
375 
376 // File: contracts/RyomaToken.sol
377 
378 pragma solidity ^0.5.16;
379 
380 
381 
382 
383 contract RyomaToken is StandardToken, MintableToken, BurnableToken {
384 
385     string public name = "Ryoma";
386     string public symbol = "RYMA";
387     uint public decimals = 18;
388 
389     constructor(uint256 initialSupply, address _owner) public {
390         totalSupply_ = initialSupply;
391         balances[_owner] = initialSupply;
392     }
393 }