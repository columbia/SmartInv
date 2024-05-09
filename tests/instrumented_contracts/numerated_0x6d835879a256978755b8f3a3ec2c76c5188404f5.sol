1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Owned.sol
4 
5 // ----------------------------------------------------------------------------
6 // Ownership functionality for authorization controls and user permissions
7 // ----------------------------------------------------------------------------
8 contract Owned {
9     address public owner;
10     address public newOwner;
11 
12     event OwnershipTransferred(address indexed _from, address indexed _to);
13 
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function transferOwnership(address _newOwner) public onlyOwner {
24         newOwner = _newOwner;
25     }
26     function acceptOwnership() public {
27         require(msg.sender == newOwner);
28         emit OwnershipTransferred(owner, newOwner);
29         owner = newOwner;
30         newOwner = address(0);
31     }
32 }
33 
34 // File: contracts/SafeMath.sol
35 
36 // ----------------------------------------------------------------------------
37 // Safe maths
38 // ----------------------------------------------------------------------------
39 contract SafeMath {
40     function safeAdd(uint a, uint b) public pure returns (uint c) {
41         c = a + b;
42         require(c >= a);
43     }
44     function safeSub(uint a, uint b) public pure returns (uint c) {
45         require(b <= a);
46         c = a - b;
47     }
48     function safeMul(uint a, uint b) public pure returns (uint c) {
49         c = a * b;
50         require(a == 0 || c / a == b);
51     }
52     function safeDiv(uint a, uint b) public pure returns (uint c) {
53         require(b > 0);
54         c = a / b;
55     }
56 }
57 
58 // File: contracts/ERC20.sol
59 
60 // ----------------------------------------------------------------------------
61 // ERC20 Standard Interface
62 // ----------------------------------------------------------------------------
63 contract ERC20 {
64     function totalSupply() public constant returns (uint);
65     function balanceOf(address tokenOwner) public constant returns (uint balance);
66     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
67     function transfer(address to, uint tokens) public returns (bool success);
68     function approve(address spender, uint tokens) public returns (bool success);
69     function transferFrom(address from, address to, uint tokens) public returns (bool success);
70 
71     event Transfer(address indexed from, address indexed to, uint tokens);
72     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
73 }
74 
75 // File: contracts/UncToken.sol
76 
77 // ----------------------------------------------------------------------------
78 // 'UNC' 'Uncloak' token contract
79 // Symbol      : UNC
80 // Name        : Uncloak
81 // Total supply: 4,200,000,000
82 // Decimals    : 18
83 // ----------------------------------------------------------------------------
84 
85 
86 // ----------------------------------------------------------------------------
87 // ERC20 Token, with the addition of symbol, name and decimals
88 // Receives ETH and generates tokens
89 // ----------------------------------------------------------------------------
90 contract UncToken is SafeMath, Owned, ERC20 {
91     string public symbol;
92     string public  name;
93     uint8 public decimals;
94     uint public _totalSupply;
95 
96     // Track whether the coin can be transfered
97     bool private transferEnabled = false;
98 
99     // track addresses that can transfer regardless of whether transfers are enables
100     mapping(address => bool) public transferAdmins;
101 
102     mapping(address => uint) public balances;
103     mapping(address => mapping(address => uint)) internal allowed;
104 
105     event Burned(address indexed burner, uint256 value);
106 
107     // Check if transfer is valid
108     modifier canTransfer(address _sender) {
109         require(transferEnabled || transferAdmins[_sender]);
110         _;
111     }
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     constructor() public {
117         symbol = "UNC";
118         name = "Uncloak";
119         decimals = 18;
120         _totalSupply = 4200000000 * 10**uint(decimals);
121         transferAdmins[owner] = true; // Enable transfers for owner
122         balances[owner] = _totalSupply;
123         emit Transfer(address(0), owner, _totalSupply);
124     }
125 
126     // ------------------------------------------------------------------------
127     // Total supply
128     // ------------------------------------------------------------------------
129     function totalSupply() public constant returns (uint) {
130         return _totalSupply;
131     }
132 
133     // ------------------------------------------------------------------------
134     // Get the token balance for account `tokenOwner`
135     // ------------------------------------------------------------------------
136     function balanceOf(address tokenOwner) public constant returns (uint balance) {
137         return balances[tokenOwner];
138     }
139 
140     // ------------------------------------------------------------------------
141     // Transfer the balance from token owner's account to `to` account
142     // - Owner's account must have sufficient balance to transfer
143     // - 0 value transfers are allowed
144     // ------------------------------------------------------------------------
145     function transfer(address to, uint tokens) canTransfer (msg.sender) public returns (bool success) {
146         require(to != address(this)); //make sure we're not transfering to this contract
147 
148         //check edge cases
149         if (balances[msg.sender] >= tokens
150             && tokens > 0) {
151 
152                 //update balances
153                 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
154                 balances[to] = safeAdd(balances[to], tokens);
155 
156                 //log event
157                 emit Transfer(msg.sender, to, tokens);
158                 return true;
159         }
160         else {
161             return false;
162         }
163     }
164 
165     // ------------------------------------------------------------------------
166     // Token owner can approve for `spender` to transferFrom(...) `tokens`
167     // from the token owner's account
168     // ------------------------------------------------------------------------
169     function approve(address spender, uint tokens) public returns (bool success) {
170         // Ownly allow changes to or from 0. Mitigates vulnerabiilty of race description
171         // described here: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172         require((tokens == 0) || (allowed[msg.sender][spender] == 0));
173 
174         allowed[msg.sender][spender] = tokens;
175         emit Approval(msg.sender, spender, tokens);
176         return true;
177     }
178 
179     // ------------------------------------------------------------------------
180     // Transfer `tokens` from the `from` account to the `to` account
181     //
182     // The calling account must already have sufficient tokens approve(...)-d
183     // for spending from the `from` account and
184     // - From account must have sufficient balance to transfer
185     // - Spender must have sufficient allowance to transfer
186     // - 0 value transfers are allowed
187     // ------------------------------------------------------------------------
188     function transferFrom(address from, address to, uint tokens) canTransfer(from) public returns (bool success) {
189         require(to != address(this));
190 
191         //check edge cases
192         if (allowed[from][msg.sender] >= tokens
193             && balances[from] >= tokens
194             && tokens > 0) {
195 
196             //update balances and allowances
197             balances[from] = safeSub(balances[from], tokens);
198             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
199             balances[to] = safeAdd(balances[to], tokens);
200 
201             //log event
202             emit Transfer(from, to, tokens);
203             return true;
204         }
205         else {
206             return false;
207         }
208     }
209 
210     // ------------------------------------------------------------------------
211     // Returns the amount of tokens approved by the owner that can be
212     // transferred to the spender's account
213     // ------------------------------------------------------------------------
214     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
215         return allowed[tokenOwner][spender];
216     }
217 
218 
219     // Owner can allow transfers for a particular address. Use for crowdsale contract.
220     function setTransferAdmin(address _addr, bool _canTransfer) onlyOwner public {
221         transferAdmins[_addr] = _canTransfer;
222     }
223 
224     // Enable transfers for token holders
225     function enablesTransfers() public onlyOwner {
226         transferEnabled = true;
227     }
228 
229     // ------------------------------------------------------------------------
230     // Burns a specific number of tokens
231     // ------------------------------------------------------------------------
232     function burn(uint256 _value) public onlyOwner {
233         require(_value > 0);
234 
235         address burner = msg.sender;
236         balances[burner] = safeSub(balances[burner], _value);
237         _totalSupply = safeSub(_totalSupply, _value);
238         emit Burned(burner, _value);
239     }
240 
241     // ------------------------------------------------------------------------
242     // Doesn't Accept Eth
243     // ------------------------------------------------------------------------
244     function () public payable {
245         revert();
246     }
247 }