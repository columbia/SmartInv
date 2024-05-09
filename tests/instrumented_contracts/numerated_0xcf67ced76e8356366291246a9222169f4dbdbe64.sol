1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Symbol      : DICE
6 // Name        : DICE.FINANCE TOKEN
7 // Total supply: 30,678.000000000000000000
8 // Decimals    : 18
9 //
10 // Enjoy.
11 //
12 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 library SafeMath {
20     function add(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function sub(uint a, uint b) internal pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function mul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function div(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // ERC Token Standard #20 Interface
41 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
42 // ----------------------------------------------------------------------------
43 contract ERC20Interface {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 
56 
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63 
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 // ERC20 Token, with the addition of symbol, name and decimals and an
89 // initial fixed supply
90 // ----------------------------------------------------------------------------
91 contract DiceToken is ERC20Interface, Owned {
92     using SafeMath for uint;
93 
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint public _totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     constructor() public {
107         decimals = 18;
108         symbol = "DICE";
109         name = "DICE.FINANCE TOKEN";
110         _totalSupply = 30678 * 10**uint(decimals);
111         balances[owner] = _totalSupply;
112         emit Transfer(address(0), owner, _totalSupply);
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Total supply
118     // ------------------------------------------------------------------------
119     function totalSupply() public constant returns (uint) {
120         return _totalSupply  - balances[address(0)];
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Get the token balance for account `tokenOwner`
126     // ------------------------------------------------------------------------
127     function balanceOf(address tokenOwner) public constant returns (uint balance) {
128         return balances[tokenOwner];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Transfer the balance from token owner's account to `to` account
134     // - Owner's account must have sufficient balance to transfer
135     // - 0 value transfers are allowed
136     // ------------------------------------------------------------------------
137     function transfer(address to, uint tokens) public returns (bool success) {
138         balances[msg.sender] = balances[msg.sender].sub(tokens);
139         balances[to] = balances[to].add(tokens);
140         emit Transfer(msg.sender, to, tokens);
141         return true;
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Token owner can approve for `spender` to transferFrom(...) `tokens`
147     // from the token owner's account
148     //
149     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
150     // recommends that there are no checks for the approval double-spend attack
151     // as this should be implemented in user interfaces 
152     // ------------------------------------------------------------------------
153     function approve(address spender, uint tokens) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         emit Approval(msg.sender, spender, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Transfer `tokens` from the `from` account to the `to` account
162     // 
163     // The calling account must already have sufficient tokens approve(...)-d
164     // for spending from the `from` account and
165     // - From account must have sufficient balance to transfer
166     // - Spender must have sufficient allowance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
170         balances[from] = balances[from].sub(tokens);
171         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
172         balances[to] = balances[to].add(tokens);
173         emit Transfer(from, to, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Returns the amount of tokens approved by the owner that can be
180     // transferred to the spender's account
181     // ------------------------------------------------------------------------
182     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
183         return allowed[tokenOwner][spender];
184     }
185 
186 
187 
188     // ------------------------------------------------------------------------
189     // Don't accept ETH
190     // ------------------------------------------------------------------------
191     function () public payable {
192         revert();
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Owner can transfer out any accidentally sent ERC20 tokens
198     // ------------------------------------------------------------------------
199     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
200         return ERC20Interface(tokenAddress).transfer(owner, tokens);
201     }
202 }