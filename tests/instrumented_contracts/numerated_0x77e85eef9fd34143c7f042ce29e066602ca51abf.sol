1 pragma solidity  ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * Based on SafeMath.sol from https://github.com/OpenZeppelin/zeppelin-solidity/tree/master
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21  
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 pragma solidity  ^0.4.18;
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  * Based on Ownable.sol from https://github.com/OpenZeppelin/zeppelin-solidity/tree/master
41  */
42 contract Ownable {
43   address public owner;
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) public onlyOwner returns (bool) {
68     require(newOwner != address(0));
69     owner = newOwner;
70     OwnershipTransferred(owner, newOwner);
71     return true;
72   }
73 
74 }
75 
76 pragma solidity  ^0.4.18;
77 
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85   function totalSupply() public view returns (uint256);
86   function balanceOf(address who) public view returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 pragma solidity  ^0.4.18;
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances.
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99   
100   // mapping of addresses with according balances
101   mapping(address => uint256) balances;
102 
103   uint256 public totalSupply;
104 
105   /**
106   * @dev Gets the totalSupply.
107   * @return An uint256 representing the total supply of tokens.
108   */
109   function totalSupply() public view returns (uint256) {
110     return totalSupply;
111   } 
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 pragma solidity  ^0.4.18;
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) public view returns (uint256);
132   function transferFrom(address from, address to, uint256 value) public returns (bool);
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 pragma solidity  ^0.4.18;
138 
139 /**
140  * @title Custom ERC20 token
141  *
142  * @dev Implementation and upgraded version of the basic standard token.
143  */
144 contract CustomToken is ERC20, BasicToken, Ownable {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148   // boolean if transfers can be done
149   bool public enableTransfer = true;
150 
151   /**
152    * @dev Modifier to make a function callable only when the contract is not paused.
153    */
154   modifier whenTransferEnabled() {
155     require(enableTransfer);
156     _;
157   }
158 
159   event Burn(address indexed burner, uint256 value);
160   event EnableTransfer(address indexed owner, uint256 timestamp);
161   event DisableTransfer(address indexed owner, uint256 timestamp);
162 
163   
164   /**
165   * @dev transfer token for a specified address
166   * @param _to The address to transfer to.
167   * @param _value The amount to be transferred.
168   */
169   function transfer(address _to, uint256 _value) whenTransferEnabled public returns (bool) {
170     require(_to != address(0));
171     require(_value <= balances[msg.sender]);
172 
173     // SafeMath.sub will throw if there is not enough balance.
174     balances[msg.sender] = balances[msg.sender].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     Transfer(msg.sender, _to, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    * The owner can transfer tokens at will. This to implement a reward pool contract in a later phase 
186    * that will transfer tokens for rewarding.
187    */
188   function transferFrom(address _from, address _to, uint256 _value) whenTransferEnabled public returns (bool) {
189     require(_to != address(0));
190     require(_value <= balances[_from]);
191 
192 
193     if (msg.sender!=owner) {
194       require(_value <= allowed[_from][msg.sender]);
195       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196       balances[_from] = balances[_from].sub(_value);
197       balances[_to] = balances[_to].add(_value);
198     }  else {
199       balances[_from] = balances[_from].sub(_value);
200       balances[_to] = balances[_to].add(_value);
201     }
202 
203     Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    *
210    * @param _spender The address which will spend the funds.
211    * @param _value The amount of tokens to be spent.
212    */
213   function approve(address _spender, uint256 _value) whenTransferEnabled public returns (bool) {
214     // To change the approve amount you first have to reduce the addresses`
215     //  allowance to zero by calling `approve(_spender,0)` if it is not
216     //  already 0 to mitigate the race condition described here:
217     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
219     
220     allowed[msg.sender][_spender] = _value;
221     Approval(msg.sender, _spender, _value);
222     return true;
223   }
224 
225   /* Approves and then calls the receiving contract */
226   function approveAndCallAsContract(address _spender, uint256 _value, bytes _extraData) onlyOwner public returns (bool success) {
227     // check if the _spender already has some amount approved else use increase approval.
228     // maybe not for exchanges
229     //require((_value == 0) || (allowed[this][_spender] == 0));
230 
231     allowed[this][_spender] = _value;
232     Approval(this, _spender, _value);
233 
234     //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
235     //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
236     //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
237     require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), this, _value, this, _extraData));
238     return true;
239   }
240 
241   /* 
242    * Approves and then calls the receiving contract 
243    */
244   function approveAndCall(address _spender, uint256 _value, bytes _extraData) whenTransferEnabled public returns (bool success) {
245     // check if the _spender already has some amount approved else use increase approval.
246     // maybe not for exchanges
247     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
248 
249     allowed[msg.sender][_spender] = _value;
250     Approval(msg.sender, _spender, _value);
251 
252     //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
253     //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
254     //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
255     require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
256     return true;
257   }
258 
259   /**
260    * @dev Function to check the amount of tokens that an owner allowed to a spender.
261    * @param _owner address The address which owns the funds.
262    * @param _spender address The address which will spend the funds.
263    * @return A uint256 specifying the amount of tokens still available for the spender.
264    */
265   function allowance(address _owner, address _spender) public view returns (uint256) {
266     return allowed[_owner][_spender];
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * @param _spender The address which will spend the funds.
276    * @param _addedValue The amount of tokens to increase the allowance by.
277    */
278   function increaseApproval(address _spender, uint _addedValue) whenTransferEnabled public returns (bool) {
279     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
280     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284   /**
285    * @dev Decrease the amount of tokens that an owner allowed to a spender.
286    *
287    * approve should be called when allowed[_spender] == 0. To decrement
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * @param _spender The address which will spend the funds.
291    * @param _subtractedValue The amount of tokens to decrease the allowance by.
292    */
293   function decreaseApproval(address _spender, uint _subtractedValue) whenTransferEnabled public returns (bool) {
294     uint oldValue = allowed[msg.sender][_spender];
295     if (_subtractedValue > oldValue) {
296       allowed[msg.sender][_spender] = 0;
297     } else {
298       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299     }
300     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304 
305   /**
306    * @dev Burns a specific amount of tokens.
307    * @param _value The amount of token to be burned.
308    */
309   function burn(address _burner, uint256 _value) onlyOwner public returns (bool) {
310     require(_value <= balances[_burner]);
311     // no need to require value <= totalSupply, since that would imply the
312     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
313 
314     balances[_burner] = balances[_burner].sub(_value);
315     totalSupply = totalSupply.sub(_value);
316     Burn(_burner, _value);
317     return true;
318   }
319    /**
320    * @dev called by the owner to enable transfers
321    */
322   function enableTransfer() onlyOwner public returns (bool) {
323     enableTransfer = true;
324     EnableTransfer(owner, now);
325     return true;
326   }
327 
328   /**
329    * @dev called by the owner to disable tranfers
330    */
331   function disableTransfer() onlyOwner whenTransferEnabled public returns (bool) {
332     enableTransfer = false;
333     DisableTransfer(owner, now);
334     return true;
335   }
336 }
337 
338 
339 pragma solidity  ^0.4.18;
340  
341 /**
342  * @title Identify token
343  * @dev ERC20 compliant token, where all tokens are pre-assigned to the token contract.
344  * Note they can later distribute these tokens as they wish using `transfer` and other
345  * `StandardToken` functions.
346  */
347 contract Identify is CustomToken {
348 
349   string public constant name = "IDENTIFY";
350   string public constant symbol = "IDF"; 
351   uint8 public constant decimals = 6;
352 
353   uint256 public constant INITIAL_SUPPLY = 49253333333 * (10 ** uint256(decimals));
354 
355   /**
356    * @dev Constructor that gives the token contract all of initial tokens.
357    */
358   function Identify() public {
359     totalSupply = INITIAL_SUPPLY;
360     balances[this] = INITIAL_SUPPLY;
361     Transfer(0x0, this, INITIAL_SUPPLY);
362   }
363 
364 }