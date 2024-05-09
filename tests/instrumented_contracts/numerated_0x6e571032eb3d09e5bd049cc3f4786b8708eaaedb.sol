1 pragma solidity ^0.5.0; 
2 // ----------------------------------------------------------------------------
3 // ERC Token Standard #20 Interface//
4 // ----------------------------------------------------------------------------
5 contract ERC20Interface { 
6     function totalSupply() public view returns (uint); 
7     function balanceOf(address tokenOwner) public view returns (uint balance); 
8     function allowance(address tokenOwner, address spender) public view returns (uint remaining); 
9     function transfer(address to, uint tokens) public returns (bool success); 
10     function approve(address spender, uint tokens) public returns (bool success); 
11     function transferFrom(address from, address to, uint tokens) public returns (bool success); 
12     event Transfer(address indexed from, address indexed to, uint tokens); 
13     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
14     
15 } 
16 
17 // ----------------------------------------------------------------------------
18 // Safe Math Library
19 // ----------------------------------------------------------------------------
20 contract SafeMath { 
21     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) { c = a + b; require(c >= a); } 
22     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) { require(b <= a); c = a - b; } 
23     function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) { c = a * b; require(a == 0 || c / a == b); } 
24     function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) { require(b > 0); c = a / b; }
25 } 
26 
27 // ----------------------------------------------------------------------------
28 // Owned contract
29 // ----------------------------------------------------------------------------
30 contract Owned {
31     address payable public owner;
32 
33     event OwnershipTransferred(address indexed _from, address indexed _to);
34 
35     constructor() public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner, "Only allowed by owner");
41         _;
42     }
43 
44     function transferOwnership(address payable _newOwner) public onlyOwner {
45         require(_newOwner != address(0), "Invalid address");
46         owner = _newOwner;
47         emit OwnershipTransferred(msg.sender, _newOwner);
48     }
49 }
50 
51 contract ARMYDOLLAR  is ERC20Interface, SafeMath, Owned { 
52     string public name; 
53     string public symbol; 
54     uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it 
55     uint256 public _totalSupply; 
56     mapping(address => uint) balances; 
57     mapping(address => mapping(address => uint)) allowed;
58     
59     mapping(address => uint) unlockingDate;
60     uint public lockingPeriod = 365 days;
61     
62     /** * Constrctor function * * Initializes contract with initial supply tokens to the creator of the contract */ 
63     constructor() public { 
64         name = "Armydollar"; 
65         symbol = "ARMY$"; 
66         decimals = 18; 
67         _totalSupply = 3000000000000000000000000000; 
68         owner = 0x5b6B3AA053c1aFD7Cd3094d15878f3390E7BCC4E;
69         balances[owner] = _totalSupply; 
70         emit Transfer(address(0), owner, _totalSupply); 
71     } 
72     
73     function changeLockingPeriod(uint256 _timeInSecs) external onlyOwner{
74         lockingPeriod = _timeInSecs;
75     }
76     
77     function totalSupply() public view returns (uint) 
78     { 
79         return _totalSupply - balances[address(0)]; 
80         
81     } 
82     
83     function balanceOf(address tokenOwner) public view returns (uint balance) 
84     { 
85         return balances[tokenOwner]; 
86         
87     } 
88     
89     function allowance(address tokenOwner, address spender) public view returns (uint remaining) 
90     { 
91         return allowed[tokenOwner][spender]; 
92         
93     } 
94     
95     function approve(address spender, uint tokens) public returns (bool success) 
96     { 
97         allowed[msg.sender][spender] = tokens; 
98         emit Approval(msg.sender, spender, tokens); 
99         return true; 
100     } 
101     
102     function transfer(address to, uint tokens) public returns (bool success) { 
103         require(block.timestamp > unlockingDate[msg.sender], "tokens are locked");
104         balances[msg.sender] = safeSub(balances[msg.sender], tokens); 
105         balances[to] = safeAdd(balances[to], tokens); 
106         emit Transfer(msg.sender, to, tokens); 
107         return true; 
108     } 
109     
110     function transferFrom(address from, address to, uint tokens) public returns (bool success) 
111     { 
112         require(block.timestamp > unlockingDate[from], "tokens are locked");
113         balances[from] = safeSub(balances[from], tokens);
114         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens); 
115         balances[to] = safeAdd(balances[to], tokens); 
116         emit Transfer(from, to, tokens); 
117         return true; 
118     }
119     
120     function transferWithLocking(address to, uint tokens) public onlyOwner returns (bool success) { 
121         balances[msg.sender] = safeSub(balances[msg.sender], tokens); 
122         balances[to] = safeAdd(balances[to], tokens); 
123         unlockingDate[to] = safeAdd(block.timestamp, lockingPeriod);
124         emit Transfer(msg.sender, to, tokens); 
125         return true; 
126     }
127 }