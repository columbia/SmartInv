1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 
23 contract ERC20Interface {
24     function totalSupply() public view returns (uint);
25     function balanceOf(address tokenOwner) public view returns (uint balance);
26     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
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
37     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
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
67 
68 contract PlayTSmartVideoToken is ERC20Interface, Owned {
69     using SafeMath for uint;
70 
71     string public symbol;
72     string public  name;
73     uint8 public decimals;
74     uint _totalSupply;
75 
76     mapping(address => uint) balances;
77     mapping(address => mapping(address => uint)) allowed;
78 
79 
80     // ------------------------------------------------------------------------
81     // Constructor
82     // ------------------------------------------------------------------------
83     constructor() public {
84         symbol = "PLA";
85         name = "PlayT Smart Video Token";
86         decimals = 18;
87         _totalSupply = 10000000000 * 10**uint(decimals);
88         balances[owner] = _totalSupply;
89         emit Transfer(address(0), owner, _totalSupply);
90     }
91 
92     event Burn(address indexed from, uint tokens);
93 
94     function totalSupply() public view returns (uint) {
95         return _totalSupply.sub(balances[address(0)]);
96     }
97 
98 
99     function balanceOf(address tokenOwner) public view returns (uint balance) {
100         return balances[tokenOwner];
101     }
102 
103 
104     function transfer(address to, uint tokens) public returns (bool success) {
105         balances[msg.sender] = balances[msg.sender].sub(tokens);
106         balances[to] = balances[to].add(tokens);
107         emit Transfer(msg.sender, to, tokens);
108         return true;
109     }
110 
111 
112     function approve(address spender, uint tokens) public returns (bool success) {
113         allowed[msg.sender][spender] = tokens;
114         emit Approval(msg.sender, spender, tokens);
115         return true;
116     }
117 
118 
119     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
120         balances[from] = balances[from].sub(tokens);
121         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
122         balances[to] = balances[to].add(tokens);
123         emit Transfer(from, to, tokens);
124         return true;
125     }
126 
127 
128     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
129         return allowed[tokenOwner][spender];
130     }
131 
132 
133     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
134         allowed[msg.sender][spender] = tokens;
135         emit Approval(msg.sender, spender, tokens);
136         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
137         return true;
138     }
139 
140 
141     function burn(uint tokens) public returns (bool success) {
142         require(balances[msg.sender] >= tokens);
143         balances[msg.sender] = balances[msg.sender].sub(tokens);
144         _totalSupply = _totalSupply.sub(tokens);
145         emit Burn(msg.sender, tokens);
146         return true;
147     }
148 
149 
150     function burnFrom(address from, uint tokens) public returns (bool success) {
151         require(balances[from] >= tokens);
152         require(tokens <= allowed[from][msg.sender]);
153         balances[from] = balances[from].sub(tokens);
154         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
155         _totalSupply = _totalSupply.sub(tokens);
156         emit Burn(from, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Don't accept ETH
163     // ------------------------------------------------------------------------
164     function () external payable {
165         revert();
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Owner can transfer out any accidentally sent ERC20 tokens
171     // ------------------------------------------------------------------------
172     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
173         return ERC20Interface(tokenAddress).transfer(owner, tokens);
174     }
175 
176 }