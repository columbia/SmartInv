1 pragma solidity ^0.4.11;
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
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances. 
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of. 
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) public constant returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) public constant returns (uint256);
84   function transferFrom(address from, address to, uint256 value) public returns (bool);
85   function approve(address spender, uint256 value) public returns (bool);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * @dev https://github.com/ethereum/EIPs/issues/20
95  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  */
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) allowed;
100 
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amout of tokens to be transfered
107    */
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
122    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
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
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifing the amount of tokens still avaible for the spender.
144    */
145   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157   address public owner;
158 
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   function Ownable() public {
165     owner = msg.sender;
166   }
167 
168 
169   /**
170    * @dev Throws if called by any account other than the owner.
171    */
172   modifier onlyOwner() {
173     require(msg.sender == owner);
174     _;
175   }
176 
177 
178   /**
179    * @dev Allows the current owner to transfer control of the contract to a newOwner.
180    * @param newOwner The address to transfer ownership to.
181    */
182   function transferOwnership(address newOwner) public onlyOwner {
183     if (newOwner != address(0)) {
184       owner = newOwner;
185     }
186   }
187 
188 }
189 
190 contract SYNVault {
191     // flag to determine if address is for a real contract or not
192     bool public isSYNVault = false;
193 
194     SynchroCoin synchroCoin;
195     address businessAddress;
196     uint256 unlockedAtBlockNumber;
197     // Locked for 345days (1year after completion of the crowdsale)
198     // 2129143 blocks = 24 hours * 60 minutes * 60 seconds * 345days / 14seconds per block
199     uint256 public constant numBlocksLocked = 2129143;
200 
201     /// @notice Constructor function sets the Multisig address and
202     /// total number of locked tokens to transfer
203     function SYNVault(address _businessAddress) public {
204         require(_businessAddress != 0x0);
205         synchroCoin = SynchroCoin(msg.sender);
206         businessAddress = _businessAddress;
207         isSYNVault = true;
208         unlockedAtBlockNumber = SafeMath.add(block.number, numBlocksLocked); // 345 days of blocks later
209     }
210 
211     /// @notice Transfer locked tokens to Synchrolife's wallet
212     function unlock() external {
213         // Wait your turn!
214         require(block.number > unlockedAtBlockNumber);
215         // Will fail if allocation (and therefore toTransfer) is 0.
216         if (!synchroCoin.transfer(businessAddress, synchroCoin.balanceOf(this))) revert();
217     }
218 
219     // disallow payment this is for SYN not ether
220     function () public { revert(); }
221 }
222 
223 contract SynchroCoin is Ownable, StandardToken {
224 
225     string public constant symbol = "SYC";
226     string public constant name = "SynchroCoin";
227     uint8 public constant decimals = 18;
228     uint256 public constant initialSupply = 100000000e18;    //100000000000000000000000000
229     
230     uint256 public constant startDate = 1506092400;
231     uint256 public constant endDate = 1508511599;
232     uint256 public constant firstPresaleStart = 1502884800;
233     uint256 public constant firstPresaleEnd = 1503835140;
234     uint256 public constant secondPresaleStart = 1504526400;
235     uint256 public constant secondPresaleEnd = 1504785540;
236 
237     //55% for CrowdSale distribution
238     uint256 public constant crowdSalePercentage = 5500;
239     //20% for Synchrolife pool for rewards
240     uint256 public constant rewardPoolPercentage = 2000;
241     //9.5% for Synchrolife business + 5% for early investors
242     uint256 public constant businessPercentage = 1450;
243     //9.5% for Synchrolife team, advisors and partners
244     uint256 public constant vaultPercentage = 950;
245     //1% for Bounty
246     uint256 public constant bountyPercentage = 100;
247     
248     //Denominator for percentage calculation.
249     uint256 public constant hundredPercent = 10000; 
250     
251     //First Presale: 268000000000000000000
252     //Second Presale: 70000000000000000000 
253     //Crowdsale:     417427897026000000400
254     uint256 public constant totalFundedEther = 755427897026000000400;
255     
256     //First Presale: 375200000000000000000
257     //Second Presale: 91000000000000000000
258     //Crowdsale:     438371225465900000400
259     uint256 public constant totalConsideredFundedEther = 904571225465900000400;
260     
261     SYNVault public vault;
262     address public businessAddress;
263     address public rewardPoolAddress;
264     
265     uint256 public crowdSaleTokens;
266     uint256 public bountyTokens;
267     uint256 public rewardPoolTokens;
268 
269     function SynchroCoin(address _businessAddress, address _rewardPoolAddress) public {
270         totalSupply = initialSupply;
271         businessAddress = _businessAddress;
272         rewardPoolAddress = _rewardPoolAddress;
273         
274         vault = new SYNVault(businessAddress);
275         require(vault.isSYNVault());
276         
277         uint256 remainingSupply = initialSupply;
278         
279         // 55% of total to be distributed to presale and crowdsale participents
280         crowdSaleTokens = SafeMath.div(SafeMath.mul(totalSupply, crowdSalePercentage), hundredPercent);
281         remainingSupply = SafeMath.sub(remainingSupply, crowdSaleTokens);
282         
283         // 20% of total to be allocated for rewards
284         rewardPoolTokens = SafeMath.div(SafeMath.mul(totalSupply, rewardPoolPercentage), hundredPercent);
285         balances[rewardPoolAddress] = SafeMath.add(balances[rewardPoolAddress], rewardPoolTokens);
286         Transfer(0, rewardPoolAddress, rewardPoolTokens);
287         remainingSupply = SafeMath.sub(remainingSupply, rewardPoolTokens);
288         
289         // 9.5% of total goes to vault, timelocked for 1 year
290         uint256 vaultTokens = SafeMath.div(SafeMath.mul(totalSupply, vaultPercentage), hundredPercent);
291         balances[vault] = SafeMath.add(balances[vault], vaultTokens);
292         Transfer(0, vault, vaultTokens);
293         remainingSupply = SafeMath.sub(remainingSupply, vaultTokens);
294         
295         // 1% of total used for bounty. Remainder will be used for business.
296         bountyTokens = SafeMath.div(SafeMath.mul(totalSupply, bountyPercentage), hundredPercent);
297         remainingSupply = SafeMath.sub(remainingSupply, bountyTokens);
298         
299         balances[businessAddress] = SafeMath.add(balances[businessAddress], remainingSupply);
300         Transfer(0, businessAddress, remainingSupply);
301     }
302 
303     /* Send coins */
304     function transfer(address _to, uint256 _amount) public returns (bool success) {
305         return super.transfer(_to, _amount);
306     }
307 
308     /* A contract attempts to get the coins */
309     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
310         return super.transferFrom(_from, _to, _amount);
311     }
312     
313     function getBonusMultiplierAt(uint256 _timestamp) public constant returns (uint256) {
314         if (_timestamp >= firstPresaleStart && _timestamp < firstPresaleEnd) {
315             return 140;
316         }
317         else if (_timestamp >= secondPresaleStart && _timestamp < secondPresaleEnd) {
318             return 130;
319         }
320         else if (_timestamp < (startDate + 1 days)) {
321             return 120;
322         }
323         else if (_timestamp < (startDate + 7 days)) {
324             return 115;
325         }
326         else if (_timestamp < (startDate + 14 days)) {
327             return 110;
328         }
329         else if (_timestamp < (startDate + 21 days)) {
330             return 105;
331         }
332         else if (_timestamp <= endDate) {
333             return 100;
334         }
335         else {
336             return 0;
337         }
338     }
339 
340     function distributeCrowdsaleTokens(address _to, uint256 _ether, uint256 _timestamp) public onlyOwner returns (uint256) {
341         require(_to != 0x0);
342         require(_ether >= 100 finney);
343         require(_timestamp >= firstPresaleStart);
344         require(_timestamp <= endDate);
345         
346         //Calculate participant's bonus
347         uint256 consideredFundedEther = SafeMath.div(SafeMath.mul(_ether, getBonusMultiplierAt(_timestamp)), 100);
348         //Calculate participant's token share
349         uint256 share = SafeMath.div(SafeMath.mul(consideredFundedEther, crowdSaleTokens), totalConsideredFundedEther);
350         balances[_to] = SafeMath.add(balances[_to], share);
351         Transfer(0, _to, share);
352         return share;
353     }
354     
355     function distributeBountyTokens(address[] _to, uint256[] _values) public onlyOwner {
356         require(_to.length == _values.length);
357         
358         uint256 i = 0;
359         while (i < _to.length) {
360             bountyTokens = SafeMath.sub(bountyTokens, _values[i]);
361             balances[_to[i]] = SafeMath.add(balances[_to[i]], _values[i]);
362             Transfer(0, _to[i], _values[i]);
363             i += 1;
364         }
365     }
366     
367     function completeBountyDistribution() public onlyOwner {
368         //After distribution of bounty tokens, transfer remaining tokens to Synchrolife business address
369         balances[businessAddress] = SafeMath.add(balances[businessAddress], bountyTokens);
370         Transfer(0, businessAddress, bountyTokens);
371         bountyTokens = 0;
372     }
373 }