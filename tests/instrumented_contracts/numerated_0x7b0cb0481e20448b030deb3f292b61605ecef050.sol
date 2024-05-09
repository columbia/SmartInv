1 pragma solidity ^0.4.18;
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
40     function Owned() public {
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
54         OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56         newOwner = address(0);
57     }
58 }
59 contract HLCN is ERC20Interface, Owned, SafeMath {
60     string public symbol;
61     string public  name;
62     uint8 public decimals;
63     uint public _totalSupply;
64     mapping(address => uint) balances;
65     mapping(address => mapping(address => uint)) allowed;
66     function HLCN() public {
67         symbol = "HLCN";
68         name = "Healthy Coin";
69         decimals = 18;
70         _totalSupply = 210000000000000000000000000;
71         balances[0x02DEA85397EF756307F9751693872d54d0B75A2c] = _totalSupply;
72         Transfer(address(0), 0x02DEA85397EF756307F9751693872d54d0B75A2c, _totalSupply);
73     }
74     function totalSupply() public constant returns (uint) {
75         return _totalSupply  - balances[address(0)];
76     }
77     function balanceOf(address tokenOwner) public constant returns (uint balance) {
78         return balances[tokenOwner];
79     }
80     function transfer(address to, uint tokens) public returns (bool success) {
81         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
82         balances[to] = safeAdd(balances[to], tokens);
83         Transfer(msg.sender, to, tokens);
84         return true;
85     }
86     function approve(address spender, uint tokens) public returns (bool success) {
87         allowed[msg.sender][spender] = tokens;
88         Approval(msg.sender, spender, tokens);
89         return true;
90     }
91     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
92         balances[from] = safeSub(balances[from], tokens);
93         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
94         balances[to] = safeAdd(balances[to], tokens);
95         Transfer(from, to, tokens);
96         return true;
97     }
98     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
99         return allowed[tokenOwner][spender];
100     }
101     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
102         allowed[msg.sender][spender] = tokens;
103         Approval(msg.sender, spender, tokens);
104         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
105         return true;
106     }
107     function () public payable {
108         revert();
109     }
110     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
111         return ERC20Interface(tokenAddress).transfer(owner, tokens);
112     }
113 }