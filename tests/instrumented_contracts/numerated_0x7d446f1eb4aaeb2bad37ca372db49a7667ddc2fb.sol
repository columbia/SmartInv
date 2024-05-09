1 pragma solidity ^0.4.24;
2 
3 /**
4  * SmartEth.co
5  * ERC20 Token and ICO smart contracts development, smart contracts audit, ICO websites.
6  * contact@smarteth.co
7  */
8 
9 /**
10  * @title SafeMath
11  */
12 library SafeMath {
13 
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 /**
43  * @title Ownable
44  */
45 contract Ownable {
46   address public owner;
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50   constructor() public {
51     owner = msg.sender;
52   }
53 
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 
65 }
66 
67 /**
68  * @title ERC20Basic
69  */
70 contract ERC20Basic {
71   uint256 public totalSupply;
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 /**
78  * @title ERC20 interface
79  */
80 contract ERC20 is ERC20Basic {
81   function allowance(address owner, address spender) public view returns (uint256);
82   function transferFrom(address from, address to, uint256 value) public returns (bool);
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 contract ZIC_Token is ERC20, Ownable {
88     using SafeMath for uint256;
89 
90     string public name = "Zinscoin";
91     string public symbol = "ZIC";
92     uint public decimals = 5;
93 
94     uint public chainStartTime;
95     uint public chainStartBlockNumber;
96     uint public stakeStartTime;
97     uint public stakeMinAge = 10 days; // minimum coin age: 10 Days
98     uint public maxMintProofOfStake = 5 * 10 ** uint256(decimals-2); // Anual reward after 50 years: 5%
99 
100     uint public totalSupply;
101     uint public maxTotalSupply;
102     uint public totalInitialSupply;
103 
104     struct transferInStruct{
105     uint128 amount;
106     uint64 time;
107     }
108 
109     mapping(address => uint256) balances;
110     mapping(address => mapping (address => uint256)) allowed;
111     mapping(address => transferInStruct[]) transferIns;
112     
113     event Mint(address indexed _address, uint _reward);
114     event Burn(address indexed burner, uint256 value);
115 
116     /**
117      * @dev Fix for the ERC20 short address attack.
118      */
119     modifier onlyPayloadSize(uint size) {
120         require(msg.data.length >= size + 4);
121         _;
122     }
123 
124     modifier canPoSMint() {
125         require(totalSupply < maxTotalSupply);
126         _;
127     }
128 
129     constructor() public {
130         maxTotalSupply = 2100000000 * 10 ** uint256(decimals); // Max supply: 2,100,000,000
131         totalInitialSupply = 50000 * 10 ** uint256(decimals); // Initial supply: 50,000
132 
133         chainStartTime = now;
134         chainStartBlockNumber = block.number;
135 
136         balances[owner] = totalInitialSupply;
137         emit Transfer(0x0, owner, totalInitialSupply);
138         totalSupply = totalInitialSupply;
139     }
140 
141     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
142         if(msg.sender == _to) return mint();
143         balances[msg.sender] = balances[msg.sender].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         emit Transfer(msg.sender, _to, _value);
146         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
147         uint64 _now = uint64(now);
148         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
149         transferIns[_to].push(transferInStruct(uint128(_value),_now));
150         return true;
151     }
152 
153     function balanceOf(address _owner) public constant returns (uint256 balance) {
154         return balances[_owner];
155     }
156 
157     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
158         require(_to != address(0));
159         require(_value <= balances[_from]);
160         require(_value <= allowed[_from][msg.sender]);
161 
162         balances[_from] = balances[_from].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165         emit Transfer(_from, _to, _value);
166         if(transferIns[_from].length > 0) delete transferIns[_from];
167         uint64 _now = uint64(now);
168         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
169         transferIns[_to].push(transferInStruct(uint128(_value),_now));
170         return true;
171     }
172 
173     function approve(address _spender, uint256 _value) public returns (bool) {
174         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
175 
176         allowed[msg.sender][_spender] = _value;
177         emit Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
182         return allowed[_owner][_spender];
183     }
184 
185     function mint() canPoSMint public returns (bool) {
186         if(balances[msg.sender] <= 0) return false;
187         if(transferIns[msg.sender].length <= 0) return false;
188 
189         uint reward = getProofOfStakeReward(msg.sender);
190         if(reward <= 0) return false;
191 
192         totalSupply = totalSupply.add(reward);
193         balances[msg.sender] = balances[msg.sender].add(reward);
194         delete transferIns[msg.sender];
195         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
196 
197         emit Mint(msg.sender, reward);
198         return true;
199     }
200 
201     function getBlockNumber() public view returns (uint blockNumber) {
202         blockNumber = block.number.sub(chainStartBlockNumber);
203     }
204 
205     function coinAge() public constant returns (uint myCoinAge) {
206         myCoinAge = getCoinAge(msg.sender,now);
207     }
208 
209     function annualInterest() public constant returns(uint interest) {
210         uint _now = now;
211         interest = maxMintProofOfStake;
212         if((_now.sub(stakeStartTime)) <= 30 years) {
213             interest = 4 * maxMintProofOfStake; // Anual reward years (0, 30]: 20%
214         } else if((_now.sub(stakeStartTime)) > 30 years && (_now.sub(stakeStartTime)) <= 50 years){
215             interest = 2 * maxMintProofOfStake; // Anual reward years (30, 50]: 20%
216         }
217     }
218 
219     function getProofOfStakeReward(address _address) internal returns (uint) {
220         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
221 
222         uint _now = now;
223         uint _coinAge = getCoinAge(_address, _now);
224         if(_coinAge <= 0) return 0;
225         
226         uint interest = maxMintProofOfStake;
227         if((_now.sub(stakeStartTime)) <= 30 years) {
228             interest = 4 * maxMintProofOfStake; // Anual reward years (0, 30]: 20%
229         } else if((_now.sub(stakeStartTime)) > 30 years && (_now.sub(stakeStartTime)) <= 50 years){
230             interest = 2 * maxMintProofOfStake; // Anual reward years (30, 50]: 20%
231         }
232 
233         return (_coinAge * interest).div(365 * 10 ** uint256(decimals));
234     }
235 
236     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
237         if(transferIns[_address].length <= 0) return 0;
238 
239         for (uint i = 0; i < transferIns[_address].length; i++){
240             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
241 
242             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
243 
244             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
245         }
246     }
247 
248     function ownerSetStakeStartTime(uint timestamp) public onlyOwner {
249         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
250         stakeStartTime = timestamp;
251     }
252 
253     function ownerBurnToken(uint _value) public onlyOwner {
254         require(_value > 0);
255 
256         balances[msg.sender] = balances[msg.sender].sub(_value);
257         delete transferIns[msg.sender];
258         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
259 
260         totalSupply = totalSupply.sub(_value);
261         totalInitialSupply = totalInitialSupply.sub(_value);
262         maxTotalSupply = maxTotalSupply.sub(_value*10);
263 
264         emit Burn(msg.sender, _value);
265     }
266 }