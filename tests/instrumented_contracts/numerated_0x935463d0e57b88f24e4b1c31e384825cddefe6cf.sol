1 pragma solidity ^0.4.23;
2 
3 /**xxp
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 
45   function allowance(address owner, address spender) public constant returns (uint256);
46   function transferFrom(address from, address to, uint256 value) public returns (bool);
47   function approve(address spender, uint256 value) public returns (bool);
48   event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   constructor() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) onlyOwner public {
82     require(newOwner != address(0));
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20Basic {
97 
98   using SafeMath for uint256;
99 
100   mapping (address => mapping (address => uint256)) internal allowed;
101   // store tokens
102   mapping(address => uint256) balances;
103   // uint256 public totalSupply;
104 
105   /**
106   * @dev transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[msg.sender]);
113 
114     // SafeMath.sub will throw if there is not enough balance.
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     emit Transfer(msg.sender, _to, _value);
118     return true;
119   }
120   
121    /**
122     *batch transfer token for a list of specified addresses
123     * @param _toList The list of addresses to transfer to.
124     * @param _tokensList The list of amount to be transferred.
125     */
126   function batchTransfer(address[] _toList, uint256[] _tokensList) public  returns (bool) {
127       require(_toList.length <= 100);
128       require(_toList.length == _tokensList.length);
129       
130       uint256 sum = 0;
131       for (uint32 index = 0; index < _tokensList.length; index++) {
132           sum = sum.add(_tokensList[index]);
133       }
134 
135       // if the sender doenst have enough balance then stop
136       require (balances[msg.sender] >= sum);
137         
138       for (uint32 i = 0; i < _toList.length; i++) {
139           transfer(_toList[i],_tokensList[i]);
140       }
141       return true;
142   }
143 
144   /**
145   * @dev Gets the balance of the specified address.
146   * @param _owner The address to query the the balance of.
147   * @return An uint256 representing the amount owned by the passed address.
148   */
149   function balanceOf(address _owner) public constant returns (uint256 balance) {
150     return balances[_owner];
151   }
152 
153 
154   /**
155    * @dev Transfer tokens from one address to another
156    * @param _from address The address which you want to send tokens from
157    * @param _to address The address which you want to transfer to
158    * @param _value uint256 the amount of tokens to be transferred
159    */
160   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
161     require(_to != address(0));
162     require(_value <= balances[_from]);
163     require(_value <= allowed[_from][msg.sender]);
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168     emit Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    *
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     emit Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
195     return allowed[_owner][_spender];
196   }
197 }
198 
199 /**
200  * @title Burnable Token
201  * @dev Token that can be irreversibly burned (destroyed).
202  */
203 contract BurnableToken is StandardToken {
204 
205     event Burn(address indexed burner, uint256 value);
206 
207     /**
208      * @dev Burns a specific amount of tokens.
209      * @param _value The amount of token to be burned.
210      */
211     function burn(uint256 _value) public {
212         require(_value > 0);
213         require(_value <= balances[msg.sender]);
214         // no need to require value <= totalSupply, since that would imply the
215         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
216 
217         address burner = msg.sender;
218         balances[burner] = balances[burner].sub(_value);
219         totalSupply = totalSupply.sub(_value);
220         emit Burn(burner, _value);
221     }
222 }
223 
224 /**
225  * @title Mintable token
226  * @dev Simple ERC20 Token example, with mintable token creation
227  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
228  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
229  */
230 
231 contract MintableToken is StandardToken, Ownable {
232   event Mint(address indexed to, uint256 amount);
233   event MintFinished();
234 
235   bool public mintingFinished = false;
236 
237 
238   modifier canMint() {
239     require(!mintingFinished);
240     _;
241   }
242 
243   /**
244    * @dev Function to mint tokens
245    * @param _to The address that will receive the minted tokens.
246    * @param _amount The amount of tokens to mint.
247    * @return A boolean that indicates if the operation was successful.
248    */
249   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
250     totalSupply = totalSupply.add(_amount);
251     balances[_to] = balances[_to].add(_amount);
252     emit Mint(_to, _amount);
253     emit Transfer(0x0, _to, _amount);
254     return true;
255   }
256 
257   /**
258    * @dev Function to stop minting new tokens.
259    * @return True if the operation was successful.
260    */
261   function finishMinting() onlyOwner public returns (bool) {
262     mintingFinished = true;
263     emit MintFinished();
264     return true;
265   }
266 }
267 
268 /**
269  * @title Pausable
270  * @dev Base contract which allows children to implement an emergency stop mechanism.
271  */
272 contract Pausable is Ownable {
273   event Pause();
274   event Unpause();
275 
276   bool public paused = false;
277 
278 
279   /**
280    * @dev Modifier to make a function callable only when the contract is not paused.
281    */
282   modifier whenNotPaused() {
283     require(!paused);
284     _;
285   }
286 
287   /**
288    * @dev Modifier to make a function callable only when the contract is paused.
289    */
290   modifier whenPaused() {
291     require(paused);
292     _;
293   }
294 
295   /**
296    * @dev called by the owner to pause, triggers stopped state
297    */
298   function pause() onlyOwner whenNotPaused public {
299     paused = true;
300     emit Pause();
301   }
302 
303   /**
304    * @dev called by the owner to unpause, returns to normal state
305    */
306   function unpause() onlyOwner whenPaused public {
307     paused = false;
308     emit Unpause();
309   }
310 }
311 
312 /**
313  * @title Pausable token
314  *
315  * @dev StandardToken modified with pausable transfers.
316  **/
317 
318 contract PausableToken is StandardToken, Pausable {
319 
320   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
321     return super.transfer(_to, _value);
322   }
323   
324   function batchTransfer(address[] _toList, uint256[] _tokensList) public whenNotPaused returns (bool) {
325       return super.batchTransfer(_toList, _tokensList);
326   }
327 
328   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
329     return super.transferFrom(_from, _to, _value);
330   }
331 
332   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
333     return super.approve(_spender, _value);
334   }
335 }
336 
337 /*
338  * @title DELCToken
339  */
340 contract DELCToken is BurnableToken, MintableToken, PausableToken {
341   // Public variables of the token
342   string public name;
343   string public symbol;
344   // ��ͬ��Wei�ĸ���,  decimals is the strongly suggested default, avoid changing it
345   uint8 public decimals;
346 
347   constructor() public {
348     name = "DELC Token";
349     symbol = "DELC";
350     decimals = 18;
351     totalSupply = 10000000000 * 10 ** uint256(decimals);
352 
353     // Allocate initial balance to the owner
354     balances[msg.sender] = totalSupply;
355   }
356 
357   // transfer balance to owner
358   //function withdrawEther() onlyOwner public {
359   //    owner.transfer(this.balance);
360   //}
361 
362   // can accept ether
363   //function() payable public {
364   //}
365 }