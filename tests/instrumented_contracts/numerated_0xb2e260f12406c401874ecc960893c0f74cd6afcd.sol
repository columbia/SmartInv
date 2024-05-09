1 pragma solidity ^0.4.18;
2 library SafeMath {
3 
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   /**
17   * @dev Integer division of two numbers, truncating the quotient.
18   */
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   /**
27   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28   */
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   /**
35   * @dev Adds two numbers, throws on overflow.
36   */
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 contract ERC20Basic {
44   function totalSupply() public view returns (uint256);
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public view returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 contract BitUPToken is ERC20, Ownable {
90 
91     using SafeMath for uint;
92 
93 /*----------------- Token Information -----------------*/
94 
95     string public constant name = "BitUP Token";
96     string public constant symbol = "BUT";
97 
98     uint8 public decimals = 18;                            // (ERC20 API) Decimal precision, factor is 1e18
99     
100     mapping (address => uint256) balances;                 // User's balances table
101     mapping (address => mapping (address => uint256)) allowed; // User's allowances table
102 
103 /*----------------- Alloc Information -----------------*/
104 
105     uint256 public totalSupply;
106     
107     uint256 public presaleSupply;                          // Pre-sale supply
108     uint256 public angelSupply;                          // Angel supply
109     uint256 public marketingSupply;                           // marketing supply
110     uint256 public foundationSupply;                       // /Foundation supply
111     uint256 public teamSupply;                          //  Team supply
112     uint256 public communitySupply;                 //  Community supply
113     
114     uint256 public teamSupply6Months;                          //Amount of Team supply could be released after 6 months
115     uint256 public teamSupply12Months;                          //Amount of Team supply could be released after 12 months
116     uint256 public teamSupply18Months;                          //Amount of Team supply could be released after 18 months
117     uint256 public teamSupply24Months;                          //Amount of Team supply could be released after 24 months
118 
119     uint256 public TeamLockingPeriod6Months;                  // Locking period for team's supply, release 1/4 per 6 months
120     uint256 public TeamLockingPeriod12Months;                  // Locking period for team's supply, release 1/4 per 6 months
121     uint256 public TeamLockingPeriod18Months;                  // Locking period for team's supply, release 1/4 per 6 months
122     uint256 public TeamLockingPeriod24Months;                  // Locking period for team's supply, release 1/4 per 6 months
123     
124     address public presaleAddress;                       // Presale address
125     address public angelAddress;                        // Angel address
126     address public marketingAddress;                       // marketing address
127     address public foundationAddress;                      // Foundation address
128     address public teamAddress;                         // Team address
129     address public communityAddress;                         // Community address    
130 
131     function () {
132          //if ether is sent to this address, send it back.
133          //throw;
134          require(false);
135     }
136 
137 /*----------------- Modifiers -----------------*/
138 
139     modifier nonZeroAddress(address _to) {                 // Ensures an address is provided
140         require(_to != 0x0);
141         _;
142     }
143 
144     modifier nonZeroAmount(uint _amount) {                 // Ensures a non-zero amount
145         require(_amount > 0);
146         _;
147     }
148 
149     modifier nonZeroValue() {                              // Ensures a non-zero value is passed
150         require(msg.value > 0);
151         _;
152     }
153 
154     modifier checkTeamLockingPeriod6Months() {                 // Ensures locking period is over
155         assert(now >= TeamLockingPeriod6Months);
156         _;
157     }
158     
159     modifier checkTeamLockingPeriod12Months() {                 // Ensures locking period is over
160         assert(now >= TeamLockingPeriod12Months);
161         _;
162     }
163     
164     modifier checkTeamLockingPeriod18Months() {                 // Ensures locking period is over
165         assert(now >= TeamLockingPeriod18Months);
166         _;
167     }
168     
169     modifier checkTeamLockingPeriod24Months() {                 // Ensures locking period is over
170         assert(now >= TeamLockingPeriod24Months);
171         _;
172     }
173     
174     modifier onlyTeam() {                             // Ensures only team can call the function
175         require(msg.sender == teamAddress);
176         _;
177     }
178     
179 /*----------------- Burn -----------------*/
180     
181     event Burn(address indexed burner, uint256 value);
182 
183     /**
184      * @dev Burns a specific amount of tokens.
185      * @param _value The amount of token to be burned.
186      */
187     function burn(uint256 _value) public {
188         require(_value <= balances[msg.sender]);
189         // no need to require value <= totalSupply, since that would imply the
190         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
191 
192         address burner = msg.sender;
193         // balances[burner] = balances[burner].sub(_value);
194         decrementBalance(burner, _value);
195         totalSupply = totalSupply.sub(_value);
196         Burn(burner, _value);
197     }
198 
199 /*----------------- Token API -----------------*/
200 
201     // -------------------------------------------------
202     // Total supply
203     // -------------------------------------------------
204     function totalSupply() constant returns (uint256){
205         return totalSupply;
206     }
207 
208     // -------------------------------------------------
209     // Transfers amount to address
210     // -------------------------------------------------
211     function transfer(address _to, uint256 _amount) returns (bool success) {
212         require(balanceOf(msg.sender) >= _amount);
213         uint previousBalances = balances[msg.sender] + balances[_to];
214         addToBalance(_to, _amount);
215         decrementBalance(msg.sender, _amount);
216         Transfer(msg.sender, _to, _amount);
217         assert(balances[msg.sender] + balances[_to] == previousBalances);
218         return true;
219     }
220 
221     // -------------------------------------------------
222     // Transfers from one address to another (need allowance to be called first)
223     // -------------------------------------------------
224     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
225         require(balanceOf(_from) >= _amount);
226         require(allowance(_from, msg.sender) >= _amount);
227         uint previousBalances = balances[_from] + balances[_to];
228         decrementBalance(_from, _amount);
229         addToBalance(_to, _amount);
230         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
231         Transfer(_from, _to, _amount);
232         assert(balances[_from] + balances[_to] == previousBalances);
233         return true;
234     }
235 
236     // -------------------------------------------------
237     // Approves another address a certain amount of FUEL
238     // -------------------------------------------------
239     function approve(address _spender, uint256 _value) returns (bool success) {
240         require((_value == 0) || (allowance(msg.sender, _spender) == 0));
241         allowed[msg.sender][_spender] = _value;
242         Approval(msg.sender, _spender, _value);
243         return true;
244     }
245 
246     // -------------------------------------------------
247     // Gets an address's FUEL allowance
248     // -------------------------------------------------
249     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
250         return allowed[_owner][_spender];
251     }
252 
253     // -------------------------------------------------
254     // Gets the FUEL balance of any address
255     // -------------------------------------------------
256     function balanceOf(address _owner) constant returns (uint256 balance) {
257         return balances[_owner];
258     }
259 
260     // -------------------------------------------------
261     // Contract's constructor
262     // -------------------------------------------------
263     function BitUPToken() {
264         totalSupply  =    1000000000 * 1e18;               // 100% - 1 billion total BUT with 18 decimals
265 
266         presaleSupply =    400000000 * 1e18;               //  40% -  400 million BUT pre-crowdsale
267         angelSupply =       50000000 * 1e18;               //  5% - 50 million BUT for the angel crowdsale
268         teamSupply =       200000000 * 1e18;               //  20% -  200 million BUT for team. 1/4 part released per 6 months
269         foundationSupply = 150000000 * 1e18;               //  15% -  300 million BUT for foundation/incentivising efforts
270         marketingSupply =  100000000 * 1e18;       //  10% -  100 million BUT for 
271         communitySupply =  100000000 * 1e18;       //  10% -  100 million BUT for      
272         
273         teamSupply6Months = 50000000 * 1e18;               // team supply release 1/4 per 6 months
274         teamSupply12Months = 50000000 * 1e18;               // team supply release 1/4 per 6 months
275         teamSupply18Months = 50000000 * 1e18;               // team supply release 1/4 per 6 months
276         teamSupply24Months = 50000000 * 1e18;               // team supply release 1/4 per 6 months
277         
278         angelAddress    = 0xeF01453A730486d262D0b490eF1aDBBF62C2Fe00;                         // Angel address
279         presaleAddress = 0x2822332F63a6b80E21cEA5C8c43Cb6f393eb5703;                         // Presale address
280         teamAddress = 0x8E199e0c1DD38d455815E11dc2c9A64D6aD893B7;                         // Team address
281         foundationAddress = 0xcA972ac76F4Db643C30b86E4A9B54EaBB88Ce5aD;                         // Foundation address
282         marketingAddress = 0xd2631280F7f0472271Ae298aF034eBa549d792EA;                         // marketing address
283         communityAddress = 0xF691e8b2B2293D3d3b06ecdF217973B40258208C;                         //Community address
284         
285         
286         TeamLockingPeriod6Months = now.add(180 * 1 days); // 180 days locking period
287         TeamLockingPeriod12Months = now.add(360 * 1 days); // 360 days locking period
288         TeamLockingPeriod18Months = now.add(450 * 1 days); // 450 days locking period
289         TeamLockingPeriod24Months = now.add(730 * 1 days); // 730 days locking period
290         
291         addToBalance(foundationAddress, foundationSupply);
292         foundationSupply = 0;
293         addToBalance(marketingAddress, marketingSupply);
294         marketingSupply = 0;
295         addToBalance(communityAddress, communitySupply);
296         communitySupply = 0;
297         addToBalance(presaleAddress, presaleSupply);
298         presaleSupply = 0;
299         addToBalance(angelAddress, angelSupply);
300         angelSupply = 0;
301     }
302 
303     // -------------------------------------------------
304     // Releases 1/4 of team supply after 6 months
305     // -------------------------------------------------
306     function releaseTeamTokensAfter6Months() checkTeamLockingPeriod6Months onlyTeam returns(bool success) {
307         require(teamSupply6Months > 0);
308         addToBalance(teamAddress, teamSupply6Months);
309         Transfer(0x0, teamAddress, teamSupply6Months);
310         teamSupply6Months = 0;
311         teamSupply.sub(teamSupply6Months);
312         return true;
313     }
314     
315     // -------------------------------------------------
316     // Releases 1/4 of team supply after 12 months
317     // -------------------------------------------------
318     function releaseTeamTokensAfter12Months() checkTeamLockingPeriod12Months onlyTeam returns(bool success) {
319         require(teamSupply12Months > 0);
320         addToBalance(teamAddress, teamSupply12Months);
321         Transfer(0x0, teamAddress, teamSupply12Months);
322         teamSupply12Months = 0;
323         teamSupply.sub(teamSupply12Months);
324         return true;
325     }
326     
327     // -------------------------------------------------
328     // Releases 1/4 of team supply after 18 months
329     // -------------------------------------------------
330     function releaseTeamTokensAfter18Months() checkTeamLockingPeriod18Months onlyTeam returns(bool success) {
331         require(teamSupply18Months > 0);
332         addToBalance(teamAddress, teamSupply18Months);
333         Transfer(0x0, teamAddress, teamSupply18Months);
334         teamSupply18Months = 0;
335         teamSupply.sub(teamSupply18Months);
336         return true;
337     }
338     
339     // -------------------------------------------------
340     // Releases 1/4 of team supply after 24 months
341     // -------------------------------------------------
342     function releaseTeamTokensAfter24Months() checkTeamLockingPeriod24Months onlyTeam returns(bool success) {
343         require(teamSupply24Months > 0);
344         addToBalance(teamAddress, teamSupply24Months);
345         Transfer(0x0, teamAddress, teamSupply24Months);
346         teamSupply24Months = 0;
347         teamSupply.sub(teamSupply24Months);
348         return true;
349     }
350 
351     // -------------------------------------------------
352     // Adds to balance
353     // -------------------------------------------------
354     function addToBalance(address _address, uint _amount) internal {
355         balances[_address] = SafeMath.add(balances[_address], _amount);
356     }
357 
358     // -------------------------------------------------
359     // Removes from balance
360     // -------------------------------------------------
361     function decrementBalance(address _address, uint _amount) internal {
362         balances[_address] = SafeMath.sub(balances[_address], _amount);
363     }
364 }