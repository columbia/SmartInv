1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29 
30     function Ownable() public {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         owner = newOwner;
42     }
43 }
44 
45 contract ERC20Basic {
46     uint256 public totalSupply;
47     function balanceOf(address who) public constant returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) public constant returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract PoSTokenStandard {
60     uint256 public stakeStartTime;
61     uint256 public stakeMinAge;
62     uint256 public stakeMaxAge;
63     function mint() public returns (bool);
64     function coinAge() public view returns (uint256);
65     function annualInterest() public constant returns (uint256);
66     event Mint(address indexed _address, uint _reward);
67 }
68 
69 contract Crescent is ERC20,PoSTokenStandard,Ownable {
70     using SafeMath for uint256;
71 
72     string public name = "Crescent";
73     string public symbol = "CSN";
74     uint public decimals = 8;
75 
76     uint public chainStartTime;
77     uint public chainStartBlockNumber;
78     uint public stakeStartTime;
79     uint public stakeMinAge = 3 days;
80     uint public stakeMaxAge = 90 days;
81     uint public maxMintProofOfStake = 10**7;
82 
83     uint public totalSupply;
84     uint public maxTotalSupply;
85     uint public totalInitialSupply;
86 
87     struct transferInStruct{
88     uint128 amount;
89     uint64 time;
90     }
91 
92     mapping(address => uint256) balances;
93     mapping(address => mapping (address => uint256)) allowed;
94     mapping(address => transferInStruct[]) transferIns;
95 
96     event Burn(address indexed burner, uint256 value);
97 
98     modifier onlyPayloadSize(uint size) {
99         require(msg.data.length >= size + 4);
100         _;
101     }
102 
103     modifier canPoSMint() {
104         require(totalSupply < maxTotalSupply);
105         _;
106     }
107 
108     function Crescent() public {
109         maxTotalSupply = 1100000000000000;
110         totalInitialSupply = 135000000000000;
111 
112         chainStartTime = now;
113         chainStartBlockNumber = block.number;
114 
115         balances[msg.sender] = totalInitialSupply;
116         totalSupply = totalInitialSupply;
117     }
118 
119     function transfer(address _to, uint256 _value) public  onlyPayloadSize(2 * 32) returns (bool) {
120         if(msg.sender == _to) return mint();
121         balances[msg.sender] = balances[msg.sender].sub(_value);
122         balances[_to] = balances[_to].add(_value);
123         Transfer(msg.sender, _to, _value);
124         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
125         uint64 _now = uint64(now);
126         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
127         transferIns[_to].push(transferInStruct(uint128(_value),_now));
128         return true;
129     }
130 
131     function balanceOf(address _owner) public constant returns (uint256 balance) {
132         return balances[_owner];
133     }
134 
135     function transferFrom(address _from, address _to, uint256 _value) public  onlyPayloadSize(3 * 32) returns (bool) {
136         require(_to != address(0));
137 
138         var _allowance = allowed[_from][msg.sender];
139 
140         balances[_from] = balances[_from].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         allowed[_from][msg.sender] = _allowance.sub(_value);
143         Transfer(_from, _to, _value);
144         if(transferIns[_from].length > 0) delete transferIns[_from];
145         uint64 _now = uint64(now);
146         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
147         transferIns[_to].push(transferInStruct(uint128(_value),_now));
148         return true;
149     }
150 
151     function approve(address _spender, uint256 _value) public returns (bool) {
152         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
153 
154         allowed[msg.sender][_spender] = _value;
155         Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159     function allowance(address _owner, address _spender) public  constant returns (uint256 remaining) {
160         return allowed[_owner][_spender];
161     }
162 
163     function mint() public canPoSMint returns (bool) {
164         if(balances[msg.sender] <= 0) return false;
165         if(transferIns[msg.sender].length <= 0) return false;
166 
167         uint reward = getProofOfStakeReward(msg.sender);
168         if(reward <= 0) return false;
169 
170         totalSupply = totalSupply.add(reward);
171         balances[msg.sender] = balances[msg.sender].add(reward);
172         delete transferIns[msg.sender];
173         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
174 
175         Mint(msg.sender, reward);
176         return true;
177     }
178 
179     function getBlockNumber() public view returns (uint blockNumber) {
180         blockNumber = block.number.sub(chainStartBlockNumber);
181     }
182 
183     function coinAge() public view returns (uint myCoinAge) {
184         myCoinAge = getCoinAge(msg.sender,now);
185     }
186 
187     function annualInterest() public constant returns(uint interest) {
188         uint _now = now;
189         interest = maxMintProofOfStake;
190         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
191             interest = (1650 * maxMintProofOfStake).div(100);
192         } else if((_now.sub(stakeStartTime)).div(1 years) == 1) {
193             interest = (770 * maxMintProofOfStake).div(100);
194         } else if((_now.sub(stakeStartTime)).div(1 years) == 2){
195             interest = (435 * maxMintProofOfStake).div(100);
196         }
197     }
198 
199     function getProofOfStakeReward(address _address) public view returns (uint) {
200         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
201 
202         uint _now = now;
203         uint _coinAge = getCoinAge(_address, _now);
204         if(_coinAge <= 0) return 0;
205 
206         uint interest = maxMintProofOfStake;
207         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
208             interest = (1650 * maxMintProofOfStake).div(100);
209         } else if((_now.sub(stakeStartTime)).div(1 years) == 1) {
210             interest = (770 * maxMintProofOfStake).div(100);
211         } else if((_now.sub(stakeStartTime)).div(1 years) == 2){
212             interest = (435 * maxMintProofOfStake).div(100);
213         }
214 
215         return (_coinAge * interest).div(365 * (10**decimals));
216     }
217 
218     function getCoinAge(address _address, uint _now) public view returns (uint _coinAge) {
219         if(transferIns[_address].length <= 0) return 0;
220 
221         for (uint i = 0; i < transferIns[_address].length; i++){
222             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
223 
224             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
225             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
226 
227             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
228         }
229     }
230 
231    function ownerSetStakeStartTime(uint timestamp) public onlyOwner {
232         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
233         stakeStartTime = timestamp;
234     }
235 
236 }