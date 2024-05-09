1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32     function Ownable() {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     function transferOwnership(address newOwner) onlyOwner {
42         require(newOwner != address(0));
43         owner = newOwner;
44     }
45 }
46 
47 contract ERC20Basic {
48     uint256 public totalSupply;
49     function balanceOf(address who) constant returns (uint256);
50     function transfer(address to, uint256 value) returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 contract ERC20 is ERC20Basic {
55     function allowance(address owner, address spender) constant returns (uint256);
56     function transferFrom(address from, address to, uint256 value) returns (bool);
57     function approve(address spender, uint256 value) returns (bool);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 contract CookieStandard {
62     uint256 public stakeStartTime;
63     uint256 public stakeMinAge;
64     uint256 public stakeMaxAge;
65     function mint() returns (bool);
66     function coinAge() constant returns (uint256);
67     function annualInterest() constant returns (uint256);
68     event Mint(address indexed _address, uint _reward);
69 }
70 
71 contract Cookie is ERC20, CookieStandard, Ownable {
72     using SafeMath for uint256;
73 
74     string public name = "Cookie";
75     string public symbol = "COOKIE";
76     uint public decimals = 18;
77 
78     uint public chainStartTime;
79     uint public chainStartBlockNumber;
80     uint public stakeStartTime;
81     uint public stakeMinAge = 2 days;
82     uint public stakeMaxAge = 60 days;
83     uint public maxMintCookie = 150000000000000000;
84 
85     uint public totalSupply;
86     uint public maxTotalSupply;
87     uint public totalInitialSupply;
88 
89     struct transferInStruct{
90 	    uint128 amount;
91 	    uint64 time;
92     }
93 
94     mapping(address => uint256) balances;
95     mapping(address => mapping (address => uint256)) allowed;
96     mapping(address => transferInStruct[]) transferIns;
97 
98     event Burn(address indexed burner, uint256 value);
99 
100     modifier onlyPayloadSize(uint size) {
101         require(msg.data.length >= size + 4);
102         _;
103     }
104 
105     modifier canCookieMint() {
106         require(totalSupply < maxTotalSupply);
107         _;
108     }
109 
110     function Cookie() {
111         maxTotalSupply = 12000000000000000000000000; // 12 Million
112         totalInitialSupply = 2000000000000000000000000; // 2 Million
113 
114         chainStartTime = now;
115         chainStartBlockNumber = block.number;
116 
117         balances[msg.sender] = totalInitialSupply;
118         totalSupply = totalInitialSupply;
119     }
120 
121     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
122         if(msg.sender == _to) return mint();
123         balances[msg.sender] = balances[msg.sender].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         Transfer(msg.sender, _to, _value);
126         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
127         uint64 _now = uint64(now);
128         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
129         transferIns[_to].push(transferInStruct(uint128(_value),_now));
130         return true;
131     }
132 
133     function balanceOf(address _owner) constant returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
138         require(_to != address(0));
139 
140         var _allowance = allowed[_from][msg.sender];
141         balances[_from] = balances[_from].sub(_value);
142         balances[_to] = balances[_to].add(_value);
143         allowed[_from][msg.sender] = _allowance.sub(_value);
144         Transfer(_from, _to, _value);
145         if(transferIns[_from].length > 0) delete transferIns[_from];
146         uint64 _now = uint64(now);
147         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
148         transferIns[_to].push(transferInStruct(uint128(_value),_now));
149         return true;
150     }
151 
152     function approve(address _spender, uint256 _value) returns (bool) {
153         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
154 
155         allowed[msg.sender][_spender] = _value;
156         Approval(msg.sender, _spender, _value);
157         return true;
158     }
159 
160     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
161         return allowed[_owner][_spender];
162     }
163 
164     function mint() canCookieMint returns (bool) {
165         if(balances[msg.sender] <= 0) return false;
166         if(transferIns[msg.sender].length <= 0) return false;
167 
168         uint reward = getProofOfStakeReward(msg.sender);
169         if(reward <= 0) return false;
170 
171         totalSupply = totalSupply.add(reward);
172         balances[msg.sender] = balances[msg.sender].add(reward);
173         delete transferIns[msg.sender];
174         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
175 
176         Mint(msg.sender, reward);
177         return true;
178     }
179 
180     function getBlockNumber() returns (uint blockNumber) {
181         blockNumber = block.number.sub(chainStartBlockNumber);
182     }
183 
184     function coinAge() constant returns (uint myCoinAge) {
185         myCoinAge = getCoinAge(msg.sender,now);
186     }
187 
188     function annualInterest() constant returns(uint interest) {
189         uint _now = now;
190         interest = maxMintCookie;
191         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
192             interest = (770 * maxMintCookie).div(100);
193         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
194             interest = (616 * maxMintCookie).div(100);
195         }
196     }
197 
198     function getProofOfStakeReward(address _address) internal returns (uint) {
199         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
200 
201         uint _now = now;
202         uint _coinAge = getCoinAge(_address, _now);
203         if(_coinAge <= 0) return 0;
204 
205         uint interest = maxMintCookie;
206         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
207             interest = (770 * maxMintCookie).div(100);
208         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
209             interest = (616 * maxMintCookie).div(100);
210         }
211         return (_coinAge * interest).div(365 * (10**decimals));
212     }
213 
214     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
215         if(transferIns[_address].length <= 0) return 0;
216 
217         for (uint i = 0; i < transferIns[_address].length; i++){
218             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
219 
220             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
221             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
222 
223             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
224         }
225     }
226 
227     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
228         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
229         stakeStartTime = timestamp;
230     }
231 
232     function ownerBurnToken(uint _value) onlyOwner {
233         require(_value > 0);
234 
235         balances[msg.sender] = balances[msg.sender].sub(_value);
236         delete transferIns[msg.sender];
237         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
238 
239         totalSupply = totalSupply.sub(_value);
240         totalInitialSupply = totalInitialSupply.sub(_value);
241         maxTotalSupply = maxTotalSupply.sub(_value*10);
242 
243         Burn(msg.sender, _value);
244     }
245 
246     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
247         require( _recipients.length > 0 && _recipients.length == _values.length);
248 
249         uint total = 0;
250         for(uint i = 0; i < _values.length; i++){
251             total = total.add(_values[i]);
252         }
253         require(total <= balances[msg.sender]);
254 
255         uint64 _now = uint64(now);
256         for(uint j = 0; j < _recipients.length; j++){
257             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
258             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
259             Transfer(msg.sender, _recipients[j], _values[j]);
260         }
261 
262         balances[msg.sender] = balances[msg.sender].sub(total);
263         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
264         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
265 
266         return true;
267     }
268 }