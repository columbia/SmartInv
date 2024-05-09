1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57   event OwnershipRenounced(address indexed previousOwner);
58   event OwnershipTransferred(
59     address indexed previousOwner,
60     address indexed newOwner
61   );
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     emit OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 }
97 
98 /**
99  * @title Pausable
100  * @dev Base contract which allows children to implement an emergency stop mechanism.
101  */
102 contract Pausable is Ownable {
103   event Pause();
104   event Unpause();
105 
106   bool public paused = false;
107 
108 
109   /**
110    * @dev Modifier to make a function callable only when the contract is not paused.
111    */
112   modifier whenNotPaused() {
113     require(!paused);
114     _;
115   }
116 
117   /**
118    * @dev Modifier to make a function callable only when the contract is paused.
119    */
120   modifier whenPaused() {
121     require(paused);
122     _;
123   }
124 
125   /**
126    * @dev called by the owner to pause, triggers stopped state
127    */
128   function pause() onlyOwner whenNotPaused public {
129     paused = true;
130     emit Pause();
131   }
132 
133   /**
134    * @dev called by the owner to unpause, returns to normal state
135    */
136   function unpause() onlyOwner whenPaused public {
137     paused = false;
138     emit Unpause();
139   }
140 }
141 
142 contract ERC20Basic {
143   function totalSupply() public view returns (uint256);
144   function balanceOf(address who) public view returns (uint256);
145   function transfer(address to, uint256 value) public returns (bool);
146   event Transfer(address indexed from, address indexed to, uint256 value);
147 }
148 
149 contract BasicToken is ERC20Basic, Ownable {
150   using SafeMath for uint256;
151     
152   mapping (address => uint256) balances;
153   uint256 totalSupply_;
154   mapping (address => uint256) public threeMonVesting;
155   mapping (address => uint256) public bonusVesting;
156   uint256 public launchBlock = 999999999999999999999999999999;
157   uint256 constant public monthSeconds = 2592000;
158   uint256 constant public secsPerBlock = 15; // 1 block per 15 seconds
159   bool public launch = false;
160   
161   function totalSupply() public view returns (uint256) {
162     return totalSupply_;
163   }
164 
165   modifier afterLaunch() {
166     require(block.number >= launchBlock || msg.sender == owner);
167     _;
168   }
169   
170   function checkVesting(address sender) public view returns (uint256) {
171       if (block.number >= launchBlock.add(monthSeconds.div(secsPerBlock).mul(6))) {
172           return balances[sender];
173       } else if (block.number >= launchBlock.add(monthSeconds.div(secsPerBlock).mul(3))) {
174           return balances[sender].sub(bonusVesting[sender]);
175       } else {
176           return balances[sender].sub(threeMonVesting[sender]).sub(bonusVesting[sender]);
177       }
178   }
179   
180   /**
181   * @dev transfer token for a specified address
182   * @param _to The address to transfer to.
183   * @param _value The amount to be transferred.
184   */
185   function transfer(address _to, uint256 _value) afterLaunch public returns (bool) {
186     require(_to != address(0));
187     require(_value <= balances[msg.sender]);
188     require(_value <= checkVesting(msg.sender));
189 
190     balances[msg.sender] = balances[msg.sender].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     emit Transfer(msg.sender, _to, _value);
193     return true;
194   }
195 
196   /**
197   * @dev Gets the balance of the specified address.
198   * @param _owner The address to query the the balance of. 
199   * @return An uint256 representing the amount owned by the passed address.
200   */
201   function balanceOf(address _owner) public view returns (uint256 balance) {
202     return balances[_owner];
203   }
204 }
205 
206 contract ERC20 is ERC20Basic {
207   function allowance(address owner, address spender) public view returns (uint256);
208   function transferFrom(address from, address to, uint256 value) public returns (bool);
209   function approve(address spender, uint256 value) public returns (bool);
210   event Approval(address indexed owner, address indexed spender, uint256 value);
211 }
212 
213 contract BurnableToken is BasicToken {
214 
215   event Burn(address indexed burner, uint256 value);
216 
217   /**
218    * @dev Burns a specific amount of tokens.
219    * @param _value The amount of token to be burned.
220    */
221   function burn(uint256 _value) afterLaunch public {
222     require(_value <= balances[msg.sender]);
223     require(_value <= checkVesting(msg.sender));
224     // no need to require value <= totalSupply, since that would imply the
225     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
226 
227     address burner = msg.sender;
228     balances[burner] = balances[burner].sub(_value);
229     totalSupply_ = totalSupply_.sub(_value);
230     emit Burn(burner, _value);
231     emit Transfer(burner, address(0), _value);
232   }
233 }
234 
235 contract StandardToken is ERC20, BurnableToken {
236 
237   mapping (address => mapping (address => uint256)) allowed;
238 
239   function transferFrom(address _from, address _to, uint256 _value) afterLaunch public returns (bool) {
240     
241     require(_to != address(0));
242     require(_value <= balances[_from]);
243     require(_value <= allowed[_from][msg.sender]);
244     require(_value <= checkVesting(_from));
245 
246     balances[_to] = balances[_to].add(_value);
247     balances[_from] = balances[_from].sub(_value);
248     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
249 
250     emit Transfer(_from, _to, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     emit Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifing the amount of tokens still avaible for the spender.
270    */
271   function allowance(address _owner, address _spender) public view returns (uint256) {
272     return allowed[_owner][_spender];
273   }
274   
275 }
276 
277 contract InstaToken is StandardToken {
278 
279   string constant public name = "INSTA";
280   string constant public symbol = "INSTA";
281   uint256 constant public decimals = 18;
282 
283   address constant public partnersWallet = 0x4092678e4E78230F46A1534C0fbc8fA39780892B; // change
284   uint256 public partnersPart = uint256(200000000).mul(10 ** decimals); // 20
285   
286   address constant public foundersWallet = 0x6748F50f686bfbcA6Fe8ad62b22228b87F31ff2b; // change
287   uint256 public foundersPart = uint256(200000000).mul(10 ** decimals); // 20
288   
289   address constant public treasuryWallet = 0xEa11755Ae41D889CeEc39A63E6FF75a02Bc1C00d; // change
290   uint256 public treasuryPart = uint256(150000000).mul(10 ** decimals); // 15
291   
292   uint256 public salePart = uint256(400000000).mul(10 ** decimals); // 40
293   
294   address constant public devWallet = 0x39Bb259F66E1C59d5ABEF88375979b4D20D98022; // change
295   uint256 public devPart = uint256(50000000).mul(10 ** decimals); // 5
296 
297   uint256 public INITIAL_SUPPLY = uint256(1000000000).mul(10 ** decimals); // 1 000 000 000 tokens
298     
299   uint256 public foundersWithdrawTokens = 0;
300   uint256 public partnersWithdrawTokens = 0;
301   
302   bool public oneTry = true;
303 
304   function setup() external {
305     require(address(msg.sender) == owner);
306     require(oneTry);
307 
308     totalSupply_ = INITIAL_SUPPLY;
309 
310     balances[msg.sender] = salePart;
311     emit Transfer(this, msg.sender, salePart);
312     
313     balances[devWallet] = devPart;
314     emit Transfer(this, devWallet, devPart);
315     
316     balances[treasuryWallet] = treasuryPart;
317     emit Transfer(this, treasuryWallet, treasuryPart);
318     
319     balances[address(this)] = INITIAL_SUPPLY.sub(treasuryPart.add(devPart).add(salePart));
320     emit Transfer(this, treasuryWallet, treasuryPart);
321     
322     oneTry = false;
323   }
324   
325   function setLaunchBlock() public onlyOwner {
326     require(!launch);
327     launchBlock = block.number.add(monthSeconds.div(secsPerBlock).div(2));
328     launch = true;
329   }
330   
331   modifier onlyFounders() {
332     require(msg.sender == foundersWallet);
333     _;
334   }
335   
336   modifier onlyPartners() {
337     require(msg.sender == partnersWallet);
338     _;
339   }
340   
341   function viewFoundersTokens() public view returns (uint256) {
342     if (block.number >= launchBlock.add(monthSeconds.div(secsPerBlock).mul(9))) {
343       return 200000000;
344     } else if (block.number >= launchBlock.add(monthSeconds.div(secsPerBlock).mul(6))) {
345       return 140000000;
346     } else if (block.number >= launchBlock.add(monthSeconds.div(secsPerBlock).mul(3))) {
347       return 80000000;
348     } else if (block.number >= launchBlock) {
349       return 20000000;
350     }
351   }
352   
353   function viewPartnersTokens() public view returns (uint256) {
354     if (block.number >= launchBlock.add(monthSeconds.div(secsPerBlock).mul(9))) {
355       return 200000000;
356     } else if (block.number >= launchBlock.add(monthSeconds.div(secsPerBlock).mul(6))) {
357       return 140000000;
358     } else if (block.number >= launchBlock.add(monthSeconds.div(secsPerBlock).mul(3))) {
359       return 80000000;
360     } else if (block.number >= launchBlock) {
361       return 20000000;
362     }
363   }
364   
365   function getFoundersTokens(uint256 _tokens) public onlyFounders {
366     uint256 tokens = _tokens.mul(10 ** decimals);
367     require(foundersWithdrawTokens.add(tokens) <= viewFoundersTokens().mul(10 ** decimals));
368     transfer(foundersWallet, tokens);
369     emit Transfer(this, foundersWallet, tokens);
370     foundersWithdrawTokens = foundersWithdrawTokens.add(tokens);
371   }
372   
373   function getPartnersTokens(uint256 _tokens) public onlyPartners {
374     uint256 tokens = _tokens.mul(10 ** decimals);
375     require(partnersWithdrawTokens.add(tokens) <= viewPartnersTokens().mul(10 ** decimals));
376     transfer(partnersWallet, tokens);
377     emit Transfer(this, partnersWallet, tokens);
378     partnersWithdrawTokens = partnersWithdrawTokens.add(tokens);
379   }
380 
381   function addBonusTokens(address sender, uint256 amount) external onlyOwner {
382       bonusVesting[sender] = bonusVesting[sender].add(amount);
383   }
384   
385   function freezeTokens(address sender, uint256 amount) external onlyOwner {
386       threeMonVesting[sender] = threeMonVesting[sender].add(amount);
387   }
388 }