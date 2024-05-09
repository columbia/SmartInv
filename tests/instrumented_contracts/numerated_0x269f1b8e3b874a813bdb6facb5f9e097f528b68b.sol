1 pragma solidity ^0.4.18;
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
109     function checkPos() constant returns (uint256);
110     function annualInterest() constant returns (uint256);
111     event Mint(address indexed _address, uint _reward);
112 }
113 
114 
115 contract EthereumUnlimited is ERC20,PoSTokenStandard,Ownable {
116     using SafeMath for uint256;
117 
118     string public name = "Ethereum Unlimited";
119     string public symbol = "ETHU";
120     uint public decimals = 18;
121 
122     uint public chainStartTime; //chain start time
123     uint public chainStartBlockNumber; //chain start block number
124     uint public stakeStartTime; //stake start time
125     uint public stakeMinAge = 1 days; // minimum age for coin age: 1D
126     uint public stakeMaxAge = 365 days; // stake age of full weight: 365D
127     uint public maxMintProofOfStake = 10**17; // default 10% annual interest
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
151 
152     modifier canPoSMint() {
153         require(totalSupply < maxTotalSupply);
154         _;
155     }
156 
157     function EthereumUnlimited() {
158         maxTotalSupply = 2**256-1; // unlimited.
159         totalInitialSupply = 100000000 * 1 ether; // 100 Mil.
160         
161         chainStartTime = now;
162         chainStartBlockNumber = block.number;
163 
164         balances[msg.sender] = totalInitialSupply;
165         totalSupply = totalInitialSupply;
166     }
167 
168     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
169         if(msg.sender == _to) return mint();
170         balances[msg.sender] = balances[msg.sender].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172         Transfer(msg.sender, _to, _value);
173         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
174         uint64 _now = uint64(now);
175         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
176         transferIns[_to].push(transferInStruct(uint128(_value),_now));
177         return true;
178     }
179 
180     function balanceOf(address _owner) constant returns (uint256 balance) {
181         return balances[_owner];
182     }
183 
184     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
185         require(_to != address(0));
186 
187         var _allowance = allowed[_from][msg.sender];
188 
189         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
190         // require (_value <= _allowance);
191 
192         balances[_from] = balances[_from].sub(_value);
193         balances[_to] = balances[_to].add(_value);
194         allowed[_from][msg.sender] = _allowance.sub(_value);
195         Transfer(_from, _to, _value);
196         if(transferIns[_from].length > 0) delete transferIns[_from];
197         uint64 _now = uint64(now);
198         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
199         transferIns[_to].push(transferInStruct(uint128(_value),_now));
200         return true;
201     }
202 
203     function approve(address _spender, uint256 _value) returns (bool) {
204         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
205 
206         allowed[msg.sender][_spender] = _value;
207         Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
212         return allowed[_owner][_spender];
213     }
214 
215     function mint() canPoSMint returns (bool) {
216         if(balances[msg.sender] <= 0) return false;
217         if(transferIns[msg.sender].length <= 0) return false;
218 
219         uint reward = getProofOfStakeReward(msg.sender);
220         if(reward <= 0) return false;
221 
222         totalSupply = totalSupply.add(reward);
223         balances[msg.sender] = balances[msg.sender].add(reward);
224         delete transferIns[msg.sender];
225         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
226 
227         Mint(msg.sender, reward);
228         return true;
229     }
230 
231     function getBlockNumber() returns (uint blockNumber) {
232         blockNumber = block.number.sub(chainStartBlockNumber);
233     }
234 
235     function coinAge() constant returns (uint myCoinAge) {
236         myCoinAge = getCoinAge(msg.sender,now);
237     }
238     
239     function checkPos() constant returns (uint reward) {
240         
241         reward = getProofOfStakeReward(msg.sender);
242         
243     }
244 
245     function annualInterest() constant returns(uint interest) {
246         uint _now = now;
247         interest = maxMintProofOfStake;
248         interest = (4000 * maxMintProofOfStake).div(100);
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
259         //Aannual interest rate is 400%.
260         interest = (4000 * maxMintProofOfStake).div(100);
261         
262         return (_coinAge * interest).div(365 * (10**decimals));
263     }
264 
265     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
266         if(transferIns[_address].length <= 0) return 0;
267 
268         for (uint i = 0; i < transferIns[_address].length; i++){
269             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
270 
271             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
272             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
273 
274             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
275         }
276     }
277 
278     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
279         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
280         stakeStartTime = timestamp;
281     }
282 
283     function ownerBurnToken(uint _value) onlyOwner {
284         require(_value > 0);
285 
286         balances[msg.sender] = balances[msg.sender].sub(_value);
287         delete transferIns[msg.sender];
288         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
289 
290         totalSupply = totalSupply.sub(_value);
291         totalInitialSupply = totalInitialSupply.sub(_value);
292         maxTotalSupply = maxTotalSupply.sub(_value*10);
293 
294         Burn(msg.sender, _value);
295     }
296 
297     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
298     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
299         require( _recipients.length > 0 && _recipients.length == _values.length);
300 
301         uint total = 0;
302         for(uint i = 0; i < _values.length; i++){
303             total = total.add(_values[i]);
304         }
305         require(total <= balances[msg.sender]);
306 
307         uint64 _now = uint64(now);
308         for(uint j = 0; j < _recipients.length; j++){
309             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
310             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
311             Transfer(msg.sender, _recipients[j], _values[j]);
312         }
313 
314         balances[msg.sender] = balances[msg.sender].sub(total);
315         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
316         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
317 
318         return true;
319     }
320 }