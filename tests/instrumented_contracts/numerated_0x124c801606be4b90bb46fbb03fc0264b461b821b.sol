1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     if (a == 0) {
26       return 0;
27     }
28     c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     // uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return a / b;
41   }
42 
43   /**
44   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   uint256 totalSupply_;
71 
72   /**
73   * @dev total number of tokens in existence
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalSupply_;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     balances[msg.sender] = balances[msg.sender].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     emit Transfer(msg.sender, _to, _value);
91     return true;
92   }
93 
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint256 representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) public view returns (uint256) {
100     return balances[_owner];
101   }
102 
103 }
104 
105 /**
106  * @title Burnable Token
107  * @dev Token that can be irreversibly burned (destroyed).
108  */
109 contract BurnableToken is BasicToken {
110 
111   event Burn(address indexed burner, uint256 value);
112 
113   /**
114    * @dev Burns a specific amount of tokens.
115    * @param _value The amount of token to be burned.
116    */
117   function burn(uint256 _value) public {
118     _burn(msg.sender, _value);
119   }
120 
121   function _burn(address _who, uint256 _value) internal {
122     require(_value <= balances[_who]);
123     // no need to require value <= totalSupply, since that would imply the
124     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
125 
126     balances[_who] = balances[_who].sub(_value);
127     totalSupply_ = totalSupply_.sub(_value);
128     emit Burn(_who, _value);
129     emit Transfer(_who, address(0), _value);
130   }
131 }
132 
133 /**
134  * @title ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/20
136  */
137 contract ERC20 is ERC20Basic {
138   function allowance(address owner, address spender) public view returns (uint256);
139   function transferFrom(address from, address to, uint256 value) public returns (bool);
140   function approve(address spender, uint256 value) public returns (bool);
141   event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     emit Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * @dev Increase the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
211     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   /**
217    * @dev Decrease the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
227     uint oldValue = allowed[msg.sender][_spender];
228     if (_subtractedValue > oldValue) {
229       allowed[msg.sender][_spender] = 0;
230     } else {
231       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232     }
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237 }
238 
239 /**
240  * @title Ownable
241  * @dev The Ownable contract has an owner address, and provides basic authorization control
242  * functions, this simplifies the implementation of "user permissions".
243  */
244 contract Ownable {
245   address public owner;
246 
247 
248   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
249 
250 
251   /**
252    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
253    * account.
254    */
255   function Ownable() public {
256     owner = msg.sender;
257   }
258 
259   /**
260    * @dev Throws if called by any account other than the owner.
261    */
262   modifier onlyOwner() {
263     require(msg.sender == owner);
264     _;
265   }
266 
267   /**
268    * @dev Allows the current owner to transfer control of the contract to a newOwner.
269    * @param newOwner The address to transfer ownership to.
270    */
271   function transferOwnership(address newOwner) public onlyOwner {
272     require(newOwner != address(0));
273     emit OwnershipTransferred(owner, newOwner);
274     owner = newOwner;
275   }
276 
277 }
278 
279 contract Karma20 is StandardToken, BurnableToken, Ownable {
280   string public constant name = "Karma";
281   string public constant symbol = "KRM";
282   uint32 public constant decimals = 5;
283 
284   address public saleAgent;
285 
286   event Mint(address indexed to, uint256 amount);
287 
288   modifier onlyAgent() {
289     require (saleAgent == msg.sender); 
290     _;
291   }
292 
293   function setSaleAgent(address agent) public onlyOwner {
294     require (agent != address(0));
295     saleAgent = agent;
296   }
297 
298   function mint(address _to, uint256 _amount) onlyAgent public returns (bool) {
299     totalSupply_ = totalSupply_.add(_amount);
300     balances[_to] = balances[_to].add(_amount);
301     emit Mint(_to, _amount);
302     emit Transfer(address(0), _to, _amount);
303     return true;
304   }
305 
306   function burn(address _who, uint _amount) onlyAgent public returns (bool) {
307     _burn(_who, _amount);
308     return true;
309   }
310 
311   function transfer(address _to, uint256 _value) public returns (bool) {
312     require(_to != address(0) && _to != address(this));
313     require(_value <= balances[msg.sender]);
314 
315     balances[msg.sender] = balances[msg.sender].sub(_value);
316     balances[_to] = balances[_to].add(_value);
317     emit Transfer(msg.sender, _to, _value);
318     return true;
319   }
320 }