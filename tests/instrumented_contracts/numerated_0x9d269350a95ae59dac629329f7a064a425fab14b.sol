1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'SocialHousing' token contract
5 //
6 // Deployed to : 0x124eb6f6cD88FD4FECD5d54E284A1FA6E5452a03
7 // Symbol      : SAHDA
8 // Name        : Social Housing
9 // Total supply: 7000000000
10 // Decimals    : 0
11 
12 contract SafeMath {
13     function safeAdd(uint a, uint b) public pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function safeSub(uint a, uint b) public pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function safeMul(uint a, uint b) public pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function safeDiv(uint a, uint b) public pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 
32 contract ERC20Interface {
33     function totalSupply() public constant returns (uint);
34     function balanceOf(address tokenOwner) public constant returns (uint balance);
35     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
36     function transfer(address to, uint tokens) public returns (bool success);
37     function approve(address spender, uint tokens) public returns (bool success);
38     function transferFrom(address from, address to, uint tokens) public returns (bool success);
39 
40     event Transfer(address indexed from, address indexed to, uint tokens);
41     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 }
43 
44 
45 
46 // ----------------------------------------------------------------------------
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint tokens, address token, bytes data) public;
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // Owned contract
54 // ----------------------------------------------------------------------------
55 contract Owned {
56     address public owner;
57     address public newOwner;
58 
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60 
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address _newOwner) public onlyOwner {
71         newOwner = _newOwner;
72     }
73     function acceptOwnership() public {
74         require(msg.sender == newOwner);
75         emit OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77         newOwner = address(0);
78     }
79 }
80 
81 
82 // ----------------------------------------------------------------------------
83 // ERC20 Token, with the addition of symbol, name and decimals and assisted
84 // token transfers
85 // ----------------------------------------------------------------------------
86 contract SocialHousing is ERC20Interface, Owned, SafeMath {
87     string public symbol;
88     string public  name;
89     uint8 public decimals;
90     uint public _totalSupply;
91 
92     mapping(address => uint) balances;
93     mapping(address => mapping(address => uint)) allowed;
94 
95 
96     // ------------------------------------------------------------------------
97     // Constructor
98     // ------------------------------------------------------------------------
99     constructor() public {
100         symbol = "SAHDA";
101         name = "Social Housing";
102         decimals = 0;
103         _totalSupply = 7000000000;
104         balances[0x124eb6f6cD88FD4FECD5d54E284A1FA6E5452a03] = _totalSupply;
105         emit Transfer(address(0), 0x124eb6f6cD88FD4FECD5d54E284A1FA6E5452a03, _totalSupply);
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Total supply
111     // ------------------------------------------------------------------------
112     function totalSupply() public constant returns (uint) {
113         return _totalSupply  - balances[address(0)];
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Get the token balance for account tokenOwner
119     // ------------------------------------------------------------------------
120     function balanceOf(address tokenOwner) public constant returns (uint balance) {
121         return balances[tokenOwner];
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Transfer the balance from token owner's account to to account
127     // - Owner's account must have sufficient balance to transfer
128     // - 0 value transfers are allowed
129     // ------------------------------------------------------------------------
130     function transfer(address to, uint tokens) public returns (bool success) {
131         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
132         balances[to] = safeAdd(balances[to], tokens);
133         emit Transfer(msg.sender, to, tokens);
134         return true;
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Token owner can approve for spender to transferFrom(...) tokens
140     // from the token owner's account
141     //
142     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
143     // recommends that there are no checks for the approval double-spend attack
144     // as this should be implemented in user interfaces 
145     // ------------------------------------------------------------------------
146     function approve(address spender, uint tokens) public returns (bool success) {
147         allowed[msg.sender][spender] = tokens;
148         emit Approval(msg.sender, spender, tokens);
149         return true;
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Transfer tokens from the from account to the to account
155     // 
156     // The calling account must already have sufficient tokens approve(...)-d
157     // for spending from the from account and
158     // - From account must have sufficient balance to transfer
159     // - Spender must have sufficient allowance to transfer
160     // - 0 value transfers are allowed
161     // ------------------------------------------------------------------------
162     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
163         balances[from] = safeSub(balances[from], tokens);
164         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
165         balances[to] = safeAdd(balances[to], tokens);
166         emit Transfer(from, to, tokens);
167         return true;
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Returns the amount of tokens approved by the owner that can be
173     // transferred to the spender's account
174     // ------------------------------------------------------------------------
175     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
176         return allowed[tokenOwner][spender];
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Token owner can approve for spender to transferFrom(...) tokens
182     // from the token owner's account. The spender contract function
183     // receiveApproval(...) is then executed
184     // ------------------------------------------------------------------------
185     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
186         allowed[msg.sender][spender] = tokens;
187         emit Approval(msg.sender, spender, tokens);
188         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
189         return true;
190     }
191 
192     // ------------------------------------------------------------------------
193     function () public payable {
194         revert();
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Owner can transfer out any accidentally sent ERC20 tokens
200     // ------------------------------------------------------------------------
201     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
202         return ERC20Interface(tokenAddress).transfer(owner, tokens);
203     }
204 }