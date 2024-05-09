1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * 
6  * Author: Iceman
7  * Telegram: iceman_0
8  * 
9  * Token Details:-
10  * Name: NoteChain
11  * Symbol: NOTE
12  * Decimals: 18
13  * Total Supply: 20 Billion
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
105 
106 contract ERC20Basic is Ownable {
107   uint256 public totalSupply;
108   function balanceOf(address who) public constant returns (uint256);
109   function transfer(address to, uint256 value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 
114 contract BasicToken is ERC20Basic {
115   using SafeMath for uint256;
116 
117   mapping(address => uint256) balances;
118   
119     mapping (address => bool) public frozenAccount;
120 
121   /* This generates a public event on the blockchain that will notify clients */
122   event FrozenFunds(address target, bool frozen);
123 
124 
125     /**
126      * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
127      * @param target Address to be frozen
128      * @param freeze either to freeze it or not
129      */
130     function freezeAccount(address target, bool freeze)  public onlyOwner{
131         frozenAccount[target] = freeze;
132         emit FrozenFunds(target, freeze);
133     }
134     
135   /**
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value)public returns (bool) {
141     require(!frozenAccount[msg.sender]);
142 
143     balances[msg.sender] = balances[msg.sender].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     emit Transfer(msg.sender, _to, _value);
146     return true;
147   }
148 
149   /**
150   * @dev Gets the balance of the specified address.
151   * @param _owner The address to query the the balance of.
152   * @return An uint256 representing the amount owned by the passed address.
153   */
154   function balanceOf(address _owner)public constant returns (uint256 balance) {
155     return balances[_owner];
156   }
157 
158 }
159 
160 
161 contract ERC20 is ERC20Basic {
162   function allowance(address owner, address spender)
163     public view returns (uint256);
164 
165   function transferFrom(address from, address to, uint256 value)
166     public returns (bool);
167 
168   function approve(address spender, uint256 value) public returns (bool);
169   event Approval(
170     address indexed owner,
171     address indexed spender,
172     uint256 value
173   );
174 }
175 
176 /**
177  * @title Standard ERC20 token
178  *
179  */
180 contract StandardToken is ERC20, BasicToken {
181 
182   mapping (address => mapping (address => uint256)) internal allowed;
183 
184 
185   /**
186    * @dev Transfer tokens from one address to another
187    * @param _from address The address which you want to send tokens from
188    * @param _to address The address which you want to transfer to
189    * @param _value uint256 the amount of tokens to be transferred
190    */
191   function transferFrom(
192     address _from,
193     address _to,
194     uint256 _value
195   )
196     public
197     returns (bool)
198   {
199     require(_to != address(0));
200     require(_value <= balances[_from]);
201     require(_value <= allowed[_from][msg.sender]);
202     require(!frozenAccount[_from]);
203 
204     balances[_from] = balances[_from].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207     emit Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    *
214    * Beware that changing an allowance with this method brings the risk that someone may use both the old
215    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     allowed[msg.sender][_spender] = _value;
223     emit Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifying the amount of tokens still available for the spender.
232    */
233   function allowance(
234     address _owner,
235     address _spender
236    )
237     public
238     view
239     returns (uint256)
240   {
241     return allowed[_owner][_spender];
242   }
243 
244   /**
245    * @dev Increase the amount of tokens that an owner allowed to a spender.
246    *
247    * approve should be called when allowed[_spender] == 0. To increment
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param _spender The address which will spend the funds.
252    * @param _addedValue The amount of tokens to increase the allowance by.
253    */
254   function increaseApproval(
255     address _spender,
256     uint _addedValue
257   )
258     public
259     returns (bool)
260   {
261     allowed[msg.sender][_spender] = (
262       allowed[msg.sender][_spender].add(_addedValue));
263     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267   /**
268    * @dev Decrease the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(
278     address _spender,
279     uint _subtractedValue
280   )
281     public
282     returns (bool)
283   {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293   
294   
295 
296 
297 }
298 
299 
300 contract NoteChainToken is StandardToken {
301 
302   string public constant name = "NoteChain";
303   string public constant symbol = "NOTE";
304   uint256 public constant decimals = 18;
305 
306   uint256 public constant INITIAL_SUPPLY = 20000000000 * 10**decimals;
307 
308   /**
309    * @dev Upon deplyment the tokens will be credidet to 4 addresses
310    */
311   constructor() public {
312     totalSupply = INITIAL_SUPPLY;
313     balances[address(0x750Da02fb96538AbAf5aDd7E09eAC25f1553109D)] = (INITIAL_SUPPLY.mul(20).div(100));
314     balances[address(0xb85e5Eb2C4F43fE44c1dF949c1c49F1638cb772B)] = (INITIAL_SUPPLY.mul(20).div(100));
315     balances[address(0xBd058b319A1355A271B732044f37BBF2Be07A0B1)] = (INITIAL_SUPPLY.mul(25).div(100));
316     balances[address(0x53da2841810e6886254B514d338146d209B164a2)] = (INITIAL_SUPPLY.mul(35).div(100));
317   }
318   
319 
320 
321 }