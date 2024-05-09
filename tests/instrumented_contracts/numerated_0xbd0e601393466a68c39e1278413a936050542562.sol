1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
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
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     emit Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128   mapping (address => mapping (address => uint256)) internal allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     emit Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     emit Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public view returns (uint256) {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * @dev Increase the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191   /**
192    * @dev Decrease the amount of tokens that an owner allowed to a spender.
193    *
194    * approve should be called when allowed[_spender] == 0. To decrement
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212 }
213 
214 
215 
216 /**
217  * @title Burnable Token
218  * @dev Token that can be irreversibly burned (destroyed).
219  */
220 contract BurnableToken is BasicToken {
221 
222   event Burn(address indexed burner, uint256 value);
223 
224   /**
225    * @dev Burns a specific amount of tokens.
226    * @param _value The amount of token to be burned.
227    */
228   function burn(uint256 _value) public {
229     _burn(msg.sender, _value);
230   }
231 
232   function _burn(address _who, uint256 _value) internal {
233     require(_value <= balances[_who]);
234     // no need to require value <= totalSupply, since that would imply the
235     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
236 
237     balances[_who] = balances[_who].sub(_value);
238     totalSupply_ = totalSupply_.sub(_value);
239     emit Burn(_who, _value);
240     emit Transfer(_who, address(0), _value);
241   }
242 }
243 
244 
245 /**
246  * @title Standard Burnable Token
247  * @dev Adds burnFrom method to ERC20 implementations
248  */
249 contract StandardBurnableToken is BurnableToken, StandardToken {
250 
251   /**
252    * @dev Burns a specific amount of tokens from the target address and decrements allowance
253    * @param _from address The address which you want to send tokens from
254    * @param _value uint256 The amount of token to be burned
255    */
256   function burnFrom(address _from, uint256 _value) public {
257     require(_value <= allowed[_from][msg.sender]);
258     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
259     // this function needs to emit an event with the updated approval.
260     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
261     _burn(_from, _value);
262   }
263 }
264 
265 /**
266  * @title Ownable
267  * @dev The Ownable contract has an owner address, and provides basic authorization control
268  * functions, this simplifies the implementation of "user permissions".
269  */
270 contract Ownable {
271   address public owner;
272 
273 
274   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276 
277   /**
278    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
279    * account.
280    */
281   function Ownable() public {
282     owner = msg.sender;
283   }
284 
285   /**
286    * @dev Throws if called by any account other than the owner.
287    */
288   modifier onlyOwner() {
289     require(msg.sender == owner);
290     _;
291   }
292 
293   /**
294    * @dev Allows the current owner to transfer control of the contract to a newOwner.
295    * @param newOwner The address to transfer ownership to.
296    */
297   function transferOwnership(address newOwner) public onlyOwner {
298     require(newOwner != address(0));
299     emit OwnershipTransferred(owner, newOwner);
300     owner = newOwner;
301   }
302 
303 }
304 
305 contract CBO is StandardBurnableToken, Ownable {
306   string public name = "CBO";
307   string public symbol = "CBO";
308   uint8 public decimals = 8;
309   uint256 public INITIAL_SUPPLY = 100000000000000000;
310 
311   address public owner;
312 
313   function CBO() public {
314     totalSupply_ = INITIAL_SUPPLY;
315     balances[msg.sender] = INITIAL_SUPPLY;
316     owner = msg.sender;
317   }
318 }