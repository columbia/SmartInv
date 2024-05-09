1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * 
6  * Author: Parkers Team
7  * Telegram: parkres
8  * 
9  * Token Details:-
10  * Name: ParkresToken
11  * Symbol: PARK
12  * Decimals: 8
13  * Total Supply: 200 million
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
84     owner = msg.sender;
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
126   mapping (address => bool) public frozenAccount;
127 
128   /* This generates a public event on the blockchain that will notify clients */
129   event FrozenFunds(address target, bool frozen);
130 
131 
132     /**
133      * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
134      * @param target Address to be frozen
135      * @param freeze either to freeze it or not
136      */
137     function freezeAccount(address target, bool freeze) onlyOwner public {
138         frozenAccount[target] = freeze;
139         emit FrozenFunds(target, freeze);
140     }
141     
142    /**
143      * @param addresses Addresses to be frozen
144      * @param freeze either to freeze it or not
145      */
146     function freezeMultipleAccounts(address[] addresses, bool[] freeze) onlyOwner public {
147        for (uint256 i = 0; i < addresses.length; i++) {
148 
149         frozenAccount[addresses[i]] = freeze[i];
150         emit FrozenFunds(addresses[i], freeze[i]);
151        }
152     }
153     
154   /**
155   * @dev transfer token for a specified address
156   * @param _to The address to transfer to.
157   * @param _value The amount to be transferred.
158   */
159   function transfer(address _to, uint256 _value)public returns (bool) {
160     require(!frozenAccount[msg.sender]);
161     
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner)public constant returns (uint256 balance) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 /**
180  * @title ERC20 interface
181  * @dev see https://github.com/ethereum/EIPs/issues/20
182  */
183 contract ERC20 is ERC20Basic {
184   function allowance(address owner, address spender)
185     public view returns (uint256);
186 
187   function transferFrom(address from, address to, uint256 value)
188     public returns (bool);
189 
190   function approve(address spender, uint256 value) public returns (bool);
191   event Approval(
192     address indexed owner,
193     address indexed spender,
194     uint256 value
195   );
196 }
197 
198 /**
199  * @title Standard ERC20 token
200  *
201  * @dev Implementation of the basic standard token.
202  * @dev https://github.com/ethereum/EIPs/issues/20
203  */
204 contract StandardToken is ERC20, BasicToken {
205 
206   mapping (address => mapping (address => uint256)) internal allowed;
207 
208 
209   /**
210    * @dev Transfer tokens from one address to another
211    * @param _from address The address which you want to send tokens from
212    * @param _to address The address which you want to transfer to
213    * @param _value uint256 the amount of tokens to be transferred
214    */
215   function transferFrom(
216     address _from,
217     address _to,
218     uint256 _value
219   )
220     public
221     returns (bool)
222   {
223     require(_to != address(0));
224     require(_value <= balances[_from]);
225     require(_value <= allowed[_from][msg.sender]);
226     require(!frozenAccount[_from]);                     // Check if sender is frozen
227 
228     balances[_from] = balances[_from].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231     emit Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    *
238    * Beware that changing an allowance with this method brings the risk that someone may use both the old
239    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) public returns (bool) {
246     allowed[msg.sender][_spender] = _value;
247     emit Approval(msg.sender, _spender, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Function to check the amount of tokens that an owner allowed to a spender.
253    * @param _owner address The address which owns the funds.
254    * @param _spender address The address which will spend the funds.
255    * @return A uint256 specifying the amount of tokens still available for the spender.
256    */
257   function allowance(
258     address _owner,
259     address _spender
260    )
261     public
262     view
263     returns (uint256)
264   {
265     return allowed[_owner][_spender];
266   }
267 
268   /**
269    * @dev Increase the amount of tokens that an owner allowed to a spender.
270    *
271    * approve should be called when allowed[_spender] == 0. To increment
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _addedValue The amount of tokens to increase the allowance by.
277    */
278   function increaseApproval(
279     address _spender,
280     uint _addedValue
281   )
282     public
283     returns (bool)
284   {
285     allowed[msg.sender][_spender] = (
286       allowed[msg.sender][_spender].add(_addedValue));
287     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291   /**
292    * @dev Decrease the amount of tokens that an owner allowed to a spender.
293    *
294    * approve should be called when allowed[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseApproval(
302     address _spender,
303     uint _subtractedValue
304   )
305     public
306     returns (bool)
307   {
308     uint oldValue = allowed[msg.sender][_spender];
309     if (_subtractedValue > oldValue) {
310       allowed[msg.sender][_spender] = 0;
311     } else {
312       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
313     }
314     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315     return true;
316   }
317 
318 }
319 
320 
321 contract ParkresToken is StandardToken {
322 
323   string public constant name = "ParkresToken";
324   string public constant symbol = "PARK";
325   uint256 public constant decimals = 8;
326 
327   uint256 public constant INITIAL_SUPPLY = 200000000 * 10**8;
328 
329   /**
330    * @dev Contructor that gives msg.sender all of existing tokens.
331    */
332   constructor() public {
333     totalSupply = INITIAL_SUPPLY;
334     balances[msg.sender] = INITIAL_SUPPLY;
335   }
336   
337 
338 
339 }