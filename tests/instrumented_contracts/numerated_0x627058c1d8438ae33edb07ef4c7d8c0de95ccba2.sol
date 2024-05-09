1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     uint256 public totalSupply;
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21     function allowance(address owner, address spender) public view returns (uint256);
22     function transferFrom(address from, address to, uint256 value) public returns (bool);
23     function approve(address spender, uint256 value) public returns (bool);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * Safe unsigned safe math.
29  *
30  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
31  *
32  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
33  *
34  * Maintained here until merged to mainline zeppelin-solidity.
35  *
36  */
37 library SafeMathLibExt {
38 
39     function times(uint a, uint b) public pure returns (uint) {
40         uint c = a * b;
41         assert(a == 0 || c / a == b);
42         return c;
43     }
44 
45     function divides(uint a, uint b) public pure returns (uint) {
46         assert(b > 0);
47         uint c = a / b;
48         assert(a == b * c + a % b);
49         return c;
50     }
51 
52     function minus(uint a, uint b) public pure returns (uint) {
53         assert(b <= a);
54         return a - b;
55     }
56 
57     function plus(uint a, uint b) public pure returns (uint) {
58         uint c = a + b;
59         assert(c >= a);
60         return c;
61     }
62 
63 }
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71     address public owner;
72 
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     /**
76     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77     * account.
78     */
79     constructor () public {
80         owner = msg.sender;
81     }
82 
83     /**
84     * @dev Throws if called by any account other than the owner.
85     */
86     modifier onlyOwner() {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     /**
92     * @dev Allows the current owner to transfer control of the contract to a newOwner.
93     * @param newOwner The address to transfer ownership to.
94     */
95     function transferOwnership(address newOwner) public onlyOwner {
96         require(newOwner != address(0));
97         emit OwnershipTransferred(owner, newOwner);
98         owner = newOwner;
99     }
100 }
101 
102 contract Allocatable is Ownable {
103 
104   /** List of agents that are allowed to allocate new tokens */
105     mapping (address => bool) public allocateAgents;
106 
107     event AllocateAgentChanged(address addr, bool state  );
108 
109   /**
110    * Owner can allow a crowdsale contract to allocate new tokens.
111    */
112     function setAllocateAgent(address addr, bool state) public onlyOwner  
113     {
114         allocateAgents[addr] = state;
115         emit AllocateAgentChanged(addr, state);
116     }
117 
118     modifier onlyAllocateAgent() {
119         //Only crowdsale contracts are allowed to allocate new tokens
120         require(allocateAgents[msg.sender]);
121         _;
122     }
123 }
124 
125 /**
126  * Contract to enforce Token Vesting
127  */
128 contract TokenVesting is Allocatable {
129 
130     using SafeMathLibExt for uint;
131 
132     address public crowdSaleTokenAddress;
133 
134     /** keep track of total tokens yet to be released, 
135      * this should be less than or equal to UTIX tokens held by this contract. 
136      */
137     uint256 public totalUnreleasedTokens;
138 
139     // default vesting parameters
140     uint256 private startAt = 0;
141     uint256 private cliff = 1;
142     uint256 private duration = 4; 
143     uint256 private step = 300; //15778463;  //2592000;
144     bool private changeFreezed = false;
145 
146     struct VestingSchedule {
147         uint256 startAt;
148         uint256 cliff;
149         uint256 duration;
150         uint256 step;
151         uint256 amount;
152         uint256 amountReleased;
153         bool changeFreezed;
154     }
155 
156     mapping (address => VestingSchedule) public vestingMap;
157 
158     event VestedTokensReleased(address _adr, uint256 _amount);
159     
160     constructor(address _tokenAddress) public {
161         
162         crowdSaleTokenAddress = _tokenAddress;
163     }
164 
165     /** Modifier to check if changes to vesting is freezed  */
166     modifier changesToVestingFreezed(address _adr) {
167         require(vestingMap[_adr].changeFreezed);
168         _;
169     }
170 
171     /** Modifier to check if changes to vesting is not freezed yet  */
172     modifier changesToVestingNotFreezed(address adr) {
173         require(!vestingMap[adr].changeFreezed); // if vesting not set then also changeFreezed will be false
174         _;
175     }
176 
177     /** Function to set default vesting schedule parameters. */
178     function setDefaultVestingParameters(
179         uint256 _startAt, uint256 _cliff, uint256 _duration,
180         uint256 _step, bool _changeFreezed) public onlyAllocateAgent {
181 
182         // data validation
183         require(_step != 0);
184         require(_duration != 0);
185         require(_cliff <= _duration);
186 
187         startAt = _startAt;
188         cliff = _cliff;
189         duration = _duration; 
190         step = _step;
191         changeFreezed = _changeFreezed;
192 
193     }
194 
195     /** Function to set vesting with default schedule. */
196     function setVestingWithDefaultSchedule(address _adr, uint256 _amount) 
197     public 
198     changesToVestingNotFreezed(_adr) onlyAllocateAgent {
199        
200         setVesting(_adr, startAt, cliff, duration, step, _amount, changeFreezed);
201     }    
202 
203     /** Function to set/update vesting schedule. PS - Amount cannot be changed once set */
204     function setVesting(
205         address _adr,
206         uint256 _startAt,
207         uint256 _cliff,
208         uint256 _duration,
209         uint256 _step,
210         uint256 _amount,
211         bool _changeFreezed) 
212     public changesToVestingNotFreezed(_adr) onlyAllocateAgent {
213 
214         VestingSchedule storage vestingSchedule = vestingMap[_adr];
215 
216         // data validation
217         require(_step != 0);
218         require(_amount != 0 || vestingSchedule.amount > 0);
219         require(_duration != 0);
220         require(_cliff <= _duration);
221 
222         //if startAt is zero, set current time as start time.
223         if (_startAt == 0) 
224             _startAt = block.timestamp;
225 
226         vestingSchedule.startAt = _startAt;
227         vestingSchedule.cliff = _cliff;
228         vestingSchedule.duration = _duration;
229         vestingSchedule.step = _step;
230 
231         // special processing for first time vesting setting
232         if (vestingSchedule.amount == 0) {
233             // check if enough tokens are held by this contract
234             ERC20 token = ERC20(crowdSaleTokenAddress);
235             require(token.balanceOf(this) >= totalUnreleasedTokens.plus(_amount));
236             totalUnreleasedTokens = totalUnreleasedTokens.plus(_amount);
237             vestingSchedule.amount = _amount; 
238         }
239 
240         vestingSchedule.amountReleased = 0;
241         vestingSchedule.changeFreezed = _changeFreezed;
242     }
243 
244     function isVestingSet(address adr) public view returns (bool isSet) {
245         return vestingMap[adr].amount != 0;
246     }
247 
248     function freezeChangesToVesting(address _adr) public changesToVestingNotFreezed(_adr) onlyAllocateAgent {
249         require(isVestingSet(_adr)); // first check if vesting is set
250         vestingMap[_adr].changeFreezed = true;
251     }
252 
253     /** Release tokens as per vesting schedule, called by contributor  */
254     function releaseMyVestedTokens() public changesToVestingFreezed(msg.sender) {
255         releaseVestedTokens(msg.sender);
256     }
257 
258     /** Release tokens as per vesting schedule, called by anyone  */
259     function releaseVestedTokens(address _adr) public changesToVestingFreezed(_adr) {
260         VestingSchedule storage vestingSchedule = vestingMap[_adr];
261         
262         // check if all tokens are not vested
263         require(vestingSchedule.amount.minus(vestingSchedule.amountReleased) > 0);
264         
265         // calculate total vested tokens till now
266         uint256 totalTime = block.timestamp - vestingSchedule.startAt;
267         uint256 totalSteps = totalTime / vestingSchedule.step;
268 
269         // check if cliff is passed
270         require(vestingSchedule.cliff <= totalSteps);
271 
272         uint256 tokensPerStep = vestingSchedule.amount / vestingSchedule.duration;
273         // check if amount is divisble by duration
274         if (tokensPerStep * vestingSchedule.duration != vestingSchedule.amount) tokensPerStep++;
275 
276         uint256 totalReleasableAmount = tokensPerStep.times(totalSteps);
277 
278         // handle the case if user has not claimed even after vesting period is over or amount was not divisible
279         if (totalReleasableAmount > vestingSchedule.amount) totalReleasableAmount = vestingSchedule.amount;
280 
281         uint256 amountToRelease = totalReleasableAmount.minus(vestingSchedule.amountReleased);
282         vestingSchedule.amountReleased = vestingSchedule.amountReleased.plus(amountToRelease);
283 
284         // transfer vested tokens
285         ERC20 token = ERC20(crowdSaleTokenAddress);
286         token.transfer(_adr, amountToRelease);
287         // decrement overall unreleased token count
288         totalUnreleasedTokens = totalUnreleasedTokens.minus(amountToRelease);
289         emit VestedTokensReleased(_adr, amountToRelease);
290     }
291 
292     /**
293     * Allow to (re)set Token.
294     */
295     function setCrowdsaleTokenExtv1(address _token) public onlyAllocateAgent {       
296         crowdSaleTokenAddress = _token;
297     }
298 }