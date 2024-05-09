1 pragma solidity ^0.4.18;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 // Safe maths
7 // ----------------------------------------------------------------------------
8 contract SafeMath {
9     function safeAdd(uint a, uint b) public pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function safeSub(uint a, uint b) public pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function safeMul(uint a, uint b) public pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function safeDiv(uint a, uint b) public pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 
28 // ----------------------------------------------------------------------------
29 // ERC Token Standard #20 Interface
30 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
31 // ----------------------------------------------------------------------------
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
45 // ----------------------------------------------------------------------------
46 // Contract function to receive approval and execute function in one call
47 //
48 // Borrowed from MiniMeToken
49 // ----------------------------------------------------------------------------
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Owned contract
57 // ----------------------------------------------------------------------------
58 contract Owned {
59     address public owner;
60     address public newOwner;
61 
62     event OwnershipTransferred(address indexed _from, address indexed _to);
63 
64     function Owned() public {
65         owner = msg.sender;
66     }
67 
68     modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     function transferOwnership(address _newOwner) public onlyOwner {
74         newOwner = _newOwner;
75     }
76     function acceptOwnership() public {
77         require(msg.sender == newOwner);
78         OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80         newOwner = address(0);
81     }
82 }
83 
84 
85 // ----------------------------------------------------------------------------
86 // ERC20 Token, with the addition of symbol, name and decimals and assisted
87 // token transfers
88 // ----------------------------------------------------------------------------
89 contract FEELCOIN is ERC20Interface, Owned, SafeMath {
90     string public symbol;
91     string public  name;
92     uint8 public decimals;
93     uint public _totalSupply;
94  uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
95     uint256 public totalEthInWei;   
96     address public fundsWallet;  
97     mapping(address => uint) balances;
98     mapping(address => mapping(address => uint)) allowed;
99 
100 
101     // ------------------------------------------------------------------------
102     // Constructor
103     // ------------------------------------------------------------------------
104     function FEELCOIN() public {
105         symbol = "FEEL";
106         name = "FEELCOIN";
107         decimals = 18;
108         _totalSupply = 1000000000000000000000000000;
109         balances[0xAD19FaF937Ca10b63bC059C0b2EF855a54151647] = _totalSupply;
110         Transfer(address(0), 0xAD19FaF937Ca10b63bC059C0b2EF855a54151647, _totalSupply);
111          unitsOneEthCanBuy = 1000000;                                      // Set the price of your token for the ICO (CHANGE THIS)
112         fundsWallet = msg.sender;   
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
205 
206          totalEthInWei = totalEthInWei + msg.value;
207         uint256 amount = msg.value * unitsOneEthCanBuy;
208         if (amount < 1e15) {
209             return;
210         }
211 
212         balances[fundsWallet] = balances[fundsWallet] - amount;
213         balances[msg.sender] = balances[msg.sender] + amount;
214 
215         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
216 
217         //Transfer ether to fundsWallet
218         fundsWallet.transfer(msg.value); 
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