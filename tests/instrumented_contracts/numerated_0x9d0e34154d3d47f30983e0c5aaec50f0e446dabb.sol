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
48     function Ownable() public {
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
66     function transferOwnership(address newOwner) onlyOwner public
67     {
68         require(newOwner != address(0));
69         owner = newOwner;
70     }
71 
72 }
73 
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81     uint256 public totalSupply;
82     function balanceOf(address who) public constant returns (uint256);
83     function transfer(address to, uint tokens) public returns (bool success);
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93     function transfer(address to, uint tokens) public returns (bool success);
94     function approve(address spender, uint tokens) public returns (bool success);
95     function transferFrom(address from, address to, uint tokens) public returns (bool success);
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 
100 /**
101  * @title PoSTokenStandard
102  * @dev the interface of PoSTokenStandard
103  */
104 contract PoSTokenStandard {
105     uint256 public stakeStartTime;
106     uint256 public stakeMinAge;
107     uint256 public stakeMaxAge;
108     function mint() public returns (bool);
109     function coinAge() public constant returns (uint256);
110     function annualInterest() public constant returns (uint256);
111     event Mint(address indexed _address, uint _reward);
112 }
113 
114 
115 contract TerraFirma is ERC20,PoSTokenStandard,Ownable {
116     using SafeMath for uint256;
117 
118     string public name = "TerraFirma";
119     string public symbol = "TFC";
120     uint public decimals = 8;
121 
122     uint public chainStartTime; //chain start time
123     uint public chainStartBlockNumber; //chain start block number
124     uint public stakeStartTime; //stake start time
125     uint public stakeMinAge = 3 days; // minimum age for coin age: 3D
126     uint public stakeMaxAge = 30 days; // stake age of full weight: 30D
127     uint public maxMintProofOfStake = 56**7; // default 10% annual interest
128 
129     uint public totalSupply;
130     uint public maxTotalSupply;
131     uint public totalInitialSupply;
132 
133     struct transferInStruct{
134     uint128 amount;
135     uint64 time;
136     }
137 
138     mapping(address => uint256) balances;
139     mapping(address => mapping (address => uint256)) allowed;
140     mapping(address => transferInStruct[]) transferIns;
141 
142     event Burn(address indexed burner, uint256 value);
143 
144     /**
145      * @dev Fix for the ERC20 short address attack.
146      */
147     modifier onlyPayloadSize(uint size) {
148         require(msg.data.length >= size + 4);
149         _;
150     }
151     modifier canPoSMint() {
152         require(totalSupply < maxTotalSupply);
153         _;
154     }
155 
156 
157     
158 
159     function TerraFirma() public { 
160         maxTotalSupply = 80000000000000000; // 800 Mil.
161         totalInitialSupply = 8000000000000000; // 80 Mil.
162 
163         chainStartTime = now;
164         chainStartBlockNumber = block.number;
165 
166         balances[msg.sender] = totalInitialSupply;
167         totalSupply = totalInitialSupply;
168     }
169 
170     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
171         if(msg.sender == _to) return mint();
172         balances[msg.sender] = balances[msg.sender].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         Transfer(msg.sender, _to, _value);
175         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
176         uint64 _now = uint64(now);
177         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
178         transferIns[_to].push(transferInStruct(uint128(_value),_now));
179         return true;
180     }
181 
182     function balanceOf(address _owner) public constant returns (uint256 balance) {
183         return balances[_owner];
184     }
185 
186     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
187         require(_to != address(0));
188 
189         var _allowance = allowed[_from][msg.sender];
190 
191         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
192         // require (_value <= _allowance);
193 
194         balances[_from] = balances[_from].sub(_value);
195         balances[_to] = balances[_to].add(_value);
196         allowed[_from][msg.sender] = _allowance.sub(_value);
197         Transfer(_from, _to, _value);
198         if(transferIns[_from].length > 0) delete transferIns[_from];
199         uint64 _now = uint64(now);
200         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
201         transferIns[_to].push(transferInStruct(uint128(_value),_now));
202         return true;
203     }
204 
205     function approve(address _spender, uint256 _value) public returns (bool) {
206         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
207 
208         allowed[msg.sender][_spender] = _value;
209         Approval(msg.sender, _spender, _value);
210         return true;
211     }
212 
213     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
214         return allowed[_owner][_spender];
215     }
216 
217     function mint() canPoSMint public returns (bool) {
218         if(balances[msg.sender] <= 0) return false;
219         if(transferIns[msg.sender].length <= 0) return false;
220 
221         uint reward = getProofOfStakeReward(msg.sender);
222         if(reward <= 0) return false;
223 
224         totalSupply = totalSupply.add(reward);
225         balances[msg.sender] = balances[msg.sender].add(reward);
226         delete transferIns[msg.sender];
227         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
228 
229         Mint(msg.sender, reward);
230         return true;
231     }
232 
233     function getBlockNumber() public returns (uint blockNumber) {
234         blockNumber = block.number.sub(chainStartBlockNumber);
235     }
236 
237     function coinAge() public constant returns (uint myCoinAge) {
238         myCoinAge = getCoinAge(msg.sender,now);
239     }
240 
241     function annualInterest() public constant returns(uint interest) {
242         uint _now = now;
243         interest = maxMintProofOfStake;
244         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
245             interest = (770 * maxMintProofOfStake).div(100);
246         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
247             interest = (435 * maxMintProofOfStake).div(100);
248         }
249     }
250 
251     function getProofOfStakeReward(address _address) internal returns (uint) {
252         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
253 
254         uint _now = now;
255         uint _coinAge = getCoinAge(_address, _now);
256         if(_coinAge <= 0) return 0;
257 
258         uint interest = maxMintProofOfStake;
259         // Due to the high interest rate for the first two years, compounding should be taken into account.
260         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
261         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
262             // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
263             interest = (770 * maxMintProofOfStake).div(100);
264         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
265             // 2nd year effective annual interest rate is 50%
266             interest = (435 * maxMintProofOfStake).div(100);
267         }
268 
269         return (_coinAge * interest).div(365 * (10**decimals));
270     }
271 
272     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
273         if(transferIns[_address].length <= 0) return 0;
274 
275         for (uint i = 0; i < transferIns[_address].length; i++){
276             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
277 
278             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
279             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
280 
281             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
282         }
283     }
284 
285     function ownerSetStakeStartTime(uint timestamp) public onlyOwner {
286         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
287         stakeStartTime = timestamp;
288     }
289 
290     function ownerBurnToken(uint _value) public onlyOwner {
291         require(_value > 0);
292 
293         balances[msg.sender] = balances[msg.sender].sub(_value);
294         delete transferIns[msg.sender];
295         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
296 
297         totalSupply = totalSupply.sub(_value);
298         totalInitialSupply = totalInitialSupply.sub(_value);
299         maxTotalSupply = maxTotalSupply.sub(_value*10);
300         
301 
302         Burn(msg.sender, _value);
303     }
304 
305     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
306     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner public returns (bool) {
307         require( _recipients.length > 0 && _recipients.length == _values.length);
308 
309         uint total = 0;
310         for(uint i = 0; i < _values.length; i++){
311             total = total.add(_values[i]);
312         }
313         require(total <= balances[msg.sender]);
314 
315         uint64 _now = uint64(now);
316         for(uint j = 0; j < _recipients.length; j++){
317             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
318             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
319             Transfer(msg.sender, _recipients[j], _values[j]);
320         }
321 
322         balances[msg.sender] = balances[msg.sender].sub(total);
323         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
324         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
325 
326         return true;
327     }
328 }