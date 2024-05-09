1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4   address public owner;
5   /**
6    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
7    * account.
8    */
9   function Ownable() {
10     owner = msg.sender;
11   }
12 
13   /**
14    * @dev Throws if called by any account other than the owner.
15    */
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21   /**
22    * @dev Allows the current owner to transfer control of the contract to a newOwner.
23    * @param newOwner The address to transfer ownership to.
24    */
25   function transferOwnership(address newOwner) onlyOwner
26   {
27     require(newOwner != address(0));
28     owner = newOwner;
29   }
30 
31 }
32 
33 contract Contactable is Ownable {
34 
35     string public contactInformation;
36 
37     /**
38      * @dev Allows the owner to set a string with their contact information.
39      * @param info The contact information to attach to the contract.
40      */
41     function setContactInformation(string info) onlyOwner
42     {
43          contactInformation = info;
44     }
45 }
46 
47 contract Destructible is Ownable {
48 
49   function Destructible() payable
50   {
51 
52   }
53 
54   /**
55    * @dev Transfers the current balance to the owner and terminates the contract.
56    */
57   function destroy() onlyOwner
58   {
59     selfdestruct(owner);
60   }
61 
62   function destroyAndSend(address _recipient) onlyOwner
63   {
64     selfdestruct(_recipient);
65   }
66 }
67 
68 contract Pausable is Ownable {
69   event Pause();
70   event Unpause();
71 
72   bool public paused = false;
73 
74 
75   /**
76    * @dev modifier to allow actions only when the contract IS paused
77    */
78   modifier whenNotPaused() {
79     require(!paused);
80     _;
81   }
82 
83   /**
84    * @dev modifier to allow actions only when the contract IS NOT paused
85    */
86   modifier whenPaused() {
87     require(paused);
88     _;
89   }
90 
91   /**
92    * @dev called by the owner to pause, triggers stopped state
93    */
94   function pause() onlyOwner whenNotPaused
95   {
96     paused = true;
97     Pause();
98   }
99 
100   /**
101    * @dev called by the owner to unpause, returns to normal state
102    */
103   function unpause() onlyOwner whenPaused
104   {
105     paused = false;
106     Unpause();
107   }
108 }
109 
110 
111 contract ERC20 {
112     uint256 public totalSupply;
113     function balanceOf(address who) constant returns (uint256);
114 
115     function transfer(address to, uint256 value) returns (bool);
116     event Transfer(address indexed from, address indexed to, uint256 value);
117 
118     function allowance(address owner, address spender) constant returns (uint256);
119     function transferFrom(address from, address to, uint256 value) returns (bool);
120 
121     function approve(address spender, uint256 value) returns (bool);
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 library SafeMath {
126   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
127     uint256 c = a * b;
128     assert(a == 0 || c / a == b);
129     return c;
130   }
131 
132   function div(uint256 a, uint256 b) internal constant returns (uint256) {
133     // assert(b > 0); // Solidity automatically throws when dividing by 0
134     uint256 c = a / b;
135     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136     return c;
137   }
138 
139   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
140     assert(b <= a);
141     return a - b;
142   }
143 
144   function add(uint256 a, uint256 b) internal constant returns (uint256) {
145     uint256 c = a + b;
146     assert(c >= a);
147     return c;
148   }
149 }
150 
151 contract StandardToken is ERC20 {
152     using SafeMath for uint256;
153     mapping(address => uint256) balances;
154     mapping (address => mapping (address => uint256)) allowed;
155 
156 
157 
158   function balanceOf(address _owner) constant returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 
163   function approve(address _spender, uint256 _value) returns (bool) {
164 
165     // To change the approve amount you first have to reduce the addresses`
166     //  allowance to zero by calling `approve(_spender, 0)` if it is not
167     //  already 0 to mitigate the race condition described here:
168     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
170 
171     allowed[msg.sender][_spender] = _value;
172     Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
177     return allowed[_owner][_spender];
178   }
179 }
180 
181 contract MintableToken is StandardToken, Ownable {
182   event Mint(address indexed to, uint256 amount);
183   event MintFinished();
184 
185   bool public mintingFinished = false;
186 
187 
188   modifier canMint() {
189     require(!mintingFinished);
190     _;
191   }
192 
193   /**
194    * @dev Function to mint tokens
195    * @param _to The address that will receive the minted tokens.
196    * @param _amount The amount of tokens to mint.
197    * @return A boolean that indicates if the operation was successful.
198    */
199   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
200     totalSupply = totalSupply.add(_amount);
201     balances[_to] = balances[_to].add(_amount);
202     Mint(_to, _amount);
203     Transfer(0x0, _to, _amount);
204     return true;
205   }
206 
207   /**
208    * @dev Function to stop minting new tokens.
209    * @return True if the operation was successful.
210    */
211   function finishMinting() onlyOwner returns (bool) {
212     mintingFinished = true;
213     MintFinished();
214     return true;
215   }
216 }
217 
218 
219 contract GTA is Ownable, Destructible, Contactable, MintableToken {
220     using SafeMath for uint256;
221 
222 
223        // start and end timestamps where investments are allowed (both inclusive)
224     uint256 public startBlock;
225     uint256 public endBlock;
226 
227     // address where funds are collected
228     address public wallet;
229 
230     // how many token units a buyer gets per wei
231     uint256 public rate;
232 
233     // amount of raised money in wei
234     uint256 public weiRaised;
235 
236     //Constant of max suppliable tokens  .
237     uint256 constant MAXSUPPLY = 200000000000000000000000000;
238 
239   string public name = "GROUP TOKEN ALIANCE";
240   string public symbol = "GTA";
241   uint public decimals = 18;
242   uint public OWNER_SUPPLY = 200000000000000000000000000;
243   address public owner;
244   bool public locked;
245 
246     modifier onlyUnlocked() {
247 
248       if (owner != msg.sender) {
249         require(false == locked);
250       }
251       _;
252     }
253 
254   function GTA() {
255       startBlock = block.number + 2;
256       endBlock = startBlock + 1;
257 
258       require(endBlock >= startBlock);
259 
260       rate = 2500;
261       wallet = msg.sender;
262       locked = true;
263       owner = msg.sender;
264       totalSupply = MAXSUPPLY;
265       balances[owner] = MAXSUPPLY;
266       contactInformation = "http://www.groupco.in";
267   }
268 
269   function unlock() onlyOwner
270     {
271       require(locked);   // to allow only 1 call
272       locked = false;
273   }
274 
275 
276   function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked returns (bool) {
277     var _allowance = allowed[_from][msg.sender];
278 
279     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
280     // require (_value <= _allowance);
281 
282     balances[_to] = balances[_to].add(_value);
283     balances[_from] = balances[_from].sub(_value);
284     allowed[_from][msg.sender] = _allowance.sub(_value);
285     Transfer(_from, _to, _value);
286     return true;
287   }
288 
289    function transfer(address _to, uint256 _value) onlyUnlocked returns (bool) {
290     balances[msg.sender] = balances[msg.sender].sub(_value);
291     balances[_to] = balances[_to].add(_value);
292     Transfer(msg.sender, _to, _value);
293     return true;
294   }
295 
296 
297 
298     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
299 
300     function () payable
301     {
302         buyTokens(msg.sender);
303     }
304 
305     // low level token purchase function
306     function buyTokens(address beneficiary) payable
307      {
308         require(beneficiary != 0x0);
309         require(validPurchase());
310         uint256 weiAmount = msg.value;
311         // calculate token amount to be created
312         uint256 tokens = weiAmount.mul(rate);
313         // update state
314         weiRaised = weiRaised.add(weiAmount);
315         balances[owner] = balances[owner].sub(tokens);
316         balances[beneficiary] = balances[beneficiary].add(tokens);
317         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
318 
319         forwardFunds(); // funds are forward finally
320 
321     }
322 
323     // send ether to the fund collection wallet
324     // override to create custom fund forwarding mechanisms
325     function forwardFunds() internal
326     {
327         wallet.transfer(msg.value);
328     }
329 
330     function validPurchase() internal constant returns (bool) {
331         uint256 current = block.number;
332         bool withinPeriod = current >= startBlock && current <= endBlock;
333         bool nonZeroPurchase = msg.value != 0;
334         bool nonMaxPurchase = msg.value <= 1000 ether;
335         bool maxSupplyNotReached = balances[owner] > OWNER_SUPPLY; // check if the balance of the owner hasnt reached the initial supply
336         return withinPeriod && nonZeroPurchase && nonMaxPurchase && maxSupplyNotReached;
337     }
338 
339     function hasEnded() public constant returns (bool) {
340         return block.number > endBlock;
341     }
342 
343    function burn(uint _value) onlyOwner
344    {
345         require(_value > 0);
346         address burner = msg.sender;
347         balances[burner] = balances[burner].sub(_value);
348         totalSupply = totalSupply.sub(_value);
349         Burn(burner, _value);
350     }
351 
352     event Burn(address indexed burner, uint indexed value);
353 
354 }