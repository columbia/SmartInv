1 pragma solidity ^0.4.20;
2 
3 
4 // ----------------------------------------------------------------------------
5 // RingDEX Token token contract
6 //
7 // Symbol           : RDEX
8 // Name             : RingDEX Token
9 // Total Supply     : 10,000,000
10 // Decimals         : 8
11 // ----------------------------------------------------------------------------
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
57 contract RingDEXToken is ERC20Interface {
58     
59     using SafeMath for uint;
60 
61     string public symbol;
62     string public  name;
63     uint8 public decimals;
64     uint public _totalSupply;
65     address owner;
66 
67     mapping(address => uint) balances;
68     mapping(address => mapping(address => uint)) allowed;
69     
70     
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75     
76     
77     // ------------------------------------------------------------------------
78     // Constructor
79     // ------------------------------------------------------------------------
80     constructor() public {
81         symbol = "RDEX";
82         name = "RingDEX Token";
83         decimals = 8;
84         _totalSupply = 10000000 * 10**uint(decimals);
85         owner = msg.sender;
86         balances[owner] = _totalSupply;
87         emit Transfer(address(0), owner, _totalSupply);
88     }
89     
90     
91     // ------------------------------------------------------------------------
92     // Reject when someone sends ethers to this contract
93     // ------------------------------------------------------------------------
94     function() public payable {
95         revert();
96     }
97     
98     
99     // ------------------------------------------------------------------------
100     // Total supply
101     // ------------------------------------------------------------------------
102     function totalSupply() public view returns (uint) {
103         return _totalSupply;
104     }
105 
106 
107     // ------------------------------------------------------------------------
108     // Get the token balance for account `tokenOwner`
109     // ------------------------------------------------------------------------
110     function balanceOf(address tokenOwner) public view returns (uint balance) {
111         return balances[tokenOwner];
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Transfer the balance from token owner's account to `to` account
117     // - Owner's account must have sufficient balance to transfer
118     // - 0 value transfers are allowed
119     // ------------------------------------------------------------------------
120     function transfer(address to, uint tokens) public returns (bool success) {
121         require(to != address(0));
122         require(tokens > 0);
123         require(balances[msg.sender] >= tokens);
124         
125         balances[msg.sender] = balances[msg.sender].sub(tokens);
126         balances[to] = balances[to].add(tokens);
127         emit Transfer(msg.sender, to, tokens);
128         return true;
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Token owner can approve for `spender` to transferFrom(...) `tokens`
134     // from the token owner's account
135     //
136     // recommends that there are no checks for the approval double-spend attack
137     // as this should be implemented in user interfaces 
138     // ------------------------------------------------------------------------
139     function approve(address spender, uint tokens) public returns (bool success) {
140         require(spender != address(0));
141         require(tokens > 0);
142         
143         allowed[msg.sender][spender] = tokens;
144         emit Approval(msg.sender, spender, tokens);
145         return true;
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Transfer `tokens` from the `from` account to the `to` account
151     // 
152     // The calling account must already have sufficient tokens approve(...)-d
153     // for spending from the `from` account and
154     // - From account must have sufficient balance to transfer
155     // - Spender must have sufficient allowance to transfer
156     // ------------------------------------------------------------------------
157     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
158         require(from != address(0));
159         require(to != address(0));
160         require(tokens > 0);
161         require(balances[from] >= tokens);
162         require(allowed[from][msg.sender] >= tokens);
163         
164         balances[from] = balances[from].sub(tokens);
165         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
166         balances[to] = balances[to].add(tokens);
167         emit Transfer(from, to, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Returns the amount of tokens approved by the owner that can be
174     // transferred to the spender's account
175     // ------------------------------------------------------------------------
176     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
177         return allowed[tokenOwner][spender];
178     }
179     
180     
181     // ------------------------------------------------------------------------
182     // Increase the amount of tokens that an owner allowed to a spender.
183     //
184     // approve should be called when allowed[_spender] == 0. To increment
185     // allowed value is better to use this function to avoid 2 calls (and wait until
186     // the first transaction is mined)
187     // _spender The address which will spend the funds.
188     // _addedValue The amount of tokens to increase the allowance by.
189     // ------------------------------------------------------------------------
190     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
191         require(_spender != address(0));
192         
193         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195         return true;
196     }
197     
198     
199     // ------------------------------------------------------------------------
200     // Decrease the amount of tokens that an owner allowed to a spender.
201     //
202     // approve should be called when allowed[_spender] == 0. To decrement
203     // allowed value is better to use this function to avoid 2 calls (and wait until
204     // the first transaction is mined)
205     // From MonolithDAO Token.sol
206     // _spender The address which will spend the funds.
207     // _subtractedValue The amount of tokens to decrease the allowance by.
208     // ------------------------------------------------------------------------
209     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210         require(_spender != address(0));
211         
212         uint oldValue = allowed[msg.sender][_spender];
213         if (_subtractedValue > oldValue) {
214             allowed[msg.sender][_spender] = 0;
215         } else {
216             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217         }
218         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219         return true;
220     }
221     
222     
223 }