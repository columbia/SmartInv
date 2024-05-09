1 pragma solidity ^0.4.24;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint a, uint b) public pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) public pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) public pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) public pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 contract ERC20Interface {
24     function totalSupply() public constant returns (uint);
25     function balanceOf(address tokenOwner) public constant returns (uint balance);
26     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
27     function transfer(address to, uint tokens) public returns (bool success);
28     function approve(address spender, uint tokens) public returns (bool success);
29     function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }
34 
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
38 }
39 
40 
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         newOwner = _newOwner;
58     }
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 contract Rascal is ERC20Interface, Owned, SafeMath {
68     string public symbol;
69     string public  name;
70     uint8 public decimals;
71     uint public _totalSupply;
72 
73     mapping(address => uint) balances;
74     mapping(address => mapping(address => uint)) allowed;
75 
76     constructor() public {
77         symbol = "RCL";
78         name = "Rascal";
79         decimals = 18;
80         _totalSupply = 12000000000000000000000000000;
81         balances[0x57Fb6FB6231106ce0aeeE40C5878e94B173f9299] = _totalSupply;
82         emit Transfer(address(0), 0x57Fb6FB6231106ce0aeeE40C5878e94B173f9299, _totalSupply);
83     }
84 
85     function totalSupply() public constant returns (uint) {
86         return _totalSupply  - balances[address(0)];
87     }
88 
89     function balanceOf(address tokenOwner) public constant returns (uint balance) {
90         return balances[tokenOwner];
91     }
92 
93 
94     function transfer(address to, uint tokens) public returns (bool success) {
95         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
96         balances[to] = safeAdd(balances[to], tokens);
97         emit Transfer(msg.sender, to, tokens);
98         return true;
99     }
100 
101     function approve(address spender, uint tokens) public returns (bool success) {
102         allowed[msg.sender][spender] = tokens;
103         emit Approval(msg.sender, spender, tokens);
104         return true;
105     }
106 
107     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
108         balances[from] = safeSub(balances[from], tokens);
109         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
110         balances[to] = safeAdd(balances[to], tokens);
111         emit Transfer(from, to, tokens);
112         return true;
113     }
114 
115     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
116         return allowed[tokenOwner][spender];
117     }
118 
119     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
120         allowed[msg.sender][spender] = tokens;
121         emit Approval(msg.sender, spender, tokens);
122         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
123         return true;
124     }
125 
126 
127     function () public payable {
128         revert();
129     }
130 
131     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
132         return ERC20Interface(tokenAddress).transfer(owner, tokens);
133     }
134     }