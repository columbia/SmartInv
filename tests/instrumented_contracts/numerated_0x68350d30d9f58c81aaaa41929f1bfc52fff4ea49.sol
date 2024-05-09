1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal constant returns (uint256) {
8       uint256 c = a * b;
9       assert(a == 0 || c / a == b);
10       return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal constant returns (uint256) {
14       // assert(b > 0); // Solidity automatically throws when dividing by 0
15       uint256 c = a / b;
16       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17       return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal constant returns (uint256) {
21       assert(b <= a);
22       return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal constant returns (uint256) {
26       uint256 c = a + b;
27       assert(c >= a);
28       return c;
29   }
30 
31 }
32 
33 // ----------------------------------------------------------------------------
34 // ERC Token Standard #20 Interface
35 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
36 // ----------------------------------------------------------------------------
37 contract ERC20Interface {
38     function totalSupply() constant returns (uint);
39     function balanceOf(address tokenOwner) constant returns (uint balance);
40     function allowance(address tokenOwner, address spender) constant returns (uint remaining);
41     function transfer(address to, uint tokens) returns (bool success);
42     function approve(address spender, uint tokens) returns (bool success);
43     function transferFrom(address from, address to, uint tokens) returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 contract ApproveAndCallFallBack {
50     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
51 }
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // To change contract ownaship if needed
56 // ----------------------------------------------------------------------------
57 contract Owned {
58     address public owner;
59     address public newOwner;
60 
61     event OwnershipTransferred(address indexed _from, address indexed _to);
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
72     function transferOwnership(address _newOwner) public onlyOwner {
73         newOwner = _newOwner;
74     }
75     function acceptOwnership() public {
76         require(msg.sender == newOwner);
77         OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79         newOwner = address(0);
80 
81     }
82 }
83 
84 
85 // ----------------------------------------------------------------------------
86 // ERC20 Token, with the addition of symbol, name and decimals and assisted
87 // token transfers
88 // ----------------------------------------------------------------------------
89 contract CrowdSale is ERC20Interface, Owned, SafeMath {
90     //address where tokens will be stored;also the address where ether sent into contract is stored
91     address public tokenAddress;
92     //symbol of token; only 8 characters(8bytes)
93     bytes8 public symbol;
94     //name of token; only 16 characters(16bytes)
95     bytes16 public  name;
96     //numbers of decimals for the tokens
97     uint256 public decimals;
98     //total token supplies
99     uint256 public _totalSupply;
100 
101     //mapping of each address tokens
102     mapping(address => uint) tokenBalances;
103 
104     mapping(address => mapping(address => uint)) internal allowed;
105 
106         /*****
107         * @dev Modifier to check that amount transferred is not 0
108         */
109     modifier nonZero() {
110         require(msg.value != 0);
111         _;
112     }
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     function CrowdSale(
117             address _tokenAddress
118             ) public {
119                 //*****************************Edit here*****************************
120                 symbol = "RPZX";
121                 name = "Rapidz";
122                 decimals = 18;
123                 _totalSupply = 5000000000000000000000000000;
124                 //*********************************************************************
125                 tokenAddress=_tokenAddress;
126                 tokenBalances[tokenAddress] = _totalSupply;//map token address to mapping
127                 Transfer(address(0), tokenAddress,_totalSupply);//initial creation of tokens and send to tokenAddress
128     }
129 
130     // ------------------------------------------------------------------------
131     // Total supply
132     // ------------------------------------------------------------------------
133     function totalSupply() constant returns (uint) {
134         return _totalSupply;
135     }
136 
137     // ------------------------------------------------------------------------
138     // Get the token balance for account tokenOwner
139     // ------------------------------------------------------------------------
140     function balanceOf(address tokenOwner) constant returns (uint balance) {
141         return tokenBalances[tokenOwner];
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Transfer the balance from token owner's account to to account
147     // - Owner's account must have sufficient balance to transfer
148     // - 0 value transfers are allowed
149     // ------------------------------------------------------------------------
150     function transfer(address to, uint tokens) returns (bool success) {
151 
152         tokenBalances[msg.sender] = safeSub(tokenBalances[msg.sender], tokens);
153         tokenBalances[to] = safeAdd(tokenBalances[to], tokens);
154         Transfer(msg.sender, to, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Token owner can approve for spender to transferFrom(...) tokens
161     // from the token owner's account
162     //
163     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
164     // recommends that there are no checks for the approval double-spend attack
165     // as this should be implemented in user interfaces
166     // ------------------------------------------------------------------------
167     function approve(address spender, uint tokens) returns (bool success) {
168         allowed[msg.sender][spender] = tokens;
169         Approval(msg.sender, spender, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Transfer tokens from the from account to the to account
176     //
177     // The calling account must already have sufficient tokens approve(...)-d
178     // for spending from the from account and
179     // - From account must have sufficient balance to transfer
180     // - Spender must have sufficient allowance to transfer
181     // - 0 value transfers are allowed
182     // ------------------------------------------------------------------------
183     function transferFrom(address from, address to, uint tokens) returns (bool success) {
184         tokenBalances[from] = safeSub(tokenBalances[from], tokens);
185         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
186         tokenBalances[to] = safeAdd(tokenBalances[to], tokens);
187         Transfer(from, to, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Returns the amount of tokens approved by the owner that can be
194     // transferred to the spender's account
195     // ------------------------------------------------------------------------
196     function allowance(address tokenOwner, address spender) constant returns (uint remaining) {
197         return allowed[tokenOwner][spender];
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Token owner can approve for spender to transferFrom(...) tokens
203     // from the token owner's account. The spender contract function
204     // receiveApproval(...) is then executed
205     // ------------------------------------------------------------------------
206     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
207         allowed[msg.sender][spender] = tokens;
208         Approval(msg.sender, spender, tokens);
209         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
210         return true;
211     }
212 
213 
214     /*****
215         * @dev Fallback Function to buy the tokens
216         */ //default function when ether is Received
217     function () nonZero payable {
218         revert();
219     }//end function()
220 
221 
222 }