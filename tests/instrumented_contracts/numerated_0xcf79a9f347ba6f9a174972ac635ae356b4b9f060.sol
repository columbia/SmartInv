1 pragma solidity ^0.5.17;
2 /**
3  * @title SafeMaths
4  * @dev Math operations with safety checks that throw on error
5  */
6  
7 
8 //*******************************************************************//
9 //------------------------ SafeMath Library -------------------------//
10 //*******************************************************************//
11 
12 library SafeMath {
13     function add(uint a, uint b) internal pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function sub(uint a, uint b) internal pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function mul(uint a, uint b) internal pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function div(uint a, uint b) internal pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 
32 // ----------------------------------------------------------------------------
33 // ERC Token Standard #20 Interface
34 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
35 // ----------------------------------------------------------------------------
36 contract ERC20Interface {
37     function totalSupply() public view returns (uint);
38     function balanceOf(address tokenOwner) public view returns (uint balance);
39     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
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
55     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
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
68     constructor() public {
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
82         emit OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84         newOwner = address(0);
85     }
86 }
87 
88 
89 // ----------------------------------------------------------------------------
90 //supply
91 // ERC20 Token, with the addition of symbol, name and decimals
92 // ----------------------------------------------------------------------------
93 contract Block385 is ERC20Interface, Owned {
94     using SafeMath for uint;
95 
96     string public symbol;
97     string public  name;
98     uint8 public decimals;
99     uint _totalSupply;
100 
101     mapping(address => uint) balances;
102     mapping(address => mapping(address => uint)) allowed;
103 
104 
105     /**_________________________________________________________________
106   _      _                                        ______           
107   |  |  /          /                                /              
108 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
109   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
110 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
111                              
112  ----------------------------------------------------------------------------
113                   
114 */
115     // Constructor
116     // ------------------------------------------------------------------------
117     constructor() public {
118         symbol = "B3B";
119         name = "Block385";
120         decimals = 18;
121         _totalSupply = 3850000 * 10**uint(decimals);
122         balances[owner] = _totalSupply;
123         emit Transfer(address(0), owner, _totalSupply);
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Total supply
129     // ------------------------------------------------------------------------
130     function totalSupply() public view returns (uint) {
131         return _totalSupply.sub(balances[address(0)]);
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Get the token balance for account `tokenOwner`
137     // ------------------------------------------------------------------------
138     function balanceOf(address tokenOwner) public view returns (uint balance) {
139         return balances[tokenOwner];
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Transfer the balance from token owner's account to `to` account
145     // - Owner's account must have sufficient balance to transfer
146     // - 0 value transfers are allowed
147     // ------------------------------------------------------------------------
148     function transfer(address to, uint tokens) public returns (bool success) {
149         balances[msg.sender] = balances[msg.sender].sub(tokens);
150         balances[to] = balances[to].add(tokens);
151         emit Transfer(msg.sender, to, tokens);
152         return true;
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Token owner can approve for `spender` to transferFrom(...) `tokens`
158     // from the token owner's account
159     //
160     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
161     // recommends that there are no checks for the approval double-spend attack
162     // as this should be implemented in user interfaces
163     // ------------------------------------------------------------------------
164     function approve(address spender, uint tokens) public returns (bool success) {
165         allowed[msg.sender][spender] = tokens;
166         emit Approval(msg.sender, spender, tokens);
167         return true;
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Transfer `tokens` from the `from` account to the `to` account
173     //
174     // The calling account must already have sufficient tokens approve(...)-d
175     // for spending from the `from` account and
176     // - From account must have sufficient balance to transfer
177     // - Spender must have sufficient allowance to transfer
178     // - 0 value transfers are allowed
179     // ------------------------------------------------------------------------
180     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
181         balances[from] = balances[from].sub(tokens);
182         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
183         balances[to] = balances[to].add(tokens);
184         emit Transfer(from, to, tokens);
185         return true;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Returns the amount of tokens approved by the owner that can be
191     // transferred to the spender's account
192     // ------------------------------------------------------------------------
193     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
194         return allowed[tokenOwner][spender];
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Token owner can approve for `spender` to transferFrom(...) `tokens`
200     // from the token owner's account. The `spender` contract function
201     // `receiveApproval(...)` is then executed
202     // ------------------------------------------------------------------------
203     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
204         allowed[msg.sender][spender] = tokens;
205         emit Approval(msg.sender, spender, tokens);
206         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
207         return true;
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Don't accept ETH
213     // ------------------------------------------------------------------------
214     function () external payable {
215         revert();
216     }
217 
218 
219     // ------------------------------------------------------------------------
220     // Owner can transfer out any accidentally sent ERC20 tokens
221     // ------------------------------------------------------------------------
222     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
223         return ERC20Interface(tokenAddress).transfer(owner, tokens);
224     }
225 }