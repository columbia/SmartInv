1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-03
3 */
4 
5 pragma solidity ^0.4.26;
6 
7 
8 contract SafeMath {
9     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 
28 contract ApproveAndCallFallBack {
29     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
30 }
31 
32 
33 contract Owned {
34     address public owner;
35     address public newOwner;
36 
37     event OwnershipTransferred(address indexed _from, address indexed _to);
38 
39     constructor() public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address _newOwner) public onlyOwner {
49         newOwner = _newOwner;
50     }
51     function acceptOwnership() public {
52         require(msg.sender == newOwner);
53         emit OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55         newOwner = address(0);
56     }
57 }
58 
59 
60 contract NvirWorldToken is Owned, SafeMath {
61     string public symbol;
62     string public  name;
63     uint8 public decimals;
64     uint256 public _totalSupply;
65 
66     mapping(address => uint256) balances;
67     mapping(address => mapping(address => uint256)) allowed;
68 
69     event Transfer(address indexed from, address indexed to, uint256 tokens);
70     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
71 
72     // ------------------------------------------------------------------------
73     // Constructor
74     // ------------------------------------------------------------------------
75     constructor() public {
76         symbol = "Nvir";
77         name = "NvirWorld";
78         decimals = 18;
79         _totalSupply = 10700000000000000000000000000;
80         balances[owner] = _totalSupply;
81         emit Transfer(address(0), owner, _totalSupply);
82     }
83 
84 
85     function totalSupply() external constant returns (uint256) {
86         return _totalSupply  - balances[address(0)];
87     }
88 
89 
90     function balanceOf(address tokenOwner) external constant returns (uint256 balance) {
91         return balances[tokenOwner];
92     }
93 
94 
95     function transfer(address to, uint256 tokens) external returns (bool success) {
96         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
97         balances[to] = safeAdd(balances[to], tokens);
98         emit Transfer(msg.sender, to, tokens);
99         return true;
100     }
101 
102 
103     function approve(address spender, uint256 tokens) external returns (bool success) {
104         allowed[msg.sender][spender] = tokens;
105         emit Approval(msg.sender, spender, tokens);
106         return true;
107     }
108 
109 
110     function transferFrom(address from, address to, uint256 tokens) external returns (bool success) {
111         balances[from] = safeSub(balances[from], tokens);
112         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
113         balances[to] = safeAdd(balances[to], tokens);
114         emit Transfer(from, to, tokens);
115         return true;
116     }
117 
118 
119     function allowance(address tokenOwner, address spender) external constant returns (uint256 remaining) {
120         return allowed[tokenOwner][spender];
121     }
122 
123 
124     function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool success) {
125         allowed[msg.sender][spender] = tokens;
126         emit Approval(msg.sender, spender, tokens);
127         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
128         return true;
129     }
130 
131 
132     function () external payable {
133         revert();
134     }
135 
136 
137     function transferAnyERC20Token(uint256 tokens) external onlyOwner returns (bool success) {
138         return this.transfer(owner, tokens);
139     }
140 }