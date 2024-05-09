1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract SafeMath {
6     function safeAdd(uint a, uint b) public pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function safeSub(uint a, uint b) public pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function safeMul(uint a, uint b) public pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function safeDiv(uint a, uint b) public pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
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
38 contract ApproveAndCallFallBack {
39     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
40 }
41 
42 
43 contract Owned {
44     address public owner;
45     address public newOwner;
46 
47     event OwnershipTransferred(address indexed _from, address indexed _to);
48 
49     function Owned() public {
50         owner = msg.sender;
51     }
52 
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         newOwner = _newOwner;
60     }
61     function acceptOwnership() public {
62         require(msg.sender == newOwner);
63         OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65         newOwner = address(0);
66     }
67 }
68 
69 
70 contract MeowToken is ERC20Interface, Owned, SafeMath {
71     string public symbol;
72     string public  name;
73     uint8 public decimals;
74     uint public _totalSupply;
75 
76     mapping(address => uint) balances;
77     mapping(address => mapping(address => uint)) allowed;
78 
79 
80 
81 
82 
83     function MeowToken() public {
84         symbol = "MMC";
85         name = "MeowMeowCoin";
86         decimals = 18;
87         _totalSupply = 31415926535000000000000000000;
88         balances[0x6DC593aC863d2122A533EedC9AdcB9d14FF223cB] = _totalSupply;
89         Transfer(address(0), 0x6DC593aC863d2122A533EedC9AdcB9d14FF223cB, _totalSupply);
90     }
91 
92 
93 
94 
95 
96     function totalSupply() public constant returns (uint) {
97         return _totalSupply  - balances[address(0)];
98     }
99 
100 
101 
102 
103 
104     function balanceOf(address tokenOwner) public constant returns (uint balance) {
105         return balances[tokenOwner];
106     }
107 
108 
109 
110 
111 
112 
113 
114     function transfer(address to, uint tokens) public returns (bool success) {
115         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
116         balances[to] = safeAdd(balances[to], tokens);
117         Transfer(msg.sender, to, tokens);
118         return true;
119     }
120 
121 
122 
123 
124 
125 
126 
127 
128 
129 
130     function approve(address spender, uint tokens) public returns (bool success) {
131         allowed[msg.sender][spender] = tokens;
132         Approval(msg.sender, spender, tokens);
133         return true;
134     }
135 
136 
137 
138 
139 
140 
141 
142 
143 
144 
145 
146     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
147         balances[from] = safeSub(balances[from], tokens);
148         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
149         balances[to] = safeAdd(balances[to], tokens);
150         Transfer(from, to, tokens);
151         return true;
152     }
153 
154 
155 
156 
157 
158 
159     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
160         return allowed[tokenOwner][spender];
161     }
162 
163 
164 
165 
166 
167 
168 
169     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
170         allowed[msg.sender][spender] = tokens;
171         Approval(msg.sender, spender, tokens);
172         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
173         return true;
174     }
175 
176 
177 
178 
179 
180     function () public payable {
181         revert();
182     }
183 
184 
185 
186 
187 
188     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
189         return ERC20Interface(tokenAddress).transfer(owner, tokens);
190     }
191 }