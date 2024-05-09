1 pragma solidity ^0.4.24;
2 contract SafeMath {
3     function safeAdd(uint a, uint b) public pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6     }
7     function safeSub(uint a, uint b) public pure returns (uint c) {
8         require(b <= a);
9         c = a - b;
10     }
11     function safeMul(uint a, uint b) public pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }
15     function safeDiv(uint a, uint b) public pure returns (uint c) {
16         require(b > 0);
17         c = a / b;
18     }
19 }
20 contract ERC20Interface {
21     function totalSupply() public constant returns (uint);
22     function balanceOf(address tokenOwner) public constant returns (uint balance);
23     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
24     function transfer(address to, uint tokens) public returns (bool success);
25     function approve(address spender, uint tokens) public returns (bool success);
26     function transferFrom(address from, address to, uint tokens) public returns (bool success);
27     event Transfer(address indexed from, address indexed to, uint tokens);
28     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
29 }
30 contract ApproveAndCallFallBack {
31     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
32 }
33 contract Owned {
34     address public owner;
35     address public newOwner;
36     event OwnershipTransferred(address indexed _from, address indexed _to);
37     constructor() public {
38         owner = msg.sender;
39     }
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44     function transferOwnership(address _newOwner) public onlyOwner {
45         newOwner = _newOwner;
46     }
47     function acceptOwnership() public {
48         require(msg.sender == newOwner);
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51         newOwner = address(0);
52     }
53 }
54 contract SToken is ERC20Interface, Owned, SafeMath {
55     string public symbol;
56     string public  name;
57     uint8 public decimals;
58     uint public _totalSupply;
59     mapping(address => uint) balances;
60     mapping(address => mapping(address => uint)) allowed;
61     constructor() public {
62         symbol = "STS";
63         name = "SToken";
64         decimals = 18;
65         _totalSupply = 50000000000000000000000000;
66         balances[0x600Af3399f5518581217620802Ae8DD5Cf7eE673] = _totalSupply;
67         emit Transfer(address(0), 0x600Af3399f5518581217620802Ae8DD5Cf7eE673, _totalSupply);
68     }
69     function totalSupply() public constant returns (uint) {
70         return _totalSupply  - balances[address(0)];
71     }
72     function balanceOf(address tokenOwner) public constant returns (uint balance) {
73         return balances[tokenOwner];
74     }
75     function transfer(address to, uint tokens) public returns (bool success) {
76         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
77         balances[to] = safeAdd(balances[to], tokens);
78         emit Transfer(msg.sender, to, tokens);
79         return true;
80     }
81     function approve(address spender, uint tokens) public returns (bool success) {
82         allowed[msg.sender][spender] = tokens;
83         emit Approval(msg.sender, spender, tokens);
84         return true;
85     }
86     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
87         balances[from] = safeSub(balances[from], tokens);
88         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
89         balances[to] = safeAdd(balances[to], tokens);
90         emit Transfer(from, to, tokens);
91         return true;
92     }
93     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
94         return allowed[tokenOwner][spender];
95     }
96     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
97         allowed[msg.sender][spender] = tokens;
98         emit Approval(msg.sender, spender, tokens);
99         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
100         return true;
101     }
102     function () public payable {
103         revert();
104     }
105     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
106         return ERC20Interface(tokenAddress).transfer(owner, tokens);
107     }
108 }