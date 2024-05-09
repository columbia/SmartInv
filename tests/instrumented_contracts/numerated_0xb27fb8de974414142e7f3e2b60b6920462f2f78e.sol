1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner 
30   {
31     require(newOwner != address(0));      
32     owner = newOwner;
33   }
34 
35 }
36 
37 contract Contactable is Ownable {
38 
39     string public contactInformation;
40 
41     /**
42      * @dev Allows the owner to set a string with their contact information.
43      * @param info The contact information to attach to the contract.
44      */
45     function setContactInformation(string info) onlyOwner 
46     {
47          contactInformation = info;
48      }
49 }
50 
51 contract Destructible is Ownable {
52 
53   function Destructible() payable 
54   { 
55 
56   } 
57 
58   /**
59    * @dev Transfers the current balance to the owner and terminates the contract. 
60    */
61   function destroy() onlyOwner 
62   {
63     selfdestruct(owner);
64   }
65 
66   function destroyAndSend(address _recipient) onlyOwner 
67   {
68     selfdestruct(_recipient);
69   }
70 }
71 
72 contract Pausable is Ownable {
73   event Pause();
74   event Unpause();
75 
76   bool public paused = false;
77 
78 
79   /**
80    * @dev modifier to allow actions only when the contract IS paused
81    */
82   modifier whenNotPaused() {
83     require(!paused);
84     _;
85   }
86 
87   /**
88    * @dev modifier to allow actions only when the contract IS NOT paused
89    */
90   modifier whenPaused() {
91     require(paused);
92     _;
93   }
94 
95   /**
96    * @dev called by the owner to pause, triggers stopped state
97    */
98   function pause() onlyOwner whenNotPaused 
99   {
100     paused = true;
101     Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() onlyOwner whenPaused 
108   {
109     paused = false;
110     Unpause();
111   }
112 }
113 
114 
115 contract ERC20 {
116     uint256 public totalSupply;
117     function balanceOf(address who) constant returns (uint256);
118     
119     function transfer(address to, uint256 value) returns (bool);
120     event Transfer(address indexed from, address indexed to, uint256 value);
121     
122     function allowance(address owner, address spender) constant returns (uint256);
123     function transferFrom(address from, address to, uint256 value) returns (bool);
124     
125     function approve(address spender, uint256 value) returns (bool);
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 library SafeMath {
130   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
131     uint256 c = a * b;
132     assert(a == 0 || c / a == b);
133     return c;
134   }
135 
136   function div(uint256 a, uint256 b) internal constant returns (uint256) {
137     // assert(b > 0); // Solidity automatically throws when dividing by 0
138     uint256 c = a / b;
139     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
140     return c;
141   }
142 
143   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
144     assert(b <= a);
145     return a - b;
146   }
147 
148   function add(uint256 a, uint256 b) internal constant returns (uint256) {
149     uint256 c = a + b;
150     assert(c >= a);
151     return c;
152   }
153 }
154 
155 contract StandardToken is ERC20 {
156     using SafeMath for uint256;
157     mapping(address => uint256) balances;
158     mapping (address => mapping (address => uint256)) allowed;
159 
160 
161  
162   function balanceOf(address _owner) constant returns (uint256 balance) {
163     return balances[_owner];
164   }
165 
166 
167   function approve(address _spender, uint256 _value) returns (bool) {
168 
169     // To change the approve amount you first have to reduce the addresses`
170     //  allowance to zero by calling `approve(_spender, 0)` if it is not
171     //  already 0 to mitigate the race condition described here:
172     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
174 
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
181     return allowed[_owner][_spender];
182   }
183 
184 
185 
186 
187 }
188 
189 
190 contract MintableToken is StandardToken, Ownable {
191   event Mint(address indexed to, uint256 amount);
192   event MintFinished();
193 
194   bool public mintingFinished = false;
195 
196 
197   modifier canMint() {
198     require(!mintingFinished);
199     _;
200   }
201 
202   /**
203    * @dev Function to mint tokens
204    * @param _to The address that will receive the minted tokens.
205    * @param _amount The amount of tokens to mint.
206    * @return A boolean that indicates if the operation was successful.
207    */
208   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
209     totalSupply = totalSupply.add(_amount);
210     balances[_to] = balances[_to].add(_amount);
211     Mint(_to, _amount);
212     Transfer(0x0, _to, _amount);
213     return true;
214   }
215 
216   /**
217    * @dev Function to stop minting new tokens.
218    * @return True if the operation was successful.
219    */
220   function finishMinting() onlyOwner returns (bool) {
221     mintingFinished = true;
222     MintFinished();
223     return true;
224   }
225 }
226 
227 
228 contract TeamCoin is Ownable, Destructible, Contactable, MintableToken {
229     using SafeMath for uint256;
230 
231 
232        // start and end timestamps where investments are allowed (both inclusive)
233     uint256 public startBlock;
234     uint256 public endBlock;
235 
236     // address where funds are collected
237     address public wallet;
238 
239     // how many token units a buyer gets per wei
240     uint256 public rate;
241 
242     // amount of raised money in wei
243     uint256 public weiRaised;
244 
245     //Constant of max suppliable tokens
246     uint256 constant MAXSUPPLY = 2000000000000000000000000;
247 
248 
249   string public name = "TeamCoin";
250   string public symbol = "TMC";
251   uint public decimals = 18;
252   uint public OWNER_SUPPLY = 1200000000000000000000000;
253   address public owner;
254   bool public locked;
255 
256     modifier onlyUnlocked() {
257 
258       if (owner != msg.sender) {
259         require(false == locked);
260       }
261       _;
262     }
263 
264   function TeamCoin() {
265       startBlock = block.number + 800;
266       endBlock = startBlock + 50000;
267         
268       require(endBlock >= startBlock);
269         
270       rate = 25;
271       wallet = msg.sender;
272       locked = true;
273       owner = msg.sender;
274       totalSupply = MAXSUPPLY;
275       balances[owner] = MAXSUPPLY;
276       contactInformation = "http://www.teamco.in";
277   }
278 
279   function unlock() onlyOwner 
280     {
281       require(locked);   // to allow only 1 call
282       locked = false;
283   }
284   
285   
286   function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked returns (bool) {
287     var _allowance = allowed[_from][msg.sender];
288 
289     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
290     // require (_value <= _allowance);
291 
292     balances[_to] = balances[_to].add(_value);
293     balances[_from] = balances[_from].sub(_value);
294     allowed[_from][msg.sender] = _allowance.sub(_value);
295     Transfer(_from, _to, _value);
296     return true;
297   }
298   
299    function transfer(address _to, uint256 _value) onlyUnlocked returns (bool) {
300     balances[msg.sender] = balances[msg.sender].sub(_value);
301     balances[_to] = balances[_to].add(_value);
302     Transfer(msg.sender, _to, _value);
303     return true;
304   }
305 
306 
307   
308     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
309 
310     function () payable 
311     {
312         buyTokens(msg.sender);
313     }
314 
315     // low level token purchase function
316     function buyTokens(address beneficiary) payable
317      {
318         require(beneficiary != 0x0);
319         require(validPurchase());
320         uint256 weiAmount = msg.value;
321         // calculate token amount to be created
322         uint256 tokens = weiAmount.mul(rate);
323         // update state
324         weiRaised = weiRaised.add(weiAmount);
325         balances[owner] = balances[owner].sub(tokens);
326         balances[beneficiary] = balances[beneficiary].add(tokens);
327         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
328 
329         forwardFunds(); // funds are forward finally 
330         
331     }
332 
333     // send ether to the fund collection wallet
334     // override to create custom fund forwarding mechanisms
335     function forwardFunds() internal 
336     {
337         wallet.transfer(msg.value);
338     }
339 
340     function validPurchase() internal constant returns (bool) {
341         uint256 current = block.number;
342         bool withinPeriod = current >= startBlock && current <= endBlock;
343         bool nonZeroPurchase = msg.value != 0;
344         bool nonMaxPurchase = msg.value <= 1000 ether;
345         bool maxSupplyNotReached = balances[owner] > OWNER_SUPPLY; // check if the balance of the owner hasnt reached the initial supply
346         return withinPeriod && nonZeroPurchase && nonMaxPurchase && maxSupplyNotReached;
347     }
348 
349     function hasEnded() public constant returns (bool) {
350         return block.number > endBlock;
351     }
352 
353    function burn(uint _value) onlyOwner 
354    {
355         require(_value > 0);
356         address burner = msg.sender;
357         balances[burner] = balances[burner].sub(_value);
358         totalSupply = totalSupply.sub(_value);
359         Burn(burner, _value);
360     }
361 
362     event Burn(address indexed burner, uint indexed value);
363 
364 }