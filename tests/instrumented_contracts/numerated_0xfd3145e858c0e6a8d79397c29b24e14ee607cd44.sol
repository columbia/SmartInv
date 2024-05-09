1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * 
6  * Author: Ace Casino
7  * 
8  * Token Details:-
9  * Name: Ace Casino
10  * Symbol: CASI
11  * Decimals: 8
12  * Total Supply: 2 Billion
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
125   mapping (address => bool) public frozenAccount;
126 
127   /* This generates a public event on the blockchain that will notify clients */
128   event FrozenFunds(address target, bool frozen);
129 
130 
131     /**
132      * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
133      * @param target Address to be frozen
134      * @param freeze either to freeze it or not
135      */
136     function freezeAccount(address target, bool freeze) onlyOwner public {
137         frozenAccount[target] = freeze;
138         emit FrozenFunds(target, freeze);
139     }
140     
141    /**
142      * @param addresses Addresses to be frozen
143      * @param freeze either to freeze it or not
144      */
145     function freezeMultipleAccounts(address[] addresses, bool[] freeze) onlyOwner public {
146        for (uint256 i = 0; i < addresses.length; i++) {
147 
148         frozenAccount[addresses[i]] = freeze[i];
149         emit FrozenFunds(addresses[i], freeze[i]);
150        }
151     }
152     
153   /**
154   * @dev transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value)public returns (bool) {
159     require(!frozenAccount[msg.sender]);
160     
161     balances[msg.sender] = balances[msg.sender].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     emit Transfer(msg.sender, _to, _value);
164     return true;
165   }
166 
167   /**
168   * @dev Gets the balance of the specified address.
169   * @param _owner The address to query the the balance of.
170   * @return An uint256 representing the amount owned by the passed address.
171   */
172   function balanceOf(address _owner)public constant returns (uint256 balance) {
173     return balances[_owner];
174   }
175 
176 }
177 
178 /**
179  * @title ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/20
181  */
182 contract ERC20 is ERC20Basic {
183   function allowance(address owner, address spender)
184     public view returns (uint256);
185 
186   function transferFrom(address from, address to, uint256 value)
187     public returns (bool);
188 
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(
191     address indexed owner,
192     address indexed spender,
193     uint256 value
194   );
195 }
196 
197 /**
198  * @title Standard ERC20 token
199  *
200  * @dev Implementation of the basic standard token.
201  * @dev https://github.com/ethereum/EIPs/issues/20
202  */
203 contract StandardToken is ERC20, BasicToken {
204 
205   mapping (address => mapping (address => uint256)) internal allowed;
206 
207 
208   /**
209    * @dev Transfer tokens from one address to another
210    * @param _from address The address which you want to send tokens from
211    * @param _to address The address which you want to transfer to
212    * @param _value uint256 the amount of tokens to be transferred
213    */
214   function transferFrom(
215     address _from,
216     address _to,
217     uint256 _value
218   )
219     public
220     returns (bool)
221   {
222     require(_to != address(0));
223     require(_value <= balances[_from]);
224     require(_value <= allowed[_from][msg.sender]);
225     require(!frozenAccount[_from]);                     // Check if sender is frozen
226 
227     balances[_from] = balances[_from].sub(_value);
228     balances[_to] = balances[_to].add(_value);
229     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
230     emit Transfer(_from, _to, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236    *
237    * Beware that changing an allowance with this method brings the risk that someone may use both the old
238    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241    * @param _spender The address which will spend the funds.
242    * @param _value The amount of tokens to be spent.
243    */
244   function approve(address _spender, uint256 _value) public returns (bool) {
245     allowed[msg.sender][_spender] = _value;
246     emit Approval(msg.sender, _spender, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Function to check the amount of tokens that an owner allowed to a spender.
252    * @param _owner address The address which owns the funds.
253    * @param _spender address The address which will spend the funds.
254    * @return A uint256 specifying the amount of tokens still available for the spender.
255    */
256   function allowance(
257     address _owner,
258     address _spender
259    )
260     public
261     view
262     returns (uint256)
263   {
264     return allowed[_owner][_spender];
265   }
266 
267   /**
268    * @dev Increase the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To increment
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _addedValue The amount of tokens to increase the allowance by.
276    */
277   function increaseApproval(
278     address _spender,
279     uint _addedValue
280   )
281     public
282     returns (bool)
283   {
284     allowed[msg.sender][_spender] = (
285       allowed[msg.sender][_spender].add(_addedValue));
286     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290   /**
291    * @dev Decrease the amount of tokens that an owner allowed to a spender.
292    *
293    * approve should be called when allowed[_spender] == 0. To decrement
294    * allowed value is better to use this function to avoid 2 calls (and wait until
295    * the first transaction is mined)
296    * From MonolithDAO Token.sol
297    * @param _spender The address which will spend the funds.
298    * @param _subtractedValue The amount of tokens to decrease the allowance by.
299    */
300   function decreaseApproval(
301     address _spender,
302     uint _subtractedValue
303   )
304     public
305     returns (bool)
306   {
307     uint oldValue = allowed[msg.sender][_spender];
308     if (_subtractedValue > oldValue) {
309       allowed[msg.sender][_spender] = 0;
310     } else {
311       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
312     }
313     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317 }
318 
319 
320 contract AceCasinoToken is StandardToken {
321 
322   string public constant name = "AceCasinoToken";
323   string public constant symbol = "CASI";
324   uint256 public constant decimals = 8;
325 
326   uint256 public constant INITIAL_SUPPLY = 2000000000 * 10**8;
327 
328   /**
329    * @dev Contructor that gives msg.sender all of existing tokens.
330    */
331   constructor() public {
332     totalSupply = INITIAL_SUPPLY;
333     balances[msg.sender] = INITIAL_SUPPLY;
334   }
335   
336 
337 
338 }