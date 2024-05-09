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
62 }
63 
64 
65 /**
66  * @title ERC20Basic
67  * @dev Simpler version of ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/179
69  */
70 contract ERC20Basic {
71     uint256 public totalSupply;
72     function balanceOf(address who) constant returns (uint256);
73     function transfer(address to, uint256 value) returns (bool);
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic {
83     function allowance(address owner, address spender) constant returns (uint256);
84     function transferFrom(address from, address to, uint256 value) returns (bool);
85     function approve(address spender, uint256 value) returns (bool);
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 /**
91  * @title onethousandToken
92  * @dev the interface of PoSTokenStandard
93  */
94 contract onethousandToken {
95     uint256 public stakeStartTime;
96     uint256 public stakeMinAge;
97     uint256 public stakeMaxAge;
98     function mint() returns (bool);
99     function coinAge() constant returns (uint256);
100     function annualInterest() constant returns (uint256);
101     event Mint(address indexed _address, uint _reward);
102 }
103 
104 
105 contract onethousand is ERC20, onethousandToken,Ownable {
106     using SafeMath for uint256;
107 
108     string public name = "1K Token";
109     string public symbol = "1KT";
110     uint public decimals = 18;
111 
112     uint public chainStartTime; //chain start time
113     uint public chainStartBlockNumber; //chain start block number
114     uint public stakeStartTime; //stake start time
115     uint public stakeMinAge = 3 days; // minimum age for coin age: 3D
116     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
117     uint public maxMintProofOfStake = 10**17; // default 10% annual interest
118 
119     uint public totalSupply;
120     uint public maxTotalSupply;
121     uint public totalInitialSupply;
122 
123     struct transferInStruct{
124     uint128 amount;
125     uint64 time;
126     }
127 
128     mapping(address => uint256) balances;
129     mapping(address => mapping (address => uint256)) allowed;
130     mapping(address => transferInStruct[]) transferIns;
131 
132     event Burn(address indexed burner, uint256 value);
133 
134     /**
135      * @dev Fix for the ERC20 short address attack.
136      */
137     modifier onlyPayloadSize(uint size) {
138         require(msg.data.length >= size + 4);
139         _;
140     }
141 
142     modifier canPoSMint() {
143         require(totalSupply < maxTotalSupply);
144         _;
145     }
146 
147     function onethousand() {
148         maxTotalSupply = 1000000000000000000000;
149         totalInitialSupply = 100000000000000000000;
150 
151         chainStartTime = now;
152         chainStartBlockNumber = block.number;
153 
154         balances[msg.sender] = totalInitialSupply;
155         totalSupply = totalInitialSupply;
156     }
157 
158     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
159         if(msg.sender == _to) return mint();
160         balances[msg.sender] = balances[msg.sender].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         Transfer(msg.sender, _to, _value);
163         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
164         uint64 _now = uint64(now);
165         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
166         transferIns[_to].push(transferInStruct(uint128(_value),_now));
167         return true;
168     }
169 
170     function balanceOf(address _owner) constant returns (uint256 balance) {
171         return balances[_owner];
172     }
173 
174     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
175         require(_to != address(0));
176 
177         var _allowance = allowed[_from][msg.sender];
178 
179         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
180         // require (_value <= _allowance);
181 
182         balances[_from] = balances[_from].sub(_value);
183         balances[_to] = balances[_to].add(_value);
184         allowed[_from][msg.sender] = _allowance.sub(_value);
185         Transfer(_from, _to, _value);
186         if(transferIns[_from].length > 0) delete transferIns[_from];
187         uint64 _now = uint64(now);
188         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
189         transferIns[_to].push(transferInStruct(uint128(_value),_now));
190         return true;
191     }
192 
193     function approve(address _spender, uint256 _value) returns (bool) {
194         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
195 
196         allowed[msg.sender][_spender] = _value;
197         Approval(msg.sender, _spender, _value);
198         return true;
199     }
200 
201     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
202         return allowed[_owner][_spender];
203     }
204 
205     function mint() canPoSMint returns (bool) {
206         if(balances[msg.sender] <= 0) return false;
207         if(transferIns[msg.sender].length <= 0) return false;
208 
209         uint reward = getProofOfStakeReward(msg.sender);
210         if(reward <= 0) return false;
211 
212         totalSupply = totalSupply.add(reward);
213         balances[msg.sender] = balances[msg.sender].add(reward);
214         delete transferIns[msg.sender];
215         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
216 
217         Mint(msg.sender, reward);
218         return true;
219     }
220 
221     function getBlockNumber() returns (uint blockNumber) {
222         blockNumber = block.number.sub(chainStartBlockNumber);
223     }
224 
225     function coinAge() constant returns (uint myCoinAge) {
226         myCoinAge = getCoinAge(msg.sender,now);
227     }
228 
229     function annualInterest() constant returns(uint interest) {
230         uint _now = now;
231         interest = maxMintProofOfStake;
232         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
233             interest = (770 * maxMintProofOfStake).div(100);
234         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
235             interest = (435 * maxMintProofOfStake).div(100);
236         }
237     }
238 
239     function getProofOfStakeReward(address _address) internal returns (uint) {
240         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
241 
242         uint _now = now;
243         uint _coinAge = getCoinAge(_address, _now);
244         if(_coinAge <= 0) return 0;
245 
246         uint interest = maxMintProofOfStake;
247         // Due to the high interest rate for the first and second years, compounding should be taken into account.
248         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
249         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
250             // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
251             interest = (770 * maxMintProofOfStake).div(100);
252         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
253             // 2nd year effective annual interest rate is 50%
254             interest = (435 * maxMintProofOfStake).div(100);
255         }
256 
257         return (_coinAge * interest).div(365 * (10**decimals));
258     }
259 
260     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
261         if(transferIns[_address].length <= 0) return 0;
262 
263         for (uint i = 0; i < transferIns[_address].length; i++){
264             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
265 
266             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
267             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
268 
269             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
270         }
271     }
272 
273     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
274         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
275         stakeStartTime = timestamp;
276     }
277 
278     function ownerBurnToken(uint _value) onlyOwner {
279         require(_value > 0);
280 
281         balances[msg.sender] = balances[msg.sender].sub(_value);
282         delete transferIns[msg.sender];
283         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
284 
285         totalSupply = totalSupply.sub(_value);
286         totalInitialSupply = totalInitialSupply.sub(_value);
287         maxTotalSupply = maxTotalSupply.sub(_value*10);
288 
289         Burn(msg.sender, _value);
290     }
291 
292     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
293     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
294         require( _recipients.length > 0 && _recipients.length == _values.length);
295 
296         uint total = 0;
297         for(uint i = 0; i < _values.length; i++){
298             total = total.add(_values[i]);
299         }
300         require(total <= balances[msg.sender]);
301 
302         uint64 _now = uint64(now);
303         for(uint j = 0; j < _recipients.length; j++){
304             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
305             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
306             Transfer(msg.sender, _recipients[j], _values[j]);
307         }
308 
309         balances[msg.sender] = balances[msg.sender].sub(total);
310         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
311         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
312 
313         return true;
314     }
315 }