1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'TIDC' token contract
5 //
6 // Deployed to : 0xAE12ABC9796836c2d8AF6D72a17eCcD33f18Ee3b
7 // Symbol      : TIDC
8 // Name        : The Internet Digital Currency
9 // Total supply: 1000000000
10 // Decimals    : 18
11 //
12 // ----------------------------------------------------------------------------
13 
14 contract SafeMath {
15     function safeAdd(uint a, uint b) public pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function safeSub(uint a, uint b) public pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function safeMul(uint a, uint b) public pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function safeDiv(uint a, uint b) public pure returns (uint c) {
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
69         emit OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71         newOwner = address(0);
72     }
73 }
74 
75 contract TheInternetDigitalCurrency is ERC20Interface, Owned, SafeMath {
76     string public symbol;
77     string public  name;
78     uint8 public decimals;
79     uint public _totalSupply;
80 
81     mapping(address => uint) balances;
82     mapping(address => mapping(address => uint)) allowed;
83 
84     function TheInternetDigitalCurrency() public {
85         symbol = "TIDC";
86         name = "The Internet Digital Currency";
87         decimals = 18;
88         _totalSupply = 1000000000000000000000000000;
89         balances[0xAE12ABC9796836c2d8AF6D72a17eCcD33f18Ee3b] = _totalSupply;
90         emit Transfer(address(0), 0xAE12ABC9796836c2d8AF6D72a17eCcD33f18Ee3b, _totalSupply);
91     }
92 
93     function totalSupply() public constant returns (uint) {
94         return _totalSupply  - balances[address(0)];
95     }
96 
97     function balanceOf(address tokenOwner) public constant returns (uint balance) {
98         return balances[tokenOwner];
99     }
100 
101     function transfer(address to, uint tokens) public returns (bool success) {
102         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
103         balances[to] = safeAdd(balances[to], tokens);
104         emit Transfer(msg.sender, to, tokens);
105         return true;
106     }
107 
108     function approve(address spender, uint tokens) public returns (bool success) {
109         allowed[msg.sender][spender] = tokens;
110         emit Approval(msg.sender, spender, tokens);
111         return true;
112     }
113 
114     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
115         balances[from] = safeSub(balances[from], tokens);
116         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
117         balances[to] = safeAdd(balances[to], tokens);
118         emit Transfer(from, to, tokens);
119         return true;
120     }
121 
122     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
123         return allowed[tokenOwner][spender];
124     }
125 
126     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
127         allowed[msg.sender][spender] = tokens;
128         emit Approval(msg.sender, spender, tokens);
129         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
130         return true;
131     }
132 
133     function () public payable {
134         revert();
135     }
136 
137     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
138         return ERC20Interface(tokenAddress).transfer(owner, tokens);
139     }
140 }