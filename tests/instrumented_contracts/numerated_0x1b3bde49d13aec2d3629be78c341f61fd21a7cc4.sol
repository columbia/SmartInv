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
35 contract Ownable {
36     address public owner;
37 
38 
39     function Ownable() {
40         owner = msg.sender;
41     }
42 
43 
44     /**
45      * @dev Throws if called by any account other than the owner.
46      */
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52 
53     /**
54      * @dev Allows the current owner to transfer control of the contract to a newOwner.
55      * @param newOwner The address to transfer ownership to.
56      */
57     function transferOwnership(address newOwner) onlyOwner {
58         require(newOwner != address(0));
59         owner = newOwner;
60     }
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
90 contract PoSStandard {
91     uint256 public stakeStartTime;
92     uint256 public stakeMinAge;
93     uint256 public stakeMaxAge;
94     function mint() returns (bool);
95     function coinAge() constant returns (uint256);
96     function annualInterest() constant returns (uint256);
97     event Mint(address indexed _address, uint _reward);
98 }
99 
100 
101 contract Meristem is ERC20,PoSStandard,Ownable {
102     using SafeMath for uint256;
103 
104     string public name = "Meristem";
105     string public symbol = "MERI";
106     uint public decimals = 18;
107 
108     uint public chainStartTime; //chain start time
109     uint public chainStartBlockNumber; //chain start block number
110     uint public stakeStartTime; //stake start time
111     uint public stakeMinAge = 3 days; // minimum age for coin age: 3D
112     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
113     uint public maxMintProofOfStake = 10**17; // default 10% annual interest
114 
115     uint public totalSupply;
116     uint public maxTotalSupply;
117     uint public totalInitialSupply;
118 
119     struct transferInStruct{
120     uint128 amount;
121     uint64 time;
122     }
123 
124     mapping(address => uint256) balances;
125     mapping(address => mapping (address => uint256)) allowed;
126     mapping(address => transferInStruct[]) transferIns;
127 
128     event Burn(address indexed burner, uint256 value);
129 
130     /**
131      * @dev Fix for the ERC20 short address attack.
132      */
133     modifier onlyPayloadSize(uint size) {
134         require(msg.data.length >= size + 4);
135         _;
136     }
137 
138     modifier canPoSMint() {
139         require(totalSupply < maxTotalSupply);
140         _;
141     }
142 
143     function Meristem() {
144         maxTotalSupply = 10**25;
145         totalInitialSupply = 10**24;
146 
147         chainStartTime = now;
148         chainStartBlockNumber = block.number;
149 
150         balances[msg.sender] = totalInitialSupply;
151         totalSupply = totalInitialSupply;
152     }
153 
154     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
155         if(msg.sender == _to) return mint();
156         balances[msg.sender] = balances[msg.sender].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         Transfer(msg.sender, _to, _value);
159         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
160         uint64 _now = uint64(now);
161         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
162         transferIns[_to].push(transferInStruct(uint128(_value),_now));
163         return true;
164     }
165 
166     function balanceOf(address _owner) constant returns (uint256 balance) {
167         return balances[_owner];
168     }
169 
170     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
171         require(_to != address(0));
172 
173         var _allowance = allowed[_from][msg.sender];
174 
175         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
176         // require (_value <= _allowance);
177 
178         balances[_from] = balances[_from].sub(_value);
179         balances[_to] = balances[_to].add(_value);
180         allowed[_from][msg.sender] = _allowance.sub(_value);
181         Transfer(_from, _to, _value);
182         if(transferIns[_from].length > 0) delete transferIns[_from];
183         uint64 _now = uint64(now);
184         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
185         transferIns[_to].push(transferInStruct(uint128(_value),_now));
186         return true;
187     }
188 
189     function approve(address _spender, uint256 _value) returns (bool) {
190         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
191 
192         allowed[msg.sender][_spender] = _value;
193         Approval(msg.sender, _spender, _value);
194         return true;
195     }
196 
197     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
198         return allowed[_owner][_spender];
199     }
200 
201     function mint() canPoSMint returns (bool) {
202         if(balances[msg.sender] <= 0) return false;
203         if(transferIns[msg.sender].length <= 0) return false;
204 
205         uint reward = getProofOfStakeReward(msg.sender);
206         if(reward <= 0) return false;
207 
208         totalSupply = totalSupply.add(reward);
209         balances[msg.sender] = balances[msg.sender].add(reward);
210         delete transferIns[msg.sender];
211         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
212 
213         Mint(msg.sender, reward);
214         return true;
215     }
216 
217     function getBlockNumber() returns (uint blockNumber) {
218         blockNumber = block.number.sub(chainStartBlockNumber);
219     }
220 
221     function coinAge() constant returns (uint myCoinAge) {
222         myCoinAge = getCoinAge(msg.sender,now);
223     }
224 
225     function annualInterest() constant returns(uint interest) {
226         uint _now = now;
227         interest = maxMintProofOfStake;
228         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
229             interest = (1650 * maxMintProofOfStake).div(100);
230         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
231             interest = (770 * maxMintProofOfStake).div(100);
232         }
233     }
234 
235     function getProofOfStakeReward(address _address) internal returns (uint) {
236         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
237 
238         uint _now = now;
239         uint _coinAge = getCoinAge(_address, _now);
240         if(_coinAge <= 0) return 0;
241 
242         uint interest = maxMintProofOfStake;
243         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
244             // 1st year effective annual interest rate is 300% when we select the stakeMaxAge (90 days) as the compounding period.
245             interest = (1650 * maxMintProofOfStake).div(100);
246         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
247             // 2nd year effective annual interest rate is 100%
248             interest = (770 * maxMintProofOfStake).div(100);
249         }
250 
251         return (_coinAge * interest).div(365 * (10**decimals));
252     }
253 
254     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
255         if(transferIns[_address].length <= 0) return 0;
256 
257         for (uint i = 0; i < transferIns[_address].length; i++){
258             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
259 
260             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
261             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
262 
263             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
264         }
265     }
266 
267     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
268         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
269         stakeStartTime = timestamp;
270     }
271 
272     function ownerBurnToken(uint _value) onlyOwner {
273         require(_value > 0);
274 
275         balances[msg.sender] = balances[msg.sender].sub(_value);
276         delete transferIns[msg.sender];
277         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
278 
279         totalSupply = totalSupply.sub(_value);
280         totalInitialSupply = totalInitialSupply.sub(_value);
281         maxTotalSupply = maxTotalSupply.sub(_value*10);
282 
283         Burn(msg.sender, _value);
284     }
285 
286     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
287     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
288         require( _recipients.length > 0 && _recipients.length == _values.length);
289 
290         uint total = 0;
291         for(uint i = 0; i < _values.length; i++){
292             total = total.add(_values[i]);
293         }
294         require(total <= balances[msg.sender]);
295 
296         uint64 _now = uint64(now);
297         for(uint j = 0; j < _recipients.length; j++){
298             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
299             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
300             Transfer(msg.sender, _recipients[j], _values[j]);
301         }
302 
303         balances[msg.sender] = balances[msg.sender].sub(total);
304         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
305         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
306 
307         return true;
308     }
309 }