1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // PIEXGO TEAM
5 // ----------------------------------------------------------------------------
6 
7 
8 // ----------------------------------------------------------------------------
9 // Safe maths
10 // ----------------------------------------------------------------------------
11 library SafeMath {
12     function add(uint a, uint b) internal pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function sub(uint a, uint b) internal pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function mul(uint a, uint b) internal pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function div(uint a, uint b) internal pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 
31 // ----------------------------------------------------------------------------
32 // ERC Token Standard #20 Interface
33 // ----------------------------------------------------------------------------
34 contract ERC20Interface {
35     function totalSupply() public view returns (uint);
36     function balanceOf(address tokenOwner) public view returns (uint balance);
37     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
50 }
51 
52 
53 
54 contract Owned {
55     address public owner;
56     address public newOwner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     constructor() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) public onlyOwner {
70         newOwner = _newOwner;
71     }
72     function acceptOwnership() public {
73         require(msg.sender == newOwner);
74         emit OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76         newOwner = address(0);
77     }
78 }
79 
80 
81 contract PIEXGOToken is ERC20Interface, Owned {
82     using SafeMath for uint;
83 
84     string public symbol;
85     string public  name;
86     uint8 public decimals;
87     uint _totalSupply;
88 
89     mapping(address => uint) balances;
90     mapping(address => mapping(address => uint)) allowed;
91 
92 
93     // ------------------------------------------------------------------------
94     // Constructor
95     // ------------------------------------------------------------------------
96     constructor() public {
97         symbol = "PXG";
98         name = "PIEXGO";
99         decimals = 18;
100         _totalSupply = 10000000000 * 10**uint(decimals);
101         balances[owner] = _totalSupply;
102         emit Transfer(address(0), owner, _totalSupply);
103     }
104 
105 
106     // ------------------------------------------------------------------------
107     // Total supply
108     // ------------------------------------------------------------------------
109     function totalSupply() public view returns (uint) {
110         return _totalSupply.sub(balances[address(0)]);
111     }
112 
113 
114     // ------------------------------------------------------------------------
115     // Get the token balance for account `tokenOwner`
116     // ------------------------------------------------------------------------
117     function balanceOf(address tokenOwner) public view returns (uint balance) {
118         return balances[tokenOwner];
119     }
120 
121 
122     
123     function transfer(address to, uint tokens) public returns (bool success) {
124         balances[msg.sender] = balances[msg.sender].sub(tokens);
125         balances[to] = balances[to].add(tokens);
126         emit Transfer(msg.sender, to, tokens);
127         return true;
128     }
129 
130 
131    
132     function approve(address spender, uint tokens) public returns (bool success) {
133         allowed[msg.sender][spender] = tokens;
134         emit Approval(msg.sender, spender, tokens);
135         return true;
136     }
137 
138 
139     
140     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
141         balances[from] = balances[from].sub(tokens);
142         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
143         balances[to] = balances[to].add(tokens);
144         emit Transfer(from, to, tokens);
145         return true;
146     }
147 
148 
149     
150     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
151         return allowed[tokenOwner][spender];
152     }
153 
154 
155     
156     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
157         allowed[msg.sender][spender] = tokens;
158         emit Approval(msg.sender, spender, tokens);
159         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
160         return true;
161     }
162 
163 
164    
165     function () external payable {
166         revert();
167     }
168 
169 
170     
171     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
172         return ERC20Interface(tokenAddress).transfer(owner, tokens);
173     }
174 }