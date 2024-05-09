1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // LabsterX:
5 //    Web: https://www.labsterx.com
6 //    Twitter: https://twitter.com/labsterx
7 // ----------------------------------------------------------------------------
8 
9 contract SafeMath {
10     function safeAdd(uint a, uint b) public pure returns (uint c) {
11         c = a + b;
12         require(c >= a);
13     }
14     function safeSub(uint a, uint b) public pure returns (uint c) {
15         require(b <= a);
16         c = a - b;
17     }
18     function safeMul(uint a, uint b) public pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22     function safeDiv(uint a, uint b) public pure returns (uint c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 
29 contract ERC20Interface {
30     function totalSupply() public constant returns (uint);
31     function balanceOf(address tokenOwner) public constant returns (uint balance);
32     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 
47 contract Owned {
48     address public owner;
49     address public newOwner;
50 
51     event OwnershipTransferred(address indexed _from, address indexed _to);
52 
53     function Owned() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65     function acceptOwnership() public {
66         require(msg.sender == newOwner);
67         OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69         newOwner = address(0);
70     }
71 }
72 
73 
74 contract LabsterXToken is ERC20Interface, Owned, SafeMath {
75     string public symbol;
76     string public  name;
77     uint8 public decimals;
78     uint public _totalSupply;
79 
80     mapping(address => uint) balances;
81     mapping(address => mapping(address => uint)) allowed;
82 
83     function LabsterXToken() public {
84         symbol = "LABX";
85         name = "LabsterX";
86         decimals = 18;
87         _totalSupply = 100000000000000000000000000;
88         balances[0x4524baA98F9a3B9DEC57caae7633936eF96bD708] = _totalSupply;
89         Transfer(address(0), 0x4524baA98F9a3B9DEC57caae7633936eF96bD708, _totalSupply);
90     }
91 
92     function totalSupply() public constant returns (uint) {
93         return _totalSupply  - balances[address(0)];
94     }
95 
96     function balanceOf(address tokenOwner) public constant returns (uint balance) {
97         return balances[tokenOwner];
98     }
99 
100     function transfer(address to, uint tokens) public returns (bool success) {
101         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
102         balances[to] = safeAdd(balances[to], tokens);
103         Transfer(msg.sender, to, tokens);
104         return true;
105     }
106 
107 
108     // ------------------------------------------------------------------------
109     // Token owner can approve for spender to transferFrom(...) tokens
110     // from the token owner's account
111     //
112     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
113     // recommends that there are no checks for the approval double-spend attack
114     // as this should be implemented in user interfaces
115     // ------------------------------------------------------------------------
116     function approve(address spender, uint tokens) public returns (bool success) {
117         allowed[msg.sender][spender] = tokens;
118         Approval(msg.sender, spender, tokens);
119         return true;
120     }
121 
122     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
123         balances[from] = safeSub(balances[from], tokens);
124         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
125         balances[to] = safeAdd(balances[to], tokens);
126         Transfer(from, to, tokens);
127         return true;
128     }
129 
130     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
131         return allowed[tokenOwner][spender];
132     }
133 
134     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
135         allowed[msg.sender][spender] = tokens;
136         Approval(msg.sender, spender, tokens);
137         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
138         return true;
139     }
140 
141     function () public payable {
142         revert();
143     }
144 
145 
146     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
147         return ERC20Interface(tokenAddress).transfer(owner, tokens);
148     }
149 }