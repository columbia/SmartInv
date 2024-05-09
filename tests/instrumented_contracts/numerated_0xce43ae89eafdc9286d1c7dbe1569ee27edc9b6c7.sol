1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Owned contract
45 // ----------------------------------------------------------------------------
46 contract Owned {
47     address public owner;
48     address public newOwner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52     function Owned() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         newOwner = _newOwner;
63     }
64     function acceptOwnership() public {
65         require(msg.sender == newOwner);
66         OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68         newOwner = address(0);
69     }
70 }
71 
72 
73 // ----------------------------------------------------------------------------
74 // ERC20 Token, with the addition of symbol, name and decimals and an
75 // initial fixed supply
76 // ----------------------------------------------------------------------------
77 contract Mining is ERC20Interface, Owned {
78     using SafeMath for uint;
79 
80     string public symbol;
81     string public  name;
82     uint8 public decimals;
83     uint public _totalSupply;
84 
85     mapping(address => uint) balances;
86     mapping(address => mapping(address => uint)) allowed;
87 
88 
89     // ------------------------------------------------------------------------
90     // Constructor
91     // ------------------------------------------------------------------------
92     function Mining() public {
93         symbol = "MINI";
94         name = "Mining";
95         decimals = 18;
96         _totalSupply = 1.8 * 10000 * 10000 * 10**uint(decimals);
97         balances[owner] = _totalSupply;
98         Transfer(address(0), owner, _totalSupply);
99     }
100 
101 
102     // ------------------------------------------------------------------------
103     // Total supply
104     // ------------------------------------------------------------------------
105     function totalSupply() public constant returns (uint) {
106         return _totalSupply  - balances[address(0)];
107     }
108 
109 
110     // ------------------------------------------------------------------------
111     // Get the token balance for account `tokenOwner`
112     // ------------------------------------------------------------------------
113     function balanceOf(address tokenOwner) public constant returns (uint balance) {
114         return balances[tokenOwner];
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Transfer the balance from token owner's account to `to` account
120     // - Owner's account must have sufficient balance to transfer
121     // - 0 value transfers are allowed
122     // ------------------------------------------------------------------------
123     function transfer(address to, uint tokens) public returns (bool success) {
124         balances[msg.sender] = balances[msg.sender].sub(tokens);
125         balances[to] = balances[to].add(tokens);
126         Transfer(msg.sender, to, tokens);
127         return true;
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Token owner can approve for `spender` to transferFrom(...) `tokens`
133     // from the token owner's account
134     //
135     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
136     // recommends that there are no checks for the approval double-spend attack
137     // as this should be implemented in user interfaces 
138     // ------------------------------------------------------------------------
139     function approve(address spender, uint tokens) public returns (bool success) {
140         allowed[msg.sender][spender] = tokens;
141         Approval(msg.sender, spender, tokens);
142         return true;
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Transfer `tokens` from the `from` account to the `to` account
148     // 
149     // The calling account must already have sufficient tokens approve(...)-d
150     // for spending from the `from` account and
151     // - From account must have sufficient balance to transfer
152     // - Spender must have sufficient allowance to transfer
153     // - 0 value transfers are allowed
154     // ------------------------------------------------------------------------
155     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
156         balances[from] = balances[from].sub(tokens);
157         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
158         balances[to] = balances[to].add(tokens);
159         Transfer(from, to, tokens);
160         return true;
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Returns the amount of tokens approved by the owner that can be
166     // transferred to the spender's account
167     // ------------------------------------------------------------------------
168     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
169         return allowed[tokenOwner][spender];
170     }
171 
172     // ------------------------------------------------------------------------
173     // Don't accept ETH
174     // ------------------------------------------------------------------------
175     function () public payable {
176         revert();
177     }
178 
179 }