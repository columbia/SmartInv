1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 // File: zeppelin-solidity/contracts/token/BasicToken.sol
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[msg.sender]);
71 
72     // SafeMath.sub will throw if there is not enough balance.
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address.
81   * @param _owner The address to query the the balance of.
82   * @return An uint256 representing the amount owned by the passed address.
83   */
84   function balanceOf(address _owner) public view returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
91 
92 /**
93  * @title Burnable Token
94  * @dev Token that can be irreversibly burned (destroyed).
95  */
96 contract BurnableToken is BasicToken {
97 
98     event Burn(address indexed burner, uint256 value);
99 
100     /**
101      * @dev Burns a specific amount of tokens.
102      * @param _value The amount of token to be burned.
103      */
104     function burn(uint256 _value) public {
105         require(_value <= balances[msg.sender]);
106         // no need to require value <= totalSupply, since that would imply the
107         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
108 
109         address burner = msg.sender;
110         balances[burner] = balances[burner].sub(_value);
111         totalSupply = totalSupply.sub(_value);
112         Burn(burner, _value);
113 		Transfer(burner, address(0), _value);
114     }
115 }
116 
117 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
118 
119 /**
120  * @title Ownable
121  * @dev The Ownable contract has an owner address, and provides basic authorization control
122  * functions, this simplifies the implementation of "user permissions".
123  */
124 contract Ownable {
125   address public owner;
126 
127 
128   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130 
131   /**
132    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
133    * account.
134    */
135   function Ownable() public {
136     owner = msg.sender;
137   }
138 
139 
140   /**
141    * @dev Throws if called by any account other than the owner.
142    */
143   modifier onlyOwner() {
144     require(msg.sender == owner);
145     _;
146   }
147 
148 
149   /**
150    * @dev Allows the current owner to transfer control of the contract to a newOwner.
151    * @param newOwner The address to transfer ownership to.
152    */
153   function transferOwnership(address newOwner) public onlyOwner {
154     require(newOwner != address(0));
155     OwnershipTransferred(owner, newOwner);
156     owner = newOwner;
157   }
158 
159 }
160 
161 // File: zeppelin-solidity/contracts/token/ERC20.sol
162 
163 /**
164  * @title ERC20 interface
165  * @dev see https://github.com/ethereum/EIPs/issues/20
166  */
167 contract ERC20 is ERC20Basic {
168   function allowance(address owner, address spender) public view returns (uint256);
169   function transferFrom(address from, address to, uint256 value) public returns (bool);
170   function approve(address spender, uint256 value) public returns (bool);
171   event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 // File: zeppelin-solidity/contracts/token/StandardToken.sol
175 
176 /**
177  * @title Standard ERC20 token
178  *
179  * @dev Implementation of the basic standard token.
180  * @dev https://github.com/ethereum/EIPs/issues/20
181  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182  */
183 contract StandardToken is ERC20, BasicToken {
184 
185   mapping (address => mapping (address => uint256)) internal allowed;
186 
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
195     require(_to != address(0));
196     require(_value <= balances[_from]);
197     require(_value <= allowed[_from][msg.sender]);
198 
199     balances[_from] = balances[_from].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202     Transfer(_from, _to, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    *
209    * Beware that changing an allowance with this method brings the risk that someone may use both the old
210    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
211    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
212    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213    * @param _spender The address which will spend the funds.
214    * @param _value The amount of tokens to be spent.
215    */
216   function approve(address _spender, uint256 _value) public returns (bool) {
217     allowed[msg.sender][_spender] = _value;
218     Approval(msg.sender, _spender, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Function to check the amount of tokens that an owner allowed to a spender.
224    * @param _owner address The address which owns the funds.
225    * @param _spender address The address which will spend the funds.
226    * @return A uint256 specifying the amount of tokens still available for the spender.
227    */
228   function allowance(address _owner, address _spender) public view returns (uint256) {
229     return allowed[_owner][_spender];
230   }
231 
232   /**
233    * @dev Increase the amount of tokens that an owner allowed to a spender.
234    *
235    * approve should be called when allowed[_spender] == 0. To increment
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param _spender The address which will spend the funds.
240    * @param _addedValue The amount of tokens to increase the allowance by.
241    */
242   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
243     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
244     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248   /**
249    * @dev Decrease the amount of tokens that an owner allowed to a spender.
250    *
251    * approve should be called when allowed[_spender] == 0. To decrement
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _subtractedValue The amount of tokens to decrease the allowance by.
257    */
258   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
259     uint oldValue = allowed[msg.sender][_spender];
260     if (_subtractedValue > oldValue) {
261       allowed[msg.sender][_spender] = 0;
262     } else {
263       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264     }
265     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269 }
270 
271 // File: zeppelin-solidity/contracts/token/MintableToken.sol
272 
273 /**
274  * @title Mintable token
275  * @dev Simple ERC20 Token example, with mintable token creation
276  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
277  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
278  */
279 
280 contract MintableToken is StandardToken, Ownable {
281   event Mint(address indexed to, uint256 amount);
282   event MintFinished();
283 
284   bool public mintingFinished = false;
285 
286 
287   modifier canMint() {
288     require(!mintingFinished);
289     _;
290   }
291 
292   /**
293    * @dev Function to mint tokens
294    * @param _to The address that will receive the minted tokens.
295    * @param _amount The amount of tokens to mint.
296    * @return A boolean that indicates if the operation was successful.
297    */
298   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
299     totalSupply = totalSupply.add(_amount);
300     balances[_to] = balances[_to].add(_amount);
301     Mint(_to, _amount);
302     Transfer(address(0), _to, _amount);
303     return true;
304   }
305 
306   /**
307    * @dev Function to stop minting new tokens.
308    * @return True if the operation was successful.
309    */
310   function finishMinting() onlyOwner canMint public returns (bool) {
311     mintingFinished = true;
312     MintFinished();
313     return true;
314   }
315 }
316 
317 // File: contracts/GeneralToken.sol
318 
319 contract GeneralToken is MintableToken, BurnableToken {
320 	string public name = "WalletPlusX";
321 	string public symbol = "WPX";
322 	uint8 public decimals = 18;
323 
324 	function GeneralToken(string _name, string _symbol, uint8 _decimals) public {
325 		name = _name;
326 		symbol = _symbol;
327 		decimals = _decimals;
328 	}
329 
330 	function burn(address burner, uint256 _value) public onlyOwner {
331 	    require(_value <= balances[burner]);
332 	    // no need to require value <= totalSupply, since that would imply the
333 	    // sender's balance is greater than the totalSupply, which *should* be an assertion failure
334 
335 	    balances[burner] = balances[burner].sub(_value);
336 	    totalSupply = totalSupply.sub(_value);
337 	    Burn(burner, _value);
338 	}
339 
340 }