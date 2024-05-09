1 /**
2  * Source Code first verified at https://etherscan.io on Tuesday, April 23, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 // ----------------------------------------------------------------------------
8 // 'ravikirannodecoin' token contract
9 //
10 // Deployed to : 0x3a60ca4b8c9dc941934ae1fd8cf5f9d57e295936
11 // Symbol      : RKCN
12 // Name        : ravikirannodecoin
13 // Total supply: 100000000000000000
14 // Decimals    : 8
15 //
16 // Enjoy.
17 //
18 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
19 // ----------------------------------------------------------------------------
20 
21 
22 // ----------------------------------------------------------------------------
23 // Safe maths
24 // ----------------------------------------------------------------------------
25 contract SafeMath {
26     function safeAdd(uint a, uint b) public pure returns (uint c) {
27         c = a + b;
28         require(c >= a);
29     }
30     function safeSub(uint a, uint b) public pure returns (uint c) {
31         require(b <= a);
32         c = a - b;
33     }
34     function safeMul(uint a, uint b) public pure returns (uint c) {
35         c = a * b;
36         require(a == 0 || c / a == b);
37     }
38     function safeDiv(uint a, uint b) public pure returns (uint c) {
39         require(b > 0);
40         c = a / b;
41     }
42 }
43 
44 
45 // ----------------------------------------------------------------------------
46 // ERC Token Standard #20 Interface
47 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
48 // ----------------------------------------------------------------------------
49 contract ERC20Interface {
50     function totalSupply() public constant returns (uint);
51     function balanceOf(address tokenOwner) public constant returns (uint balance);
52     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
53     function transfer(address to, uint tokens) public returns (bool success);
54     function approve(address spender, uint tokens) public returns (bool success);
55     function transferFrom(address from, address to, uint tokens) public returns (bool success);
56 
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // Contract function to receive approval and execute function in one call
64 //
65 // Borrowed from MiniMeToken
66 // ----------------------------------------------------------------------------
67 contract ApproveAndCallFallBack {
68     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
69 }
70 
71 
72 // ----------------------------------------------------------------------------
73 // Owned contract
74 // ----------------------------------------------------------------------------
75 contract Owned {
76     address public owner;
77     address public newOwner;
78 
79     event OwnershipTransferred(address indexed _from, address indexed _to);
80 
81     constructor() public {
82         owner = msg.sender;
83     }
84 
85     modifier onlyOwner {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     function transferOwnership(address _newOwner) public onlyOwner {
91         newOwner = _newOwner;
92     }
93     function acceptOwnership() public {
94         require(msg.sender == newOwner);
95         emit OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97         newOwner = address(0);
98     }
99 }
100 
101 
102 // ----------------------------------------------------------------------------
103 // ERC20 Token, with the addition of symbol, name and decimals and assisted
104 // token transfers
105 // ----------------------------------------------------------------------------
106 contract ravikirannodecoin is ERC20Interface, Owned, SafeMath {
107     string public symbol;
108     string public  name;
109     uint8 public decimals;
110     uint public _totalSupply;
111 
112     mapping(address => uint) balances;
113     mapping(address => mapping(address => uint)) allowed;
114 
115 
116     // ------------------------------------------------------------------------
117     // Constructor
118     // ------------------------------------------------------------------------
119     function ravikirannodecoin() public {
120         symbol = "RKCN";
121         name = "ravikirannodecoin";
122         decimals = 8;
123         _totalSupply = 20000000000000000;
124         balances[0x3a60ca4b8c9dc941934ae1fd8cf5f9d57e295936] = _totalSupply;
125         emit Transfer(address(0), 0x3a60ca4b8c9dc941934ae1fd8cf5f9d57e295936, _totalSupply);
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Total supply
131     // ------------------------------------------------------------------------
132     function totalSupply() public constant returns (uint) {
133         return _totalSupply  - balances[address(0)];
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Get the token balance for account tokenOwner
139     // ------------------------------------------------------------------------
140     function balanceOf(address tokenOwner) public constant returns (uint balance) {
141         return balances[tokenOwner];
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Transfer the balance from token owner's account to to account
147     // - Owner's account must have sufficient balance to transfer
148     // - 0 value transfers are allowed
149     // ------------------------------------------------------------------------
150     function transfer(address to, uint tokens) public returns (bool success) {
151         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
152         balances[to] = safeAdd(balances[to], tokens);
153         emit Transfer(msg.sender, to, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Token owner can approve for spender to transferFrom(...) tokens
160     // from the token owner's account
161     //
162     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
163     // recommends that there are no checks for the approval double-spend attack
164     // as this should be implemented in user interfaces 
165     // ------------------------------------------------------------------------
166     function approve(address spender, uint tokens) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         emit Approval(msg.sender, spender, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Transfer tokens from the from account to the to account
175     // 
176     // The calling account must already have sufficient tokens approve(...)-d
177     // for spending from the from account and
178     // - From account must have sufficient balance to transfer
179     // - Spender must have sufficient allowance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
183         balances[from] = safeSub(balances[from], tokens);
184         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
185         balances[to] = safeAdd(balances[to], tokens);
186         emit Transfer(from, to, tokens);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Returns the amount of tokens approved by the owner that can be
193     // transferred to the spender's account
194     // ------------------------------------------------------------------------
195     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
196         return allowed[tokenOwner][spender];
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Token owner can approve for spender to transferFrom(...) tokens
202     // from the token owner's account. The spender contract function
203     // receiveApproval(...) is then executed
204     // ------------------------------------------------------------------------
205     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
206         allowed[msg.sender][spender] = tokens;
207         emit Approval(msg.sender, spender, tokens);
208         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
209         return true;
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Don't accept ETH
215     // ------------------------------------------------------------------------
216     function () public payable {
217         revert();
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // Owner can transfer out any accidentally sent ERC20 tokens
223     // ------------------------------------------------------------------------
224     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
225         return ERC20Interface(tokenAddress).transfer(owner, tokens);
226     }
227 }