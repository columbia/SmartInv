1 pragma solidity ^0.4.24;
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
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20Basic {
62   uint public totalSupply;
63   function balanceOf(address who) constant returns (uint);
64   function transfer(address to, uint value);
65   event Transfer(address indexed from, address indexed to, uint value);
66 }
67 
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances.
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint;
75 
76   mapping(address => uint) balances;
77 
78   /**
79    * @dev Fix for the ERC20 short address attack.
80    */
81   modifier onlyPayloadSize(uint size) {
82      if(msg.data.length < size + 4) {
83        throw;
84      }
85      _;
86   }
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
94     if (_to == address(0)) {
95       throw;
96     }
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     Transfer(msg.sender, _to, _value);
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) constant returns (uint balance) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120   function allowance(address owner, address spender) constant returns (uint);
121   function transferFrom(address from, address to, uint value);
122   function approve(address spender, uint value);
123   event Approval(address indexed owner, address indexed spender, uint value);
124 }
125 
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implemantation of the basic standart token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is BasicToken, ERC20 {
135 
136   mapping (address => mapping (address => uint)) allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint the amout of tokens to be transfered
144    */
145   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
146     if(_to == address(0)) {
147       throw; 
148     }
149 
150     var _allowance = allowed[_from][msg.sender];
151     
152     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
153     // if (_value > _allowance) throw;
154     
155     balances[_to] = balances[_to].add(_value);
156     balances[_from] = balances[_from].sub(_value);
157     allowed[_from][msg.sender] = _allowance.sub(_value);
158     Transfer(_from, _to, _value);
159   }
160 
161   /**
162    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint _value) {
167 
168     // To change the approve amount you first have to reduce the addresses`
169     //  allowance to zero by calling `approve(_spender, 0)` if it is not
170     //  already 0 to mitigate the race condition described here:
171     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
173 
174     allowed[msg.sender][_spender] = _value;
175     Approval(msg.sender, _spender, _value);
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens than an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint specifing the amount of tokens still avaible for the spender.
183    */
184   function allowance(address _owner, address _spender) constant returns (uint remaining) {
185     return allowed[_owner][_spender];
186   }
187 
188 }
189 
190 
191 /**
192  * @title Ownable
193  * @dev The Ownable contract has an owner address, and provides basic authorization control
194  * functions, this simplifies the implementation of "user permissions".
195  */
196 contract Ownable {
197   address public owner;
198 
199 
200   /**
201    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
202    * account.
203    */
204   function Ownable() {
205     owner = msg.sender;
206   }
207 
208 
209   /**
210    * @dev Throws if called by any account other than the owner.
211    */
212   modifier onlyOwner() {
213     if (msg.sender != owner) {
214       throw;
215     }
216     _;
217   }
218 
219 
220   /**
221    * @dev Allows the current owner to transfer control of the contract to a newOwner.
222    * @param newOwner The address to transfer ownership to.
223    */
224   function transferOwnership(address newOwner) onlyOwner {
225     if (newOwner != address(0)) {
226       owner = newOwner;
227     }
228   }
229 
230 }
231 
232 
233 /**
234  * @title Pausable
235  * @dev Base contract which allows children to implement an emergency stop mechanism.
236  */
237 contract Pausable is Ownable {
238   event Pause();
239   event Unpause();
240 
241   bool public paused = false;
242 
243 
244   /**
245    * @dev modifier to allow actions only when the contract IS paused
246    */
247   modifier whenNotPaused() {
248     if (paused) throw;
249     _;
250   }
251 
252   /**
253    * @dev modifier to allow actions only when the contract IS NOT paused
254    */
255   modifier whenPaused {
256     if (!paused) throw;
257     _;
258   }
259 
260   /**
261    * @dev called by the owner to pause, triggers stopped state
262    */
263   function pause() onlyOwner whenNotPaused returns (bool) {
264     paused = true;
265     Pause();
266     return true;
267   }
268 
269   /**
270    * @dev called by the owner to unpause, returns to normal state
271    */
272   function unpause() onlyOwner whenPaused returns (bool) {
273     paused = false;
274     Unpause();
275     return true;
276   }
277 }
278 
279 
280 /**
281  * Pausable token
282  *
283  * Simple ERC20 Token example, with pausable token creation
284  **/
285 
286 contract PausableToken is StandardToken, Pausable {
287 
288   function transfer(address _to, uint _value) whenNotPaused {
289     super.transfer(_to, _value);
290   }
291 
292   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
293     super.transferFrom(_from, _to, _value);
294   }
295 }
296 
297 
298 /**
299  * @title VocToken
300  * @dev Voc Token contract
301  */
302 contract VocToken is PausableToken {
303   using SafeMath for uint256;
304 
305   string public name = "Vocal Chain";
306   string public symbol = "VOC";
307   uint public decimals = 8;
308   uint public totalSupply = 2*10**19;
309 
310   function VocToken() {
311         balances[msg.sender] = totalSupply;
312         Transfer(address(0), msg.sender, totalSupply);
313     }
314 }