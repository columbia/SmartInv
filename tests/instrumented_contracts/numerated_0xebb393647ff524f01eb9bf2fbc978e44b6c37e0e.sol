1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public view returns (uint);
24     function balanceOf(address tokenOwner) public view returns (uint balance);
25     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract ApproveAndCallFallBack {
35     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
36 }
37 
38 contract Owned {
39     address public owner;
40     address public newOwner;
41 
42     event OwnershipTransferred(address indexed _from, address indexed _to);
43 
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     function transferOwnership(address _newOwner) public onlyOwner {
54         newOwner = _newOwner;
55     }
56     function acceptOwnership() public {
57         require(msg.sender == newOwner);
58         emit OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60         newOwner = address(0);
61     }
62 }
63 
64 contract RyangdooCoin is ERC20Interface, Owned, SafeMath {
65     string public symbol;
66     string public  name;
67     uint8 public decimals;
68     uint public _totalSupply;
69 
70     mapping(address => uint) balances;
71     mapping(address => mapping(address => uint)) allowed;
72 
73     constructor() public {
74         symbol = "RDC";
75         name = "RyangdooCoin";
76         decimals = 0;
77         _totalSupply = 1000000;
78         balances[0x348bECeB6eb290eeE4306C055448c948dc258A23] = _totalSupply;
79         emit Transfer(address(0), 0x348bECeB6eb290eeE4306C055448c948dc258A23, _totalSupply);
80     }
81 
82 
83     function totalSupply() public view returns (uint) {
84         return _totalSupply  - balances[address(0)];
85     }
86 
87     function balanceOf(address tokenOwner) public view returns (uint balance) {
88         return balances[tokenOwner];
89     }
90 
91     function transfer(address to, uint tokens) public returns (bool success) {
92         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
93         balances[to] = safeAdd(balances[to], tokens);
94         emit Transfer(msg.sender, to, tokens);
95         return true;
96     }
97 
98     function approve(address spender, uint tokens) public returns (bool success) {
99         allowed[msg.sender][spender] = tokens;
100         emit Approval(msg.sender, spender, tokens);
101         return true;
102     }
103 
104     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
105         balances[from] = safeSub(balances[from], tokens);
106         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
107         balances[to] = safeAdd(balances[to], tokens);
108         emit Transfer(from, to, tokens);
109         return true;
110     }
111 
112     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
113         return allowed[tokenOwner][spender];
114     }
115 
116     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
117         allowed[msg.sender][spender] = tokens;
118         emit Approval(msg.sender, spender, tokens);
119         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
120         return true;
121     }
122 
123     function () public payable {
124         revert();
125     }
126 
127     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
128         return ERC20Interface(tokenAddress).transfer(owner, tokens);
129     }
130 }