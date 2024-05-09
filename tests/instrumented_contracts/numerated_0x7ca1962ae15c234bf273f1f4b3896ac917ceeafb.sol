1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20Basic {
56   uint256 public totalSupply = 1e27;
57   function balanceOf(address who) constant returns (uint);
58   function transfer(address to, uint value) returns (bool);
59   event Transfer(address indexed from, address indexed to, uint value);
60 }
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint;
69 
70   mapping(address => uint) balances;
71 
72   /**
73    * @dev Fix for the ERC20 short address attack.
74    */
75   modifier onlyPayloadSize(uint size) {
76      if(msg.data.length < size + 4) {
77        throw;
78      }
79      _;
80   }
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool) {
88     balances[msg.sender] = balances[msg.sender].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     Transfer(msg.sender, _to, _value);
91     return true;
92   }
93 
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) constant returns (uint balance) {
100     return balances[_owner];
101   }
102 
103 }
104 
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) constant returns (uint);
112   function transferFrom(address from, address to, uint value) returns (bool);
113   function approve(address spender, uint value) returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint value);
115 }
116 
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implemantation of the basic standart token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is BasicToken, ERC20 {
126 
127   mapping (address => mapping (address => uint)) allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint the amout of tokens to be transfered
135    */
136   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool) {
137     var _allowance = allowed[_from][msg.sender];
138 
139     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
140     // if (_value > _allowance) throw;
141 
142     balances[_to] = balances[_to].add(_value);
143     balances[_from] = balances[_from].sub(_value);
144     allowed[_from][msg.sender] = _allowance.sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint _value) returns (bool) {
155 
156     // To change the approve amount you first have to reduce the addresses`
157     //  allowance to zero by calling `approve(_spender, 0)` if it is not
158     //  already 0 to mitigate the race condition described here:
159     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
161 
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens than an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint specifing the amount of tokens still avaible for the spender.
172    */
173   function allowance(address _owner, address _spender) constant returns (uint remaining) {
174     return allowed[_owner][_spender];
175   }
176 
177 }
178 
179 
180 /**
181  * @title Ownable
182  * @dev The Ownable contract has an owner address, and provides basic authorization control
183  * functions, this simplifies the implementation of "user permissions".
184  */
185 contract Ownable {
186   address public owner;
187 
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   function Ownable() {
194     owner = msg.sender;
195   }
196 
197 
198   /**
199    * @dev Throws if called by any account other than the owner.
200    */
201   modifier onlyOwner() {
202     if (msg.sender != owner) {
203       throw;
204     }
205     _;
206   }
207 
208 
209   /**
210    * @dev Allows the current owner to transfer control of the contract to a newOwner.
211    * @param newOwner The address to transfer ownership to.
212    */
213   function transferOwnership(address newOwner) onlyOwner {
214     if (newOwner != address(0)) {
215       owner = newOwner;
216     }
217   }
218 
219 }
220 
221 
222 /**
223  * @title Pausable
224  * @dev Base contract which allows children to implement an emergency stop mechanism.
225  */
226 contract Pausable is Ownable {
227   event Pause();
228   event Unpause();
229 
230   bool public paused = false;
231 
232 
233   /**
234    * @dev modifier to allow actions only when the contract IS paused
235    */
236   modifier whenNotPaused() {
237     if (paused) throw;
238     _;
239   }
240 
241   /**
242    * @dev modifier to allow actions only when the contract IS NOT paused
243    */
244   modifier whenPaused {
245     if (!paused) throw;
246     _;
247   }
248 
249   /**
250    * @dev called by the owner to pause, triggers stopped state
251    */
252   function pause() onlyOwner whenNotPaused returns (bool) {
253     paused = true;
254     Pause();
255     return true;
256   }
257 
258   /**
259    * @dev called by the owner to unpause, returns to normal state
260    */
261   function unpause() onlyOwner whenPaused returns (bool) {
262     paused = false;
263     Unpause();
264     return true;
265   }
266 }
267 
268 
269 /**
270  * Pausable token
271  *
272  * Simple ERC20 Token example, with pausable token creation
273  **/
274 
275 contract PausableToken is StandardToken, Pausable {
276 
277   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
278     return super.transfer(_to, _value);
279   }
280 
281   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
282     return super.transferFrom(_from, _to, _value);
283   }
284 }
285 
286 /**
287  * @title FOREToken
288  * @dev dev
289  */
290 contract FOREToken is PausableToken {
291   using SafeMath for uint256;
292 
293   string public name = "FORESEE";
294   string public symbol = "FORE";
295   uint8 public decimals = 18;
296   
297   function FOREToken() public {
298       balances[msg.sender] = totalSupply;
299   }
300 }