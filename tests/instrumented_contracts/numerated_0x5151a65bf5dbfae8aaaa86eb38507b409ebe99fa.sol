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
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84   uint256 totalSupply_;
85 
86   /**
87   * @dev total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     // SafeMath.sub will throw if there is not enough balance.
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
114   function balanceOf(address _owner) public view returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 /**
121  * @title Standard ERC20 token
122  *
123  * @dev Implementation of the basic standard token.
124  * @dev https://github.com/ethereum/EIPs/issues/20
125  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
126  */
127 contract StandardToken is ERC20, BasicToken {
128 
129   mapping (address => mapping (address => uint256)) internal allowed;
130 
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint256 the amount of tokens to be transferred
137    */
138   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[_from]);
141     require(_value <= allowed[_from][msg.sender]);
142 
143     balances[_from] = balances[_from].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146     emit Transfer(_from, _to, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152    *
153    * Beware that changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint256 _value) public returns (bool) {
161     allowed[msg.sender][_spender] = _value;
162     emit Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifying the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) public view returns (uint256) {
173     return allowed[_owner][_spender];
174   }
175 
176   /**
177    * @dev Increase the amount of tokens that an owner allowed to a spender.
178    *
179    * approve should be called when allowed[_spender] == 0. To increment
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    * @param _spender The address which will spend the funds.
184    * @param _addedValue The amount of tokens to increase the allowance by.
185    */
186   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
187     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   /**
193    * @dev Decrease the amount of tokens that an owner allowed to a spender.
194    *
195    * approve should be called when allowed[_spender] == 0. To decrement
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _subtractedValue The amount of tokens to decrease the allowance by.
201    */
202   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
203     uint oldValue = allowed[msg.sender][_spender];
204     if (_subtractedValue > oldValue) {
205       allowed[msg.sender][_spender] = 0;
206     } else {
207       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208     }
209     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213 }
214 
215 /**
216  * @title Ownable
217  * @dev The Ownable contract has an owner address, and provides basic authorization control
218  * functions, this simplifies the implementation of "user permissions".
219  */
220 contract Ownable {
221   address public owner;
222 
223 
224   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226 
227   /**
228    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
229    * account.
230    */
231   constructor() public {
232     owner = msg.sender;
233   }
234 
235   /**
236    * @dev Throws if called by any account other than the owner.
237    */
238   modifier onlyOwner() {
239     require(msg.sender == owner);
240     _;
241   }
242 
243   /**
244    * @dev Allows the current owner to transfer control of the contract to a newOwner.
245    * @param newOwner The address to transfer ownership to.
246    */
247   function transferOwnership(address newOwner) public onlyOwner {
248     require(newOwner != address(0));
249     emit OwnershipTransferred(owner, newOwner);
250     owner = newOwner;
251   }
252 
253 }
254 
255 
256 
257 /**
258  * @title Mintable token
259  * @dev Simple ERC20 Token example, with mintable token creation
260  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
261  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
262  */
263 contract MintableToken is StandardToken, Ownable {
264   event Mint(address indexed to, uint256 amount);
265   event MintFinished();
266 
267   bool public mintingFinished = false;
268 
269 
270   modifier canMint() {
271     require(!mintingFinished);
272     _;
273   }
274 
275   /**
276    * @dev Function to mint tokens
277    * @param _to The address that will receive the minted tokens.
278    * @param _amount The amount of tokens to mint.
279    * @return A boolean that indicates if the operation was successful.
280    */
281   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
282     totalSupply_ = totalSupply_.add(_amount);
283     balances[_to] = balances[_to].add(_amount);
284     emit Mint(_to, _amount);
285     emit Transfer(address(0), _to, _amount);
286     return true;
287   }
288 
289   /**
290    * @dev Function to stop minting new tokens.
291    * @return True if the operation was successful.
292    */
293   function finishMinting() onlyOwner canMint public returns (bool) {
294     mintingFinished = true;
295     emit MintFinished();
296     return true;
297   }
298 }
299 
300 
301 contract CappedToken is MintableToken {
302 
303   uint256 public cap;
304 
305   constructor(uint256 _cap) public {
306     require(_cap > 0);
307     cap = _cap;
308   }
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will receive the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
317     require(totalSupply_.add(_amount) <= cap);
318 
319     return super.mint(_to, _amount);
320   }
321 
322 }
323 
324 contract FrieseCoin is CappedToken {
325   string public name = "FrieseCoin";
326   string public symbol = "FRBC";
327   uint8 public decimals = 18;
328   constructor(uint256 _cap) public
329     CappedToken(_cap){
330 
331   }
332 }