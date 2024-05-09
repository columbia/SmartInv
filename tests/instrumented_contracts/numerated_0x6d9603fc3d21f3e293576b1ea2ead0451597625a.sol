1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29     event Transfer(address indexed from, address indexed to, uint tokens);
30     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31 }
32 
33 contract ApproveAndCallFallBack {
34     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
35     
36 }
37 
38 contract Owned {
39     address public owner;
40     address public newOwner;
41     event OwnershipTransferred(address indexed _from, address indexed _to);
42 
43     constructor() public {
44         owner = msg.sender;
45     }
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     function transferOwnership(address _newOwner) public onlyOwner {
52         newOwner = _newOwner;
53     }
54     function acceptOwnership() public {
55         require(msg.sender == newOwner);
56         emit OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58         newOwner = address(0);
59     }
60 }
61 
62 contract ZealCasino is ERC20Interface, Owned, SafeMath {
63     string public symbol;
64     string public  name;
65     uint8 public decimals;
66     uint public _totalSupply;
67     mapping(address => uint) balances;
68     mapping(address => mapping(address => uint)) allowed;
69 
70     constructor() public {
71         symbol = "ZLC";
72         name = "ZealCasino";
73         decimals = 4;
74         _totalSupply = 5000000000000;
75         balances[0xD76B99c8CF50753b9677631f183D9946C761fC2c] = _totalSupply;
76         emit Transfer(address(0), 0xD76B99c8CF50753b9677631f183D9946C761fC2c, _totalSupply);
77     }
78 
79     function totalSupply() public constant returns (uint) {
80         return _totalSupply  - balances[address(0)];
81     }
82 
83     function balanceOf(address tokenOwner) public constant returns (uint balance) {
84         return balances[tokenOwner];
85     }
86 
87     function transfer(address to, uint tokens) public returns (bool success) {
88         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
89         balances[to] = safeAdd(balances[to], tokens);
90         emit Transfer(msg.sender, to, tokens);
91         return true;
92     }
93 
94     function approve(address spender, uint tokens) public returns (bool success) {
95         allowed[msg.sender][spender] = tokens;
96         emit Approval(msg.sender, spender, tokens);
97         return true;
98     }
99 
100     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
101         balances[from] = safeSub(balances[from], tokens);
102         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
103         balances[to] = safeAdd(balances[to], tokens);
104         emit Transfer(from, to, tokens);
105         return true;
106     }
107 
108     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
109         return allowed[tokenOwner][spender];
110     }
111 
112     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
113         allowed[msg.sender][spender] = tokens;
114         emit Approval(msg.sender, spender, tokens);
115         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
116         return true;
117     }
118 
119     function () public payable {
120         revert();
121     }
122 
123     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
124         return ERC20Interface(tokenAddress).transfer(owner, tokens);
125     }
126 }