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
64 
65 contract NoobCoin is ERC20Interface, Owned, SafeMath {
66     string public symbol;
67     string public  name;
68     uint8 public decimals;
69     uint public _totalSupply;
70     uint public startDate;
71     uint public bonusEnds;
72     uint public endDate;
73 
74     mapping(address => uint) balances;
75     mapping(address => mapping(address => uint)) allowed;
76 
77     function NoobCoin() public {
78         symbol = "NOOB";
79         name = "Noob Coin";
80         decimals = 18;
81         bonusEnds = now + 1 weeks;
82         endDate = now + 4 weeks;
83 
84     }
85 
86     function totalSupply() public constant returns (uint) {
87         return _totalSupply  - balances[address(0)];
88     }
89 
90     function balanceOf(address tokenOwner) public constant returns (uint balance) {
91         return balances[tokenOwner];
92     }
93 
94     function transfer(address to, uint tokens) public returns (bool success) {
95         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
96         balances[to] = safeAdd(balances[to], tokens);
97         Transfer(msg.sender, to, tokens);
98         return true;
99     }
100 
101     function approve(address spender, uint tokens) public returns (bool success) {
102         allowed[msg.sender][spender] = tokens;
103         Approval(msg.sender, spender, tokens);
104         return true;
105     }
106 
107     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
108         balances[from] = safeSub(balances[from], tokens);
109         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
110         balances[to] = safeAdd(balances[to], tokens);
111         Transfer(from, to, tokens);
112         return true;
113     }
114 
115     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
116         return allowed[tokenOwner][spender];
117     }
118 
119     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
120         allowed[msg.sender][spender] = tokens;
121         Approval(msg.sender, spender, tokens);
122         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
123         return true;
124     }
125 
126     // ------------------------------------------------------------------------
127     // 4090 Noob Coins per 1 ETH
128     // ------------------------------------------------------------------------
129     function () public payable {
130         require(now >= startDate && now <= endDate);
131         uint tokens;
132         if (now <= bonusEnds) {
133             tokens = msg.value * 5115;
134         } else {
135             tokens = msg.value * 4090;
136         }
137         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
138         _totalSupply = safeAdd(_totalSupply, tokens);
139         Transfer(address(0), msg.sender, tokens);
140         owner.transfer(msg.value);
141     }
142 
143     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
144         return ERC20Interface(tokenAddress).transfer(owner, tokens);
145     }
146 }