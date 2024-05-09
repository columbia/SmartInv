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
99 
100 contract CommunityToken {
101     uint256 public stakeStartTime;
102     uint256 public stakeMinAge;
103     uint256 public stakeMaxAge;
104     function mint() returns (bool);
105     function coinAge() constant returns (uint256);
106     function annualInterest() constant returns (uint256);
107     event Mint(address indexed _address, uint _reward);
108 }
109 
110 
111 contract Community is ERC20,CommunityToken,Ownable {
112     using SafeMath for uint256;
113 
114     string public name = "Community Token";
115     string public symbol = "COM";
116     uint public decimals = 18;
117 
118     uint public chainStartTime; 
119     uint public chainStartBlockNumber; 
120     uint public stakeStartTime; 
121     uint public stakeMinAge = 3 days; 
122     uint public stakeMaxAge = 90 days; 
123     uint public maxMintProofOfStake = 10**17; 
124 
125     uint public totalSupply;
126     uint public maxTotalSupply;
127     uint public totalInitialSupply;
128 
129     struct transferInStruct{
130     uint128 amount;
131     uint64 time;
132     }
133 
134     mapping(address => uint256) balances;
135     mapping(address => mapping (address => uint256)) allowed;
136     mapping(address => transferInStruct[]) transferIns;
137 
138     event Burn(address indexed burner, uint256 value);
139 
140     /**
141      * @dev Fix for the ERC20 short address attack.
142      */
143     modifier onlyPayloadSize(uint size) {
144         require(msg.data.length >= size + 4);
145         _;
146     }
147 
148     modifier canPoSMint() {
149         require(totalSupply < maxTotalSupply);
150         _;
151     }
152 
153     function Community() {
154         maxTotalSupply = 10000000000000000000000000000; 
155         totalInitialSupply = 2000000000000000000000000000; 
156 
157         chainStartTime = now;
158         chainStartBlockNumber = block.number;
159 
160         balances[msg.sender] = totalInitialSupply;
161         totalSupply = totalInitialSupply;
162     }
163 
164     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
165         if(msg.sender == _to) return mint();
166         balances[msg.sender] = balances[msg.sender].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168         Transfer(msg.sender, _to, _value);
169         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
170         uint64 _now = uint64(now);
171         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
172         transferIns[_to].push(transferInStruct(uint128(_value),_now));
173         return true;
174     }
175 
176     function balanceOf(address _owner) constant returns (uint256 balance) {
177         return balances[_owner];
178     }
179 
180     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
181         require(_to != address(0));
182 
183         var _allowance = allowed[_from][msg.sender];
184 
185         
186 
187         balances[_from] = balances[_from].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189         allowed[_from][msg.sender] = _allowance.sub(_value);
190         Transfer(_from, _to, _value);
191         if(transferIns[_from].length > 0) delete transferIns[_from];
192         uint64 _now = uint64(now);
193         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
194         transferIns[_to].push(transferInStruct(uint128(_value),_now));
195         return true;
196     }
197 
198     function approve(address _spender, uint256 _value) returns (bool) {
199         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
200 
201         allowed[msg.sender][_spender] = _value;
202         Approval(msg.sender, _spender, _value);
203         return true;
204     }
205 
206     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
207         return allowed[_owner][_spender];
208     }
209 
210     function mint() canPoSMint returns (bool) {
211         if(balances[msg.sender] <= 0) return false;
212         if(transferIns[msg.sender].length <= 0) return false;
213 
214         uint reward = getProofOfStakeReward(msg.sender);
215         if(reward <= 0) return false;
216 
217         totalSupply = totalSupply.add(reward);
218         balances[msg.sender] = balances[msg.sender].add(reward);
219         delete transferIns[msg.sender];
220         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
221 
222         Mint(msg.sender, reward);
223         return true;
224     }
225 
226     function getBlockNumber() returns (uint blockNumber) {
227         blockNumber = block.number.sub(chainStartBlockNumber);
228     }
229 
230     function coinAge() constant returns (uint myCoinAge) {
231         myCoinAge = getCoinAge(msg.sender,now);
232     }
233 
234     function annualInterest() constant returns(uint interest) {
235         uint _now = now;
236         interest = maxMintProofOfStake;
237         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
238             interest = (770 * maxMintProofOfStake).div(100);
239         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
240             interest = (435 * maxMintProofOfStake).div(100);
241         }
242     }
243 
244     function getProofOfStakeReward(address _address) internal returns (uint) {
245         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
246 
247         uint _now = now;
248         uint _coinAge = getCoinAge(_address, _now);
249         if(_coinAge <= 0) return 0;
250 
251         uint interest = maxMintProofOfStake;
252         
253         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
254             
255             interest = (770 * maxMintProofOfStake).div(100);
256         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
257             
258             interest = (435 * maxMintProofOfStake).div(100);
259         }
260 
261         return (_coinAge * interest).div(365 * (10**decimals));
262     }
263 
264     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
265         if(transferIns[_address].length <= 0) return 0;
266 
267         for (uint i = 0; i < transferIns[_address].length; i++){
268             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
269 
270             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
271             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
272 
273             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
274         }
275     }
276 
277     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
278         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
279         stakeStartTime = timestamp;
280     }
281 
282     function ownerBurnToken(uint _value) onlyOwner {
283         require(_value > 0);
284 
285         balances[msg.sender] = balances[msg.sender].sub(_value);
286         delete transferIns[msg.sender];
287         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
288 
289         totalSupply = totalSupply.sub(_value);
290         totalInitialSupply = totalInitialSupply.sub(_value);
291         maxTotalSupply = maxTotalSupply.sub(_value*10);
292 
293         Burn(msg.sender, _value);
294     }
295 
296     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
297         require( _recipients.length > 0 && _recipients.length == _values.length);
298 
299         uint total = 0;
300         for(uint i = 0; i < _values.length; i++){
301             total = total.add(_values[i]);
302         }
303         require(total <= balances[msg.sender]);
304 
305         uint64 _now = uint64(now);
306         for(uint j = 0; j < _recipients.length; j++){
307             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
308             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
309             Transfer(msg.sender, _recipients[j], _values[j]);
310         }
311 
312         balances[msg.sender] = balances[msg.sender].sub(total);
313         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
314         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
315 
316         return true;
317     }
318 }