1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint256);
32     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
34     function transfer(address to, uint256 tokens) public returns (bool success);
35     function approve(address spender, uint256 tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint256 tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     //address public newOwner;
59 
60     //event OwnershipTransferred(address indexed _from, address indexed _to);
61     //event OwnershipTransferInitiated(address indexed _to);
62 
63     function Owned() public {
64         owner = msg.sender;
65     }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71     
72 /*
73     function transferOwnership(address _newOwner) public onlyOwner {
74         newOwner = _newOwner;
75         OwnershipTransferInitiated(_newOwner);
76     }
77     function acceptOwnership() public {
78         require(msg.sender == newOwner);
79         owner = newOwner;
80         OwnershipTransferred(owner, newOwner);
81         newOwner = address(0);
82     }
83     function resetOwner() public onlyOwner{
84         newOwner = address(0);
85     }
86     */
87 }
88 
89 
90 // ----------------------------------------------------------------------------
91 // ERC20 Token, with the addition of symbol, name and decimals and assisted
92 // token transfers
93 // ----------------------------------------------------------------------------
94 contract Coin4Cast is ERC20Interface, Owned, SafeMath {
95     string public symbol;
96     string public  name;
97     uint8 public decimals;
98     uint256 public _totalSupply;
99 
100     mapping(address => uint256) internal balances;
101 	mapping (address => uint256) internal freezeOf;
102     mapping(address => mapping(address => uint256)) internal allowed;
103 
104 
105     // ------------------------------------------------------------------------
106     // Constructor
107     // ------------------------------------------------------------------------
108     function Coin4Cast() public {
109         symbol = 'C4C';
110         name = 'Coin4Cast';
111         decimals = 10;
112         _totalSupply = 1000000000000000000;
113         balances[msg.sender] = _totalSupply;
114         Transfer(address(0), msg.sender, _totalSupply);
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Total supply
120     // ------------------------------------------------------------------------
121     function totalSupply() public constant returns (uint256) {
122         return _totalSupply  - balances[address(0)];
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Get the token balance for account tokenOwner
128     // ------------------------------------------------------------------------
129     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
130         return balances[tokenOwner];
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Transfer the balance from token owner's account to to account
136     // - Owner's account must have sufficient balance to transfer
137     // - 0 value transfers are allowed
138     // ------------------------------------------------------------------------
139     function transfer(address to, uint256 tokens) public returns (bool success) {
140         if (to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
141 		if (tokens <= 0) revert(); 
142 		require(msg.sender != address(0) && msg.sender != to);
143 	    require(to != address(0));
144         if (balances[msg.sender] < tokens) revert();           // Check if the sender has enough
145         if (balances[to] + tokens < balances[to]) revert(); // Check for overflows
146         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
147         balances[to] = safeAdd(balances[to], tokens);
148         Transfer(msg.sender, to, tokens);
149         return true;
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Token owner can approve for spender to transferFrom(...) tokens
155     // from the token owner's account
156     //
157     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
158     // recommends that there are no checks for the approval double-spend attack
159     // as this should be implemented in user interfaces 
160     // ------------------------------------------------------------------------
161     function approve(address spender, uint256 tokens) public returns (bool success) {
162         require(tokens > 0); 
163         allowed[msg.sender][spender] = tokens;
164         Approval(msg.sender, spender, tokens);
165         return true;
166     }
167 	
168 
169     // ------------------------------------------------------------------------
170     // Transfer tokens from the from account to the to account
171     // 
172     // The calling account must already have sufficient tokens approve(...)-d
173     // for spending from the from account and
174     // - From account must have sufficient balance to transfer
175     // - Spender must have sufficient allowance to transfer
176     // - 0 value transfers are allowed
177     // ------------------------------------------------------------------------
178     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
179         if (to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
180 		if (tokens <= 0) revert(); 
181         if (balances[from] < tokens) revert();                 // Check if the sender has enough
182         if (balances[to] + tokens < balances[to]) revert();  // Check for overflows
183         if (tokens > allowed[from][msg.sender]) revert();     // Check allowance
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
196     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
197         return allowed[tokenOwner][spender];
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Token owner can approve for spender to transferFrom(...) tokens
203     // from the token owner's account. The spender contract function
204     // receiveApproval(...) is then executed
205     // ------------------------------------------------------------------------
206     function approveAndCall(address spender, uint256 tokens, bytes data) public returns (bool success) {
207         require(tokens > 0);
208         allowed[msg.sender][spender] = tokens;
209         Approval(msg.sender, spender, tokens);
210         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
211         return true;
212     }
213 
214 
215 	// can accept ether
216 	function() public payable {
217 	    //revert(); //disable receive ether
218     }
219 
220 	// transfer balance to owner
221 	/*
222 	function withdrawEther(uint256 amount)  public onlyOwner returns (bool success){
223 		owner.transfer(amount);
224 		return true;
225 	}*/
226 
227     // ------------------------------------------------------------------------
228     // Owner can transfer out any accidentally sent ERC20 tokens
229     // ------------------------------------------------------------------------
230     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
231         return ERC20Interface(tokenAddress).transfer(owner, tokens);
232     }
233 }