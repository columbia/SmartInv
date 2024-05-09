1 pragma solidity 0.5.13;
2 
3 interface Callable {
4 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
5 }
6 
7 contract DeFiFirefly {
8 
9 	uint256 constant public INITIAL_SUPPLY = 9e13; // 900,000
10 	uint256 public unallocatedEth;
11 	uint256 id;
12 	mapping(uint256 => address) idToAddress;
13 	mapping(address => bool) isUser;
14 
15 	string constant public name = "Defi Firefly";
16 	string constant public symbol = "DFF";
17 	uint8 constant public decimals = 8;
18 
19 	struct User {
20 		uint256 balance;
21 		uint256 staked;
22 		mapping(address => uint256) allowance;
23 		uint256 dividend;
24 		uint256 totalEarned;
25 		uint256 stakeTimestamp;
26 	}
27 
28 	struct Info {
29 		uint256 totalSupply;
30 		uint256 totalStaked;
31 		mapping(address => User) users;
32 		address admin;
33 	}
34 	Info public info;
35 
36 	event Transfer(address indexed from, address indexed to, uint256 tokens);
37 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
38 	event Stake(address indexed owner, uint256 tokens);
39 	event Unstake(address indexed owner, uint256 tokens);
40 	event Collect(address indexed owner, uint256 amount);
41 	event Fee(uint256 tokens);
42 	event POOLDDIVIDENDCALCULATE(uint256 totalStaked, uint256 amount,uint256 sharePerToken,uint256 eligibleMembers, uint256 totalDistributed);
43 
44 
45 	constructor() public {
46 		info.admin = msg.sender;
47 		info.totalSupply = INITIAL_SUPPLY;
48 		info.users[msg.sender].balance = INITIAL_SUPPLY;
49 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
50 		id =0;
51 		idToAddress[id] = msg.sender;
52 		isUser[msg.sender] = true;
53 		id++;
54 	}
55 
56 	function stake(uint256 _tokens) external {
57 		_stake(_tokens);
58 	}
59 
60 	function unstake(uint256 _tokens) external {
61 		_unstake(_tokens);
62 	}
63 
64 	function collectDividend() public returns (uint256) {
65 	    uint256 _dividends = dividendsOf(msg.sender);
66 		require(_dividends >= 0, "no dividends to recieve");
67 		address(uint160(msg.sender)).transfer(_dividends);
68 		emit Collect(msg.sender, _dividends);
69 		info.users[msg.sender].dividend = 0;
70 		info.users[msg.sender].totalEarned += _dividends;
71 		return _dividends;
72 	}
73 	
74 	function sendDividend() external payable onlyAdmin returns(uint256){
75 	    unallocatedEth += msg.value;
76 	    return unallocatedEth;
77 	}
78 
79 	function distribute() external onlyAdmin {
80 		require(info.totalStaked > 0,"no stakers to distribute");
81 		require(address(this).balance > 0, "no dividend to distribute");
82 		uint256 share;
83 		uint256 count;
84 		uint256 distributed;
85 		share = div(unallocatedEth, div(info.totalStaked,1e8,"division error"),"invaid holding supply" );
86 		for(uint256 i=1; i<id; i++){
87             if(stakedOf(idToAddress[i]) >0){
88                 info.users[idToAddress[i]].dividend += mul(share, div(stakedOf(idToAddress[i]),1e8,"division error"));
89                 distributed += mul(share, div(stakedOf(idToAddress[i]),1e8,"division error"));
90                 count++;
91             }
92         }
93         emit POOLDDIVIDENDCALCULATE(info.totalStaked, unallocatedEth, share, count, distributed);
94         address(uint160(info.admin)).transfer(unallocatedEth - distributed);
95         if(share > 0){
96             unallocatedEth = 0;
97         }
98 	}
99 
100 	function transfer(address _to, uint256 _tokens) external returns (bool) {
101 		_transfer(msg.sender, _to, _tokens);
102 		return true;
103 	}
104 
105 	function approve(address _spender, uint256 _tokens) external returns (bool) {
106 		info.users[msg.sender].allowance[_spender] = _tokens;
107 		emit Approval(msg.sender, _spender, _tokens);
108 		return true;
109 	}
110 
111 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
112 		require(info.users[_from].allowance[msg.sender] >= _tokens);
113 		info.users[_from].allowance[msg.sender] -= _tokens;
114 		_transfer(_from, _to, _tokens);
115 		return true;
116 	}
117 
118 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
119 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
120 		uint32 _size;
121 		assembly {
122 			_size := extcodesize(_to)
123 		}
124 		if (_size > 0) {
125 			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
126 		}
127 		return true;
128 	}
129 
130 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
131 		require(_receivers.length == _amounts.length);
132 		for (uint256 i = 0; i < _receivers.length; i++) {
133 			_transfer(msg.sender, _receivers[i], _amounts[i]);
134 		}
135 	}
136 
137 	function totalSupply() public view returns (uint256) {
138 		return info.totalSupply;
139 	}
140 
141 	function totalStaked() public view returns (uint256) {
142 		return info.totalStaked;
143 	}
144 
145 	function balanceOf(address _user) public view returns (uint256) {
146 		return info.users[_user].balance - stakedOf(_user);
147 	}
148 
149 	function stakedOf(address _user) public view returns (uint256) {
150 		return info.users[_user].staked;
151 	}
152 
153 	function dividendsOf(address _user) public view returns (uint256) {
154         return	info.users[_user].dividend;
155 	}
156 
157 	function allowance(address _user, address _spender) public view returns (uint256) {
158 		return info.users[_user].allowance[_spender];
159 	}
160 	
161 	function userTotalEarned(address _user) public view returns(uint256){
162 	    return info.users[_user].totalEarned;
163 	}
164 	
165 	modifier onlyAdmin(){
166         require(msg.sender == info.admin,"only admin can change transaction fee ");
167         _;
168     }
169     
170     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b > 0, errorMessage);
172         uint256 c = a / b;
173         return c;
174     }
175     
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         if (a == 0) {
178             return 0;
179         }
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182         return c;
183     }
184 
185 	function allInfoFor(address _user) public view returns (uint256 userBalance, uint256 userStaked, uint256 userDividends,uint256 totalEarned) {
186 		return ( balanceOf(_user), stakedOf(_user), dividendsOf(_user),userTotalEarned(_user));
187 	}
188 
189     function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
190 		require(balanceOf(_from) >= _tokens, "insufficient funds");
191 		if(!isUser[_to]){
192 		    idToAddress[id] = _to;
193 		    isUser[_to] = true;
194 		    id++;
195 		}
196 		info.users[_from].balance -= _tokens;
197         info.users[_to].balance += _tokens;
198         emit Transfer(_from, _to, _tokens);
199         return _tokens;
200     }
201 
202 	function _stake(uint256 _amount) internal {
203 		require(balanceOf(msg.sender) >= _amount, "insufficient funds");
204 		info.totalStaked += _amount;
205 		info.users[msg.sender].staked += _amount;
206 		info.users[msg.sender].stakeTimestamp = now;
207 		emit Transfer(msg.sender, address(this), _amount);
208 		emit Stake(msg.sender, _amount);
209 	}
210 
211     function _unstake(uint256 _amount) internal {
212 		require(stakedOf(msg.sender) >= _amount,"user stake already 0");
213 		require(info.users[msg.sender].stakeTimestamp + 24 hours <= now,"must wait 24 hours before unstaking");
214 		if(dividendsOf(msg.sender)>0){
215 		    collectDividend();
216 		}
217 		info.totalStaked -= _amount;
218 		info.users[msg.sender].staked -= _amount;
219 		emit Unstake(msg.sender, _amount);
220 	}
221 }