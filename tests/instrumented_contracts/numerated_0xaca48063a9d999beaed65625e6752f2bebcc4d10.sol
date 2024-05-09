1 pragma solidity ^0.4.21;
2 // ----------------------------------------------------------------------------
3 // ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
5 // ----------------------------------------------------------------------------
6 contract ERC20Interface {
7     function totalSupply() public constant returns (uint);
8     function balanceOf(address tokenOwner) public constant returns (uint balance);
9     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
10     function transfer(address to, uint tokens) public returns (bool success);
11     function approve(address spender, uint tokens) public returns (bool success);
12     function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 contract Ownable {
19   address public owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   function Ownable() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     emit OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 }
48 
49 // ----------------------------------------------------------------------------
50 // Contract function to receive approval and execute function in one call
51 //
52 // Borrowed from MiniMeToken
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 // ----------------------------------------------------------------------------
59 // Safe maths
60 // ----------------------------------------------------------------------------
61 library SafeMath {
62     function add(uint a, uint b) internal pure returns (uint c) {
63         c = a + b;
64         require(c >= a);
65     }
66     function sub(uint a, uint b) internal pure returns (uint c) {
67         require(b <= a);
68         c = a - b;
69     }
70     function mul(uint a, uint b) internal pure returns (uint c) {
71         c = a * b;
72         require(a == 0 || c / a == b); // the same as: if (a !=0 && c / a != b) {throw;}
73     }
74     function div(uint a, uint b) internal pure returns (uint c) {
75         require(b > 0);
76         c = a / b;
77     }
78 }
79 
80 // ----------------------------------------------------------------------------
81 // ERC20 Token, with the addition of symbol, name and decimals and an
82 // initial fixed supply
83 // ----------------------------------------------------------------------------
84 contract IMOSToken is ERC20Interface, Ownable{
85     using SafeMath for uint;
86 
87     string public symbol;
88     string public  name;
89     uint8 public decimals;
90     uint _totalSupply;
91 
92     mapping(address => uint) balances;
93     mapping(address => mapping(address => uint)) allowed;
94 
95     // ------------------------------------------------------------------------
96     // Constructor
97     // ------------------------------------------------------------------------
98     function IMOSToken() public {
99         symbol = "IMOS";
100         name = "Intelligent Manufacturing Operation System";
101         decimals = 18;
102         _totalSupply = 500000000 * 10**uint(decimals);
103         balances[msg.sender] = _totalSupply;
104         emit Transfer(address(0), msg.sender, _totalSupply);
105     }
106     function reName(string _symbol, string _name) public onlyOwner {
107       symbol = _symbol;
108       name = _name;
109     }
110     // ------------------------------------------------------------------------
111     // Total supply
112     // ------------------------------------------------------------------------
113     function totalSupply() public constant returns (uint) {
114         return _totalSupply  - balances[address(0)];
115     }
116 
117     // ------------------------------------------------------------------------
118     // Get the token balance for account `tokenOwner`
119     // ------------------------------------------------------------------------
120     function balanceOf(address tokenOwner) public constant returns (uint balance) {
121         return balances[tokenOwner];
122     }
123 
124     // ------------------------------------------------------------------------
125     // Transfer the balance from token owner's account to `to` account
126     // - Owner's account must have sufficient balance to transfer
127     // - 0 value transfers are allowed
128     // ------------------------------------------------------------------------
129     function transfer(address to, uint tokens) public returns (bool success) {
130         balances[msg.sender] = balances[msg.sender].sub(tokens);
131         balances[to] = balances[to].add(tokens);
132         emit Transfer(msg.sender, to, tokens);
133         return true;
134     }
135 
136     // ------------------------------------------------------------------------
137     // Token owner can approve for `spender` to transferFrom(...) `tokens`
138     // from the token owner's account
139     //
140     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
141     // recommends that there are no checks for the approval double-spend attack
142     // as this should be implemented in user interfaces
143     // ------------------------------------------------------------------------
144     function approve(address spender, uint tokens) public returns (bool success) {
145         allowed[msg.sender][spender] = tokens;
146         emit Approval(msg.sender, spender, tokens);
147         return true;
148     }
149 
150     // ------------------------------------------------------------------------
151     // Transfer `tokens` from the `from` account to the `to` account
152     //
153     // The calling account must already have sufficient tokens approve(...)-d
154     // for spending from the `from` account and
155     // - From account must have sufficient balance to transfer
156     // - Spender must have sufficient allowance to transfer
157     // - 0 value transfers are allowed
158     // ------------------------------------------------------------------------
159     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
160         balances[from] = balances[from].sub(tokens);
161         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
162         balances[to] = balances[to].add(tokens);
163         emit Transfer(from, to, tokens);
164         return true;
165     }
166 
167     // ------------------------------------------------------------------------
168     // Returns the amount of tokens approved by the owner that can be
169     // transferred to the spender's account
170     // ------------------------------------------------------------------------
171     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
172         return allowed[tokenOwner][spender];
173     }
174 
175     // ------------------------------------------------------------------------
176     // Token owner can approve for `spender` to transferFrom(...) `tokens`
177     // from the token owner's account. The `spender` contract function
178     // `receiveApproval(...)` is then executed
179     // ------------------------------------------------------------------------
180     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
181         allowed[msg.sender][spender] = tokens;
182         emit Approval(msg.sender, spender, tokens);
183         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
184         return true;
185     }
186 
187     // ------------------------------------------------------------------------
188     // send ERC20 Token to multi address
189     // ------------------------------------------------------------------------
190     function multiTransfer(address[] _addresses, uint256[] amounts) public returns (bool success){
191         for (uint256 i = 0; i < _addresses.length; i++) {
192             transfer(_addresses[i], amounts[i]);
193         }
194         return true;
195     }
196 
197     // ------------------------------------------------------------------------
198     // send ERC20 Token to multi address with decimals
199     // ------------------------------------------------------------------------
200     function multiTransferDecimals(address[] _addresses, uint256[] amounts) public returns (bool success){
201         for (uint256 i = 0; i < _addresses.length; i++) {
202             transfer(_addresses[i], amounts[i] * 10**uint(decimals));
203         }
204         return true;
205     }
206     // ------------------------------------------------------------------------
207     // Don't accept ETH
208     // ------------------------------------------------------------------------
209     function () public payable {
210         revert();
211     }
212 }