1 pragma solidity ^0.4.18;
2 // ----------------------------------------------------------------------------
3 // 'TOG' token contract
4 //
5 // Deployed to     : 0x916186f2959aC103C458485A2681C0cd805ad7A2
6 // Symbol          : TOG
7 // Name            : Tool of God Token
8 // Total supply    : 1000000000
9 // Frozen Amount   :  400000000
10 // First Release   :   50000000
11 // Seconad Release :   50000000
12 // Decimals        : 8
13 //
14 //
15 // (c) by Gary.Huang@toxbtc.com.
16 // ----------------------------------------------------------------------------
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint256);
43     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
45     function transfer(address to, uint256 tokens) public returns (bool success);
46     function approve(address spender, uint256 tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint256 tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
51 }
52 
53 
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 
59 contract Owned {
60     address public owner;
61     address public newOwner;
62 
63     event OwnershipTransferred(address indexed _from, address indexed _to);
64 
65     function Constructor() public { owner = msg.sender; }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     function transferOwnership(address _newOwner) public onlyOwner {
73         newOwner = _newOwner;
74     }
75     function acceptOwnership() public {
76         require(msg.sender == newOwner);
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79         newOwner = address(0);
80     }
81 }
82 
83 contract TOGToken is ERC20Interface, Owned, SafeMath {
84     string public symbol;
85     string public  name;
86     uint8 public decimals;
87     uint256 public _totalSupply;
88     uint256 public _frozeAmount;
89     uint256 _firstUnlockAmmount;
90     uint256 _secondUnlockAmmount;
91     uint256 _firstUnlockTime;
92     uint256 _secondUnlockTime;
93 
94 
95     mapping(address => uint256) balances;
96     mapping(address => mapping(address => uint256)) allowed;
97 
98 
99     function Constructor() public {
100         symbol = "TOG";
101         name = "Tool of God Token";
102         decimals = 8;               // decimals 可以有的小数点个数，最小的代币单位。
103         _totalSupply = 1000000000;   // 总共发行10亿枚
104         _frozeAmount =  400000000;   // 冻结4亿枚
105         _firstUnlockAmmount  =  50000000;  //第一年解冻数量
106         _secondUnlockAmmount =  50000000;  //第一年解冻数量
107         balances[msg.sender] = 500000000;
108         _firstUnlockTime  = now + 31536000;
109         _secondUnlockTime = now + 63072000;
110         emit Transfer(address(0), msg.sender, 500000000);
111     }
112 
113     function totalSupply() public constant returns (uint256) {
114         return _totalSupply  - balances[address(0)];
115     }
116 
117     
118     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
119         return balances[tokenOwner];
120     }
121 
122     function releaseFirstUnlock() public onlyOwner returns (bool success){
123         require(now >= _firstUnlockTime);
124         require(_firstUnlockAmmount > 0);
125         balances[msg.sender] = safeAdd(balances[msg.sender], _firstUnlockAmmount);
126         _firstUnlockAmmount = 0;
127         emit Transfer(address(0), msg.sender, _firstUnlockAmmount);
128         return true;
129     }
130 
131     function releaseSecondUnlock() public onlyOwner returns (bool success){
132         require(now >= _secondUnlockTime);
133         require(_secondUnlockAmmount > 0);
134         balances[msg.sender] = safeAdd(balances[msg.sender], _secondUnlockAmmount);
135         _secondUnlockAmmount = 0;
136         emit Transfer(address(0), msg.sender, _secondUnlockAmmount);
137         return true;
138     }
139 
140     function transfer(address to, uint256 tokens) public returns (bool success) {
141         require (to != 0x0);                                             // 收币帐户不能为空帐号
142         require (balances[msg.sender] >= tokens);                        // 转出帐户的余额足够
143         require (balances[to] + tokens >= balances[to]);                 // 转入帐户余额未溢出  
144         uint256 previousBalances = balances[msg.sender] + balances[to];  // 两帐户总余额
145         balances[msg.sender] = safeSub(balances[msg.sender], tokens);    // 转出
146         balances[to] = safeAdd(balances[to], tokens);                    // 转入
147         emit Transfer(msg.sender, to, tokens);
148         assert(balances[msg.sender] + balances[to] == previousBalances); //两帐户总余额不变
149         return true;
150     }
151 
152     function approve(address spender, uint256 tokens) public returns (bool success) {
153         allowed[msg.sender][spender] = tokens;
154         emit Approval(msg.sender, spender, tokens);
155         return true;
156     }
157 
158     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
159         require (to != 0x0);                               // 收币帐户不能为空帐号
160         require (balances[from] >= tokens);                // 转出帐户的余额足够
161         require (balances[to] + tokens >= balances[to]);   // 转入帐户余额未溢出                    
162         uint256 previousBalances = balances[from] + balances[to];
163         balances[from] = safeSub(balances[from], tokens);
164         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
165         balances[to] = safeAdd(balances[to], tokens);
166         emit Transfer(from, to, tokens);
167         assert(balances[from] + balances[to] == previousBalances);
168         return true;
169     }
170 
171     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
172         return allowed[tokenOwner][spender];
173     }
174 
175     function approveAndCall(address spender, uint256 tokens, bytes data) public returns (bool success) {
176         allowed[msg.sender][spender] = tokens;
177         emit Approval(msg.sender, spender, tokens);
178         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
179         return true;
180     }
181 
182     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
183         return ERC20Interface(tokenAddress).transfer(owner, tokens);
184     }
185 }