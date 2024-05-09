1 pragma solidity ^0.4.21;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function transfer(address to, uint tokens) public returns (bool success);
7 	function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
8 	function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10     event Transfer(address indexed from, address indexed to, uint tokens);
11 }
12 
13 contract CryptoQuantumTradingFund is ERC20Interface {
14 	
15 	
16 	// ERC20 //////////////
17 
18 	function totalSupply()public constant returns (uint) {
19 		return fixTotalBalance;
20 	}
21 	
22 	function balanceOf(address tokenOwner)public constant returns (uint balance) {
23 		return balances[tokenOwner];
24 	}
25 
26 	function transfer(address to, uint tokens)public returns (bool success) {
27 		if (balances[msg.sender] >= tokens && tokens > 0 && balances[to] + tokens > balances[to]) {
28 			if(msg.sender == creatorsAddress) //创始团队锁定判断
29 			{
30 				TryUnLockCreatorBalance();
31 				if(balances[msg.sender] < (creatorsLocked + tokens))
32 				{
33 					return false;
34 				}
35 			}
36 			balances[msg.sender] -= tokens;
37 			balances[to] += tokens;
38 			emit Transfer(msg.sender, to, tokens);
39 			return true;
40 		} else {
41 			return false;
42 		}
43 	}
44 
45 	function transferFrom(address from, address to, uint tokens)public returns (bool success) {
46 		if (balances[from] >= tokens && allowed[from][msg.sender] >= tokens && tokens > 0 && balances[to] + tokens > balances[to]) {
47 			if(from == creatorsAddress) //创始团队锁定判断
48 			{
49 				TryUnLockCreatorBalance();
50 				if(balances[from] < (creatorsLocked + tokens))
51 				{
52 					return false;
53 				}
54 			}
55 			balances[from] -= tokens;
56 			allowed[from][msg.sender] -= tokens;
57 			balances[to] += tokens;
58 			emit Transfer(from, to, tokens);
59 			return true;
60 		} else {
61 			return false;
62 		}
63 	}
64 	
65 	
66 	function approve(address spender, uint tokens)public returns (bool success) {
67 		allowed[msg.sender][spender] = tokens;
68 		emit Approval(msg.sender, spender, tokens);
69 		return true;
70 	}
71 	
72 	function allowance(address tokenOwner, address spender)public constant returns (uint remaining) {
73 		return allowed[tokenOwner][spender];
74 	}
75 	
76 
77 	
78 	event Transfer(address indexed from, address indexed to, uint tokens);//transfer方法调用时的通知事件
79 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens); //approve方法调用时的通知事件
80 
81 	// ERC20 //////////////
82 		
83     string public name = "CryptoQuantumTradingFund";
84     string public symbol = "CQTF";
85     uint8 public decimals = 18;
86 	uint256 private fixTotalBalance = 100000000000000000000000000;
87 	uint256 private _totalBalance =    92000000000000000000000000;
88 	uint256   public creatorsLocked =  8000000000000000000000000; //创世团队当前锁定额度
89 	
90 	address public owner = 0x0;
91 	
92     	mapping (address => uint256) balances;
93 	mapping(address => mapping (address => uint256)) allowed;
94 	
95 	uint  constant    private ONE_DAY_TIME_LEN = 86400; //一天的秒数
96 	uint  constant    private ONE_YEAR_TIME_LEN = 946080000; //一年的秒数
97 	uint32 private constant MAX_UINT32 = 0xFFFFFFFF;
98 	
99 	
100 	address public creatorsAddress = 0xbcabf04377034e4eC3C20ACaD2CA093559Ee9742; //创世团队地址
101 	
102 	uint      public unLockIdx = 2;		//锁定系数
103 	uint      public nextUnLockTime = block.timestamp + ONE_YEAR_TIME_LEN;	//下次解锁时间点
104 
105 	
106 	
107 
108 
109     function CryptoQuantumTradingFund() public {
110 	
111 		owner = msg.sender;
112 		balances[creatorsAddress] = creatorsLocked;
113 		balances[owner] = _totalBalance;
114        
115     }
116 
117 	
118 	
119 	
120 	//解锁创始团队
121 	function TryUnLockCreatorBalance() public {
122 		while(unLockIdx > 0 && block.timestamp >= nextUnLockTime){ //解锁判断
123 			uint256 append = creatorsLocked/unLockIdx;
124 			creatorsLocked -= append;
125 			
126 			unLockIdx -= 1;
127 			nextUnLockTime = block.timestamp + ONE_YEAR_TIME_LEN;
128 		}
129 	}
130 	
131 	function () public payable
132     {
133     }
134 	
135 	function Save() public {
136 		if (msg.sender != owner) revert();
137 
138 		owner.transfer(address(this).balance);
139     }
140 	
141 	
142 	function changeOwner(address newOwner) public {
143 		if (msg.sender != owner) 
144 		{
145 		    revert();
146 		}
147 		else
148 		{
149 			owner = newOwner;
150 		}
151     }
152 	
153 	function destruct() public {
154 		if (msg.sender != owner) 
155 		{
156 		    revert();
157 		}
158 		else
159 		{
160 			selfdestruct(owner);
161 		}
162     }
163 }