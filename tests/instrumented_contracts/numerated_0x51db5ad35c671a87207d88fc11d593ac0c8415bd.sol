1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 
70 }
71 
72 /**
73  * @title Contracts that should not own Tokens
74  * @author Remco Bloemen <remco@2π.com>
75  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
76  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
77  * owner to reclaim the tokens.
78  */
79 contract HasNoTokens is Ownable {
80 
81  /**
82   * @dev Reject all ERC23 compatible tokens
83   * @param from_ address The address that is transferring the tokens
84   * @param value_ uint256 the amount of the specified token
85   * @param data_ Bytes The data passed from the caller.
86   */
87   function tokenFallback(address from_, uint256 value_, bytes data_) external {
88     revert();
89   }
90 
91   /**
92    * @dev Reclaim all ERC20Basic compatible tokens
93    * @param tokenAddr address The address of the token contract
94    */
95   function reclaimToken(address tokenAddr) external onlyOwner {
96     ERC20Basic tokenInst = ERC20Basic(tokenAddr);
97     uint256 balance = tokenInst.balanceOf(this);
98     tokenInst.transfer(owner, balance);
99   }
100 }
101 
102 contract ERC20Basic {
103   uint256 public totalSupply;
104   function balanceOf(address who) constant returns (uint256);
105   function transfer(address to, uint256 value) returns (bool);
106   event Transfer(address indexed from, address indexed to, uint256 value);
107 }
108 
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) constant returns (uint256);
111   function transferFrom(address from, address to, uint256 value) returns (bool);
112   function approve(address spender, uint256 value) returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 /**
117  * @title Basic token
118  * @dev Basic version of StandardToken, with no allowances.
119  */
120 contract BasicToken is ERC20Basic {
121   using SafeMath for uint256;
122 
123   mapping(address => uint256) balances;
124 
125   /**
126   * @dev transfer token for a specified address
127   * @param _to The address to transfer to.
128   * @param _value The amount to be transferred.
129   */
130   function transfer(address _to, uint256 _value) returns (bool) {
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   /**
138   * @dev Gets the balance of the specified address.
139   * @param _owner The address to query the the balance of.
140   * @return An uint256 representing the amount owned by the passed address.
141   */
142   function balanceOf(address _owner) constant returns (uint256 balance) {
143     return balances[_owner];
144   }
145 
146 }
147 
148 contract StandardToken is ERC20, BasicToken {
149 
150   mapping (address => mapping (address => uint256)) allowed;
151 
152 
153   /**
154    * @dev Transfer tokens from one address to another
155    * @param _from address The address which you want to send tokens from
156    * @param _to address The address which you want to transfer to
157    * @param _value uint256 the amout of tokens to be transfered
158    */
159   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
160     var _allowance = allowed[_from][msg.sender];
161 
162     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
163     // require (_value <= _allowance);
164 
165     balances[_to] = balances[_to].add(_value);
166     balances[_from] = balances[_from].sub(_value);
167     allowed[_from][msg.sender] = _allowance.sub(_value);
168     Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) returns (bool) {
178 
179     // To change the approve amount you first have to reduce the addresses`
180     //  allowance to zero by calling `approve(_spender, 0)` if it is not
181     //  already 0 to mitigate the race condition described here:
182     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
184 
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifing the amount of tokens still avaible for the spender.
195    */
196   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
197     return allowed[_owner][_spender];
198   }
199 
200 }
201 
202 contract MigrationAgent {
203   /*
204     MigrationAgent contracts need to have this exact constant!
205     it is intended to be identify the contract, since there is no way to tell
206     if a contract is indeed an instance of the right type of contract otherwise
207   */
208   uint256 public constant MIGRATE_MAGIC_ID = 0x6e538c0d750418aae4131a91e5a20363;
209 
210   /*
211     A contract implementing this interface is assumed to implement the neccessary
212     access controls. E.g;
213     * token being migrated FROM is the only one allowed to call migrateTo
214     * token being migrated TO has a minting function that can only be called by
215       the migration agent
216   */
217   function migrateTo(address beneficiary, uint256 amount) external;
218 }
219 
220 /// @title Moeda Loyalty Points token contract
221 /// @author Erik Mossberg
222 contract MoedaToken is StandardToken, Ownable, HasNoTokens {
223   string public constant name = "Moeda Loyalty Points";
224   string public constant symbol = "MDA";
225   uint8 public constant decimals = 18;
226 
227   // The migration agent is used to be to allow opt-in transfer of tokens to a
228   // new token contract. This could be set sometime in the future if additional
229   // functionality needs be added.
230   MigrationAgent public migrationAgent;
231 
232   // used to ensure that a given address is an instance of a particular contract
233   uint256 constant AGENT_MAGIC_ID = 0x6e538c0d750418aae4131a91e5a20363;
234   uint256 public totalMigrated;
235 
236   uint constant TOKEN_MULTIPLIER = 10**uint256(decimals);
237   // don't allow creation of more than this number of tokens
238   uint public constant MAX_TOKENS = 20000000 * TOKEN_MULTIPLIER;
239 
240   // transfers are locked during minting
241   bool public mintingFinished;
242 
243   // Log when tokens are migrated to a new contract
244   event LogMigration(address indexed spender, address grantee, uint256 amount);
245   event LogCreation(address indexed donor, uint256 tokensReceived);
246   event LogDestruction(address indexed sender, uint256 amount);
247   event LogMintingFinished();
248 
249   modifier afterMinting() {
250     require(mintingFinished);
251     _;
252   }
253 
254   modifier canTransfer(address recipient) {
255     require(mintingFinished && recipient != address(0));
256     _;
257   }
258 
259   modifier canMint() {
260     require(!mintingFinished);
261     _;
262   }
263 
264   /// @dev Create moeda token and assign partner allocations
265   function MoedaToken() {
266     // manual distribution
267     issueTokens();
268   }
269 
270   function issueTokens() internal {
271     mint(0x2f37be861699b6127881693010596B4bDD146f5e, MAX_TOKENS);
272   }
273 
274   /// @dev start a migration to a new contract
275   /// @param agent address of contract handling migration
276   function setMigrationAgent(address agent) external onlyOwner afterMinting {
277     require(agent != address(0) && isContract(agent));
278     require(MigrationAgent(agent).MIGRATE_MAGIC_ID() == AGENT_MAGIC_ID);
279     require(migrationAgent == address(0));
280     migrationAgent = MigrationAgent(agent);
281   }
282 
283   function isContract(address addr) internal constant returns (bool) {
284     uint256 size;
285     assembly { size := extcodesize(addr) }
286     return size > 0;
287   }
288 
289   /// @dev move a given amount of tokens a new contract (destroying them here)
290   /// @param beneficiary address that will get tokens in new contract
291   /// @param amount the number of tokens to migrate
292   function migrate(address beneficiary, uint256 amount) external afterMinting {
293     require(beneficiary != address(0));
294     require(migrationAgent != address(0));
295     require(amount > 0);
296 
297     // safemath subtraction will throw if balance < amount
298     balances[msg.sender] = balances[msg.sender].sub(amount);
299     totalSupply = totalSupply.sub(amount);
300     totalMigrated = totalMigrated.add(amount);
301     migrationAgent.migrateTo(beneficiary, amount);
302 
303     LogMigration(msg.sender, beneficiary, amount);
304   }
305 
306   /// @dev destroy a given amount of tokens owned by sender
307   // anyone that owns tokens can destroy them, reducing the total supply
308   function burn(uint256 amount) external {
309     require(amount > 0);
310     balances[msg.sender] = balances[msg.sender].sub(amount);
311     totalSupply = totalSupply.sub(amount);
312 
313     LogDestruction(msg.sender, amount);
314   }
315 
316   /// @dev unlock transfers
317   function unlock() external onlyOwner canMint {
318     mintingFinished = true;
319     LogMintingFinished();
320   }
321 
322   /// @dev create tokens, only usable before minting has ended
323   /// @param recipient address that will receive the created tokens
324   /// @param amount the number of tokens to create
325   function mint(address recipient, uint256 amount) internal canMint {
326     require(amount > 0);
327     require(totalSupply.add(amount) <= MAX_TOKENS);
328 
329     balances[recipient] = balances[recipient].add(amount);
330     totalSupply = totalSupply.add(amount);
331 
332     LogCreation(recipient, amount);
333   }
334 
335   // only allowed after minting has ended
336   // note: transfers to null address not allowed, use burn(value)
337   function transfer(address to, uint _value)
338   public canTransfer(to) returns (bool)
339   {
340     return super.transfer(to, _value);
341   }
342 
343   // only allowed after minting has ended
344   // note: transfers to null address not allowed, use burn(value)
345   function transferFrom(address from, address to, uint value)
346   public canTransfer(to) returns (bool)
347   {
348     return super.transferFrom(from, to, value);
349   }
350 }