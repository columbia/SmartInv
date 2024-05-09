1 pragma solidity ^0.4.24;
2 
3 
4 /**
5 *
6 */
7 
8 /**
9  * Math operations with safety checks
10  */
11 library SafeMath {
12 function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 
36   function assert(bool assertion) internal {
37     if (!assertion) {
38       throw;
39     }
40   }
41 }
42 
43 
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20Basic {
50   uint256 public totalSupply;
51   function balanceOf(address who) constant returns (uint256);
52   function transfer(address to, uint256 value);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   /**
67    * @dev Fix for the ERC20 short address attack.
68    */
69   modifier onlyPayloadSize(uint size) {
70      if(msg.data.length < size + 4) {
71        throw;
72      }
73      _;
74   }
75 
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
82     balances[msg.sender] = balances[msg.sender].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     Transfer(msg.sender, _to, _value);
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 
99 /**
100  * @title ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/20
102  */
103 contract ERC20 is ERC20Basic {
104   function allowance(address owner, address spender) constant returns (uint256);
105   function transferFrom(address from, address to, uint256 value);
106   function approve(address spender, uint256 value);
107   event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implemantation of the basic standart token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
117  */
118 contract StandardToken is BasicToken, ERC20 {
119 
120   mapping (address => mapping (address => uint256)) allowed;
121 
122 
123   /**
124    * @dev Transfer tokens from one address to another
125    * @param _from address The address which you want to send tokens from
126    * @param _to address The address which you want to transfer to
127    * @param _value uint the amout of tokens to be transfered
128    */
129   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
130     var _allowance = allowed[_from][msg.sender];
131 
132     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
133     // if (_value > _allowance) throw;
134 
135     balances[_to] = balances[_to].add(_value);
136     balances[_from] = balances[_from].sub(_value);
137     allowed[_from][msg.sender] = _allowance.sub(_value);
138     Transfer(_from, _to, _value);
139   }
140 
141   /**
142    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146   function approve(address _spender, uint256 _value) {
147 
148     // To change the approve amount you first have to reduce the addresses`
149     //  allowance to zero by calling `approve(_spender, 0)` if it is not
150     //  already 0 to mitigate the race condition described here:
151     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
153 
154     allowed[msg.sender][_spender] = _value;
155     Approval(msg.sender, _spender, _value);
156   }
157 
158   /**
159    * @dev Function to check the amount of tokens than an owner allowed to a spender.
160    * @param _owner address The address which owns the funds.
161    * @param _spender address The address which will spend the funds.
162    * @return A uint specifing the amount of tokens still avaible for the spender.
163    */
164   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
165     return allowed[_owner][_spender];
166   }
167 
168 }
169 
170 
171 /**
172  * @title Ownable
173  * @dev The Ownable contract has an owner address, and provides basic authorization control
174  * functions, this simplifies the implementation of "user permissions".
175  */
176 contract Ownable {
177   address public owner;
178 
179 
180   /**
181    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
182    * account.
183    */
184   function Ownable() {
185     owner = msg.sender;
186   }
187 
188 
189   /**
190    * @dev Throws if called by any account other than the owner.
191    */
192   modifier onlyOwner() {
193     if (msg.sender != owner) {
194       throw;
195     }
196     _;
197   }
198 
199 
200   /**
201    * @dev Allows the current owner to transfer control of the contract to a newOwner.
202    * @param newOwner The address to transfer ownership to.
203    */
204   function transferOwnership(address newOwner) onlyOwner {
205     if (newOwner != address(0)) {
206       owner = newOwner;
207     }
208   }
209 
210 }
211 
212 
213 /**
214  * @title Mintable token
215  * @dev Simple ERC20 Token example, with mintable token creation
216  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
217  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
218  */
219 
220 contract MintableToken is StandardToken, Ownable {
221   event Mint(address indexed to, uint256 value);
222   event MintFinished();
223 
224   bool public mintingFinished = false;
225   uint256 public totalSupply = 0;
226 
227 
228   modifier canMint() {
229     if(mintingFinished) throw;
230     _;
231   }
232 
233   /**
234    * @dev Function to mint tokens
235    * @param _to The address that will recieve the minted tokens.
236    * @param _amount The amount of tokens to mint.
237    * @return A boolean that indicates if the operation was successful.
238    */
239   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
240     totalSupply = totalSupply.add(_amount);
241     balances[_to] = balances[_to].add(_amount);
242     Mint(_to, _amount);
243     return true;
244   }
245 
246   /**
247    * @dev Function to stop minting new tokens.
248    * @return True if the operation was successful.
249    */
250   function finishMinting() onlyOwner returns (bool) {
251     mintingFinished = true;
252     MintFinished();
253     return true;
254   }
255 }
256 
257 contract TimeLockToken is Ownable, MintableToken{
258   using SafeMath for uint256;
259   struct LockedBalance {  
260     uint256 releaseTime; 
261     uint256 amount;
262   }
263 
264   event MintLock(address indexed to, uint256 releaseTime, uint256 value);
265   mapping(address => LockedBalance) lockedBalances;
266   /**
267    * @dev mint timelocked tokens
268    */
269   function mintTimelocked(address _to, uint256 _releaseTime, uint256 _amount)
270     onlyOwner canMint returns (bool){
271     require(_releaseTime > now);
272     require(_amount > 0);
273     LockedBalance exist = lockedBalances[_to];
274     require(exist.amount == 0);
275     LockedBalance memory balance = LockedBalance(_releaseTime,_amount);
276     totalSupply = totalSupply.add(_amount);
277     lockedBalances[_to] = balance;
278     MintLock(_to, _releaseTime, _amount);
279     return true;
280   }
281 
282   /**
283    * @dev beneficiary claims tokens held by time lock
284    */
285   function claim() {
286     LockedBalance balance = lockedBalances[msg.sender];
287     require(balance.amount > 0);
288     require(now >= balance.releaseTime);
289     uint256 amount = balance.amount;
290     delete lockedBalances[msg.sender];
291     balances[msg.sender] = balances[msg.sender].add(amount);
292     Transfer(0, msg.sender, amount);
293   }
294 
295   /**
296   * @dev Gets the locked balance of the specified address.
297   * @param _owner The address to query the the locked balance of.
298   * @return An uint representing the amount owned by the passed address.
299   */
300   function lockedBalanceOf(address _owner) constant returns (uint256 lockedAmount) {
301     return lockedBalances[_owner].amount;
302   }
303 
304   /**
305   * @dev Gets the releaseTime of the specified address.
306   * @param _owner The address to query the the releaseTime of.
307   * @return An uint representing the amount owned by the passed address.
308   */
309   function releaseTimeOf(address _owner) constant returns (uint256 releaseTime) {
310     return lockedBalances[_owner].releaseTime;
311   }
312   
313 }
314 
315 
316 contract LiuTJToken is TimeLockToken {
317   using SafeMath for uint256;
318   event Freeze(address indexed to, uint256 value);
319   event Unfreeze(address indexed to, uint256 value);
320   event Burn(address indexed to, uint256 value);
321   mapping (address => uint256) public freezeOf;
322   string public name = "Liu TJ Token";
323   string public symbol = "LT";
324   uint public decimals = 18;
325 
326 
327   function burn(address _to,uint256 _value) onlyOwner returns (bool success) {
328     require(_value >= 0);
329     require(balances[_to] >= _value);
330     
331     balances[_to] = balances[_to].sub(_value);                      // Subtract from the sender
332     totalSupply = totalSupply.sub(_value);                                // Updates totalSupply
333     Burn(_to, _value);
334     return true;
335   }
336   
337   function freeze(address _to,uint256 _value) onlyOwner returns (bool success) {
338     require(_value >= 0);
339     require(balances[_to] >= _value);
340     balances[_to] = balances[_to].sub(_value);                      // Subtract from the sender
341     freezeOf[_to] = freezeOf[_to].add(_value);                                // Updates totalSupply
342     Freeze(_to, _value);
343     return true;
344   }
345   
346   function unfreeze(address _to,uint256 _value) onlyOwner returns (bool success) {
347     require(_value >= 0);
348     require(freezeOf[_to] >= _value);
349     freezeOf[_to] = freezeOf[_to].sub(_value);                      // Subtract from the sender
350     balances[_to] = balances[_to].add(_value);
351     Unfreeze(_to, _value);
352     return true;
353   }
354 
355 }