1 pragma solidity 0.4.21;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 /**
31  * @dev The "SCHTSub" contract is the interface declaration of a Sub-Contract that is paired with this current instance of the Master Contract.
32  */
33 contract SCHTSub {
34   function changeStage(uint256 stageCapValue) public;
35   function transfer(address _to, uint256 _value, address origin) public returns (bool);
36   function transferFromTo(address _from, address _to, uint256 _value, address origin) public returns (bool);
37   function transferFrom(address _from, address _to, uint256 _value, address origin) public returns (bool);
38   function approve(address _spender, uint256 _value, address origin) public returns (bool);
39   function increaseApproval(address _spender, uint256 _addedValue, address origin) public returns (bool);
40   function decreaseApproval(address _spender, uint256 _subtractedValue, address origin) public returns (bool);
41 }
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49   address public ctOwner;
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == ctOwner);
57     _;
58   }
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
62    */
63   function Ownable() public {
64     ctOwner = msg.sender;
65   }
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) public onlyOwner {
72     require(newOwner != address(0));
73     emit OwnershipTransferred(ctOwner, newOwner);
74     ctOwner = newOwner;
75   }
76 }
77 
78 contract SubRule is Ownable {
79   address public subContractAddr;
80 
81   function setSubContractAddr(address _newSubAddr) public onlyOwner {
82     subContractAddr = _newSubAddr;
83   }
84 
85   /**
86    * @dev Throws if called by any contract other than the Sub-Contract address that has been set.
87    */
88   modifier onlySubContract() {
89     require(msg.sender == subContractAddr);
90     _;
91   }
92 }
93 
94 /**
95  * @title Destructible
96  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
97  */
98 contract Destructible is SubRule {
99 
100   function Destructible() public payable { }
101 
102   /**
103    * @dev Transfers the current balance to the owner and terminates the contract.
104    */
105   function destroy() onlyOwner public {
106     selfdestruct(ctOwner);
107   }
108 
109   /**
110    * @dev Transfers the current balance to the _recipient address and terminates the contract.
111    */
112   function destroyAndSend(address _recipient) onlyOwner public {
113     selfdestruct(_recipient);
114   }
115 }
116 
117 /**
118  * @title Capable
119  * @dev The Capable contract has a cap value for each stage of the token Sale, Only set/reset by owner.
120  */
121 contract Capable is Destructible {
122   using SafeMath for uint256;
123   uint256 saleStage;
124   uint256 currentStageSpent;
125   uint256 currentStageCap;
126 
127   event StageChanged(uint256 indexed previousStage, uint256 indexed newStage);
128 
129   function getCurrentStage() public view returns (uint256) {
130     return saleStage;
131   }
132 
133   function getCurrentStageSpent() public view returns (uint256) {
134     return currentStageSpent;
135   }
136 
137   function getCurrentRemainingCap() public view returns (uint256) {
138     return currentStageCap.sub(currentStageSpent);
139   }
140 
141   function getCurrentCap() public view returns (uint256) {
142     return currentStageCap;
143   }
144 
145   function setCurrentStageSpent(uint256 _value) public onlySubContract {
146     currentStageSpent = _value;
147   }
148 
149   function setCurrentCap(uint256 _value) public onlySubContract {
150     currentStageCap = _value;
151   }
152 
153   function incrementStage() public onlySubContract {
154     saleStage = saleStage+1;
155   }
156 
157   function changeStage(uint256 stageCapValue) public onlyOwner returns (bool){
158     SCHTSub sc = SCHTSub(subContractAddr);
159     sc.changeStage(stageCapValue);
160     emit StageChanged(saleStage-1, saleStage);
161     return true;
162   }
163 }
164 
165 /**
166  * @title ERC20Basic interface
167  */
168 contract ERC20Basic {
169   function totalSupply() public view returns (uint256);
170   function balanceOf(address who) public view returns (uint256);
171   function transfer(address to, uint256 value) public returns (bool);
172   function transferFromTo(address from, address to, uint256 value) public returns (bool);
173   event Transfer(address indexed from, address indexed to, uint256 value);
174 }
175 
176 /**
177  * @title BasicToken
178  */
179 contract BasicToken is ERC20Basic, Capable {
180   mapping(address => uint256) balances;
181   mapping(address => address) addrIndex;
182 
183   uint256 totalSupply_;
184   uint256 totalSpent_;
185 
186   /**
187   * @dev total number of tokens in existence
188   */
189   function totalSupply() public view returns (uint256) {
190     return totalSupply_;
191   }
192 
193    /**
194   * @dev total number of tokens spent in sale stages
195   */
196   function getTotalSpent() public view returns (uint256) {
197     return totalSpent_;
198   }
199 
200 
201   /**
202   * @dev transfer token for a specified address
203   * @param _to The address to transfer to.
204   * @param _value The amount to be transferred.
205   */
206   function transfer(address _to, uint256 _value) public returns (bool) {
207     SCHTSub sc = SCHTSub(subContractAddr);
208     bool result = sc.transfer(_to, _value, msg.sender);
209     emit Transfer(msg.sender, _to, _value);
210     return result;
211   }
212 
213   /**
214   * @dev transfer token for a specified address
215   * @param _from The address to transfer from.
216   * @param _to The address to transfer to.
217   * @param _value The amount to be transferred.
218   */
219   function transferFromTo(address _from, address _to, uint256 _value) public returns (bool) {
220     SCHTSub sc = SCHTSub(subContractAddr);
221     bool result = sc.transferFromTo(_from, _to, _value, msg.sender);
222     emit Transfer(_from, _to, _value);
223     return result;
224   }
225 
226   /**
227   * @dev Gets the balance of the specified address.
228   * @param _owner The address to query the the balance of.
229   * @return An uint256 representing the amount owned by the passed address.
230   */
231   function balanceOf(address _owner) public view returns (uint256 balance) {
232     return balances[_owner];
233   }
234 
235   function setBalanceForAddr( address _addr, uint256 _value) public onlySubContract {
236     balances[_addr] = _value;
237   }
238 
239    function setTotalSpent(uint256 _value) public onlySubContract {
240     totalSpent_=_value;
241   }
242 
243   function addAddrToIndex(address _addr) public onlySubContract {
244     if(!isAddrExists(_addr)){
245       addrIndex[_addr] = _addr;
246     }
247   }
248 
249   function isAddrExists(address _addr) public view returns (bool) {
250     return (_addr == addrIndex[_addr]);
251   }
252 }
253 
254 /**
255  * @title BurnableToken
256  * @dev Token that can be irreversibly burned (destroyed).
257  */
258 contract BurnableToken is BasicToken {
259 
260   event Burn(address indexed burner, uint256 value);
261 
262   /**
263    * @dev Burns a specific amount of tokens.
264    * @param _value The amount of token to be burned.
265    */
266   function burn(uint256 _value) public onlyOwner {
267     require(_value <= balances[msg.sender]);
268     address burner = msg.sender;
269     balances[burner] = balances[burner].sub(_value);
270     totalSupply_ = totalSupply_.sub(_value);
271     emit Burn(burner, _value);
272     emit Transfer(burner, address(0), _value);
273   }
274 }
275 
276 /**
277  * @title ERC20 interface
278  */
279 contract ERC20 is ERC20Basic {
280   event Approval(address indexed owner, address indexed spender, uint256 value);
281   function approve(address spender, uint256 value) public returns (bool);
282   function allowance(address owner, address spender) public view returns (uint256);
283   function transferFrom(address from, address to, uint256 value) public returns (bool);
284 }
285 
286 /**
287  * @title Standard ERC20 token
288  * @dev Implementation of the basic standard token.
289  */
290 contract StandardToken is ERC20, BurnableToken {
291 
292   mapping (address => mapping (address => uint256)) internal allowed;
293 
294   function approve(address _spender, uint256 _value) public returns (bool) {
295     SCHTSub sc = SCHTSub(subContractAddr);
296     bool result = sc.approve(_spender,_value, msg.sender);
297     emit Approval(msg.sender, _spender, _value);
298     return result;
299   }
300 
301   /**
302    * @dev Transfer tokens from one address to another
303    * @param _from address The address which you want to send tokens from
304    * @param _to address The address which you want to transfer to
305    * @param _value uint256 the amount of tokens to be transferred
306    */
307   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
308     SCHTSub sc = SCHTSub(subContractAddr);
309     bool result = sc.transferFrom(_from, _to, _value, msg.sender);
310     emit Transfer(_from, _to, _value);
311     return result;
312   }
313 
314   /**
315    * @dev Function to check the amount of tokens that an owner allowed to a spender.
316    * @param _owner address The address which owns the funds.
317    * @param _spender address The address which will spend the funds.
318    * @return A uint256 specifying the amount of tokens still available for the spender.
319    */
320   function allowance(address _owner, address _spender) public view returns (uint256) {
321     return allowed[_owner][_spender];
322   }
323 
324   function setAllowance(address _owner, address _spender, uint256 _value) public onlySubContract returns (bool) {
325     allowed[_owner][_spender] = _value;
326   }
327 
328   /**
329    * @dev Increase the amount of tokens that an owner allowed to a spender.
330    *
331    * approve should be called when allowed[_spender] == 0. To increment
332    * allowed value is better to use this function to avoid 2 calls (and wait until
333    * the first transaction is mined)
334    * From MonolithDAO Token.sol
335    * @param _spender The address which will spend the funds.
336    * @param _addedValue The amount of tokens to increase the allowance by.
337    */
338   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
339     SCHTSub sc = SCHTSub(subContractAddr);
340     bool result = sc.increaseApproval(_spender,_addedValue, msg.sender);
341     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
342     return result;
343   }
344 
345   /**
346    * @dev Decrease the amount of tokens that an owner allowed to a spender.
347    *
348    * approve should be called when allowed[_spender] == 0. To decrement
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _subtractedValue The amount of tokens to decrease the allowance by.
354    */
355   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
356     SCHTSub sc = SCHTSub(subContractAddr);
357     bool result = sc.decreaseApproval(_spender,_subtractedValue,msg.sender);
358     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
359     return result;
360   }
361 }
362 
363 /**
364  * @title SCHToken
365  * All tokens are pre-assigned to the creator.
366  */
367 
368 contract SCHToken is StandardToken {
369 
370   string public constant name = "SCHToken";
371   string public constant symbol = "SCHT";
372   uint8 public constant decimals = 18;
373 
374   uint256 public constant INITIAL_SUPPLY = 400000000 * (10 ** uint256(decimals));
375 
376   /**
377    * @dev Constructor that gives msg.sender all of existing tokens
378    * Defines stages and Stage Caps.
379    */
380   function SCHToken() public {
381     totalSupply_ = INITIAL_SUPPLY;
382     totalSpent_ = 0;
383     balances[msg.sender] = INITIAL_SUPPLY;
384     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
385 
386     saleStage = 0;
387     currentStageSpent = 0;
388     currentStageCap = 0;
389   }
390 }