1 pragma solidity ^0.4.26;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 contract ApproveAndCallFallBack {
25     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
26 }
27 
28 
29 contract Owned {
30     address public owner;
31     address public newOwner;
32 
33     event OwnershipTransferred(address indexed _from, address indexed _to);
34 
35     constructor() public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     function transferOwnership(address _newOwner) public onlyOwner {
45         newOwner = _newOwner;
46     }
47     function acceptOwnership() public {
48         require(msg.sender == newOwner);
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51         newOwner = address(0);
52     }
53 }
54 
55 
56 contract NV_USDollar is Owned, SafeMath {
57     string public symbol;
58     string public  name;
59     uint8 public decimals;
60     uint256 public _totalSupply;
61 
62     mapping(address => uint256) balances;
63     mapping(address => mapping(address => uint256)) allowed;
64 
65     event Transfer(address indexed from, address indexed to, uint256 tokens);
66     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
67 
68     // ------------------------------------------------------------------------
69     // Constructor
70     // ------------------------------------------------------------------------
71     constructor() public {
72         symbol = "USDn";
73         name = "NV US Dollar";
74         decimals = 18;
75         _totalSupply = 1000000000000000000000000000;
76         balances[owner] = _totalSupply;
77         emit Transfer(address(0), owner, _totalSupply);
78     }
79 
80 
81     function totalSupply() external constant returns (uint256) {
82         return _totalSupply  - balances[address(0)];
83     }
84 
85 
86     function balanceOf(address tokenOwner) external constant returns (uint256 balance) {
87         return balances[tokenOwner];
88     }
89 
90 
91     function transfer(address to, uint256 tokens) external returns (bool success) {
92         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
93         balances[to] = safeAdd(balances[to], tokens);
94         emit Transfer(msg.sender, to, tokens);
95         return true;
96     }
97 
98 
99     function approve(address spender, uint256 tokens) external returns (bool success) {
100         allowed[msg.sender][spender] = tokens;
101         emit Approval(msg.sender, spender, tokens);
102         return true;
103     }
104 
105 
106     function transferFrom(address from, address to, uint256 tokens) external returns (bool success) {
107         balances[from] = safeSub(balances[from], tokens);
108         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
109         balances[to] = safeAdd(balances[to], tokens);
110         emit Transfer(from, to, tokens);
111         return true;
112     }
113 
114 
115     function allowance(address tokenOwner, address spender) external constant returns (uint256 remaining) {
116         return allowed[tokenOwner][spender];
117     }
118 
119 
120     function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool success) {
121         allowed[msg.sender][spender] = tokens;
122         emit Approval(msg.sender, spender, tokens);
123         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
124         return true;
125     }
126 
127 
128     function () external payable {
129         revert();
130     }
131 
132 
133     function transferAnyERC20Token(uint256 tokens) external onlyOwner returns (bool success) {
134         return this.transfer(owner, tokens);
135     }
136 }