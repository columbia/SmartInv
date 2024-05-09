1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Interface Contract
6 // ----------------------------------------------------------------------------
7 contract ERC20Interface {
8     function totalSupply() public constant returns (uint);
9     function balanceOf(address tokenOwner) public constant returns (uint balance);
10     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 
20 contract ApproveAndCallFallBack {
21     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
22 }
23 
24 
25 // ----------------------------------------------------------------------------
26 // Owned contract
27 // ----------------------------------------------------------------------------
28 contract Owned {
29     address public owner;
30     address public newOwner;
31 
32     event OwnershipTransferred(address indexed _from, address indexed _to);
33 
34     function Owned() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address _newOwner) public onlyOwner {
44         newOwner = _newOwner;
45     }
46     function acceptOwnership() public {
47         require(msg.sender == newOwner);
48         OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50         newOwner = address(0);
51     }
52 }
53 
54 // ----------------------------------------------------------------------------
55 // Safe maths - SafeMath
56 // ----------------------------------------------------------------------------
57 contract SafeMath {
58     function safeAdd(uint a, uint b) public pure returns (uint c) {
59         c = a + b;
60         require(c >= a);
61     }
62     function safeSub(uint a, uint b) public pure returns (uint c) {
63         require(b <= a);
64         c = a - b;
65     }
66     function safeMul(uint a, uint b) public pure returns (uint c) {
67         c = a * b;
68         require(a == 0 || c / a == b);
69     }
70     function safeDiv(uint a, uint b) public pure returns (uint c) {
71         require(b > 0);
72         c = a / b;
73     }
74 }
75 
76 
77 // ----------------------------------------------------------------------------
78 // ERC20 Token
79 // ----------------------------------------------------------------------------
80 contract UPCHAINS is ERC20Interface, Owned, SafeMath {
81     string public symbol;
82     string public  name;
83     uint8 public decimals;
84     uint public _totalSupply;
85 
86     mapping(address => uint) balances;
87     mapping(address => mapping(address => uint)) allowed;
88 
89 
90     // ------------------------------------------------------------------------
91     // Constructor 
92     // ------------------------------------------------------------------------
93     function UPCHAINS() public {
94         symbol = "UCH";
95         name = "UPCHAINS";
96         decimals = 18;
97         _totalSupply = 500000000 * (10**18);
98         balances[0xcEc7254Cfb69813285Fc4d2A1131b6b26Eeef86D] = _totalSupply;
99         Transfer(address(0), 0xcEc7254Cfb69813285Fc4d2A1131b6b26Eeef86D, _totalSupply);
100     }
101 
102 
103     // ------------------------------------------------------------------------
104     // Total supply
105     // ------------------------------------------------------------------------
106     function totalSupply() public constant returns (uint) {
107         return _totalSupply  - balances[address(0)];
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Get the token balance for account tokenOwner
113     // ------------------------------------------------------------------------
114     function balanceOf(address tokenOwner) public constant returns (uint balance) {
115         return balances[tokenOwner];
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Transfer the balance from token owner's account to to account
121     // - Owner's account must have sufficient balance to transfer
122     // - 0 value transfers are allowed
123     // ------------------------------------------------------------------------
124     function transfer(address to, uint tokens) public returns (bool success) {
125         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
126         balances[to] = safeAdd(balances[to], tokens);
127         Transfer(msg.sender, to, tokens);
128         return true;
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Token owner can approve for spender to transferFrom(...) tokens
134     // from the token owner's account
135     //
136     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
137     // recommends that there are no checks for the approval double-spend attack
138     // as this should be implemented in user interfaces 
139     // ------------------------------------------------------------------------
140     function approve(address spender, uint tokens) public returns (bool success) {
141         allowed[msg.sender][spender] = tokens;
142         Approval(msg.sender, spender, tokens);
143         return true;
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Transfer tokens from the from account to the to account
149     // 
150     // The calling account must already have sufficient tokens approve(...)-d
151     // for spending from the from account and
152     // - From account must have sufficient balance to transfer
153     // - Spender must have sufficient allowance to transfer
154     // - 0 value transfers are allowed
155     // ------------------------------------------------------------------------
156     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
157         balances[from] = safeSub(balances[from], tokens);
158         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
159         balances[to] = safeAdd(balances[to], tokens);
160         Transfer(from, to, tokens);
161         return true;
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Returns the amount of tokens approved by the owner that can be
167     // transferred to the spender's account
168     // ------------------------------------------------------------------------
169     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
170         return allowed[tokenOwner][spender];
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Token owner can approve for spender to transferFrom(...) tokens
176     // from the token owner's account. The spender contract function
177     // receiveApproval(...) is then executed
178     // ------------------------------------------------------------------------
179     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
180         allowed[msg.sender][spender] = tokens;
181         Approval(msg.sender, spender, tokens);
182         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Don't accept ETH
189     // ------------------------------------------------------------------------
190     function () public payable {
191         revert();
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Owner can transfer out any accidentally sent ERC20 tokens
197     // ------------------------------------------------------------------------
198     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
199         return ERC20Interface(tokenAddress).transfer(owner, tokens);
200     }
201 }