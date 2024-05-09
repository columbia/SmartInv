1 pragma solidity ^0.4.24;
2 
3 interface ERC20 {
4 	
5 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
6 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
7 	
8 	function name() external view returns (string);
9 	function symbol() external view returns (string);
10 	function decimals() external view returns (uint8);
11 	
12 	function totalSupply() external view returns (uint256);
13 	function balanceOf(address _owner) external view returns (uint256 balance);
14 	function transfer(address _to, uint256 _value) external payable returns (bool success);
15 	function transferFrom(address _from, address _to, uint256 _value) external payable returns (bool success);
16 	function approve(address _spender, uint256 _value) external payable returns (bool success);
17 	function allowance(address _owner, address _spender) external view returns (uint256 remaining);
18 }
19 
20 interface ERC165 {
21     /// @notice Query if a contract implements an interface
22     /// @param interfaceID The interface identifier, as specified in ERC-165
23     /// @dev Interface identification is specified in ERC-165. This function
24     ///  uses less than 30,000 gas.
25     /// @return `true` if the contract implements `interfaceID` and
26     ///  `interfaceID` is not 0xffffffff, `false` otherwise
27     function supportsInterface(bytes4 interfaceID) external view returns (bool);
28 }
29 
30 // 숫자 계산 시 오버플로우 문제를 방지하기 위한 라이브러리
31 library SafeMath {
32 	
33 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34 		c = a + b;
35 		assert(c >= a);
36 		return c;
37 	}
38 	
39 	function sub(uint256 a, uint256 b) pure internal returns (uint256 c) {
40 		assert(b <= a);
41 		return a - b;
42 	}
43 	
44 	function mul(uint256 a, uint256 b) pure internal returns (uint256 c) {
45 		if (a == 0) {
46 			return 0;
47 		}
48 		c = a * b;
49 		assert(c / a == b);
50 		return c;
51 	}
52 	
53 	function div(uint256 a, uint256 b) pure internal returns (uint256 c) {
54 		return a / b;
55 	}
56 }
57 
58 contract RankCoin is ERC20, ERC165 {
59 	using SafeMath for uint256;
60 	
61 	event ChangeName(address indexed user, string name);
62 	event ChangeMessage(address indexed user, string message);
63 	
64 	// 토큰 정보
65 	string constant public NAME = "RankCoin";
66 	string constant public SYMBOL = "RC";
67 	uint8 constant public DECIMALS = 18;
68 	uint256 constant public TOTAL_SUPPLY = 100000000000 * (10 ** uint256(DECIMALS));
69 	
70 	address public author;
71 	
72 	mapping(address => uint256) public balances;
73 	mapping(address => mapping(address => uint256)) public allowed;
74 	
75 	// 사용자들 주소
76 	address[] public users;
77 	mapping(address => string) public names;
78 	mapping(address => string) public messages;
79 	
80 	function getUserCount() view public returns (uint256) {
81 		return users.length;
82 	}
83 	
84 	// 유저가 이미 존재하는지
85 	mapping(address => bool) internal userToIsExisted;
86 	
87 	constructor() public {
88 		
89 		author = msg.sender;
90 		
91 		balances[author] = TOTAL_SUPPLY;
92 		
93 		emit Transfer(0x0, author, TOTAL_SUPPLY);
94 	}
95 	
96 	// 주소를 잘못 사용하는 것인지 체크
97 	function checkAddressMisused(address target) internal view returns (bool) {
98 		return
99 			target == address(0) ||
100 			target == address(this);
101 	}
102 	
103 	//ERC20: 토큰의 이름 반환
104 	function name() external view returns (string) {
105 		return NAME;
106 	}
107 	
108 	//ERC20: 토큰의 심볼 반환
109 	function symbol() external view returns (string) {
110 		return SYMBOL;
111 	}
112 	
113 	//ERC20: 토큰의 소수점 반환
114 	function decimals() external view returns (uint8) {
115 		return DECIMALS;
116 	}
117 	
118 	//ERC20: 전체 토큰 수 반환
119 	function totalSupply() external view returns (uint256) {
120 		return TOTAL_SUPPLY;
121 	}
122 	
123 	//ERC20: 특정 유저의 토큰 수를 반환합니다.
124 	function balanceOf(address user) external view returns (uint256 balance) {
125 		return balances[user];
126 	}
127 	
128 	//ERC20: 특정 유저에게 토큰을 전송합니다.
129 	function transfer(address to, uint256 amount) external payable returns (bool success) {
130 		
131 		// 주소 오용 차단
132 		require(checkAddressMisused(to) != true);
133 		
134 		require(amount <= balances[msg.sender]);
135 		
136 		balances[msg.sender] = balances[msg.sender].sub(amount);
137 		balances[to] = balances[to].add(amount);
138 		
139 		// 유저 주소 등록
140 		if (to != author && userToIsExisted[to] != true) {
141 			users.push(to);
142 			userToIsExisted[to] = true;
143 		}
144 		
145 		emit Transfer(msg.sender, to, amount);
146 		
147 		return true;
148 	}
149 	
150 	//ERC20: spender에 amount만큼의 토큰을 보낼 권리를 부여합니다.
151 	function approve(address spender, uint256 amount) external payable returns (bool success) {
152 		
153 		allowed[msg.sender][spender] = amount;
154 		
155 		emit Approval(msg.sender, spender, amount);
156 		
157 		return true;
158 	}
159 	
160 	//ERC20: spender에 인출을 허락한 토큰의 양을 반환합니다.
161 	function allowance(address user, address spender) external view returns (uint256 remaining) {
162 		return allowed[user][spender];
163 	}
164 	
165 	//ERC20: 허락된 spender가 from으로부터 amount만큼의 토큰을 to에게 전송합니다.
166 	function transferFrom(address from, address to, uint256 amount) external payable returns (bool success) {
167 		
168 		// 주소 오용 차단
169 		require(checkAddressMisused(to) != true);
170 		
171 		require(amount <= balances[from]);
172 		require(amount <= allowed[from][msg.sender]);
173 		
174 		balances[from] = balances[from].sub(amount);
175 		balances[to] = balances[to].add(amount);
176 		
177 		// 유저 주소 등록
178 		if (to != author && userToIsExisted[to] != true) {
179 			users.push(to);
180 			userToIsExisted[to] = true;
181 		}
182 		
183 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
184 		
185 		emit Transfer(from, to, amount);
186 		
187 		return true;
188 	}
189 	
190 	// 토큰을 많이 가진 순서대로 유저 목록을 가져옵니다.
191 	function getUsersByBalance() view public returns (address[]) {
192 		address[] memory _users = new address[](users.length);
193 		
194 		for (uint256 i = 0; i < users.length; i += 1) {
195 			
196 			uint256 balance = balances[users[i]];
197 			
198 			for (uint256 j = i; j > 0; j -= 1) {
199 				if (balances[_users[j - 1]] < balance) {
200 					_users[j] = _users[j - 1];
201 				} else {
202 					break;
203 				}
204 			}
205 			
206 			_users[j] = users[i];
207 		}
208 		
209 		return _users;
210 	}
211 	
212 	// 특정 유저의 랭킹을 가져옵니다.
213 	function getRank(address user) view public returns (uint256) {
214 		
215 		uint256 rank = 1;
216 		uint256 balance = balances[user];
217 		
218 		for (uint256 i = 0; i < users.length; i += 1) {
219 			if (balances[users[i]] > balance) {
220 				rank += 1;
221 			}
222 		}
223 		
224 		return rank;
225 	}
226 	
227 	// 이름을 지정합니다.
228 	function setName(string _name) public {
229 		
230 		names[msg.sender] = _name;
231 		
232 		emit ChangeName(msg.sender, _name);
233 	}
234 	
235 	// 메시지를 지정합니다.
236 	function setMessage(string message) public {
237 		
238 		messages[msg.sender] = message;
239 		
240 		emit ChangeMessage(msg.sender, message);
241 	}
242 	
243 	//ERC165: 주어진 인터페이스가 구현되어 있는지 확인합니다.
244 	function supportsInterface(bytes4 interfaceID) external view returns (bool) {
245 		return
246 			// ERC165
247 			interfaceID == this.supportsInterface.selector ||
248 			// ERC20
249 			interfaceID == 0x942e8b22 ||
250 			interfaceID == 0x36372b07;
251 	}
252 }