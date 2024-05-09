1 pragma solidity ^0.4.4;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal constant returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal constant returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37     address public owner;
38 
39 
40     /**
41      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42      * account.
43      */
44     function Ownable() {
45         owner = msg.sender;
46     }
47 
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) onlyOwner {
61         require(newOwner != address(0));
62         owner = newOwner;
63     }
64 
65 }
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72     uint256 public totalSupply;
73     function balanceOf(address who) constant returns (uint256);
74     function transfer(address to, uint256 value) returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82     function allowance(address owner, address spender) constant returns (uint256);
83     function transferFrom(address from, address to, uint256 value) returns (bool);
84     function approve(address spender, uint256 value) returns (bool);
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 /**
88  * @title PoSTokenStandard
89  * @dev the interface of PoSTokenStandard
90  */
91 contract PoSTokenStandard {
92     uint256 public stakeStartTime;
93     uint256 public stakeMinAge;
94     uint256 public stakeMaxAge;
95    //Maximumcoin - Modified the correct technical term "mint" to a well know term "mine" for marketing purposes
96     function mine() returns (bool);
97     function coinAge(address who) constant returns (uint256);
98     function annualInterest() constant returns (uint256);
99     event Mine(address indexed _address, uint _reward);
100 }
101 //Maximumcoin - Changed name of contract
102 contract Maximumcoin is ERC20,PoSTokenStandard,Ownable {
103     using SafeMath for uint256;
104 //Maximumcoin - Changed name of contract
105     string public name = "Maximum-coin";
106     string public symbol = "xMUM";
107     uint public decimals = 18;
108 
109     uint public chainStartTime; //chain start time
110     uint public chainStartBlockNumber; //chain start block number
111     uint public stakeStartTime; //stake start time
112     uint public stakeMinAge = 3 days; // minimum age for coin age: 3D
113     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
114     uint public maxMintProofOfStake = 10**17; // default 10% annual interest
115 
116     uint public totalSupply;
117     uint public maxTotalSupply;
118     uint public totalInitialSupply;
119 
120     struct transferInStruct{
121     uint128 amount;
122     uint64 time;
123     }
124 
125     mapping(address => uint256) balances;
126     mapping(address => mapping (address => uint256)) allowed;
127     mapping(address => transferInStruct[]) transferIns;
128 
129 //Maximumcoin - Removed burn system
130     //event Burn(address indexed burner, uint256 value);
131 
132     /**
133      * @dev Fix for the ERC20 short address attack.
134      */
135     modifier onlyPayloadSize(uint size) {
136         require(msg.data.length >= size + 4);
137         _;
138     }
139 
140     modifier canPoSMint() {
141         require(totalSupply < maxTotalSupply);
142         _;
143     }
144 
145     function MaximumcoinStart() onlyOwner {
146         address recipient;
147         uint value;
148         uint64 _now = uint64(now);
149         //kill start if this has already been ran
150         require((maxTotalSupply <= 0));
151 
152         maxTotalSupply = 10**25; // 10 Mil.
153         
154         //Maximumcoin - Modified initial supply to 250k
155         totalInitialSupply = 2.5*(10**23); // 250K
156 
157         chainStartTime = now;
158         chainStartBlockNumber = block.number;
159 
160         //Free Airdrop and Bounty Program - 200K
161         recipient = 0x1748b386a6F008Ce4Ad3a969974F4D7b7c0d92bE;
162         value = 2 * (10**23);
163 
164         //run
165         balances[recipient] = value;
166         transferIns[recipient].push(transferInStruct(uint128(value),_now));
167 
168         //iMAC development Team - 50K
169         recipient = 0x8067d29f98A8E7F87713867c0e9bF5ae578B3237;
170         value = 5 * (10**22);
171 
172         //run
173         balances[recipient] = value;
174         transferIns[recipient].push(transferInStruct(uint128(value),_now));
175 
176         totalSupply = totalInitialSupply;
177     }
178 
179     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
180         //Maximumcoin - Modified to mine
181         if(msg.sender == _to) return mine();
182         balances[msg.sender] = balances[msg.sender].sub(_value);
183         balances[_to] = balances[_to].add(_value);
184         Transfer(msg.sender, _to, _value);
185         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
186         uint64 _now = uint64(now);
187         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
188         transferIns[_to].push(transferInStruct(uint128(_value),_now));
189         return true;
190     }
191 
192     function balanceOf(address _owner) constant returns (uint256 balance) {
193         return balances[_owner];
194     }
195 
196     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
197         require(_to != address(0));
198 
199         var _allowance = allowed[_from][msg.sender];
200 
201         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
202         // require (_value <= _allowance);
203 
204         balances[_from] = balances[_from].sub(_value);
205         balances[_to] = balances[_to].add(_value);
206         allowed[_from][msg.sender] = _allowance.sub(_value);
207         Transfer(_from, _to, _value);
208         if(transferIns[_from].length > 0) delete transferIns[_from];
209         uint64 _now = uint64(now);
210         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
211         transferIns[_to].push(transferInStruct(uint128(_value),_now));
212         return true;
213     }
214 
215     function approve(address _spender, uint256 _value) returns (bool) {
216         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
217 
218         allowed[msg.sender][_spender] = _value;
219         Approval(msg.sender, _spender, _value);
220         return true;
221     }
222 
223     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
224         return allowed[_owner][_spender];
225     }
226 //Maximumcoin - Modified the correct technical term "mint" to a well know term "mine" for marketing purposes.
227     function mine() canPoSMint returns (bool) {
228         if(balances[msg.sender] <= 0) return false;
229         if(transferIns[msg.sender].length <= 0) return false;
230 
231         uint reward = getProofOfStakeReward(msg.sender);
232         if(reward <= 0) return false;
233 
234         totalSupply = totalSupply.add(reward);
235         balances[msg.sender] = balances[msg.sender].add(reward);
236         delete transferIns[msg.sender];
237         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
238 //Maximumcoin - Change event to Mine
239         Mine(msg.sender, reward);
240         return true;
241     }
242 
243     function getBlockNumber() returns (uint blockNumber) {
244         blockNumber = block.number.sub(chainStartBlockNumber);
245     }
246 
247     function coinAge(address who) constant returns (uint myCoinAge) {
248         myCoinAge = getCoinAge(who,now);
249     }
250 
251     function annualInterest() constant returns(uint interest) {
252         uint _now = now;
253         interest = maxMintProofOfStake;
254         //Maximumcoin - Modified initial interest rate to 300%
255         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
256             interest = (1650 * maxMintProofOfStake).div(100);
257         } else if((_now.sub(stakeStartTime)).div(1 years) == 1) {
258             interest = (770 * maxMintProofOfStake).div(100);
259         } else if((_now.sub(stakeStartTime)).div(1 years) == 2){
260             interest = (435 * maxMintProofOfStake).div(100);
261         }
262     }
263 
264     function getProofOfStakeReward(address _address) internal returns (uint) {
265         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
266 
267         uint _now = now;
268         uint _coinAge = getCoinAge(_address, _now);
269         if(_coinAge <= 0) return 0;
270 
271         uint interest = maxMintProofOfStake;
272         // Due to the high interest rate for the first two years, compounding should be taken into account.
273         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
274         //Maximumcoin - Modified initial interest rate to 300%
275         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
276             // 1st year effective annual interest rate is 300% when we select the stakeMaxAge (90 days) as the compounding period.
277             interest = (1650 * maxMintProofOfStake).div(100);
278         } else if((_now.sub(stakeStartTime)).div(1 years) == 1) {
279             // 2nd year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
280             interest = (770 * maxMintProofOfStake).div(100);
281         } else if((_now.sub(stakeStartTime)).div(1 years) == 2){
282             // 3nd year effective annual interest rate is 50%
283             interest = (435 * maxMintProofOfStake).div(100);
284         }
285 
286         return (_coinAge * interest).div(365 * (10**decimals));
287     }
288 
289     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
290         if(transferIns[_address].length <= 0) return 0;
291 
292         for (uint i = 0; i < transferIns[_address].length; i++){
293             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
294 
295             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
296             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
297 
298             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
299         }
300     }
301 
302     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
303         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
304         stakeStartTime = timestamp;
305     }
306 
307 }