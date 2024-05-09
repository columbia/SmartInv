1 pragma solidity 0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract ERC223 {
35   uint public totalSupply;
36   function balanceOf(address who) constant returns (uint);
37 
38   function name() constant returns (string _name);
39   function symbol() constant returns (string _symbol);
40   function decimals() constant returns (uint8 _decimals);
41   function totalSupply() constant returns (uint256 _supply);
42 
43   function transfer(address to, uint value) returns (bool ok);
44   function transfer(address to, uint value, bytes data) returns (bool ok);
45   event Transfer(address indexed _from, address indexed _to, uint256 _value);
46   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
47 }
48 
49 contract ContractReceiver {
50   function tokenFallback(address _from, uint _value, bytes _data);
51 }
52 
53 /**
54  * @title PoSTokenStandard
55  * @dev the interface of PoSTokenStandard
56  */
57 contract PoSTokenStandard {
58     uint256 public stakeStartTime;
59     uint256 public stakeMinAge;
60     uint256 public stakeMaxAge;
61     function mint() public returns (bool);
62     function coinAge(address staker) public view returns (uint256);
63     function annualInterest() public view returns (uint256);
64     event Mint(address indexed _address, uint _reward);
65 }
66 
67 
68 contract METADOLLAR is ERC223, PoSTokenStandard {
69     using SafeMath for uint256;
70 
71     string public name = "METADOLLAR";
72     string public symbol = "M$";
73     uint8 public decimals = 18;
74 
75     uint public chainStartTime; //chain start time
76     uint public chainStartBlockNumber; //chain start block number
77     uint public stakeStartTime; //stake start time
78     uint public stakeMinAge = 3 days; // minimum age for coin age: 3D
79     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
80     uint public maxMintProofOfStake = 10**17; // default 10% annual interest
81 
82     uint public totalSupply;
83     uint public maxTotalSupply;
84     uint public totalInitialSupply;
85 
86     struct transferInStruct{
87         uint128 amount;
88         uint64 time;
89     }
90 
91     mapping(address => uint256) balances;
92     mapping(address => transferInStruct[]) transferIns;
93 
94     modifier canPoSMint() {
95         require(totalSupply < maxTotalSupply);
96         _;
97     }
98 
99 
100     function METADOLLAR() public {
101         maxTotalSupply = 10**30; // 1000000 Mil.
102         totalInitialSupply = 10**26; // 100 Mil.
103 
104         chainStartTime = now;
105         stakeStartTime = now;
106         chainStartBlockNumber = block.number;
107 
108         balances[msg.sender] = totalInitialSupply;
109         totalSupply = totalInitialSupply;
110     }
111 
112     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
113     function isContract(address _addr) private returns (bool is_contract) {
114         uint length;
115         assembly {
116             //retrieve the size of the code on target address, this needs assembly
117             length := extcodesize(_addr)
118         }
119         return (length > 0);
120     }
121 
122     // Function that is called when a user or another contract wants to transfer funds .
123     function transfer(address _to, uint _value, bytes _data) returns (bool success) {
124         if(isContract(_to)) {
125           return transferToContract(_to, _value, _data);
126         } else {
127           return transferToAddress(_to, _value, _data);
128         }
129     }
130 
131     // Standard function transfer similar to ERC20 transfer with no _data .
132     // Added due to backwards compatibility reasons .
133     function transfer(address _to, uint _value) returns (bool success) {
134         //standard function transfer similar to ERC20 transfer with no _data
135         //added due to backwards compatibility reasons
136         bytes memory empty;
137         if(isContract(_to)) {
138             return transferToContract(_to, _value, empty);
139         } else {
140             return transferToAddress(_to, _value, empty);
141         }
142     }
143 
144     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
145       if(msg.sender == _to) return mint();
146       if(balanceOf(msg.sender) < _value) revert();
147       balances[msg.sender] = balanceOf(msg.sender).sub(_value);
148       balances[_to] = balanceOf(_to).add(_value);
149 
150       if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
151       uint64 _now = uint64(now);
152       transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
153       transferIns[_to].push(transferInStruct(uint128(_value),_now));
154 
155       Transfer(msg.sender, _to, _value);
156       ERC223Transfer(msg.sender, _to, _value, _data);
157       return true;
158     }
159 
160     //function that is called when transaction target is a contract
161     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
162       if(msg.sender == _to) return mint();
163       if (balanceOf(msg.sender) < _value) revert();
164       balances[msg.sender] = balanceOf(msg.sender).sub(_value);
165       balances[_to] = balanceOf(_to).add(_value);
166       ContractReceiver reciever = ContractReceiver(_to);
167       reciever.tokenFallback(msg.sender, _value, _data);
168 
169       if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
170       uint64 _now = uint64(now);
171       transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
172       transferIns[_to].push(transferInStruct(uint128(_value),_now));
173 
174       Transfer(msg.sender, _to, _value);
175       ERC223Transfer(msg.sender, _to, _value, _data);
176       return true;
177     }
178 
179     function mint() public canPoSMint returns (bool) {
180         if(balances[msg.sender] <= 0) return false;
181         if(transferIns[msg.sender].length <= 0) return false;
182 
183         uint reward = getProofOfStakeReward(msg.sender);
184         if(reward <= 0) return false;
185 
186         totalSupply = totalSupply.add(reward);
187         balances[msg.sender] = balances[msg.sender].add(reward);
188         delete transferIns[msg.sender];
189         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
190 
191         Mint(msg.sender, reward);
192         return true;
193     }
194 
195 
196     function getBlockNumber() public view returns (uint blockNumber) {
197         blockNumber = block.number.sub(chainStartBlockNumber);
198     }
199 
200 
201     function coinAge(address staker) public view returns (uint256) {
202         return getCoinAge(staker, now);
203     }
204 
205 
206     function annualInterest() public view returns(uint interest) {
207         uint _now = now;
208         interest = maxMintProofOfStake;
209         if((_now.sub(stakeStartTime)).div(365 days) == 0) {
210             interest = (770 * maxMintProofOfStake).div(100);
211         } else if((_now.sub(stakeStartTime)).div(365 days) == 1){
212             interest = (435 * maxMintProofOfStake).div(100);
213         }
214     }
215 
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
227         if((_now.sub(stakeStartTime)).div(365 days) == 0) {
228             // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
229             interest = (770 * maxMintProofOfStake).div(100);
230         } else if((_now.sub(stakeStartTime)).div(365 days) == 1){
231             // 2nd year effective annual interest rate is 50%
232             interest = (435 * maxMintProofOfStake).div(100);
233         }
234 
235         uint offset = 10**uint(decimals);
236 
237         return (_coinAge * interest).div(365 * offset);
238     }
239 
240 
241     function getCoinAge(address _address, uint _now) internal view returns (uint _coinAge) {
242         if(transferIns[_address].length <= 0) return 0;
243 
244         for (uint i = 0; i < transferIns[_address].length; i++){
245             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
246 
247             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
248             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
249 
250             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
251         }
252     }
253 
254     function balanceOf(address _owner) constant returns (uint balance) {
255       return balances[_owner];
256     }
257 
258     // Function to access name of token .
259     function name() constant returns (string _name) {
260         return name;
261     }
262     // Function to access symbol of token .
263     function symbol() constant returns (string _symbol) {
264         return symbol;
265     }
266     // Function to access decimals of token .
267     function decimals() constant returns (uint8 _decimals) {
268         return decimals;
269     }
270     // Function to access total supply of tokens .
271     function totalSupply() constant returns (uint256 _totalSupply) {
272         return totalSupply;
273     }
274 }