1 pragma solidity 0.4.18;
2 //signature - 9927A75EF7C89D3C028C8BA7A1B48CDD515ACED7A2BC564A099D452D3B3FFE89
3 contract NewYearToken{
4 	string public symbol = "NYT";
5 	string public name = "New Year Token";
6 	uint8 public constant decimals = 8;
7 	uint256 _totalSupply = 0;
8 	address contract_owner;
9 	uint256 current_remaining = 0;
10 	uint256 _contractStart = 1514782800; // 01/01/2018 12:00AM EST
11 	uint256 _maxTotalSupply = 10000000000000000; //one hundred million
12 	uint256 _miningReward = 10000000000; //100 NYT rewarded on successful mine halved every 5 years 
13 	uint256 _maxMiningReward = 1000000000000000; //10,000,000 NYT - To be halved every 5 years
14 	uint256 _year = 1514782800; // 01/01/2018 12:00AM EST
15 	uint256 _year_count = 2018; //contract starts in 2018 first leap year is 2020
16 	uint256 _currentMined = 0; //mined for the year
17 
18 
19 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21     mapping(address => uint256) balances;
22     mapping(address => mapping (address => uint256)) allowed;
23 
24     //initialize contract - set owner and give owner 20,000 tokens
25     function NewYearToken(){	
26     	contract_owner = msg.sender;
27     	balances[msg.sender] += 20000;
28     }
29 
30 	function totalSupply() constant returns (uint256) {        
31 		return _totalSupply;
32 	}
33 
34 	function balanceOf(address _owner) constant returns (uint256 balance) {
35 		return balances[_owner];
36 	}
37 
38 
39 	function transfer(address _to, uint256 _amount) returns (bool success) {
40 		if (balances[msg.sender] >= _amount 
41 			&& _amount > 0
42 			&& balances[_to] + _amount > balances[_to]) {
43 			balances[msg.sender] -= _amount;
44 			balances[_to] += _amount;
45 			Transfer(msg.sender, _to, _amount);
46 			return true;
47 		} else {
48             return false;
49 		}
50 	}
51 
52 	function transferFrom(
53 		address _from,
54 		address _to,
55 		uint256 _amount
56 	) returns (bool success) {
57 		if (balances[_from] >= _amount
58 			&& allowed[_from][msg.sender] >= _amount
59 			&& _amount > 0
60 			&& balances[_to] + _amount > balances[_to]) {
61 			balances[_from] -= _amount;
62 			allowed[_from][msg.sender] -= _amount;
63 			balances[_to] += _amount;
64 			Transfer(_from, _to, _amount);
65 			return true;
66 		} else {
67 			return false;
68 		}
69 	}
70 
71 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
72 		return allowed[_owner][_spender];
73 	}
74 
75 	function approve(address _spender, uint256 _amount) returns (bool success) {
76 		allowed[msg.sender][_spender] = _amount;
77 		Approval(msg.sender, _spender, _amount);
78 		return true;
79 	}
80 	//is_leap_year sets year to 12AM on new years day of the current year and sets the mining rewards
81 	function is_leap_year() private{
82 		if(now >= _year + 31557600){	
83 			_year = _year + 31557600;	//changes to new year, 1 day early on leap year, in seconds
84 			_year_count = _year_count + 1; //changes to new year in years
85 			_currentMined = 0;	//rests for current years supply
86 			_miningReward = _miningReward/2; //halved yearly starting at 100
87 			if(((_year_count-2018)%5 == 0) && (_year_count != 2018)){
88 				_maxMiningReward = _maxMiningReward/2; //halved every 5th year
89 				
90 
91 			}
92 			if((_year_count%4 == 1) && ((_year_count-1)%100 != 0)){
93 				_year = _year + 86400;	//adds a day following a leap year
94 				
95 
96 			}
97 			else if((_year_count-1)%400 == 0){
98 				_year = _year + 86400; //leap year day added on last day of leap year
99 
100 			}
101  
102 		}	
103 
104 	}
105 
106 
107 	function date_check() private returns(bool check_newyears){
108 
109 		is_leap_year(); //set the year variables and rewards
110 		//check if date is new years day
111 	    if((_year <= now) && (now <= (_year + 604800))){
112 			return true;	//it is the first week of the new year
113 		}
114 		else{
115 			return false; //it is not the first week of the new year
116 		}
117 	}
118 	
119 	function mine() returns(bool success){
120 		if(date_check() != true)
121 			revert();
122 		else if((_currentMined < _maxMiningReward) && (_maxMiningReward - _currentMined >= _miningReward)){
123 			if((_totalSupply+_miningReward) <= _maxTotalSupply){
124 				//send reward if there are tokens available and it is new years day
125 				balances[msg.sender] += _miningReward;	
126 				_currentMined += _miningReward;
127 				_totalSupply += _miningReward;
128 				Transfer(this, msg.sender, _miningReward); 
129 				return true;
130 			}
131 		else if(now > (_year + 604800)){
132 			current_remaining = _maxMiningReward - _currentMined; 
133 			if((current_remaining >= 0) && (_currentMined != 0)){
134 				_currentMined += current_remaining;
135 				Transfer(this, contract_owner, current_remaining);	//sends unmined coins for the year to _owner
136 			}
137 		}
138 		return false;
139 		}
140 		
141 	}
142 
143 	function MaxTotalSupply() constant returns(uint256)
144 	{
145 		return _maxTotalSupply;
146 	}
147 	
148 	function MiningReward() constant returns(uint256)
149 	{
150 		return _miningReward;
151 	}
152 	
153 	function MaxMiningReward() constant returns(uint256)
154 	{
155 		return _maxMiningReward;
156 	}
157 	function CurrentMined() constant returns(uint256)
158 	{
159 		return _currentMined; //amount mined so far this year
160 	}
161 
162 
163 
164 }