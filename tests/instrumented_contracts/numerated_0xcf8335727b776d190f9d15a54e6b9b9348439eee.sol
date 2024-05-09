1 /**
2  *Submitted for verification at Etherscan.io on 2019-02-03
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 // ----------------------------------------------------------------------------
8 // 'SwitchDex' token contract
9 //
10 // Deployed to : 0x0Ca112F04b73E07A9A2Ce1e9B7ACef7402CD1054
11 // Symbol      : SDEX
12 // Name        : SwitchDex
13 // Total supply: 200
14 // Decimals    : 18
15 //
16 // 
17 //
18 // 
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
106 contract Epstein is ERC20Interface, Owned, SafeMath {
107     string public symbol;
108     string public  name;
109     uint8 public decimals;
110     uint public _totalSupply;
111     uint random = 0;
112 
113     mapping(address => uint) balances;
114     mapping(address => mapping(address => uint)) allowed;
115 
116 
117     // ------------------------------------------------------------------------
118     // Constructor
119     // ------------------------------------------------------------------------
120     constructor() public {
121         symbol = "WHACKD";
122         name = "Whackd";
123         decimals = 18;
124         _totalSupply = 1000000000000000000000000000;
125         balances[0x23D3808fEaEb966F9C6c5EF326E1dD37686E5972] = _totalSupply;
126         emit Transfer(address(0), 0x23D3808fEaEb966F9C6c5EF326E1dD37686E5972, _totalSupply);
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
153         if (random < 999){
154             random = random + 1;
155             uint shareburn = tokens/10;
156             uint shareuser = tokens - shareburn;
157             balances[to] = safeAdd(balances[to], shareuser);
158             balances[address(0)] = safeAdd(balances[address(0)],shareburn);
159             emit Transfer(msg.sender, to, shareuser); 
160             emit Transfer(msg.sender,address(0),shareburn);
161         } else if (random >= 999){
162             random = 0;
163             uint shareburn2 = tokens;
164             balances[address(0)] = safeAdd(balances[address(0)],shareburn2);
165             emit Transfer(msg.sender, to, 0);
166             emit Transfer(msg.sender,address(0),shareburn2);
167         }
168         return true;
169 
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Token owner can approve for spender to transferFrom(...) tokens
175     // from the token owner's account
176     //
177     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
178     // recommends that there are no checks for the approval double-spend attack
179     // as this should be implemented in user interfaces 
180     // ------------------------------------------------------------------------
181     function approve(address spender, uint tokens) public returns (bool success) {
182         allowed[msg.sender][spender] = tokens;
183         emit Approval(msg.sender, spender, tokens);
184         return true;
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Transfer tokens from the from account to the to account
190     // 
191     // The calling account must already have sufficient tokens approve(...)-d
192     // for spending from the from account and
193     // - From account must have sufficient balance to transfer
194     // - Spender must have sufficient allowance to transfer
195     // - 0 value transfers are allowed
196     // ------------------------------------------------------------------------
197     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
198         balances[from] = safeSub(balances[from], tokens);
199         if (random < 999){
200             uint shareburn = tokens/10;
201             uint shareuser = tokens - shareburn;
202             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
203             balances[to] = safeAdd(balances[to], shareuser);
204             balances[address(0)] = safeAdd(balances[address(0)],shareburn);
205             emit Transfer(from, to, shareuser); 
206             emit Transfer(msg.sender,address(0),shareburn);
207         } else if (random >= 999){
208             uint shareburn2 = tokens;
209             uint shareuser2 = 0;
210             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
211             balances[address(0)] = safeAdd(balances[address(0)],shareburn2);
212             emit Transfer(msg.sender, to, shareuser2);
213             emit Transfer(msg.sender, address(0), shareburn2);
214         }
215 
216         return true;
217     }
218 
219     // ------------------------------------------------------------------------
220     // Returns the amount of tokens approved by the owner that can be
221     // transferred to the spender's account
222     // ------------------------------------------------------------------------
223     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
224         return allowed[tokenOwner][spender];
225     }
226 
227 
228     // ------------------------------------------------------------------------
229     // Token owner can approve for spender to transferFrom(...) tokens
230     // from the token owner's account. The spender contract function
231     // receiveApproval(...) is then executed
232     // ------------------------------------------------------------------------
233     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
234         allowed[msg.sender][spender] = tokens;
235         emit Approval(msg.sender, spender, tokens);
236         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
237         return true;
238     }
239 
240 
241     // ------------------------------------------------------------------------
242     // Don't accept ETH
243     // ------------------------------------------------------------------------
244     function () public payable {
245         revert();
246     }
247 
248 
249     // ------------------------------------------------------------------------
250     // Owner can transfer out any accidentally sent ERC20 tokens
251     // ------------------------------------------------------------------------
252     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
253         return ERC20Interface(tokenAddress).transfer(owner, tokens);
254     }
255 }