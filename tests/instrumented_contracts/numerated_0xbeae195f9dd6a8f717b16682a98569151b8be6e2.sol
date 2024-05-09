1 pragma solidity ^0.4.11;
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
55    * @dev Fix for the ERC20 short address attack.
56    */
57   modifier onlyPayloadSize(uint size) {
58      if(msg.data.length < size + 4) {
59        throw;
60      }
61      _;
62   }
63 
64   /**
65   * @dev transfer token for a specified address
66   * @param _to The address to transfer to.
67   * @param _value The amount to be transferred.
68   */
69   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
70     require(_to != address(0));
71     require(_value > 0 && _value <= balances[msg.sender]);
72 
73     // SafeMath.sub will throw if there is not enough balance.
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of.
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) public constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public constant returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * @dev https://github.com/ethereum/EIPs/issues/20
107  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract StandardToken is ERC20, BasicToken {
110 
111   mapping (address => mapping (address => uint256)) internal allowed;
112 
113 
114   /**
115    * @dev Transfer tokens from one address to another
116    * @param _from address The address which you want to send tokens from
117    * @param _to address The address which you want to transfer to
118    * @param _value uint256 the amount of tokens to be transferred
119    */
120   function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
121     require(_to != address(0));
122     require(_value > 0 && _value <= balances[_from]);
123     require(_value <= allowed[_from][msg.sender]);
124 
125     balances[_from] = balances[_from].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128     Transfer(_from, _to, _value);
129     return true;
130   }
131 
132   /**
133    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134    *
135    * Beware that changing an allowance with this method brings the risk that someone may use both the old
136    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
137    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
138    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139    * @param _spender The address which will spend the funds.
140    * @param _value The amount of tokens to be spent.
141    */
142   function approve(address _spender, uint256 _value) public returns (bool) {
143     allowed[msg.sender][_spender] = _value;
144     Approval(msg.sender, _spender, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Function to check the amount of tokens that an owner allowed to a spender.
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint256 specifying the amount of tokens still available for the spender.
153    */
154   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
155     return allowed[_owner][_spender];
156   }
157 }
158 
159 /**
160  * @title Ownable
161  * @dev The Ownable contract has an owner address, and provides basic authorization control
162  * functions, this simplifies the implementation of "user permissions".
163  */
164 contract Ownable {
165   address public owner;
166 
167 
168   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170 
171   /**
172    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
173    * account.
174    */
175   function Ownable() {
176     owner = msg.sender;
177   }
178 
179 
180   /**
181    * @dev Throws if called by any account other than the owner.
182    */
183   modifier onlyOwner() {
184     require(msg.sender == owner);
185     _;
186   }
187 
188   /**
189    * @dev Allows the current owner to transfer control of the contract to a newOwner.
190    * @param newOwner The address to transfer ownership to.
191    */
192   function transferOwnership(address newOwner) onlyOwner public {
193     require(newOwner != address(0));
194     OwnershipTransferred(owner, newOwner);
195     owner = newOwner;
196   }
197 }
198 
199 /**
200  * @title Pausable
201  * @dev Base contract which allows children to implement an emergency stop mechanism.
202  */
203 contract Pausable is Ownable {
204   event Pause();
205   event Unpause();
206 
207   bool public paused = false;
208 
209 
210   /**
211    * @dev Modifier to make a function callable only when the contract is not paused.
212    */
213   modifier whenNotPaused() {
214     require(!paused);
215     _;
216   }
217 
218   /**
219    * @dev Modifier to make a function callable only when the contract is paused.
220    */
221   modifier whenPaused() {
222     require(paused);
223     _;
224   }
225 
226   /**
227    * @dev called by the owner to pause, triggers stopped state
228    */
229   function pause() onlyOwner whenNotPaused public {
230     paused = true;
231     Pause();
232   }
233 
234   /**
235    * @dev called by the owner to unpause, returns to normal state
236    */
237   function unpause() onlyOwner whenPaused public {
238     paused = false;
239     Unpause();
240   }
241 }
242 
243 /**
244  * @title Pausable token
245  *
246  * @dev StandardToken modified with pausable transfers.
247  **/
248 
249 contract PausableToken is StandardToken, Pausable {
250     
251   using SafeMath for uint256;
252 
253   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
254     return super.transfer(_to, _value);
255   }
256 
257   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
258     return super.transferFrom(_from, _to, _value);
259   }
260 
261   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
262     return super.approve(_spender, _value);
263   }
264 }
265 
266 /**
267  * @title Bec Token
268  *
269  * @dev Implementation of Bec Token based on the basic standard token.
270  */
271 contract JFBToken is PausableToken {
272     /**
273     * Public variables of the token
274     * The following variables are OPTIONAL vanities. One does not have to include them.
275     * They allow one to customise the token contract & in no way influences the core functionality.
276     * Some wallets/interfaces might not even bother to look at this information.
277     */
278     string public name = "JiFenBao";
279     string public symbol = "JFB-1";
280     string public version = '1.0.0';
281     uint8 public decimals = 18;
282 
283     /**
284      * @dev Function to check the amount of tokens that an owner allowed to a spender.
285      */
286     function JFBToken() {
287       totalSupply = 300000000*10**(uint256(decimals));
288       balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
289     }
290 }