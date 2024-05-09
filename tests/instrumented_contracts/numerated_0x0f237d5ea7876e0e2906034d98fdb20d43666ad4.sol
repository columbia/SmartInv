1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev PROUDLY MADE BY CMX 
8  * @dev CONNECT COIN TEAM
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public constant returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 
19 /**
20  * @title Ownable
21  * @dev The Ownable contract has an owner address, and provides basic authorization control
22  * functions, this simplifies the implementation of "user permissions".
23  */
24 contract Ownable {
25   address public owner;
26 
27 
28   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   function Ownable() {
36     owner = msg.sender;
37   }
38 
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) onlyOwner public {
54     require(newOwner != address(0));
55     OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 //ERC20 Token
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 /**
76  * @title SafeMath
77  * @dev Math operations with safety checks that throw on error
78  */
79 library SafeMath {
80   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
81     uint256 c = a * b;
82     assert(a == 0 || c / a == b);
83     return c;
84   }
85 
86   function div(uint256 a, uint256 b) internal constant returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   function add(uint256 a, uint256 b) internal constant returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 }
104 
105 
106 
107 /**
108  * @title Basic token
109  * @dev Basic version of StandardToken, with no allowances.
110  */
111 contract BasicToken is ERC20Basic {
112   using SafeMath for uint256;
113 
114   mapping(address => uint256) balances;
115 
116   /**
117   * @dev transfer token for a specified address
118   * @param _to The address to transfer to.
119   * @param _value The amount to be transferred.
120   */
121   function transfer(address _to, uint256 _value) public returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[msg.sender]);
124 
125     // SafeMath.sub will throw if there is not enough balance.
126     balances[msg.sender] = balances[msg.sender].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     Transfer(msg.sender, _to, _value);
129     return true;
130   }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137   function balanceOf(address _owner) public constant returns (uint256 balance) {
138     return balances[_owner];
139   }
140 
141 }
142 
143 
144 
145 
146 
147 
148 
149 /**
150  * @title ERC20 interface
151  * @dev see https://github.com/ethereum/EIPs/issues/20
152  */
153 contract ERC20 is ERC20Basic {
154   function allowance(address owner, address spender) public constant returns (uint256);
155   function transferFrom(address from, address to, uint256 value) public returns (bool);
156   function approve(address spender, uint256 value) public returns (bool);
157   event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 
161 
162 /**
163  * @title Standard ERC20 token
164  *
165  * @dev Implementation of the basic standard token.
166  * @dev https://github.com/ethereum/EIPs/issues/20
167  * @dev MADE BY CMX https://cryptocurrencymountain.com
168  * @dev JIMMY JAMES jimyjames44@gmail.com
169  * @dev RENEE KROM reneekrom11@gmail.com
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) internal allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186 
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190     Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
217     return allowed[_owner][_spender];
218   }
219 
220   /**
221    * approve should be called when allowed[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    */
226   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
227     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
228     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
233     uint oldValue = allowed[msg.sender][_spender];
234     if (_subtractedValue > oldValue) {
235       allowed[msg.sender][_spender] = 0;
236     } else {
237       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238     }
239     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243 }
244 
245 
246 /**
247  * @title Burnable Token
248  * @dev Token that can be irreversibly burned (destroyed).
249  */
250 contract BurnableToken is StandardToken {
251 
252     event Burn(address indexed burner, uint256 value);
253 
254     /**
255      * @dev Burns a specific amount of tokens.
256      * @param _value The amount of token to be burned.
257      */
258     function burn(uint256 _value) public {
259         require(_value > 0);
260         require(_value <= balances[msg.sender]);
261         // no need to require value <= totalSupply, since that would imply the
262         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
263 
264         address burner = msg.sender;
265         balances[burner] = balances[burner].sub(_value);
266         totalSupply = totalSupply.sub(_value);
267         Burn(burner, _value);
268     }
269 }
270 
271 
272 
273 contract CONNECTXCON is BurnableToken, Ownable {
274 
275     string public constant name = "Connect coin(XCON)";
276     string public constant symbol = "XCON";
277     uint public constant decimals = 18;
278     uint256 public constant initialSupply = 70000000 * (10 ** uint256(decimals));
279 
280     // Constructor
281     function CONNECTXCON() {
282         totalSupply = initialSupply;
283         balances[msg.sender] = initialSupply; // Send all tokens to owner
284     }
285 }