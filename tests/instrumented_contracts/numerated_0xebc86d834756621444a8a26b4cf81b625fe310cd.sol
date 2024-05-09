1 pragma solidity ^0.4.14;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8  
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11         uint256 c = a * b;
12         assert(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal constant returns (uint256) {
17         uint256 c = a / b;
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
39  
40  
41 contract Ownable {
42     address public owner;
43 
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     function Ownable() {
50         owner = msg.sender;
51     }
52 
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) onlyOwner {
68         require(newOwner != address(0));
69         owner = newOwner;
70     }
71 
72 }
73 
74 
75     /**
76     * @title ERC20Basic
77     * @dev Simpler version of ERC20 interface
78     * * @dev see https://github.com/ethereum/EIPs/issues/179
79     */
80 contract ERC20Basic {
81     uint256 public totalSupply;
82     
83  /**
84   * @dev Gets the balance of the specified address.
85  */
86   
87     function balanceOf(address who) constant returns (uint256);
88     function transfer(address to, uint256 value) returns (bool);
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 }
91 
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98     function allowance(address owner, address spender) constant returns (uint256);
99     function transferFrom(address from, address to, uint256 value) returns (bool);
100     function approve(address spender, uint256 value) returns (bool);
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 /**
106  * @title PoSTokenStandard
107  * @dev the interface of PoSTokenStandard
108  */
109 contract PoSTokenStandard {
110     uint256 public stakeStartTime;
111     uint256 public stakeMinAge;
112     uint256 public stakeMaxAge;
113     function mint() returns (bool);
114     function coinAge() constant returns (uint256);
115     function annualInterest() constant returns (uint256);
116     event Mint(address indexed _address, uint _reward);
117 }
118 
119 
120 contract EtherPower is ERC20,PoSTokenStandard,Ownable {
121     using SafeMath for uint256;
122 
123     string public name = "EtherPower";
124     string public symbol = "ETHP";
125     uint public decimals = 18;
126 
127     uint public chainStartTime; //chain start time
128     uint public chainStartBlockNumber; //chain start block number
129     uint public stakeStartTime; //stake start time
130     uint public stakeMinAge = 2 days; // minimum age for coin age: 2D
131     uint public stakeMaxAge = 45 days; // stake age of full weight: 45D
132     uint public maxMintProofOfStake = 10**18;
133 
134     uint public totalSupply;
135     uint public maxTotalSupply;
136     uint public totalInitialSupply;
137 
138     struct transferInStruct{
139     uint128 amount;
140     uint64 time;
141     }
142 
143     mapping(address => uint256) balances;
144     mapping(address => mapping (address => uint256)) allowed;
145     mapping(address => transferInStruct[]) transferIns;
146 
147     event Burn(address indexed burner, uint256 value);
148 
149     /**
150      * @dev Fix for the ERC20 short address attack.
151      */
152     modifier onlyPayloadSize(uint size) {
153         require(msg.data.length >= size + 4);
154         _;
155     }
156 
157     modifier canPoSMint() {
158         require(totalSupply < maxTotalSupply);
159         _;
160     }
161 
162     function EtherPower() {
163         maxTotalSupply = 2**256-1; // Unlimited
164         totalInitialSupply = 10**24; // 1 Mil.
165 
166         chainStartTime = now;
167         chainStartBlockNumber = block.number;
168 
169         balances[msg.sender] = totalInitialSupply;
170         totalSupply = totalInitialSupply;
171     }
172 
173     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
174         if(msg.sender == _to) return mint();
175         balances[msg.sender] = balances[msg.sender].sub(_value);
176         balances[_to] = balances[_to].add(_value);
177         Transfer(msg.sender, _to, _value);
178         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
179         uint64 _now = uint64(now);
180         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
181         transferIns[_to].push(transferInStruct(uint128(_value),_now));
182         return true;
183     }
184 
185     function balanceOf(address _owner) constant returns (uint256 balance) {
186         return balances[_owner];
187     }
188 
189     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
190         require(_to != address(0));
191 
192         var _allowance = allowed[_from][msg.sender];
193 
194         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
195         // require (_value <= _allowance);
196 
197         balances[_from] = balances[_from].sub(_value);
198         balances[_to] = balances[_to].add(_value);
199         allowed[_from][msg.sender] = _allowance.sub(_value);
200         Transfer(_from, _to, _value);
201         if(transferIns[_from].length > 0) delete transferIns[_from];
202         uint64 _now = uint64(now);
203         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
204         transferIns[_to].push(transferInStruct(uint128(_value),_now));
205         return true;
206     }
207 
208     function approve(address _spender, uint256 _value) returns (bool) {
209         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
210 
211         allowed[msg.sender][_spender] = _value;
212         Approval(msg.sender, _spender, _value);
213         return true;
214     }
215 
216     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
217         return allowed[_owner][_spender];
218     }
219 
220     function mint() canPoSMint returns (bool) {
221         if(balances[msg.sender] <= 0) return false;
222         if(transferIns[msg.sender].length <= 0) return false;
223 
224         uint reward = getProofOfStakeReward(msg.sender);
225         if(reward <= 0) return false;
226 
227         totalSupply = totalSupply.add(reward);
228         balances[msg.sender] = balances[msg.sender].add(reward);
229         delete transferIns[msg.sender];
230         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
231 
232         Mint(msg.sender, reward);
233         return true;
234     }
235     
236     
237     function getBlockNumber() returns (uint blockNumber) {
238         blockNumber = block.number.sub(chainStartBlockNumber);
239     }
240 
241     function coinAge() constant returns (uint myCoinAge) {
242         myCoinAge = getCoinAge(msg.sender,now);
243     }
244 
245     function annualInterest() constant returns(uint interest) {
246         uint _now = now;
247         interest = maxMintProofOfStake;
248         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
249             interest = (25 * maxMintProofOfStake).div(100);
250         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
251             interest = (50 * maxMintProofOfStake).div(100);
252         }
253         
254     }
255 
256     function getProofOfStakeReward(address _address) internal returns (uint) {
257         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
258 
259         uint _now = now;
260         uint _coinAge = getCoinAge(_address, _now);
261         if(_coinAge <= 0) return 0;
262         uint interest = maxMintProofOfStake;
263         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
264             interest = (25 * maxMintProofOfStake).div(100);
265         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
266             interest = (50 * maxMintProofOfStake).div(100);
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
285     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
286         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
287         stakeStartTime = timestamp;
288     }
289 
290     function ownerBurnToken(uint _value) onlyOwner {
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
301         Burn(msg.sender, _value);
302     }
303 
304     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
305     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
306         require( _recipients.length > 0 && _recipients.length == _values.length);
307 
308         uint total = 0;
309         for(uint i = 0; i < _values.length; i++){
310             total = total.add(_values[i]);
311         }
312         require(total <= balances[msg.sender]);
313 
314         uint64 _now = uint64(now);
315         for(uint j = 0; j < _recipients.length; j++){
316             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
317             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
318             Transfer(msg.sender, _recipients[j], _values[j]);
319         }
320 
321         balances[msg.sender] = balances[msg.sender].sub(total);
322         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
323         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
324 
325         return true;
326     }
327 }