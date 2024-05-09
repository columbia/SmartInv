1 pragma solidity ^0.5.17;
2 // ----------------------------------------------------------------------------
3 // ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
5 // ----------------------------------------------------------------------------
6 contract ERC20Interface {
7   function totalSupply() public view returns (uint);
8   function balanceOf(address tokenOwner) public view returns (uint balance);
9   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
10   function transfer(address to, uint tokens) public returns (bool success);
11   function approve(address spender, uint tokens) public returns (bool success);
12   function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 
14   event Transfer(address indexed from, address indexed to, uint tokens);
15   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
22 library SafeMath {
23   function add(uint a, uint b) internal pure returns (uint c) {
24     c = a + b;
25     require(c >= a);
26   }
27   function sub(uint a, uint b) internal pure returns (uint c) {
28     require(b <= a);
29     c = a - b;
30   }
31   function mul(uint a, uint b) internal pure returns (uint c) {
32     c = a * b;
33     require(a == 0 || c / a == b); // the same as: if (a !=0 && c / a != b) {throw;}
34   }
35   function div(uint a, uint b) internal pure returns (uint c) {
36     require(b > 0);
37     c = a / b;
38   }
39 }
40 
41 // ----------------------------------------------------------------------------
42 // ERC20 Token, with the addition of symbol, name and decimals and an
43 // initial fixed supply
44 // ----------------------------------------------------------------------------
45 contract WaterToken is ERC20Interface {
46   using SafeMath for uint;
47 
48   string public symbol;
49   string public  name;
50   uint8 public decimals;
51   uint _totalSupply;
52 
53   mapping(address => uint) balances;
54   mapping(address => mapping(address => uint)) allowed;
55 
56 
57   // ------------------------------------------------------------------------
58   // Constructor
59   // ------------------------------------------------------------------------
60   constructor() public {
61     symbol = "WT";
62     name = "Water Token";
63     decimals = 18;
64     _totalSupply = 100000000 * 10**uint(decimals);
65     balances[msg.sender] = _totalSupply;
66     emit Transfer(address(0), msg.sender, _totalSupply);
67   }
68 
69   // ------------------------------------------------------------------------
70   // Total supply
71   // ------------------------------------------------------------------------
72   function totalSupply() public view returns (uint) {
73     return _totalSupply;
74   }
75 
76   // ------------------------------------------------------------------------
77   // Get the token balance for account `tokenOwner`
78   // ------------------------------------------------------------------------
79   function balanceOf(address tokenOwner) public view returns (uint balance) {
80     return balances[tokenOwner];
81   }
82 
83   // ------------------------------------------------------------------------
84   // Transfer the balance from token owner's account to `to` account
85   // - Owner's account must have sufficient balance to transfer
86   // - 0 value transfers are allowed
87   // ------------------------------------------------------------------------
88   function transfer(address to, uint tokens) public returns (bool success) {
89     require(to != address(0), "to address is a zero address"); 
90     balances[msg.sender] = balances[msg.sender].sub(tokens);
91     balances[to] = balances[to].add(tokens);
92     emit Transfer(msg.sender, to, tokens);
93     return true;
94   }
95 
96   // ------------------------------------------------------------------------
97   // Token owner can approve for `spender` to transferFrom(...) `tokens`
98   // from the token owner's account
99   //
100   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
101   // recommends that there are no checks for the approval double-spend attack
102   // as this should be implemented in user interfaces
103   // ------------------------------------------------------------------------
104   function approve(address spender, uint tokens) public returns (bool success) {
105     require(spender != address(0), "spender address is a zero address");   
106     allowed[msg.sender][spender] = tokens;
107     emit Approval(msg.sender, spender, tokens);
108     return true;
109   }
110 
111   // ------------------------------------------------------------------------
112   // Transfer `tokens` from the `from` account to the `to` account
113   //
114   // The calling account must already have sufficient tokens approve(...)-d
115   // for spending from the `from` account and
116   // - From account must have sufficient balance to transfer
117   // - Spender must have sufficient allowance to transfer
118   // - 0 value transfers are allowed
119   // ------------------------------------------------------------------------
120   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
121     require(to != address(0), "to address is a zero address"); 
122     balances[from] = balances[from].sub(tokens);
123     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
124     balances[to] = balances[to].add(tokens);
125     emit Transfer(from, to, tokens);
126     return true;
127   }
128 
129   // ------------------------------------------------------------------------
130   // Returns the amount of tokens approved by the owner that can be
131   // transferred to the spender's account
132   // ------------------------------------------------------------------------
133   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
134     return allowed[tokenOwner][spender];
135   }
136 }