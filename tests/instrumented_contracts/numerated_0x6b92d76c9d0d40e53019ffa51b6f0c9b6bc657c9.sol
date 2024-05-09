1 pragma solidity ^0.4.19;
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
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     Transfer(msg.sender, _to, _value);
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of.
105   * @return An uint representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) constant returns (uint balance) {
108     return balances[_owner];
109   }
110 }
111 
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) constant returns (uint);
119   function transferFrom(address from, address to, uint value);
120   function approve(address spender, uint value);
121   event Approval(address indexed owner, address indexed spender, uint value);
122 }
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implemantation of the basic standart token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is BasicToken, ERC20 {
133 
134   mapping (address => mapping (address => uint)) allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint the amout of tokens to be transfered
142    */
143   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
144     var _allowance = allowed[_from][msg.sender];
145 
146     if(_to == address(0)) {
147       throw; 
148     }
149     
150     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
151     // if (_value > _allowance) throw;
152 
153     balances[_to] = balances[_to].add(_value);
154     balances[_from] = balances[_from].sub(_value);
155     allowed[_from][msg.sender] = _allowance.sub(_value);
156     Transfer(_from, _to, _value);
157   }
158 
159   /**
160    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint _value) {
165 
166     // To change the approve amount you first have to reduce the addresses`
167     //  allowance to zero by calling `approve(_spender, 0)` if it is not
168     //  already 0 to mitigate the race condition described here:
169     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
171 
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens than an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint specifing the amount of tokens still avaible for the spender.
181    */
182   function allowance(address _owner, address _spender) constant returns (uint remaining) {
183     return allowed[_owner][_spender];
184   }
185 
186 }
187 
188 
189 /**
190  * @title Ownable
191  * @dev The Ownable contract has an owner address, and provides basic authorization control
192  * functions, this simplifies the implementation of "user permissions".
193  */
194 contract Ownable {
195   address public owner;
196 
197 
198   /**
199    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
200    * account.
201    */
202   function Ownable() {
203     owner = msg.sender;
204   }
205 
206 
207   /**
208    * @dev Throws if called by any account other than the owner.
209    */
210   modifier onlyOwner() {
211     if (msg.sender != owner) {
212       throw;
213     }
214     _;
215   }
216 
217 
218   /**
219    * @dev Allows the current owner to transfer control of the contract to a newOwner.
220    * @param newOwner The address to transfer ownership to.
221    */
222   function transferOwnership(address newOwner) onlyOwner {
223     if (newOwner != address(0)) {
224       owner = newOwner;
225     }
226   }
227 }
228 
229 
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
295 /**
296  * @title Equipment Token
297  * @dev Equipment Token contract
298  */
299 contract ETHUToken is PausableToken {
300   using SafeMath for uint256;
301 
302   string public name = "Ethereum Utility";
303   string public symbol = "ETHU";
304   uint public decimals = 8;
305   uint public totalSupply = 2*10**18;
306   
307     function ETHUToken() {
308         balances[msg.sender] = totalSupply;
309         Transfer(address(0), msg.sender, totalSupply);
310     }
311     
312     /**
313      * @dev Function is used to perform a multi-transfer operation. This could play a significant role in the Ammbr Mesh Routing protocol.
314      *  
315      * Mechanics:
316      * Sends tokens from Sender to destinations[0..n] the amount tokens[0..n]. Both arrays
317      * must have the same size, and must have a greater-than-zero length. Max array size is 127.
318      * 
319      * IMPORTANT: ANTIPATTERN
320      * This function performs a loop over arrays. Unless executed in a controlled environment,
321      * it has the potential of failing due to gas running out. This is not dangerous, yet care
322      * must be taken to prevent quality being affected.
323      * 
324      * @param destinations An array of destinations we would be sending tokens to
325      * @param tokens An array of tokens, sent to destinations (index is used for destination->token match)
326      */
327     function multiTransfer(address[] destinations, uint[] tokens) public returns (bool success){
328         // Two variables must match in length, and must contain elements
329         // Plus, a maximum of 127 transfers are supported
330         assert(destinations.length > 0);
331         assert(destinations.length < 128);
332         assert(destinations.length == tokens.length);
333         
334         // Check total requested balance
335         uint8 i = 0;
336         uint totalTokensToTransfer = 0;
337         for (i = 0; i < destinations.length; i++){
338             assert(tokens[i] > 0);
339             totalTokensToTransfer = totalTokensToTransfer.add(tokens[i]);
340         }
341         
342         // We have enough tokens, execute the transfer
343         balances[msg.sender] = balances[msg.sender].sub(totalTokensToTransfer);
344         for (i = 0; i < destinations.length; i++){
345             // Add the token to the intended destination
346             balances[destinations[i]] = balances[destinations[i]].add(tokens[i]);
347             // Call the event...
348             emit Transfer(msg.sender, destinations[i], tokens[i]);
349         }
350         return true;
351     }
352 }