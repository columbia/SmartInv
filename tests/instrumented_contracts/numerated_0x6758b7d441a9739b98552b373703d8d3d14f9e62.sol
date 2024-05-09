1 pragma solidity 0.4.23;
2 
3 // File: contracts/ERC677Receiver.sol
4 
5 contract ERC677Receiver {
6   function onTokenTransfer(address _from, uint _value, bytes _data) external returns(bool);
7 }
8 
9 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   function totalSupply() public view returns (uint256);
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
24 
25 /**
26  * @title ERC20 interface
27  * @dev see https://github.com/ethereum/EIPs/issues/20
28  */
29 contract ERC20 is ERC20Basic {
30   function allowance(address owner, address spender) public view returns (uint256);
31   function transferFrom(address from, address to, uint256 value) public returns (bool);
32   function approve(address spender, uint256 value) public returns (bool);
33   event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 // File: contracts/ERC677.sol
37 
38 contract ERC677 is ERC20 {
39     event Transfer(address indexed from, address indexed to, uint value, bytes data);
40 
41     function transferAndCall(address, uint, bytes) external returns (bool);
42 
43 }
44 
45 // File: contracts/IBurnableMintableERC677Token.sol
46 
47 contract IBurnableMintableERC677Token is ERC677 {
48     function mint(address, uint256) public returns (bool);
49     function burn(uint256 _value) public;
50     function claimTokens(address _token, address _to) public;
51 }
52 
53 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, throws on overflow.
63   */
64   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
65     if (a == 0) {
66       return 0;
67     }
68     c = a * b;
69     assert(c / a == b);
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers, truncating the quotient.
75   */
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     // assert(b > 0); // Solidity automatically throws when dividing by 0
78     // uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return a / b;
81   }
82 
83   /**
84   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
85   */
86   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87     assert(b <= a);
88     return a - b;
89   }
90 
91   /**
92   * @dev Adds two numbers, throws on overflow.
93   */
94   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
95     c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111 
112   uint256 totalSupply_;
113 
114   /**
115   * @dev total number of tokens in existence
116   */
117   function totalSupply() public view returns (uint256) {
118     return totalSupply_;
119   }
120 
121   /**
122   * @dev transfer token for a specified address
123   * @param _to The address to transfer to.
124   * @param _value The amount to be transferred.
125   */
126   function transfer(address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[msg.sender]);
129 
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     emit Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public view returns (uint256) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
148 
149 /**
150  * @title Burnable Token
151  * @dev Token that can be irreversibly burned (destroyed).
152  */
153 contract BurnableToken is BasicToken {
154 
155   event Burn(address indexed burner, uint256 value);
156 
157   /**
158    * @dev Burns a specific amount of tokens.
159    * @param _value The amount of token to be burned.
160    */
161   function burn(uint256 _value) public {
162     _burn(msg.sender, _value);
163   }
164 
165   function _burn(address _who, uint256 _value) internal {
166     require(_value <= balances[_who]);
167     // no need to require value <= totalSupply, since that would imply the
168     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
169 
170     balances[_who] = balances[_who].sub(_value);
171     totalSupply_ = totalSupply_.sub(_value);
172     emit Burn(_who, _value);
173     emit Transfer(_who, address(0), _value);
174   }
175 }
176 
177 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
178 
179 contract DetailedERC20 is ERC20 {
180   string public name;
181   string public symbol;
182   uint8 public decimals;
183 
184   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
185     name = _name;
186     symbol = _symbol;
187     decimals = _decimals;
188   }
189 }
190 
191 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
192 
193 /**
194  * @title Ownable
195  * @dev The Ownable contract has an owner address, and provides basic authorization control
196  * functions, this simplifies the implementation of "user permissions".
197  */
198 contract Ownable {
199   address public owner;
200 
201 
202   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204 
205   /**
206    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
207    * account.
208    */
209   function Ownable() public {
210     owner = msg.sender;
211   }
212 
213   /**
214    * @dev Throws if called by any account other than the owner.
215    */
216   modifier onlyOwner() {
217     require(msg.sender == owner);
218     _;
219   }
220 
221   /**
222    * @dev Allows the current owner to transfer control of the contract to a newOwner.
223    * @param newOwner The address to transfer ownership to.
224    */
225   function transferOwnership(address newOwner) public onlyOwner {
226     require(newOwner != address(0));
227     emit OwnershipTransferred(owner, newOwner);
228     owner = newOwner;
229   }
230 
231 }
232 
233 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
234 
235 /**
236  * @title Standard ERC20 token
237  *
238  * @dev Implementation of the basic standard token.
239  * @dev https://github.com/ethereum/EIPs/issues/20
240  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
241  */
242 contract StandardToken is ERC20, BasicToken {
243 
244   mapping (address => mapping (address => uint256)) internal allowed;
245 
246 
247   /**
248    * @dev Transfer tokens from one address to another
249    * @param _from address The address which you want to send tokens from
250    * @param _to address The address which you want to transfer to
251    * @param _value uint256 the amount of tokens to be transferred
252    */
253   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
254     require(_to != address(0));
255     require(_value <= balances[_from]);
256     require(_value <= allowed[_from][msg.sender]);
257 
258     balances[_from] = balances[_from].sub(_value);
259     balances[_to] = balances[_to].add(_value);
260     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
261     emit Transfer(_from, _to, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
267    *
268    * Beware that changing an allowance with this method brings the risk that someone may use both the old
269    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
270    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
271    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
272    * @param _spender The address which will spend the funds.
273    * @param _value The amount of tokens to be spent.
274    */
275   function approve(address _spender, uint256 _value) public returns (bool) {
276     allowed[msg.sender][_spender] = _value;
277     emit Approval(msg.sender, _spender, _value);
278     return true;
279   }
280 
281   /**
282    * @dev Function to check the amount of tokens that an owner allowed to a spender.
283    * @param _owner address The address which owns the funds.
284    * @param _spender address The address which will spend the funds.
285    * @return A uint256 specifying the amount of tokens still available for the spender.
286    */
287   function allowance(address _owner, address _spender) public view returns (uint256) {
288     return allowed[_owner][_spender];
289   }
290 
291   /**
292    * @dev Increase the amount of tokens that an owner allowed to a spender.
293    *
294    * approve should be called when allowed[_spender] == 0. To increment
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _addedValue The amount of tokens to increase the allowance by.
300    */
301   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
302     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307   /**
308    * @dev Decrease the amount of tokens that an owner allowed to a spender.
309    *
310    * approve should be called when allowed[_spender] == 0. To decrement
311    * allowed value is better to use this function to avoid 2 calls (and wait until
312    * the first transaction is mined)
313    * From MonolithDAO Token.sol
314    * @param _spender The address which will spend the funds.
315    * @param _subtractedValue The amount of tokens to decrease the allowance by.
316    */
317   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
318     uint oldValue = allowed[msg.sender][_spender];
319     if (_subtractedValue > oldValue) {
320       allowed[msg.sender][_spender] = 0;
321     } else {
322       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
323     }
324     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
325     return true;
326   }
327 
328 }
329 
330 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
331 
332 /**
333  * @title Mintable token
334  * @dev Simple ERC20 Token example, with mintable token creation
335  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
336  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
337  */
338 contract MintableToken is StandardToken, Ownable {
339   event Mint(address indexed to, uint256 amount);
340   event MintFinished();
341 
342   bool public mintingFinished = false;
343 
344 
345   modifier canMint() {
346     require(!mintingFinished);
347     _;
348   }
349 
350   /**
351    * @dev Function to mint tokens
352    * @param _to The address that will receive the minted tokens.
353    * @param _amount The amount of tokens to mint.
354    * @return A boolean that indicates if the operation was successful.
355    */
356   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
357     totalSupply_ = totalSupply_.add(_amount);
358     balances[_to] = balances[_to].add(_amount);
359     emit Mint(_to, _amount);
360     emit Transfer(address(0), _to, _amount);
361     return true;
362   }
363 
364   /**
365    * @dev Function to stop minting new tokens.
366    * @return True if the operation was successful.
367    */
368   function finishMinting() onlyOwner canMint public returns (bool) {
369     mintingFinished = true;
370     emit MintFinished();
371     return true;
372   }
373 }
374 
375 // File: contracts/POA20.sol
376 
377 contract POA20 is
378     IBurnableMintableERC677Token,
379     DetailedERC20,
380     BurnableToken,
381     MintableToken {
382     function POA20(
383         string _name,
384         string _symbol,
385         uint8 _decimals)
386     public DetailedERC20(_name, _symbol, _decimals) {}
387 
388     modifier validRecipient(address _recipient) {
389         require(_recipient != address(0) && _recipient != address(this));
390         _;
391     }
392 
393     function transferAndCall(address _to, uint _value, bytes _data)
394         external validRecipient(_to) returns (bool)
395     {
396         require(transfer(_to, _value));
397         emit Transfer(msg.sender, _to, _value, _data);
398         if (isContract(_to)) {
399             require(contractFallback(_to, _value, _data));
400         }
401         return true;
402     }
403 
404     function contractFallback(address _to, uint _value, bytes _data)
405         private
406         returns(bool)
407     {
408         ERC677Receiver receiver = ERC677Receiver(_to);
409         return receiver.onTokenTransfer(msg.sender, _value, _data);
410     }
411 
412     function isContract(address _addr)
413         private
414         view
415         returns (bool)
416     {
417         uint length;
418         assembly { length := extcodesize(_addr) }
419         return length > 0;
420     }
421 
422     function finishMinting() public returns (bool) {
423         revert();
424     }
425 
426     function claimTokens(address _token, address _to) public onlyOwner {
427         require(_to != address(0));
428         if (_token == address(0)) {
429             _to.transfer(address(this).balance);
430             return;
431         }
432 
433         DetailedERC20 token = DetailedERC20(_token);
434         uint256 balance = token.balanceOf(address(this));
435         require(token.transfer(_to, balance));
436     }
437 
438 
439 }