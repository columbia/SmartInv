1 pragma solidity ^0.5.4;
2 
3 // ----------------------------------------------------------------------------
4 // BXTB token contract for BXTB PoC Utility Token
5 //
6 // Symbol      : BXTB
7 // Name        : BXTB PoC Utility Token
8 // Total supply: 21,980,000,000.000000
9 // Decimals    : 6
10 // ----------------------------------------------------------------------------
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 library SafeMath {
17     function addSafe(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function subSafe(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function mulSafe(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function divSafe(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public view returns (uint);
42     function balanceOf(address tokenOwner) public view returns (uint balance);
43     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 // ----------------------------------------------------------------------------
53 // Contract function to receive approval and execute function in one call
54 // ----------------------------------------------------------------------------
55 contract ApproveAndCallFallBack {
56     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
57 }
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address public owner;
64     address public newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     constructor() public {
69         owner = msg.sender;
70     }
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 // ERC20 Token, with the addition of symbol, name and decimals and a
89 // fixed supply
90 // ----------------------------------------------------------------------------
91 contract BXTBToken is ERC20Interface, Owned {
92     using SafeMath for uint;
93 
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint _totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102     constructor() public {
103         symbol = "BXTB";
104         name = "BXTB PoC Utility Token";
105         decimals = 6;
106         _totalSupply = 21980000000 * 10**uint(decimals);
107         balances[owner] = _totalSupply;
108         emit Transfer(address(0), owner, _totalSupply);
109     }
110 
111     // ----------------------------------------------------------------------------
112     // Standard ERC20 implementations
113     // ----------------------------------------------------------------------------
114     function totalSupply() public view returns (uint) {
115         return _totalSupply.subSafe(balances[address(0)]);
116     }
117     function balanceOf(address tokenOwner) public view returns (uint balance) {
118         return balances[tokenOwner];
119     }
120     function transfer(address to, uint tokens) public returns (bool success) {
121         balances[msg.sender] = balances[msg.sender].subSafe(tokens);
122         balances[to] = balances[to].addSafe(tokens);
123         emit Transfer(msg.sender, to, tokens);
124         return true;
125     }
126     function approve(address spender, uint tokens) public returns (bool success) {
127         allowed[msg.sender][spender] = tokens;
128         emit Approval(msg.sender, spender, tokens);
129         return true;
130     }
131     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
132         balances[from] = balances[from].subSafe(tokens);
133         allowed[from][msg.sender] = allowed[from][msg.sender].subSafe(tokens);
134         balances[to] = balances[to].addSafe(tokens);
135         emit Transfer(from, to, tokens);
136         return true;
137     }
138     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
139         return allowed[tokenOwner][spender];
140     }
141 
142     // ----------------------------------------------------------------------------
143     // Other common and courtesy functions
144     // ----------------------------------------------------------------------------
145     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
146         allowed[msg.sender][spender] = tokens;
147         emit Approval(msg.sender, spender, tokens);
148         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
149         return true;
150     }
151     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
152         return ERC20Interface(tokenAddress).transfer(owner, tokens);
153     }
154 }