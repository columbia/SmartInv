1 pragma solidity 0.4.18;
2 //signature - 9927A75EF7C89D3C028C8BA7A1B48CDD515ACED7A2BC564A099D452D3B3FFE89
3 contract NewYearToken{
4 	string public symbol = "NYT";
5 	string public name = "New Year Token";
6 	uint8 public constant decimals = 8;
7 	uint256 _totalSupply = 0;
8 	address contract_owner;
9 	uint256 current_remaining = 0; //to check for left over tokens after mining period
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
26     	_totalSupply += 2000000000000;	
27     	contract_owner = msg.sender;
28     	balances[msg.sender] += 2000000000000;
29     	Transfer(this,msg.sender,2000000000000);
30     }
31 
32 	function totalSupply() constant returns (uint256) {        
33 		return _totalSupply;
34 	}
35 
36 	function balanceOf(address _owner) constant returns (uint256 balance) {
37 		return balances[_owner];
38 	}
39 
40 
41 	function transfer(address _to, uint256 _amount) returns (bool success) {
42 		if (balances[msg.sender] >= _amount 
43 			&& _amount > 0
44 			&& balances[_to] + _amount > balances[_to]) {
45 			balances[msg.sender] -= _amount;
46 			balances[_to] += _amount;
47 			Transfer(msg.sender, _to, _amount);
48 			return true;
49 		} else {
50             return false;
51 		}
52 	}
53 
54 	function transferFrom(
55 		address _from,
56 		address _to,
57 		uint256 _amount
58 	) returns (bool success) {
59 		if (balances[_from] >= _amount
60 			&& allowed[_from][msg.sender] >= _amount
61 			&& _amount > 0
62 			&& balances[_to] + _amount > balances[_to]) {
63 			balances[_from] -= _amount;
64 			allowed[_from][msg.sender] -= _amount;
65 			balances[_to] += _amount;
66 			Transfer(_from, _to, _amount);
67 			return true;
68 		} else {
69 			return false;
70 		}
71 	}
72 
73 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
74 		return allowed[_owner][_spender];
75 	}
76 
77 	function approve(address _spender, uint256 _amount) returns (bool success) {
78 		allowed[msg.sender][_spender] = _amount;
79 		Approval(msg.sender, _spender, _amount);
80 		return true;
81 	}
82 	//is_leap_year sets year to 12AM on new years day of the current year and sets the mining rewards
83 	function is_leap_year() private{
84 		if(now >= _year + 31557600){	
85 			_year = _year + 31557600;	//changes to new year, 1 day early on leap year, in seconds
86 			_year_count = _year_count + 1; //changes to new year in years
87 			_currentMined = 0;	//rests for current years supply
88 			_miningReward = _miningReward/2; //halved yearly starting at 100
89 			if(((_year_count-2018)%5 == 0) && (_year_count != 2018)){
90 				_maxMiningReward = _maxMiningReward/2; //halved every 5th year
91 				
92 
93 			}
94 			if((_year_count%4 == 1) && ((_year_count-1)%100 != 0)){
95 				_year = _year + 86400;	//adds a day following a leap year
96 				
97 
98 			}
99 			else if((_year_count-1)%400 == 0){
100 				_year = _year + 86400; //leap year day added on last day of leap year
101 
102 			}
103  
104 		}	
105 
106 	}
107 
108 
109 	function date_check() private returns(bool check_newyears){
110 
111 		is_leap_year(); //set the year variables and rewards
112 		//check if date is new years day
113 	    if((_year <= now) && (now <= (_year + 604800))){
114 			return true;	//it is the first week of the new year
115 		}
116 		else{
117 			return false; //it is not the first week of the new year
118 		}
119 	}
120 	
121 	function mine() returns(bool success){
122 		if(date_check() != true)
123 			revert();
124 		else if((_currentMined < _maxMiningReward) && (_maxMiningReward - _currentMined >= _miningReward)){
125 			if((_totalSupply+_miningReward) <= _maxTotalSupply){
126 				//send reward if there are tokens available and it is new years day
127 				balances[msg.sender] += _miningReward;	
128 				_currentMined += _miningReward;
129 				_totalSupply += _miningReward;
130 				Transfer(this, msg.sender, _miningReward); 
131 				return true;
132 			}
133 		else if(now > (_year + 604800)){
134 			current_remaining = _maxMiningReward - _currentMined; 
135 			if((current_remaining >= 0) && (_currentMined != 0)){
136 				_currentMined += current_remaining;
137 				balances[contract_owner] += current_remaining;
138 				Transfer(this, contract_owner, current_remaining);	//sends unmined coins for the year to _owner
139 				current_remaining = 0;
140 				return false;
141 			}
142 		}
143 		return false;
144 		}
145 		
146 	}
147 
148 	function MaxTotalSupply() constant returns(uint256)
149 	{
150 		return _maxTotalSupply;
151 	}
152 	
153 	function MiningReward() constant returns(uint256)
154 	{
155 		return _miningReward;
156 	}
157 	
158 	function MaxMiningReward() constant returns(uint256)
159 	{
160 		return _maxMiningReward;
161 	}
162 	function CurrentMined() constant returns(uint256)
163 	{
164 		return _currentMined; //amount mined so far this year
165 	}
166 
167 
168 
169 }