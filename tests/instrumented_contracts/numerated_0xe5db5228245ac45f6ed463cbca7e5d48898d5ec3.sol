1 pragma solidity ^0.4.18;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 contract ERC20Interface {
25     function totalSupply() public constant returns (uint);
26     function balanceOf(address tokenOwner) public constant returns (uint balance);
27     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 
37 contract ApproveAndCallFallBack {
38     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
39 }
40 
41 
42 contract Owned {
43     address public owner;
44     address public newOwner;
45 
46     event OwnershipTransferred(address indexed _from, address indexed _to);
47 
48     function Owned() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     function transferOwnership(address _newOwner) public onlyOwner {
58         newOwner = _newOwner;
59     }
60     function acceptOwnership() public {
61         require(msg.sender == newOwner);
62         OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64         newOwner = address(0);
65     }
66 }
67 
68 
69 contract Compaq is ERC20Interface, Owned, SafeMath {
70     string public symbol;
71     string public  name;
72     uint8 public decimals;
73     uint public _totalSupply;
74     uint public startDate;
75     uint public bonusEnds;
76     uint public endDate;
77 
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81 
82     function Compaq() public {
83         symbol = "CPQ";
84         name = "Compaq";
85         decimals = 18;
86         _totalSupply = 5000000000000000000000000000;
87         balances[0xC6F32eB58aE9402c8a652bCb333B84f12116446a] = _totalSupply;
88         Transfer(address(0), 0xC6F32eB58aE9402c8a652bCb333B84f12116446a, _totalSupply);
89         bonusEnds = now + 22 weeks;
90         endDate = now + 2222 weeks;
91 
92     }
93 
94 
95     function totalSupply() public constant returns (uint) {
96         return _totalSupply - balances[address(0)];
97     }
98 
99 
100     function balanceOf(address tokenOwner) public constant returns (uint balance) {
101         return balances[tokenOwner];
102     }
103 
104     function transfer(address to, uint tokens) public returns (bool success) {
105         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
106         balances[to] = safeAdd(balances[to], tokens);
107         Transfer(msg.sender, to, tokens);
108         return true;
109     }
110 
111 
112     function approve(address spender, uint tokens) public returns (bool success) {
113         allowed[msg.sender][spender] = tokens;
114         Approval(msg.sender, spender, tokens);
115         return true;
116     }
117 
118 
119     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
120         balances[from] = safeSub(balances[from], tokens);
121         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
122         balances[to] = safeAdd(balances[to], tokens);
123         Transfer(from, to, tokens);
124         return true;
125     }
126 
127     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
128         return allowed[tokenOwner][spender];
129     }
130 
131 
132     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
133         allowed[msg.sender][spender] = tokens;
134         Approval(msg.sender, spender, tokens);
135         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
136         return true;
137     }
138 
139     function () public payable {
140         require(now >= startDate && now <= endDate);
141         uint tokens;
142         if (now <= bonusEnds) {
143             tokens = msg.value * 222222222;
144         } else {
145             tokens = msg.value * 111111111;
146         }
147         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
148         _totalSupply = safeAdd(_totalSupply, tokens);
149         Transfer(address(0), msg.sender, tokens);
150         owner.transfer(msg.value);
151     }
152 
153 
154     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
155         return ERC20Interface(tokenAddress).transfer(owner, tokens);
156     }
157 }