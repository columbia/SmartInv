1 pragma solidity ^0.4.18;
2 
3 contract TokenRecipient {
4   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
5 }
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   uint256 public totalSupply;
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 /**
53  * @title Basic token
54  * @dev Basic version of StandardToken, with no allowances.
55  */
56 contract BasicToken is ERC20Basic {
57   using SafeMath for uint256;
58 
59   mapping(address => uint256) balances;
60 
61   /**
62   * @dev transfer token for a specified address
63   * @param _to The address to transfer to.
64   * @param _value The amount to be transferred.
65   */
66   function transfer(address _to, uint256 _value) public returns (bool) {
67     require(_to != address(0));
68     require(_value <= balances[msg.sender]);
69 
70     // SafeMath.sub will throw if there is not enough balance.
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   /**
78   * @dev Gets the balance of the specified address.
79   * @param _owner The address to query the the balance of.
80   * @return An uint256 representing the amount owned by the passed address.
81   */
82   function balanceOf(address _owner) public view returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86 }
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * @dev https://github.com/ethereum/EIPs/issues/20
104  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
105  */
106 contract StandardToken is ERC20, BasicToken {
107 
108   mapping (address => mapping (address => uint256)) internal allowed;
109 
110 
111   /**
112    * @dev Transfer tokens from one address to another
113    * @param _from address The address which you want to send tokens from
114    * @param _to address The address which you want to transfer to
115    * @param _value uint256 the amount of tokens to be transferred
116    */
117   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    *
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public view returns (uint256) {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156    * @dev Increase the amount of tokens that an owner allowed to a spender.
157    *
158    * approve should be called when allowed[_spender] == 0. To increment
159    * allowed value is better to use this function to avoid 2 calls (and wait until
160    * the first transaction is mined)
161    * From MonolithDAO Token.sol
162    * @param _spender The address which will spend the funds.
163    * @param _addedValue The amount of tokens to increase the allowance by.
164    */
165   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
166     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   /**
172    * @dev Decrease the amount of tokens that an owner allowed to a spender.
173    *
174    * approve should be called when allowed[_spender] == 0. To decrement
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    * @param _spender The address which will spend the funds.
179    * @param _subtractedValue The amount of tokens to decrease the allowance by.
180    */
181   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
182     uint oldValue = allowed[msg.sender][_spender];
183     if (_subtractedValue > oldValue) {
184       allowed[msg.sender][_spender] = 0;
185     } else {
186       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187     }
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192 }
193 
194 contract ApproveAndCallToken is StandardToken {
195   function approveAndCall(address _spender, uint _value, bytes _data) public returns (bool) {
196     TokenRecipient spender = TokenRecipient(_spender);
197     if (approve(_spender, _value)) {
198       spender.receiveApproval(msg.sender, _value, this, _data);
199       return true;
200     }
201     return false;
202   }
203 
204   // ERC223 Token improvement to send tokens to smart-contracts
205   function transfer(address _to, uint _value) public returns (bool success) { 
206     //standard function transfer similar to ERC20 transfer with no _data
207     //added due to backwards compatibility reasons
208     bytes memory empty;
209     if (isContract(_to)) {
210         return transferToContract(_to, _value, empty);
211     }
212     else {
213         return super.transfer(_to, _value);
214     }
215   }
216 
217   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
218   function isContract(address _addr) private view returns (bool) {
219     uint length;
220     assembly {
221       //retrieve the size of the code on target address, this needs assembly
222       length := extcodesize(_addr)
223     }
224     return (length>0);
225   }
226 
227   //function that is called when transaction target is a contract
228   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
229     return approveAndCall(_to, _value, _data);
230   }
231 }
232 
233 contract UserRegistryInterface {
234   event AddAddress(address indexed who);
235   event AddIdentity(address indexed who);
236 
237   function knownAddress(address _who) public constant returns(bool);
238   function hasIdentity(address _who) public constant returns(bool);
239   function systemAddresses(address _to, address _from) public constant returns(bool);
240 }
241 
242 /**
243  * @title Ownable
244  * @dev The Ownable contract has an owner address, and provides basic authorization control
245  * functions, this simplifies the implementation of "user permissions".
246  */
247 contract Ownable {
248   address public owner;
249 
250 
251   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253 
254   /**
255    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
256    * account.
257    */
258   function Ownable() public {
259     owner = msg.sender;
260   }
261 
262 
263   /**
264    * @dev Throws if called by any account other than the owner.
265    */
266   modifier onlyOwner() {
267     require(msg.sender == owner);
268     _;
269   }
270 
271 
272   /**
273    * @dev Allows the current owner to transfer control of the contract to a newOwner.
274    * @param newOwner The address to transfer ownership to.
275    */
276   function transferOwnership(address newOwner) public onlyOwner {
277     require(newOwner != address(0));
278     OwnershipTransferred(owner, newOwner);
279     owner = newOwner;
280   }
281 
282 }
283 
284 contract TokenPolicy is StandardToken, Ownable {
285   bool public unfrozen;
286   UserRegistryInterface public userRegistry;
287 
288   function TokenPolicy(address registry) public {
289     require(registry != 0x0);
290     userRegistry = UserRegistryInterface(registry);
291   }
292 
293   event Unfrezee();
294 
295   modifier shouldPassPolicy(address _from, address _to) {
296     // KYC policy
297     require(
298       !userRegistry.knownAddress(_from) || 
299        userRegistry.hasIdentity(_from) || 
300        userRegistry.systemAddresses(_to, _from));
301 
302     // Freeze policy
303     require(unfrozen || userRegistry.systemAddresses(_to, _from));
304 
305     _;
306   }
307   function transfer(address _to, uint256 _value) shouldPassPolicy(msg.sender, _to) public returns (bool) {
308     return super.transfer(_to, _value);
309   }
310 
311   function transferFrom(address _from, address _to, uint256 _value) shouldPassPolicy(_from, _to) public returns (bool) {
312     return super.transferFrom(_from, _to, _value);
313   }
314 
315   function unfrezee() onlyOwner public returns (bool) {
316     require(!unfrozen);
317     unfrozen = true;
318   }
319 }
320 
321 /**
322  * @title Mintable token
323  * @dev Simple ERC20 Token example, with mintable token creation
324  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
325  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
326  */
327 
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   /**
341    * @dev Function to mint tokens
342    * @param _to The address that will receive the minted tokens.
343    * @param _amount The amount of tokens to mint.
344    * @return A boolean that indicates if the operation was successful.
345    */
346   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
347     totalSupply = totalSupply.add(_amount);
348     balances[_to] = balances[_to].add(_amount);
349     Mint(_to, _amount);
350     Transfer(address(0), _to, _amount);
351     return true;
352   }
353 
354   /**
355    * @dev Function to stop minting new tokens.
356    * @return True if the operation was successful.
357    */
358   function finishMinting() onlyOwner canMint public returns (bool) {
359     mintingFinished = true;
360     MintFinished();
361     return true;
362   }
363 }
364 
365 contract DefaultToken is MintableToken, TokenPolicy, ApproveAndCallToken {
366   using SafeMath for uint;
367 
368   string public name;
369   string public ticker;
370   uint public decimals;
371   
372   function DefaultToken(string _name, string _ticker, uint _decimals, address _registry) 
373     ApproveAndCallToken()
374     MintableToken()
375     TokenPolicy(_registry) public {
376     name = _name;
377     ticker = _ticker;
378     decimals = _decimals;
379   }
380 
381   function takeAway(address _holder, address _to) onlyOwner public returns (bool) {
382     require(userRegistry.knownAddress(_holder) && !userRegistry.hasIdentity(_holder));
383 
384     uint allBalance = balances[_holder];
385     balances[_to] = balances[_to].add(allBalance);
386     balances[_holder] = 0;
387     
388     Transfer(_holder, _to, allBalance);
389   }
390 }
391 
392 contract AltToken is DefaultToken {
393   function AltToken(address _registry) DefaultToken("AltEstate token", "ALT", 18, _registry) public {
394   }
395 }