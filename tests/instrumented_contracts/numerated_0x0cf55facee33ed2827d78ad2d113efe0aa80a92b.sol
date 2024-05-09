1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 
39 library SafeMath {
40 
41   /**
42   * @dev Multiplies two numbers, throws on overflow.
43   */
44   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45     if (a == 0) {
46       return 0;
47     }
48     uint256 c = a * b;
49     assert(c / a == b);
50     return c;
51   }
52 
53   /**
54   * @dev Integer division of two numbers, truncating the quotient.
55   */
56   function div(uint256 a, uint256 b) internal pure returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return c;
61   }
62 
63   /**
64   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65   */
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   /**
72   * @dev Adds two numbers, throws on overflow.
73   */
74   function add(uint256 a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 contract ERC20Basic {
82   function totalSupply() public view returns (uint256);
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public view returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title PoSTokenStandard
97  * @dev the interface of PoSTokenStandard
98  */
99 contract PoSTokenStandard {
100     uint256 public stakeStartTime;
101     uint256 public stakeMinAge;
102     uint256 public stakeMaxAge;
103     function mint() public returns (bool);
104     function coinAge() constant public returns (uint256);
105     function annualInterest() constant public returns (uint256);
106     event Mint(address indexed _address, uint _reward);
107 }
108 
109 
110 contract BITTOToken is ERC20,PoSTokenStandard,Ownable {
111     using SafeMath for uint256;
112 
113     string public name = "BITTO";
114     string public symbol = "BITTO";
115     uint public decimals = 18;
116 
117     uint public chainStartTime; //chain start time
118     uint public chainStartBlockNumber; //chain start block number
119     uint public stakeStartTime; //stake start time
120     uint public stakeMinAge = 15 days; // minimum age for coin age: 3D
121     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
122     // uint public maxMintProofOfStake = 10**17; // default 10% annual interest
123     uint constant REWARDS_PER_AGE = 622665006227000;  // token rewards per coin age.
124 
125     uint public totalSupply;
126     uint public maxTotalSupply;
127     uint public totalInitialSupply;
128 
129     mapping(address => bool) public noPOSRewards;
130 
131     struct transferInStruct {
132         uint128 amount;
133         uint64 time;
134     }
135 
136     mapping(address => uint256) balances;
137     mapping(address => mapping (address => uint256)) allowed;
138     mapping(address => transferInStruct[]) transferIns;
139 
140     event Burn(address indexed burner, uint256 value);
141 
142     /**
143      * @dev Fix for the ERC20 short address attack.
144      */
145     modifier onlyPayloadSize(uint size) {
146         require(msg.data.length >= size + 4);
147         _;
148     }
149 
150     modifier canPoSMint() {
151         require(totalSupply < maxTotalSupply);
152         _;
153     }
154 
155     function BITTOToken() public {
156         // 5 mil is reserved for POS rewards
157         maxTotalSupply = 223 * 10**23; // 22.3 Mil.
158         totalInitialSupply = 173 * 10**23; // 17.3 Mil. 10 mil = crowdsale, 7.3 team account
159 
160         chainStartTime = now;
161         chainStartBlockNumber = block.number;
162 
163         balances[msg.sender] = totalInitialSupply;
164         totalSupply = totalInitialSupply;
165     }
166 
167     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
168         if (msg.sender == _to)
169             return mint();
170         balances[msg.sender] = balances[msg.sender].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172         Transfer(msg.sender, _to, _value);
173         if (transferIns[msg.sender].length > 0)
174             delete transferIns[msg.sender];
175         uint64 _now = uint64(now);
176         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
177         transferIns[_to].push(transferInStruct(uint128(_value),_now));
178         return true;
179     }
180 
181     function totalSupply() public view returns (uint256) {
182         return totalSupply;
183     }
184 
185     function balanceOf(address _owner) constant public returns (uint256 balance) {
186         return balances[_owner];
187     }
188 
189     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
190         require(_to != address(0));
191 
192         uint256 _allowance = allowed[_from][msg.sender];
193 
194         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
195         // require (_value <= _allowance);
196 
197         balances[_from] = balances[_from].sub(_value);
198         balances[_to] = balances[_to].add(_value);
199         allowed[_from][msg.sender] = _allowance.sub(_value);
200         Transfer(_from, _to, _value);
201         if (transferIns[_from].length > 0)
202             delete transferIns[_from];
203         uint64 _now = uint64(now);
204         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
205         transferIns[_to].push(transferInStruct(uint128(_value),_now));
206         return true;
207     }
208 
209     function approve(address _spender, uint256 _value) public returns (bool) {
210         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
211 
212         allowed[msg.sender][_spender] = _value;
213         Approval(msg.sender, _spender, _value);
214         return true;
215     }
216 
217     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
218         return allowed[_owner][_spender];
219     }
220 
221     function mint() canPoSMint public returns (bool) {
222         // minimum stake of 5000 BITTO is required to earn staking.
223         if (balances[msg.sender] < 5000 ether)
224             return false;
225         if (transferIns[msg.sender].length <= 0)
226             return false;
227 
228         uint reward = getProofOfStakeReward(msg.sender);
229         if (reward <= 0)
230             return false;
231 
232         totalSupply = totalSupply.add(reward);
233         balances[msg.sender] = balances[msg.sender].add(reward);
234         delete transferIns[msg.sender];
235         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
236 
237         Transfer(address(0), msg.sender, reward);
238         Mint(msg.sender, reward);
239         return true;
240     }
241 
242     function getBlockNumber() view public returns (uint blockNumber) {
243         blockNumber = block.number.sub(chainStartBlockNumber);
244     }
245 
246     function coinAge() constant public returns (uint myCoinAge) {
247         myCoinAge = getCoinAge(msg.sender,now);
248     }
249 
250     function annualInterest() constant public returns (uint interest) {
251         // uint _now = now;
252         // interest = maxMintProofOfStake;
253         // if ((_now.sub(stakeStartTime)).div(1 years) == 0) {
254         //     interest = (770 * maxMintProofOfStake).div(100);
255         // } else if ((_now.sub(stakeStartTime)).div(1 years) == 1) {
256         //     interest = (435 * maxMintProofOfStake).div(100);
257         // }
258 
259         return REWARDS_PER_AGE;
260     }
261 
262     function getProofOfStakeReward(address _address) internal returns (uint) {
263         require((now >= stakeStartTime) && (stakeStartTime > 0));
264         require(!noPOSRewards[_address]);
265 
266         uint _now = now;
267         uint _coinAge = getCoinAge(_address, _now);
268         if (_coinAge <= 0)
269             return 0;
270 
271         // uint interest = maxMintProofOfStake;
272         // // Due to the high interest rate for the first two years, compounding should be taken into account.
273         // // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
274         // if ((_now.sub(stakeStartTime)).div(1 years) == 0) {
275         //     // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
276         //     interest = (770 * maxMintProofOfStake).div(100);
277         // } else if ((_now.sub(stakeStartTime)).div(1 years) == 1) {
278         //     // 2nd year effective annual interest rate is 50%
279         //     interest = (435 * maxMintProofOfStake).div(100);
280         // }
281 
282         // return (_coinAge * interest).div(365 * (10**decimals));
283         return _coinAge.mul(REWARDS_PER_AGE);
284     }
285 
286     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
287         if (transferIns[_address].length <= 0)
288             return 0;
289 
290         for (uint i = 0; i < transferIns[_address].length; i++) {
291             if (_now < uint(transferIns[_address][i].time).add(stakeMinAge))
292                 continue;
293 
294             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
295             if ( nCoinSeconds > stakeMaxAge )
296                 nCoinSeconds = stakeMaxAge;
297 
298             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
299         }
300         _coinAge = _coinAge.div(5000 ether);
301     }
302 
303     function ownerSetStakeStartTime(uint timestamp) onlyOwner public {
304         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
305         stakeStartTime = timestamp;
306     }
307 
308     function ownerBurnToken(uint _value) onlyOwner public {
309         require(_value > 0);
310 
311         balances[msg.sender] = balances[msg.sender].sub(_value);
312         delete transferIns[msg.sender];
313         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
314 
315         totalSupply = totalSupply.sub(_value);
316         totalInitialSupply = totalInitialSupply.sub(_value);
317         maxTotalSupply = maxTotalSupply.sub(_value*10);
318 
319         Burn(msg.sender, _value);
320     }
321 
322     /**
323     * @dev Burns a specific amount of tokens.
324     * @param _value The amount of token to be burned.
325     */
326     function burn(uint256 _value) public {
327         require(_value <= balances[msg.sender]);
328         // no need to require value <= totalSupply, since that would imply the
329         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
330 
331         address burner = msg.sender;
332         balances[burner] = balances[burner].sub(_value);
333         delete transferIns[msg.sender];
334         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
335         totalSupply = totalSupply.sub(_value);
336         Burn(burner, _value);
337     }
338 
339     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
340     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner public returns (bool) {
341         require(_recipients.length > 0 && _recipients.length == _values.length);
342 
343         uint total = 0;
344         for (uint i = 0; i < _values.length; i++) {
345             total = total.add(_values[i]);
346         }
347         require(total <= balances[msg.sender]);
348 
349         uint64 _now = uint64(now);
350         for (uint j = 0; j < _recipients.length; j++) {
351             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
352             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
353             Transfer(msg.sender, _recipients[j], _values[j]);
354         }
355 
356         balances[msg.sender] = balances[msg.sender].sub(total);
357         if (transferIns[msg.sender].length > 0)
358             delete transferIns[msg.sender];
359         if (balances[msg.sender] > 0)
360             transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
361 
362         return true;
363     }
364 
365     function disablePOSReward(address _account, bool _enabled) onlyOwner public {
366         noPOSRewards[_account] = _enabled;
367     }
368 }