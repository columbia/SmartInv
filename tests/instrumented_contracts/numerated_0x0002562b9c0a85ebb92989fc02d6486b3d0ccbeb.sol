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
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) constant returns (uint balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) constant returns (uint);
117   function transferFrom(address from, address to, uint value);
118   function approve(address spender, uint value);
119   event Approval(address indexed owner, address indexed spender, uint value);
120 }
121 
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implemantation of the basic standart token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  */
129 contract StandardToken is BasicToken, ERC20 {
130 
131   mapping (address => mapping (address => uint)) allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint the amout of tokens to be transfered
139    */
140   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
141     var _allowance = allowed[_from][msg.sender];
142 
143     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
144     // if (_value > _allowance) throw;
145 
146     balances[_to] = balances[_to].add(_value);
147     balances[_from] = balances[_from].sub(_value);
148     allowed[_from][msg.sender] = _allowance.sub(_value);
149     Transfer(_from, _to, _value);
150   }
151 
152   /**
153    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint _value) {
158 
159     // To change the approve amount you first have to reduce the addresses`
160     //  allowance to zero by calling `approve(_spender, 0)` if it is not
161     //  already 0 to mitigate the race condition described here:
162     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
164 
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167   }
168 
169   /**
170    * @dev Function to check the amount of tokens than an owner allowed to a spender.
171    * @param _owner address The address which owns the funds.
172    * @param _spender address The address which will spend the funds.
173    * @return A uint specifing the amount of tokens still avaible for the spender.
174    */
175   function allowance(address _owner, address _spender) constant returns (uint remaining) {
176     return allowed[_owner][_spender];
177   }
178 
179 }
180 
181 
182 /**
183  * @title Ownable
184  * @dev The Ownable contract has an owner address, and provides basic authorization control
185  * functions, this simplifies the implementation of "user permissions".
186  */
187 contract Ownable {
188   address public owner;
189 
190 
191   /**
192    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193    * account.
194    */
195   function Ownable() {
196     owner = msg.sender;
197   }
198 
199 
200   /**
201    * @dev Throws if called by any account other than the owner.
202    */
203   modifier onlyOwner() {
204     if (msg.sender != owner) {
205       throw;
206     }
207     _;
208   }
209 
210 
211   /**
212    * @dev Allows the current owner to transfer control of the contract to a newOwner.
213    * @param newOwner The address to transfer ownership to.
214    */
215   function transferOwnership(address newOwner) onlyOwner {
216     if (newOwner != address(0)) {
217       owner = newOwner;
218     }
219   }
220 
221 }
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
277   function transfer(address _to, uint _value) whenNotPaused {
278     super.transfer(_to, _value);
279   }
280 
281   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
282     super.transferFrom(_from, _to, _value);
283   }
284 }
285 
286 
287 
288 contract DMAToken is PausableToken {
289   using SafeMath for uint256;  
290   string public name = "DataMiningAlliance";
291   string public symbol = "DMA";
292   uint public decimals = 8;
293   function DMAToken(){
294 	totalSupply = 500000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
295     balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
296 	Transfer(address(0x0), msg.sender, totalSupply);
297   }
298 
299 }