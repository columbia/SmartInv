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
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
53     if (a == 0) {
54       return 0;
55     }
56     c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     // uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return a / b;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public view returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) balances;
120 
121   uint256 totalSupply_;
122 
123   /**
124   * @dev total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     emit Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256) {
151     return balances[_owner];
152   }
153 
154 }
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[_from]);
177     require(_value <= allowed[_from][msg.sender]);
178 
179     balances[_from] = balances[_from].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182     emit Transfer(_from, _to, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188    *
189    * Beware that changing an allowance with this method brings the risk that someone may use both the old
190    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _value) public returns (bool) {
197     allowed[msg.sender][_spender] = _value;
198     emit Approval(msg.sender, _spender, _value);
199     return true;
200   }
201 
202   /**
203    * @dev Function to check the amount of tokens that an owner allowed to a spender.
204    * @param _owner address The address which owns the funds.
205    * @param _spender address The address which will spend the funds.
206    * @return A uint256 specifying the amount of tokens still available for the spender.
207    */
208   function allowance(address _owner, address _spender) public view returns (uint256) {
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
222   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
239     uint oldValue = allowed[msg.sender][_spender];
240     if (_subtractedValue > oldValue) {
241       allowed[msg.sender][_spender] = 0;
242     } else {
243       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244     }
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249 }
250 
251 /**
252  * @title Mintable token
253  * @dev Simple ERC20 Token example, with mintable token creation
254  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
255  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
256  */
257 contract MintableToken is StandardToken, Ownable {
258   event Mint(address indexed to, uint256 amount);
259   event MintFinished();
260 
261   bool public mintingFinished = false;
262 
263 
264   modifier canMint() {
265     require(!mintingFinished);
266     _;
267   }
268 
269   /**
270    * @dev Function to mint tokens
271    * @param _to The address that will receive the minted tokens.
272    * @param _amount The amount of tokens to mint.
273    * @return A boolean that indicates if the operation was successful.
274    */
275   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
276     totalSupply_ = totalSupply_.add(_amount);
277     balances[_to] = balances[_to].add(_amount);
278     emit Mint(_to, _amount);
279     emit Transfer(address(0), _to, _amount);
280     return true;
281   }
282 
283   /**
284    * @dev Function to stop minting new tokens.
285    * @return True if the operation was successful.
286    */
287   function finishMinting() onlyOwner canMint public returns (bool) {
288     mintingFinished = true;
289     emit MintFinished();
290     return true;
291   }
292 }
293 
294 /**
295  * @title Burnable Token
296  * @dev Token that can be irreversibly burned (destroyed).
297  */
298 contract BurnableToken is BasicToken {
299 
300   event Burn(address indexed burner, uint256 value);
301 
302   /**
303    * @dev Burns a specific amount of tokens.
304    * @param _value The amount of token to be burned.
305    */
306   function burn(uint256 _value) public {
307     _burn(msg.sender, _value);
308   }
309 
310   function _burn(address _who, uint256 _value) internal {
311     require(_value <= balances[_who]);
312     // no need to require value <= totalSupply, since that would imply the
313     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
314 
315     balances[_who] = balances[_who].sub(_value);
316     totalSupply_ = totalSupply_.sub(_value);
317     emit Burn(_who, _value);
318     emit Transfer(_who, address(0), _value);
319   }
320 }
321 
322 contract XRT is MintableToken, BurnableToken {
323     string public constant name     = "Robonomics Alpha";
324     string public constant symbol   = "XRT";
325     uint   public constant decimals = 9;
326 
327     uint256 public constant INITIAL_SUPPLY = 5 * (10 ** uint256(decimals));
328 
329     constructor() public {
330         totalSupply_ = INITIAL_SUPPLY;
331         balances[msg.sender] = INITIAL_SUPPLY;
332         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
333     }
334 }