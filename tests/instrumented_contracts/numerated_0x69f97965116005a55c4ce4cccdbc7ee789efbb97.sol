1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Symbol      : ROD
5 // Name        : Redwood Chain
6 // Total supply: 130000000.000000
7 // Decimals    : 4
8 // ----------------------------------------------------------------------------
9 
10 
11 // ----------------------------------------------------------------------------
12 // Safe maths
13 // ----------------------------------------------------------------------------
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function sub(uint a, uint b) internal pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function mul(uint a, uint b) internal pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function div(uint a, uint b) internal pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 contract ERC20Interface {
34     function totalSupply() public constant returns (uint);
35     function balanceOf(address tokenOwner) public constant returns (uint balance);
36     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
37     function transfer(address to, uint tokens) public returns (bool success);
38     function approve(address spender, uint tokens) public returns (bool success);
39     function transferFrom(address from, address to, uint tokens) public returns (bool success);
40 
41     event Transfer(address indexed from, address indexed to, uint tokens);
42     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43 }
44 
45 
46 contract ApproveAndCallFallBack {
47     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Owned contract
53 // ----------------------------------------------------------------------------
54 contract Owned {
55     address public owner;
56     address public newOwner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     function Owned() public {
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
74         OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76         newOwner = address(0);
77     }
78 }
79 
80 
81 contract Token is ERC20Interface, Owned {
82     using SafeMath for uint;
83 
84     string public symbol;
85     string public  name;
86     uint8 public decimals;
87     uint public _totalSupply;
88 
89     mapping(address => uint) balances;
90     mapping(address => mapping(address => uint)) allowed;
91 
92 
93     function Token() public {
94         symbol = "ROD";
95         name = "Redwood Chain";
96         decimals = 4;
97         _totalSupply = 130000000 * 10**uint(decimals);
98         balances[owner] = _totalSupply;
99         Transfer(address(0), owner, _totalSupply);
100     }
101 
102 
103     function totalSupply() public constant returns (uint) {
104         return _totalSupply  - balances[address(0)];
105     }
106 
107     function balanceOf(address tokenOwner) public constant returns (uint balance) {
108         return balances[tokenOwner];
109     }
110 
111 
112     function transfer(address to, uint tokens) public returns (bool success) {
113         balances[msg.sender] = balances[msg.sender].sub(tokens);
114         balances[to] = balances[to].add(tokens);
115         Transfer(msg.sender, to, tokens);
116         return true;
117     }
118 
119 
120     function approve(address spender, uint tokens) public returns (bool success) {
121         allowed[msg.sender][spender] = tokens;
122         Approval(msg.sender, spender, tokens);
123         return true;
124     }
125 
126 
127     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
128         balances[from] = balances[from].sub(tokens);
129         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
130         balances[to] = balances[to].add(tokens);
131         Transfer(from, to, tokens);
132         return true;
133     }
134 
135 
136     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
137         return allowed[tokenOwner][spender];
138     }
139 
140 
141     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
142         allowed[msg.sender][spender] = tokens;
143         Approval(msg.sender, spender, tokens);
144         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
145         return true;
146     }
147 
148 
149     function () public payable {
150         revert();
151     }
152 
153 
154     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
155         return ERC20Interface(tokenAddress).transfer(owner, tokens);
156     }
157 }