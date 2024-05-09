1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-05
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 // ----------------------------------------------------------------------------
8 // Safe maths
9 // ----------------------------------------------------------------------------
10 contract SafeMath {
11     function safeAdd(uint a, uint b) public pure returns (uint c) {
12         c = a + b;
13         require(c >= a, "Error");
14     }
15     function safeSub(uint a, uint b) public pure returns (uint c) {
16         require(b <= a, "Error");
17         c = a - b;
18     }
19     function safeMul(uint a, uint b) public pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b, "Error");
22     }
23     function safeDiv(uint a, uint b) public pure returns (uint c) {
24         require(b > 0, "Error");
25         c = a / b;
26     }
27 }
28 
29 
30 // ----------------------------------------------------------------------------
31 // ERC Token Standard #20 Interface
32 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
33 // ----------------------------------------------------------------------------
34 contract ERC20Interface {
35     function totalSupply() public view returns (uint);
36     function balanceOf(address tokenOwner) public view returns (uint balance);
37     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 // Contract function to receive approval and execute function in one call
49 //
50 // Borrowed from MiniMeToken
51 // ----------------------------------------------------------------------------
52 contract ApproveAndCallFallBack {
53     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63 
64     event OwnershipTransferred(address indexed from, address indexed to);
65 
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner, "Sender should be the owner");
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         owner = _newOwner;
77         emit OwnershipTransferred(owner, newOwner);
78     }
79     function acceptOwnership() public {
80         require(msg.sender == newOwner, "Sender should be the owner");
81         emit OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83         newOwner = address(0);
84     }
85 }
86 
87 
88 // ----------------------------------------------------------------------------
89 // ERC20 Token, with the addition of symbol, name and decimals and assisted
90 // token transfers
91 // ----------------------------------------------------------------------------
92 contract ContractDeployer is ERC20Interface, Owned, SafeMath {
93     string public symbol;
94     string public  name;
95     uint8 public decimals;
96     uint public _totalSupply;
97 
98     mapping(address => uint) balances;
99     mapping(address => mapping(address => uint)) allowed;
100 
101 
102     // ------------------------------------------------------------------------
103     // Constructor
104     // ------------------------------------------------------------------------
105     constructor(string _symbol, string _name, uint8 _decimals, uint totalSupply, address _owner) public {
106         symbol = _symbol;
107         name = _name;
108         decimals = _decimals;
109         _totalSupply = totalSupply*10**uint(decimals);
110         balances[_owner] = _totalSupply;
111         emit Transfer(address(0), _owner, _totalSupply);
112         transferOwnership(_owner);
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Total supply
118     // ------------------------------------------------------------------------
119     function totalSupply() public view returns (uint) {
120         return _totalSupply - balances[address(0)];
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Get the token balance for account tokenOwner
126     // ------------------------------------------------------------------------
127     function balanceOf(address tokenOwner) public view returns (uint balance) {
128         return balances[tokenOwner];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Transfer the balance from token owner's account to to account
134     // - Owner's account must have sufficient balance to transfer
135     // - 0 value transfers are allowed
136     // ------------------------------------------------------------------------
137     function transfer(address to, uint tokens) public returns (bool success) {
138         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
139         balances[to] = safeAdd(balances[to], tokens);
140         emit Transfer(msg.sender, to, tokens);
141         return true;
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Token owner can approve for spender to transferFrom(...) tokens
147     // from the token owner's account
148     //
149     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
150     // recommends that there are no checks for the approval double-spend attack
151     // as this should be implemented in user interfaces 
152     // ------------------------------------------------------------------------
153     function approve(address spender, uint tokens) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         emit Approval(msg.sender, spender, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Transfer tokens from the from account to the to account
162     // 
163     // The calling account must already have sufficient tokens approve(...)-d
164     // for spending from the from account and
165     // - From account must have sufficient balance to transfer
166     // - Spender must have sufficient allowance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
170         balances[from] = safeSub(balances[from], tokens);
171         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
172         balances[to] = safeAdd(balances[to], tokens);
173         emit Transfer(from, to, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Returns the amount of tokens approved by the owner that can be
180     // transferred to the spender's account
181     // ------------------------------------------------------------------------
182     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
183         return allowed[tokenOwner][spender];
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Token owner can approve for spender to transferFrom(...) tokens
189     // from the token owner's account. The spender contract function
190     // receiveApproval(...) is then executed
191     // ------------------------------------------------------------------------
192     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
193         allowed[msg.sender][spender] = tokens;
194         emit Approval(msg.sender, spender, tokens);
195         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
196         return true;
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Don't accept ETH
202     // ------------------------------------------------------------------------
203     function () public payable {
204         revert("Ether can't be accepted.");
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Owner can transfer out any accidentally sent ERC20 tokens
210     // ------------------------------------------------------------------------
211     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
212         return ERC20Interface(tokenAddress).transfer(owner, tokens);
213     }
214 }