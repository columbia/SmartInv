1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // Safe math
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
31     function totalSupply() public view returns (uint);
32     function balanceOf(address tokenOwner) public view returns (uint balance);
33     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
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
44 // ERC20 Token, with the addition of symbol, name and decimals and an
45 // initial fixed supply
46 // ----------------------------------------------------------------------------
47 contract DCXToken is ERC20Interface {
48 
49     using SafeMath for uint;
50 
51     string public symbol;
52     string public  name;
53     uint8 public decimals;
54     uint public _totalSupply;
55     address owner;
56 
57     mapping(address => uint) balances;
58     mapping(address => mapping(address => uint)) allowed;
59 
60 
61     modifier onlyOwner {
62         assert(msg.sender == owner);
63         _;
64     }
65 
66 
67     // ------------------------------------------------------------------------
68     // Constructor
69     // ------------------------------------------------------------------------
70     constructor() public {
71         symbol = "DCX";
72         name = "DCX Global Ltd Dividend Entitlement";
73         decimals = 0;
74         _totalSupply = 1000000000 * 10**uint(decimals);
75         owner = msg.sender;
76         balances[owner] = _totalSupply;
77         emit Transfer(address(0), owner, _totalSupply);
78     }
79 
80 
81     // ------------------------------------------------------------------------
82     // Reject when someone sends ethers to this contract
83     // ------------------------------------------------------------------------
84     function() public payable {
85         revert("You can't send ether to this contract");
86     }
87 
88 
89     // ------------------------------------------------------------------------
90     // Total supply
91     // ------------------------------------------------------------------------
92     function totalSupply() public view returns (uint) {
93         return _totalSupply;
94     }
95 
96 
97     // ------------------------------------------------------------------------
98     // Get the token balance for account `tokenOwner`
99     // ------------------------------------------------------------------------
100     function balanceOf(address tokenOwner) public view returns (uint balance) {
101         return balances[tokenOwner];
102     }
103 
104 
105     // ------------------------------------------------------------------------
106     // Transfer the balance from token owner's account to `to` account
107     // - Owner's account must have sufficient balance to transfer
108     // - 0 value transfers are allowed
109     // ------------------------------------------------------------------------
110     function transfer(address to, uint tokens) public returns (bool success) {
111         require(to != address(0));
112         require(tokens > 0);
113         require(balances[msg.sender] >= tokens);
114 
115         balances[msg.sender] = balances[msg.sender].sub(tokens);
116         balances[to] = balances[to].add(tokens);
117         emit Transfer(msg.sender, to, tokens);
118         return true;
119     }
120 
121 
122     // ------------------------------------------------------------------------
123     // Token owner can approve for `spender` to transferFrom(...) `tokens`
124     // from the token owner's account
125     //
126     // recommends that there are no checks for the approval double-spend attack
127     // as this should be implemented in user interfaces
128     // ------------------------------------------------------------------------
129     function approve(address spender, uint tokens) public returns (bool success) {
130         require(spender != address(0));
131         require(tokens > 0);
132 
133         allowed[msg.sender][spender] = tokens;
134         emit Approval(msg.sender, spender, tokens);
135         return true;
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer `tokens` from the `from` account to the `to` account
141     //
142     // The calling account must already have sufficient tokens approve(...)-d
143     // for spending from the `from` account and
144     // - From account must have sufficient balance to transfer
145     // - Spender must have sufficient allowance to transfer
146     // ------------------------------------------------------------------------
147     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
148         require(from != address(0));
149         require(to != address(0));
150         require(tokens > 0);
151         require(balances[from] >= tokens);
152         require(allowed[from][msg.sender] >= tokens);
153 
154         balances[from] = balances[from].sub(tokens);
155         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
156         balances[to] = balances[to].add(tokens);
157         emit Transfer(from, to, tokens);
158         return true;
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Returns the amount of tokens approved by the owner that can be
164     // transferred to the spender's account
165     // ------------------------------------------------------------------------
166     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
167         return allowed[tokenOwner][spender];
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Increase the amount of tokens that an owner allowed to a spender.
173     //
174     // approve should be called when allowed[_spender] == 0. To increment
175     // allowed value is better to use this function to avoid 2 calls (and wait until
176     // the first transaction is mined)
177     // _spender The address which will spend the funds.
178     // _addedValue The amount of tokens to increase the allowance by.
179     // ------------------------------------------------------------------------
180     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
181         assert(_spender != address(0));
182 
183         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185         return true;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Decrease the amount of tokens that an owner allowed to a spender.
191     //
192     // approve should be called when allowed[_spender] == 0. To decrement
193     // allowed value is better to use this function to avoid 2 calls (and wait until
194     // the first transaction is mined)
195     // From MonolithDAO Token.sol
196     // _spender The address which will spend the funds.
197     // _subtractedValue The amount of tokens to decrease the allowance by.
198     // ------------------------------------------------------------------------
199     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200         assert(_spender != address(0));
201 
202         uint oldValue = allowed[msg.sender][_spender];
203         if (_subtractedValue > oldValue) {
204             allowed[msg.sender][_spender] = 0;
205         } else {
206             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207         }
208         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209         return true;
210     }
211 
212 
213 }