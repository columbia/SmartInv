1 /**
2  * @First Smart Airdrop eGAS
3  * @http://ethgas.stream
4  * @egas@ethgas.stream
5  */
6 
7 pragma solidity ^0.4.16;
8 
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14  library SafeMath {
15   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16     uint256 c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal constant returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 contract Owned {
41     // The address of the account of the current owner
42     address public owner;
43 
44     // The publiser is the inital owner
45     function Owned() public {
46         owner = msg.sender;
47     }
48 
49     /**
50      * Access is restricted to the current owner
51      */
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     /**
58      * Transfer ownership to `_newOwner`
59      *
60      * @param _newOwner The address of the account that will become the new owner
61      */
62     function transferOwnership(address _newOwner) public onlyOwner {
63         owner = _newOwner;
64     }
65 }
66 
67 contract EGAS is Owned {
68     using SafeMath for uint256;
69     string public symbol = "EGAS";
70     string public name = "ETHGAS";
71     uint8 public constant decimals = 8;
72     uint256 _initialSupply = 100000000000000;
73     uint256 _totalSupply = 0;
74 	uint256 _maxTotalSupply = 1279200000000000;
75 	uint256 _dropReward = 26000000000; //260 eGAS - per entry with 30% bonus to start
76 	uint256 _maxDropReward = 1300000000000; //13000 eGAS - per block 10min with 30% bonus to start - 50 entry max
77 	uint256 _rewardBonusTimePeriod = 86400; //1 day each bonus stage
78 	uint256 _nextRewardBonus = now + _rewardBonusTimePeriod;
79 	uint256 _rewardTimePeriod = 600; //10 minutes
80 	uint256 _rewardStart = now;
81 	uint256 _rewardEnd = now + _rewardTimePeriod;
82 	uint256 _currentAirdropped = 0;
83     
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86  
87     mapping(address => uint256) balances;
88  
89     mapping(address => mapping (address => uint256)) allowed;
90     
91     function OwnerReward() public {
92     balances[owner] = _initialSupply;
93     transfer(owner, balances[owner]);
94     }
95  
96     function withdraw() public onlyOwner {
97         owner.transfer(this.balance);
98     }
99  
100     function totalSupply() constant returns (uint256) {        
101 		return _totalSupply + _initialSupply;
102     }
103     
104     function balanceOf(address _owner) constant returns (uint256 balance) {
105         return balances[_owner];
106     }
107  
108     function transfer(address _to, uint256 _amount) returns (bool success) {
109         if (balances[msg.sender] >= _amount 
110             && _amount > 0
111             && balances[_to] + _amount > balances[_to]) {
112             balances[msg.sender] -= _amount;
113             balances[_to] += _amount;
114             Transfer(msg.sender, _to, _amount);
115             return true;
116         } else {
117             return false;
118         }
119     }
120  
121     function transferFrom(
122         address _from,
123         address _to,
124         uint256 _amount
125     ) returns (bool success) {
126         if (balances[_from] >= _amount
127             && allowed[_from][msg.sender] >= _amount
128             && _amount > 0
129             && balances[_to] + _amount > balances[_to]) {
130             balances[_from] -= _amount;
131             allowed[_from][msg.sender] -= _amount;
132             balances[_to] += _amount;
133             Transfer(_from, _to, _amount);
134             return true;
135         } else {
136             return false;
137         }
138     }
139  
140     function approve(address _spender, uint256 _amount) returns (bool success) {
141         allowed[msg.sender][_spender] = _amount;
142         Approval(msg.sender, _spender, _amount);
143         return true;
144     }
145  
146     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
147         return allowed[_owner][_spender];
148     }
149 	
150 	function SmartAirdrop() payable returns (bool success)
151 	{
152 		if (now < _rewardEnd && _currentAirdropped >= _maxDropReward)
153 			revert();
154 		else if (now >= _rewardEnd)
155 		{
156 			_rewardStart = now;
157 			_rewardEnd = now + _rewardTimePeriod;
158 			_currentAirdropped = 0;
159 		}
160 	
161 		if (now >= _nextRewardBonus)
162 		{
163 			_nextRewardBonus = now + _rewardBonusTimePeriod;
164 			_dropReward = _dropReward - 1000000000;
165 			_maxDropReward = _maxDropReward - 50000000000;
166 			_currentAirdropped = 0;
167 			_rewardStart = now;
168 			_rewardEnd = now + _rewardTimePeriod;
169 		}	
170 		
171 		if ((_currentAirdropped < _maxDropReward) && (_totalSupply < _maxTotalSupply))
172 		{
173 			balances[msg.sender] += _dropReward;
174 			_currentAirdropped += _dropReward;
175 			_totalSupply += _dropReward;
176 			Transfer(this, msg.sender, _dropReward);
177 			return true;
178 		}				
179 		return false;
180 	}
181 	
182 	function MaxTotalSupply() constant returns(uint256)
183 	{
184 		return _maxTotalSupply;
185 	}
186 	
187 	function DropReward() constant returns(uint256)
188 	{
189 		return _dropReward;
190 	}
191 	
192 	function MaxDropReward() constant returns(uint256)
193 	{
194 		return _maxDropReward;
195 	}
196 	
197 	function RewardBonusTimePeriod() constant returns(uint256)
198 	{
199 		return _rewardBonusTimePeriod;
200 	}
201 	
202 	function NextRewardBonus() constant returns(uint256)
203 	{
204 		return _nextRewardBonus;
205 	}
206 	
207 	function RewardTimePeriod() constant returns(uint256)
208 	{
209 		return _rewardTimePeriod;
210 	}
211 	
212 	function RewardStart() constant returns(uint256)
213 	{
214 		return _rewardStart;
215 	}
216 	
217 	function RewardEnd() constant returns(uint256)
218 	{
219 		return _rewardEnd;
220 	}
221 	
222 	function CurrentAirdropped() constant returns(uint256)
223 	{
224 		return _currentAirdropped;
225 	}
226 	
227 	function TimeNow() constant returns(uint256)
228 	{
229 		return now;
230 	}
231 }