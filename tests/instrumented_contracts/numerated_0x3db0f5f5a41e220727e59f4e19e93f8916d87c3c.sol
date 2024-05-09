1 pragma solidity ^0.4.17;
2 
3 
4 // ----------------------------------------------------------------------------
5 // TIP token contract
6 //
7 // Symbol           : TIP
8 // Name             : Tipcoin
9 // Total supply     : 10,000,000,000.000000000000000000
10 // Decimals         : 18
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe math
15 // ----------------------------------------------------------------------------
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function sub(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function div(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public view returns (uint);
42     function balanceOf(address tokenOwner) public view returns (uint balance);
43     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // ERC20 Token, with the addition of symbol, name and decimals and an
55 // initial fixed supply
56 // ----------------------------------------------------------------------------
57 contract Tipcoin is ERC20Interface {
58     
59     using SafeMath for uint;
60 
61     string public symbol;
62     string public  name;
63     uint8 public decimals;
64     uint public _totalSupply;
65 
66     mapping(address => uint) balances;
67     mapping(address => mapping(address => uint)) allowed;
68     
69     
70     // ------------------------------------------------------------------------
71     // Constructor
72     // ------------------------------------------------------------------------
73     function Tipcoin() public {
74         symbol = "TIP";
75         name = "Tipcoin";
76         decimals = 18;
77         _totalSupply = 10000000000 * 10**uint(decimals);
78         address owner = 0x0eEda9Eb3333F2EBA926853a8637fa3e8Aa4b8e2;
79         balances[owner] = _totalSupply;
80         emit Transfer(address(0), owner, _totalSupply);
81     }
82     
83     
84     // ------------------------------------------------------------------------
85     // Reject when someone sends ethers to this contract
86     // ------------------------------------------------------------------------
87     function() public payable {
88         revert();
89     }
90     
91     
92     // ------------------------------------------------------------------------
93     // Total supply
94     // ------------------------------------------------------------------------
95     function totalSupply() public view returns (uint) {
96         return _totalSupply;
97     }
98 
99 
100     // ------------------------------------------------------------------------
101     // Get the token balance for account `tokenOwner`
102     // ------------------------------------------------------------------------
103     function balanceOf(address tokenOwner) public view returns (uint balance) {
104         return balances[tokenOwner];
105     }
106 
107 
108     // ------------------------------------------------------------------------
109     // Transfer the balance from token owner's account to `to` account
110     // - Owner's account must have sufficient balance to transfer
111     // - 0 value transfers are allowed
112     // ------------------------------------------------------------------------
113     function transfer(address to, uint tokens) public returns (bool success) {
114         if(balances[msg.sender] >= tokens && tokens > 0 && to != address(0)) {
115             balances[msg.sender] = balances[msg.sender].sub(tokens);
116             balances[to] = balances[to].add(tokens);
117             emit Transfer(msg.sender, to, tokens);
118             return true;
119         } else { return false; }
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Token owner can approve for `spender` to transferFrom(...) `tokens`
125     // from the token owner's account
126     //
127     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
128     // recommends that there are no checks for the approval double-spend attack
129     // as this should be implemented in user interfaces 
130     // ------------------------------------------------------------------------
131     function approve(address spender, uint tokens) public returns (bool success) {
132         if(tokens > 0 && spender != address(0)) {
133             allowed[msg.sender][spender] = tokens;
134             emit Approval(msg.sender, spender, tokens);
135             return true;
136         } else { return false; }
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Transfer `tokens` from the `from` account to the `to` account
142     // 
143     // The calling account must already have sufficient tokens approve(...)-d
144     // for spending from the `from` account and
145     // - From account must have sufficient balance to transfer
146     // - Spender must have sufficient allowance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
150         if (balances[from] >= tokens && allowed[from][msg.sender] >= tokens && tokens > 0) {
151             balances[from] = balances[from].sub(tokens);
152             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
153             balances[to] = balances[to].add(tokens);
154             emit Transfer(from, to, tokens);
155             return true;
156         } else { return false; }
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Returns the amount of tokens approved by the owner that can be
162     // transferred to the spender's account
163     // ------------------------------------------------------------------------
164     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
165         return allowed[tokenOwner][spender];
166     }
167     
168     
169     // ------------------------------------------------------------------------
170     // Increase the amount of tokens that an owner allowed to a spender.
171     //
172     // approve should be called when allowed[_spender] == 0. To increment
173     // allowed value is better to use this function to avoid 2 calls (and wait until
174     // the first transaction is mined)
175     // From MonolithDAO Token.sol
176     // _spender The address which will spend the funds.
177     // _addedValue The amount of tokens to increase the allowance by.
178     // ------------------------------------------------------------------------
179     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
180         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184     
185     
186     // ------------------------------------------------------------------------
187     // Decrease the amount of tokens that an owner allowed to a spender.
188     //
189     // approve should be called when allowed[_spender] == 0. To decrement
190     // allowed value is better to use this function to avoid 2 calls (and wait until
191     // the first transaction is mined)
192     // From MonolithDAO Token.sol
193     // _spender The address which will spend the funds.
194     // _subtractedValue The amount of tokens to decrease the allowance by.
195     // ------------------------------------------------------------------------
196     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
197         uint oldValue = allowed[msg.sender][_spender];
198         if (_subtractedValue > oldValue) {
199             allowed[msg.sender][_spender] = 0;
200         } else {
201             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
202         }
203         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204         return true;
205     }
206 
207 }