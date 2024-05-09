1 pragma solidity ^0.5.1;
2 
3 // ----------------------------------------------------------------------------
4 // Symbol      : CBP
5 // Name        : CashBackPro
6 // Total supply: 102000000
7 // Decimals    : 18
8 //
9 // ----------------------------------------------------------------------------
10 
11 contract SafeMath {
12     function safeAdd(uint a, uint b) public pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function safeSub(uint a, uint b) public pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function safeMul(uint a, uint b) public pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function safeDiv(uint a, uint b) public pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 contract ERC20Interface {
30     function totalSupply() public view returns (uint);
31     function balanceOf(address tokenOwner) public view returns (uint balance);
32     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 contract ApproveAndCallFallBack {
42     function receiveApproval(address from, uint256 tokens, address token, bytes memory) public;
43 }
44 
45 contract Owned {
46     address public owner;
47     address public newOwner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     constructor() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         newOwner = _newOwner;
62     }
63     function acceptOwnership() public {
64         require(msg.sender == newOwner);
65         emit OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         newOwner = address(0);
68     }
69 }
70 
71 contract CASHBACKPRO is ERC20Interface, Owned, SafeMath {
72     string public symbol;
73     string public  name;
74     uint8 public decimals;
75     uint public _totalSupply;
76 
77     mapping(address => uint) balances;
78     mapping(address => mapping(address => uint)) allowed;
79 
80     constructor() public {
81         symbol = "CBP";
82         name = "CashBackPro";
83         decimals = 18;
84         _totalSupply = 102000000e18;
85         balances[owner] = _totalSupply;
86         emit Transfer(address(0), owner, _totalSupply);
87     }
88     function totalSupply() public view returns (uint) {
89         return _totalSupply  - balances[address(0)];
90     }
91     function balanceOf(address tokenOwner) public view returns (uint balance) {
92         return balances[tokenOwner];
93     }
94     function transfer(address to, uint tokens) public returns (bool success) {
95         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
96         balances[to] = safeAdd(balances[to], tokens);
97         emit Transfer(msg.sender, to, tokens);
98         return true;
99     }
100     function approve(address spender, uint tokens) public returns (bool success) {
101         allowed[msg.sender][spender] = tokens;
102         emit Approval(msg.sender, spender, tokens);
103         return true;
104     }
105     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
106         balances[from] = safeSub(balances[from], tokens);
107         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
108         balances[to] = safeAdd(balances[to], tokens);
109         emit Transfer(from, to, tokens);
110         return true;
111     }
112     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
113         return allowed[tokenOwner][spender];
114     }
115     function approveAndCall(address spender, uint tokens, bytes memory) public returns (bool success) {
116         allowed[msg.sender][spender] = tokens;
117         emit Approval(msg.sender, spender, tokens);
118         return true;
119     }
120     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
121         return ERC20Interface(tokenAddress).transfer(owner, tokens);
122     }
123 }