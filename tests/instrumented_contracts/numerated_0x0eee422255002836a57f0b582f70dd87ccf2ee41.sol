1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Ownership functionality for authorization controls and user permissions
5 // ----------------------------------------------------------------------------
6 contract Owned {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address _newOwner) public onlyOwner {
22         newOwner = _newOwner;
23     }
24     function acceptOwnership() public {
25         require(msg.sender == newOwner);
26         emit OwnershipTransferred(owner, newOwner);
27         owner = newOwner;
28         newOwner = address(0);
29     }
30 }
31 
32 
33 
34 // ----------------------------------------------------------------------------
35 // Safe maths
36 // ----------------------------------------------------------------------------
37 contract SafeMath {
38     function safeAdd(uint a, uint b) public pure returns (uint c) {
39         c = a + b;
40         require(c >= a);
41     }
42     function safeSub(uint a, uint b) public pure returns (uint c) {
43         require(b <= a);
44         c = a - b;
45     }
46     function safeMul(uint a, uint b) public pure returns (uint c) {
47         c = a * b;
48         require(a == 0 || c / a == b);
49     }
50     function safeDiv(uint a, uint b) public pure returns (uint c) {
51         require(b > 0);
52         c = a / b;
53     }
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // ERC20 Standard Interface
59 // ----------------------------------------------------------------------------
60 contract ERC20 {
61     function totalSupply() public constant returns (uint);
62     function balanceOf(address tokenOwner) public constant returns (uint balance);
63     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
64     function transfer(address to, uint tokens) public returns (bool success);
65     function approve(address spender, uint tokens) public returns (bool success);
66     function transferFrom(address from, address to, uint tokens) public returns (bool success);
67 
68     event Transfer(address indexed from, address indexed to, uint tokens);
69     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
70 }
71 
72 
73 // ----------------------------------------------------------------------------
74 // 'BCT' 'Bitcratic' token contract
75 // Symbol      : BCT
76 // Name        : Bitcratic
77 // Total supply: 88,000,000
78 // Decimals    : 18
79 // ----------------------------------------------------------------------------
80 
81 
82 // ----------------------------------------------------------------------------
83 // ERC20 Token. Specifies symbol, name, decimals, and total supply
84 // ----------------------------------------------------------------------------
85 contract Bitcratic is  Owned,SafeMath, ERC20 {
86 	string public symbol;
87     string public  name;
88     uint8 public decimals;
89     uint public _totalSupply;
90 
91 
92 
93     mapping(address => uint) public balances;
94     mapping(address => mapping(address => uint)) internal allowed;
95 
96     event Burned(address indexed burner, uint256 value);
97     
98 
99 
100     // ------------------------------------------------------------------------
101     // Constructor
102     // ------------------------------------------------------------------------
103     constructor() public {
104         symbol = "BCT";
105         name = "Bitcratic";
106         decimals = 18;
107         _totalSupply = 88000000 * 10**uint(decimals);
108         balances[owner] = _totalSupply;
109         emit Transfer(address(0), owner, _totalSupply);
110     }
111 
112     // ------------------------------------------------------------------------
113     // Total supply
114     // ------------------------------------------------------------------------
115     function totalSupply() public constant returns (uint) {
116         return _totalSupply;
117     }
118 
119     // ------------------------------------------------------------------------
120     // Get the token balance for account `tokenOwner`
121     // ------------------------------------------------------------------------
122     function balanceOf(address tokenOwner) public constant returns (uint balance) {
123         return balances[tokenOwner];
124     }
125 
126     // ------------------------------------------------------------------------
127     // Transfer the balance from token owner's account to `to` account
128     // - Owner's account must have sufficient balance to transfer
129     // - 0 value transfers are allowed
130     // ------------------------------------------------------------------------
131     function transfer(address to, uint tokens) public  returns (bool success) {
132         require(to != address(this)); //make sure we're not transfering to this contract
133 
134         //check edge cases
135         if (balances[msg.sender] >= tokens
136             && tokens > 0) {
137 
138                 //update balances
139                 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
140                 balances[to] = safeAdd(balances[to], tokens);
141 
142                 //log event
143                 emit Transfer(msg.sender, to, tokens);
144                 return true;
145         }
146         else {
147             return false;
148         }
149     }
150 
151     // ------------------------------------------------------------------------
152     // Token owner can approve for `spender` to transferFrom(...) `tokens`
153     // from the token owner's account
154     // ------------------------------------------------------------------------
155     function approve(address spender, uint tokens) public  returns (bool success) {
156         allowed[msg.sender][spender] = tokens;
157         emit Approval(msg.sender, spender, tokens);
158         return true;
159     }
160 
161     // ------------------------------------------------------------------------
162     // Transfer `tokens` from the `from` account to the `to` account
163     //
164     // The calling account must already have sufficient tokens approve(...)-d
165     // for spending from the `from` account and
166     // - From account must have sufficient balance to transfer
167     // - Spender must have sufficient allowance to transfer
168     // ------------------------------------------------------------------------
169     function transferFrom(address from, address to, uint tokens) public  returns (bool success) {
170         require(to != address(this));
171 
172         //check edge cases
173         if (allowed[from][msg.sender] >= tokens
174             && balances[from] >= tokens
175             && tokens > 0) {
176 
177             //update balances and allowances
178             balances[from] = safeSub(balances[from], tokens);
179             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
180             balances[to] = safeAdd(balances[to], tokens);
181 
182             //log event
183             emit Transfer(from, to, tokens);
184             return true;
185         }
186         else {
187             return false;
188         }
189     }
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
201     // Burns a specific number of tokens
202     // ------------------------------------------------------------------------
203     function burn(uint256 _value) public onlyOwner {
204         require(_value > 0);
205 
206         address burner = msg.sender;
207         balances[burner] = safeSub(balances[burner], _value);
208         _totalSupply = safeSub(_totalSupply, _value);
209         emit Burned(burner, _value);
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Doesn't Accept Eth
215     // ------------------------------------------------------------------------
216     function () public payable {
217         revert();
218     }
219 }