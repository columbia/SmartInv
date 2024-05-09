1 pragma solidity ^0.4.10;
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
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) returns (bool);
52   function approve(address spender, uint256 value) returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances. 
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) returns (bool) {
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
82   function balanceOf(address _owner) constant returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97   mapping (address => mapping (address => uint256)) allowed;
98 
99 
100   /**
101    * @dev Transfer tokens from one address to another
102    * @param _from address The address which you want to send tokens from
103    * @param _to address The address which you want to transfer to
104    * @param _value uint256 the amout of tokens to be transfered
105    */
106   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110     // require (_value <= _allowance);
111 
112     balances[_to] = balances[_to].add(_value);
113     balances[_from] = balances[_from].sub(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) returns (bool) {
125 
126     // To change the approve amount you first have to reduce the addresses`
127     //  allowance to zero by calling `approve(_spender, 0)` if it is not
128     //  already 0 to mitigate the race condition described here:
129     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still avaible for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155   address public owner;
156 
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166 
167   /**
168    * @dev Throws if called by any account other than the owner.
169    */
170   modifier onlyOwner() {
171     require(msg.sender == owner);
172     _;
173   }
174 
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner {
181     if (newOwner != address(0)) {
182       owner = newOwner;
183     }
184   }
185 
186 }
187 
188 contract MigrationAgent {
189     function migrateFrom(address _from, uint256 _value);
190 }
191 
192 /**
193     BlockChain Board Of Derivatives Token. 
194  */
195 contract BBDToken is StandardToken, Ownable {
196 
197     // Metadata
198     string public constant name = "BlockChain Board Of Derivatives Token";
199     string public constant symbol = "BBD";
200     uint256 public constant decimals = 18;
201     string public constant version = '1.0.0';
202 
203     // Presale parameters
204     uint256 public presaleStartTime;
205     uint256 public presaleEndTime;
206 
207     bool public presaleFinalized = false;
208 
209     uint256 public constant presaleTokenCreationCap = 40000 * 10 ** decimals;// amount on presale
210     uint256 public constant presaleTokenCreationRate = 20000; // 2 BDD per 1 ETH
211 
212     // Sale parameters
213     uint256 public saleStartTime;
214     uint256 public saleEndTime;
215 
216     bool public saleFinalized = false;
217 
218     uint256 public constant totalTokenCreationCap = 240000 * 10 ** decimals; //total amount on ale and presale
219     uint256 public constant saleStartTokenCreationRate = 16600; // 1.66 BDD per 1 ETH
220     uint256 public constant saleEndTokenCreationRate = 10000; // 1 BDD per 1 ETH
221 
222     // Migration information
223     address public migrationAgent;
224     uint256 public totalMigrated;
225 
226     // Team accounts
227     address public constant qtAccount = 0x87a9131485cf8ed8E9bD834b46A12D7f3092c263;
228     address public constant coreTeamMemberOne = 0xe43088E823eA7422D77E32a195267aE9779A8B07;
229     address public constant coreTeamMemberTwo = 0xad00884d1E7D0354d16fa8Ab083208c2cC3Ed515;
230 
231     uint256 public constant divisor = 10000;
232 
233     // ETH amount rised
234     uint256 raised = 0;
235 
236     // Events
237     event Migrate(address indexed _from, address indexed _to, uint256 _value);
238     event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount);
239 
240     function() payable {
241         require(!presaleFinalized || !saleFinalized); //todo
242 
243         if (!presaleFinalized) {
244             buyPresaleTokens(msg.sender);
245         }
246         else{
247             buySaleTokens(msg.sender);
248         }
249     }
250 
251     function BBDToken(uint256 _presaleStartTime, uint256 _presaleEndTime, uint256 _saleStartTime, uint256 _saleEndTime) {
252         require(_presaleStartTime >= now);
253         require(_presaleEndTime >= _presaleStartTime);
254         require(_saleStartTime >= _presaleEndTime);
255         require(_saleEndTime >= _saleStartTime);
256 
257         presaleStartTime = _presaleStartTime;
258         presaleEndTime = _presaleEndTime;
259         saleStartTime = _saleStartTime;
260         saleEndTime = _saleEndTime;
261     }
262 
263     // Get token creation rate
264     function getTokenCreationRate() constant returns (uint256) {
265         require(!presaleFinalized || !saleFinalized);
266 
267         uint256 creationRate;
268 
269         if (!presaleFinalized) {
270             //The rate on presales is constant
271             creationRate = presaleTokenCreationRate;
272         } else {
273             //The rate on sale is changing lineral while time is passing. On sales start it is 1.66 and on end 1.0 
274             uint256 rateRange = saleStartTokenCreationRate - saleEndTokenCreationRate;
275             uint256 timeRange = saleEndTime - saleStartTime;
276             creationRate = saleStartTokenCreationRate.sub(rateRange.mul(now.sub(saleStartTime)).div(timeRange));
277         }
278 
279         return creationRate;
280     }
281     
282     // Buy presale tokens
283     function buyPresaleTokens(address _beneficiary) payable {
284         require(!presaleFinalized);
285         require(msg.value != 0);
286         require(now <= presaleEndTime);
287         require(now >= presaleStartTime);
288 
289         uint256 bbdTokens = msg.value.mul(getTokenCreationRate()).div(divisor);
290         uint256 checkedSupply = totalSupply.add(bbdTokens);
291         require(presaleTokenCreationCap >= checkedSupply);
292 
293         totalSupply = totalSupply.add(bbdTokens);
294         balances[_beneficiary] = balances[_beneficiary].add(bbdTokens);
295 
296         raised += msg.value;
297         TokenPurchase(msg.sender, _beneficiary, msg.value, bbdTokens);
298     }
299 
300     // Finalize presale
301     function finalizePresale() onlyOwner external {
302         require(!presaleFinalized);
303         require(now >= presaleEndTime || totalSupply == presaleTokenCreationCap);
304 
305         presaleFinalized = true;
306 
307         uint256 ethForCoreMember = this.balance.mul(500).div(divisor);
308 
309         coreTeamMemberOne.transfer(ethForCoreMember); // 5%
310         coreTeamMemberTwo.transfer(ethForCoreMember); // 5%
311         qtAccount.transfer(this.balance); // Quant Technology 90%
312     }
313 
314     // Buy sale tokens
315     function buySaleTokens(address _beneficiary) payable {
316         require(!saleFinalized);
317         require(msg.value != 0);
318         require(now <= saleEndTime);
319         require(now >= saleStartTime);
320 
321         uint256 bbdTokens = msg.value.mul(getTokenCreationRate()).div(divisor);
322         uint256 checkedSupply = totalSupply.add(bbdTokens);
323         require(totalTokenCreationCap >= checkedSupply);
324 
325         totalSupply = totalSupply.add(bbdTokens);
326         balances[_beneficiary] = balances[_beneficiary].add(bbdTokens);
327 
328         raised += msg.value;
329         TokenPurchase(msg.sender, _beneficiary, msg.value, bbdTokens);
330     }
331 
332     // Finalize sale
333     function finalizeSale() onlyOwner external {
334         require(!saleFinalized);
335         require(now >= saleEndTime || totalSupply == totalTokenCreationCap);
336 
337         saleFinalized = true;
338 
339         //Add aditional 25% tokens to the Quant Technology and development team
340         uint256 additionalBBDTokensForQTAccount = totalSupply.mul(2250).div(divisor); // 22.5%
341         totalSupply = totalSupply.add(additionalBBDTokensForQTAccount);
342         balances[qtAccount] = balances[qtAccount].add(additionalBBDTokensForQTAccount);
343 
344         uint256 additionalBBDTokensForCoreTeamMember = totalSupply.mul(125).div(divisor); // 1.25%
345         totalSupply = totalSupply.add(2 * additionalBBDTokensForCoreTeamMember);
346         balances[coreTeamMemberOne] = balances[coreTeamMemberOne].add(additionalBBDTokensForCoreTeamMember);
347         balances[coreTeamMemberTwo] = balances[coreTeamMemberTwo].add(additionalBBDTokensForCoreTeamMember);
348 
349         uint256 ethForCoreMember = this.balance.mul(500).div(divisor);
350 
351         coreTeamMemberOne.transfer(ethForCoreMember); // 5%
352         coreTeamMemberTwo.transfer(ethForCoreMember); // 5%
353         qtAccount.transfer(this.balance); // Quant Technology 90%
354     }
355 
356     // Allow migrate contract
357     function migrate(uint256 _value) external {
358         require(saleFinalized);
359         require(migrationAgent != 0x0);
360         require(_value > 0);
361         require(_value <= balances[msg.sender]);
362 
363         balances[msg.sender] = balances[msg.sender].sub(_value);
364         totalSupply = totalSupply.sub(_value);
365         totalMigrated = totalMigrated.add(_value);
366         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
367         Migrate(msg.sender, migrationAgent, _value);
368     }
369 
370     function setMigrationAgent(address _agent) onlyOwner external {
371         require(saleFinalized);
372         require(migrationAgent == 0x0);
373 
374         migrationAgent = _agent;
375     }
376 
377     // ICO Status overview. Used for BBOD landing page
378     function icoOverview() constant returns (uint256 currentlyRaised, uint256 currentlyTotalSupply, uint256 currentlyTokenCreationRate){
379         currentlyRaised = raised;
380         currentlyTotalSupply = totalSupply;
381         currentlyTokenCreationRate = getTokenCreationRate();
382     }
383 }