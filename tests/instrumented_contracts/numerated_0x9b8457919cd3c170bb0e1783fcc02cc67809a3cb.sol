1 pragma solidity ^0.4.11;
2 
3 /** Prosperium Presale Token (PP)
4  * ERC-20 Token
5  * Ability to upgrade to new contract - main Prosperium contract - when deployed by token Owner
6  * 
7 
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  * from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
13  */
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16     uint256 c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal constant returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 
41 contract StandardToken{
42     
43     using SafeMath for uint256;
44     
45     // create mapping from ether address to uint for balances
46     mapping (address => uint256) balances;
47     
48     mapping (address => mapping(address => uint256)) approved;
49     
50     // public events on ether network for Transfer and Approval 
51     event Transfer(address indexed _from, address indexed _to, uint256 _value);
52     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53     
54     uint256 public totalSupply;
55     
56     // returns the total supply of all prosperium presale tokens
57     function totalSupply() constant returns (uint totalSupply){
58         return totalSupply;
59     }
60     
61     // returns address specified as "_owner"
62     function balanceOf(address _owner) constant returns (uint256 balance){
63         return balances[_owner];
64     }
65     
66     // transfer _value PP tokens from msg.sender to _to 
67     function transfer(address _to, uint256 _value) returns (bool success){
68         
69         require(_to != address(0));
70         
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         Transfer(msg.sender, _to, _value);
74         return true;
75         
76     }
77     
78     // permission from owner to approve spender(s)
79     function approve(address _spender, uint _value) returns (bool success){
80         
81         require((_value == 0) || (approved[msg.sender][_spender] == 0));
82 
83         approved[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86         
87     }
88     
89     // amount of coins allowed to spend from another account
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
91         
92         return approved[_owner][_spender];
93         
94     }
95     
96     /**
97    * approve should be called when allowed[_spender] == 0. To increment
98    * allowed value is better to use this function to avoid 2 calls (and wait until 
99    * the first transaction is mined)
100    * from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/StandardToken.sol
101    */
102     function increaseApproval (address _spender, uint _addedValue) 
103     returns (bool success) {
104     approved[msg.sender][_spender] = approved[msg.sender][_spender].add(_addedValue);
105     Approval(msg.sender, _spender, approved[msg.sender][_spender]);
106     return true;
107   }
108 
109   function decreaseApproval (address _spender, uint _subtractedValue) 
110     returns (bool success) {
111     uint oldValue = approved[msg.sender][_spender];
112     if (_subtractedValue > oldValue) {
113       approved[msg.sender][_spender] = 0;
114     } else {
115       approved[msg.sender][_spender] = oldValue.sub(_subtractedValue);
116     }
117     Approval(msg.sender, _spender, approved[msg.sender][_spender]);
118     return true;
119   }
120     // transfer tokens from owners account to given address _to
121     function transferFrom(address _from, address _to, uint _value) returns (bool success){
122         
123         require(_to != address(0));
124         
125          var _allowance = approved[_from][msg.sender];
126 
127         balances[_from] = balances[_from].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         approved[_from][msg.sender] = _allowance.sub(_value);
130         Transfer(_from, _to, _value);
131         return true;
132         
133     }
134     
135 }
136 
137 /**
138  * @title Ownable
139  * from OpenZeppelin
140  * @dev The Ownable contract has an owner address, and provides basic authorization control
141  * functions, this simplifies the implementation of "user permissions".
142  */
143 contract Ownable {
144     
145   address public owner;
146 
147 
148   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
149 
150 
151   /**
152    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
153    * account.
154    */
155   function Ownable() {
156     owner = msg.sender;
157   }
158 
159 
160   /**
161    * @dev Throws if called by any account other than the owner.
162    */
163   modifier onlyOwner() {
164     require(msg.sender == owner);
165     _;
166   }
167 
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address newOwner) onlyOwner {
174     require(newOwner != address(0));      
175     OwnershipTransferred(owner, newOwner);
176     owner = newOwner;
177   }
178 
179 }
180 
181 // prosperium will be mintable only by owner
182 // from OpenZeppelin https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
183 contract ProsperMintableToken is StandardToken, Ownable {
184   event Mint(address indexed to, uint256 amount);
185   event MintFinished();
186 
187   bool public mintingFinished = false;
188 
189 
190   modifier canMint() {
191     require(!mintingFinished);
192     _;
193   }
194 
195   /**
196    * @dev Function to mint tokens
197    * @param _to The address that will receive the minted tokens.
198    * @param _amount The amount of tokens to mint.
199    * @return A boolean that indicates if the operation was successful.
200    */
201   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
202     totalSupply = totalSupply.add(_amount);
203     balances[_to] = balances[_to].add(_amount);
204     Mint(_to, _amount);
205     Transfer(0x0, _to, _amount);
206     return true;
207   }
208 
209   /**
210    * @dev Function to stop minting new tokens.
211    * @return True if the operation was successful.
212    */
213   function finishMinting() onlyOwner returns (bool) {
214     mintingFinished = true;
215     MintFinished();
216     return true;
217   }
218 }
219 
220 
221 /**
222  * inspirsed from Civic token
223  * Upgrade agent interface inspired by Lunyr.
224  *
225  * Upgrade agent transfers tokens to a new version of a token contract.
226  * Upgrade agent can be set on a token by the upgrade master.
227  *
228  * Steps are
229  * - Upgradeabletoken.upgradeMaster calls UpgradeableToken.setUpgradeAgent()
230  * - Individual token holders can now call UpgradeableToken.upgrade()
231  *   -> This results to call UpgradeAgent.upgradeFrom() that issues new tokens
232  *   -> UpgradeableToken.upgrade() reduces the original total supply based on amount of upgraded tokens
233  *
234  */
235 
236 
237 contract UpgradeAgent {
238 
239   uint public originalSupply;
240 
241   /** Interface marker */
242   function isUpgradeAgent() public constant returns (bool) {
243     return true;
244   }
245 
246   /**
247    * Upgrade amount of tokens to a new version.
248    *
249    * Only callable by UpgradeableToken.
250    *
251    * @param _tokenHolder Address that wants to upgrade its tokens
252    * @param _amount Number of tokens to upgrade. The address may consider to hold back some amount of tokens in the old version.
253    */
254   function upgradeFrom(address _tokenHolder, uint256 _amount) external;
255 }
256 
257 
258 
259 /**
260  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
261  *
262  * First envisioned by Golem and Lunyr projects.
263  */
264 contract UpgradeableToken is ProsperMintableToken {
265 
266   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
267   address public upgradeMaster;
268 
269   /** The next contract where the tokens will be migrated. */
270   UpgradeAgent public upgradeAgent;
271 
272   /** How many tokens we have upgraded by now. */
273   uint256 public totalUpgraded;
274 
275   /**
276    * Upgrade states.
277    *
278    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
279    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
280    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
281    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
282    *
283    */
284   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
285 
286   /**
287    * Somebody has upgraded some of his tokens.
288    */
289   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
290 
291   /**
292    * New upgrade agent available.
293    */
294   event UpgradeAgentSet(address agent);
295 
296   /**
297    * Upgrade master updated.
298    */
299   event NewUpgradeMaster(address upgradeMaster);
300 
301   /**
302    * Do not allow construction without upgrade master set.
303    */
304   function UpgradeableToken(address _upgradeMaster) {
305     upgradeMaster = _upgradeMaster;
306     NewUpgradeMaster(upgradeMaster);
307   }
308 
309   /**
310    * Allow the token holder to upgrade some of their tokens to a new contract.
311    */
312   function upgrade(uint256 value) public {
313 
314       UpgradeState state = getUpgradeState();
315       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
316         // Called in a bad state
317         throw;
318       }
319 
320       // Validate input value.
321       if (value == 0) throw;
322 
323       balances[msg.sender] = balances[msg.sender].sub(value);
324 
325       // Take tokens out from circulation
326       totalSupply = totalSupply.sub(value);
327       totalUpgraded = totalUpgraded.add(value);
328 
329       // Upgrade agent reissues the tokens
330       upgradeAgent.upgradeFrom(msg.sender, value);
331       Upgrade(msg.sender, upgradeAgent, value);
332   }
333 
334   /**
335    * Set an upgrade agent that handles
336    */
337   function setUpgradeAgent(address agent) external {
338 
339       if(!canUpgrade()) {
340         // The token is not yet in a state that we could think upgrading
341         throw;
342       }
343 
344       if (agent == 0x0) throw;
345       // Only a master can designate the next agent
346       if (msg.sender != upgradeMaster) throw;
347       // Upgrade has already begun for an agent
348       if (getUpgradeState() == UpgradeState.Upgrading) throw;
349 
350       upgradeAgent = UpgradeAgent(agent);
351 
352       // Bad interface
353       if(!upgradeAgent.isUpgradeAgent()) throw;
354       // Make sure that token supplies match in source and target
355       if (upgradeAgent.originalSupply() != totalSupply) throw;
356 
357       UpgradeAgentSet(upgradeAgent);
358   }
359 
360   /**
361    * Get the state of the token upgrade.
362    */
363   function getUpgradeState() public constant returns(UpgradeState) {
364     if(!canUpgrade()) return UpgradeState.NotAllowed;
365     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
366     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
367     else return UpgradeState.Upgrading;
368   }
369 
370   /**
371    * Change the upgrade master.
372    *
373    * This allows us to set a new owner for the upgrade mechanism.
374    */
375   function setUpgradeMaster(address master) public {
376       if (master == 0x0) throw;
377       if (msg.sender != upgradeMaster) throw;
378       upgradeMaster = master;
379       NewUpgradeMaster(upgradeMaster);
380   }
381 
382   /**
383    * Child contract can enable to provide the condition when the upgrade can begun.
384    */
385   function canUpgrade() public constant returns(bool) {
386      return true;
387   }
388 
389 }
390 
391 contract ProsperPresaleToken is UpgradeableToken {
392     
393     
394     string public name;
395     string public symbol;
396     uint8 public decimals;
397 
398   
399     function ProsperPresaleToken(address _owner, string _name, string _symbol, uint256 _initSupply, uint8 _decimals) UpgradeableToken(_owner) {
400         
401         name = _name;
402         symbol = _symbol;
403         totalSupply = _initSupply;
404         decimals = _decimals;
405         
406         balances[_owner] = _initSupply;
407         
408     }
409     
410 }