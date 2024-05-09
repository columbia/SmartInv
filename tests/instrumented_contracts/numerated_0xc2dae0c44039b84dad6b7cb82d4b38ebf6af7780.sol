1 pragma solidity 0.5.13;
2 
3 //CHADs, if you cloned it, don't be BADASS and send some tokens here: 0x21eb0E524B7f68D8B8B1d8b670df182b797faAF0
4 
5 //Happy CODING!!!
6 
7 contract Contract {
8 
9 	uint256 constant private TOKEN_PRECISION = 1e6;
10 	uint256 constant private PRECISION = 1e12;
11 	
12 	uint256 constant private initial_supply = 6 * TOKEN_PRECISION;
13 	uint256 constant private max_supply = 3000 * TOKEN_PRECISION;
14 	    
15 	string constant public name = "TIM3";
16 	string constant public symbol = "TIM3";
17 	
18 	uint8 constant public decimals = 6;
19 	
20     uint256 constant private round = 60 seconds;
21     uint256 constant private partOfToken = 60;
22   
23 	struct User {
24 		uint256 balance;
25 		mapping(address => uint256) allowance;
26 		uint256 appliedTokenCirculation;
27 	}
28 
29 	struct Info {
30 		uint256 totalSupply;
31 		mapping(address => User) users;
32 		address admin;
33         uint256 coinWorkingTime;
34         uint256 coinCreationTime;
35         address uniswapV2PairAddress;
36         bool initialSetup;
37         uint256 maxSupply;
38 	}
39 
40 	Info private info;
41 	
42 	event Transfer(address indexed from, address indexed to, uint256 tokens);
43 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
44 	
45 	constructor() public {
46 	    info.coinWorkingTime = now;
47 	    info.coinCreationTime = now;
48 	    info.uniswapV2PairAddress = address(0);
49 	     
50 		info.admin = msg.sender;
51 		info.totalSupply = initial_supply;
52 		info.maxSupply = initial_supply;
53 		 
54 		info.users[msg.sender].balance = initial_supply;
55 		info.users[msg.sender].appliedTokenCirculation = initial_supply;
56 		
57 		info.initialSetup = false;
58 	}
59 	
60 	// start once during initialization
61     function setUniswapAddress (address _uniswapV2PairAddress) public {
62         require(msg.sender == info.admin);
63         require(!info.initialSetup);
64         info.uniswapV2PairAddress = _uniswapV2PairAddress;
65         info.initialSetup = true; // close system
66         info.maxSupply = max_supply; // change max supply and start rebase system
67         info.coinWorkingTime = now;
68 	    info.coinCreationTime = now;
69 		info.users[_uniswapV2PairAddress].appliedTokenCirculation = info.totalSupply;
70 		info.users[address(this)].appliedTokenCirculation = info.totalSupply;
71     }
72     
73 	function uniswapAddress() public view returns (address) {
74 	    return info.uniswapV2PairAddress;
75 	}
76 
77 	function totalSupply() public view returns (uint256) {
78 	    uint256 countOfCoinsToAdd = ((now - info.coinCreationTime) / round);
79         uint256 realTotalSupply = initial_supply + (((countOfCoinsToAdd) * TOKEN_PRECISION) / partOfToken);
80         
81         if(realTotalSupply >= info.maxSupply)
82         {
83             realTotalSupply = info.maxSupply;
84         }
85         
86 		return realTotalSupply;
87 	}
88 	
89 	function balanceOfTokenCirculation(address _user) private view returns (uint256) {
90 		return info.users[_user].appliedTokenCirculation;
91 	}
92 
93 	function balanceOf(address _user) public view returns (uint256) {
94 		return info.users[_user].balance;
95 	}
96 
97 	function allowance(address _user, address _spender) public view returns (uint256) {
98 		return info.users[_user].allowance[_spender];
99 	}
100 
101 	function allUserBalances(address _user) public view returns (uint256 totalTokenSupply, uint256 userTokenCirculation, uint256 userBalance, uint256 realUserBalance) {
102 		return (totalSupply(), balanceOfTokenCirculation(_user), balanceOf(_user), realUserTokenBalance(_user));
103 	}
104 	
105 	function realUserTokenBalance(address _user)  private view returns (uint256 totalTokenSupply)
106 	{
107 	    uint256 countOfCoinsToAdd = ((now - info.coinCreationTime) / round);
108         uint256 realTotalSupply = initial_supply + (((countOfCoinsToAdd) * TOKEN_PRECISION) / partOfToken);
109         
110         if(realTotalSupply >= info.maxSupply)
111         {
112             realTotalSupply = info.maxSupply;
113         }
114         
115 	    uint256 AppliedTokenCirculation = info.users[_user].appliedTokenCirculation; 
116         uint256 addressBalance = info.users[_user].balance;
117        
118         uint256 adjustedAddressBalance = ((((addressBalance * PRECISION)) / AppliedTokenCirculation) * realTotalSupply) / PRECISION;
119   
120         return (adjustedAddressBalance);
121 	}
122 	
123 	function approve(address _spender, uint256 _tokens) external returns (bool) {
124 		info.users[msg.sender].allowance[_spender] = _tokens;
125 		emit Approval(msg.sender, _spender, _tokens);
126 		return true;
127 	}
128 	
129 	function transfer(address _to, uint256 _tokens) external returns (bool) {
130 		_transfer(msg.sender, _to, _tokens);
131 		return true;
132 	}
133 
134 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
135 		require(info.users[_from].allowance[msg.sender] >= _tokens);
136 		info.users[_from].allowance[msg.sender] -= _tokens;
137 		_transfer(_from, _to, _tokens);
138 		return true;
139 	}
140 	
141 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
142 
143 	 	require(balanceOf(_from) >= _tokens && balanceOf(_from) >= 1);
144 	 	
145 	 	uint256 _transferred = 0;
146 	 	
147         bool isNewUser = info.users[_to].balance == 0;
148         		
149         if(isNewUser)
150         {
151             info.users[_to].appliedTokenCirculation = info.totalSupply;
152         }
153         
154         if(info.coinWorkingTime + round < now)
155         {
156             uint256 countOfCoinsToAdd = ((now - info.coinCreationTime) / round); 
157             info.coinWorkingTime = now;
158           
159             info.totalSupply = initial_supply + (((countOfCoinsToAdd) * TOKEN_PRECISION) / partOfToken);
160             
161             if(info.totalSupply >= info.maxSupply)
162             {
163                 info.totalSupply = info.maxSupply;
164             }
165         }
166         
167         info.users[_from].balance = ((((info.users[_from].balance * PRECISION) / info.users[_from].appliedTokenCirculation) * info.totalSupply)) / PRECISION;
168         info.users[_to].balance = ((((info.users[_to].balance * PRECISION) / info.users[_to].appliedTokenCirculation) * info.totalSupply)) / PRECISION;
169         
170         uint256 adjustedTokens = (((((_tokens * PRECISION) / info.users[_from].appliedTokenCirculation) * info.totalSupply)) / PRECISION);
171         
172         if(info.uniswapV2PairAddress != address(0)){
173 			info.users[info.uniswapV2PairAddress].balance = ((((info.users[info.uniswapV2PairAddress].balance * PRECISION) / info.users[info.uniswapV2PairAddress].appliedTokenCirculation) * info.totalSupply)) / PRECISION;
174 			info.users[address(this)].balance = ((((info.users[address(this)].balance * PRECISION) / info.users[address(this)].appliedTokenCirculation) * info.totalSupply)) / PRECISION;
175             
176 			info.users[_from].balance -= adjustedTokens;
177             _transferred = adjustedTokens;
178             
179             uint256 burnToLP = ((adjustedTokens * 4) / 100); // 4% transaction fee
180             uint256 burnToHell = ((adjustedTokens * 2) / 100); // 2% transaction fee
181             info.users[_to].balance += ((_transferred - burnToLP) - burnToHell);
182             
183             info.users[info.uniswapV2PairAddress].balance += (burnToLP);
184             info.users[address(this)].balance += (burnToHell);
185 
186 			info.users[info.uniswapV2PairAddress].appliedTokenCirculation = info.totalSupply;
187         	info.users[address(this)].appliedTokenCirculation = info.totalSupply;
188         }else{
189             info.users[_from].balance -= adjustedTokens;
190             _transferred = adjustedTokens;
191             info.users[_to].balance += _transferred;
192         }
193         
194         info.users[_from].appliedTokenCirculation = info.totalSupply;
195         info.users[_to].appliedTokenCirculation = info.totalSupply;
196 
197 		emit Transfer(_from, _to, _transferred);
198 	
199 		return _transferred;
200 	}
201 }