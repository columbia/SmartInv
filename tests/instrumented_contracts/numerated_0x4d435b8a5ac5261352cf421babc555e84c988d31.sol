1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'FRIENDZONE' token contract
5 //
6 // Deployed to : 0xeD62002Bb7697C12D1F7fB6c7D98DD2FD995b618
7 // Symbol      : FRDZ
8 // Name        : FRIENDZONE 
9 // Total supply: 500,000,000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by FRIENDZONE Project. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 // Safe maths
22 library SafeMath {
23     function add(uint a, uint b) internal pure returns (uint c) {
24         c = a + b; require(c >= a); }
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a); c = a - b;  }
27     function mul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b; require(a == 0 || c / a == b); }
29     function div(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0); c = a / b; }
31 }
32 
33 
34 // ----------------------------------------------------------------------------
35 // ERC Token Standard #20 Interface
36 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
37 // ----------------------------------------------------------------------------
38 contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Contract function to receive approval and execute function in one call
53 //
54 // Borrowed from MiniMeToken
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
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
70     constructor() public {
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
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // ERC20 Token, with the addition of symbol, name and decimals and assisted
93 // token transfers
94 // ----------------------------------------------------------------------------
95 contract FRDZ is ERC20Interface, Owned {
96     using SafeMath for uint;
97 
98     string public symbol;
99     string public  name;
100     uint8 public decimals;
101     uint public _totalSupply;
102 
103     mapping(address => uint) balances;
104     mapping(address => mapping(address => uint)) allowed;
105 
106     // ------------------------------------------------------------------------
107     // Constructor
108     // ------------------------------------------------------------------------
109     constructor() public {
110         symbol = "FRDZ";
111         name = "FRIENDZONE";
112         decimals = 18;
113         _totalSupply = 500000000000000000000000000;
114         //500M start
115         balances[0xeD62002Bb7697C12D1F7fB6c7D98DD2FD995b618] = _totalSupply;
116         emit Transfer(address(0), 0xeD62002Bb7697C12D1F7fB6c7D98DD2FD995b618, _totalSupply);
117     }
118 
119 
120     // ------------------------------------------------------------------------
121     // Total supply
122     // ------------------------------------------------------------------------
123     function totalSupply() public constant returns (uint) {
124         return _totalSupply  - balances[address(0)];
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Get the token balance for account tokenOwner
130     // ------------------------------------------------------------------------
131     function balanceOf(address tokenOwner) public constant returns (uint balance) {
132         return balances[tokenOwner];
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Transfer the balance from token owner's account to to account
138     // - Owner's account must have sufficient balance to transfer
139     // - 0 value transfers are allowed
140     // ------------------------------------------------------------------------
141    function transfer(address to, uint tokens) public returns (bool success) {
142         balances[msg.sender] = balances[msg.sender].sub(tokens);
143         balances[to] = balances[to].add(tokens);
144         emit Transfer(msg.sender, to, tokens);
145         return true;
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Token owner can approve for spender to transferFrom(...) tokens
151     // from the token owner's account
152     //
153     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
154     // recommends that there are no checks for the approval double-spend attack
155     // as this should be implemented in user interfaces 
156     // ------------------------------------------------------------------------
157     function approve(address spender, uint tokens) public returns (bool success) {
158         allowed[msg.sender][spender] = tokens;
159         emit Approval(msg.sender, spender, tokens);
160         return true;
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Transfer tokens from the from account to the to account
166     // 
167     // The calling account must already have sufficient tokens approve(...)-d
168     // for spending from the from account and
169     // - From account must have sufficient balance to transfer
170     // - Spender must have sufficient allowance to transfer
171     // - 0 value transfers are allowed
172     // ------------------------------------------------------------------------
173     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
174         balances[from] = balances[from].sub(tokens);
175         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
176         balances[to] = balances[to].add(tokens);
177         emit Transfer(from, to, tokens);
178         return true;
179     }
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
197         emit Approval(msg.sender, spender, tokens);
198         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
199         return true;
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Don't accept ETH
205     // ------------------------------------------------------------------------
206     function () public payable {
207         revert();
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Owner can transfer out any accidentally sent ERC20 tokens
213     // ------------------------------------------------------------------------
214     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
215         return ERC20Interface(tokenAddress).transfer(owner, tokens);
216     }
217 }