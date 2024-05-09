1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths.
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         assert(c >= a);
10     }
11 
12     function sub(uint a, uint b) internal pure returns (uint c) {
13         assert(b <= a);
14         c = a - b;
15     }
16 
17     function mul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         assert(a == 0 || c / a == b);
20     }
21 
22     function div(uint a, uint b) internal pure returns (uint c) {
23         assert(b > 0);
24         c = a / b;
25     }
26 }
27 
28 
29 // ----------------------------------------------------------------------------
30 // ERC Token Standard #20 Interface
31 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
32 // ----------------------------------------------------------------------------
33 contract ERC20Interface {
34     function totalSupply() public constant returns (uint);
35 
36     function balanceOf(address tokenOwner) public constant returns (uint balance);
37     
38     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
39     
40     function transfer(address to, uint tokens) public returns (bool success);
41     
42     function approve(address spender, uint tokens) public returns (bool success);
43     
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // 
53 // Contract function to receive approval and execute function in one call
54 // 
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     address public newOwner;
67 
68     event OwnershipTransferred(address indexed _from, address indexed _to);
69 
70     function Owned() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address _newOwner) public onlyOwner {
80         newOwner = _newOwner;
81     }
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84         OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // ERC20 Token, with the addition of symbol, name, and decimals and assisted
93 // token transfers
94 // ----------------------------------------------------------------------------
95 contract INZURA is ERC20Interface, Owned {
96     using SafeMath for uint;
97 
98     string public symbol;
99     string public  name;
100     uint8 public decimals;
101     uint public _totalSupply;
102 
103     mapping(address => uint) public balances;
104     mapping(address => mapping(address => uint)) public allowed;
105 
106 
107     // ------------------------------------------------------------------------
108     // Constructor
109     // ------------------------------------------------------------------------
110     function INZURA() public {
111         symbol = "IZA";
112         name = "INZURA";
113         decimals = 18;
114         _totalSupply = 120000000e18;
115         balances[owner] = _totalSupply;
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Total supply
121     // ------------------------------------------------------------------------
122     function totalSupply() public constant returns (uint) {
123         return _totalSupply - balances[address(0)];
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Get the token balance for account tokenOwner
129     // ------------------------------------------------------------------------
130     function balanceOf(address tokenOwner) public constant returns (uint balance) {
131         return balances[tokenOwner];
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Transfer the balance from token owner's account to "to account"
137     // - Owner's account must have sufficient balance to transfer
138     // - 0 value transfers are allowed
139     // ------------------------------------------------------------------------
140     function transfer(address to, uint tokens) public returns (bool success) {
141         balances[msg.sender] = balances[msg.sender].sub(tokens);
142         balances[to] = balances[to].add(tokens);
143         Transfer(msg.sender, to, tokens);
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Token owner can approve for spender to transferFrom(...) tokens
150     // from the token owner's account
151     //
152     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
153     // recommends that there are no checks for the approval double-spend attack
154     // as this should be implemented in user interfaces 
155     // ------------------------------------------------------------------------
156     function approve(address spender, uint tokens) public returns (bool success) {
157         allowed[msg.sender][spender] = tokens;
158         Approval(msg.sender, spender, tokens);
159         return true;
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Transfer tokens from the from account to the to account
165     // 
166     // The calling account must already have sufficient tokens approve(...)-d
167     // for spending from the from account and
168     // - From account must have sufficient balance to transfer
169     // - Spender must have sufficient allowance to transfer
170     // - 0 value transfers are allowed
171     // ------------------------------------------------------------------------
172     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
173         balances[from] = balances[from].sub(tokens);
174         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
175         balances[to] = balances[to].add(tokens);
176         Transfer(from, to, tokens);
177         return true;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Returns the amount of tokens approved by the owner that can be
183     // transferred to the spender's account
184     // ------------------------------------------------------------------------
185     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
186         return allowed[tokenOwner][spender];
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Token owner can approve for spender to transferFrom(...) tokens
192     // from the token owner's account. The spender contract function
193     // receiveApproval(...) is then executed
194     // ------------------------------------------------------------------------
195     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
196         allowed[msg.sender][spender] = tokens;
197         Approval(msg.sender, spender, tokens);
198         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
199         return true;
200     }
201 
202     // ------------------------------------------------------------------------
203     // Owner can transfer out any accidentally sent ERC20 tokens
204     // ------------------------------------------------------------------------
205     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
206         return ERC20Interface(tokenAddress).transfer(owner, tokens);
207     }
208 }