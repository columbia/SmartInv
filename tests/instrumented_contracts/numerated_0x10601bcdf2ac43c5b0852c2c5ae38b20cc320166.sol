1 /**
2  *Submitted for verification at Etherscan.io on 2020-02-18
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2018-09-24
7 */
8 
9 pragma solidity ^0.4.11;
10 
11 
12 /**
13  * Math operations with safety checks
14  */
15 library SafeMath {
16   function mul(uint a, uint b) internal returns (uint) {
17     uint c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint a, uint b) internal returns (uint) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint a, uint b) internal returns (uint) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint a, uint b) internal returns (uint) {
35     uint c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 
40   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
41     return a >= b ? a : b;
42   }
43 
44   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
45     return a < b ? a : b;
46   }
47 
48   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a >= b ? a : b;
50   }
51 
52   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
53     return a < b ? a : b;
54   }
55 
56   function assert(bool assertion) internal {
57     if (!assertion) {
58       throw;
59     }
60   }
61 }
62 
63 
64 /**
65  * @title ERC20Basic
66  * @dev Simpler version of ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20Basic {
70   uint public totalSupply;
71   function balanceOf(address who) constant returns (uint);
72   function transfer(address to, uint value);
73   event Transfer(address indexed from, address indexed to, uint value);
74 }
75 
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint;
83 
84   mapping(address => uint) balances;
85 
86   /**
87    * @dev Fix for the ERC20 short address attack.
88    */
89   modifier onlyPayloadSize(uint size) {
90      if(msg.data.length < size + 4) {
91        throw;
92      }
93      _;
94   }
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     Transfer(msg.sender, _to, _value);
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) constant returns (uint balance) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address owner, address spender) constant returns (uint);
125   function transferFrom(address from, address to, uint value);
126   function approve(address spender, uint value);
127   event Approval(address indexed owner, address indexed spender, uint value);
128 }
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implemantation of the basic standart token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  */
137 contract StandardToken is BasicToken, ERC20 {
138 
139   mapping (address => mapping (address => uint)) allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint the amout of tokens to be transfered
147    */
148   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
149     var _allowance = allowed[_from][msg.sender];
150 
151     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
152     // if (_value > _allowance) throw;
153 
154     balances[_to] = balances[_to].add(_value);
155     balances[_from] = balances[_from].sub(_value);
156     allowed[_from][msg.sender] = _allowance.sub(_value);
157     Transfer(_from, _to, _value);
158   }
159 
160   /**
161    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint _value) {
166 
167     // To change the approve amount you first have to reduce the addresses`
168     //  allowance to zero by calling `approve(_spender, 0)` if it is not
169     //  already 0 to mitigate the race condition described here:
170     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
172 
173     allowed[msg.sender][_spender] = _value;
174     Approval(msg.sender, _spender, _value);
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens than an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint specifing the amount of tokens still avaible for the spender.
182    */
183   function allowance(address _owner, address _spender) constant returns (uint remaining) {
184     return allowed[_owner][_spender];
185   }
186 
187 }
188 
189 
190 /**
191  * @title Ownable
192  * @dev The Ownable contract has an owner address, and provides basic authorization control
193  * functions, this simplifies the implementation of "user permissions".
194  */
195 contract Ownable {
196   address public owner;
197 
198 
199   /**
200    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
201    * account.
202    */
203   function Ownable() {
204     owner = msg.sender;
205   }
206 
207 
208   /**
209    * @dev Throws if called by any account other than the owner.
210    */
211   modifier onlyOwner() {
212     if (msg.sender != owner) {
213       throw;
214     }
215     _;
216   }
217 
218 
219   /**
220    * @dev Allows the current owner to transfer control of the contract to a newOwner.
221    * @param newOwner The address to transfer ownership to.
222    */
223   function transferOwnership(address newOwner) onlyOwner {
224     if (newOwner != address(0)) {
225       owner = newOwner;
226     }
227   }
228 
229 }
230 /**
231  * @title Pausable
232  * @dev Base contract which allows children to implement an emergency stop mechanism.
233  */
234 contract Pausable is Ownable {
235   event Pause();
236   event Unpause();
237 
238   bool public paused = false;
239 
240 
241   /**
242    * @dev modifier to allow actions only when the contract IS paused
243    */
244   modifier whenNotPaused() {
245     if (paused) throw;
246     _;
247   }
248 
249   /**
250    * @dev modifier to allow actions only when the contract IS NOT paused
251    */
252   modifier whenPaused {
253     if (!paused) throw;
254     _;
255   }
256 
257   /**
258    * @dev called by the owner to pause, triggers stopped state
259    */
260   function pause() onlyOwner whenNotPaused returns (bool) {
261     paused = true;
262     Pause();
263     return true;
264   }
265 
266   /**
267    * @dev called by the owner to unpause, returns to normal state
268    */
269   function unpause() onlyOwner whenPaused returns (bool) {
270     paused = false;
271     Unpause();
272     return true;
273   }
274 }
275 
276 
277 /**
278  * Pausable token
279  *
280  * Simple ERC20 Token example, with pausable token creation
281  **/
282 
283 contract PausableToken is StandardToken, Pausable {
284 
285   function transfer(address _to, uint _value) whenNotPaused {
286     super.transfer(_to, _value);
287   }
288 
289   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
290     super.transferFrom(_from, _to, _value);
291   }
292 }
293 
294 
295 contract BTWLToken is PausableToken {
296   using SafeMath for uint256;  
297   string public name = "BTCFuture";
298   string public symbol = "BTWL";
299   uint public decimals = 18;
300   function BTWLToken(){
301 	totalSupply = 10000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
302     balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
303 	Transfer(address(0x0), msg.sender, totalSupply);
304   }
305 
306 }