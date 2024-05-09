1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * 
6  * Author: NoteChain Developer
7  * 
8  * Token Details:-
9  * Name: NoteChain
10  * Symbol: NOTE
11  * Decimals: 18
12  * Total Supply: 20 Billion
13  * 
14  */
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28     // benefit is lost if 'b' is also tested.
29     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30     if (a == 0) {
31       return 0;
32     }
33 
34     c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38   
39   
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75 
76   address public owner;
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82    constructor() public {
83     owner = msg.sender;
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   /**
95    * @dev Allows the current owner to transfer control of the contract to a newOwner.
96    * @param newOwner The address to transfer ownership to.
97    */
98   function transferOwnership(address newOwner)public onlyOwner {
99     require(newOwner != address(0));
100     owner = newOwner;
101   }
102 }
103 
104 /**
105  * @title ERC20Basic
106  * @dev Simpler version of ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/179
108  */
109 contract ERC20Basic is Ownable {
110   uint256 public totalSupply;
111   function balanceOf(address who) public constant returns (uint256);
112   function transfer(address to, uint256 value) public returns (bool);
113   event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 /**
117  * @title Basic token
118  * @dev Basic version of StandardToken, with no allowances.
119  */
120 contract BasicToken is ERC20Basic {
121   using SafeMath for uint256;
122 
123   mapping(address => uint256) balances;
124   
125   /**
126   * @dev transfer token for a specified address
127   * @param _to The address to transfer to.
128   * @param _value The amount to be transferred.
129   */
130   function transfer(address _to, uint256 _value)public returns (bool) {
131 
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     emit Transfer(msg.sender, _to, _value);
135     return true;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner)public constant returns (uint256 balance) {
144     return balances[_owner];
145   }
146 
147 }
148 
149 /**
150  * @title ERC20 interface
151  * @dev see https://github.com/ethereum/EIPs/issues/20
152  */
153 contract ERC20 is ERC20Basic {
154   function allowance(address owner, address spender)
155     public view returns (uint256);
156 
157   function transferFrom(address from, address to, uint256 value)
158     public returns (bool);
159 
160   function approve(address spender, uint256 value) public returns (bool);
161   event Approval(
162     address indexed owner,
163     address indexed spender,
164     uint256 value
165   );
166 }
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  */
174 contract StandardToken is ERC20, BasicToken {
175 
176   mapping (address => mapping (address => uint256)) internal allowed;
177 
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(
186     address _from,
187     address _to,
188     uint256 _value
189   )
190     public
191     returns (bool)
192   {
193     require(_to != address(0));
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200     emit Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    *
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) public returns (bool) {
215     allowed[msg.sender][_spender] = _value;
216     emit Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(
227     address _owner,
228     address _spender
229    )
230     public
231     view
232     returns (uint256)
233   {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To increment
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param _spender The address which will spend the funds.
245    * @param _addedValue The amount of tokens to increase the allowance by.
246    */
247   function increaseApproval(
248     address _spender,
249     uint _addedValue
250   )
251     public
252     returns (bool)
253   {
254     allowed[msg.sender][_spender] = (
255       allowed[msg.sender][_spender].add(_addedValue));
256     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260   /**
261    * @dev Decrease the amount of tokens that an owner allowed to a spender.
262    *
263    * approve should be called when allowed[_spender] == 0. To decrement
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _subtractedValue The amount of tokens to decrease the allowance by.
269    */
270   function decreaseApproval(
271     address _spender,
272     uint _subtractedValue
273   )
274     public
275     returns (bool)
276   {
277     uint oldValue = allowed[msg.sender][_spender];
278     if (_subtractedValue > oldValue) {
279       allowed[msg.sender][_spender] = 0;
280     } else {
281       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
282     }
283     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287 }
288 
289 
290 contract NoteChainToken is StandardToken {
291 
292   string public constant name = "NoteChain";
293   string public constant symbol = "NOTE";
294   uint256 public constant decimals = 18;
295 
296   uint256 public constant INITIAL_SUPPLY = 20000000000 * 10**decimals;
297 
298   /**
299    * @dev Contructor that gives msg.sender all of existing tokens.
300    */
301   constructor() public {
302     totalSupply = INITIAL_SUPPLY;
303     balances[address(0x72EBbA77118bb1eA4ed3F66dB59705A38aB24B4C)] = (INITIAL_SUPPLY.mul(20).div(100));
304     balances[address(0x59C8245babfcb77B72574117659C3a6a4882E548)] = (INITIAL_SUPPLY.mul(20).div(100));
305     balances[address(0xab005AEe9352d411f4024778E291F4efC77E34eB)] = (INITIAL_SUPPLY.mul(25).div(100));
306     balances[address(0xb72b84090E2BFEb295a8bDeA7978de5f80a53ED4)] = (INITIAL_SUPPLY.mul(35).div(100));
307   }
308   
309 
310 
311 }