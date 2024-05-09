1 pragma solidity ^0.4.20;
2 
3 
4 // ----------------------------------------------------------------------------
5 // CWH token contract
6 //
7 // Symbol           : CWH
8 // Name             : Chrysalis Token
9 // Total Supply     : 25,000,000
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
57 contract ChrysalisToken is ERC20Interface {
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
73     constructor() public {
74         symbol = "CWH";
75         name = "Chrysalis Token";
76         decimals = 18;
77         _totalSupply = 25000000;
78         _totalSupply = _totalSupply.mul(10 ** uint(decimals));
79         address owner = 0x49BB86e52f724dcbD858F66640fC58E3CA8000A0;
80         balances[owner] = _totalSupply;
81         emit Transfer(address(0), owner, _totalSupply);
82     }
83     
84     
85     // ------------------------------------------------------------------------
86     // Reject when someone sends ethers to this contract
87     // ------------------------------------------------------------------------
88     function() public payable {
89         revert();
90     }
91     
92     
93     // ------------------------------------------------------------------------
94     // Total supply
95     // ------------------------------------------------------------------------
96     function totalSupply() public view returns (uint) {
97         return _totalSupply;
98     }
99 
100 
101     // ------------------------------------------------------------------------
102     // Get the token balance for account `tokenOwner`
103     // ------------------------------------------------------------------------
104     function balanceOf(address tokenOwner) public view returns (uint balance) {
105         return balances[tokenOwner];
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Transfer the balance from token owner's account to `to` account
111     // - Owner's account must have sufficient balance to transfer
112     // - 0 value transfers are allowed
113     // ------------------------------------------------------------------------
114     function transfer(address to, uint tokens) public returns (bool success) {
115         require(to != address(0));
116         require(tokens > 0);
117         require(balances[msg.sender] >= tokens);
118         
119         balances[msg.sender] = balances[msg.sender].sub(tokens);
120         balances[to] = balances[to].add(tokens);
121         emit Transfer(msg.sender, to, tokens);
122         return true;
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Token owner can approve for `spender` to transferFrom(...) `tokens`
128     // from the token owner's account
129     //
130     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
131     // recommends that there are no checks for the approval double-spend attack
132     // as this should be implemented in user interfaces 
133     // ------------------------------------------------------------------------
134     function approve(address spender, uint tokens) public returns (bool success) {
135         require(spender != address(0));
136         require(tokens > 0);
137         
138         allowed[msg.sender][spender] = tokens;
139         emit Approval(msg.sender, spender, tokens);
140         return true;
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Transfer `tokens` from the `from` account to the `to` account
146     // 
147     // The calling account must already have sufficient tokens approve(...)-d
148     // for spending from the `from` account and
149     // - From account must have sufficient balance to transfer
150     // - Spender must have sufficient allowance to transfer
151     // ------------------------------------------------------------------------
152     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
153         require(from != address(0));
154         require(to != address(0));
155         require(tokens > 0);
156         require(balances[from] >= tokens);
157         require(allowed[from][msg.sender] >= tokens);
158         
159         balances[from] = balances[from].sub(tokens);
160         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
161         balances[to] = balances[to].add(tokens);
162         emit Transfer(from, to, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Returns the amount of tokens approved by the owner that can be
169     // transferred to the spender's account
170     // ------------------------------------------------------------------------
171     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
172         return allowed[tokenOwner][spender];
173     }
174     
175     
176     // ------------------------------------------------------------------------
177     // Increase the amount of tokens that an owner allowed to a spender.
178     //
179     // approve should be called when allowed[_spender] == 0. To increment
180     // allowed value is better to use this function to avoid 2 calls (and wait until
181     // the first transaction is mined)
182     // _spender The address which will spend the funds.
183     // _addedValue The amount of tokens to increase the allowance by.
184     // ------------------------------------------------------------------------
185     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186         require(_spender != address(0));
187         
188         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190         return true;
191     }
192     
193     
194     // ------------------------------------------------------------------------
195     // Decrease the amount of tokens that an owner allowed to a spender.
196     //
197     // approve should be called when allowed[_spender] == 0. To decrement
198     // allowed value is better to use this function to avoid 2 calls (and wait until
199     // the first transaction is mined)
200     // _spender The address which will spend the funds.
201     // _subtractedValue The amount of tokens to decrease the allowance by.
202     // ------------------------------------------------------------------------
203     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204         require(_spender != address(0));
205         
206         uint oldValue = allowed[msg.sender][_spender];
207         if (_subtractedValue > oldValue) {
208             allowed[msg.sender][_spender] = 0;
209         } else {
210             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211         }
212         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 
216 }