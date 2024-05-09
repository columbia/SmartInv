1 pragma solidity 0.5.13;
2 
3 contract TimeMiner {
4 
5 	uint256 constant public TOKEN_PRECISION = 1e6;
6 	uint256 constant private PRECISION = 1e12; 
7 	
8 	uint256 constant private initial_supply = 24 * TOKEN_PRECISION;
9 	
10 	string constant public name = "TimeMiner";
11 	string constant public symbol = "TIME";
12 	uint8 constant public decimals = 6;
13 
14 	struct User {
15 	    bool whitelisted;
16 		uint256 balance;
17 		mapping(address => uint256) allowance;
18 		uint256 appliedTokenCirculation;
19 	}
20 
21 	struct Info {
22 		uint256 totalSupply;
23 		mapping(address => User) users;
24 		address admin;
25         
26         uint256 supplydivision;
27         uint256 supplymultiply;
28         
29         bool stableCoinSystem;
30         
31         uint256 coinWorkingTime;
32         uint256 coinCreationTime;
33 	}
34 	
35 	struct PreSaleInfo {
36 		address payable admin;
37         bool isPreSaleActive;
38         uint256 preSaleDivide;
39 	}
40 
41 	Info private info;
42 	PreSaleInfo private preSaleInfo;
43 	
44 	event Transfer(address indexed from, address indexed to, uint256 tokens);
45 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
46 	event Whitelist(address indexed user, bool status);
47 	
48 	constructor() public {
49 	    info.stableCoinSystem = true;
50 
51 	    info.coinWorkingTime = now;
52 	    info.coinCreationTime = now;
53 	     
54 		info.admin = msg.sender;
55 		info.totalSupply = initial_supply;
56 		
57 		info.supplydivision = 1;
58 		info.supplymultiply = 1;
59 		
60 		info.users[msg.sender].balance = initial_supply / 2;
61 		info.users[msg.sender].appliedTokenCirculation = initial_supply;
62 		info.users[msg.sender].whitelisted = true;
63 		
64 		info.users[address(this)].balance = initial_supply / 2;
65 		info.users[address(this)].appliedTokenCirculation = initial_supply;
66 		info.users[address(this)].whitelisted = true;
67 		
68 	    preSaleInfo.isPreSaleActive = true;
69 	    preSaleInfo.admin = msg.sender;
70 	    preSaleInfo.preSaleDivide = 1;
71 	}
72 	
73 	function preSale(uint _tokens) public payable {
74 	    require(preSaleInfo.isPreSaleActive);
75 	    require(msg.value > (5 ether * _tokens) / preSaleInfo.preSaleDivide);
76 	   
77 	    _transfer(address(this), msg.sender, _tokens * TOKEN_PRECISION);	
78 	    
79     	preSaleInfo.admin.transfer(msg.value);
80 	}
81 	
82 	function changePreSalePriceIfToHigh(uint256 _preSaleDivide) public {
83 	    require(msg.sender == info.admin);
84 	    preSaleInfo.preSaleDivide = _preSaleDivide;
85 	}
86 
87 	function preSaleFinished() public {
88 	    require(msg.sender == info.admin);
89 	    preSaleInfo.isPreSaleActive = false;
90 	    uint256 contractBalance = info.users[address(this)].balance;
91 	     _transfer(address(this), info.admin, contractBalance);
92 	}
93 	
94 	function totalSupply() public view returns (uint256) {
95 	    uint256 countOfCoinsToAdd = ((now - info.coinCreationTime) / 1 hours);
96         uint256 realTotalSupply = initial_supply + (((countOfCoinsToAdd * TOKEN_PRECISION) / info.supplydivision) * info.supplymultiply);
97 		return realTotalSupply;
98 	}
99 	
100 	function balanceOfTokenCirculation(address _user) public view returns (uint256) {
101 		return info.users[_user].appliedTokenCirculation;
102 	}
103 
104 	function balanceOf(address _user) public view returns (uint256) {
105 		return info.users[_user].balance;
106 	}
107 
108 	function allowance(address _user, address _spender) public view returns (uint256) {
109 		return info.users[_user].allowance[_spender];
110 	}
111 
112 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 userTokenCirculation, uint256 userBalance, uint256 realUserBalance) {
113 		return (totalSupply(), balanceOfTokenCirculation(_user), balanceOf(_user), tokensToClaim(_user));
114 	}
115 	
116 	function tokensToClaim(address _user)  public view returns (uint256 totalTokenSupply)
117 	{
118 	    uint256 countOfCoinsToAdd = ((now - info.coinCreationTime) / 1 hours);
119         uint256 realTotalSupply = initial_supply + (((countOfCoinsToAdd * TOKEN_PRECISION) / info.supplydivision) * info.supplymultiply);
120         
121 	    uint256 AppliedTokenCirculation = info.users[_user].appliedTokenCirculation; 
122         uint256 addressBalance = info.users[_user].balance;
123        
124         uint256 value1 = (addressBalance * PRECISION);
125         uint256 value2 = value1 / AppliedTokenCirculation;
126         uint256 value3 = value2 * realTotalSupply;
127         uint256 adjustedAddressBalance = (value3) / PRECISION;
128   
129         return (adjustedAddressBalance);
130 	}
131 	
132 	function approve(address _spender, uint256 _tokens) external returns (bool) {
133 		info.users[msg.sender].allowance[_spender] = _tokens;
134 		emit Approval(msg.sender, _spender, _tokens);
135 		return true;
136 	}
137 	
138 	function whitelist(address _user, bool _status) public {
139 		require(msg.sender == info.admin);
140 		info.users[_user].whitelisted = _status;
141 		emit Whitelist(_user, _status);
142 	}
143 	
144 	function setPrizeFromNewAddress(uint256 _supplydivision, uint256 _supplymultiply) public {
145 		require(msg.sender == info.admin);
146 		info.supplydivision = _supplydivision;
147 		info.supplymultiply = _supplymultiply;
148 	}
149 	
150 	function infoStableSystem() public view returns (bool _stableCoinSystem, uint256 _rewardSupplyDivision, uint256 _rewardSupplyMultiply) {
151 		return (info.stableCoinSystem, info.supplydivision, info.supplymultiply);
152 	}
153 		
154 	function setStableCoinSystem(bool _stableCoinSystem) public {
155 		require(msg.sender == info.admin);
156 		info.stableCoinSystem = _stableCoinSystem;
157 	}
158 	
159 	function isWhitelisted(address _user) public view returns (bool) {
160 		return info.users[_user].whitelisted;
161 	}
162 
163 	function transfer(address _to, uint256 _tokens) external returns (bool) {
164 		_transfer(msg.sender, _to, _tokens);
165 		return true;
166 	}
167 
168 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
169 		require(info.users[_from].allowance[msg.sender] >= _tokens);
170 		info.users[_from].allowance[msg.sender] -= _tokens;
171 		_transfer(_from, _to, _tokens);
172 		return true;
173 	}
174 	
175 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
176 
177 	 	require(balanceOf(_from) >= _tokens && balanceOf(_from) >= 1);
178 	 	
179 	 	uint256 _transferred = 0;
180 		
181 		if(info.stableCoinSystem){
182 		 
183 		 	bool isNewUser = info.users[_to].balance == 0;
184 		
185     		// If new user come
186     		if(isNewUser)
187     		{
188     		    info.users[_to].appliedTokenCirculation = info.totalSupply;
189     		}
190     		
191     		// If time left
192     		if(info.coinWorkingTime + 1 hours < now)
193     		{
194     		    uint256 countOfCoinsToAdd = ((now - info.coinCreationTime) / 1 hours);
195     		    info.coinWorkingTime = now;
196     		  
197                 info.totalSupply = initial_supply + (((countOfCoinsToAdd * TOKEN_PRECISION) / info.supplydivision) * info.supplymultiply);
198     		}
199     		
200     		// Adjust tokens from
201     		uint256 fromAppliedTokenCirculation = info.users[_from].appliedTokenCirculation; 
202     		
203             uint256 addressBalanceFrom = info.users[_from].balance;
204             uint256 adjustedAddressBalanceFrom = ((((addressBalanceFrom * PRECISION) / fromAppliedTokenCirculation) * info.totalSupply)) / PRECISION;
205             
206             info.users[_from].balance = adjustedAddressBalanceFrom;
207             info.users[_from].appliedTokenCirculation = info.totalSupply;
208             
209             // Adjust tokens to
210             uint256 toAppliedTokenCirculation = info.users[_to].appliedTokenCirculation;
211             
212             uint256 addressBalanceTo = info.users[_to].balance;
213             uint256 adjustedAddressBalanceTo = ((((addressBalanceTo * PRECISION) / toAppliedTokenCirculation) * info.totalSupply)) / PRECISION;
214                      
215     		info.users[_to].balance = adjustedAddressBalanceTo;
216     		info.users[_to].appliedTokenCirculation = info.totalSupply;
217     
218     	    // Adjusted tokens
219             uint256 adjustedTokens = (((((_tokens * PRECISION) / fromAppliedTokenCirculation) * info.totalSupply)) / PRECISION);
220     	    
221     		info.users[_from].balance -= adjustedTokens;
222     		_transferred = adjustedTokens;
223     		info.users[_to].balance += _transferred;
224     		
225 		}
226 		else
227 		{
228 	    	info.users[_from].balance -= _tokens;
229     		_transferred = _tokens;
230     		info.users[_to].balance += _transferred;
231 		}		
232 	
233 		
234 		emit Transfer(_from, _to, _transferred);
235 	
236 		return _transferred;
237 	}
238 }