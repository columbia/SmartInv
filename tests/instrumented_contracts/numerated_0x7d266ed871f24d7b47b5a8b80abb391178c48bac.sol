1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 pragma solidity ^0.4.23;
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipRenounced(address indexed previousOwner);
62   event OwnershipTransferred(
63     address indexed previousOwner,
64     address indexed newOwner
65   );
66 
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   constructor() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address newOwner) public onlyOwner {
89     require(newOwner != address(0));
90     emit OwnershipTransferred(owner, newOwner);
91     owner = newOwner;
92   }
93 
94   /**
95    * @dev Allows the current owner to relinquish control of the contract.
96    */
97   function renounceOwnership() public onlyOwner {
98     emit OwnershipRenounced(owner);
99     owner = address(0);
100   }
101 }
102 
103 /**
104  * @title ERC20Basic
105  * @dev Simpler version of ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/179
107  */
108 contract ERC20Basic {
109     uint256 public totalSupply;
110     function balanceOf(address who) public constant returns (uint256);
111     function transfer(address to, uint256 value) public returns (bool);
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121     function allowance(address owner, address spender) public constant returns (uint256);
122     function transferFrom(address from, address to, uint256 value) public returns (bool);
123     function approve(address spender, uint256 value) public returns (bool);
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 
128 /**
129  * @title StakeItStandard
130  * @dev the interface of StakeItStandard
131  */
132 contract StakeItStandard {
133     uint256 public stakeStartTime;
134     uint256 public stakeMinAge;
135     uint256 public stakeMaxAge;
136     function mint() public returns (bool);
137     function coinAge() public constant returns (uint256);
138     function annualInterest() public constant returns (uint256);
139     event Mint(address indexed _address, uint _reward);
140 }
141 
142 
143 contract StakeIt is ERC20, StakeItStandard, Ownable {
144     using SafeMath for uint256;
145 
146     string public name = "StakeIt";
147     string public symbol = "STAKE";
148     uint public decimals = 8;
149 
150     uint public chainStartTime; // chain start time
151     uint public chainStartBlockNumber; // chain start block number
152     uint public stakeStartTime; // stake start time
153     uint public stakeMinAge = 1 days; // minimum age for coin age: 1 Day
154     uint public stakeMaxAge = 90 days; // stake age of full weight: 90 Days
155     uint public MintProofOfStake = 100 * 10 ** uint256(decimals); // default 100% annual interest
156 
157     uint public totalSupply;
158     uint public maxTotalSupply;
159     uint public totalInitialSupply;
160 
161     struct transferInStruct{
162     uint128 amount;
163     uint64 time;
164     }
165 
166     mapping(address => uint256) balances;
167     mapping(address => mapping (address => uint256)) allowed;
168     mapping(address => transferInStruct[]) transferIns;
169 
170     event Burn(address indexed burner, uint256 value);
171 
172     /**
173      * @dev Fix for the ERC20 short address attack.
174      */
175     modifier onlyPayloadSize(uint size) {
176         require(msg.data.length >= size + 4);
177         _;
178     }
179 
180     modifier canPoSMint() {
181         require(totalSupply < maxTotalSupply);
182         _;
183     }
184 
185     constructor() public {
186         maxTotalSupply = 100000000 * 10 ** uint256(decimals); // 100,000,000
187         totalInitialSupply = 5000000 * 10 ** uint256(decimals); // 5,000,000
188 
189         chainStartTime = now;
190         chainStartBlockNumber = block.number;
191 
192         balances[msg.sender] = totalInitialSupply;
193         totalSupply = totalInitialSupply;
194     }
195 
196     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
197         if(msg.sender == _to) return mint();
198         balances[msg.sender] = balances[msg.sender].sub(_value);
199         balances[_to] = balances[_to].add(_value);
200         emit Transfer(msg.sender, _to, _value);
201         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
202         uint64 _now = uint64(now);
203         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
204         transferIns[_to].push(transferInStruct(uint128(_value),_now));
205         return true;
206     }
207 
208     function balanceOf(address _owner) public constant returns (uint256 balance) {
209         return balances[_owner];
210     }
211 
212     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
213         require(_to != address(0));
214 
215         var _allowance = allowed[_from][msg.sender];
216 
217         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
218         // require (_value <= _allowance);
219 
220         balances[_from] = balances[_from].sub(_value);
221         balances[_to] = balances[_to].add(_value);
222         allowed[_from][msg.sender] = _allowance.sub(_value);
223         emit Transfer(_from, _to, _value);
224         if(transferIns[_from].length > 0) delete transferIns[_from];
225         uint64 _now = uint64(now);
226         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
227         transferIns[_to].push(transferInStruct(uint128(_value),_now));
228         return true;
229     }
230 
231     function approve(address _spender, uint256 _value) public returns (bool) {
232         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
233 
234         allowed[msg.sender][_spender] = _value;
235         emit Approval(msg.sender, _spender, _value);
236         return true;
237     }
238 
239     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
240         return allowed[_owner][_spender];
241     }
242     
243     function changeRate(uint _rate) public onlyOwner {
244         MintProofOfStake = _rate * 10 ** uint256(decimals);
245     }
246 
247     function mint() canPoSMint public returns (bool) {
248         if(balances[msg.sender] <= 0) return false;
249         if(transferIns[msg.sender].length <= 0) return false;
250 
251         uint reward = getProofOfStakeReward(msg.sender);
252         if(reward <= 0) return false;
253 
254         totalSupply = totalSupply.add(reward);
255         balances[msg.sender] = balances[msg.sender].add(reward);
256         delete transferIns[msg.sender];
257         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
258 
259         emit Mint(msg.sender, reward);
260         return true;
261     }
262 
263     function getBlockNumber() public view returns (uint blockNumber) {
264         blockNumber = block.number.sub(chainStartBlockNumber);
265     }
266 
267     function coinAge() public constant returns (uint myCoinAge) {
268         myCoinAge = getCoinAge(msg.sender, now);
269     }
270 
271     function annualInterest() public constant returns(uint interest) {
272         interest = MintProofOfStake;
273     }
274 
275     function getProofOfStakeReward(address _address) internal view returns (uint) {
276         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
277 
278         uint _now = now;
279         uint _coinAge = getCoinAge(_address, _now);
280         if(_coinAge <= 0) return 0;
281 
282         uint interest = MintProofOfStake;
283 
284         return (_coinAge * interest).div(365 * (10**uint256(decimals)));
285     }
286 
287     function getCoinAge(address _address, uint _now) internal view returns (uint _coinAge) {
288         if(transferIns[_address].length <= 0) return 0;
289 
290         for (uint i = 0; i < transferIns[_address].length; i++){
291             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
292 
293             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
294             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
295 
296             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
297         }
298     }
299 
300     function ownerSetStakeStartTime(uint timestamp) public onlyOwner {
301         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
302         stakeStartTime = timestamp;
303     }
304 
305     function ownerBurnToken(uint _value) public onlyOwner {
306         require(_value > 0);
307 
308         balances[msg.sender] = balances[msg.sender].sub(_value);
309         delete transferIns[msg.sender];
310         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
311 
312         totalSupply = totalSupply.sub(_value);
313         totalInitialSupply = totalInitialSupply.sub(_value);
314         maxTotalSupply = maxTotalSupply.sub(_value*10);
315 
316         emit Burn(msg.sender, _value);
317     }
318 
319     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
320     function batchTransfer(address[] _recipients, uint[] _values) public onlyOwner returns (bool) {
321         require( _recipients.length > 0 && _recipients.length == _values.length);
322 
323         uint total = 0;
324         for(uint i = 0; i < _values.length; i++){
325             total = total.add(_values[i]);
326         }
327         require(total <= balances[msg.sender]);
328 
329         uint64 _now = uint64(now);
330         for(uint j = 0; j < _recipients.length; j++){
331             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
332             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
333             emit Transfer(msg.sender, _recipients[j], _values[j]);
334         }
335 
336         balances[msg.sender] = balances[msg.sender].sub(total);
337         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
338         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
339 
340         return true;
341     }
342 }