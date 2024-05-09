1 pragma solidity ^0.4.23;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
113 
114 /**
115  * @title Burnable Token
116  * @dev Token that can be irreversibly burned (destroyed).
117  */
118 contract BurnableToken is BasicToken {
119 
120   event Burn(address indexed burner, uint256 value);
121 
122   /**
123    * @dev Burns a specific amount of tokens.
124    * @param _value The amount of token to be burned.
125    */
126   function burn(uint256 _value) public {
127     require(_value <= balances[msg.sender]);
128     // no need to require value <= totalSupply, since that would imply the
129     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
130 
131     address burner = msg.sender;
132     balances[burner] = balances[burner].sub(_value);
133     totalSupply_ = totalSupply_.sub(_value);
134     Burn(burner, _value);
135     Transfer(burner, address(0), _value);
136   }
137 }
138 
139 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
140 
141 /**
142  * @title Ownable
143  * @dev The Ownable contract has an owner address, and provides basic authorization control
144  * functions, this simplifies the implementation of "user permissions".
145  */
146 contract Ownable {
147   address public owner;
148 
149 
150   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152 
153   /**
154    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155    * account.
156    */
157   function Ownable() public {
158     owner = msg.sender;
159   }
160 
161   /**
162    * @dev Throws if called by any account other than the owner.
163    */
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address newOwner) public onlyOwner {
174     require(newOwner != address(0));
175     OwnershipTransferred(owner, newOwner);
176     owner = newOwner;
177   }
178 
179 }
180 
181 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
182 
183 /**
184  * @title ERC20 interface
185  * @dev see https://github.com/ethereum/EIPs/issues/20
186  */
187 contract ERC20 is ERC20Basic {
188   function allowance(address owner, address spender) public view returns (uint256);
189   function transferFrom(address from, address to, uint256 value) public returns (bool);
190   function approve(address spender, uint256 value) public returns (bool);
191   event Approval(address indexed owner, address indexed spender, uint256 value);
192 }
193 
194 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
195 
196 /**
197  * @title Standard ERC20 token
198  *
199  * @dev Implementation of the basic standard token.
200  * @dev https://github.com/ethereum/EIPs/issues/20
201  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
202  */
203 contract StandardToken is ERC20, BasicToken {
204 
205   mapping (address => mapping (address => uint256)) internal allowed;
206 
207 
208   /**
209    * @dev Transfer tokens from one address to another
210    * @param _from address The address which you want to send tokens from
211    * @param _to address The address which you want to transfer to
212    * @param _value uint256 the amount of tokens to be transferred
213    */
214   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
215     require(_to != address(0));
216     require(_value <= balances[_from]);
217     require(_value <= allowed[_from][msg.sender]);
218 
219     balances[_from] = balances[_from].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
222     Transfer(_from, _to, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228    *
229    * Beware that changing an allowance with this method brings the risk that someone may use both the old
230    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    * @param _spender The address which will spend the funds.
234    * @param _value The amount of tokens to be spent.
235    */
236   function approve(address _spender, uint256 _value) public returns (bool) {
237     allowed[msg.sender][_spender] = _value;
238     Approval(msg.sender, _spender, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Function to check the amount of tokens that an owner allowed to a spender.
244    * @param _owner address The address which owns the funds.
245    * @param _spender address The address which will spend the funds.
246    * @return A uint256 specifying the amount of tokens still available for the spender.
247    */
248   function allowance(address _owner, address _spender) public view returns (uint256) {
249     return allowed[_owner][_spender];
250   }
251 
252   /**
253    * @dev Increase the amount of tokens that an owner allowed to a spender.
254    *
255    * approve should be called when allowed[_spender] == 0. To increment
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param _spender The address which will spend the funds.
260    * @param _addedValue The amount of tokens to increase the allowance by.
261    */
262   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
263     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
264     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Decrease the amount of tokens that an owner allowed to a spender.
270    *
271    * approve should be called when allowed[_spender] == 0. To decrement
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _subtractedValue The amount of tokens to decrease the allowance by.
277    */
278   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
279     uint oldValue = allowed[msg.sender][_spender];
280     if (_subtractedValue > oldValue) {
281       allowed[msg.sender][_spender] = 0;
282     } else {
283       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
284     }
285     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286     return true;
287   }
288 
289 }
290 
291 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
292 
293 /**
294  * @title Mintable token
295  * @dev Simple ERC20 Token example, with mintable token creation
296  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
297  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
298  */
299 contract MintableToken is StandardToken, Ownable {
300   event Mint(address indexed to, uint256 amount);
301   event MintFinished();
302 
303   bool public mintingFinished = false;
304 
305 
306   modifier canMint() {
307     require(!mintingFinished);
308     _;
309   }
310 
311   /**
312    * @dev Function to mint tokens
313    * @param _to The address that will receive the minted tokens.
314    * @param _amount The amount of tokens to mint.
315    * @return A boolean that indicates if the operation was successful.
316    */
317   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
318     totalSupply_ = totalSupply_.add(_amount);
319     balances[_to] = balances[_to].add(_amount);
320     Mint(_to, _amount);
321     Transfer(address(0), _to, _amount);
322     return true;
323   }
324 
325   /**
326    * @dev Function to stop minting new tokens.
327    * @return True if the operation was successful.
328    */
329   function finishMinting() onlyOwner canMint public returns (bool) {
330     mintingFinished = true;
331     MintFinished();
332     return true;
333   }
334 }
335 
336 // File: contracts/LDCMintableToken.sol
337 
338 contract LDCMintableCoin is MintableToken, BurnableToken {
339 
340   string public constant name = "LORDLESS COIN"; // solium-disable-line uppercase
341   string public constant symbol = "LDC"; // solium-disable-line uppercase
342   uint8 public constant decimals = 18; // solium-disable-line uppercase
343 
344 }