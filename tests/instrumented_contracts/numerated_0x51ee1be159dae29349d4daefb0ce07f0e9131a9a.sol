1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipRenounced(address indexed previousOwner);
12   event OwnershipTransferred(
13     address indexed previousOwner,
14     address indexed newOwner
15   );
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to relinquish control of the contract.
35    */
36   function renounceOwnership() public onlyOwner {
37     emit OwnershipRenounced(owner);
38     owner = address(0);
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address _newOwner) public onlyOwner {
46     _transferOwnership(_newOwner);
47   }
48 
49   /**
50    * @dev Transfers control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function _transferOwnership(address _newOwner) internal {
54     require(_newOwner != address(0));
55     emit OwnershipTransferred(owner, _newOwner);
56     owner = _newOwner;
57   }
58 }
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
70     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
71     // benefit is lost if 'b' is also tested.
72     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
73     if (a == 0) {
74       return 0;
75     }
76 
77     c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     // uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return a / b;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
104     c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 }
109 
110 /**
111  * @title ERC20Basic
112  * @dev Simpler version of ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/179
114  */
115 contract ERC20Basic {
116   function totalSupply() public view returns (uint256);
117   function balanceOf(address who) public view returns (uint256);
118   function transfer(address to, uint256 value) public returns (bool);
119   event Transfer(address indexed from, address indexed to, uint256 value);
120 }
121 
122 /**
123  * @title Basic token
124  * @dev Basic version of StandardToken, with no allowances.
125  */
126 contract BasicToken is ERC20Basic {
127   using SafeMath for uint256;
128 
129   mapping(address => uint256) balances;
130 
131   uint256 totalSupply_;
132 
133   /**
134   * @dev total number of tokens in existence
135   */
136   function totalSupply() public view returns (uint256) {
137     return totalSupply_;
138   }
139 
140   /**
141   * @dev transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transfer(address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[msg.sender]);
148 
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     emit Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public view returns (uint256) {
161     return balances[_owner];
162   }
163 
164 }
165 
166 /**
167  * @title Burnable Token
168  * @dev Token that can be irreversibly burned (destroyed).
169  */
170 contract BurnableToken is BasicToken {
171 
172   event Burn(address indexed burner, uint256 value);
173 
174   /**
175    * @dev Burns a specific amount of tokens.
176    * @param _value The amount of token to be burned.
177    */
178   function burn(uint256 _value) public {
179     _burn(msg.sender, _value);
180   }
181 
182   function _burn(address _who, uint256 _value) internal {
183     require(_value <= balances[_who]);
184     // no need to require value <= totalSupply, since that would imply the
185     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
186 
187     balances[_who] = balances[_who].sub(_value);
188     totalSupply_ = totalSupply_.sub(_value);
189     emit Burn(_who, _value);
190     emit Transfer(_who, address(0), _value);
191   }
192 }
193 
194 /**
195  * @title ERC20 interface
196  * @dev see https://github.com/ethereum/EIPs/issues/20
197  */
198 contract ERC20 is ERC20Basic {
199   function allowance(address owner, address spender)
200     public view returns (uint256);
201 
202   function transferFrom(address from, address to, uint256 value)
203     public returns (bool);
204 
205   function approve(address spender, uint256 value) public returns (bool);
206   event Approval(
207     address indexed owner,
208     address indexed spender,
209     uint256 value
210   );
211 }
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * @dev https://github.com/ethereum/EIPs/issues/20
218  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  */
220 contract StandardToken is ERC20, BasicToken {
221 
222   mapping (address => mapping (address => uint256)) internal allowed;
223 
224 
225   /**
226    * @dev Transfer tokens from one address to another
227    * @param _from address The address which you want to send tokens from
228    * @param _to address The address which you want to transfer to
229    * @param _value uint256 the amount of tokens to be transferred
230    */
231   function transferFrom(
232     address _from,
233     address _to,
234     uint256 _value
235   )
236     public
237     returns (bool)
238   {
239     require(_to != address(0));
240     require(_value <= balances[_from]);
241     require(_value <= allowed[_from][msg.sender]);
242 
243     balances[_from] = balances[_from].sub(_value);
244     balances[_to] = balances[_to].add(_value);
245     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246     emit Transfer(_from, _to, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
252    *
253    * Beware that changing an allowance with this method brings the risk that someone may use both the old
254    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257    * @param _spender The address which will spend the funds.
258    * @param _value The amount of tokens to be spent.
259    */
260   function approve(address _spender, uint256 _value) public returns (bool) {
261     allowed[msg.sender][_spender] = _value;
262     emit Approval(msg.sender, _spender, _value);
263     return true;
264   }
265 
266   /**
267    * @dev Function to check the amount of tokens that an owner allowed to a spender.
268    * @param _owner address The address which owns the funds.
269    * @param _spender address The address which will spend the funds.
270    * @return A uint256 specifying the amount of tokens still available for the spender.
271    */
272   function allowance(
273     address _owner,
274     address _spender
275    )
276     public
277     view
278     returns (uint256)
279   {
280     return allowed[_owner][_spender];
281   }
282 
283   /**
284    * @dev Increase the amount of tokens that an owner allowed to a spender.
285    *
286    * approve should be called when allowed[_spender] == 0. To increment
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _addedValue The amount of tokens to increase the allowance by.
292    */
293   function increaseApproval(
294     address _spender,
295     uint _addedValue
296   )
297     public
298     returns (bool)
299   {
300     allowed[msg.sender][_spender] = (
301       allowed[msg.sender][_spender].add(_addedValue));
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306   /**
307    * @dev Decrease the amount of tokens that an owner allowed to a spender.
308    *
309    * approve should be called when allowed[_spender] == 0. To decrement
310    * allowed value is better to use this function to avoid 2 calls (and wait until
311    * the first transaction is mined)
312    * From MonolithDAO Token.sol
313    * @param _spender The address which will spend the funds.
314    * @param _subtractedValue The amount of tokens to decrease the allowance by.
315    */
316   function decreaseApproval(
317     address _spender,
318     uint _subtractedValue
319   )
320     public
321     returns (bool)
322   {
323     uint oldValue = allowed[msg.sender][_spender];
324     if (_subtractedValue > oldValue) {
325       allowed[msg.sender][_spender] = 0;
326     } else {
327       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
328     }
329     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332 
333 }
334 
335 /**
336  * @title CustomDealToken
337  * @author Aleksandar Djordjevic
338  * @dev CustomDealToken is ERC20 Ownable, BurnableToken & StandardToken
339  * It is meant to be used in a CustomDealToken Crowdsale contract
340  */
341 contract CustomDealToken is Ownable, BurnableToken, StandardToken {
342     string public constant name = 'Custom Deal Token'; // CDL name
343     string public constant symbol = 'CDL'; // CDL symbol
344     uint8 public constant decimals = 18; // CDL decimal number
345     uint256 public constant TOTAL_SUPPLY = 400000000 * (10 ** uint256(decimals)); // total amount of all CDL tokens - 400 000 000 CDL
346 
347     /**
348      * @dev CustomDealToken constructor
349      * Sets total supply and assigns total supply to the owner
350      */
351     constructor() public {
352         totalSupply_ = TOTAL_SUPPLY; // set total amount of tokens
353         balances[owner] = TOTAL_SUPPLY; // transfer all tokens to smart contract owner
354 
355         emit Transfer(address(0), owner, totalSupply_); // emit Transfer event and notify that transfer of tokens was made
356     }
357 }