1 pragma solidity ^0.4.18;
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
19   function Ownable() public {
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
37     OwnershipTransferred(owner, newOwner);
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
49   function totalSupply() public view returns (uint256);
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
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76     if (a == 0) {
77       return 0;
78     }
79     uint256 c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   /**
95   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256) {
106     uint256 c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 
113 /**
114  * @title PoSTokenStandard
115  * @dev the interface of PoSTokenStandard
116  */
117 contract PoSTokenStandard {
118     uint256 public stakeStartTime;
119     uint256 public stakeMinAge;
120     uint256 public stakeMaxAge;
121     function mint() public returns (bool);
122     function coinAge() constant public returns (uint256);
123     function annualInterest() constant public returns (uint256);
124     event Mint(address indexed _address, uint _reward);
125 }
126 
127 
128 contract BITTOToken is ERC20,PoSTokenStandard,Ownable {
129     using SafeMath for uint256;
130 
131     string public name = "BITTO Token";
132     string public symbol = "BITTO";
133     uint public decimals = 18;
134 
135     uint public chainStartTime; //chain start time
136     uint public chainStartBlockNumber; //chain start block number
137     uint public stakeStartTime; //stake start time
138     uint public stakeMinAge = 15 days; // minimum age for coin age: 3D
139     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
140     // uint public maxMintProofOfStake = 10**17; // default 10% annual interest
141     uint constant REWARDS_PER_AGE = 622665006227000;  // token rewards per coin age.
142 
143     uint public totalSupply;
144     uint public maxTotalSupply;
145     uint public totalInitialSupply;
146 
147     mapping(address => bool) public noPOSRewards;
148 
149     struct transferInStruct {
150         uint128 amount;
151         uint64 time;
152     }
153 
154     mapping(address => uint256) balances;
155     mapping(address => mapping (address => uint256)) allowed;
156     mapping(address => transferInStruct[]) transferIns;
157 
158     event Burn(address indexed burner, uint256 value);
159 
160     /**
161      * @dev Fix for the ERC20 short address attack.
162      */
163     modifier onlyPayloadSize(uint size) {
164         require(msg.data.length >= size + 4);
165         _;
166     }
167 
168     modifier canPoSMint() {
169         require(totalSupply < maxTotalSupply);
170         _;
171     }
172 
173     function BITTOToken() public {
174         // 5 mil is reserved for POS rewards
175         maxTotalSupply = 223 * 10**23; // 22.3 Mil.
176         totalInitialSupply = 173 * 10**23; // 17.3 Mil. 10 mil = crowdsale, 7.3 team account
177 
178         chainStartTime = now;
179         chainStartBlockNumber = block.number;
180 
181         balances[msg.sender] = totalInitialSupply;
182         totalSupply = totalInitialSupply;
183     }
184 
185     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
186         if (msg.sender == _to)
187             return mint();
188         balances[msg.sender] = balances[msg.sender].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         Transfer(msg.sender, _to, _value);
191         if (transferIns[msg.sender].length > 0)
192             delete transferIns[msg.sender];
193         uint64 _now = uint64(now);
194         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
195         transferIns[_to].push(transferInStruct(uint128(_value),_now));
196         return true;
197     }
198 
199     function totalSupply() public view returns (uint256) {
200         return totalSupply;
201     }
202 
203     function balanceOf(address _owner) constant public returns (uint256 balance) {
204         return balances[_owner];
205     }
206 
207     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
208         require(_to != address(0));
209 
210         uint256 _allowance = allowed[_from][msg.sender];
211 
212         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
213         // require (_value <= _allowance);
214 
215         balances[_from] = balances[_from].sub(_value);
216         balances[_to] = balances[_to].add(_value);
217         allowed[_from][msg.sender] = _allowance.sub(_value);
218         Transfer(_from, _to, _value);
219         if (transferIns[_from].length > 0)
220             delete transferIns[_from];
221         uint64 _now = uint64(now);
222         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
223         transferIns[_to].push(transferInStruct(uint128(_value),_now));
224         return true;
225     }
226 
227     function approve(address _spender, uint256 _value) public returns (bool) {
228         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
229 
230         allowed[msg.sender][_spender] = _value;
231         Approval(msg.sender, _spender, _value);
232         return true;
233     }
234 
235     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
236         return allowed[_owner][_spender];
237     }
238 
239     function mint() canPoSMint public returns (bool) {
240         // minimum stake of 5000 BITTO is required to earn staking.
241         if (balances[msg.sender] < 5000 ether)
242             return false;
243         if (transferIns[msg.sender].length <= 0)
244             return false;
245 
246         uint reward = getProofOfStakeReward(msg.sender);
247         if (reward <= 0)
248             return false;
249 
250         totalSupply = totalSupply.add(reward);
251         balances[msg.sender] = balances[msg.sender].add(reward);
252         delete transferIns[msg.sender];
253         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
254 
255         Transfer(address(0), msg.sender, reward);
256         Mint(msg.sender, reward);
257         return true;
258     }
259 
260     function getBlockNumber() view public returns (uint blockNumber) {
261         blockNumber = block.number.sub(chainStartBlockNumber);
262     }
263 
264     function coinAge() constant public returns (uint myCoinAge) {
265         myCoinAge = getCoinAge(msg.sender,now);
266     }
267 
268     function annualInterest() constant public returns (uint interest) {
269         // uint _now = now;
270         // interest = maxMintProofOfStake;
271         // if ((_now.sub(stakeStartTime)).div(1 years) == 0) {
272         //     interest = (770 * maxMintProofOfStake).div(100);
273         // } else if ((_now.sub(stakeStartTime)).div(1 years) == 1) {
274         //     interest = (435 * maxMintProofOfStake).div(100);
275         // }
276 
277         return REWARDS_PER_AGE;
278     }
279 
280     function getProofOfStakeReward(address _address) internal returns (uint) {
281         require((now >= stakeStartTime) && (stakeStartTime > 0));
282         require(!noPOSRewards[_address]);
283 
284         uint _now = now;
285         uint _coinAge = getCoinAge(_address, _now);
286         if (_coinAge <= 0)
287             return 0;
288 
289         // uint interest = maxMintProofOfStake;
290         // // Due to the high interest rate for the first two years, compounding should be taken into account.
291         // // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
292         // if ((_now.sub(stakeStartTime)).div(1 years) == 0) {
293         //     // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
294         //     interest = (770 * maxMintProofOfStake).div(100);
295         // } else if ((_now.sub(stakeStartTime)).div(1 years) == 1) {
296         //     // 2nd year effective annual interest rate is 50%
297         //     interest = (435 * maxMintProofOfStake).div(100);
298         // }
299 
300         // return (_coinAge * interest).div(365 * (10**decimals));
301         return _coinAge.mul(REWARDS_PER_AGE);
302     }
303 
304     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
305         if (transferIns[_address].length <= 0)
306             return 0;
307 
308         for (uint i = 0; i < transferIns[_address].length; i++) {
309             if (_now < uint(transferIns[_address][i].time).add(stakeMinAge))
310                 continue;
311 
312             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
313             if ( nCoinSeconds > stakeMaxAge )
314                 nCoinSeconds = stakeMaxAge;
315 
316             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
317         }
318         _coinAge = _coinAge.div(5000 ether);
319     }
320 
321     function ownerSetStakeStartTime(uint timestamp) onlyOwner public {
322         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
323         stakeStartTime = timestamp;
324     }
325 
326     function ownerBurnToken(uint _value) onlyOwner public {
327         require(_value > 0);
328 
329         balances[msg.sender] = balances[msg.sender].sub(_value);
330         delete transferIns[msg.sender];
331         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
332 
333         totalSupply = totalSupply.sub(_value);
334         totalInitialSupply = totalInitialSupply.sub(_value);
335         maxTotalSupply = maxTotalSupply.sub(_value*10);
336 
337         Burn(msg.sender, _value);
338     }
339 
340     /**
341     * @dev Burns a specific amount of tokens.
342     * @param _value The amount of token to be burned.
343     */
344     function burn(uint256 _value) public {
345         require(_value <= balances[msg.sender]);
346         // no need to require value <= totalSupply, since that would imply the
347         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
348 
349         address burner = msg.sender;
350         balances[burner] = balances[burner].sub(_value);
351         delete transferIns[msg.sender];
352         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
353         totalSupply = totalSupply.sub(_value);
354         Burn(burner, _value);
355     }
356 
357     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
358     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner public returns (bool) {
359         require(_recipients.length > 0 && _recipients.length == _values.length);
360 
361         uint total = 0;
362         for (uint i = 0; i < _values.length; i++) {
363             total = total.add(_values[i]);
364         }
365         require(total <= balances[msg.sender]);
366 
367         uint64 _now = uint64(now);
368         for (uint j = 0; j < _recipients.length; j++) {
369             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
370             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
371             Transfer(msg.sender, _recipients[j], _values[j]);
372         }
373 
374         balances[msg.sender] = balances[msg.sender].sub(total);
375         if (transferIns[msg.sender].length > 0)
376             delete transferIns[msg.sender];
377         if (balances[msg.sender] > 0)
378             transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
379 
380         return true;
381     }
382 
383     function disablePOSReward(address _account, bool _enabled) onlyOwner public {
384         noPOSRewards[_account] = _enabled;
385     }
386 }