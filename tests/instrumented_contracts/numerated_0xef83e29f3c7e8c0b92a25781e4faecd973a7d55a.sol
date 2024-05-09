1 pragma solidity 0.4.18;
2 
3 /*
4 	Per Annum is an ERC20 token which can be mined during the first two weeks of each year for 120 years 
5 	starting in 2018. The mining reward starts at 100 tokens and is halved yearly. The maximum mining
6 	reward starts at 10,000,000 and is halved every five years. The contract owner was granted 40,000
7 	tokens on deployment of the contract, and any unmined tokens at the end of the mining period are 
8 	sent to the owner. 20,000 of the initial owner's supply will be given away in order to promote the
9 	token. 
10 
11 	
12 
13 
14 	anonymous proof of authorship - 4612370A4B007CE4AE5AEF472642F1DE55C63CEB53319C457EF1ED83F7441EA6
15 	signature - 9927A75EF7C89D3C028C8BA7A1B48CDD515ACED7A2BC564A099D452D3B3FFE89
16 */
17 contract Per_Annum{
18 	string public symbol = "ANNUM";
19 	string public name = "Per Annum";
20 	uint8 public constant decimals = 8;
21 	uint256 _totalSupply = 0;
22 	address contract_owner;
23 	uint256 current_remaining = 0; //to check for left over tokens after mining period
24 	uint256 _maxTotalSupply = 10000000000000000; //one hundred million
25 	uint256 _miningReward = 10000000000; //100 ANNUM rewarded on successful mine halved every 5 years 
26 	uint256 _maxMiningReward = 1000000000000000; //10,000,000 ANNUM - To be halved every 5 years
27 	uint256 _year = 1514782800; // 01/01/2018 12:00AM EST
28 	uint256 _year_count = 2018; //contract starts in 2018 first leap year is 2020
29 	uint256 _currentMined = 0; //mined for the year
30 
31 
32 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34     mapping(address => uint256) balances;
35     mapping(address => mapping (address => uint256)) allowed;
36 
37     //initialize contract - set owner and give owner 20,000 tokens
38     function Per_Annum(){
39     	_totalSupply += 4000000000000;
40     	_currentMined += 4000000000000;	
41     	contract_owner = msg.sender;
42     	balances[msg.sender] += 4000000000000;
43     	Transfer(this,msg.sender,4000000000000);
44     }
45 
46 	function totalSupply() constant returns (uint256) {        
47 		return _totalSupply;
48 	}
49 
50 	function balanceOf(address _owner) constant returns (uint256 balance) {
51 		return balances[_owner];
52 	}
53 
54 
55 	function transfer(address _to, uint256 _amount) returns (bool success) {
56 		if (balances[msg.sender] >= _amount 
57 			&& _amount > 0
58 			&& balances[_to] + _amount > balances[_to]) {
59 			balances[msg.sender] -= _amount;
60 			balances[_to] += _amount;
61 			Transfer(msg.sender, _to, _amount);
62 			return true;
63 		} else {
64             return false;
65 		}
66 	}
67 
68 	function transferFrom(
69 		address _from,
70 		address _to,
71 		uint256 _amount
72 	) returns (bool success) {
73 		if (balances[_from] >= _amount
74 			&& allowed[_from][msg.sender] >= _amount
75 			&& _amount > 0
76 			&& balances[_to] + _amount > balances[_to]) {
77 			balances[_from] -= _amount;
78 			allowed[_from][msg.sender] -= _amount;
79 			balances[_to] += _amount;
80 			Transfer(_from, _to, _amount);
81 			return true;
82 		} else {
83 			return false;
84 		}
85 	}
86 
87 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
88 		return allowed[_owner][_spender];
89 	}
90 
91 	function approve(address _spender, uint256 _amount) returns (bool success) {
92 		allowed[msg.sender][_spender] = _amount;
93 		Approval(msg.sender, _spender, _amount);
94 		return true;
95 	}
96 	//is_leap_year sets year to 12AM on new years day of the current year and sets the mining rewards
97 	function is_leap_year() private{
98 		if(now >= _year + 31557600){	
99 			_year = _year + 31557600;	//changes to new year, 1 day early on leap year, in seconds
100 			_year_count = _year_count + 1; //changes to new year in years
101 			_currentMined = 0;	//resets for current years supply
102 			_miningReward = _miningReward/2; //halved yearly starting at 100
103 			if(((_year_count-2018)%5 == 0) && (_year_count != 2018)){
104 				_maxMiningReward = _maxMiningReward/2; //halved every 5th year
105 				
106 
107 			}
108 			if((_year_count%4 == 1) && ((_year_count-1)%100 != 0)){
109 				_year = _year + 86400;	//adds a day following a leap year
110 				
111 
112 			}
113 			else if((_year_count-1)%400 == 0){
114 				_year = _year + 86400; //leap year day added on last day of leap year
115 
116 			}
117  
118 		}	
119 
120 	}
121 
122 
123 	function date_check() private returns(bool check_newyears){
124 
125 		is_leap_year(); //set the year variables and rewards
126 		//check if date is new years day
127 	    if((_year <= now) && (now <= (_year + 1209600))){
128 			return true;	//it is the first two weeks of the new year
129 		}
130 		else{
131 			return false; //it is not the first two weeks of the new year
132 		}
133 	}
134 	
135 	function mine() returns(bool success){
136 		if(date_check() != true){
137 			current_remaining = _maxMiningReward - _currentMined; 
138 			if((current_remaining > 0) && (_currentMined != 0)){
139 				_currentMined += current_remaining;
140 				balances[contract_owner] += current_remaining;
141 				Transfer(this, contract_owner, current_remaining);
142 				current_remaining = 0;
143 			}
144 			revert();
145 		}
146 		else if((_currentMined < _maxMiningReward) && (_maxMiningReward - _currentMined >= _miningReward)){
147 			if((_totalSupply+_miningReward) <= _maxTotalSupply){
148 				//send reward if there are tokens available and it is new years day
149 				balances[msg.sender] += _miningReward;	
150 				_currentMined += _miningReward;
151 				_totalSupply += _miningReward;
152 				Transfer(this, msg.sender, _miningReward); 
153 				return true;
154 			}
155 		
156 		}
157 		return false;
158 	}
159 
160 	function MaxTotalSupply() constant returns(uint256)
161 	{
162 		return _maxTotalSupply;
163 	}
164 	
165 	function MiningReward() constant returns(uint256)
166 	{
167 		return _miningReward;
168 	}
169 	
170 	function MaxMiningReward() constant returns(uint256)
171 	{
172 		return _maxMiningReward;
173 	}
174 	function MinedThisYear() constant returns(uint256)
175 	{
176 		return _currentMined; //amount mined so far this year
177 	}
178 
179 
180 
181 }