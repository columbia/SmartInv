1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41     address public owner;
42 
43 
44     /**
45      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46      * account.
47      */
48     function Ownable() {
49         owner = msg.sender;
50     }
51 
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) onlyOwner {
67         require(newOwner != address(0));
68         owner = newOwner;
69     }
70 
71 }
72 
73 
74 /**
75  * @title ERC20Basic
76  * @dev Simpler version of ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/179
78  */
79 contract ERC20Basic {
80     uint256 public totalSupply;
81     function balanceOf(address who) constant returns (uint256);
82     function transfer(address to, uint256 value) returns (bool);
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92     function allowance(address owner, address spender) constant returns (uint256);
93     function transferFrom(address from, address to, uint256 value) returns (bool);
94     function approve(address spender, uint256 value) returns (bool);
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 /**
100  * @title PoSTokenStandard
101  * @dev the interface of PoSTokenStandard
102  */
103 contract PoSTokenStandard {
104     uint256 public stakeStartTime;
105     uint256 public stakeMinAge;
106     uint256 public stakeMaxAge;
107     function mine() returns (bool);
108     function coinAge() constant returns (uint256);
109     function annualInterest() constant returns (uint256);
110     event Mine(address indexed _address, uint _reward);
111 }
112 
113 
114 contract iPoSToken is ERC20,PoSTokenStandard,Ownable {
115     using SafeMath for uint256;
116 
117     string public name = "iPoS";
118     string public symbol = "IPOS";
119     uint public decimals = 18;
120 
121     uint public chainStartTime; //chain start time
122     uint public chainStartBlockNumber; //chain start block number
123     uint public stakeStartTime; //stake start time
124     uint public stakeMinAge = 3 days; // minimum age for coin age: 3D
125     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
126     uint public maxMintProofOfStake = 10**17; // default 10% annual interest
127 
128     uint public totalSupply;
129     uint public maxTotalSupply;
130     uint public totalInitialSupply;
131 
132     struct transferInStruct{
133     uint128 amount;
134     uint64 time;
135     }
136 
137     mapping(address => uint256) balances;
138     mapping(address => mapping (address => uint256)) allowed;
139     mapping(address => transferInStruct[]) transferIns;
140 
141     /**
142      * @dev Fix for the ERC20 short address attack.
143      */
144     modifier onlyPayloadSize(uint size) {
145         require(msg.data.length >= size + 4);
146         _;
147     }
148 
149     modifier canPoSMint() {
150         require(totalSupply < maxTotalSupply);
151         _;
152     }
153 
154     function iPoSToken() {
155         maxTotalSupply = 10**25; // 10 Mil.
156         totalInitialSupply = 5*(10**23); // 500k.
157 
158         chainStartTime = now;
159         chainStartBlockNumber = block.number;
160 
161         balances[msg.sender] = totalInitialSupply;
162         totalSupply = totalInitialSupply;
163     }
164 
165     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
166         if(msg.sender == _to) return mine();
167         balances[msg.sender] = balances[msg.sender].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         Transfer(msg.sender, _to, _value);
170         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
171         uint64 _now = uint64(now);
172         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
173         transferIns[_to].push(transferInStruct(uint128(_value),_now));
174         return true;
175     }
176 
177     function balanceOf(address _owner) constant returns (uint256 balance) {
178         return balances[_owner];
179     }
180 
181     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
182         require(_to != address(0));
183 
184         var _allowance = allowed[_from][msg.sender];
185 
186         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
187         // require (_value <= _allowance);
188 
189         balances[_from] = balances[_from].sub(_value);
190         balances[_to] = balances[_to].add(_value);
191         allowed[_from][msg.sender] = _allowance.sub(_value);
192         Transfer(_from, _to, _value);
193         if(transferIns[_from].length > 0) delete transferIns[_from];
194         uint64 _now = uint64(now);
195         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
196         transferIns[_to].push(transferInStruct(uint128(_value),_now));
197         return true;
198     }
199 
200     function approve(address _spender, uint256 _value) returns (bool) {
201         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
202 
203         allowed[msg.sender][_spender] = _value;
204         Approval(msg.sender, _spender, _value);
205         return true;
206     }
207 
208     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
209         return allowed[_owner][_spender];
210     }
211 
212     function mine() canPoSMint returns (bool) {
213         if(balances[msg.sender] <= 0) return false;
214         if(transferIns[msg.sender].length <= 0) return false;
215 
216         uint reward = getProofOfStakeReward(msg.sender);
217         if(reward <= 0) return false;
218 
219         totalSupply = totalSupply.add(reward);
220         balances[msg.sender] = balances[msg.sender].add(reward);
221         delete transferIns[msg.sender];
222         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
223 
224         Mine(msg.sender, reward);
225         return true;
226     }
227 
228     function getBlockNumber() returns (uint blockNumber) {
229         blockNumber = block.number.sub(chainStartBlockNumber);
230     }
231 
232     function coinAge() constant returns (uint myCoinAge) {
233         myCoinAge = getCoinAge(msg.sender,now);
234     }
235 
236         function annualInterest() constant returns(uint interest) {
237         uint _now = now;
238         interest = maxMintProofOfStake;
239         // Modified initial interest rate to 300%
240         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
241             interest = (1650 * maxMintProofOfStake).div(100);
242         } else if((_now.sub(stakeStartTime)).div(1 years) == 1) {
243             interest = (770 * maxMintProofOfStake).div(100);
244         } else if((_now.sub(stakeStartTime)).div(1 years) == 2){
245             interest = (435 * maxMintProofOfStake).div(100);
246         }
247     }
248 
249     function getProofOfStakeReward(address _address) internal returns (uint) {
250         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
251 
252         uint _now = now;
253         uint _coinAge = getCoinAge(_address, _now);
254         if(_coinAge <= 0) return 0;
255 
256         uint interest = maxMintProofOfStake;
257         // Due to the high interest rate for the first two years, compounding should be taken into account.
258         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
259         // Modified initial interest rate to 300%
260         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
261             // 1st year effective annual interest rate is 300% when we select the stakeMaxAge (90 days) as the compounding period.
262             interest = (1650 * maxMintProofOfStake).div(100);
263         } else if((_now.sub(stakeStartTime)).div(1 years) == 1) {
264             // 2nd year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
265             interest = (770 * maxMintProofOfStake).div(100);
266         } else if((_now.sub(stakeStartTime)).div(1 years) == 2){
267             // 3nd year effective annual interest rate is 50%
268             interest = (435 * maxMintProofOfStake).div(100);
269         }
270 
271         return (_coinAge * interest).div(365 * (10**decimals));
272     }
273 
274     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
275         if(transferIns[_address].length <= 0) return 0;
276 
277         for (uint i = 0; i < transferIns[_address].length; i++){
278             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
279 
280             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
281             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
282 
283             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
284         }
285     }
286 
287     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
288         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
289         stakeStartTime = timestamp;
290     }
291 
292     
293     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
294     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
295         require( _recipients.length > 0 && _recipients.length == _values.length);
296 
297         uint total = 0;
298         for(uint i = 0; i < _values.length; i++){
299             total = total.add(_values[i]);
300         }
301         require(total <= balances[msg.sender]);
302 
303         uint64 _now = uint64(now);
304         for(uint j = 0; j < _recipients.length; j++){
305             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
306             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
307             Transfer(msg.sender, _recipients[j], _values[j]);
308         }
309 
310         balances[msg.sender] = balances[msg.sender].sub(total);
311         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
312         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
313 
314         return true;
315     }
316 }