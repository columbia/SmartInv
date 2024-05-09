1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61     require(_value > 0 && _value <= balances[msg.sender]);
62 
63     // SafeMath.sub will throw if there is not enough balance.
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   /**
71   * @dev Gets the balance of the specified address.
72   * @param _owner The address to query the the balance of.
73   * @return An uint256 representing the amount owned by the passed address.
74   */
75   function balanceOf(address _owner) public constant returns (uint256 balance) {
76     return balances[_owner];
77   }
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) public constant returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) internal allowed;
101 
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amount of tokens to be transferred
108    */
109   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111     require(_value > 0 && _value <= balances[_from]);
112     require(_value <= allowed[_from][msg.sender]);
113 
114     balances[_from] = balances[_from].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    *
124    * Beware that changing an allowance with this method brings the risk that someone may use both the old
125    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
126    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
127    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128    * @param _spender The address which will spend the funds.
129    * @param _value The amount of tokens to be spent.
130    */
131   function approve(address _spender, uint256 _value) public returns (bool) {
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifying the amount of tokens still available for the spender.
142    */
143   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 }
147 
148 /**
149  * @title Ownable
150  * @dev The Ownable contract has an owner address, and provides basic authorization control
151  * functions, this simplifies the implementation of "user permissions".
152  */
153 contract Ownable {
154   address public owner;
155 
156 
157   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   function Ownable() public {
165     owner = msg.sender;
166   }
167 
168 
169   /**
170    * @dev Throws if called by any account other than the owner.
171    */
172   modifier onlyOwner() {
173     require(msg.sender == owner);
174     _;
175   }
176 
177 
178   /**
179    * @dev Allows the current owner to transfer control of the contract to a newOwner.
180    * @param newOwner The address to transfer ownership to.
181    */
182   function transferOwnership(address newOwner) onlyOwner public {
183     require(newOwner != address(0));
184     OwnershipTransferred(owner, newOwner);
185     owner = newOwner;
186   }
187 
188 }
189 
190 /**
191  * @title Pausable
192  * @dev Base contract which allows children to implement an emergency stop mechanism.
193  */
194 contract Pausable is Ownable {
195   event Pause();
196   event Unpause();
197 
198   bool public paused = false;
199 
200 
201   /**
202    * @dev Modifier to make a function callable only when the contract is not paused.
203    */
204   modifier whenNotPaused() {
205     require(!paused);
206     _;
207   }
208 
209   /**
210    * @dev Modifier to make a function callable only when the contract is paused.
211    */
212   modifier whenPaused() {
213     require(paused);
214     _;
215   }
216 
217   /**
218    * @dev called by the owner to pause, triggers stopped state
219    */
220   function pause() onlyOwner whenNotPaused public {
221     paused = true;
222     Pause();
223   }
224 
225   /**
226    * @dev called by the owner to unpause, returns to normal state
227    */
228   function unpause() onlyOwner whenPaused public {
229     paused = false;
230     Unpause();
231   }
232 }
233 
234 /**
235  * @title Pausable token
236  *
237  * @dev StandardToken modified with pausable transfers.
238  **/
239 
240 contract PausableToken is StandardToken, Pausable {
241 
242   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
243     return super.transfer(_to, _value);
244   }
245 
246   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
247     return super.transferFrom(_from, _to, _value);
248   }
249 
250   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
251     return super.approve(_spender, _value);
252   }
253 }
254 
255 /**
256  * @title BI Token
257  *
258  * @dev Implementation of BI Token based on the basic standard token.
259  */
260 contract BIToken is PausableToken {
261     /**
262     * Public variables of the token
263     * The following variables are OPTIONAL vanities. One does not have to include them.
264     * They allow one to customise the token contract & in no way influences the core functionality.
265     * Some wallets/interfaces might not even bother to look at this information.
266     */
267     string public name = "Coin of biWallet";
268     string public symbol = "BI";
269     string public version = '1.0.0';
270     uint8 public decimals = 18;
271     uint256 public supplyLimit = 21000000000 * (10 ** uint256(decimals));
272 
273     /**
274      * @dev Function to check the amount of tokens that an owner allowed to a spender.
275      */
276     function BIToken() public {
277         totalSupply = supplyLimit;
278         balances[msg.sender] = supplyLimit;    // Give the creator all initial tokens
279     }
280     
281     function () public {
282         //if ether is sent to this address, send it back.
283         revert();
284     }
285 }