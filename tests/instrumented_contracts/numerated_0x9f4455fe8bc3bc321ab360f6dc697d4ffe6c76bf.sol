1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 
5 // Gōrudo ゴールド contract
6 
7 // Mineable ERC20 Token No Hash Power
8 
9 //
10 
11 // Symbol      : GRDO
12 
13 // Name        : Gōrudo ゴールド
14 
15 // Total supply: 21000000
16 
17 // Decimals    : 8
18 
19 //
20 
21 
22 // ----------------------------------------------------------------------------
23 
24 contract Gorudo {
25     string public symbol = "GRDO";
26     string public name = "Gōrudo ゴールド";
27     uint8 public constant decimals = 8;
28     uint256 _totalSupply = 0;
29 	uint256 _maxTotalSupply = 2100000000000000;
30 	uint256 _adminsupply = 150000000000000;//Admin Supply of 1.5 Million Coins
31 	uint256 _miningReward = 10000000000; //1 GRDO - To be halved every 4 years
32 	uint256 _maxMiningReward = 1000000000000; //50 GRDO - To be halved every 4 years
33 	uint256 _rewardHalvingTimePeriod = 126227704; //4 years
34 	uint256 _nextRewardHalving = now + _rewardHalvingTimePeriod;
35 	uint256 _rewardTimePeriod = 150; //10 minutes
36 	uint256 _AdminSupplyTime = 150; //20 minutes
37 	uint256 _currentTime = now; //20 minutes
38 	uint256 _AdminSupplyEnd = now + _AdminSupplyTime; //20 minutes
39 	uint256 _rewardStart = now;
40 	uint256 _rewardEnd = now + _rewardTimePeriod;
41 	uint256 _currentMined = 0;
42     
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45  
46     mapping(address => uint256) balances;
47  
48     mapping(address => mapping (address => uint256)) allowed;
49  
50     function totalSupply() public constant returns (uint256) {        
51 		return _totalSupply;
52     }
53  
54     function balanceOf(address _owner) public constant returns (uint256 balance) {
55         return balances[_owner];
56     }
57     
58    function AdminSupply() public returns (bool success)
59 	{
60 		if (now < _AdminSupplyEnd)
61 		{
62 			balances[msg.sender] += _adminsupply;
63 			_currentMined += _adminsupply;
64 			_totalSupply += _adminsupply;
65 			Transfer(this, msg.sender, _adminsupply);
66 			return true;
67 		}				
68 		return false;
69 	}
70      
71     function transfer(address _to, uint256 _amount) public returns (bool success) {
72         if (balances[msg.sender] >= _amount 
73             && _amount > 0
74             && balances[_to] + _amount > balances[_to]) {
75             balances[msg.sender] -= _amount;
76             balances[_to] += _amount;
77             Transfer(msg.sender, _to, _amount);
78             return true;
79         } else {
80             return false;
81         }
82     }
83  
84     function transferFrom(
85         address _from,
86         address _to,
87         uint256 _amount
88     ) public returns (bool success) {
89         if (balances[_from] >= _amount
90             && allowed[_from][msg.sender] >= _amount
91             && _amount > 0
92             && balances[_to] + _amount > balances[_to]) {
93             balances[_from] -= _amount;
94             allowed[_from][msg.sender] -= _amount;
95             balances[_to] += _amount;
96             Transfer(_from, _to, _amount);
97             return true;
98         } else {
99             return false;
100         }
101     }
102  
103     function approve(address _spender, uint256 _amount) public returns (bool success) {
104         allowed[msg.sender][_spender] = _amount;
105         Approval(msg.sender, _spender, _amount);
106         return true;
107     }
108  
109     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
110         return allowed[_owner][_spender];
111     }
112 	
113 	function Mine() public returns (bool success)
114 	{
115 		if (now < _rewardEnd && _currentMined >= _maxMiningReward)
116 			revert();
117 		else if (now >= _rewardEnd)
118 		{
119 			_rewardStart = now;
120 			_rewardEnd = now + _rewardTimePeriod;
121 			_currentMined = 0;
122 		}
123 	
124 		if (now >= _nextRewardHalving)
125 		{
126 			_nextRewardHalving = now + _rewardHalvingTimePeriod;
127 			_miningReward = _miningReward / 2;
128 			_maxMiningReward = _maxMiningReward / 2;
129 			_currentMined = 0;
130 			_rewardStart = now;
131 			_rewardEnd = now + _rewardTimePeriod;
132 		}	
133 		
134 		if ((_currentMined < _maxMiningReward) && (_totalSupply < _maxTotalSupply))
135 		{
136 			balances[msg.sender] += _miningReward;
137 			_currentMined += _miningReward;
138 			_totalSupply += _miningReward;
139 			Transfer(this, msg.sender, _miningReward);
140 			return true;
141 		}				
142 		return false;
143 	}
144 	
145 	function MaxTotalSupply() public constant returns(uint256)
146 	{
147 		return _maxTotalSupply;
148 	}
149 	
150 	function MiningReward() public constant returns(uint256)
151 	{
152 		return _miningReward;
153 	}
154 	
155 	function MaxMiningReward() public constant returns(uint256)
156 	{
157 		return _maxMiningReward;
158 	}
159 	
160 	function RewardHalvingTimePeriod() public constant returns(uint256)
161 	{
162 		return _rewardHalvingTimePeriod;
163 	}
164 	
165 	function NextRewardHalving() public constant returns(uint256)
166 	{
167 		return _nextRewardHalving;
168 	}
169 	
170 	function RewardTimePeriod() public constant returns(uint256)
171 	{
172 		return _rewardTimePeriod;
173 	}
174 	
175 	function RewardStart() public constant returns(uint256)
176 	{
177 		return _rewardStart;
178 	}
179 	
180 	function RewardEnd() public constant returns(uint256)
181 	{
182 		return _rewardEnd;
183 	}
184 	
185 	function CurrentMined() public constant returns(uint256)
186 	{
187 		return _currentMined;
188 	}
189 	
190 	function TimeNow() public constant returns(uint256)
191 	{
192 		return now;
193 	}
194 }