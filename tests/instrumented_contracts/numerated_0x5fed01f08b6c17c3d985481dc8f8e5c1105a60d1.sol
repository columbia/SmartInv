1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     emit OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 /**
71  * @title SafeMath
72  * @dev Math operations with safety checks that throw on error
73  */
74 library SafeMath {
75 
76   /**
77   * @dev Multiplies two numbers, throws on overflow.
78   */
79   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
80     if (a == 0) {
81       return 0;
82     }
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return a / b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 
117 
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122 contract BasicToken is ERC20Basic {
123   using SafeMath for uint256;
124 
125   mapping(address => uint256) balances;
126 
127   uint256 totalSupply_;
128 
129   /**
130   * @dev total number of tokens in existence
131   */
132   function totalSupply() public view returns (uint256) {
133     return totalSupply_;
134   }
135 
136   /**
137   * @dev transfer token for a specified address
138   * @param _to The address to transfer to.
139   * @param _value The amount to be transferred.
140   */
141   function transfer(address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[msg.sender]);
144 
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     emit Transfer(msg.sender, _to, _value);
148     return true;
149   }
150 
151   /**
152   * @dev Gets the balance of the specified address.
153   * @param _owner The address to query the the balance of.
154   * @return An uint256 representing the amount owned by the passed address.
155   */
156   function balanceOf(address _owner) public view returns (uint256) {
157     return balances[_owner];
158   }
159 
160 }
161 
162 
163 
164 
165 
166 
167 /**
168  * @title ERC20 interface
169  * @dev see https://github.com/ethereum/EIPs/issues/20
170  */
171 contract ERC20 is ERC20Basic {
172   function allowance(address owner, address spender) public view returns (uint256);
173   function transferFrom(address from, address to, uint256 value) public returns (bool);
174   function approve(address spender, uint256 value) public returns (bool);
175   event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 
179 
180 /**
181  * @title Standard ERC20 token
182  *
183  * @dev Implementation of the basic standard token.
184  * @dev https://github.com/ethereum/EIPs/issues/20
185  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
186  */
187 contract StandardToken is ERC20, BasicToken {
188 
189   mapping (address => mapping (address => uint256)) internal allowed;
190 
191 
192   /**
193    * @dev Transfer tokens from one address to another
194    * @param _from address The address which you want to send tokens from
195    * @param _to address The address which you want to transfer to
196    * @param _value uint256 the amount of tokens to be transferred
197    */
198   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
199     require(_to != address(0));
200     require(_value <= balances[_from]);
201     require(_value <= allowed[_from][msg.sender]);
202 
203     balances[_from] = balances[_from].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
206     emit Transfer(_from, _to, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212    *
213    * Beware that changing an allowance with this method brings the risk that someone may use both the old
214    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
215    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
216    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217    * @param _spender The address which will spend the funds.
218    * @param _value The amount of tokens to be spent.
219    */
220   function approve(address _spender, uint256 _value) public returns (bool) {
221     allowed[msg.sender][_spender] = _value;
222     emit Approval(msg.sender, _spender, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Function to check the amount of tokens that an owner allowed to a spender.
228    * @param _owner address The address which owns the funds.
229    * @param _spender address The address which will spend the funds.
230    * @return A uint256 specifying the amount of tokens still available for the spender.
231    */
232   function allowance(address _owner, address _spender) public view returns (uint256) {
233     return allowed[_owner][_spender];
234   }
235 
236   /**
237    * @dev Increase the amount of tokens that an owner allowed to a spender.
238    *
239    * approve should be called when allowed[_spender] == 0. To increment
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _addedValue The amount of tokens to increase the allowance by.
245    */
246   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
247     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252   /**
253    * @dev Decrease the amount of tokens that an owner allowed to a spender.
254    *
255    * approve should be called when allowed[_spender] == 0. To decrement
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param _spender The address which will spend the funds.
260    * @param _subtractedValue The amount of tokens to decrease the allowance by.
261    */
262   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
263     uint oldValue = allowed[msg.sender][_spender];
264     if (_subtractedValue > oldValue) {
265       allowed[msg.sender][_spender] = 0;
266     } else {
267       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268     }
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273 }
274 
275 
276 
277 
278 /**
279  * @title Mintable token
280  * @dev Simple ERC20 Token example, with mintable token creation
281  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
282  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
283  */
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
305     emit Mint(_to, _amount);
306     emit Transfer(address(0), _to, _amount);
307     return true;
308   }
309 
310   /**
311    * @dev Function to stop minting new tokens.
312    * @return True if the operation was successful.
313    */
314   function finishMinting() onlyOwner canMint public returns (bool) {
315     mintingFinished = true;
316     emit MintFinished();
317     return true;
318   }
319 }
320 
321 
322 contract AAToken is MintableToken{
323     string public constant name = "AAToken";
324     string public constant symbol = "AAT";
325     uint8 public constant decimals = 18;
326 }