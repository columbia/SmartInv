1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // NOVA token contract
5 //
6 // Symbol : NVT
7 // Name : NOVA TOKEN
8 // Total supply: 100,000,000,000.000000000000000000
9 // Decimals : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 
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
33 
34 contract ERC20Interface {
35     function totalSupply() public constant returns (uint);
36     function balanceOf(address tokenOwner) public constant returns (uint balance);
37     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
49 }
50 
51 
52 contract Owned {
53     address public owner;
54     address public newOwner;
55 
56     event OwnershipTransferred(address indexed _from, address indexed _to);
57 
58     function Owned() public {
59         owner = msg.sender;
60     }
61  
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address _newOwner) public onlyOwner {
68         newOwner = _newOwner;
69     }
70     function acceptOwnership() public {
71         require(msg.sender == newOwner);
72         OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74         newOwner = address(0);
75     }
76 }
77 
78 
79 contract NovaToken is ERC20Interface, Owned {
80     using SafeMath for uint;
81 
82     string public symbol;
83     string public  name;
84     uint8 public decimals;
85     uint public _totalSupply;
86 
87     mapping(address => uint) balances;
88     mapping(address => mapping(address => uint)) allowed;
89 
90 
91     function NovaToken() public {
92         symbol = "NVT";
93         name = "Nova Token";
94         decimals = 18;
95         _totalSupply = 100000000000 * 10**uint(decimals);
96         balances[owner] = _totalSupply;
97         Transfer(address(0), owner, _totalSupply);
98     }
99 
100 
101     function totalSupply() public constant returns (uint) {
102         return _totalSupply  - balances[address(0)];
103     }
104  
105  
106     function balanceOf(address tokenOwner) public constant returns (uint balance) {
107         return balances[tokenOwner];
108     }
109 
110  
111     function transfer(address to, uint tokens) public returns (bool success) {
112         balances[msg.sender] = balances[msg.sender].sub(tokens);
113         balances[to] = balances[to].add(tokens);
114         Transfer(msg.sender, to, tokens);
115         return true;
116     }
117 
118 
119     function approve(address spender, uint tokens) public returns (bool success) {
120         allowed[msg.sender][spender] = tokens;
121         Approval(msg.sender, spender, tokens);
122         return true;
123     }
124 
125 
126     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
127         balances[from] = balances[from].sub(tokens);
128         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
129         balances[to] = balances[to].add(tokens);
130         Transfer(from, to, tokens);
131         return true;
132     }
133 
134 
135     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
136         return allowed[tokenOwner][spender];
137     }
138 
139 
140     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
141         allowed[msg.sender][spender] = tokens;
142         Approval(msg.sender, spender, tokens);
143         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
144         return true;
145     }
146 
147 
148     function () public payable {
149         revert();
150     }
151 
152 
153     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
154         return ERC20Interface(tokenAddress).transfer(owner, tokens);
155     }
156 }