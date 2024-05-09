1 pragma solidity ^0.4.23;
2 // ----------------------------------------------------------------------------
3 //   _   _   _   _   _   _   _   _   _   _   _   _   _  
4 //  / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ 
5 // ( G | A | M | E | I | N | V | E | S | T | - | I | O )
6 //  \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ 
7 //
8 // ----------------------------------------------------------------------------
9 contract SafeMath {
10     function safeAdd(uint a, uint b) public pure returns (uint c) {
11         c = a + b;
12         require(c >= a);
13     }
14     function safeSub(uint a, uint b) public pure returns (uint c) {
15         require(b <= a);
16         c = a - b;
17     }
18     function safeMul(uint a, uint b) public pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22     function safeDiv(uint a, uint b) public pure returns (uint c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 contract ERC20Interface {
28     function totalSupply() public constant returns (uint);
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 contract ApproveAndCallFallBack {
39     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
40 }
41 // ----------------------------------------------------------------------------
42 // Owned contract
43 // ----------------------------------------------------------------------------
44 contract Owned {
45     address public owner;
46     address public newOwner;
47 
48     event OwnershipTransferred(address indexed _from, address indexed _to);
49 
50     constructor() public {
51         owner = msg.sender;
52     }
53 
54     modifier onlyOwner {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     function transferOwnership(address _newOwner) public onlyOwner {
60         newOwner = _newOwner;
61     }
62     function acceptOwnership() public {
63         require(msg.sender == newOwner);
64         emit OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66         newOwner = address(0);
67     }
68 }
69 contract GameInvestToken is ERC20Interface, Owned, SafeMath {
70     string public symbol;
71     string public  name;
72     uint8 public decimals;
73     uint public _totalSupply;
74 
75     mapping(address => uint) balances;
76     mapping(address => mapping(address => uint)) allowed;
77 
78 
79     event TansactionEvent(address _from,address to, uint value);
80 
81     // ------------------------------------------------------------------------
82     // Constructor
83     // ------------------------------------------------------------------------
84     constructor() public {
85         symbol = "GAIN";
86         name = "GAMEINVEST.IO";
87         decimals = 18;
88         _totalSupply = (980000000) * (10 **18);
89         
90         owner = msg.sender;
91         
92         balances[owner] = _totalSupply;
93         emit Transfer(address(0), owner, _totalSupply);
94     }
95 
96 
97     // ------------------------------------------------------------------------
98     // Total supply
99     // ------------------------------------------------------------------------
100     function totalSupply() public constant returns (uint) {
101         return _totalSupply  - balances[address(0)];
102     }
103 
104 
105     // ------------------------------------------------------------------------
106     // Get the token balance for account tokenOwner
107     // ------------------------------------------------------------------------
108     function balanceOf(address tokenOwner) public constant returns (uint balance) {
109         return balances[tokenOwner];
110     }
111 
112 
113     // ------------------------------------------------------------------------
114     // Transfer the balance from token owner's account to to account
115     // - Owner's account must have sufficient balance to transfer
116     // - 0 value transfers are allowed
117     // ------------------------------------------------------------------------
118     function transfer(address to, uint tokens) public returns (bool success) {
119         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
120         balances[to] = safeAdd(balances[to], tokens);
121         emit TansactionEvent(msg.sender,to,tokens);
122         emit Transfer(msg.sender, to, tokens);
123         return true;
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Token owner can approve for spender to transferFrom(...) tokens
129     // from the token owner's account
130     //
131     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
132     // recommends that there are no checks for the approval double-spend attack
133     // as this should be implemented in user interfaces
134     // ------------------------------------------------------------------------
135     function approve(address spender, uint tokens) public returns (bool success) {
136         allowed[msg.sender][spender] = tokens;
137         emit Approval(msg.sender, spender, tokens);
138         return true;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Transfer tokens from the from account to the to account
144     //
145     // The calling account must already have sufficient tokens approve(...)-d
146     // for spending from the from account and
147     // - From account must have sufficient balance to transfer
148     // - Spender must have sufficient allowance to transfer
149     // - 0 value transfers are allowed
150     // ------------------------------------------------------------------------
151     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
152         balances[from] = safeSub(balances[from], tokens);
153         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
154         balances[to] = safeAdd(balances[to], tokens);
155         emit TansactionEvent(msg.sender,to,tokens);
156         emit Transfer(from, to, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Returns the amount of tokens approved by the owner that can be
163     // transferred to the spender's account
164     // ------------------------------------------------------------------------
165     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
166         return allowed[tokenOwner][spender];
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Token owner can approve for spender to transferFrom(...) tokens
172     // from the token owner's account. The spender contract function
173     // receiveApproval(...) is then executed
174     // ------------------------------------------------------------------------
175     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
176         allowed[msg.sender][spender] = tokens;
177         emit Approval(msg.sender, spender, tokens);
178         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Don't accept ETH
185     // ------------------------------------------------------------------------
186     function () public payable {
187         revert();
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Owner can transfer out any accidentally sent ERC20 tokens
193     // ------------------------------------------------------------------------
194     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
195         return ERC20Interface(tokenAddress).transfer(owner, tokens);
196     }
197     
198 
199 }