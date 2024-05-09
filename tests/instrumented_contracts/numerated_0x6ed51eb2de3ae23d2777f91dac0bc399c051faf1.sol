1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract ERC20Interface {
6     function totalSupply() public constant returns (uint);
7     function balanceOf(address tokenOwner) public constant returns (uint balance);
8     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
9     function transfer(address to, uint tokens) public payable returns (bool success);
10     function approve(address spender, uint tokens) public returns (bool success);
11     function transferFrom(address from, address to, uint tokens) public returns (bool success);
12 
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
15 }
16 
17 contract ApproveAndCallFallBack {
18     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
19 }
20 
21 contract Owned {
22     address public owner;
23     address public newOwner;
24 
25     event OwnershipTransferred(address indexed _from, address indexed _to);
26 
27     function Owned() public {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function transferOwnership(address _newOwner) public onlyOwner {
37         newOwner = _newOwner;
38     }
39     function acceptOwnership() public {
40         require(msg.sender == newOwner);
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43         newOwner = address(0);
44     }
45 }
46 
47 pragma solidity ^0.4.18;
48 
49 
50 contract SafeMath {
51     function safeAdd(uint a, uint b) internal pure returns (uint c) {
52         c = a + b;
53         require(c >= a);
54     }
55     function safeSub(uint a, uint b) internal pure returns (uint c) {
56         require(b <= a);
57         c = a - b;
58     }
59     function safeMul(uint a, uint b) internal pure returns (uint c) {
60         c = a * b;
61         require(a == 0 || c / a == b);
62     }
63     function safeDiv(uint a, uint b) internal pure returns (uint c) {
64         require(b > 0);
65         c = a / b;
66     }
67 }
68 
69 
70 
71 
72 contract LifeToken is ERC20Interface, Owned, SafeMath {
73     string public symbol;
74     string public  name;
75     uint8 public decimals;
76     uint public _totalSupply;
77     uint public startDate;
78     uint public bonusEnds;
79     uint public endDate;
80 
81    
82     
83 
84     
85 
86     mapping(address => uint) balances;
87     mapping(address => mapping(address => uint)) allowed;
88 
89 
90    
91     function LifeToken() public {
92         symbol = "LFT";
93         name = "LifeToken";
94         decimals = 18;
95         bonusEnds = now + 1 weeks;
96         endDate = now + 9 weeks;
97         
98     
99 
100     }
101 
102 
103   
104     function totalSupply() public constant returns (uint) {
105         return _totalSupply  - balances[address(0)];
106     }
107 
108 
109     function balanceOf(address tokenOwner) public constant returns (uint balance) {
110         return balances[tokenOwner];
111     }
112 
113 
114   
115    
116 function transfer(address to, uint tokens) public payable returns (bool success) {
117     balances[msg.sender] = safeSub(balances[msg.sender], tokens);
118     balances[to] = safeAdd(balances[to], tokens);
119     emit Transfer(msg.sender, to, tokens);
120     return true;
121 }
122 
123 
124 
125 
126     function approve(address spender, uint tokens) public returns (bool success) {
127         allowed[msg.sender][spender] = tokens;
128         emit Approval(msg.sender, spender, tokens);
129         return true;
130     }
131 
132 
133     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
134         balances[from] = safeSub(balances[from], tokens);
135         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
136         balances[to] = safeAdd(balances[to], tokens);
137         emit Transfer(from, to, tokens);
138         return true;
139     }
140 
141 
142     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
143         return allowed[tokenOwner][spender];
144     }
145 
146 
147   
148     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
149         allowed[msg.sender][spender] = tokens;
150         emit Approval(msg.sender, spender, tokens);
151         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
152         return true;
153     }
154 
155     uint256 public max_contribution = 50 ether; 
156     uint256 public min_contribution = 0.05 ether; 
157     function () public payable {
158          require(msg.value >= min_contribution);
159     require(msg.value <= max_contribution);
160         require(now >= startDate && now <= endDate);
161         uint tokens;
162         if (now <= bonusEnds) {
163             tokens = msg.value * 12000;
164         } else {
165             tokens = msg.value * 10000;
166         }
167         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
168         _totalSupply = safeAdd(_totalSupply, tokens);
169         emit Transfer(address(0), msg.sender, tokens);
170         owner.transfer(msg.value);
171     }
172 
173 
174 
175   
176     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
177         return ERC20Interface(tokenAddress).transfer(owner, tokens);
178     }
179 
180      
181     }