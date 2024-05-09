1 pragma solidity ^0.4.18;
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
24 // ----------------------------------------------------------------------------
25 // ERC Token Standard #20 Interface
26 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
27 // ----------------------------------------------------------------------------
28 contract ERC20Interface {
29     function totalSupply() public constant returns (uint);
30     function balanceOf(address tokenOwner) public constant returns (uint balance);
31     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
32     function transfer(address to, uint tokens) public returns (bool success);
33     function approve(address spender, uint tokens) public returns (bool success);
34     function transferFrom(address from, address to, uint tokens) public returns (bool success);
35 
36     event Transfer(address indexed from, address indexed to, uint tokens);
37     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38 }
39 
40 
41 
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 
47 
48 contract Owned {
49     address public owner;
50     address public newOwner;
51 
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53 
54     function Owned() public {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address _newOwner) public onlyOwner {
64         newOwner = _newOwner;
65     }
66     function acceptOwnership() public {
67         require(msg.sender == newOwner);
68         OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70         newOwner = address(0);
71     }
72 }
73 
74 
75 
76 contract DropToken is ERC20Interface, Owned {
77     using SafeMath for uint;
78 
79     string public symbol;
80     string public  name;
81     uint8 public decimals;
82     uint public _totalSupply;
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86 
87 
88     function DropToken() public {
89         symbol = "DROP";
90         name = "Dropil";
91         decimals = 18;
92         _totalSupply = 30000000000 * 10**uint(decimals);
93         balances[owner] = _totalSupply;
94         Transfer(address(0), owner, _totalSupply);
95     }
96 
97 
98     // ------------------------------------------------------------------------
99     // Total supply
100     // ------------------------------------------------------------------------
101     function totalSupply() public constant returns (uint) {
102         return _totalSupply  - balances[address(0)];
103     }
104 
105 
106 
107     function balanceOf(address tokenOwner) public constant returns (uint balance) {
108         return balances[tokenOwner];
109     }
110 
111 
112 
113     function transfer(address to, uint tokens) public returns (bool success) {
114         balances[msg.sender] = balances[msg.sender].sub(tokens);
115         balances[to] = balances[to].add(tokens);
116         Transfer(msg.sender, to, tokens);
117         return true;
118     }
119 
120 
121 
122     function approve(address spender, uint tokens) public returns (bool success) {
123         allowed[msg.sender][spender] = tokens;
124         Approval(msg.sender, spender, tokens);
125         return true;
126     }
127 
128 
129 
130     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
131         balances[from] = balances[from].sub(tokens);
132         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
133         balances[to] = balances[to].add(tokens);
134         Transfer(from, to, tokens);
135         return true;
136     }
137 
138 
139 
140     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
141         return allowed[tokenOwner][spender];
142     }
143 
144 
145     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
146         allowed[msg.sender][spender] = tokens;
147         Approval(msg.sender, spender, tokens);
148         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
149         return true;
150     }
151 
152 
153 
154     function () public payable {
155         revert();
156     }
157 
158 
159     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
160         return ERC20Interface(tokenAddress).transfer(owner, tokens);
161     }
162 }