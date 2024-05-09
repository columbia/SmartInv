1 pragma solidity ^0.4.20;
2 
3 
4 // ----------------------------------------------------------------------------
5 // STP token contract
6 //
7 // Symbol           : STP
8 // Name             : BitGoals
9 // Total Supply     : 185,000,000
10 // Decimals         : 18
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe math
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public view returns (uint);
43     function balanceOf(address tokenOwner) public view returns (uint balance);
44     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // ERC20 Token, with the addition of symbol, name and decimals and an
56 // initial fixed supply
57 // ----------------------------------------------------------------------------
58 contract BitGoals is ERC20Interface {
59     
60     using SafeMath for uint;
61 
62     string public symbol;
63     string public  name;
64     uint8 public decimals;
65     uint public _totalSupply;
66 
67     mapping(address => uint) balances;
68     mapping(address => mapping(address => uint)) allowed;
69     
70     
71     // ------------------------------------------------------------------------
72     // Constructor
73     // ------------------------------------------------------------------------
74     constructor() public {
75         symbol = "STP";
76         name = "BitGoals";
77         decimals = 18;
78         _totalSupply = 185000000;
79         address owner = 0x209380a57d88B07352A409548F3Ff9A95066881D;
80         _totalSupply = _totalSupply.mul(10 ** uint(decimals));
81         balances[owner] = _totalSupply;
82         emit Transfer(address(0), owner, _totalSupply);
83     }
84     
85     
86     // ------------------------------------------------------------------------
87     // Reject when someone sends ethers to this contract
88     // ------------------------------------------------------------------------
89     function() public payable {
90         revert();
91     }
92     
93     
94     // ------------------------------------------------------------------------
95     // Total supply
96     // ------------------------------------------------------------------------
97     function totalSupply() public view returns (uint) {
98         return _totalSupply;
99     }
100 
101 
102     // ------------------------------------------------------------------------
103     // Get the token balance for account `tokenOwner`
104     // ------------------------------------------------------------------------
105     function balanceOf(address tokenOwner) public view returns (uint balance) {
106         return balances[tokenOwner];
107     }
108 
109 
110     // ------------------------------------------------------------------------
111     // Transfer the balance from token owner's account to `to` account
112     // - Owner's account must have sufficient balance to transfer
113     // - 0 value transfers are allowed
114     // ------------------------------------------------------------------------
115     function transfer(address to, uint tokens) public returns (bool success) {
116         require(to != address(0));
117         require(tokens > 0);
118         require(balances[msg.sender] >= tokens);
119         
120         balances[msg.sender] = balances[msg.sender].sub(tokens);
121         balances[to] = balances[to].add(tokens);
122         emit Transfer(msg.sender, to, tokens);
123         return true;
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Token owner can approve for `spender` to transferFrom(...) `tokens`
129     // from the token owner's account
130     //
131     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
132     // recommends that there are no checks for the approval double-spend attack
133     // as this should be implemented in user interfaces 
134     // ------------------------------------------------------------------------
135     function approve(address spender, uint tokens) public returns (bool success) {
136         require(spender != address(0));
137         require(tokens > 0);
138         
139         allowed[msg.sender][spender] = tokens;
140         emit Approval(msg.sender, spender, tokens);
141         return true;
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Transfer `tokens` from the `from` account to the `to` account
147     // 
148     // The calling account must already have sufficient tokens approve(...)-d
149     // for spending from the `from` account and
150     // - From account must have sufficient balance to transfer
151     // - Spender must have sufficient allowance to transfer
152     // ------------------------------------------------------------------------
153     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
154         require(from != address(0));
155         require(to != address(0));
156         require(tokens > 0);
157         require(balances[from] >= tokens);
158         require(allowed[from][msg.sender] >= tokens);
159         
160         balances[from] = balances[from].sub(tokens);
161         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
162         balances[to] = balances[to].add(tokens);
163         emit Transfer(from, to, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Returns the amount of tokens approved by the owner that can be
170     // transferred to the spender's account
171     // ------------------------------------------------------------------------
172     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
173         return allowed[tokenOwner][spender];
174     }
175     
176     
177     // ------------------------------------------------------------------------
178     // Increase the amount of tokens that an owner allowed to a spender.
179     //
180     // approve should be called when allowed[_spender] == 0. To increment
181     // allowed value is better to use this function to avoid 2 calls (and wait until
182     // the first transaction is mined)
183     // _spender The address which will spend the funds.
184     // _addedValue The amount of tokens to increase the allowance by.
185     // ------------------------------------------------------------------------
186     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
187         require(_spender != address(0));
188         
189         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191         return true;
192     }
193     
194     
195     // ------------------------------------------------------------------------
196     // Decrease the amount of tokens that an owner allowed to a spender.
197     //
198     // approve should be called when allowed[_spender] == 0. To decrement
199     // allowed value is better to use this function to avoid 2 calls (and wait until
200     // the first transaction is mined)
201     // From MonolithDAO Token.sol
202     // _spender The address which will spend the funds.
203     // _subtractedValue The amount of tokens to decrease the allowance by.
204     // ------------------------------------------------------------------------
205     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
206         require(_spender != address(0));
207         
208         uint oldValue = allowed[msg.sender][_spender];
209         if (_subtractedValue > oldValue) {
210             allowed[msg.sender][_spender] = 0;
211         } else {
212             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213         }
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218 }