1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 // FIXED ERCX token contract
5 //
6 // Symbol      : ERCX
7 // Name        : Edel Rosten Coin
8 // Total supply: 122,000,000
9 // Decimals    : 18
10 
11 // ----------------------------------------------------------------------------
12 // Safe math
13 // ----------------------------------------------------------------------------
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function sub(uint a, uint b) internal pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function mul(uint a, uint b) internal pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function div(uint a, uint b) internal pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 
34 // ----------------------------------------------------------------------------
35 // ERCX Token Standard #20 Interface
36 // ----------------------------------------------------------------------------
37 contract ERCX20Interface {
38     function totalSupply() public constant returns (uint);
39     function balanceOf(address tokenOwner) public constant returns (uint balance);
40     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 // ----------------------------------------------------------------------------
50 // ERCX20 Token, with the addition of symbol, name and decimals and an
51 // initial fixed supply
52 // ----------------------------------------------------------------------------
53 contract EdelRostenCoin is ERCX20Interface {
54     
55     using SafeMath for uint;
56 
57     string public symbol;
58     string public  name;
59     uint8 public decimals;
60     uint public _totalSupply;
61     address public owner;
62 
63     mapping(address => uint) balances;
64     mapping(address => mapping(address => uint)) allowed;
65 
66 
67     // ------------------------------------------------------------------------
68     // Constructor
69     // ------------------------------------------------------------------------
70     function EdelRostenCoin() public {
71         symbol = "ERCX";
72         name = "Edel Rosten Coin";
73         decimals = 18;
74         _totalSupply = 122000000 * 10**uint(decimals);
75         owner = 0xDeE7D782Fa2645070e3c15CabF8324A0ccceAC78;
76         balances[owner] = _totalSupply;
77         Transfer(address(0), owner, _totalSupply);
78     }
79     
80     function() public payable {
81         revert();
82     }
83     
84     // ------------------------------------------------------------------------
85     // Total supply
86     // ------------------------------------------------------------------------
87     function totalSupply() public constant returns (uint) {
88         return _totalSupply;
89     }
90 
91 
92     // ------------------------------------------------------------------------
93     // Get the token balance for account `tokenOwner`
94     // ------------------------------------------------------------------------
95     function balanceOf(address tokenOwner) public constant returns (uint balance) {
96         return balances[tokenOwner];
97     }
98 
99 
100     // ------------------------------------------------------------------------
101     // Transfer the balance from token owner's account to `to` account
102     // - Owner's account must have sufficient balance to transfer
103     // - 0 value transfers are allowed
104     // ------------------------------------------------------------------------
105     function transfer(address to, uint tokens) public returns (bool success) {
106         if(balances[msg.sender] >= tokens && tokens > 0 && to!=address(0)) {
107             balances[msg.sender] = balances[msg.sender].sub(tokens);
108             balances[to] = balances[to].add(tokens);
109             Transfer(msg.sender, to, tokens);
110             return true;
111         } else { return false; }
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Token owner can approve for `spender` to transferFrom(...) `tokens`
117     // from the token owner's account
118     //
119     // recommends that there are no checks for the approval double-spend attack
120     // as this should be implemented in user interfaces 
121     // ------------------------------------------------------------------------
122     function approve(address spender, uint tokens) public returns (bool success) {
123         if(tokens > 0 && spender != address(0)) {
124             allowed[msg.sender][spender] = tokens;
125             Approval(msg.sender, spender, tokens);
126             return true;
127         } else { return false; }
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Transfer `tokens` from the `from` account to the `to` account
133     // 
134     // The calling account must already have sufficient tokens approve(...)-d
135     // for spending from the `from` account and
136     // - From account must have sufficient balance to transfer
137     // - Spender must have sufficient allowance to transfer
138     // - 0 value transfers are allowed
139     // ------------------------------------------------------------------------
140     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
141         if (balances[from] >= tokens && allowed[from][msg.sender] >= tokens && tokens > 0) {
142             balances[from] = balances[from].sub(tokens);
143             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
144             balances[to] = balances[to].add(tokens);
145             Transfer(from, to, tokens);
146             return true;
147         } else { return false; }
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Returns the amount of tokens approved by the owner that can be
153     // transferred to the spender's account
154     // ------------------------------------------------------------------------
155     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
156         return allowed[tokenOwner][spender];
157     }
158 
159 }