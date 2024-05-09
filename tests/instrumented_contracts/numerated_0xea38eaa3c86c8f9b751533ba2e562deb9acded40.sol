1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7   address public owner;
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner {
33     if (newOwner != address(0)) {
34       owner = newOwner;
35     }
36   }
37 
38 }
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal constant returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal constant returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/179
74  */
75 contract ERC20Basic {
76   uint256 public totalSupply;
77   function balanceOf(address who) constant returns (uint256);
78   function transfer(address to, uint256 value) returns (bool);
79   event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87   function allowance(address owner, address spender) constant returns (uint256);
88   function transferFrom(address from, address to, uint256 value) returns (bool);
89   function approve(address spender, uint256 value) returns (bool);
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 /**
95  * @title Pausable
96  * @dev Base contract which allows children to implement an emergency stop mechanism.
97  */
98 contract Pausable is Ownable {
99   event Pause();
100   event Unpause();
101 
102   bool public paused = false;
103 
104 
105   /**
106    * @dev modifier to allow actions only when the contract IS paused
107    */
108   modifier whenNotPaused() {
109     require(!paused);
110     _;
111   }
112 
113   /**
114    * @dev modifier to allow actions only when the contract IS NOT paused
115    */
116   modifier whenPaused {
117     require(paused);
118     _;
119   }
120 
121   /**
122    * @dev called by the owner to pause, triggers stopped state
123    */
124   function pause() onlyOwner whenNotPaused returns (bool) {
125     paused = true;
126     Pause();
127     return true;
128   }
129 
130   /**
131    * @dev called by the owner to unpause, returns to normal state
132    */
133   function unpause() onlyOwner whenPaused returns (bool) {
134     paused = false;
135     Unpause();
136     return true;
137   }
138 }
139 
140 /**
141  * @title NonZero
142  */
143 contract NonZero {
144 
145 // Functions with this modifier fail if he 
146     modifier nonZeroAddress(address _to) {
147         require(_to != 0x0);
148         _;
149     }
150 
151     modifier nonZeroAmount(uint _amount) {
152         require(_amount > 0);
153         _;
154     }
155 
156     modifier nonZeroValue() {
157         require(msg.value > 0);
158         _;
159     }
160 
161     // prevents short address attack
162     // standard size = 2 * 32
163     modifier onlyPayloadSize(uint size) {
164 	// we assert the msg data is greater than or equal to, because
165 	// a multisgi wallet will be greater than standard payload size of 64 bits
166     assert(msg.data.length >= size + 4);
167      _;
168    } 
169 }
170 
171 contract FuelToken is ERC20, Ownable, NonZero {
172 
173     using SafeMath for uint;
174 
175 /////////////////////// TOKEN INFORMATION ///////////////////////
176     string public constant name = "Fuel Token";
177     string public constant symbol = "FUEL";
178 
179     uint8 public decimals = 18;
180     
181     // Mapping to keep user's balances
182     mapping (address => uint256) balances;
183     // Mapping to keep user's allowances
184     mapping (address => mapping (address => uint256)) allowed;
185 
186 /////////////////////// VARIABLE INITIALIZATION ///////////////////////
187     
188     // Allocation for the Vanbex Team
189     uint256 public vanbexTeamSupply;
190     // Etherparty platform supply
191     uint256 public platformSupply;
192     // Amount of FUEL for the presale
193     uint256 public presaleSupply;
194     // Amount of presale tokens remaining at a given time
195     uint256 public presaleAmountRemaining;
196     // Total ICO supply
197     uint256 public icoSupply;
198     // Community incentivisation supply
199     uint256 public incentivisingEffortsSupply;
200     // Crowdsale End Timestamp
201     uint256 public crowdfundEndsAt;
202     // Vesting period for the Vanbex Team allocation
203     uint256 public vanbexTeamVestingPeriod;
204 
205     // Crowdfund Address
206     address public crowdfundAddress;
207     // Vanbex team address
208     address public vanbexTeamAddress;
209     // Etherparty platform address
210     address public platformAddress;
211     // Community incentivisation address
212     address public incentivisingEffortsAddress;
213 
214     // Flag keeping track of presale status. Ensures functions can only be called once
215     bool public presaleFinalized = false;
216     // Flag keeping track of crowdsale status. Ensures functions can only be called once
217     bool public crowdfundFinalized = false;
218 
219 /////////////////////// EVENTS ///////////////////////
220 
221     // Event called when crowdfund is done
222     event CrowdfundFinalized(uint tokensRemaining);
223     // Event called when presale is done
224     event PresaleFinalized(uint tokensRemaining);
225 
226 /////////////////////// MODIFIERS ///////////////////////
227 
228     // Ensure actions can only happen after crowdfund ends
229     modifier notBeforeCrowdfundEnds(){
230         require(now >= crowdfundEndsAt);
231         _;
232     }
233 
234     // Ensure vesting period is over
235     modifier checkVanbexTeamVestingPeriod() {
236         assert(now >= vanbexTeamVestingPeriod);
237         _;
238     }
239 
240     // Ensure only crowdfund can call the function
241     modifier onlyCrowdfund() {
242         require(msg.sender == crowdfundAddress);
243         _;
244     }
245 
246 /////////////////////// ERC20 FUNCTIONS ///////////////////////
247 
248     // Transfer
249     function transfer(address _to, uint256 _amount) notBeforeCrowdfundEnds returns (bool success) {
250         require(balanceOf(msg.sender) >= _amount);
251         addToBalance(_to, _amount);
252         decrementBalance(msg.sender, _amount);
253         Transfer(msg.sender, _to, _amount);
254         return true;
255     }
256 
257     // Transfer from one address to another (need allowance to be called first)
258     function transferFrom(address _from, address _to, uint256 _amount) notBeforeCrowdfundEnds returns (bool success) {
259         require(allowance(_from, msg.sender) >= _amount);
260         decrementBalance(_from, _amount);
261         addToBalance(_to, _amount);
262         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
263         Transfer(_from, _to, _amount);
264         return true;
265     }
266 
267     // Approve another address a certain amount of FUEL
268     function approve(address _spender, uint256 _value) returns (bool success) {
269         require((_value == 0) || (allowance(msg.sender, _spender) == 0));
270         allowed[msg.sender][_spender] = _value;
271         Approval(msg.sender, _spender, _value);
272         return true;
273     }
274 
275     // Get an address's FUEL allowance
276     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
277         return allowed[_owner][_spender];
278     }
279 
280     // Get the FUEL balance of any address
281     function balanceOf(address _owner) constant returns (uint256 balance) {
282         return balances[_owner];
283     }
284 
285 /////////////////////// TOKEN FUNCTIONS ///////////////////////
286 
287     // Constructor
288     function FuelToken() {
289         crowdfundEndsAt = 1509292800;                                               // Oct 29, 9 AM PST
290         vanbexTeamVestingPeriod = crowdfundEndsAt.add(183 * 1 days);                // 6 months vesting period
291 
292         totalSupply = 1 * 10**27;                                                   // 100% - 1 billion total FUEL tokens with 18 decimals
293         vanbexTeamSupply = 5 * 10**25;                                              // 5% - 50 million for etherparty team
294         platformSupply = 5 * 10**25;                                                // 5% - 50 million to be sold on the etherparty platform in-app
295         incentivisingEffortsSupply = 1 * 10**26;                                    // 10% - 100 million for incentivising efforts
296         presaleSupply = 54 * 10**25;                                                // 540,000,000 fuel tokens available for presale with overflow for bonus included
297         icoSupply = 26 * 10**25;                                                    // 260 million fuel tokens for ico with potential for extra after finalizing presale
298        
299         presaleAmountRemaining = presaleSupply;                                     // Decreased over the course of the pre-sale
300         vanbexTeamAddress = 0xCF701D8eA4C727466D42651dda127c0c033076B0;             // Vanbex Team Address
301         platformAddress = 0xF5b5f6c1E233671B220C2A19Af10Fd18785D0744;               // Platform Address
302         incentivisingEffortsAddress = 0x5584b17B40F6a2E412e65FcB1533f39Fc7D8Aa26;   // Community incentivisation address
303 
304         addToBalance(incentivisingEffortsAddress, incentivisingEffortsSupply);     
305         addToBalance(platformAddress, platformSupply);                              
306     }
307 
308     // Sets the crowdfund address, can only be done once
309     function setCrowdfundAddress(address _crowdfundAddress) external onlyOwner nonZeroAddress(_crowdfundAddress) {
310         require(crowdfundAddress == 0x0);
311         crowdfundAddress = _crowdfundAddress;
312         addToBalance(crowdfundAddress, icoSupply); 
313     }
314 
315     // Function for the Crowdfund to transfer tokens
316     function transferFromCrowdfund(address _to, uint256 _amount) onlyCrowdfund nonZeroAmount(_amount) nonZeroAddress(_to) returns (bool success) {
317         require(balanceOf(crowdfundAddress) >= _amount);
318         decrementBalance(crowdfundAddress, _amount);
319         addToBalance(_to, _amount);
320         Transfer(0x0, _to, _amount);
321         return true;
322     }
323 
324     // Release Vanbex team supply after vesting period is finished.
325     function releaseVanbexTeamTokens() checkVanbexTeamVestingPeriod onlyOwner returns(bool success) {
326         require(vanbexTeamSupply > 0);
327         addToBalance(vanbexTeamAddress, vanbexTeamSupply);
328         Transfer(0x0, vanbexTeamAddress, vanbexTeamSupply);
329         vanbexTeamSupply = 0;
330         return true;
331     }
332 
333     // Finalize presale. If there are leftover FUEL, let them overflow to the crowdfund
334     function finalizePresale() external onlyOwner returns (bool success) {
335         require(presaleFinalized == false);
336         uint256 amount = presaleAmountRemaining;
337         if (amount != 0) {
338             presaleAmountRemaining = 0;
339             addToBalance(crowdfundAddress, amount);
340         }
341         presaleFinalized = true;
342         PresaleFinalized(amount);
343         return true;
344     }
345 
346     // Finalize crowdfund. If there are leftover FUEL, let them overflow to the be sold at 1$ on the platform
347     function finalizeCrowdfund() external onlyCrowdfund {
348         require(presaleFinalized == true && crowdfundFinalized == false);
349         uint256 amount = balanceOf(crowdfundAddress);
350         if (amount > 0) {
351             balances[crowdfundAddress] = 0;
352             addToBalance(platformAddress, amount);
353             Transfer(crowdfundAddress, platformAddress, amount);
354         }
355         crowdfundFinalized = true;
356         CrowdfundFinalized(amount);
357     }
358 
359 
360     // Function to send FUEL to presale investors
361     function deliverPresaleFuelBalances(address[] _batchOfAddresses, uint[] _amountOfFuel) external onlyOwner returns (bool success) {
362         for (uint256 i = 0; i < _batchOfAddresses.length; i++) {
363             deliverPresaleFuelBalance(_batchOfAddresses[i], _amountOfFuel[i]);            
364         }
365         return true;
366     }
367 
368     // All presale purchases will be delivered. If one address has contributed more than once,
369     // his contribution will be aggregated
370     function deliverPresaleFuelBalance(address _accountHolder, uint _amountOfBoughtFuel) internal onlyOwner {
371         require(presaleAmountRemaining > 0);
372         addToBalance(_accountHolder, _amountOfBoughtFuel);
373         Transfer(0x0, _accountHolder, _amountOfBoughtFuel);
374         presaleAmountRemaining = presaleAmountRemaining.sub(_amountOfBoughtFuel);    
375     }
376 
377     // Add to balance
378     function addToBalance(address _address, uint _amount) internal {
379     	balances[_address] = balances[_address].add(_amount);
380     }
381 
382     // Remove from balance
383     function decrementBalance(address _address, uint _amount) internal {
384     	balances[_address] = balances[_address].sub(_amount);
385     }
386 }