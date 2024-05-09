1 pragma solidity ^0.4.19;
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
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
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
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   uint256 totalSupply_;
83 
84   /**
85   * @dev total number of tokens in existence
86   */
87   function totalSupply() public view returns (uint256) {
88     return totalSupply_;
89   }
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98     require(_value <= balances[msg.sender]);
99 
100     // SafeMath.sub will throw if there is not enough balance.
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint256 representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) public view returns (uint256 balance) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 /**
119  * @title Burnable Token
120  * @dev Token that can be irreversibly burned (destroyed).
121  */
122 contract BurnableToken is BasicToken {
123 
124   event Burn(address indexed burner, uint256 value);
125 
126   /**
127    * @dev Burns a specific amount of tokens.
128    * @param _value The amount of token to be burned.
129    */
130   function burn(uint256 _value) public {
131     require(_value <= balances[msg.sender]);
132     // no need to require value <= totalSupply, since that would imply the
133     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
134 
135     address burner = msg.sender;
136     balances[burner] = balances[burner].sub(_value);
137     totalSupply_ = totalSupply_.sub(_value);
138     Burn(burner, _value);
139   }
140 }
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * @dev https://github.com/ethereum/EIPs/issues/20
147  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is ERC20, BasicToken, BurnableToken {
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
160   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
161     require(_to != address(0));
162     require(_value <= balances[_from]);
163     require(_value <= allowed[_from][msg.sender]);
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168     Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    *
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(address _owner, address _spender) public view returns (uint256) {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
209     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
210     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214   /**
215    * @dev Decrease the amount of tokens that an owner allowed to a spender.
216    *
217    * approve should be called when allowed[_spender] == 0. To decrement
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _subtractedValue The amount of tokens to decrease the allowance by.
223    */
224   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
225     uint oldValue = allowed[msg.sender][_spender];
226     if (_subtractedValue > oldValue) {
227       allowed[msg.sender][_spender] = 0;
228     } else {
229       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
230     }
231     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235 }
236 
237 /**
238  * @title Ownable
239  * @dev The Ownable contract has an owner address, and provides basic authorization control
240  * functions, this simplifies the implementation of "user permissions".
241  */
242 contract Ownable {
243   address public owner;
244 
245 
246   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
247 
248 
249   /**
250    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
251    * account.
252    */
253   function Ownable() public {
254     owner = msg.sender;
255   }
256 
257   /**
258    * @dev Throws if called by any account other than the owner.
259    */
260   modifier onlyOwner() {
261     require(msg.sender == owner);
262     _;
263   }
264 
265   /**
266    * @dev Allows the current owner to transfer control of the contract to a newOwner.
267    * @param newOwner The address to transfer ownership to.
268    */
269   function transferOwnership(address newOwner) public onlyOwner {
270     require(newOwner != address(0));
271     OwnershipTransferred(owner, newOwner);
272     owner = newOwner;
273   }
274 
275 }
276 
277 /**
278  * @title Mintable token
279  * @dev Simple ERC20 Token example, with mintable token creation
280  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
281  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
282  */
283 
284 contract MintableToken is StandardToken, Ownable {
285   event Mint(address indexed to, uint256 amount);
286   event MintFinished();
287 
288   bool public mintingFinished = false;
289 
290 
291   modifier canMint() {
292     require(!mintingFinished);
293     _;
294   }
295 
296   /**
297    * @dev Function to mint tokens
298    * @param _to The address that will receive the minted tokens.
299    * @param _amount The amount of tokens to mint.
300    * @return A boolean that indicates if the operation was successful.
301    */
302   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
303     totalSupply_ = totalSupply_.add(_amount);
304     balances[_to] = balances[_to].add(_amount);
305     Mint(_to, _amount);
306     Transfer(address(0), _to, _amount);
307     return true;
308   }
309 
310   /**
311    * @dev Function to stop minting new tokens.
312    * @return True if the operation was successful.
313    */
314   function finishMinting() onlyOwner canMint public returns (bool) {
315     mintingFinished = true;
316     MintFinished();
317     return true;
318   }
319 }
320 
321 contract BitcoinBlack is StandardToken, MintableToken {
322 
323   string public constant name = "Bitcoin Black"; // solium-disable-line uppercase
324   string public constant symbol = "BLACK"; // solium-disable-line uppercase
325   uint8 public constant decimals = 18; // solium-disable-line uppercase
326 
327   uint256 public constant INITIAL_SUPPLY = 21000000 * (10 ** uint256(decimals));
328 
329   /**
330    * @dev Constructor that gives msg.sender all of existing tokens.
331    */
332   function BitcoinBlack() public {
333     totalSupply_ = INITIAL_SUPPLY;
334     balances[msg.sender] = INITIAL_SUPPLY;
335     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
336   }
337 
338 }