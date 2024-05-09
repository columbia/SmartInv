1 pragma solidity ^0.4.18;
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
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public view returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 
76 
77 /**
78  * @title Ownable
79  * @dev The Ownable contract has an owner address, and provides basic authorization control
80  * functions, this simplifies the implementation of "user permissions".
81  */
82 contract Ownable {
83   address public owner;
84 
85 
86   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88 
89   /**
90    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91    * account.
92    */
93   function Ownable() public {
94     owner = msg.sender;
95   }
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(msg.sender == owner);
102     _;
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address newOwner) public onlyOwner {
110     require(newOwner != address(0));
111     OwnershipTransferred(owner, newOwner);
112     owner = newOwner;
113   }
114 
115 }
116 
117 
118 
119 /**
120  * @title Basic token
121  * @dev Basic version of StandardToken, with no allowances.
122  */
123 contract BasicToken is ERC20Basic {
124   using SafeMath for uint256;
125 
126   mapping(address => uint256) balances;
127 
128   uint256 totalSupply_;
129 
130   /**
131   * @dev total number of tokens in existence
132   */
133   function totalSupply() public view returns (uint256) {
134     return totalSupply_;
135   }
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145 
146     // SafeMath.sub will throw if there is not enough balance.
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 
165 /**
166  * @title Standard ERC20 token
167  *
168  * @dev Implementation of the basic standard token.
169  * @dev https://github.com/ethereum/EIPs/issues/20
170  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
171  */
172 contract StandardToken is ERC20, BasicToken {
173 
174   mapping (address => mapping (address => uint256)) internal allowed;
175 
176 
177   /**
178    * @dev Transfer tokens from one address to another
179    * @param _from address The address which you want to send tokens from
180    * @param _to address The address which you want to transfer to
181    * @param _value uint256 the amount of tokens to be transferred
182    */
183   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
184     require(_to != address(0));
185     require(_value <= balances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    *
198    * Beware that changing an allowance with this method brings the risk that someone may use both the old
199    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202    * @param _spender The address which will spend the funds.
203    * @param _value The amount of tokens to be spent.
204    */
205   function approve(address _spender, uint256 _value) public returns (bool) {
206     allowed[msg.sender][_spender] = _value;
207     Approval(msg.sender, _spender, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens that an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint256 specifying the amount of tokens still available for the spender.
216    */
217   function allowance(address _owner, address _spender) public view returns (uint256) {
218     return allowed[_owner][_spender];
219   }
220 
221   /**
222    * @dev Increase the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To increment
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _addedValue The amount of tokens to increase the allowance by.
230    */
231   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
232     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
233     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237   /**
238    * @dev Decrease the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To decrement
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param _spender The address which will spend the funds.
245    * @param _subtractedValue The amount of tokens to decrease the allowance by.
246    */
247   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
248     uint oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue > oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 }
259 
260 
261 /**
262  * @title Mintable token
263  * @dev Simple ERC20 Token example, with mintable token creation
264  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
265  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
266  */
267 contract MintableToken is StandardToken, Ownable {
268   event Mint(address indexed to, uint256 amount);
269   event MintFinished();
270 
271   bool public mintingFinished = false;
272 
273 
274   modifier canMint() {
275     require(!mintingFinished);
276     _;
277   }
278 
279   /**
280    * @dev Function to mint tokens
281    * @param _to The address that will receive the minted tokens.
282    * @param _amount The amount of tokens to mint.
283    * @return A boolean that indicates if the operation was successful.
284    */
285   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
286     totalSupply_ = totalSupply_.add(_amount);
287     balances[_to] = balances[_to].add(_amount);
288     Mint(_to, _amount);
289     Transfer(address(0), _to, _amount);
290     return true;
291   }
292 
293   /**
294    * @dev Function to stop minting new tokens.
295    * @return True if the operation was successful.
296    */
297   function finishMinting() onlyOwner canMint public returns (bool) {
298     mintingFinished = true;
299     MintFinished();
300     return true;
301   }
302 }
303 
304 
305 /**
306  * @title SampleCrowdsaleToken
307  * @dev Very simple ERC20 Token that can be minted.
308  * It is meant to be used in a crowdsale contract.
309  */
310 contract PibbleToken is MintableToken {
311 
312   string public constant name = "Pibble Token"; // solium-disable-line uppercase
313   string public constant symbol = "PIB"; // solium-disable-line uppercase
314   uint8 public constant decimals = 18; // solium-disable-line uppercase
315 
316   uint256 public constant INITIAL_SUPPLY = (10*1000*1000*1000) * (10 ** uint256(decimals)); // 10 billion coin
317 
318   event Burn(address indexed burner, uint256 value);
319 
320   /**
321    * @dev Constructor that gives msg.sender all of existing tokens.
322    */
323   function PibbleToken() public {
324     totalSupply_ = INITIAL_SUPPLY;
325     balances[msg.sender] = INITIAL_SUPPLY;
326     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
327   }
328 
329 
330   /**
331    * @dev Burns a specific amount of tokens.
332    * @param _value The amount of token to be burned.
333    */
334   function burn(uint256 _value) public {
335     require(_value <= balances[msg.sender]);
336 
337     address burner = msg.sender;
338     balances[burner] = balances[burner].sub(_value);
339     totalSupply_ = totalSupply_.sub(_value);
340     Burn(burner, _value);
341   }
342 
343 }