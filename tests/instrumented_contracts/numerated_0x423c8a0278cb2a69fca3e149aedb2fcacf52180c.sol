1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function div(uint a, uint b) internal pure returns (uint c) {
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
44 // ----------------------------------------------------------------------------
45 // Owned contract
46 // ----------------------------------------------------------------------------
47 contract Owned {
48     address public owner;
49     address public newOwner;
50 
51     event OwnershipTransferred(address indexed _from, address indexed _to);
52 
53     constructor() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65     function acceptOwnership() public {
66         require(msg.sender == newOwner);
67         emit OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69         newOwner = address(0);
70     }
71 }
72 
73 
74 
75 contract Platinume is ERC20Interface, Owned {
76     using SafeMath for uint;
77 
78     string public symbol;
79     string public  name;
80     uint8 public decimals;
81     uint _totalSupply;
82     uint256 public buyPrice;
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86 
87 
88     // ------------------------------------------------------------------------
89     // Constructor
90     // ------------------------------------------------------------------------
91     constructor() public {
92         symbol = "PLM";
93         name = "Platinum";
94         decimals = 8;
95         buyPrice = 1000;
96         _totalSupply = 10000000 * 10**uint(decimals);
97         balances[owner] = _totalSupply;
98         emit Transfer(address(0), owner, _totalSupply);
99     }
100 
101 
102     function totalSupply() public view returns (uint) {
103         return _totalSupply.sub(balances[address(0)]);
104     }
105 
106 
107     
108     function balanceOf(address tokenOwner) public view returns (uint balance) {
109         return balances[tokenOwner];
110     }
111 
112 
113     
114     function transfer(address to, uint tokens) public returns (bool success) {
115         balances[msg.sender] = balances[msg.sender].sub(tokens);
116         balances[to] = balances[to].add(tokens);
117         emit Transfer(msg.sender, to, tokens);
118         return true;
119     }
120 
121 
122     
123     function approve(address spender, uint tokens) public returns (bool success) {
124         allowed[msg.sender][spender] = tokens;
125         emit Approval(msg.sender, spender, tokens);
126         return true;
127     }
128 
129 
130     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
131         balances[from] = balances[from].sub(tokens);
132         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
133         balances[to] = balances[to].add(tokens);
134         emit Transfer(from, to, tokens);
135         return true;
136     }
137 
138 
139    
140     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
141         return allowed[tokenOwner][spender];
142     }
143 
144 
145     
146     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
147         allowed[msg.sender][spender] = tokens;
148         emit Approval(msg.sender, spender, tokens);
149         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
150         return true;
151     }
152 
153 
154    
155     function () public payable {
156        uint amount = msg.value * buyPrice;               // calculates the amount
157         transfer(msg.sender, amount);              // makes the transfers
158     }
159 
160 
161     
162     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
163         return ERC20Interface(tokenAddress).transfer(owner, tokens);
164     }
165 }