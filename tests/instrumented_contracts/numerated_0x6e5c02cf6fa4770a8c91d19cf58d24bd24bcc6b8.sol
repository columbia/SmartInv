1 pragma solidity ^0.4.16;
2 
3 /**
4 * @title ERC20Basic
5 * @dev Simpler version of ERC20 interface
6 * @dev see https://github.com/ethereum/EIPs/issues/179
7 */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16 * @title ERC20 interface
17 * @dev see https://github.com/ethereum/EIPs/issues/20
18 */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27 * @title SafeMath
28 * @dev Math operations with safety checks that throw on error
29 */
30 library SafeMath {
31 
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 
56 }
57 
58 /**
59 * @title Basic token
60 * @dev Basic version of StandardToken, with no allowances.
61 */
62 contract BasicToken is ERC20Basic {
63 
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of.
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) public constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 /**
92 * @title Standard ERC20 token
93 *
94 * @dev Implementation of the basic standard token.
95 * @dev https://github.com/ethereum/EIPs/issues/20
96 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97 */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102   /**
103   * @dev Transfer tokens from one address to another
104   * @param _from address The address which you want to send tokens from
105   * @param _to address The address which you want to transfer to
106   * @param _value uint256 the amout of tokens to be transfered
107   */
108   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109     var _allowance = allowed[_from][msg.sender];
110 
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // require (_value <= _allowance);
113 
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123   * @param _spender The address which will spend the funds.
124   * @param _value The amount of tokens to be spent.
125   */
126   function approve(address _spender, uint256 _value) public returns (bool) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140   * @dev Function to check the amount of tokens that an owner allowed to a spender.
141   * @param _owner address The address which owns the funds.
142   * @param _spender address The address which will spend the funds.
143   * @return A uint256 specifing the amount of tokens still available for the spender.
144   */
145   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 /**
152 * @title Ownable
153 * @dev The Ownable contract has an owner address, and provides basic authorization control
154 * functions, this simplifies the implementation of "user permissions".
155 */
156 contract Ownable {
157 
158   address public owner;
159 
160   /**
161   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162   * account.
163   */
164   function Ownable() public {
165     owner = msg.sender;
166   }
167 
168   /**
169   * @dev Throws if called by any account other than the owner.
170   */
171   modifier onlyOwner() {
172     require(msg.sender == owner);
173     _;
174   }
175 
176   /**
177   * @dev Allows the current owner to transfer control of the contract to a newOwner.
178   * @param newOwner The address to transfer ownership to.
179   */
180   function transferOwnership(address newOwner) public onlyOwner {
181     require(newOwner != address(0));
182     owner = newOwner;
183   }
184 
185 }
186 
187 /**
188 * @title Mintable token
189 * @dev Simple ERC20 Token example, with mintable token creation
190 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
191 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
192 */
193 
194 contract MintableToken is StandardToken, Ownable {
195 
196   event Mint(address indexed to, uint256 amount);
197 
198   event MintFinished();
199 
200   bool public mintingFinished = false;
201 
202   modifier canMint() {
203     require(!mintingFinished);
204     _;
205   }
206 
207   /**
208   * @dev Function to mint tokens
209   * @param _to The address that will recieve the minted tokens.
210   * @param _amount The amount of tokens to mint.
211   * @return A boolean that indicates if the operation was successful.
212   */
213   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
214     totalSupply = totalSupply.add(_amount);
215     balances[_to] = balances[_to].add(_amount);
216     Mint(_to, _amount);
217     return true;
218   }
219 
220   /**
221   * @dev Function to stop minting new tokens.
222   * @return True if the operation was successful.
223   */
224   function finishMinting() public onlyOwner returns (bool) {
225     mintingFinished = true;
226     MintFinished();
227     return true;
228   }
229 
230 }
231 
232 contract DbiCapitalToken is MintableToken {
233 
234   string public constant name = "DBI Capital Token";
235 
236   string public constant symbol = "DBI";
237 
238   uint32 public constant decimals = 18;
239 
240 }
241 
242 contract Crowdsale is Ownable {
243 
244   using SafeMath for uint;
245 
246   address multisig; //address for ETH
247   address bounty;   //address for bounty tokens
248   uint bountyCount = 1000000000000000000000; //1,000 tokens for bounty
249 
250   DbiCapitalToken public token = new DbiCapitalToken();
251 
252   uint startDate = 0; //UNIX timestamp
253   uint endDate = 0;   //UNIX timestamp
254   uint hardcap = 0;   //in ether
255   uint rate = 0;      //tokens for 1 eth
256 
257   uint tokensSold = 0;
258   uint etherReceived = 0;
259 
260   uint hardcapStage1 = 2000 ether;  //Pre-ICO, Research & Lega
261   uint hardcapStage2 = 20000 ether; //Pre-ICO, MVP + START
262   uint hardcapStage3 = 150000 ether; //ICO, SCALE
263 
264   uint rateStage1 = 100; //Pre-ICO, Research & Lega
265   uint rateStage2 = 70;  //Pre-ICO, MVP + START
266   uint rateStage3 = 50;  //ICO, SCALE
267 
268   uint crowdsaleStage = 0;
269   bool crowdsaleStarted = false;
270   bool crowdsaleFinished = false;
271 
272   event CrowdsaleStageStarted(uint stage, uint startDate, uint endDate, uint rate, uint hardcap);
273   event CrowdsaleFinished(uint tokensSold, uint etherReceived);
274   event TokenSold(uint tokens, uint ethFromTokens, uint rate, uint hardcap);
275   event HardcapGoalReached(uint tokensSold, uint etherReceived, uint hardcap, uint stage);
276 
277 
278   function Crowdsale() public {
279     multisig = 0x70C39CC41a3852e20a8B1a59A728305758e3aa37;
280     bounty = 0x11404c733254d66612765B5A94fB4b1f0937639c;
281     token.mint(bounty, bountyCount);
282   }
283 
284   modifier saleIsOn() {
285     require(now >= startDate && now <= endDate && crowdsaleStarted && !crowdsaleFinished && crowdsaleStage > 0 && crowdsaleStage <= 3);
286     _;
287   }
288 
289   modifier isUnderHardCap() {
290     require(etherReceived <= hardcap);
291     _;
292   }
293 
294   function nextStage(uint _startDate, uint _endDate) public onlyOwner {
295     crowdsaleStarted = true;
296     crowdsaleStage += 1;
297     startDate = _startDate;
298     endDate = _endDate;
299     if (crowdsaleStage == 1) {
300       rate = rateStage1;
301       hardcap = hardcapStage1;
302       CrowdsaleStageStarted(crowdsaleStage, startDate, endDate, rate, hardcap);
303     } else if (crowdsaleStage == 2) {
304       rate = rateStage2;
305       hardcap = hardcapStage2;
306       CrowdsaleStageStarted(crowdsaleStage, startDate, endDate, rate, hardcap);
307     } else if (crowdsaleStage == 3) {
308       rate = rateStage3;
309       hardcap = hardcapStage3;
310       CrowdsaleStageStarted(crowdsaleStage, startDate, endDate, rate, hardcap);
311     } else {
312       finishMinting();
313     }
314   }
315 
316   function finishMinting() public onlyOwner {
317     crowdsaleFinished = true;
318     token.finishMinting();
319     CrowdsaleFinished(tokensSold, etherReceived);
320   }
321 
322   function createTokens() public isUnderHardCap saleIsOn payable {
323     multisig.transfer(msg.value);
324     uint tokens = rate.mul(msg.value);
325     tokensSold += tokens;
326     etherReceived += msg.value;
327     TokenSold(tokens, msg.value, rate, hardcap);
328     token.mint(msg.sender, tokens);
329     if (etherReceived >= hardcap) {
330       HardcapGoalReached(tokensSold, etherReceived, hardcap, crowdsaleStage);
331     }
332   }
333 
334   function() external payable {
335     createTokens();
336   }
337 
338   function getTokensSold() public view returns (uint) {
339     return tokensSold;
340   }
341 
342   function getEtherReceived() public view returns (uint) {
343     return etherReceived;
344   }
345 
346   function getCurrentHardcap() public view returns (uint) {
347     return hardcap;
348   }
349 
350   function getCurrentRate() public view returns (uint) {
351     return rate;
352   }
353 
354   function getStartDate() public view returns (uint) {
355     return startDate;
356   }
357 
358   function getEndDate() public view returns (uint) {
359     return endDate;
360   }
361 
362   function getStage() public view returns (uint) {
363     return crowdsaleStage;
364   }
365 
366   function isStarted() public view returns (bool) {
367     return crowdsaleStarted;
368   }
369 
370   function isFinished() public view returns (bool) {
371     return crowdsaleFinished;
372   }
373 
374 }