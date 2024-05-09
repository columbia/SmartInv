1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4 
5     function safeAdd(uint a, uint b) public pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9 
10     function safeSub(uint a, uint b) public pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14 
15     function safeMul(uint a, uint b) public pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19 
20     function safeDiv(uint a, uint b) public pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 /**
27 ERC Token Standard #20 Interface
28 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29 */
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 contract W3RLDToken is ERC20Interface, SafeMath {
47     string public symbol;
48     string public  name;
49     uint8 public decimals;
50     uint public _totalSupply;
51 
52     mapping(address => uint) balances;
53     mapping(address => mapping(address => uint)) allowed;
54 
55     constructor() public {
56         symbol = "W3RLD";
57         name = "W3RLD";
58         decimals = 2;
59         _totalSupply = 1000000;
60         balances[0xdaAaB595fdE6C90F9dFd8549d1183B078B85580D] = _totalSupply;
61         emit Transfer(address(0), 0xdaAaB595fdE6C90F9dFd8549d1183B078B85580D, _totalSupply);
62     }
63 
64     function totalSupply() public constant returns (uint) {
65         return _totalSupply  - balances[address(0)];
66     }
67 
68     function balanceOf(address tokenOwner) public constant returns (uint balance) {
69         return balances[tokenOwner];
70     }
71 
72     function transfer(address to, uint tokens) public returns (bool success) {
73         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
74         balances[to] = safeAdd(balances[to], tokens);
75         emit Transfer(msg.sender, to, tokens);
76         return true;
77     }
78 
79     function approve(address spender, uint tokens) public returns (bool success) {
80         allowed[msg.sender][spender] = tokens;
81         emit Approval(msg.sender, spender, tokens);
82         return true;
83     }
84 
85     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
86         balances[from] = safeSub(balances[from], tokens);
87         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
88         balances[to] = safeAdd(balances[to], tokens);
89         emit Transfer(from, to, tokens);
90         return true;
91     }
92 
93     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
94         return allowed[tokenOwner][spender];
95     }
96 
97     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
98         allowed[msg.sender][spender] = tokens;
99         emit Approval(msg.sender, spender, tokens);
100         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
101         return true;
102     }
103 
104     function () public payable {
105         revert();
106     }
107 }