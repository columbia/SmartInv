1 pragma solidity ^0.4.3;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   uint256 public totalSupply;
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 /**
56  * @title ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) public view returns (uint256);
61   function transferFrom(address from, address to, uint256 value) public returns (bool);
62   function approve(address spender, uint256 value) public returns (bool);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract ERC677 is ERC20 {
67   function transferAndCall(address to, uint value, bytes data) public returns (bool success);
68 
69   event Transfer(address indexed from, address indexed to, uint value, bytes data);
70 }
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a * b;
79     assert(a == 0 || c / a == b);
80     return c;
81   }
82 
83   function div(uint256 a, uint256 b) internal pure returns (uint256) {
84     // assert(b > 0); // Solidity automatically throws when dividing by 0
85     uint256 c = a / b;
86     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87     return c;
88   }
89 
90   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   function add(uint256 a, uint256 b) internal pure returns (uint256) {
96     uint256 c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 }
101 
102 contract PoolOwners is Ownable {
103 
104     mapping(uint64 => address)  private ownerAddresses;
105     mapping(address => bool)    private whitelist;
106 
107     mapping(address => uint256) public ownerPercentages;
108     mapping(address => uint256) public ownerShareTokens;
109     mapping(address => uint256) public tokenBalance;
110 
111     mapping(address => mapping(address => uint256)) private balances;
112 
113     uint64  public totalOwners = 0;
114     uint16  public distributionMinimum = 20;
115 
116     bool   private contributionStarted = false;
117     bool   private distributionActive = false;
118 
119     // Public Contribution Variables
120     uint256 private ethWei = 1000000000000000000; // 1 ether in wei
121     uint256 private valuation = ethWei * 4000; // 1 ether * 4000
122     uint256 private hardCap = ethWei * 1000; // 1 ether * 1000
123     address private wallet;
124     bool    private locked = false;
125 
126     uint256 public totalContributed = 0;
127 
128     // The contract hard-limit is 0.04 ETH due to the percentage precision, lowest % possible is 0.001%
129     // It's been set at 0.2 ETH to try and minimise the sheer number of contributors as that would up the distribution GAS cost
130     uint256 private minimumContribution = 200000000000000000; // 0.2 ETH
131 
132     /**
133         Events
134      */
135 
136     event Contribution(address indexed sender, uint256 share, uint256 amount);
137     event TokenDistribution(address indexed token, uint256 amount);
138     event TokenWithdrawal(address indexed token, address indexed owner, uint256 amount);
139     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint256 amount);
140 
141     /**
142         Modifiers
143      */
144 
145     modifier onlyWhitelisted() {
146         require(whitelist[msg.sender]);
147         _;
148     }
149 
150     /**
151         Contribution Methods
152      */
153 
154     // Fallback, redirects to contribute
155     function() public payable { contribute(msg.sender); }
156 
157     function contribute(address sender) internal {
158         // Make sure the shares aren't locked
159         require(!locked);
160 
161         // Ensure the contribution phase has started
162         require(contributionStarted);
163 
164         // Make sure they're in the whitelist
165         require(whitelist[sender]);
166 
167         // Assert that the contribution is above or equal to the minimum contribution
168         require(msg.value >= minimumContribution);
169 
170         // Make sure the contribution isn't above the hard cap
171         require(hardCap >= msg.value);
172 
173         // Ensure the amount contributed is cleanly divisible by the minimum contribution
174         require((msg.value % minimumContribution) == 0);
175 
176         // Make sure the contribution doesn't exceed the hardCap
177         require(hardCap >= SafeMath.add(totalContributed, msg.value));
178 
179         // Increase the total contributed
180         totalContributed = SafeMath.add(totalContributed, msg.value);
181 
182         // Calculated share
183         uint256 share = percent(msg.value, valuation, 5);
184 
185         // Calculate and set the contributors % holding
186         if (ownerPercentages[sender] != 0) { // Existing contributor
187             ownerShareTokens[sender] = SafeMath.add(ownerShareTokens[sender], msg.value);
188             ownerPercentages[sender] = SafeMath.add(share, ownerPercentages[sender]);
189         } else { // New contributor
190             ownerAddresses[totalOwners] = sender;
191             totalOwners += 1;
192             ownerPercentages[sender] = share;
193             ownerShareTokens[sender] = msg.value;
194         }
195 
196         // Transfer the ether to the wallet
197         wallet.transfer(msg.value);
198 
199         // Fire event
200         emit Contribution(sender, share, msg.value);
201     }
202 
203     // Add a wallet to the whitelist
204     function whitelistWallet(address contributor) external onlyOwner() {
205         // Is it actually an address?
206         require(contributor != address(0));
207 
208         // Add address to whitelist
209         whitelist[contributor] = true;
210     }
211 
212     // Start the contribution
213     function startContribution() external onlyOwner() {
214         require(!contributionStarted);
215         contributionStarted = true;
216     }
217 
218     /**
219         Public Methods
220      */
221 
222     // Set the owners share per owner, the balancing of shares is done externally
223     function setOwnerShare(address owner, uint256 value) public onlyOwner() {
224         // Make sure the shares aren't locked
225         require(!locked);
226 
227         if (ownerShareTokens[owner] == 0) {
228             whitelist[owner] = true;
229             ownerAddresses[totalOwners] = owner;
230             totalOwners += 1;
231         }
232         ownerShareTokens[owner] = value;
233         ownerPercentages[owner] = percent(value, valuation, 5);
234     }
235 
236     // Non-Standard token transfer, doesn't confine to any ERC
237     function sendOwnership(address receiver, uint256 amount) public onlyWhitelisted() {
238         // Require they have an actual balance
239         require(ownerShareTokens[msg.sender] > 0);
240 
241         // Require the amount to be equal or less to their shares
242         require(ownerShareTokens[msg.sender] >= amount);
243 
244         // Deduct the amount from the owner
245         ownerShareTokens[msg.sender] = SafeMath.sub(ownerShareTokens[msg.sender], amount);
246 
247         // Remove the owner if the share is now 0
248         if (ownerShareTokens[msg.sender] == 0) {
249             ownerPercentages[msg.sender] = 0;
250             whitelist[receiver] = false; 
251             
252         } else { // Recalculate percentage
253             ownerPercentages[msg.sender] = percent(ownerShareTokens[msg.sender], valuation, 5);
254         }
255 
256         // Add the new share holder
257         if (ownerShareTokens[receiver] == 0) {
258             whitelist[receiver] = true;
259             ownerAddresses[totalOwners] = receiver;
260             totalOwners += 1;
261         }
262         ownerShareTokens[receiver] = SafeMath.add(ownerShareTokens[receiver], amount);
263         ownerPercentages[receiver] = SafeMath.add(ownerPercentages[receiver], percent(amount, valuation, 5));
264 
265         emit OwnershipTransferred(msg.sender, receiver, amount);
266     }
267 
268     // Lock the shares so contract owners cannot change them
269     function lockShares() public onlyOwner() {
270         require(!locked);
271         locked = true;
272     }
273 
274     // Distribute the tokens in the contract to the contributors/creators
275     function distributeTokens(address token) public onlyWhitelisted() {
276         // Is this method already being called?
277         require(!distributionActive);
278         distributionActive = true;
279 
280         // Get the token address
281         ERC677 erc677 = ERC677(token);
282 
283         // Has the contract got a balance?
284         uint256 currentBalance = erc677.balanceOf(this) - tokenBalance[token];
285         require(currentBalance > ethWei * distributionMinimum);
286 
287         // Add the current balance on to the total returned
288         tokenBalance[token] = SafeMath.add(tokenBalance[token], currentBalance);
289 
290         // Loop through stakers and add the earned shares
291         // This is GAS expensive, but unless complex more bug prone logic was added there is no alternative
292         // This is due to the percentages needed to be calculated for all at once, or the amounts would differ
293         for (uint64 i = 0; i < totalOwners; i++) {
294             address owner = ownerAddresses[i];
295 
296             // If the owner still has a share
297             if (ownerShareTokens[owner] > 0) {
298                 // Calculate and transfer the ownership of shares with a precision of 5, for example: 12.345%
299                 balances[owner][token] = SafeMath.add(SafeMath.div(SafeMath.mul(currentBalance, ownerPercentages[owner]), 100000), balances[owner][token]);
300             }
301         }
302         distributionActive = false;
303 
304         // Emit the event
305         emit TokenDistribution(token, currentBalance);
306     }
307 
308     // Withdraw tokens from the owners balance
309     function withdrawTokens(address token, uint256 amount) public {
310         // Can't withdraw nothing
311         require(amount > 0);
312 
313         // Assert they're withdrawing what is in their balance
314         require(balances[msg.sender][token] >= amount);
315 
316         // Substitute the amounts
317         balances[msg.sender][token] = SafeMath.sub(balances[msg.sender][token], amount);
318         tokenBalance[token] = SafeMath.sub(tokenBalance[token], amount);
319 
320         // Transfer the tokens
321         ERC677 erc677 = ERC677(token);
322         require(erc677.transfer(msg.sender, amount) == true);
323 
324         // Emit the event
325         emit TokenWithdrawal(token, msg.sender, amount);
326     }
327 
328     // Sets the minimum balance needed for token distribution
329     function setDistributionMinimum(uint16 minimum) public onlyOwner() {
330         distributionMinimum = minimum;
331     }
332 
333     // Sets the contribution ETH wallet
334     function setEthWallet(address _wallet) public onlyOwner() {
335         wallet = _wallet;
336     }
337 
338     // Is an account whitelisted?
339     function isWhitelisted(address contributor) public view returns (bool) {
340         return whitelist[contributor];
341     }
342 
343     // Get the owners token balance
344     function getOwnerBalance(address token) public view returns (uint256) {
345         return balances[msg.sender][token];
346     }
347 
348     /**
349         Private Methods
350     */
351 
352     // Credit to Rob Hitchens: https://stackoverflow.com/a/42739843
353     function percent(uint numerator, uint denominator, uint precision) private pure returns (uint quotient) {
354         uint _numerator = numerator * 10 ** (precision+1);
355         uint _quotient = ((_numerator / denominator) + 5) / 10;
356         return ( _quotient);
357     }
358 }