1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
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
61     require(_value <= balances[msg.sender]);
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
78 
79 }
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) public constant returns (uint256);
87   function transferFrom(address from, address to, uint256 value) public returns (bool);
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    *
126    * Beware that changing an allowance with this method brings the risk that someone may use both the old
127    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130    * @param _spender The address which will spend the funds.
131    * @param _value The amount of tokens to be spent.
132    */
133   function approve(address _spender, uint256 _value) public returns (bool) {
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 }
149 
150 /**
151  * @title Ownable
152  * @dev The Ownable contract has an owner address, and provides basic authorization control
153  * functions, this simplifies the implementation of "user permissions".
154  */
155 contract Ownable {
156   address public owner;
157 
158 
159   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160 
161 
162   /**
163    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
164    * account.
165    */
166   function Ownable() {
167     owner = msg.sender;
168   }
169 
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179 
180   /**
181    * @dev Allows the current owner to transfer control of the contract to a newOwner.
182    * @param newOwner The address to transfer ownership to.
183    */
184   function transferOwnership(address newOwner) onlyOwner public {
185     require(newOwner != address(0));
186     OwnershipTransferred(owner, newOwner);
187     owner = newOwner;
188   }
189 
190 }
191 
192 /**
193  * @title Pausable
194  * @dev Base contract which allows children to implement an emergency stop mechanism.
195  */
196 contract Pausable is Ownable {
197   event Pause();
198   event Unpause();
199 
200   bool public paused = false;
201 
202 
203   /**
204    * @dev Modifier to make a function callable only when the contract is not paused.
205    */
206   modifier whenNotPaused() {
207     require(!paused);
208     _;
209   }
210 
211   /**
212    * @dev Modifier to make a function callable only when the contract is paused.
213    */
214   modifier whenPaused() {
215     require(paused);
216     _;
217   }
218 
219   /**
220    * @dev called by the owner to pause, triggers stopped state
221    */
222   function pause() onlyOwner whenNotPaused public {
223     paused = true;
224     Pause();
225   }
226 
227   /**
228    * @dev called by the owner to unpause, returns to normal state
229    */
230   function unpause() onlyOwner whenPaused public {
231     paused = false;
232     Unpause();
233   }
234 }
235 
236 /**
237  * @title Pausable token
238  *
239  * @dev StandardToken modified with pausable transfers.
240  **/
241 
242 contract PausableToken is StandardToken, Pausable {
243 
244   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
245     return super.transfer(_to, _value);
246   }
247 
248   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
249     return super.transferFrom(_from, _to, _value);
250   }
251 
252   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
253     return super.approve(_spender, _value);
254   }
255 }
256 
257 /**
258  * @title QASH Token
259  *
260  * @dev Implementation of QASH Token based on the basic standard token.
261  */
262 contract GATcoin is PausableToken {
263 
264     function () {
265       //if ether is sent to this address, send it back.
266         revert();
267     }
268 
269     /**
270     * Public variables of the token
271     * The following variables are OPTIONAL vanities. One does not have to include them.
272     * They allow one to customise the token contract & in no way influences the core functionality.
273     * Some wallets/interfaces might not even bother to look at this information.
274     */
275     string public name;
276     uint8 public decimals;
277     string public symbol;
278     string public version = '1.0.0';
279 
280     /**
281      * @dev Function to check the amount of tokens that an owner allowed to a spender.
282      * @param _totalSupply total supply of the token.
283      * @param _name token name e.g QASH Token.
284      * @param _symbol token symbol e.g QASH.
285      * @param _decimals amount of decimals.
286      */
287     function GATcoin(uint256 _totalSupply, string _name, string _symbol, uint8 _decimals) {
288         balances[msg.sender] = _totalSupply;    // Give the creator all initial tokens
289         totalSupply = _totalSupply;
290         name = _name;
291         symbol = _symbol;
292         decimals = _decimals;
293     }
294 }