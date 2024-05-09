1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * 
6  * Author: Iceman
7  * Telegram: ice_man0
8  * 
9  * Token Details:-
10  * Name: TEEN
11  * Symbol: TEEN
12  * Decimals: 18
13  * Total Supply: 13500000000
14  * 
15  */
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
28     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
29     // benefit is lost if 'b' is also tested.
30     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31     if (a == 0) {
32       return 0;
33     }
34 
35     c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39   
40   
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     // uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return a / b;
50   }
51 
52   /**
53   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76 
77   address public owner;
78 
79   /**
80    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81    * account.
82    */
83    constructor() public {
84     owner = 0xF774bE017bFAf640FAb7958BC37AB5Cf893E3A76;
85   }
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address newOwner)public onlyOwner {
100     require(newOwner != address(0));
101     owner = newOwner;
102   }
103 }
104 
105 /**
106  * @title ERC20Basic
107  * @dev Simpler version of ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/179
109  */
110 contract ERC20Basic is Ownable {
111   uint256 public totalSupply;
112   function balanceOf(address who) public constant returns (uint256);
113   function transfer(address to, uint256 value) public returns (bool);
114   event Transfer(address indexed from, address indexed to, uint256 value);
115 }
116 
117 /**
118  * @title Basic token
119  * @dev Basic version of StandardToken, with no allowances.
120  */
121 contract BasicToken is ERC20Basic {
122   using SafeMath for uint256;
123 
124   mapping(address => uint256) balances;
125   
126 
127     
128   /**
129   * @dev transfer token for a specified address
130   * @param _to The address to transfer to.
131   * @param _value The amount to be transferred.
132   */
133   function transfer(address _to, uint256 _value)public returns (bool) {
134 
135     balances[msg.sender] = balances[msg.sender].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     emit Transfer(msg.sender, _to, _value);
138     return true;
139   }
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param _owner The address to query the the balance of.
144   * @return An uint256 representing the amount owned by the passed address.
145   */
146   function balanceOf(address _owner)public constant returns (uint256 balance) {
147     return balances[_owner];
148   }
149 
150 }
151 
152 /**
153  * @title ERC20 interface
154  * @dev see https://github.com/ethereum/EIPs/issues/20
155  */
156 contract ERC20 is ERC20Basic {
157   function allowance(address owner, address spender)
158     public view returns (uint256);
159 
160   function transferFrom(address from, address to, uint256 value)
161     public returns (bool);
162 
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(
165     address indexed owner,
166     address indexed spender,
167     uint256 value
168   );
169 }
170 
171 /**
172  * @title Standard ERC20 token
173  *
174  * @dev Implementation of the basic standard token.
175  * @dev https://github.com/ethereum/EIPs/issues/20
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) internal allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(
189     address _from,
190     address _to,
191     uint256 _value
192   )
193     public
194     returns (bool)
195   {
196     require(_to != address(0));
197     require(_value <= balances[_from]);
198     require(_value <= allowed[_from][msg.sender]);
199 
200     balances[_from] = balances[_from].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203     emit Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    *
210    * Beware that changing an allowance with this method brings the risk that someone may use both the old
211    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214    * @param _spender The address which will spend the funds.
215    * @param _value The amount of tokens to be spent.
216    */
217   function approve(address _spender, uint256 _value) public returns (bool) {
218     allowed[msg.sender][_spender] = _value;
219     emit Approval(msg.sender, _spender, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Function to check the amount of tokens that an owner allowed to a spender.
225    * @param _owner address The address which owns the funds.
226    * @param _spender address The address which will spend the funds.
227    * @return A uint256 specifying the amount of tokens still available for the spender.
228    */
229   function allowance(
230     address _owner,
231     address _spender
232    )
233     public
234     view
235     returns (uint256)
236   {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseApproval(
251     address _spender,
252     uint _addedValue
253   )
254     public
255     returns (bool)
256   {
257     allowed[msg.sender][_spender] = (
258       allowed[msg.sender][_spender].add(_addedValue));
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   /**
264    * @dev Decrease the amount of tokens that an owner allowed to a spender.
265    *
266    * approve should be called when allowed[_spender] == 0. To decrement
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _subtractedValue The amount of tokens to decrease the allowance by.
272    */
273   function decreaseApproval(
274     address _spender,
275     uint _subtractedValue
276   )
277     public
278     returns (bool)
279   {
280     uint oldValue = allowed[msg.sender][_spender];
281     if (_subtractedValue > oldValue) {
282       allowed[msg.sender][_spender] = 0;
283     } else {
284       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285     }
286     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290 }
291 
292 
293 contract TEENToken is StandardToken {
294 
295   string public constant name = "TEEN";
296   string public constant symbol = "TEEN";
297   uint256 public constant decimals = 18;
298 
299   uint256 public constant INITIAL_SUPPLY = 13500000000 * 10**decimals;
300 
301   /**
302    * @dev Contructor that gives msg.sender all of existing tokens.
303    */
304   constructor() public {
305     totalSupply = INITIAL_SUPPLY;
306     balances[0xF774bE017bFAf640FAb7958BC37AB5Cf893E3A76] = INITIAL_SUPPLY;
307     emit Transfer(address(0),0xF774bE017bFAf640FAb7958BC37AB5Cf893E3A76, totalSupply);
308   }
309   
310 
311 
312 }