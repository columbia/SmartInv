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
51 // ----------------------------------------------------------------------------
52 contract ApproveAndCallFallBack {
53     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
54 }
55 
56 // ----------------------------------------------------------------------------
57 // Safe maths
58 // ----------------------------------------------------------------------------
59 library SafeMath {
60     function add(uint a, uint b) internal pure returns (uint c) {
61         c = a + b;
62         require(c >= a);
63     }
64     function sub(uint a, uint b) internal pure returns (uint c) {
65         require(b <= a);
66         c = a - b;
67     }
68     function mul(uint a, uint b) internal pure returns (uint c) {
69         c = a * b;
70         require(a == 0 || c / a == b); // the same as: if (a !=0 && c / a != b) {throw;}
71     }
72     function div(uint a, uint b) internal pure returns (uint c) {
73         require(b > 0);
74         c = a / b;
75     }
76 }
77 
78 // ----------------------------------------------------------------------------
79 // ERC20 Token, with the addition of symbol, name and decimals and an
80 // initial fixed supply
81 // ----------------------------------------------------------------------------
82 contract MIMTToken is ERC20Interface, Ownable{
83     using SafeMath for uint;
84 
85     string public symbol;
86     string public name;
87     uint8  public decimals;
88     uint _totalSupply;
89     
90     string public version = "V1.00";  	//版本
91 
92     mapping(address => uint) balances;
93     mapping(address => mapping(address => uint)) allowed;
94 
95     // ------------------------------------------------------------------------
96     // Constructor
97     // ------------------------------------------------------------------------
98     function MIMTToken() public {
99         symbol = "MIMT";
100         name = "My Intelligent Manufacturing Token";
101         decimals = 18;
102         _totalSupply = 1000000000 * 10 ** uint(decimals);	//10亿枚
103         
104         balances[msg.sender] = _totalSupply;
105         emit Transfer(address(0), msg.sender, _totalSupply);
106     }
107     function reName(string _symbol, string _name) public onlyOwner {
108       symbol = _symbol;
109       name = _name;
110     }
111     // ------------------------------------------------------------------------
112     // Total supply
113     // ------------------------------------------------------------------------
114     function totalSupply() public constant returns (uint) {
115         return _totalSupply  - balances[address(0)];
116     }
117 
118     // ------------------------------------------------------------------------
119     // Get the token balance for account `tokenOwner`
120     // ------------------------------------------------------------------------
121     function balanceOf(address tokenOwner) public constant returns (uint balance) {
122         return balances[tokenOwner];
123     }
124 
125     // ------------------------------------------------------------------------
126     // Transfer the balance from token owner's account to `to` account
127     // - Owner's account must have sufficient balance to transfer
128     // - 0 value transfers are allowed
129     // ------------------------------------------------------------------------
130     function transfer(address to, uint tokens) public returns (bool success) {
131         balances[msg.sender] = balances[msg.sender].sub(tokens);
132         balances[to] = balances[to].add(tokens);
133         emit Transfer(msg.sender, to, tokens);
134         return true;
135     }
136 
137     // ------------------------------------------------------------------------
138     // Token owner can approve for `spender` to transferFrom(...) `tokens`
139     // from the token owner's account
140     //
141     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
142     // recommends that there are no checks for the approval double-spend attack
143     // as this should be implemented in user interfaces
144     // ------------------------------------------------------------------------
145     function approve(address spender, uint tokens) public returns (bool success) {
146         allowed[msg.sender][spender] = tokens;
147         emit Approval(msg.sender, spender, tokens);
148         return true;
149     }
150 
151     // ------------------------------------------------------------------------
152     // Transfer `tokens` from the `from` account to the `to` account
153     //
154     // The calling account must already have sufficient tokens approve(...)-d
155     // for spending from the `from` account and
156     // - From account must have sufficient balance to transfer
157     // - Spender must have sufficient allowance to transfer
158     // - 0 value transfers are allowed
159     // ------------------------------------------------------------------------
160     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
161         balances[from] = balances[from].sub(tokens);
162         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
163         balances[to] = balances[to].add(tokens);
164         emit Transfer(from, to, tokens);
165         return true;
166     }
167 
168     // ------------------------------------------------------------------------
169     // Returns the amount of tokens approved by the owner that can be
170     // transferred to the spender's account
171     // ------------------------------------------------------------------------
172     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
173         return allowed[tokenOwner][spender];
174     }
175 
176     // ------------------------------------------------------------------------
177     // Token owner can approve for `spender` to transferFrom(...) `tokens`
178     // from the token owner's account. The `spender` contract function
179     // `receiveApproval(...)` is then executed
180     // ------------------------------------------------------------------------
181     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
182         allowed[msg.sender][spender] = tokens;
183         emit Approval(msg.sender, spender, tokens);
184         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
185         return true;
186     }
187 
188     // ------------------------------------------------------------------------
189     // send ERC20 Token to multi address
190     // ------------------------------------------------------------------------
191     function multiTransfer(address[] _addresses, uint256[] amounts) public returns (bool success){
192         for (uint256 i = 0; i < _addresses.length; i++) {
193             transfer(_addresses[i], amounts[i]);
194         }
195         return true;
196     }
197 
198     // ------------------------------------------------------------------------
199     // send ERC20 Token to multi address with decimals
200     // ------------------------------------------------------------------------
201     function multiTransferDecimals(address[] _addresses, uint256[] amounts) public returns (bool success){
202         for (uint256 i = 0; i < _addresses.length; i++) {
203             transfer(_addresses[i], amounts[i] * 10 ** uint(decimals));
204         }
205         return true;
206     }
207     // ------------------------------------------------------------------------
208     // Don't accept ETH
209     // ------------------------------------------------------------------------
210     function () public payable {
211         revert();
212     }
213 }