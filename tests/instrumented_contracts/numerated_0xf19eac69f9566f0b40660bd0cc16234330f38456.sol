1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40     address public owner;
41 
42 
43     /**
44      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45      * account.
46      */
47     function Ownable() {
48         owner = msg.sender;
49     }
50 
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60 
61     /**
62      * @dev Allows the current owner to transfer control of the contract to a newOwner.
63      * @param newOwner The address to transfer ownership to.
64      */
65     function transferOwnership(address newOwner) onlyOwner {
66         require(newOwner != address(0));
67         owner = newOwner;
68     }
69 
70 }
71 
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79     uint256 public totalSupply;
80     function balanceOf(address who) constant returns (uint256);
81     function transfer(address to, uint256 value) returns (bool);
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) constant returns (uint256);
92     function transferFrom(address from, address to, uint256 value) returns (bool);
93     function approve(address spender, uint256 value) returns (bool);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 /**
99  * @title CraftRStandard
100  * @dev the interface of CraftRStandard
101  */
102 contract CraftRStandard {
103     uint256 public stakeStartTime;
104     uint256 public stakeMinAge;
105     uint256 public stakeMaxAge;
106     function pos() returns (bool);
107     function coinAge() constant returns (uint256);
108     function annualPos() constant returns (uint256);
109     event Mint(address indexed _address, uint _reward);
110 }
111 
112 
113 contract CraftR is ERC20,CraftRStandard,Ownable {
114     using SafeMath for uint256;
115 
116     string public name = "CraftR";
117     string public symbol = "CRAFTR";
118     uint public decimals = 18;
119 
120     uint public chainStartTime; //chain start time
121     uint public chainStartBlockNumber; //chain start block number
122     uint public stakeStartTime; //stake start time
123     uint public stakeMinAge = 1 days; // minimum age for coin age: 1D
124     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
125     uint public maxMintProofOfStake = 10**17; // default 10% annual interest
126 
127     uint public totalSupply;
128     uint public maxTotalSupply;
129     uint public totalInitialSupply;
130 
131     struct transferInStruct{
132     uint128 amount;
133     uint64 time;
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
155     function CraftR() {
156         maxTotalSupply = 100*10**24; // 100 Mil.
157         totalInitialSupply = 333*10**23; // 33.3 Mil. (30%)
158 
159         chainStartTime = now;
160         chainStartBlockNumber = block.number;
161 
162         balances[msg.sender] = totalInitialSupply;
163         totalSupply = totalInitialSupply;
164     }
165 
166     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
167         if(msg.sender == _to) return pos();
168         balances[msg.sender] = balances[msg.sender].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         Transfer(msg.sender, _to, _value);
171         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
172         uint64 _now = uint64(now);
173         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
174         transferIns[_to].push(transferInStruct(uint128(_value),_now));
175         return true;
176     }
177 
178     function balanceOf(address _owner) constant returns (uint256 balance) {
179         return balances[_owner];
180     }
181 
182     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
183         require(_to != address(0));
184 
185         var _allowance = allowed[_from][msg.sender];
186 
187         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
188         // require (_value <= _allowance);
189 
190         balances[_from] = balances[_from].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192         allowed[_from][msg.sender] = _allowance.sub(_value);
193         Transfer(_from, _to, _value);
194         if(transferIns[_from].length > 0) delete transferIns[_from];
195         uint64 _now = uint64(now);
196         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
197         transferIns[_to].push(transferInStruct(uint128(_value),_now));
198         return true;
199     }
200 
201     function approve(address _spender, uint256 _value) returns (bool) {
202         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
203 
204         allowed[msg.sender][_spender] = _value;
205         Approval(msg.sender, _spender, _value);
206         return true;
207     }
208 
209     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
210         return allowed[_owner][_spender];
211     }
212 
213     function pos() canPoSMint returns (bool) {
214         if(balances[msg.sender] <= 0) return false;
215         if(transferIns[msg.sender].length <= 0) return false;
216 
217         uint reward = getPosReward(msg.sender);
218         if(reward <= 0) return false;
219 
220         totalSupply = totalSupply.add(reward);
221         balances[msg.sender] = balances[msg.sender].add(reward);
222         delete transferIns[msg.sender];
223         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
224 
225         Mint(msg.sender, reward);
226         return true;
227     }
228 
229     function getBlockNumber() returns (uint blockNumber) {
230         blockNumber = block.number.sub(chainStartBlockNumber);
231     }
232 
233     function coinAge() constant returns (uint myCoinAge) {
234         myCoinAge = getCoinAge(msg.sender,now);
235     }
236 
237     function annualPos() constant returns(uint interest) {
238         uint _now = now;
239         interest = maxMintProofOfStake;
240         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
241             interest = (770 * maxMintProofOfStake).div(100);
242         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
243             interest = (435 * maxMintProofOfStake).div(100);
244         }
245     }
246 
247     function getPosReward(address _address) internal returns (uint) {
248         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
249 
250         uint _now = now;
251         uint _coinAge = getCoinAge(_address, _now);
252         if(_coinAge <= 0) return 0;
253 
254         uint interest = maxMintProofOfStake;
255         // Due to the high interest rate for the first two years, compounding should be taken into account.
256         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
257         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
258             // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
259             interest = (770 * maxMintProofOfStake).div(100);
260         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
261             // 2nd year effective annual interest rate is 50%
262             interest = (435 * maxMintProofOfStake).div(100);
263         }
264 
265         return (_coinAge * interest).div(365 * (10**decimals));
266     }
267 
268     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
269         if(transferIns[_address].length <= 0) return 0;
270 
271         for (uint i = 0; i < transferIns[_address].length; i++){
272             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
273 
274             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
275             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
276 
277             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
278         }
279     }
280 
281     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
282         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
283         stakeStartTime = timestamp;
284     }
285 
286     function burnToken(uint _value) onlyOwner {
287         require(_value > 0);
288 
289         balances[msg.sender] = balances[msg.sender].sub(_value);
290         delete transferIns[msg.sender];
291         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
292 
293         totalSupply = totalSupply.sub(_value);
294         totalInitialSupply = totalInitialSupply.sub(_value);
295         maxTotalSupply = maxTotalSupply.sub(_value*10);
296 
297         Burn(msg.sender, _value);
298     }
299 
300     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
301     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
302         require( _recipients.length > 0 && _recipients.length == _values.length);
303 
304         uint total = 0;
305         for(uint i = 0; i < _values.length; i++){
306             total = total.add(_values[i]);
307         }
308         require(total <= balances[msg.sender]);
309 
310         uint64 _now = uint64(now);
311         for(uint j = 0; j < _recipients.length; j++){
312             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
313             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
314             Transfer(msg.sender, _recipients[j], _values[j]);
315         }
316 
317         balances[msg.sender] = balances[msg.sender].sub(total);
318         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
319         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
320 
321         return true;
322     }
323 }