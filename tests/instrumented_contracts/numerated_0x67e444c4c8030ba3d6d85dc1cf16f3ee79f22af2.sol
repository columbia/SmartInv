1 /**
2  *Submitted for verification at Etherscan.io on 2018-07-18
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 // ----------------------------------------------------------------------------
8 // 'MoonToken' token contract
9 //
10 // Deployed to : 0x37efd6a702E171218380cf6B1f898A07632A7d60
11 // Symbol      : MOON
12 // Name        : MOON TOKEN
13 // Total supply: 10000000000
14 // Decimals    : 18
15 //
16 // Enjoy.
17 //
18 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
19 // (c) by Rakuraku Jyo
20 // ----------------------------------------------------------------------------
21 
22 
23 // ----------------------------------------------------------------------------
24 // Safe maths
25 // ----------------------------------------------------------------------------
26 contract SafeMath {
27     function safeAdd(uint a, uint b) public pure returns (uint c) {
28         c = a + b;
29         require(c >= a);
30     }
31     function safeSub(uint a, uint b) public pure returns (uint c) {
32         require(b <= a);
33         c = a - b;
34     }
35     function safeMul(uint a, uint b) public pure returns (uint c) {
36         c = a * b;
37         require(a == 0 || c / a == b);
38     }
39     function safeDiv(uint a, uint b) public pure returns (uint c) {
40         require(b > 0);
41         c = a / b;
42     }
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 // ERC Token Standard #20 Interface
48 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
49 // ----------------------------------------------------------------------------
50 contract ERC20Interface {
51     function totalSupply() public constant returns (uint);
52     function balanceOf(address tokenOwner) public constant returns (uint balance);
53     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
54     function transfer(address to, uint tokens) public returns (bool success);
55     function approve(address spender, uint tokens) public returns (bool success);
56     function transferFrom(address from, address to, uint tokens) public returns (bool success);
57 
58     event Transfer(address indexed from, address indexed to, uint tokens);
59     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // Contract function to receive approval and execute function in one call
65 //
66 // Borrowed from MiniMeToken
67 // ----------------------------------------------------------------------------
68 contract ApproveAndCallFallBack {
69     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
70 }
71 
72 
73 // ----------------------------------------------------------------------------
74 // Owned contract
75 // ----------------------------------------------------------------------------
76 contract Owned {
77     address public owner;
78     address public newOwner;
79 
80     event OwnershipTransferred(address indexed _from, address indexed _to);
81 
82     function Owned() public {
83         owner = msg.sender;
84     }
85 
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     function transferOwnership(address _newOwner) public onlyOwner {
92         newOwner = _newOwner;
93     }
94     function acceptOwnership() public {
95         require(msg.sender == newOwner);
96         OwnershipTransferred(owner, newOwner);
97         owner = newOwner;
98         newOwner = address(0);
99     }
100 }
101 
102 
103 // ----------------------------------------------------------------------------
104 // ERC20 Token, with the addition of symbol, name and decimals and assisted
105 // token transfers
106 // ----------------------------------------------------------------------------
107 contract MoonToken is ERC20Interface, Owned, SafeMath {
108     string public symbol;
109     string public  name;
110     uint8 public decimals;
111     uint public _totalSupply;
112 
113     mapping(address => uint) balances;
114     mapping(address => mapping(address => uint)) allowed;
115 
116 
117     // ------------------------------------------------------------------------
118     // Constructor
119     // ------------------------------------------------------------------------
120     function MoonToken() public {
121         symbol = "MOON";
122         name = "MOON Token";
123         decimals = 18;
124         _totalSupply = 10000000000000000000000000000;
125         balances[0x37efd6a702E171218380cf6B1f898A07632A7d60] = _totalSupply;
126         Transfer(address(0), 0x37efd6a702E171218380cf6B1f898A07632A7d60, _totalSupply);
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Total supply
132     // ------------------------------------------------------------------------
133     function totalSupply() public constant returns (uint) {
134         return _totalSupply  - balances[address(0)];
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Get the token balance for account tokenOwner
140     // ------------------------------------------------------------------------
141     function balanceOf(address tokenOwner) public constant returns (uint balance) {
142         return balances[tokenOwner];
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Transfer the balance from token owner's account to to account
148     // - Owner's account must have sufficient balance to transfer
149     // - 0 value transfers are allowed
150     // ------------------------------------------------------------------------
151     function transfer(address to, uint tokens) public returns (bool success) {
152         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
153         balances[to] = safeAdd(balances[to], tokens);
154         Transfer(msg.sender, to, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Token owner can approve for spender to transferFrom(...) tokens
161     // from the token owner's account
162     //
163     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
164     // recommends that there are no checks for the approval double-spend attack
165     // as this should be implemented in user interfaces
166     // ------------------------------------------------------------------------
167     function approve(address spender, uint tokens) public returns (bool success) {
168         allowed[msg.sender][spender] = tokens;
169         Approval(msg.sender, spender, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Transfer tokens from the from account to the to account
176     //
177     // The calling account must already have sufficient tokens approve(...)-d
178     // for spending from the from account and
179     // - From account must have sufficient balance to transfer
180     // - Spender must have sufficient allowance to transfer
181     // - 0 value transfers are allowed
182     // ------------------------------------------------------------------------
183     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
184         balances[from] = safeSub(balances[from], tokens);
185         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
186         balances[to] = safeAdd(balances[to], tokens);
187         Transfer(from, to, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Returns the amount of tokens approved by the owner that can be
194     // transferred to the spender's account
195     // ------------------------------------------------------------------------
196     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
197         return allowed[tokenOwner][spender];
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Token owner can approve for spender to transferFrom(...) tokens
203     // from the token owner's account. The spender contract function
204     // receiveApproval(...) is then executed
205     // ------------------------------------------------------------------------
206     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
207         allowed[msg.sender][spender] = tokens;
208         Approval(msg.sender, spender, tokens);
209         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
210         return true;
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Don't accept ETH
216     // ------------------------------------------------------------------------
217     function () public payable {
218         revert();
219     }
220 
221 
222     // ------------------------------------------------------------------------
223     // Owner can transfer out any accidentally sent ERC20 tokens
224     // ------------------------------------------------------------------------
225     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
226         return ERC20Interface(tokenAddress).transfer(owner, tokens);
227     }
228 }