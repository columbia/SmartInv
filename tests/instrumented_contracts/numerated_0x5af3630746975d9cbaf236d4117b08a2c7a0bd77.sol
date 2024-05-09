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
107     function mint() returns (bool);
108     function coinAge() constant returns (uint256);
109     function annualInterest() constant returns (uint256);
110     event Mint(address indexed _address, uint _reward);
111 }
112 
113 
114 contract COCO is ERC20,PoSTokenStandard,Ownable {
115     using SafeMath for uint256;
116 
117     string public name = "Cookie Coin";
118     string public symbol = "COCO";
119     uint public decimals = 18;
120 
121     uint public chainStartTime; //chain start time
122     uint public chainStartBlockNumber; //chain start block number
123     uint public stakeStartTime; //stake start time
124     uint public stakeMinAge = 3 days; // minimum age for coin age: 3D
125     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
126     uint public maxMintProofOfStake = 50000000000000000; // default 5% annual interest Years 3-15
127 	uint public yearOneMultiplier = 72; //72 times the default 5% (360%)
128 	uint public yearTwoMultiplier = 2; //2 times the default 5% (10%)
129 	
130     uint public totalSupply;
131     uint public maxTotalSupply;
132     uint public totalInitialSupply;
133 
134     struct transferInStruct{
135     uint128 amount;
136     uint64 time;
137     }
138 
139     mapping(address => uint256) balances;
140     mapping(address => mapping (address => uint256)) allowed;
141     mapping(address => transferInStruct[]) transferIns;
142 
143     event Burn(address indexed burner, uint256 value);
144 
145     /**
146      * @dev Fix for the ERC20 short address attack.
147      */
148     modifier onlyPayloadSize(uint size) {
149         require(msg.data.length >= size + 4);
150         _;
151     }
152 
153     modifier canPoSMint() {
154         require(totalSupply < maxTotalSupply);
155         _;
156     }
157 
158     function COCO() {
159         maxTotalSupply = 32200000000000000000000000; // 32.2 Mil.
160         totalInitialSupply = 3200000000000000000000000; // 3.2 Mil.
161 
162         chainStartTime = now;
163         chainStartBlockNumber = block.number;
164 
165         balances[msg.sender] = totalInitialSupply;
166         totalSupply = totalInitialSupply;
167     }
168 
169     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
170         if(msg.sender == _to) return mint();
171         balances[msg.sender] = balances[msg.sender].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         Transfer(msg.sender, _to, _value);
174         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
175         uint64 _now = uint64(now);
176         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
177         transferIns[_to].push(transferInStruct(uint128(_value),_now));
178         return true;
179     }
180 
181     function balanceOf(address _owner) constant returns (uint256 balance) {
182         return balances[_owner];
183     }
184 
185     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
186         require(_to != address(0));
187 
188         var _allowance = allowed[_from][msg.sender];
189 
190         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
191         // require (_value <= _allowance);
192 
193         balances[_from] = balances[_from].sub(_value);
194         balances[_to] = balances[_to].add(_value);
195         allowed[_from][msg.sender] = _allowance.sub(_value);
196         Transfer(_from, _to, _value);
197         if(transferIns[_from].length > 0) delete transferIns[_from];
198         uint64 _now = uint64(now);
199         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
200         transferIns[_to].push(transferInStruct(uint128(_value),_now));
201         return true;
202     }
203 
204     function approve(address _spender, uint256 _value) returns (bool) {
205         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
206 
207         allowed[msg.sender][_spender] = _value;
208         Approval(msg.sender, _spender, _value);
209         return true;
210     }
211 
212     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
213         return allowed[_owner][_spender];
214     }
215 
216     function mint() canPoSMint returns (bool) {
217         if(balances[msg.sender] <= 0) return false;
218         if(transferIns[msg.sender].length <= 0) return false;
219 
220         uint reward = getProofOfStakeReward(msg.sender);
221         if(reward <= 0) return false;
222 
223         totalSupply = totalSupply.add(reward);
224         balances[msg.sender] = balances[msg.sender].add(reward);
225         delete transferIns[msg.sender];
226         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
227 
228         Mint(msg.sender, reward);
229         return true;
230     }
231 
232     function getBlockNumber() returns (uint blockNumber) {
233         blockNumber = block.number.sub(chainStartBlockNumber);
234     }
235 
236     function coinAge() constant returns (uint myCoinAge) {
237         myCoinAge = getCoinAge(msg.sender,now);
238     }
239 	
240 	//Interest Check Function
241 
242     function annualInterest() constant returns(uint interest) {
243         uint _now = now;
244         interest = maxMintProofOfStake;
245         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
246             interest = maxMintProofOfStake * yearOneMultiplier;
247         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
248             interest = maxMintProofOfStake * yearTwoMultiplier;
249         }
250     }
251 
252     function getProofOfStakeReward(address _address) internal returns (uint) {
253         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
254 
255         uint _now = now;
256         uint _coinAge = getCoinAge(_address, _now);
257         if(_coinAge <= 0) return 0;
258 
259         uint interest = maxMintProofOfStake;
260         // Due to the high interest rate for the first two years, compounding should be taken into account.
261         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
262         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
263             // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
264             interest = maxMintProofOfStake * yearOneMultiplier;
265         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
266             // 2nd year effective annual interest rate is 50%
267             interest = maxMintProofOfStake * yearTwoMultiplier;
268         }
269 
270         return (_coinAge * interest).div(365 * (10**decimals));
271     }
272 
273     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
274         if(transferIns[_address].length <= 0) return 0;
275 
276         for (uint i = 0; i < transferIns[_address].length; i++){
277             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
278 
279             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
280             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
281 
282             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
283         }
284     }
285 
286     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
287         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
288         stakeStartTime = timestamp;
289     }
290 
291     function ownerBurnToken(uint _value) onlyOwner {
292         require(_value > 0);
293 
294         balances[msg.sender] = balances[msg.sender].sub(_value);
295         delete transferIns[msg.sender];
296         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
297 
298         totalSupply = totalSupply.sub(_value);
299         totalInitialSupply = totalInitialSupply.sub(_value);
300         maxTotalSupply = maxTotalSupply.sub(_value*10);
301 
302         Burn(msg.sender, _value);
303     }
304 
305     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
306     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
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
328 	
329 	function setBaseInterest(uint amount) onlyOwner{
330 		maxMintProofOfStake = amount;
331 	}
332 	
333 	function setYearOneMultiplier (uint amount) onlyOwner{
334 		yearOneMultiplier = amount;
335 	}
336 	
337 	function setYearTwoMultiplier (uint amount) onlyOwner{
338 		yearTwoMultiplier = amount;
339 	}
340 }