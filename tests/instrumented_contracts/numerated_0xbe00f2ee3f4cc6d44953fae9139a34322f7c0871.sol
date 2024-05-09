1 pragma solidity ^0.4.17;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 }
45 /**
46  * @title GscTokenStandard
47  * @dev the interface of GscTokenStandard
48  */
49 contract GscTokenStandard {
50     uint256 public stakeStartTime;
51     uint256 public stakeMinAge;
52     uint256 public stakeMaxAge;
53     function mint() returns (bool);
54     function coinAge() constant returns (uint256);
55     function annualInterest() constant returns (uint256);
56     event Mint(address indexed _address, uint _reward);
57 }
58 /**
59     @Dev github.com/HamzaYasin1
60 */
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that throw on error
74  */
75 library SafeMath {
76   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77     if (a == 0) {
78       return 0;
79     }
80     uint256 c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84   function div(uint256 a, uint256 b) internal pure returns (uint256) {
85     // assert(b > 0); // Solidity automatically throws when dividing by 0
86     uint256 c = a / b;
87     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88     return c;
89   }
90   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 contract GscToken is ERC20,GscTokenStandard,Ownable {
101     using SafeMath for uint256;
102     string public name = "Gas Coin";
103     string public symbol = "GSC";
104     uint public decimals = 18;
105     uint public chainStartTime; //chain start time
106     uint public chainStartBlockNumber; //chain start block number
107     uint public stakeStartTime; //stake start time
108     uint public stakeMinAge = 3 days; // minimum age for coin age: 3 Days
109     uint public stakeMaxAge = 90 days; // stake age of full weight: 90 Days
110     uint public maxMintProofOfStake = 10**17; // default 10% annual interest
111     uint public totalSupply;
112     uint public maxTotalSupply;
113     uint public totalInitialSupply;
114     struct transferInStruct {
115     uint128 amount;
116     uint64 time;
117     }
118     mapping(address => uint256) balances;
119     mapping(address => mapping (address => uint256)) allowed;
120     mapping(address => transferInStruct[]) transferIns;
121     event Burn(address indexed burner, uint256 value);
122     /**
123      * @dev Fix for the ERC20 short address attack.
124      */
125     modifier onlyPayloadSize(uint size) {
126         require(msg.data.length >= size + 4);
127         _;
128     }
129     modifier canGscMint() {
130         require(totalSupply < maxTotalSupply);
131         _;
132     }
133     function GscToken() {
134         maxTotalSupply = 250000000 * 1 ether; // 250 Mil.
135         totalInitialSupply = 130000000 * 1 ether; // 130 Mil.
136         chainStartTime = now;
137         chainStartBlockNumber = block.number;
138         balances[msg.sender] = totalInitialSupply;
139         totalSupply = totalInitialSupply;
140     }
141     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
142         if(msg.sender == _to) 
143         return mint();
144         balances[msg.sender] = balances[msg.sender].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         Transfer(msg.sender, _to, _value);
147         if(transferIns[msg.sender].length > 0) 
148         delete transferIns[msg.sender];
149         uint64 _now = uint64(now);
150         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
151         transferIns[_to].push(transferInStruct(uint128(_value),_now));
152         return true;
153     }
154     function balanceOf(address _owner) constant returns (uint256 balance) {
155         return balances[_owner];
156     }
157     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
158         require(_to != address(0));
159         var _allowance = allowed[_from][msg.sender];
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = _allowance.sub(_value);
163         Transfer(_from, _to, _value);
164         if(transferIns[_from].length > 0) 
165         delete transferIns[_from];
166         uint64 _now = uint64(now);
167         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
168         transferIns[_to].push(transferInStruct(uint128(_value),_now));
169         return true;
170     }
171     function approve(address _spender, uint256 _value) returns (bool) {
172         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
173         allowed[msg.sender][_spender] = _value;
174         Approval(msg.sender, _spender, _value);
175         return true;
176     }
177     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
178         return allowed[_owner][_spender];
179     }
180     function mint() canGscMint returns (bool) {
181         if(balances[msg.sender] <= 0) 
182         return false;
183         if(transferIns[msg.sender].length <= 0) 
184         return false;
185         uint reward = getProofOfStakeReward(msg.sender);
186         if(reward <= 0) 
187         return false;
188         totalSupply = totalSupply.add(reward);
189         balances[msg.sender] = balances[msg.sender].add(reward);
190         delete transferIns[msg.sender];
191         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
192         Mint(msg.sender, reward);
193         return true;
194     }
195     function getBlockNumber() returns (uint blockNumber) {
196         blockNumber = block.number.sub(chainStartBlockNumber);
197     }
198     function coinAge() constant returns (uint myCoinAge) {
199         myCoinAge = getCoinAge(msg.sender,now);
200     }
201     function annualInterest() constant returns(uint interest) {
202         interest = maxMintProofOfStake;
203     }
204     function getProofOfStakeReward(address _address) internal returns (uint) {
205         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
206         uint _now = now;
207         uint _coinAge = getCoinAge(_address, _now);
208         if(_coinAge <= 0) 
209         return 0;
210         uint interest = maxMintProofOfStake;
211         return (_coinAge * interest).div(365 * (10**decimals)); // 2 = 365
212     }
213     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
214         if(transferIns[_address].length <= 0) 
215         return 0;
216         for (uint i = 0; i < transferIns[_address].length; i++) {
217             if(_now < uint(transferIns[_address][i].time).add(stakeMinAge)) 
218             continue;
219             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
220             if(nCoinSeconds > stakeMaxAge) {
221             nCoinSeconds = stakeMaxAge;
222             }
223             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days)); // days
224         }
225     }
226     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
227         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
228         stakeStartTime = timestamp;
229     }
230     function ownerBurnToken(uint _value) onlyOwner {
231         require(_value > 0);
232         balances[msg.sender] = balances[msg.sender].sub(_value);
233         delete transferIns[msg.sender];
234         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
235         totalSupply = totalSupply.sub(_value);
236         totalInitialSupply = totalInitialSupply.sub(_value);
237         maxTotalSupply = maxTotalSupply.sub(_value*10);
238         Burn(msg.sender, _value);
239     }
240     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
241     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
242         require( _recipients.length > 0 && _recipients.length == _values.length);
243         uint total = 0;
244         for(uint i = 0; i < _values.length; i++) {
245             total = total.add(_values[i]);
246         }
247         require(total <= balances[msg.sender]);
248         uint64 _now = uint64(now);
249         for(uint j = 0; j < _recipients.length; j++) {
250             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
251             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
252             Transfer(msg.sender, _recipients[j], _values[j]);
253         }
254         balances[msg.sender] = balances[msg.sender].sub(total);
255         if(transferIns[msg.sender].length > 0) 
256         delete transferIns[msg.sender];
257         if(balances[msg.sender] > 0) 
258         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
259         return true;
260     }
261 }