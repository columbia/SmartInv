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
151         Constructor
152      */
153 
154     constructor(address _wallet) public {
155         wallet = _wallet;
156     }
157 
158     /**
159         Contribution Methods
160      */
161 
162     // Fallback, redirects to contribute
163     function() public payable { contribute(msg.sender); }
164 
165     function contribute(address sender) internal {
166         // Make sure the shares aren't locked
167         require(!locked);
168 
169         // Ensure the contribution phase has started
170         require(contributionStarted);
171 
172         // Make sure they're in the whitelist
173         require(whitelist[sender]);
174 
175         // Assert that the contribution is above or equal to the minimum contribution
176         require(msg.value >= minimumContribution);
177 
178         // Make sure the contribution isn't above the hard cap
179         require(hardCap >= msg.value);
180 
181         // Ensure the amount contributed is cleanly divisible by the minimum contribution
182         require((msg.value % minimumContribution) == 0);
183 
184         // Make sure the contribution doesn't exceed the hardCap
185         require(hardCap >= SafeMath.add(totalContributed, msg.value));
186 
187         // Increase the total contributed
188         totalContributed = SafeMath.add(totalContributed, msg.value);
189 
190         // Calculated share
191         uint256 share = percent(msg.value, valuation, 5);
192 
193         // Calculate and set the contributors % holding
194         if (ownerPercentages[sender] != 0) { // Existing contributor
195             ownerShareTokens[sender] = SafeMath.add(ownerShareTokens[sender], msg.value);
196             ownerPercentages[sender] = SafeMath.add(share, ownerPercentages[sender]);
197         } else { // New contributor
198             ownerAddresses[totalOwners] = sender;
199             totalOwners += 1;
200             ownerPercentages[sender] = share;
201             ownerShareTokens[sender] = msg.value;
202         }
203 
204         // Transfer the ether to the wallet
205         wallet.transfer(msg.value);
206 
207         // Fire event
208         emit Contribution(sender, share, msg.value);
209     }
210 
211     // Add a wallet to the whitelist
212     function whitelistWallet(address contributor) external onlyOwner() {
213         // Is it actually an address?
214         require(contributor != address(0));
215 
216         // Add address to whitelist
217         whitelist[contributor] = true;
218     }
219 
220     // Start the contribution
221     function startContribution() external onlyOwner() {
222         require(!contributionStarted);
223         contributionStarted = true;
224     }
225 
226     /**
227         Public Methods
228      */
229 
230     // Set the owners share per owner, the balancing of shares is done externally
231     function setOwnerShare(address owner, uint256 value) public onlyOwner() {
232         // Make sure the shares aren't locked
233         require(!locked);
234 
235         if (ownerShareTokens[owner] == 0) {
236             whitelist[owner] = true;
237             ownerAddresses[totalOwners] = owner;
238             totalOwners += 1;
239         }
240         ownerShareTokens[owner] = value;
241         ownerPercentages[owner] = percent(value, valuation, 5);
242     }
243 
244     // Non-Standard token transfer, doesn't confine to any ERC
245     function sendOwnership(address receiver, uint256 amount) public onlyWhitelisted() {
246         // Require they have an actual balance
247         require(ownerShareTokens[msg.sender] > 0);
248 
249         // Require the amount to be equal or less to their shares
250         require(ownerShareTokens[msg.sender] >= amount);
251 
252         // Deduct the amount from the owner
253         ownerShareTokens[msg.sender] = SafeMath.sub(ownerShareTokens[msg.sender], amount);
254 
255         // Remove the owner if the share is now 0
256         if (ownerShareTokens[msg.sender] == 0) {
257             ownerPercentages[msg.sender] = 0;
258             whitelist[receiver] = false; 
259             
260         } else { // Recalculate percentage
261             ownerPercentages[msg.sender] = percent(ownerShareTokens[msg.sender], valuation, 5);
262         }
263 
264         // Add the new share holder
265         if (ownerShareTokens[receiver] == 0) {
266             whitelist[receiver] = true;
267             ownerAddresses[totalOwners] = receiver;
268             totalOwners += 1;
269         }
270         ownerShareTokens[receiver] = SafeMath.add(ownerShareTokens[receiver], amount);
271         ownerPercentages[receiver] = SafeMath.add(ownerPercentages[receiver], percent(amount, valuation, 5));
272 
273         emit OwnershipTransferred(msg.sender, receiver, amount);
274     }
275 
276     // Lock the shares so contract owners cannot change them
277     function lockShares() public onlyOwner() {
278         require(!locked);
279         locked = true;
280     }
281 
282     // Distribute the tokens in the contract to the contributors/creators
283     function distributeTokens(address token) public onlyWhitelisted() {
284         // Is this method already being called?
285         require(!distributionActive);
286         distributionActive = true;
287 
288         // Get the token address
289         ERC677 erc677 = ERC677(token);
290 
291         // Has the contract got a balance?
292         uint256 currentBalance = erc677.balanceOf(this) - tokenBalance[token];
293         require(currentBalance > ethWei * distributionMinimum);
294 
295         // Add the current balance on to the total returned
296         tokenBalance[token] = SafeMath.add(tokenBalance[token], currentBalance);
297 
298         // Loop through stakers and add the earned shares
299         // This is GAS expensive, but unless complex more bug prone logic was added there is no alternative
300         // This is due to the percentages needed to be calculated for all at once, or the amounts would differ
301         for (uint64 i = 0; i < totalOwners; i++) {
302             address owner = ownerAddresses[i];
303 
304             // If the owner still has a share
305             if (ownerShareTokens[owner] > 0) {
306                 // Calculate and transfer the ownership of shares with a precision of 5, for example: 12.345%
307                 balances[owner][token] = SafeMath.add(SafeMath.div(SafeMath.mul(currentBalance, ownerPercentages[owner]), 100000), balances[owner][token]);
308             }
309         }
310         distributionActive = false;
311 
312         // Emit the event
313         emit TokenDistribution(token, currentBalance);
314     }
315 
316     // Withdraw tokens from the owners balance
317     function withdrawTokens(address token, uint256 amount) public {
318         // Can't withdraw nothing
319         require(amount > 0);
320 
321         // Assert they're withdrawing what is in their balance
322         require(balances[msg.sender][token] >= amount);
323 
324         // Substitute the amounts
325         balances[msg.sender][token] = SafeMath.sub(balances[msg.sender][token], amount);
326         tokenBalance[token] = SafeMath.sub(tokenBalance[token], amount);
327 
328         // Transfer the tokens
329         ERC677 erc677 = ERC677(token);
330         require(erc677.transfer(msg.sender, amount) == true);
331 
332         // Emit the event
333         emit TokenWithdrawal(token, msg.sender, amount);
334     }
335 
336     // Sets the minimum balance needed for token distribution
337     function setDistributionMinimum(uint16 minimum) public onlyOwner() {
338         distributionMinimum = minimum;
339     }
340 
341     // Is an account whitelisted?
342     function isWhitelisted(address contributor) public view returns (bool) {
343         return whitelist[contributor];
344     }
345 
346     // Get the owners token balance
347     function getOwnerBalance(address token) public view returns (uint256) {
348         return balances[msg.sender][token];
349     }
350 
351     /**
352         Private Methods
353     */
354 
355     // Credit to Rob Hitchens: https://stackoverflow.com/a/42739843
356     function percent(uint numerator, uint denominator, uint precision) private pure returns (uint quotient) {
357         uint _numerator = numerator * 10 ** (precision+1);
358         uint _quotient = ((_numerator / denominator) + 5) / 10;
359         return ( _quotient);
360     }
361 }