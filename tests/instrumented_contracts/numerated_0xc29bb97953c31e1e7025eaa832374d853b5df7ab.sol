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
27 
28     event Transfer(address indexed from, address indexed to, uint tokens);
29     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
30 }
31 contract ApproveAndCallFallBack {
32     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
33 }
34 contract Owned {
35     address public owner;
36     address public newOwner;
37 
38     event OwnershipTransferred(address indexed _from, address indexed _to);
39 
40     constructor() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address _newOwner) public onlyOwner {
50         newOwner = _newOwner;
51     }
52     function acceptOwnership() public {
53         require(msg.sender == newOwner);
54         emit OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56         newOwner = address(0);
57     }
58 }
59 contract NZT is ERC20Interface, Owned, SafeMath {
60     string public symbol;
61     string public  name;
62     uint8 public decimals;
63     uint public _totalSupply;
64 
65     mapping(address => uint) balances;
66     mapping(address => mapping(address => uint)) allowed;
67     constructor() public {
68         symbol = "NZT";
69         name = "NZT";
70         decimals = 18;
71         _totalSupply = 1000000000000000000000000;
72         balances[0xaF3cDB7D531396eFDE790D45585d49109f1093fF] = _totalSupply;
73         emit Transfer(address(0), 0xaF3cDB7D531396eFDE790D45585d49109f1093fF, _totalSupply);
74     }
75     function totalSupply() public constant returns (uint) {
76         return _totalSupply  - balances[address(0)];
77     }
78     function balanceOf(address tokenOwner) public constant returns (uint balance) {
79         return balances[tokenOwner];
80     }
81     function transfer(address to, uint tokens) public returns (bool success) {
82         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
83         balances[to] = safeAdd(balances[to], tokens);
84         emit Transfer(msg.sender, to, tokens);
85         return true;
86     }
87     function approve(address spender, uint tokens) public returns (bool success) {
88         allowed[msg.sender][spender] = tokens;
89         emit Approval(msg.sender, spender, tokens);
90         return true;
91     }
92     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
93         balances[from] = safeSub(balances[from], tokens);
94         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
95         balances[to] = safeAdd(balances[to], tokens);
96         emit Transfer(from, to, tokens);
97         return true;
98     }
99     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
100         return allowed[tokenOwner][spender];
101     }
102     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
103         allowed[msg.sender][spender] = tokens;
104         emit Approval(msg.sender, spender, tokens);
105         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
106         return true;
107     }
108     function () public payable {
109         revert();
110     }
111     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
112         return ERC20Interface(tokenAddress).transfer(owner, tokens);
113     }
114 }