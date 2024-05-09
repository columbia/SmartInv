1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Blockchain Asset Fund
5 //
6 // Symbol      : BAF
7 // Name        : Blockchain Asset Fund
8 // Total supply: 5000000000
9 // Decimals    : 4
10 //
11 // (c) Blockchain Asset Fund
12 // ----------------------------------------------------------------------------
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
45 contract ApproveAndCallFallBack {
46     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
47 }
48 
49 contract Owned {
50     address public owner;
51     address public newOwner;
52 
53     event OwnershipTransferred(address indexed _from, address indexed _to);
54 
55     function Owned() public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     function transferOwnership(address _newOwner) public onlyOwner {
65         newOwner = _newOwner;
66     }
67     function acceptOwnership() public {
68         require(msg.sender == newOwner);
69         OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71         newOwner = address(0);
72     }
73 }
74 
75 contract FixedSupplyToken is ERC20Interface, Owned {
76     using SafeMath for uint;
77 
78     string public symbol;
79     string public  name;
80     uint8 public decimals;
81     uint public _totalSupply;
82 
83     mapping(address => uint) balances;
84     mapping(address => mapping(address => uint)) allowed;
85 
86     function FixedSupplyToken() public {
87         symbol = "BAF";
88         name = "BAF";
89         decimals = 4;
90         _totalSupply = 5000000000 * 10**uint(decimals);
91         balances[owner] = _totalSupply;
92         Transfer(address(0), owner, _totalSupply);
93     }
94 
95     function totalSupply() public constant returns (uint) {
96         return _totalSupply  - balances[address(0)];
97     }
98 
99     function balanceOf(address tokenOwner) public constant returns (uint balance) {
100         return balances[tokenOwner];
101     }
102 
103     function transfer(address to, uint tokens) public returns (bool success) {
104         balances[msg.sender] = balances[msg.sender].sub(tokens);
105         balances[to] = balances[to].add(tokens);
106         Transfer(msg.sender, to, tokens);
107         return true;
108     }
109 
110     function approve(address spender, uint tokens) public returns (bool success) {
111         allowed[msg.sender][spender] = tokens;
112         Approval(msg.sender, spender, tokens);
113         return true;
114     }
115 
116 
117     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
118         balances[from] = balances[from].sub(tokens);
119         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
120         balances[to] = balances[to].add(tokens);
121         Transfer(from, to, tokens);
122         return true;
123     }
124 
125 
126    
127     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
128         return allowed[tokenOwner][spender];
129     }
130 
131 
132    
133     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
134         allowed[msg.sender][spender] = tokens;
135         Approval(msg.sender, spender, tokens);
136         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
137         return true;
138     }
139 
140 
141    
142     function () public payable {
143         revert();
144     }
145 
146     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
147         return ERC20Interface(tokenAddress).transfer(owner, tokens);
148     }
149 }