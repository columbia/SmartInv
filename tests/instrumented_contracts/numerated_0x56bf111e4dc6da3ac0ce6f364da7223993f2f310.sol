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
24 
25 contract ERC20Interface {
26     function totalSupply() public constant returns (uint);
27     function balanceOf(address tokenOwner) public constant returns (uint balance);
28     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
29     function transfer(address to, uint tokens) public returns (bool success);
30     function approve(address spender, uint tokens) public returns (bool success);
31     function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 
33     event Transfer(address indexed from, address indexed to, uint tokens);
34     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
35 }
36 
37 
38 
39 contract ApproveAndCallFallBack {
40     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
41 }
42 
43 
44 
45 contract Owned {
46     address public owner;
47     address public newOwner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     function Owned() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         newOwner = _newOwner;
62     }
63     function acceptOwnership() public {
64         require(msg.sender == newOwner);
65         OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         newOwner = address(0);
68     }
69 }
70 
71 
72 
73 contract PaparazzoToken is ERC20Interface, Owned, SafeMath {
74     string public symbol;
75     string public  name;
76     uint8 public decimals;
77     uint public _totalSupply;
78     uint public startDate;
79     uint public bonusEnds;
80     uint public endDate;
81 
82     mapping(address => uint) balances;
83     mapping(address => mapping(address => uint)) allowed;
84 
85 
86     function PaparazzoToken() public {
87         symbol = "PPZ";
88         name = "Paparazzo Token";
89         decimals = 18;
90         bonusEnds = now + 2 weeks;
91         endDate = now + 10 weeks;
92 
93     }
94 
95 
96     function totalSupply() public constant returns (uint) {
97         return _totalSupply  - balances[address(0)];
98     }
99 
100 
101     function balanceOf(address tokenOwner) public constant returns (uint balance) {
102         return balances[tokenOwner];
103     }
104 
105 
106 
107     function transfer(address to, uint tokens) public returns (bool success) {
108         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
109         balances[to] = safeAdd(balances[to], tokens);
110         Transfer(msg.sender, to, tokens);
111         return true;
112     }
113 
114 
115 
116     function approve(address spender, uint tokens) public returns (bool success) {
117         allowed[msg.sender][spender] = tokens;
118         Approval(msg.sender, spender, tokens);
119         return true;
120     }
121 
122 
123     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
124         balances[from] = safeSub(balances[from], tokens);
125         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
126         balances[to] = safeAdd(balances[to], tokens);
127         Transfer(from, to, tokens);
128         return true;
129     }
130 
131 
132 
133     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
134         return allowed[tokenOwner][spender];
135     }
136 
137 
138 
139     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
140         allowed[msg.sender][spender] = tokens;
141         Approval(msg.sender, spender, tokens);
142         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
143         return true;
144     }
145 
146     // ------------------------------------------------------------------------
147     // 1000 Paparazzo Tokens per 1 ETH
148     // ------------------------------------------------------------------------
149     function () public payable {
150         require(now >= startDate && now <= endDate);
151         uint tokens;
152         if (now <= bonusEnds) {
153             tokens = msg.value * 10000;
154         } else {
155             tokens = msg.value * 1000;
156         }
157         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
158         _totalSupply = safeAdd(_totalSupply, tokens);
159         Transfer(address(0), msg.sender, tokens);
160         owner.transfer(msg.value);
161     }
162 
163 
164 
165     // ------------------------------------------------------------------------
166     // Owner can transfer out any accidentally sent ERC20 tokens
167     // ------------------------------------------------------------------------
168     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
169         return ERC20Interface(tokenAddress).transfer(owner, tokens);
170     }
171 }