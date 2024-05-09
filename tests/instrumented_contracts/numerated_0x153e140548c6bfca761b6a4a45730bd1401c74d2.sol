1 pragma solidity ^0.4.11;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 
31 
32 contract Ownable {
33     address public owner;
34 
35 
36     function Ownable() public {
37         owner = msg.sender;
38     }
39 
40 
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46 
47     function transferOwnership(address newOwner) public onlyOwner {
48         require(newOwner != address(0));
49         owner = newOwner;
50     }
51 
52 }
53 
54 
55 
56 contract ERC20Basic {
57     uint256 public totalSupply;
58     function balanceOf(address who) public view returns (uint256);
59     function transfer(address to, uint256 value) public returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 contract ERC20 is ERC20Basic {
65     function allowance(address owner, address spender) public view returns (uint256);
66     function transferFrom(address from, address to, uint256 value) public returns (bool);
67     function approve(address spender, uint256 value) public returns (bool);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 
72 contract TIPbotRegulation {
73     uint256 public stakeStartTime;
74     uint256 public stakeMinAge;
75     uint256 public stakeMaxAge;
76     function mint() public returns (bool);
77     function coinAge() public payable returns (uint256);
78     function annualInterest() public view returns (uint256);
79     event Mint(address indexed _address, uint _reward);
80 }
81 
82 
83 contract TIPToken is ERC20,TIPbotRegulation,Ownable {
84     using SafeMath for uint256;
85 
86     string public name = "TIPbot";
87     string public symbol = "TIP";
88     uint public decimals = 18;
89 
90     uint public chainStartTime; //chain start time
91     uint public chainStartBlockNumber; //chain start block number
92     uint public stakeStartTime; //stake start time
93     uint public stakeMinAge = 3 days; // minimum age for coin age: 3D
94     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
95     uint public maxMintProofOfStake = 10**17; // default 10% annual interest
96 
97     uint public totalSupply;
98     uint public maxTotalSupply;
99     uint public totalInitialSupply;
100 
101     struct transferInStruct{
102     uint256 amount;
103     uint64 time;
104     }
105 
106     mapping(address => uint256) balances;
107     mapping(address => mapping (address => uint256)) allowed;
108     mapping(address => transferInStruct[]) transferIns;
109 
110     event Burn(address indexed burner, uint256 value);
111 
112     /**
113      * @dev Fix for the ERC20 short address attack.
114      */
115     modifier onlyPayloadSize(uint size) {
116         require(msg.data.length >= size + 4);
117         _;
118     }
119 
120     modifier canTIPMint() {
121         require(totalSupply < maxTotalSupply);
122         _;
123     }
124 
125     function TIPToken() public {
126         maxTotalSupply = 10000000000000000000000000000000; // 10 Trillion.
127         totalInitialSupply = 100000000000000000000000000000; // 100 Billion.
128 
129         chainStartTime = now;
130         chainStartBlockNumber = block.number;
131 
132         balances[msg.sender] = totalInitialSupply;
133         totalSupply = totalInitialSupply;
134     }
135 
136     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
137         if(msg.sender == _to) return mint();
138         balances[msg.sender] = balances[msg.sender].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         Transfer(msg.sender, _to, _value);
141         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
142         uint64 _now = uint64(now);
143         transferIns[msg.sender].push(transferInStruct(uint256(balances[msg.sender]),_now));
144         transferIns[_to].push(transferInStruct(uint256(_value),_now));
145         return true;
146     }
147 
148     function balanceOf(address _owner) public view returns (uint256 balance) {
149         return balances[_owner];
150     }
151 
152     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
153         require(_to != address(0));
154 
155         var _allowance = allowed[_from][msg.sender];
156 
157         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
158         // require (_value <= _allowance);
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = _allowance.sub(_value);
163         Transfer(_from, _to, _value);
164         if(transferIns[_from].length > 0) delete transferIns[_from];
165         uint64 _now = uint64(now);
166         transferIns[_from].push(transferInStruct(uint256(balances[_from]),_now));
167         transferIns[_to].push(transferInStruct(uint256(_value),_now));
168         return true;
169     }
170 
171     function approve(address _spender, uint256 _value) public returns (bool) {
172         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
173 
174         allowed[msg.sender][_spender] = _value;
175         Approval(msg.sender, _spender, _value);
176         return true;
177     }
178 
179     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
180         return allowed[_owner][_spender];
181     }
182 
183     function mint() public canTIPMint returns (bool) {
184         if(balances[msg.sender] <= 0) return false;
185         if(transferIns[msg.sender].length <= 0) return false;
186 
187         uint reward = getProofOfStakeReward(msg.sender);
188         if(reward <= 0) return false;
189 
190         totalSupply = totalSupply.add(reward);
191         balances[msg.sender] = balances[msg.sender].add(reward);
192         delete transferIns[msg.sender];
193         transferIns[msg.sender].push(transferInStruct(uint256(balances[msg.sender]),uint64(now)));
194 
195         Mint(msg.sender, reward);
196         return true;
197     }
198 
199     function getBlockNumber() public view returns (uint blockNumber) {
200         blockNumber = block.number.sub(chainStartBlockNumber);
201     }
202 
203     function coinAge() public payable returns (uint myCoinAge) {
204         myCoinAge = getCoinAge(msg.sender,now);
205     }
206 
207     function annualInterest() public view returns(uint interest) {
208         uint _now = now;
209         interest = maxMintProofOfStake;
210         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
211             interest = (770 * maxMintProofOfStake).div(100);
212         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
213             interest = (435 * maxMintProofOfStake).div(100);
214         }
215     }
216 
217     function getProofOfStakeReward(address _address) internal view returns (uint) {
218         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
219 
220         uint _now = now;
221         uint _coinAge = getCoinAge(_address, _now);
222         if(_coinAge <= 0) return 0;
223 
224         uint interest = maxMintProofOfStake;
225         // Due to the high interest rate for the first two years, compounding should be taken into account.
226         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
227         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
228             // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
229             interest = (770 * maxMintProofOfStake).div(100);
230         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
231             // 2nd year effective annual interest rate is 50%
232             interest = (435 * maxMintProofOfStake).div(100);
233         }
234 
235         return (_coinAge * interest).div(365 * (10**decimals));
236     }
237 
238     function getCoinAge(address _address, uint _now) internal view returns (uint _coinAge) {
239         if(transferIns[_address].length <= 0) return 0;
240 
241         for (uint i = 0; i < transferIns[_address].length; i++){
242             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
243 
244             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
245             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
246 
247             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
248         }
249     }
250 
251     function ownerSetStakeStartTime(uint timestamp) public onlyOwner {
252         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
253         stakeStartTime = timestamp;
254     }
255 
256     function ownerBurnToken(uint _value) public onlyOwner {
257         require(_value > 0);
258 
259         balances[msg.sender] = balances[msg.sender].sub(_value);
260         delete transferIns[msg.sender];
261         transferIns[msg.sender].push(transferInStruct(uint256(balances[msg.sender]),uint64(now)));
262 
263         totalSupply = totalSupply.sub(_value);
264         totalInitialSupply = totalInitialSupply.sub(_value);
265         maxTotalSupply = maxTotalSupply.sub(_value*10);
266 
267         Burn(msg.sender, _value);
268     }
269 
270    
271     function batchTransfer(address[] _recipients, uint[] _values) public onlyOwner returns (bool) {
272         require( _recipients.length > 0 && _recipients.length == _values.length);
273 
274         uint total = 0;
275         for(uint i = 0; i < _values.length; i++){
276             total = total.add(_values[i]);
277         }
278         require(total <= balances[msg.sender]);
279 
280         uint64 _now = uint64(now);
281         for(uint j = 0; j < _recipients.length; j++){
282             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
283             transferIns[_recipients[j]].push(transferInStruct(uint256(_values[j]),_now));
284             Transfer(msg.sender, _recipients[j], _values[j]);
285         }
286 
287         balances[msg.sender] = balances[msg.sender].sub(total);
288         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
289         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint256(balances[msg.sender]),_now));
290 
291         return true;
292     }
293 }