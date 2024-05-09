1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 interface IERC20 {
69     function transfer(address to, uint256 value) external returns (bool);
70 
71     function approve(address spender, uint256 value) external returns (bool);
72 
73     function transferFrom(address from, address to, uint256 value) external returns (bool);
74 
75     function totalSupply() external view returns (uint256);
76 
77     function balanceOf(address who) external view returns (uint256);
78 
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 contract ERC20 {
87   uint public totalSupply;
88   function balanceOf(address _address) public view returns (uint);
89 
90   function name() public view returns (string _name);
91   function symbol()public view returns (string _symbol);
92   function decimals()public view returns (uint8 _decimals);
93   function totalSupply()public view returns (uint256 _supply);
94 
95   function transfer(address to, uint value)public returns (bool ok);
96   function transfer(address to, uint value, bytes data)public returns (bool ok);
97   event Transfer(address indexed _from, address indexed _to, uint256 _value);
98   event ERC20Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
99 }
100 
101 contract ContractReceiver {
102   function tokenFallback (address _from, uint _value, bytes _data) public;
103 }
104 
105 /**
106  * @title PoSTokenStandard
107  * @dev the interface of PoSTokenStandard
108  */
109 contract PoSTokenStandard {
110     uint256 public stakeStartTime;
111     uint256 public stakeMinAge;
112     uint256 public stakeMaxAge;
113     function mint() public returns (bool);
114     function coinAge(address staker) public view returns (uint256);
115     function annualInterest() public view returns (uint256);
116     event Mint(address indexed _address, uint _reward);
117 }
118 
119 
120 contract BitUnits is ERC20, PoSTokenStandard {
121     using SafeMath for uint256;
122 
123     string public name = "BitUnits";
124     string public symbol = "UNITX";
125     uint8 public decimals = 8;
126 
127     uint public chainStartTime; //chain start time
128     uint public chainStartBlockNumber; //chain start block number
129     uint public stakeStartTime; //stake start time
130     uint public stakeMinAge = 3 days; // minimum age for coin age: 3D
131     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
132     uint public maxMintProofOfStake = 5*10**14 ; // default 10% annual interest
133 
134     uint public totalSupply;
135     uint public maxTotalSupply;
136     uint public totalInitialSupply;
137 
138     struct transferInStruct{
139         uint128 amount;
140         uint64 time;
141     }
142 
143     mapping(address => uint256) balances;
144     mapping(address => transferInStruct[]) transferIns;
145 
146     modifier canPoSMint() {
147         require(totalSupply < maxTotalSupply);
148         _;
149     }
150 
151 
152     function UNITX() public {
153         maxTotalSupply = 10**15; // 10 Mil.
154         totalInitialSupply = 5*10**14; // 1 Mil.
155 
156         chainStartTime = now;
157         stakeStartTime = now + 1 days;
158         chainStartBlockNumber = block.number;
159 
160         balances[msg.sender] = totalInitialSupply;
161         totalSupply = totalInitialSupply;
162     }
163 
164     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
165     function isContract(address _Tokenaddr) private returns (bool is_contract) {
166         uint length;
167         assembly {
168             //retrieve the size of the code on target address, this needs assembly
169             length := extcodesize( _Tokenaddr)
170         }
171         return (length > 0);
172     }
173 
174     // Function that is called when a user or another contract wants to transfer funds .
175      function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
176         if(isContract(_to)) {
177           return transferToContract(_to, _value, _data);
178         } else {
179           return transferToAddress(_to, _value, _data);
180         }
181     }
182 
183     // Standard function transfer similar to ERC20 transfer with no _data .
184     // Added due to backwards compatibility reasons .
185      function transfer(address _to, uint _value) public returns (bool success) {
186         //standard function transfer similar to ERC20 transfer with no _data
187         //added due to backwards compatibility reasons
188         bytes memory empty;
189         if(isContract(_to)) {
190             return transferToContract(_to, _value, empty);
191         } else {
192             return transferToAddress(_to, _value, empty);
193         }
194     }
195 
196     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
197       if(msg.sender == _to) return mint();
198       if(balanceOf(msg.sender) < _value) revert();
199       balances[msg.sender] = balanceOf(msg.sender).sub(_value);
200       balances[_to] = balanceOf(_to).add(_value);
201 
202       if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
203       uint64 _now = uint64(now);
204       transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
205       transferIns[_to].push(transferInStruct(uint128(_value),_now));
206 
207       emit Transfer (msg.sender, _to, _value);
208       emit ERC20Transfer (msg.sender, _to, _value, _data);
209       return true;
210     }
211 
212     //function that is called when transaction target is a contract
213     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
214       if(msg.sender == _to) return mint();
215       if (balanceOf(msg.sender) < _value) revert();
216       balances[msg.sender] = balanceOf(msg.sender).sub(_value);
217       balances[_to] = balanceOf(_to).add(_value);
218       ContractReceiver reciever = ContractReceiver(_to);
219       reciever.tokenFallback(msg.sender, _value, _data);
220 
221       if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
222       uint64 _now = uint64(now);
223       transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
224       transferIns[_to].push(transferInStruct(uint128(_value),_now));
225 
226       emit Transfer(msg.sender, _to, _value);
227       emit ERC20Transfer(msg.sender, _to, _value, _data);
228       return true;
229     }
230 
231     function mint() public canPoSMint returns (bool) {
232         if(balances[msg.sender] <= 0) return false;
233         if(transferIns[msg.sender].length <= 0) return false;
234 
235         uint reward = getProofOfStakeReward(msg.sender);
236         if(reward <= 0) return false;
237 
238         totalSupply = totalSupply.add(reward);
239         balances[msg.sender] = balances[msg.sender].add(reward);
240         delete transferIns[msg.sender];
241         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
242 
243         emit Mint(msg.sender, reward);
244         return true;
245     }
246 
247 
248     function getBlockNumber() public view returns (uint blockNumber) {
249         blockNumber = block.number.sub(chainStartBlockNumber);
250     }
251 
252 
253     function coinAge(address staker) public view returns (uint256) {
254         return getCoinAge(staker, now);
255     }
256 
257 
258     function annualInterest() public view returns(uint interest) {
259         uint _now = now;
260         interest = maxMintProofOfStake;
261         if((_now.sub(stakeStartTime)).div(365 days) == 0) {
262             interest = (770 * maxMintProofOfStake).div(100);
263         } else if((_now.sub(stakeStartTime)).div(365 days) == 1){
264             interest = (435 * maxMintProofOfStake).div(100);
265         }
266     }
267 
268 
269     function getProofOfStakeReward(address _address) internal view returns (uint) {
270         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
271 
272         uint _now = now;
273         uint _coinAge = getCoinAge(_address, _now);
274         if(_coinAge <= 0) return 0;
275 
276         uint interest = maxMintProofOfStake;
277         // Due to the high interest rate for the first two years, compounding should be taken into account.
278         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
279         if((_now.sub(stakeStartTime)).div(365 days) == 0) {
280             // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
281             interest = (770 * maxMintProofOfStake).div(100);
282         } else if((_now.sub(stakeStartTime)).div(365 days) == 1){
283             // 2nd year effective annual interest rate is 50%
284             interest = (435 * maxMintProofOfStake).div(100);
285         }
286 
287         uint offset = 10**uint(decimals);
288 
289         return (_coinAge * interest).div(365 * offset);
290     }
291 
292 
293     function getCoinAge(address _address, uint _now) internal view returns (uint _coinAge) {
294         if(transferIns[_address].length <= 0) return 0;
295 
296         for (uint i = 0; i < transferIns[_address].length; i++){
297             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
298 
299             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
300             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
301 
302             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
303         }
304     }
305 
306     function balanceOf(address _owner)public view returns (uint balance) {
307       return balances[_owner];
308     }
309 
310    // Function to access name of token .
311     function name() public constant returns (string _name) {
312         return name;
313     }
314     // Function to access symbol of token .
315     function symbol()public constant returns (string _symbol) {
316         return symbol;
317     }
318     // Function to access decimals of token .
319     function decimals()public constant returns (uint8 _decimals) {
320         return decimals;
321     }
322     // Function to access total supply of tokens .
323     function totalSupply()public constant returns (uint256 _totalSupply) {
324         return totalSupply;
325     }
326 }