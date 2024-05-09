1 /**
2  *Submitted for verification at Etherscan.io on 2018-09-24
3 */
4 
5 pragma solidity ^0.4.11;
6 
7 
8 /**
9  * Math operations with safety checks
10  */
11 library SafeMath {
12   function mul(uint a, uint b) internal returns (uint) {
13     uint c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint a, uint b) internal returns (uint) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint a, uint b) internal returns (uint) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint a, uint b) internal returns (uint) {
31     uint c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 
36   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a >= b ? a : b;
38   }
39 
40   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
41     return a < b ? a : b;
42   }
43 
44   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a >= b ? a : b;
46   }
47 
48   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a < b ? a : b;
50   }
51 
52   function assert(bool assertion) internal {
53     if (!assertion) {
54       throw;
55     }
56   }
57 }
58 
59 
60 /**
61  * @title ERC20Basic
62  * @dev Simpler version of ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20Basic {
66   uint public totalSupply;
67   function balanceOf(address who) constant returns (uint);
68   function transfer(address to, uint value);
69   event Transfer(address indexed from, address indexed to, uint value);
70 }
71 
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint;
79 
80   mapping(address => uint) balances;
81 
82   /**
83    * @dev Fix for the ERC20 short address attack.
84    */
85   modifier onlyPayloadSize(uint size) {
86      if(msg.data.length < size + 4) {
87        throw;
88      }
89      _;
90   }
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
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
146     var _allowance = allowed[_from][msg.sender];
147 
148     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
149     // if (_value > _allowance) throw;
150 
151     balances[_to] = balances[_to].add(_value);
152     balances[_from] = balances[_from].sub(_value);
153     allowed[_from][msg.sender] = _allowance.sub(_value);
154     Transfer(_from, _to, _value);
155   }
156 
157   /**
158    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint _value) {
163 
164     // To change the approve amount you first have to reduce the addresses`
165     //  allowance to zero by calling `approve(_spender, 0)` if it is not
166     //  already 0 to mitigate the race condition described here:
167     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
169 
170     allowed[msg.sender][_spender] = _value;
171     Approval(msg.sender, _spender, _value);
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens than an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint specifing the amount of tokens still avaible for the spender.
179    */
180   function allowance(address _owner, address _spender) constant returns (uint remaining) {
181     return allowed[_owner][_spender];
182   }
183 
184 }
185 
186 
187 /**
188  * @title Ownable
189  * @dev The Ownable contract has an owner address, and provides basic authorization control
190  * functions, this simplifies the implementation of "user permissions".
191  */
192 contract Ownable {
193   address public owner;
194 
195 
196   /**
197    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
198    * account.
199    */
200   function Ownable() {
201     owner = msg.sender;
202   }
203 
204 
205   /**
206    * @dev Throws if called by any account other than the owner.
207    */
208   modifier onlyOwner() {
209     if (msg.sender != owner) {
210       throw;
211     }
212     _;
213   }
214 
215 
216   /**
217    * @dev Allows the current owner to transfer control of the contract to a newOwner.
218    * @param newOwner The address to transfer ownership to.
219    */
220   function transferOwnership(address newOwner) onlyOwner {
221     if (newOwner != address(0)) {
222       owner = newOwner;
223     }
224   }
225 
226 }
227 /**
228  * @title Pausable
229  * @dev Base contract which allows children to implement an emergency stop mechanism.
230  */
231 contract Pausable is Ownable {
232   event Pause();
233   event Unpause();
234 
235   bool public paused = false;
236 
237 
238   /**
239    * @dev modifier to allow actions only when the contract IS paused
240    */
241   modifier whenNotPaused() {
242     if (paused) throw;
243     _;
244   }
245 
246   /**
247    * @dev modifier to allow actions only when the contract IS NOT paused
248    */
249   modifier whenPaused {
250     if (!paused) throw;
251     _;
252   }
253 
254   /**
255    * @dev called by the owner to pause, triggers stopped state
256    */
257   function pause() onlyOwner whenNotPaused returns (bool) {
258     paused = true;
259     Pause();
260     return true;
261   }
262 
263   /**
264    * @dev called by the owner to unpause, returns to normal state
265    */
266   function unpause() onlyOwner whenPaused returns (bool) {
267     paused = false;
268     Unpause();
269     return true;
270   }
271 }
272 
273 
274 /**
275  * Pausable token
276  *
277  * Simple ERC20 Token example, with pausable token creation
278  **/
279 
280 contract PausableToken is StandardToken, Pausable {
281 
282   function transfer(address _to, uint _value) whenNotPaused {
283     super.transfer(_to, _value);
284   }
285 
286   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
287     super.transferFrom(_from, _to, _value);
288   }
289 }
290 
291 
292 contract FCTToken is PausableToken {
293   using SafeMath for uint256;  
294   string public name = "FCT";
295   string public symbol = "FCT";
296   uint public decimals = 18;
297   function FCTToken(){
298 	totalSupply = 1400000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
299     balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
300 	Transfer(address(0x0), msg.sender, totalSupply);
301   }
302 
303 }