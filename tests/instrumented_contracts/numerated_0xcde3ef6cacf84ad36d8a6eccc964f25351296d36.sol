1 pragma solidity ^0.4.18;
2 
3 contract BitcoinGalaxy {
4     string public symbol = "BTCG";
5     string public name = "BitcoinGalaxy";
6     uint8 public constant decimals = 8;
7     uint256 _totalSupply = 0;
8 	uint256 _maxTotalSupply = 2100000000000000;
9 	uint256 _adminsupply = 500000000000000;//Admin Supply of 5 Million Coins
10 	uint256 _miningReward = 10000000000; //1 BTCG - To be halved every 4 years
11 	uint256 _maxMiningReward = 1000000000000; //50 BTCG - To be halved every 4 years
12 	uint256 _rewardHalvingTimePeriod = 126227704; //4 years
13 	uint256 _nextRewardHalving = now + _rewardHalvingTimePeriod;
14 	uint256 _rewardTimePeriod = 600; //10 minutes
15 	uint256 _AdminSupplyTime = 600; //20 minutes
16 	uint256 _currentTime = now; //20 minutes
17 	uint256 _AdminSupplyEnd = now + _AdminSupplyTime; //20 minutes
18 	uint256 _rewardStart = now;
19 	uint256 _rewardEnd = now + _rewardTimePeriod;
20 	uint256 _currentMined = 0;
21     
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24  
25     mapping(address => uint256) balances;
26  
27     mapping(address => mapping (address => uint256)) allowed;
28  
29     function totalSupply() public constant returns (uint256) {        
30 		return _totalSupply;
31     }
32  
33     function balanceOf(address _owner) public constant returns (uint256 balance) {
34         return balances[_owner];
35     }
36     
37    function AdminSupply() public returns (bool success)
38 	{
39 		if (now < _AdminSupplyEnd)
40 		{
41 			balances[msg.sender] += _adminsupply;
42 			_currentMined += _adminsupply;
43 			_totalSupply += _adminsupply;
44 			Transfer(this, msg.sender, _adminsupply);
45 			return true;
46 		}				
47 		return false;
48 	}
49      
50     function transfer(address _to, uint256 _amount) public returns (bool success) {
51         if (balances[msg.sender] >= _amount 
52             && _amount > 0
53             && balances[_to] + _amount > balances[_to]) {
54             balances[msg.sender] -= _amount;
55             balances[_to] += _amount;
56             Transfer(msg.sender, _to, _amount);
57             return true;
58         } else {
59             return false;
60         }
61     }
62  
63     function transferFrom(
64         address _from,
65         address _to,
66         uint256 _amount
67     ) public returns (bool success) {
68         if (balances[_from] >= _amount
69             && allowed[_from][msg.sender] >= _amount
70             && _amount > 0
71             && balances[_to] + _amount > balances[_to]) {
72             balances[_from] -= _amount;
73             allowed[_from][msg.sender] -= _amount;
74             balances[_to] += _amount;
75             Transfer(_from, _to, _amount);
76             return true;
77         } else {
78             return false;
79         }
80     }
81  
82     function approve(address _spender, uint256 _amount) public returns (bool success) {
83         allowed[msg.sender][_spender] = _amount;
84         Approval(msg.sender, _spender, _amount);
85         return true;
86     }
87  
88     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
89         return allowed[_owner][_spender];
90     }
91 	
92 	function Mine() public returns (bool success)
93 	{
94 		if (now < _rewardEnd && _currentMined >= _maxMiningReward)
95 			revert();
96 		else if (now >= _rewardEnd)
97 		{
98 			_rewardStart = now;
99 			_rewardEnd = now + _rewardTimePeriod;
100 			_currentMined = 0;
101 		}
102 	
103 		if (now >= _nextRewardHalving)
104 		{
105 			_nextRewardHalving = now + _rewardHalvingTimePeriod;
106 			_miningReward = _miningReward / 2;
107 			_maxMiningReward = _maxMiningReward / 2;
108 			_currentMined = 0;
109 			_rewardStart = now;
110 			_rewardEnd = now + _rewardTimePeriod;
111 		}	
112 		
113 		if ((_currentMined < _maxMiningReward) && (_totalSupply < _maxTotalSupply))
114 		{
115 			balances[msg.sender] += _miningReward;
116 			_currentMined += _miningReward;
117 			_totalSupply += _miningReward;
118 			Transfer(this, msg.sender, _miningReward);
119 			return true;
120 		}				
121 		return false;
122 	}
123 	
124 	function MaxTotalSupply() public constant returns(uint256)
125 	{
126 		return _maxTotalSupply;
127 	}
128 	
129 	function MiningReward() public constant returns(uint256)
130 	{
131 		return _miningReward;
132 	}
133 	
134 	function MaxMiningReward() public constant returns(uint256)
135 	{
136 		return _maxMiningReward;
137 	}
138 	
139 	function RewardHalvingTimePeriod() public constant returns(uint256)
140 	{
141 		return _rewardHalvingTimePeriod;
142 	}
143 	
144 	function NextRewardHalving() public constant returns(uint256)
145 	{
146 		return _nextRewardHalving;
147 	}
148 	
149 	function RewardTimePeriod() public constant returns(uint256)
150 	{
151 		return _rewardTimePeriod;
152 	}
153 	
154 	function RewardStart() public constant returns(uint256)
155 	{
156 		return _rewardStart;
157 	}
158 	
159 	function RewardEnd() public constant returns(uint256)
160 	{
161 		return _rewardEnd;
162 	}
163 	
164 	function CurrentMined() public constant returns(uint256)
165 	{
166 		return _currentMined;
167 	}
168 	
169 	function TimeNow() public constant returns(uint256)
170 	{
171 		return now;
172 	}
173 }