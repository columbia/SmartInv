1 contract Ethereumshares {
2     string public symbol = "ETS";
3     string public name = "Ethereumshares";
4     uint8 public constant decimals = 18;
5     uint256 _totalSupply = 5000000000000000000000000;
6 	uint256 _maxTotalSupply = 7000000000000000000000000;
7 	uint256 _miningReward = 1000000000000000000000; //One time 1000 ETS
8 	uint256 _maxMiningReward = 1500000000000000000000; //One time 1500 ETS
9 	uint256 _rewardHalvingTimePeriod = 63113852; //2 years
10 	uint256 _nextRewardHalving = now + _rewardHalvingTimePeriod;
11 	uint256 _rewardTimePeriod = 600; //10 minutes
12 	uint256 _rewardStart = now;
13 	uint256 _rewardEnd = now + _rewardTimePeriod;
14 	uint256 _currentMined = 0;
15     
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18  
19     mapping(address => uint256) balances;
20  
21     mapping(address => mapping (address => uint256)) allowed;
22  
23     function totalSupply() constant returns (uint256) {        
24 		return _totalSupply;
25     }
26  
27     function balanceOf(address _owner) constant returns (uint256 balance) {
28         return balances[_owner];
29     }
30  
31     function transfer(address _to, uint256 _amount) returns (bool success) {
32         if (balances[msg.sender] >= _amount 
33             && _amount > 0
34             && balances[_to] + _amount > balances[_to]) {
35             balances[msg.sender] -= _amount;
36             balances[_to] += _amount;
37             Transfer(msg.sender, _to, _amount);
38             return true;
39         } else {
40             return false;
41         }
42     }
43  
44     function transferFrom(
45         address _from,
46         address _to,
47         uint256 _amount
48     ) returns (bool success) {
49         if (balances[_from] >= _amount
50             && allowed[_from][msg.sender] >= _amount
51             && _amount > 0
52             && balances[_to] + _amount > balances[_to]) {
53             balances[_from] -= _amount;
54             allowed[_from][msg.sender] -= _amount;
55             balances[_to] += _amount;
56             Transfer(_from, _to, _amount);
57             return true;
58         } else {
59             return false;
60         }
61     }
62  
63     function approve(address _spender, uint256 _amount) returns (bool success) {
64         allowed[msg.sender][_spender] = _amount;
65         Approval(msg.sender, _spender, _amount);
66         return true;
67     }
68  
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
70         return allowed[_owner][_spender];
71     }
72 	
73 	function Mine() returns (bool success)
74 	{
75 		if (now < _rewardEnd && _currentMined >= _maxMiningReward)
76 			revert();
77 		else if (now >= _rewardEnd)
78 		{
79 			_rewardStart = now;
80 			_rewardEnd = now + _rewardTimePeriod;
81 			_currentMined = 0;
82 		}
83 	
84 		if (now >= _nextRewardHalving)
85 		{
86 			_nextRewardHalving = now + _rewardHalvingTimePeriod;
87 			_miningReward = _miningReward / 2;
88 			_maxMiningReward = _maxMiningReward / 2;
89 			_currentMined = 0;
90 			_rewardStart = now;
91 			_rewardEnd = now + _rewardTimePeriod;
92 		}	
93 		
94 		if ((_currentMined < _maxMiningReward) && (_totalSupply < _maxTotalSupply) && (balances[msg.sender] <=1))
95 		{
96 			balances[msg.sender] += _miningReward;
97 			_currentMined += _miningReward;
98 			_totalSupply += _miningReward;
99 			Transfer(this, msg.sender, _miningReward);
100 			return true;
101 		}				
102 		return false;
103 	}
104 	
105 	function MaxTotalSupply() constant returns(uint256)
106 	{
107 		return _maxTotalSupply;
108 	}
109 	
110 	function MiningReward() constant returns(uint256)
111 	{
112 		return _miningReward;
113 	}
114 	
115 	function MaxMiningReward() constant returns(uint256)
116 	{
117 		return _maxMiningReward;
118 	}
119 	
120 	function RewardHalvingTimePeriod() constant returns(uint256)
121 	{
122 		return _rewardHalvingTimePeriod;
123 	}
124 	
125 	function NextRewardHalving() constant returns(uint256)
126 	{
127 		return _nextRewardHalving;
128 	}
129 	
130 	function RewardTimePeriod() constant returns(uint256)
131 	{
132 		return _rewardTimePeriod;
133 	}
134 	
135 	function RewardStart() constant returns(uint256)
136 	{
137 		return _rewardStart;
138 	}
139 	
140 	function RewardEnd() constant returns(uint256)
141 	{
142 		return _rewardEnd;
143 	}
144 	
145 	function CurrentMined() constant returns(uint256)
146 	{
147 		return _currentMined;
148 	}
149 	
150 	function TimeNow() constant returns(uint256)
151 	{
152 		return now;
153 	}
154     }