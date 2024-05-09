1 pragma solidity ^0.4.19;
2 
3 /*
4 Created by Cogenero Blockchain Solutions Limited
5 */
6 
7 // File: zeppelin-solidity/contracts/math/SafeMath.sol
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
43 
44 /**
45  * @title Ownable
46  * @dev The Ownable contract has an owner address, and provides basic authorization control
47  * functions, this simplifies the implementation of "user permissions".
48  */
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84 }
85 
86 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
87 
88 /**
89  * @title ERC20Basic
90  * @dev Simpler version of ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/179
92  */
93 contract ERC20Basic {
94   uint256 public totalSupply;
95   function balanceOf(address who) public view returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 // File: zeppelin-solidity/contracts/token/BasicToken.sol
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[msg.sender]);
119 
120     // SafeMath.sub will throw if there is not enough balance.
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256 balance) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 // File: zeppelin-solidity/contracts/token/ERC20.sol
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/20
143  */
144 contract ERC20 is ERC20Basic {
145   function allowance(address owner, address spender) public view returns (uint256);
146   function transferFrom(address from, address to, uint256 value) public returns (bool);
147   function approve(address spender, uint256 value) public returns (bool);
148   event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 // File: zeppelin-solidity/contracts/token/StandardToken.sol
152 
153 /**
154  * @title Standard ERC20 token
155  *
156  * @dev Implementation of the basic standard token.
157  * @dev https://github.com/ethereum/EIPs/issues/20
158  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
159  */
160 contract StandardToken is ERC20, BasicToken {
161 
162   mapping (address => mapping (address => uint256)) internal allowed;
163 
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param _from address The address which you want to send tokens from
168    * @param _to address The address which you want to transfer to
169    * @param _value uint256 the amount of tokens to be transferred
170    */
171   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[_from]);
174     require(_value <= allowed[_from][msg.sender]);
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    *
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(address _owner, address _spender) public view returns (uint256) {
206     return allowed[_owner][_spender];
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
220     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
236     uint oldValue = allowed[msg.sender][_spender];
237     if (_subtractedValue > oldValue) {
238       allowed[msg.sender][_spender] = 0;
239     } else {
240       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241     }
242     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246 }
247 
248 // File: zeppelin-solidity/contracts/token/MintableToken.sol
249 
250 /**
251  * @title Mintable token
252  * @dev Simple ERC20 Token example, with mintable token creation
253  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
254  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
255  */
256 
257 contract MintableToken is StandardToken, Ownable {
258   event Mint(address indexed to, uint256 amount);
259   event MintFinished();
260 
261   bool public mintingFinished = false;
262 
263 
264   modifier canMint() {
265     require(!mintingFinished);
266     _;
267   }
268 
269   /**
270    * @dev Function to mint tokens
271    * @param _to The address that will receive the minted tokens.
272    * @param _amount The amount of tokens to mint.
273    * @return A boolean that indicates if the operation was successful.
274    */
275   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
276     totalSupply = totalSupply.add(_amount);
277     balances[_to] = balances[_to].add(_amount);
278     Mint(_to, _amount);
279     Transfer(address(0), _to, _amount);
280     return true;
281   }
282 
283   /**
284    * @dev Function to stop minting new tokens.
285    * @return True if the operation was successful.
286    */
287   function finishMinting() onlyOwner canMint public returns (bool) {
288     mintingFinished = true;
289     MintFinished();
290     return true;
291   }
292 }
293 
294 contract CogeneroToken is MintableToken {
295   string public constant name = "Cogenero";
296   string public constant symbol = "COG";
297   uint8 public constant decimals = 18;
298 
299   bool public AllowTransferGlobal = false;
300   bool public AllowTransferLocal = false;
301   bool public AllowTransferExternal = false;
302 
303   mapping(address => uint256) public Whitelist;
304   mapping(address => uint256) public LockupList;
305   mapping(address => bool) public WildcardList;
306   mapping(address => bool) public Managers;
307 
308   event Burn(address indexed burner, uint256 value);
309     
310   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
311     require(totalSupply.add(_amount) <= 1000000000000000000000000000);
312     
313     return super.mint(_to, _amount);
314   }
315     
316   function allowTransfer(address _from, address _to) public view returns (bool) {
317     if (WildcardList[_from])
318       return true;
319 
320     if (LockupList[_from] > now)
321       return false;
322 
323     if (!AllowTransferGlobal) {
324         if (AllowTransferLocal && Whitelist[_from] != 0 && Whitelist[_to] != 0 && Whitelist[_from] < now && Whitelist[_to] < now)
325             return true;
326 
327         if (AllowTransferExternal && Whitelist[_from] != 0 && Whitelist[_from] < now)
328             return true;
329 
330         return false;
331     }
332 
333     return true;
334   }
335 
336   function allowManager() public view returns (bool) {
337     if (msg.sender == owner)
338       return true;
339 
340     if (Managers[msg.sender])
341       return true;
342 
343     return false;
344   }
345 
346   function transfer(address _to, uint256 _value) public returns (bool) {
347     require(allowTransfer(msg.sender, _to));
348 
349     return super.transfer(_to, _value);
350   }
351 
352   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
353     require(allowTransfer(_from, _to));
354 
355     return super.transferFrom(_from, _to, _value);
356   }
357 
358   function setManager(address _manager, bool _status) onlyOwner public {
359     Managers[_manager] = _status;
360   }
361 
362   function setAllowTransferGlobal(bool _status) public {
363     require(allowManager());
364 
365     AllowTransferGlobal = _status;
366   }
367 
368   function setAllowTransferLocal(bool _status) public {
369     require(allowManager());
370 
371     AllowTransferLocal = _status;
372   }
373 
374   function setAllowTransferExternal(bool _status) public {
375     require(allowManager());
376 
377     AllowTransferExternal = _status;
378   }
379 
380   function setWhitelist(address _address, uint256 _date) public {
381     require(allowManager());
382 
383     Whitelist[_address] = _date;
384   }
385 
386   function setLockupList(address _address, uint256 _date) public {
387     require(allowManager());
388 
389     LockupList[_address] = _date;
390   }
391 
392   function setWildcardList(address _address, bool _status) public {
393     require(allowManager());
394 
395     WildcardList[_address] = _status;
396   }
397 
398   function burn(address _burner, uint256 _value) onlyOwner public {
399     require(_value <= balances[_burner]);
400 
401     balances[_burner] = balances[_burner].sub(_value);
402     totalSupply = totalSupply.sub(_value);
403     Burn(_burner, _value);
404     Transfer(_burner, address(0), _value);
405   }
406 
407 }