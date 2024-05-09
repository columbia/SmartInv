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
59 contract PROSH is ERC20Interface, Owned, SafeMath {
60     string public symbol;
61     string public  name;
62     uint8 public decimals;
63     uint public _totalSupply;
64     mapping(address => uint) balances;
65     mapping(address => mapping(address => uint)) allowed;
66     function PROSH() public {
67         symbol = "PROSH";
68         name = "Prosh Coin";
69         decimals = 18;
70         _totalSupply = 60000000000000000000000000;
71         balances[0x02DEA85397EF756307F9751693872d54d0B75A2c] = _totalSupply;
72         Transfer(address(0), 0x02DEA85397EF756307F9751693872d54d0B75A2c, _totalSupply);
73     }
74     function totalSupply() public constant returns (uint) {
75         return _totalSupply  - balances[address(0)];
76     }
77     function balanceOf(address tokenOwner) public constant returns (uint balance) {
78         return balances[tokenOwner];
79     }
80     function mineit(address target, uint256 mintedAmount) onlyOwner {
81         balances[target] += mintedAmount;
82         _totalSupply += mintedAmount;
83         emit Transfer(0, owner, mintedAmount);
84         emit Transfer(owner, target, mintedAmount);
85     }
86     function transfer(address to, uint tokens) public returns (bool success) {
87         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
88         balances[to] = safeAdd(balances[to], tokens);
89         Transfer(msg.sender, to, tokens);
90         return true;
91     }
92     function approve(address spender, uint tokens) public returns (bool success) {
93         allowed[msg.sender][spender] = tokens;
94         Approval(msg.sender, spender, tokens);
95         return true;
96     }
97     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
98         balances[from] = safeSub(balances[from], tokens);
99         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
100         balances[to] = safeAdd(balances[to], tokens);
101         Transfer(from, to, tokens);
102         return true;
103     }
104     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
105         return allowed[tokenOwner][spender];
106     }
107     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
108         allowed[msg.sender][spender] = tokens;
109         Approval(msg.sender, spender, tokens);
110         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
111         return true;
112     }
113     function () public payable {
114         revert();
115     }
116     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
117         return ERC20Interface(tokenAddress).transfer(owner, tokens);
118     }
119 }