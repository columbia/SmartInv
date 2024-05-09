1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'BitEsprit Coin' token contract
5 //
6 // Symbol      : BEC
7 // Name        : BitEsprit Coin
8 // Total supply: 100000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) public pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) public pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51     // This notifies clients about the amount burnt
52     event Burn(address indexed from, uint256 value);
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Contract function to receive approval and execute function in one call
58 //
59 // Borrowed from MiniMeToken
60 // ----------------------------------------------------------------------------
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 contract Owned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     function Owned() public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83     
84     function transferOwnership(address _newOwner) public onlyOwner {
85         newOwner = _newOwner;
86     }
87     
88     function acceptOwnership() public {
89         require(msg.sender == newOwner);
90         OwnershipTransferred(owner, newOwner);
91         owner = newOwner;
92         newOwner = address(0);
93     }
94 }
95 
96 
97 // ----------------------------------------------------------------------------
98 // ERC20 Token, with the addition of symbol, name and decimals and assisted
99 // token transfers
100 // ----------------------------------------------------------------------------
101 contract BitEspritCoin is ERC20Interface, Owned, SafeMath {
102     string public symbol;
103     string public  name;
104     uint8 public decimals;
105     uint public _totalSupply;
106 
107     mapping(address => uint) _balances;
108     mapping(address => mapping(address => uint)) allowed;
109 
110 
111     // ------------------------------------------------------------------------
112     // Constructor
113     // ------------------------------------------------------------------------
114     function BitEspritCoin() public {
115         symbol = "BEC";
116         name = "BitEsprit Coin";
117         decimals = 18;
118         _totalSupply = 100000000000000000000000000;
119         _balances[msg.sender] = _totalSupply;
120         Transfer(address(0), msg.sender, _totalSupply);
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Total supply
126     // ------------------------------------------------------------------------
127     function totalSupply() public constant returns (uint) {
128         return _totalSupply;
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Get the token balance for account tokenOwner
134     // ------------------------------------------------------------------------
135     function balanceOf(address tokenOwner) public constant returns (uint balance) {
136         return _balances[tokenOwner];
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Transfer the balance from token owner's account to to account
142     // - Owner's account must have sufficient balance to transfer
143     // - 0 value transfers are allowed
144     // ------------------------------------------------------------------------
145     function transfer(address to, uint tokens) public returns (bool success) {
146 	    require(to != 0x0);
147 	    require(_balances[msg.sender] >= tokens);
148         _balances[msg.sender] = safeSub(_balances[msg.sender], tokens);
149         _balances[to] = safeAdd(_balances[to], tokens);
150         Transfer(msg.sender, to, tokens);
151         return true;
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Token owner can approve for spender to transferFrom(...) tokens
157     // from the token owner's account
158     //
159     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
160     // recommends that there are no checks for the approval double-spend attack
161     // as this should be implemented in user interfaces 
162     // ------------------------------------------------------------------------
163     function approve(address spender, uint tokens) public returns (bool success) {
164         allowed[msg.sender][spender] = tokens;
165         Approval(msg.sender, spender, tokens);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Transfer tokens from the from account to the to account
172     // 
173     // The calling account must already have sufficient tokens approve(...)-d
174     // for spending from the from account and
175     // - From account must have sufficient balance to transfer
176     // - Spender must have sufficient allowance to transfer
177     // - 0 value transfers are allowed
178     // ------------------------------------------------------------------------
179     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
180 	    require(to != 0x0);
181 	    require(_balances[from] >= tokens);
182 	   
183         _balances[from] = safeSub(_balances[from], tokens);
184         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
185         _balances[to] = safeAdd(_balances[to], tokens);
186         Transfer(from, to, tokens);
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
207         Approval(msg.sender, spender, tokens);
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
220 	function transferMany(address[] dests, uint256[] values) public
221     onlyOwner
222     returns (uint256) {
223         uint256 i = 0;
224         while (i < dests.length) {
225 	        transfer(dests[i], values[i]);
226             i += 1;
227         }
228         return(i);
229     }
230 	
231 	 function burn(uint256 _value) public onlyOwner returns (bool success) {
232         require(_balances[msg.sender] >= _value);   // Check if the sender has enough
233         _balances[msg.sender] -= _value;            // Subtract from the sender
234         _totalSupply -= _value;                      // Updates totalSupply
235         Burn(msg.sender, _value);
236         return true;
237     }
238 }