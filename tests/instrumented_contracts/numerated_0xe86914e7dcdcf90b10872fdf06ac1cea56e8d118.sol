1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // DecalinxCoin contract
5 // Deployed to : 0x00175175537E92B33227A2F5a1E886fF1abf2aB0
6 // Symbol      : ÐCC
7 // Name        : DecalinxCoin
8 // Total supply: 1,000,000,000
9 // Decimals    : 18
10 // Enjoy.
11 //
12 // (c) by DecalinxCoin Ecosystem
13 // ----------------------------------------------------------------------------
14 
15 
16 contract SafeMath {
17     function safeAdd(uint a, uint b) public pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function safeSub(uint a, uint b) public pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function safeMul(uint a, uint b) public pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function safeDiv(uint a, uint b) public pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 contract ERC20Interface {
37     function totalSupply() public constant returns (uint);
38     function balanceOf(address tokenOwner) public constant returns (uint balance);
39     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
40     function transfer(address to, uint tokens) public returns (bool success);
41     function approve(address spender, uint tokens) public returns (bool success);
42     function transferFrom(address from, address to, uint tokens) public returns (bool success);
43 
44     event Transfer(address indexed from, address indexed to, uint tokens);
45     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
46 }
47 
48 
49 // ----------------------------------------------------------------------------
50 // Contract function to receive approval and execute function in one call
51 //
52 // Borrowed from MiniMeToken
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address public owner;
64     address public newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     function Owned() public {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address _newOwner) public onlyOwner {
78         newOwner = _newOwner;
79     }
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84         newOwner = address(0);
85     }
86 }
87 
88 
89 // ----------------------------------------------------------------------------
90 // ERC20 Token, with the addition of symbol, name and decimals and assisted
91 // token transfers
92 // ----------------------------------------------------------------------------
93 contract DecalinxCoin is ERC20Interface, Owned, SafeMath {
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint public _totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     function DecalinxCoin() public {
107         symbol = "ÐCC";
108         name = "DecalinxCoin";
109         decimals = 18;
110         _totalSupply = 1000000000 * 10 ** uint256(decimals);
111         balances[0x00175175537E92B33227A2F5a1E886fF1abf2aB0] = _totalSupply;
112         Transfer(address(0), 0x00175175537E92B33227A2F5a1E886fF1abf2aB0, _totalSupply);
113         
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Total supply
119     // ------------------------------------------------------------------------
120     function totalSupply() public constant returns (uint) {
121         return _totalSupply  - balances[address(0)];
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Get the token balance for account tokenOwner
127     // ------------------------------------------------------------------------
128     function balanceOf(address tokenOwner) public constant returns (uint balance) {
129         return balances[tokenOwner];
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Transfer the balance from token owner's account to to account
135     // - Owner's account must have sufficient balance to transfer
136     // - 0 value transfers are allowed
137     // ------------------------------------------------------------------------
138     function transfer(address to, uint tokens) public returns (bool success) {
139         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
140         balances[to] = safeAdd(balances[to], tokens);
141         Transfer(msg.sender, to, tokens);
142         return true;
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Token owner can approve for spender to transferFrom(...) tokens
148     // from the token owner's account
149     //
150     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
151     // recommends that there are no checks for the approval double-spend attack
152     // as this should be implemented in user interfaces
153     // ------------------------------------------------------------------------
154     function approve(address spender, uint tokens) public returns (bool success) {
155         allowed[msg.sender][spender] = tokens;
156         Approval(msg.sender, spender, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Transfer tokens from the from account to the to account
163     //
164     // The calling account must already have sufficient tokens approve(...)-d
165     // for spending from the from account and
166     // - From account must have sufficient balance to transfer
167     // - Spender must have sufficient allowance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
171         balances[from] = safeSub(balances[from], tokens);
172         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
173         balances[to] = safeAdd(balances[to], tokens);
174         Transfer(from, to, tokens);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Returns the amount of tokens approved by the owner that can be
181     // transferred to the spender's account
182     // ------------------------------------------------------------------------
183     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
184         return allowed[tokenOwner][spender];
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Token owner can approve for spender to transferFrom(...) tokens
190     // from the token owner's account. The spender contract function
191     // receiveApproval(...) is then executed
192     // ------------------------------------------------------------------------
193     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
194         allowed[msg.sender][spender] = tokens;
195         Approval(msg.sender, spender, tokens);
196         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
197         return true;
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Don't accept ETH
203     // ------------------------------------------------------------------------
204     function () public payable {
205         revert();
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Owner can transfer out any accidentally sent ERC20 tokens
211     // ------------------------------------------------------------------------
212     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
213         return ERC20Interface(tokenAddress).transfer(owner, tokens);
214     }
215 }