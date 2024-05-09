1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 //All Rights Reserved 2019 rexcoin.online
5 
6 // 'owner 0x3D3C716A902751Ba4996d85DC6F3DDcd8d1404c2
7 // 'contract 
8 // '
9 // 
10 
11 //**********************
12 // Symbol      : Rex
13 // Name        : RexCoin
14 // Total supply: 3,000,000,000
15 // Decimals    : 18
16 //
17 // Enjoy.
18 // 
19 //
20 // (c) RexCoin TEAM 2019
21 // ----------------------------------------------------------------------------
22 
23 
24 // ----------------------------------------------------------------------------
25 // Safe maths
26 // ----------------------------------------------------------------------------
27 contract SafeMath {
28     function safeAdd(uint a, uint b) public pure returns (uint c) {
29         c = a + b;
30         require(c >= a);
31     }
32     function safeSub(uint a, uint b) public pure returns (uint c) {
33         require(b <= a);
34         c = a - b;
35     }
36     function safeMul(uint a, uint b) public pure returns (uint c) {
37         c = a * b;
38         require(a == 0 || c / a == b);
39     }
40     function safeDiv(uint a, uint b) public pure returns (uint c) {
41         require(b > 0);
42         c = a / b;
43     }
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 // ERC Token Standard #20 Interface
49 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
50 // ----------------------------------------------------------------------------
51 contract ERC20Interface {
52     function totalSupply() public constant returns (uint);
53     function balanceOf(address tokenOwner) public constant returns (uint balance);
54     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
55     function transfer(address to, uint tokens) public returns (bool success);
56     function approve(address spender, uint tokens) public returns (bool success);
57     function transferFrom(address from, address to, uint tokens) public returns (bool success);
58 
59     event Transfer(address indexed from, address indexed to, uint tokens);
60     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // Contract function to receive approval and execute function in one call
66 //
67 // Borrowed from MiniMeToken
68 // ----------------------------------------------------------------------------
69 contract ApproveAndCallFallBack {
70     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
71 }
72 
73 
74 // ----------------------------------------------------------------------------
75 // Owned contract
76 // ----------------------------------------------------------------------------
77 contract Owned {
78     address public owner;
79     address public newOwner;
80 
81     event OwnershipTransferred(address indexed _from, address indexed _to);
82 
83     constructor() public {
84         owner = msg.sender;
85     }
86 
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function transferOwnership(address _newOwner) public onlyOwner {
93         newOwner = _newOwner;
94     }
95     function acceptOwnership() public {
96         require(msg.sender == newOwner);
97         emit OwnershipTransferred(owner, newOwner);
98         owner = newOwner;
99         newOwner = address(0);
100     }
101 }
102 
103 
104 // ----------------------------------------------------------------------------
105 // ERC20 Token, with the addition of symbol, name and decimals and assisted
106 // token transfers 
107 // ----------------------------------------------------------------------------
108 contract RexCoin is ERC20Interface, Owned, SafeMath {
109     string public symbol;
110     string public  name;
111     uint8 public decimals;
112     uint public _totalSupply;
113 
114     mapping(address => uint) balances;
115     mapping(address => mapping(address => uint)) allowed;
116 
117 
118     // ------------------------------------------------------------------------
119     // Constructor
120     // ------------------------------------------------------------------------
121     constructor () public {
122         symbol = "REX";
123         name = "RexCoin";
124         decimals = 18;
125         _totalSupply = 3000000000000000000000000000;
126         balances[0x3D3C716A902751Ba4996d85DC6F3DDcd8d1404c2] = _totalSupply;
127         emit Transfer(address(0), 0x3D3C716A902751Ba4996d85DC6F3DDcd8d1404c2, _totalSupply);
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Total supply
133     // ------------------------------------------------------------------------
134     function totalSupply() public constant returns (uint) {
135         return _totalSupply  - balances[address(0)];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Get the token balance for account tokenOwner
141     // ------------------------------------------------------------------------
142     function balanceOf(address tokenOwner) public constant returns (uint balance) {
143         return balances[tokenOwner];
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Transfer the balance from token owner's account to to account
149     // - Owner's account must have sufficient balance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152     function transfer(address to, uint tokens) public returns (bool success) {
153         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
154         balances[to] = safeAdd(balances[to], tokens);
155         emit Transfer(msg.sender, to, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Token owner can approve for spender to transferFrom(...) tokens
162     // from the token owner's account
163     //
164     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
165     // recommends that there are no checks for the approval double-spend attack
166     // as this should be implemented in user interfaces 
167     // ------------------------------------------------------------------------
168     function approve(address spender, uint tokens) public returns (bool success) {
169         allowed[msg.sender][spender] = tokens;
170         emit Approval(msg.sender, spender, tokens);
171         return true;
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Transfer tokens from the from account to the to account
177     // 
178     // The calling account must already have sufficient tokens approve(...)-d
179     // for spending from the from account and
180     // - From account must have sufficient balance to transfer
181     // - Spender must have sufficient allowance to transfer
182     // - 0 value transfers are allowed
183     // ------------------------------------------------------------------------
184     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
185         balances[from] = safeSub(balances[from], tokens);
186         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
187         balances[to] = safeAdd(balances[to], tokens);
188         emit Transfer(from, to, tokens);
189         return true;
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Returns the amount of tokens approved by the owner that can be
195     // transferred to the spender's account
196     // ------------------------------------------------------------------------
197     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
198         return allowed[tokenOwner][spender];
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Token owner can approve for spender to transferFrom(...) tokens
204     // from the token owner's account. The spender contract function
205     // receiveApproval(...) is then executed
206     // ------------------------------------------------------------------------
207     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
208         allowed[msg.sender][spender] = tokens;
209         emit Approval(msg.sender, spender, tokens);
210         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
211         return true;
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Don't accept ETH
217     // ------------------------------------------------------------------------
218     function () public payable {
219         revert();
220     }
221 
222 
223     // ------------------------------------------------------------------------
224     // Owner can transfer out any accidentally sent ERC20 tokens
225     // ------------------------------------------------------------------------
226     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
227         return ERC20Interface(tokenAddress).transfer(owner, tokens);
228     }
229 }