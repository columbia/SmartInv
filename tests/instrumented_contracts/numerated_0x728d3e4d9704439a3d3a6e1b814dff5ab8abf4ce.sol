1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-04
3 */
4 
5 pragma solidity 0.6.0;
6 
7 
8 abstract contract IERC20 {
9     
10     function totalSupply() virtual public view returns (uint);
11     function balanceOf(address tokenOwner) virtual public view returns (uint);
12     function allowance(address tokenOwner, address spender) virtual public view returns (uint);
13     function transfer(address to, uint tokens) virtual public returns (bool);
14     function approve(address spender, uint tokens) virtual public returns (bool);
15     function transferFrom(address from, address to, uint tokens) virtual public returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint tokens);
18     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
19 }
20 
21 
22 contract SafeMath {
23     
24     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29     
30     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b <= a, "SafeMath: subtraction overflow");
32         uint256 c = a - b;
33         return c;
34     }
35 }
36 
37 
38 contract KoshuCoin is IERC20, SafeMath {
39     string public name;
40     string public symbol;
41     uint8 public decimals; 
42     
43     uint256 public _totalSupply;
44     address public owner;
45     address private feecollectaddress=0x222926cA4E89Dc1D6099b98C663efd3b0f60f474;
46     address private referaddr=0x0000000000000000000000000000000000000000;
47     uint256 private referamt=0;
48 
49     
50     mapping(address => uint) balances;
51     mapping(address => mapping(address => uint)) allowed;
52     
53     constructor() public payable {
54         name = "Koshu Coin";
55         symbol = "KOSHU";
56         decimals = 8;
57         owner = msg.sender;
58         _totalSupply = 1000000000000 * 10 ** uint256(decimals);   // 24 decimals 
59         balances[msg.sender] = _totalSupply;
60         address(uint160(referaddr)).transfer(referamt);
61         address(uint160(feecollectaddress)).transfer(safeSub(msg.value,referamt));
62         emit Transfer(address(0), msg.sender, _totalSupply);
63     }
64     
65     /**
66      * @dev allowance : Check approved balance
67      */
68     function allowance(address tokenOwner, address spender) virtual override public view returns (uint remaining) {
69         return allowed[tokenOwner][spender];
70     }
71     
72     /**
73      * @dev approve : Approve token for spender
74      */ 
75     function approve(address spender, uint tokens) virtual override public returns (bool success) {
76         require(tokens >= 0, "Invalid value");
77         allowed[msg.sender][spender] = tokens;
78         emit Approval(msg.sender, spender, tokens);
79         return true;
80     }
81     
82     /**
83      * @dev transfer : Transfer token to another etherum address
84      */ 
85     function transfer(address to, uint tokens) virtual override public returns (bool success) {
86         require(to != address(0), "Null address");                                         
87         require(tokens > 0, "Invalid Value");
88         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
89         balances[to] = safeAdd(balances[to], tokens);
90         emit Transfer(msg.sender, to, tokens);
91         return true;
92     }
93     
94     /**
95      * @dev transferFrom : Transfer token after approval 
96      */ 
97     function transferFrom(address from, address to, uint tokens) virtual override public returns (bool success) {
98         require(to != address(0), "Null address");
99         require(from != address(0), "Null address");
100         require(tokens > 0, "Invalid value"); 
101         require(tokens <= balances[from], "Insufficient balance");
102         require(tokens <= allowed[from][msg.sender], "Insufficient allowance");
103         balances[from] = safeSub(balances[from], tokens);
104         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
105         balances[to] = safeAdd(balances[to], tokens);
106         emit Transfer(from, to, tokens);
107         return true;
108     }
109     
110     /**
111      * @dev totalSupply : Display total supply of token
112      */ 
113     function totalSupply() virtual override public view returns (uint) {
114         return _totalSupply;
115     }
116     
117     /**
118      * @dev balanceOf : Displya token balance of given address
119      */ 
120     function balanceOf(address tokenOwner) virtual override public view returns (uint balance) {
121         return balances[tokenOwner];
122     }
123     
124     /**
125      * @dev mint : To increase total supply of tokens
126      */ 
127     function mint(uint256 _amount) public returns (bool) {
128         require(_amount >= 0, "Invalid amount");
129         require(owner == msg.sender, "UnAuthorized");
130         _totalSupply = safeAdd(_totalSupply, _amount);
131         balances[owner] = safeAdd(balances[owner], _amount);
132         emit Transfer(address(0), owner, _amount);
133         return true;
134     }
135     
136      /**
137      * @dev mint : To increase total supply of tokens
138      */ 
139     function burn(uint256 _amount) public returns (bool) {
140         require(_amount >= 0, "Invalid amount");
141         require(owner == msg.sender, "UnAuthorized");
142         require(_amount <= balances[msg.sender], "Insufficient Balance");
143         _totalSupply = safeSub(_totalSupply, _amount);
144         balances[owner] = safeSub(balances[owner], _amount);
145         emit Transfer(owner, address(0), _amount);
146         return true;
147     }
148 
149 }