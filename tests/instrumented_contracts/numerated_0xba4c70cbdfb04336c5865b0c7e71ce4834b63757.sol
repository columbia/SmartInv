1 pragma solidity ^0.4.18;
2 
3 contract BitcoinGalaxy {
4     string public symbol = "BTCG";
5     string public name = "BitcoinGalaxy";
6     uint8 public constant decimals = 8;
7     uint256 _totalSupply = 0;
8 	uint256 _maxTotalSupply = 2100000000000000;
9 	uint256 _miningReward = 10000000000; //1 BTCG - To be halved every 4 years
10 	uint256 _maxMiningReward = 1000000000000; //50 BTCG - To be halved every 4 years
11 	uint256 _rewardHalvingTimePeriod = 126227704; //4 years
12 	uint256 _nextRewardHalving = now + _rewardHalvingTimePeriod;
13 	uint256 _rewardTimePeriod = 600; //10 minutes
14 	uint256 _rewardStart = now;
15 	uint256 _rewardEnd = now + _rewardTimePeriod;
16 	uint256 _currentMined = 0;
17     
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20  
21     mapping(address => uint256) balances;
22  
23     mapping(address => mapping (address => uint256)) allowed;
24  
25     function totalSupply() public constant returns (uint256) {        
26 		return _totalSupply;
27     }
28  
29     function balanceOf(address _owner) public constant returns (uint256 balance) {
30         return balances[_owner];
31     }
32  
33     function transfer(address _to, uint256 _amount) public returns (bool success) {
34         if (balances[msg.sender] >= _amount 
35             && _amount > 0
36             && balances[_to] + _amount > balances[_to]) {
37             balances[msg.sender] -= _amount;
38             balances[_to] += _amount;
39             Transfer(msg.sender, _to, _amount);
40             return true;
41         } else {
42             return false;
43         }
44     }
45  
46     function transferFrom(
47         address _from,
48         address _to,
49         uint256 _amount
50     ) public returns (bool success) {
51         if (balances[_from] >= _amount
52             && allowed[_from][msg.sender] >= _amount
53             && _amount > 0
54             && balances[_to] + _amount > balances[_to]) {
55             balances[_from] -= _amount;
56             allowed[_from][msg.sender] -= _amount;
57             balances[_to] += _amount;
58             Transfer(_from, _to, _amount);
59             return true;
60         } else {
61             return false;
62         }
63     }
64  
65     function approve(address _spender, uint256 _amount) public returns (bool success) {
66         allowed[msg.sender][_spender] = _amount;
67         Approval(msg.sender, _spender, _amount);
68         return true;
69     }
70  
71     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
72         return allowed[_owner][_spender];
73     }
74 	
75 	function Mine() public returns (bool success)
76 	{
77 		if (now < _rewardEnd && _currentMined >= _maxMiningReward)
78 			revert();
79 		else if (now >= _rewardEnd)
80 		{
81 			_rewardStart = now;
82 			_rewardEnd = now + _rewardTimePeriod;
83 			_currentMined = 0;
84 		}
85 	
86 		if (now >= _nextRewardHalving)
87 		{
88 			_nextRewardHalving = now + _rewardHalvingTimePeriod;
89 			_miningReward = _miningReward / 2;
90 			_maxMiningReward = _maxMiningReward / 2;
91 			_currentMined = 0;
92 			_rewardStart = now;
93 			_rewardEnd = now + _rewardTimePeriod;
94 		}	
95 		
96 		if ((_currentMined < _maxMiningReward) && (_totalSupply < _maxTotalSupply))
97 		{
98 			balances[msg.sender] += _miningReward;
99 			_currentMined += _miningReward;
100 			_totalSupply += _miningReward;
101 			Transfer(this, msg.sender, _miningReward);
102 			return true;
103 		}				
104 		return false;
105 	}
106 	
107 	function MaxTotalSupply() public constant returns(uint256)
108 	{
109 		return _maxTotalSupply;
110 	}
111 	
112 	function MiningReward() public constant returns(uint256)
113 	{
114 		return _miningReward;
115 	}
116 	
117 	function MaxMiningReward() public constant returns(uint256)
118 	{
119 		return _maxMiningReward;
120 	}
121 	
122 	function RewardHalvingTimePeriod() public constant returns(uint256)
123 	{
124 		return _rewardHalvingTimePeriod;
125 	}
126 	
127 	function NextRewardHalving() public constant returns(uint256)
128 	{
129 		return _nextRewardHalving;
130 	}
131 	
132 	function RewardTimePeriod() public constant returns(uint256)
133 	{
134 		return _rewardTimePeriod;
135 	}
136 	
137 	function RewardStart() public constant returns(uint256)
138 	{
139 		return _rewardStart;
140 	}
141 	
142 	function RewardEnd() public constant returns(uint256)
143 	{
144 		return _rewardEnd;
145 	}
146 	
147 	function CurrentMined() public constant returns(uint256)
148 	{
149 		return _currentMined;
150 	}
151 	
152 	function TimeNow() public constant returns(uint256)
153 	{
154 		return now;
155 	}
156 }