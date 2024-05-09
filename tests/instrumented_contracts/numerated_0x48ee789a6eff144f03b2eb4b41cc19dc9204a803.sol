1 pragma solidity ^0.4.16;
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
114 contract Diyflex is ERC20, PoSTokenStandard, Ownable {
115     using SafeMath for uint256;
116 
117     string public name = "Diyflex";
118     string public symbol = "DFX";
119     uint public decimals = 18;
120 
121     uint public chainStartTime; // chain start time
122     uint public chainStartBlockNumber; // chain start block number
123     uint public stakeStartTime; // stake start time
124     uint public stakeMinAge = 10 days; // minimum age for coin age: 3D
125     uint public stakeMaxAge = 30 days; // stake age of full weight: 90D
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
141     event Burn(address indexed burner, uint256 value);
142 
143     /**
144      * @dev Fix for the ERC20 short address attack.
145      */
146     modifier onlyPayloadSize(uint size) {
147         require(msg.data.length >= size + 4);
148         _;
149     }
150 
151     modifier canPoSMint() {
152         require(totalSupply < maxTotalSupply);
153         _;
154     }
155 
156     function Diyflex() {
157         maxTotalSupply = 70*10**25; // 700 Mil.
158         totalInitialSupply = 50*10**25; // 500 Mil.
159 
160         chainStartTime = now;
161         chainStartBlockNumber = block.number;
162 
163         balances[msg.sender] = totalInitialSupply;
164         totalSupply = totalInitialSupply;
165     }
166 
167     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
168         if(msg.sender == _to) return mint();
169         balances[msg.sender] = balances[msg.sender].sub(_value);
170         balances[_to] = balances[_to].add(_value);
171         Transfer(msg.sender, _to, _value);
172         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
173         uint64 _now = uint64(now);
174         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
175         transferIns[_to].push(transferInStruct(uint128(_value),_now));
176         return true;
177     }
178 
179     function balanceOf(address _owner) constant returns (uint256 balance) {
180         return balances[_owner];
181     }
182 
183     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
184         require(_to != address(0));
185 
186         var _allowance = allowed[_from][msg.sender];
187 
188         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
189         // require (_value <= _allowance);
190 
191         balances[_from] = balances[_from].sub(_value);
192         balances[_to] = balances[_to].add(_value);
193         allowed[_from][msg.sender] = _allowance.sub(_value);
194         Transfer(_from, _to, _value);
195         if(transferIns[_from].length > 0) delete transferIns[_from];
196         uint64 _now = uint64(now);
197         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
198         transferIns[_to].push(transferInStruct(uint128(_value),_now));
199         return true;
200     }
201 
202     function approve(address _spender, uint256 _value) returns (bool) {
203         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
204 
205         allowed[msg.sender][_spender] = _value;
206         Approval(msg.sender, _spender, _value);
207         return true;
208     }
209 
210     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
211         return allowed[_owner][_spender];
212     }
213 
214     function mint() canPoSMint returns (bool) {
215         if(balances[msg.sender] <= 0) return false;
216         if(transferIns[msg.sender].length <= 0) return false;
217 
218         uint reward = getProofOfStakeReward(msg.sender);
219         if(reward <= 0) return false;
220 
221         totalSupply = totalSupply.add(reward);
222         balances[msg.sender] = balances[msg.sender].add(reward);
223         delete transferIns[msg.sender];
224         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
225 
226         Mint(msg.sender, reward);
227         return true;
228     }
229 
230     function getBlockNumber() returns (uint blockNumber) {
231         blockNumber = block.number.sub(chainStartBlockNumber);
232     }
233 
234     function coinAge() constant returns (uint myCoinAge) {
235         myCoinAge = getCoinAge(msg.sender,now);
236     }
237 
238     function annualInterest() constant returns(uint interest) {
239         interest = maxMintProofOfStake;
240     }
241 
242     function getProofOfStakeReward(address _address) internal returns (uint) {
243         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
244 
245         uint _now = now;
246         uint _coinAge = getCoinAge(_address, _now);
247         if(_coinAge <= 0) return 0;
248 
249         uint interest = maxMintProofOfStake;
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