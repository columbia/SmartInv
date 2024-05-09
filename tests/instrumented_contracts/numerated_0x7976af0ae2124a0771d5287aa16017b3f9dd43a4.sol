1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72 
73   /**
74   * @dev Multiplies two numbers, throws on overflow.
75   */
76   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
77     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
78     // benefit is lost if 'b' is also tested.
79     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
80     if (a == 0) {
81       return 0;
82     }
83 
84     c = a * b;
85     assert(c / a == b);
86     return c;
87   }
88 
89   /**
90   * @dev Integer division of two numbers, truncating the quotient.
91   */
92   function div(uint256 a, uint256 b) internal pure returns (uint256) {
93     // assert(b > 0); // Solidity automatically throws when dividing by 0
94     // uint256 c = a / b;
95     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96     return a / b;
97   }
98 
99   /**
100   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
101   */
102   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103     assert(b <= a);
104     return a - b;
105   }
106 
107   /**
108   * @dev Adds two numbers, throws on overflow.
109   */
110   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
111     c = a + b;
112     assert(c >= a);
113     return c;
114   }
115 }
116 
117 
118 
119 contract ERC223ReceivingContract { 
120     function tokenFallback(address _from, uint _value, bytes _data) public;
121 }
122 
123 
124 
125 /**
126  * @title ERC20Basic
127  * @dev Simpler version of ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/179
129  */
130 contract ERC20Basic is Ownable {
131   function totalSupply() public view returns (uint256);
132   function balanceOf(address who) public view returns (uint256);
133   function transfer(address to, uint256 value) public returns (bool);
134   event Transfer(address indexed from, address indexed to, uint256 value);
135 }
136 
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 contract ERC20 is ERC20Basic {
142   function allowance(address owner, address spender) public view returns (uint256);
143   function transferFrom(address from, address to, uint256 value) public returns (bool);
144   function approve(address spender, uint256 value) public returns (bool);
145   event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 /**
149  * @title Basic token
150  * @dev Basic version of StandardToken, with no allowances.
151  */
152 contract BasicToken is ERC20Basic {
153   using SafeMath for uint256;
154 
155   mapping(address => uint256) balances;
156 
157   uint256 totalSupply_;
158   bool transferable;
159 
160   modifier isTransferable() {
161       require(transferable || msg.sender == owner);
162       _;
163   }
164 
165   /**
166   * @dev total number of tokens in existence
167   */
168   function totalSupply() public view returns (uint256) {
169     return totalSupply_;
170   }
171 
172   /**
173   * @dev transfer token for a specified address
174   * @param _to The address to transfer to.
175   * @param _value The amount to be transferred.
176   *//*
177   function transfer(address _to, uint256 _value) isTransferable public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[msg.sender]);
180 
181     balances[msg.sender] = balances[msg.sender].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     emit Transfer(msg.sender, _to, _value);
184     return true;
185   }
186   */
187   
188   
189   
190   
191   
192   
193 // Overridden transfer method with _data param for transaction data
194     function transfer(address _to, uint256 _value, bytes _data) isTransferable public {
195         uint codeLength;
196 
197         assembly {
198             codeLength := extcodesize(_to)
199         }
200 
201         balances[msg.sender] = balances[msg.sender].sub(_value);
202         balances[_to] = balances[_to].add(_value);
203         // Check to see if receiver is contract
204         if(codeLength>0) {
205             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
206             receiver.tokenFallback(msg.sender, _value, _data);
207         }
208         emit Transfer(msg.sender, _to, _value);
209     }
210     
211     // Overridden Backwards compatible transfer method without _data param
212     function transfer(address _to, uint256 _value) isTransferable public returns (bool) {
213         uint codeLength;
214         bytes memory empty;
215 
216         assembly {
217             codeLength := extcodesize(_to)
218         }
219 
220         balances[msg.sender] = balances[msg.sender].sub(_value);
221         balances[_to] = balances[_to].add(_value);
222         // Check to see if receiver is contract
223         if(codeLength>0) {
224             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
225             receiver.tokenFallback(msg.sender, _value, empty);
226         }
227         emit Transfer(msg.sender, _to, _value);
228     }
229   
230   
231   
232   
233   
234 
235   /**
236   * @dev Gets the balance of the specified address.
237   * @param _owner The address to query the the balance of.
238   * @return An uint256 representing the amount owned by the passed address.
239   */
240   function balanceOf(address _owner) public view returns (uint256) {
241     return balances[_owner];
242   }
243 
244 }
245 
246 /**
247  * @title Standard ERC20 token
248  *
249  * @dev Implementation of the basic standard token.
250  * @dev https://github.com/ethereum/EIPs/issues/20
251  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
252  */
253 contract StandardToken is ERC20, BasicToken {
254 
255   mapping (address => mapping (address => uint256)) internal allowed;
256 
257 
258   /**
259    * @dev Transfer tokens from one address to another
260    * @param _from address The address which you want to send tokens from
261    * @param _to address The address which you want to transfer to
262    * @param _value uint256 the amount of tokens to be transferred
263    */
264   function transferFrom(address _from, address _to, uint256 _value) isTransferable public returns (bool) {
265     require(_to != address(0));
266     require(_value <= balances[_from]);
267     require(_value <= allowed[_from][msg.sender]);
268 
269     balances[_from] = balances[_from].sub(_value);
270     balances[_to] = balances[_to].add(_value);
271     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
272     emit Transfer(_from, _to, _value);
273     return true;
274   }
275 
276   /**
277    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
278    *
279    * Beware that changing an allowance with this method brings the risk that someone may use both the old
280    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
281    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
282    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
283    * @param _spender The address which will spend the funds.
284    * @param _value The amount of tokens to be spent.
285    */
286   function approve(address _spender, uint256 _value) public returns (bool) {
287     allowed[msg.sender][_spender] = _value;
288     emit Approval(msg.sender, _spender, _value);
289     return true;
290   }
291 
292   /**
293    * @dev Function to check the amount of tokens that an owner allowed to a spender.
294    * @param _owner address The address which owns the funds.
295    * @param _spender address The address which will spend the funds.
296    * @return A uint256 specifying the amount of tokens still available for the spender.
297    */
298   function allowance(address _owner, address _spender) public view returns (uint256) {
299     return allowed[_owner][_spender];
300   }
301 
302   /**
303    * @dev Increase the amount of tokens that an owner allowed to a spender.
304    *
305    * approve should be called when allowed[_spender] == 0. To increment
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param _spender The address which will spend the funds.
310    * @param _addedValue The amount of tokens to increase the allowance by.
311    */
312   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
313     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
314     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315     return true;
316   }
317 
318   /**
319    * @dev Decrease the amount of tokens that an owner allowed to a spender.
320    *
321    * approve should be called when allowed[_spender] == 0. To decrement
322    * allowed value is better to use this function to avoid 2 calls (and wait until
323    * the first transaction is mined)
324    * From MonolithDAO Token.sol
325    * @param _spender The address which will spend the funds.
326    * @param _subtractedValue The amount of tokens to decrease the allowance by.
327    */
328   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
329     uint oldValue = allowed[msg.sender][_spender];
330     if (_subtractedValue > oldValue) {
331       allowed[msg.sender][_spender] = 0;
332     } else {
333       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
334     }
335     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
336     return true;
337   }
338 }
339 
340 /**
341  * @title Burnable Token
342  * @dev Token that can be irreversibly burned (destroyed).
343  */
344 contract BurnableToken is BasicToken {
345 
346   event Burn(address indexed burner, uint256 value);
347 
348   /**
349    * @dev Burns a specific amount of tokens.
350    * @param _value The amount of token to be burned.
351    */
352   function burn(uint256 _value) onlyOwner public {
353     _burn(msg.sender, _value);
354   }
355 
356   function _burn(address _who, uint256 _value) internal {
357     require(_value <= balances[_who]);
358     // no need to require value <= totalSupply, since that would imply the
359     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
360 
361     balances[_who] = balances[_who].sub(_value);
362     totalSupply_ = totalSupply_.sub(_value);
363     emit Burn(_who, _value);
364     emit Transfer(_who, address(0), _value);
365   }
366 }
367 
368 
369 contract BurCoin is BurnableToken {
370 
371     string public constant name = "Buratino Coin";
372     string public constant symbol = "BUR";
373     uint32 public constant decimals = 8;
374     uint256 public INITIAL_SUPPLY = 250000000 * 100000000000;
375 
376     constructor() public {
377         totalSupply_ = INITIAL_SUPPLY;
378         balances[msg.sender] = INITIAL_SUPPLY;
379         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
380         transferable = false;
381     }
382 
383 
384 	
385 	
386 	
387     modifier saleIsOn() {
388         require(transferable == false);
389         _;
390     }
391 
392     function refund(address _from, uint256 _value) onlyOwner saleIsOn public returns(bool) {
393         balances[_from] = balances[_from].sub(_value);
394         balances[owner] = balances[owner].add(_value);
395         emit Transfer(_from, owner, _value);
396         return true;
397     }
398 
399     function stopSale() onlyOwner saleIsOn public returns(bool) {
400         transferable = true;
401         return true;
402     }
403 
404 }