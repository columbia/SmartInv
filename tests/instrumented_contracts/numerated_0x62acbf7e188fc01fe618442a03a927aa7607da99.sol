1 pragma solidity ^0.4.23;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal pure returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeSub(uint a, uint b) internal pure returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function safeAdd(uint a, uint b) internal pure returns (uint) {
16     uint c = a + b;
17     assert(c>=a && c>=b);
18     return c;
19   }
20 
21   // mitigate short address attack
22   // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
23   modifier onlyPayloadSize(uint numWords) {
24      assert(msg.data.length >= numWords * 32 + 4);
25      _;
26   }
27 }
28 
29 // ERC20 standard
30 contract Token {
31     function balanceOf(address _owner) public  view returns (uint256 balance);
32     function transfer(address _to, uint256 _value) public returns (bool success);
33     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
34     function approve(address _spender, uint256 _value)  public returns (bool success);
35     function allowance(address _owner, address _spender) public  view returns (uint256 remaining);
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 contract StandardToken is Token, SafeMath {
41     uint256 public totalSupply;
42 
43     function transfer(address _to, uint256 _value) public  onlyPayloadSize(2) returns (bool success) {
44         require(_to != address(0));
45         require(balances[msg.sender] >= _value && _value > 0);
46         balances[msg.sender] = safeSub(balances[msg.sender], _value);
47         balances[_to] = safeAdd(balances[_to], _value);
48         emit Transfer(msg.sender, _to, _value);
49         return true;
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool success) {
53         require(_to != address(0));
54         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
55         balances[_from] = safeSub(balances[_from], _value);
56         balances[_to] = safeAdd(balances[_to], _value);
57         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
58         emit Transfer(_from, _to, _value);
59         return true;
60     }
61 
62     function balanceOf(address _owner) public view returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     // To change the approve amount you first have to reduce the addresses'
67     //  allowance to zero by calling 'approve(_spender, 0)' if it is not
68     //  already 0 to mitigate the race condition described here:
69     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70     function approve(address _spender, uint256 _value) public onlyPayloadSize(2) returns (bool success) {
71         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
72         allowed[msg.sender][_spender] = _value;
73         emit Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) public onlyPayloadSize(3) returns (bool success) {
78         require(allowed[msg.sender][_spender] == _oldValue);
79         allowed[msg.sender][_spender] = _newValue;
80         emit Approval(msg.sender, _spender, _newValue);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
85       return allowed[_owner][_spender];
86     }
87 
88     mapping (address => uint256) public balances;
89     mapping (address => mapping (address => uint256)) public allowed;
90 }
91 
92 contract STCDR is StandardToken {
93 	string public name = "STCDR";
94 	string public symbol = "STCDR";
95 	uint256 public decimals = 8;
96 	string public version = "1.0";
97 	uint256 public tokenCap = 1000000000 * 10**8;
98 	uint256 public tokenBurned = 0;
99 	uint256 public tokenAllocated = 0;
100   // root control
101 	address public fundWallet;
102 	// maps addresses
103   mapping (address => bool) public whitelist;
104 
105 	event Whitelist(address indexed participant);
106 
107   modifier onlyWhitelist {
108 		require(whitelist[msg.sender]);
109 		_;
110 	}
111 	modifier onlyFundWallet {
112 		require(msg.sender == fundWallet);
113 		_;
114 	}
115 
116 	constructor() public  {
117 		fundWallet = msg.sender;
118 		whitelist[fundWallet] = true;
119 	}
120 
121 	function setTokens(address participant, uint256  amountTokens) private {
122 		uint256 thisamountTokens = amountTokens;
123 		uint256 newtokenAllocated =  safeAdd(tokenAllocated, thisamountTokens);
124 
125     if(newtokenAllocated > tokenCap){
126 			thisamountTokens = safeSub(tokenCap,thisamountTokens);
127 			newtokenAllocated = safeAdd(tokenAllocated, thisamountTokens);
128 		}
129 
130 		require(newtokenAllocated <= tokenCap);
131 
132 		tokenAllocated = newtokenAllocated;
133 		whitelist[participant] = true;
134 		balances[participant] = safeAdd(balances[participant], thisamountTokens);
135 	}
136 
137 	function allocateTokens(address participant, uint256  amountTokens, address recommended) external onlyFundWallet  {
138 		setTokens(participant, amountTokens);
139 
140 		if (recommended != participant)	{
141       require(whitelist[recommended]);
142       setTokens(recommended, amountTokens);
143     }
144 	}
145 
146 	function burnTokens(address participant, uint256  amountTokens) external onlyFundWallet  {
147 		uint256 newTokValue = amountTokens;
148 		address thisparticipant = participant;
149 
150 		if (balances[thisparticipant] < newTokValue) {
151       newTokValue = balances[thisparticipant];
152     }
153 
154 		uint256 newtokenBurned = safeAdd(tokenBurned, newTokValue);
155 		require(newtokenBurned <= tokenCap);
156 		tokenBurned = newtokenBurned;
157 		balances[thisparticipant] = safeSub(balances[thisparticipant], newTokValue);
158 	}
159 
160 	function burnMyTokens(uint256 amountTokens) external onlyWhitelist  {
161 		uint256 newTokValue = amountTokens;
162 		address thisparticipant = msg.sender;
163 
164     if (balances[thisparticipant] < newTokValue) {
165       newTokValue = balances[thisparticipant];
166     }
167 
168 		uint256 newtokenBurned = safeAdd(tokenBurned, newTokValue);
169 		require(newtokenBurned <= tokenCap);
170 		tokenBurned = newtokenBurned;
171 		balances[msg.sender] = safeSub(balances[thisparticipant],newTokValue );
172 	}
173 
174   function buy() external payable {
175 		buyTo(msg.sender);
176 	}
177 
178   function buyTo(address participant) public payable onlyWhitelist {
179 		require(false);
180 	}
181 
182   function changeFundWallet(address newFundWallet) external onlyFundWallet {
183 		require(newFundWallet != address(0));
184 		fundWallet = newFundWallet;
185 	}
186 
187   // prevent transfers until trading allowed
188 	function transfer(address _to, uint256 _value) public returns (bool success) {
189 		return super.transfer(_to, _value);
190 	}
191 
192 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
193 		return super.transferFrom(_from, _to, _value);
194 	}
195 }