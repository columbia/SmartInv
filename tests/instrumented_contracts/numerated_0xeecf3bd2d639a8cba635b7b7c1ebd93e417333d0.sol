1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
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
44     function Owned() public {
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
58         OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60         newOwner = address(0);
61     }
62 }
63 
64 contract SEACASH is ERC20Interface, Owned, SafeMath {
65     string public symbol;
66     string public  name;
67     uint8 public decimals;
68     uint public _totalSupply;
69     uint public startDate;
70     uint public bonusEnds;
71     uint public endDate;
72 
73     mapping(address => uint) balances;
74     mapping(address => mapping(address => uint)) allowed;
75 
76     function SEACASH() public {
77         symbol = "SEACASH";
78         name = "SEACASH";
79         decimals = 18;
80         bonusEnds = now + 1 weeks;
81         endDate = now + 12 weeks;
82 
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
93     function transfer(address to, uint tokens) public returns (bool success) {
94         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
95         balances[to] = safeAdd(balances[to], tokens);
96         Transfer(msg.sender, to, tokens);
97         return true;
98     }
99 
100     function approve(address spender, uint tokens) public returns (bool success) {
101         allowed[msg.sender][spender] = tokens;
102         Approval(msg.sender, spender, tokens);
103         return true;
104     }
105 
106     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
107         balances[from] = safeSub(balances[from], tokens);
108         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
109         balances[to] = safeAdd(balances[to], tokens);
110         Transfer(from, to, tokens);
111         return true;
112     }
113 
114     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
115         return allowed[tokenOwner][spender];
116     }
117 
118     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
119         allowed[msg.sender][spender] = tokens;
120         Approval(msg.sender, spender, tokens);
121         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
122         return true;
123     }
124 
125     function () public payable {
126         require(now >= startDate && now <= endDate);
127         uint tokens;
128         if (now <= bonusEnds) {
129             tokens = msg.value * 1200;
130         } else {
131             tokens = msg.value * 1000;
132         }
133         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
134         _totalSupply = safeAdd(_totalSupply, tokens);
135         Transfer(address(0), msg.sender, tokens);
136         owner.transfer(msg.value);
137     }
138 
139     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
140         return ERC20Interface(tokenAddress).transfer(owner, tokens);
141     }
142 }