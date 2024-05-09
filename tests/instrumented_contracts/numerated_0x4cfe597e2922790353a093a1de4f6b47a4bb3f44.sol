1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Symbol : XENC
6 // Name : XENC Token
7 // Total supply: 200000000
8 // Decimals : 6
9 //
10 // ----------------------------------------------------------------------------
11 
12 
13 library SafeMath {
14     function add(uint a, uint b) internal pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18     function sub(uint a, uint b) internal pure returns (uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22     function mul(uint a, uint b) internal pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b);
25     }
26     function div(uint a, uint b) internal pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
31 
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
51 contract Owned {
52     address public owner;
53     address public newOwner;
54 
55     event OwnershipTransferred(address indexed _from, address indexed _to);
56 
57     function Owned() public {
58         owner = msg.sender;
59     }
60  
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function transferOwnership(address _newOwner) public onlyOwner {
67         newOwner = _newOwner;
68     }
69     function acceptOwnership() public {
70         require(msg.sender == newOwner);
71         emit OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73         newOwner = address(0);
74     }
75 }
76 
77 
78 contract XENCToken is ERC20Interface, Owned {
79     using SafeMath for uint;
80 
81     string public symbol;
82     string public  name;
83     uint8 public decimals;
84     uint public _totalSupply;
85 
86     mapping(address => uint) balances;
87     mapping(address => mapping(address => uint)) allowed;
88 
89 
90     function XENCToken() public {
91         symbol = "XENC";
92         name = "XENC Token";
93         decimals = 6;
94         _totalSupply = 200000000 * 10**uint(decimals);
95         balances[owner] = _totalSupply;
96         emit Transfer(address(0), owner, _totalSupply);
97     }
98 
99 
100     function totalSupply() public constant returns (uint) {
101         return _totalSupply  - balances[address(0)];
102     }
103  
104  
105     function balanceOf(address tokenOwner) public constant returns (uint balance) {
106         return balances[tokenOwner];
107     }
108 
109  
110     function transfer(address to, uint tokens) public returns (bool success) {
111         balances[msg.sender] = balances[msg.sender].sub(tokens);
112         balances[to] = balances[to].add(tokens);
113         emit Transfer(msg.sender, to, tokens);
114         return true;
115     }
116 
117 
118     function approve(address spender, uint tokens) public returns (bool success) {
119         allowed[msg.sender][spender] = tokens;
120         emit Approval(msg.sender, spender, tokens);
121         return true;
122     }
123 
124 
125     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
126         balances[from] = balances[from].sub(tokens);
127         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
128         balances[to] = balances[to].add(tokens);
129         emit Transfer(from, to, tokens);
130         return true;
131     }
132 
133 
134     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
135         return allowed[tokenOwner][spender];
136     }
137 
138 
139     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
140         allowed[msg.sender][spender] = tokens;
141         emit Approval(msg.sender, spender, tokens);
142         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
143         return true;
144     }
145 
146 
147     function () public payable {
148         revert();
149     }
150 
151 
152     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
153         return ERC20Interface(tokenAddress).transfer(owner, tokens);
154     }
155 }