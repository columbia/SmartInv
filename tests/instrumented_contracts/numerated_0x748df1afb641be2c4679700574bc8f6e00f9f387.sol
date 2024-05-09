1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Grand50' ERC20 token contract
5 // Symbol      : G50
6 // Name        : Grand50(G50)
7 // Total supply: 10000000000 
8 // Decimals    : 18
9 
10 contract SafeMath {
11     function safeAdd(uint a, uint b) public pure returns (uint c) {
12         c = a + b;
13         require(c >= a);
14     }
15     function safeSub(uint a, uint b) public pure returns (uint c) {
16         require(b <= a);
17         c = a - b;
18     }
19     function safeMul(uint a, uint b) public pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b);
22     }
23     function safeDiv(uint a, uint b) public pure returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 
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
42 
43 contract ApproveAndCallFallBack {
44     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
45 }
46 
47 
48 contract Owned {
49     address public owner;
50     address public newOwner;
51 
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53 
54     constructor() public {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address _newOwner) public onlyOwner {
64         newOwner = _newOwner;
65     }
66     function acceptOwnership() public {
67         require(msg.sender == newOwner);
68         emit OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70         newOwner = address(0);
71     }
72 }
73 
74 
75 // ----------------------------------------------------------------------------
76 // ERC20 Token, with the addition of symbol, name and decimals and assisted
77 // token transfers
78 // ----------------------------------------------------------------------------
79 contract Grand50Token is ERC20Interface, Owned, SafeMath {
80     string public symbol;
81     string public  name;
82     uint8 public decimals;
83     uint public _totalSupply;
84 
85     mapping(address => uint) balances;
86     mapping(address => mapping(address => uint)) allowed;
87 
88 
89     // ------------------------------------------------------------------------
90     // Constructor
91     // ------------------------------------------------------------------------
92     constructor() public {
93         symbol = "G50";
94         name = "Grand50";
95         decimals = 18;
96         _totalSupply = 10000000000 ether;
97         balances[msg.sender] = _totalSupply;
98         emit Transfer(address(0), msg.sender, _totalSupply);
99     }
100 
101 
102     // ------------------------------------------------------------------------
103     // Total supply
104     // ------------------------------------------------------------------------
105     function totalSupply() public constant returns (uint) {
106         return _totalSupply  - balances[address(0)];
107     }
108 
109 
110     // ------------------------------------------------------------------------
111     // Get the token balance for account tokenOwner
112     // ------------------------------------------------------------------------
113     function balanceOf(address tokenOwner) public constant returns (uint balance) {
114         return balances[tokenOwner];
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Transfer the balance from token owner's account to to account
120     // - Owner's account must have sufficient balance to transfer
121     // - 0 value transfers are allowed
122     // ------------------------------------------------------------------------
123     function transfer(address to, uint tokens) public returns (bool success) {
124         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
125         balances[to] = safeAdd(balances[to], tokens);
126         emit Transfer(msg.sender, to, tokens);
127         return true;
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Token owner can approve for spender to transferFrom(...) tokens
133     // from the token owner's account
134   
135     // ------------------------------------------------------------------------
136     function approve(address spender, uint tokens) public returns (bool success) {
137         allowed[msg.sender][spender] = tokens;
138         emit Approval(msg.sender, spender, tokens);
139         return true;
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Transfer tokens from the from account to the to account
145     // 
146     // The calling account must already have sufficient tokens approve(...)-d
147     // for spending from the from account and
148     // - From account must have sufficient balance to transfer
149     // - Spender must have sufficient allowance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
153         balances[from] = safeSub(balances[from], tokens);
154         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
155         balances[to] = safeAdd(balances[to], tokens);
156         emit Transfer(from, to, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Returns the amount of tokens approved by the owner that can be
163     // transferred to the spender's account
164     // ------------------------------------------------------------------------
165     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
166         return allowed[tokenOwner][spender];
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Token owner can approve for spender to transferFrom(...) tokens
172     // from the token owner's account. The spender contract function
173     // receiveApproval(...) is then executed
174     // ------------------------------------------------------------------------
175     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
176         allowed[msg.sender][spender] = tokens;
177         emit Approval(msg.sender, spender, tokens);
178         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Don't accept ETH
185     // ------------------------------------------------------------------------
186     function () public payable {
187         revert();
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Owner can transfer out any accidentally sent ERC20 tokens
193     // ------------------------------------------------------------------------
194     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
195         return ERC20Interface(tokenAddress).transfer(owner, tokens);
196     }
197 }