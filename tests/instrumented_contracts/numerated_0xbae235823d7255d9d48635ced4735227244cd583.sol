1 pragma solidity 0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38     address public owner;
39 
40     /**
41      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42      * account.
43      */
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48     /**
49      * @dev Throws if called by any account other than the owner.
50      */
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) onlyOwner public {
61         require(newOwner != address(0));
62         owner = newOwner;
63     }
64 
65 }
66 
67 /**
68  * @title ERC20Basic
69  * @dev Simpler version of ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/179
71  */
72 contract ERC20Basic {
73     uint256 public totalSupply;
74     function balanceOf(address who) public view returns (uint256);
75     function transfer(address to, uint256 value) public returns (bool);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84     function allowance(address owner, address spender) public view returns (uint256);
85     function transferFrom(address from, address to, uint256 value) public returns (bool);
86     function approve(address spender, uint256 value) public returns (bool);
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 contract StakerToken {
91     uint256 public stakeStartTime;
92     uint256 public stakeMinAge;
93     uint256 public stakeMaxAge;
94     function mint() public returns (bool);
95     function coinAge() public view returns (uint256);
96     function annualInterest() public view returns (uint256);
97     event Mint(address indexed _address, uint _reward);
98 }
99 
100 contract Staker is ERC20,StakerToken,Ownable {
101     using SafeMath for uint256;
102 
103     string public name = "Staker";
104     string public symbol = "STR";
105     uint public decimals = 18;
106 
107     uint public chainStartTime;
108     uint public chainStartBlockNumber;
109     uint public stakeStartTime;
110     uint public stakeMinAge = 3 days;
111     uint public stakeMaxAge = 90 days;
112     uint public maxMintProofOfStake = 10**17;
113 
114     uint public totalSupply;
115     uint public maxTotalSupply;
116     uint public totalInitialSupply;
117 
118     struct transferInStruct{
119     uint128 amount;
120     uint64 time;
121     }
122 
123     mapping(address => uint256) balances;
124     mapping(address => mapping (address => uint256)) allowed;
125     mapping(address => transferInStruct[]) transferIns;
126 
127     modifier canPoSMint() {
128         require(totalSupply < maxTotalSupply);
129         _;
130     }
131 
132     constructor() public {
133         maxTotalSupply = 7785000000000000000000000;
134         totalInitialSupply = 1785000000000000000000000;
135 
136         chainStartTime = 1524771589; //Original Time
137         chainStartBlockNumber = 5510803; //Original Block
138 
139         balances[msg.sender] = totalInitialSupply;
140         totalSupply = totalInitialSupply;
141     }
142 
143     function transfer(address _to, uint256 _value) public returns (bool) {
144         require(_to != address(0));
145 
146         if(msg.sender == _to) return mint();
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149         emit Transfer(msg.sender, _to, _value);
150         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
151         uint64 _now = uint64(now);
152         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
153         transferIns[_to].push(transferInStruct(uint128(_value),_now));
154         return true;
155     }
156 
157     function balanceOf(address _owner) public view returns (uint256 balance) {
158         return balances[_owner];
159     }
160 
161     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
162         require(_to != address(0));
163 
164         uint256 _allowance = allowed[_from][msg.sender];
165         balances[_from] = balances[_from].sub(_value);
166         balances[_to] = balances[_to].add(_value);
167         allowed[_from][msg.sender] = _allowance.sub(_value);
168         emit Transfer(_from, _to, _value);
169         if(transferIns[_from].length > 0) delete transferIns[_from];
170         uint64 _now = uint64(now);
171         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
172         transferIns[_to].push(transferInStruct(uint128(_value),_now));
173         return true;
174     }
175 
176     function approve(address _spender, uint256 _value) public returns (bool) {
177         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
178 
179         allowed[msg.sender][_spender] = _value;
180         emit Approval(msg.sender, _spender, _value);
181         return true;
182     }
183 
184     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
185         return allowed[_owner][_spender];
186     }
187 
188     function mint() canPoSMint public returns (bool) {
189         if(balances[msg.sender] <= 0) return false;
190         if(transferIns[msg.sender].length <= 0) return false;
191 
192         uint reward = getProofOfStakeReward(msg.sender);
193         if(reward <= 0) return false;
194 
195         totalSupply = totalSupply.add(reward);
196         balances[msg.sender] = balances[msg.sender].add(reward);
197         delete transferIns[msg.sender];
198         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
199 
200         emit Mint(msg.sender, reward);
201         return true;
202     }
203 
204     function getBlockNumber() public view returns (uint blockNumber) {
205         blockNumber = block.number.sub(chainStartBlockNumber);
206     }
207 
208     function coinAge() public view returns (uint myCoinAge) {
209         myCoinAge = getCoinAge(msg.sender,now);
210     }
211 
212     function annualInterest() public view returns(uint interest) {
213         uint _now = now;
214         interest = maxMintProofOfStake;
215         if((_now.sub(stakeStartTime)).div(365 days) == 0) {
216             interest = (770 * maxMintProofOfStake).div(100);
217         } else if((_now.sub(stakeStartTime)).div(365 days) == 1){
218             interest = (435 * maxMintProofOfStake).div(100);
219         }
220     }
221 
222     function getProofOfStakeReward(address _address) internal view returns (uint) {
223         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
224 
225         uint _now = now;
226         uint _coinAge = getCoinAge(_address, _now);
227         if(_coinAge <= 0) return 0;
228 
229         uint interest = maxMintProofOfStake;
230 
231         if((_now.sub(stakeStartTime)).div(365 days) == 0) {
232 
233             interest = (770 * maxMintProofOfStake).div(100);
234         } else if((_now.sub(stakeStartTime)).div(365 days) == 1){
235 
236             interest = (435 * maxMintProofOfStake).div(100);
237         }
238 
239         return (_coinAge * interest).div(365 * (10**decimals));
240     }
241 
242     function getCoinAge(address _address, uint _now) internal view returns (uint _coinAge) {
243         if(transferIns[_address].length <= 0) return 0;
244 
245         for (uint i = 0; i < transferIns[_address].length; i++){
246             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
247 
248             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
249             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
250 
251             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
252         }
253     }
254 
255     function ownerSetStakeStartTime(uint timestamp) onlyOwner public {
256         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
257         stakeStartTime = timestamp;
258     }
259 
260     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner public returns (bool) {
261         require( _recipients.length > 0 && _recipients.length == _values.length);
262 
263         uint total = 0;
264         for(uint i = 0; i < _values.length; i++){
265             total = total.add(_values[i]);
266         }
267         require(total <= balances[msg.sender]);
268 
269         uint64 _now = uint64(now);
270         for(uint j = 0; j < _recipients.length; j++){
271             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
272             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
273             emit Transfer(msg.sender, _recipients[j], _values[j]);
274         }
275 
276         balances[msg.sender] = balances[msg.sender].sub(total);
277         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
278         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
279 
280         return true;
281     }
282 }