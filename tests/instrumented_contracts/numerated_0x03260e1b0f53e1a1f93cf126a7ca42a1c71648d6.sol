1 pragma solidity ^0.4.20;
2 
3 
4 // ----------------------------------------------------------------------------
5 // RingDEX Token Burnable/Mintable token contract
6 //
7 // Symbol           : RDEX
8 // Name             : RingDEX Token
9 // Total Supply     : 1,000,000
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
71     event Mint(address indexed to, uint256 amount);
72     event Burn(address indexed burner, uint256 value);
73     
74     
75     modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79     
80     
81     // ------------------------------------------------------------------------
82     // Constructor
83     // ------------------------------------------------------------------------
84     constructor() public {
85         symbol = "RDEX";
86         name = "RingDEX Token";
87         decimals = 8;
88         _totalSupply = 1000000 * 10**uint(decimals);
89         owner = msg.sender;
90         balances[owner] = _totalSupply;
91         emit Transfer(address(0), owner, _totalSupply);
92     }
93     
94     
95     // ------------------------------------------------------------------------
96     // Reject when someone sends ethers to this contract
97     // ------------------------------------------------------------------------
98     function() public payable {
99         revert();
100     }
101     
102     
103     // ------------------------------------------------------------------------
104     // Total supply
105     // ------------------------------------------------------------------------
106     function totalSupply() public view returns (uint) {
107         return _totalSupply;
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Get the token balance for account `tokenOwner`
113     // ------------------------------------------------------------------------
114     function balanceOf(address tokenOwner) public view returns (uint balance) {
115         return balances[tokenOwner];
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Transfer the balance from token owner's account to `to` account
121     // - Owner's account must have sufficient balance to transfer
122     // - 0 value transfers are allowed
123     // ------------------------------------------------------------------------
124     function transfer(address to, uint tokens) public returns (bool success) {
125         require(to != address(0));
126         require(tokens > 0);
127         require(balances[msg.sender] >= tokens);
128         
129         balances[msg.sender] = balances[msg.sender].sub(tokens);
130         balances[to] = balances[to].add(tokens);
131         emit Transfer(msg.sender, to, tokens);
132         return true;
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Token owner can approve for `spender` to transferFrom(...) `tokens`
138     // from the token owner's account
139     //
140     // recommends that there are no checks for the approval double-spend attack
141     // as this should be implemented in user interfaces 
142     // ------------------------------------------------------------------------
143     function approve(address spender, uint tokens) public returns (bool success) {
144         require(spender != address(0));
145         require(tokens > 0);
146         
147         allowed[msg.sender][spender] = tokens;
148         emit Approval(msg.sender, spender, tokens);
149         return true;
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Transfer `tokens` from the `from` account to the `to` account
155     // 
156     // The calling account must already have sufficient tokens approve(...)-d
157     // for spending from the `from` account and
158     // - From account must have sufficient balance to transfer
159     // - Spender must have sufficient allowance to transfer
160     // ------------------------------------------------------------------------
161     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
162         require(from != address(0));
163         require(to != address(0));
164         require(tokens > 0);
165         require(balances[from] >= tokens);
166         require(allowed[from][msg.sender] >= tokens);
167         
168         balances[from] = balances[from].sub(tokens);
169         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
170         balances[to] = balances[to].add(tokens);
171         emit Transfer(from, to, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Returns the amount of tokens approved by the owner that can be
178     // transferred to the spender's account
179     // ------------------------------------------------------------------------
180     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
181         return allowed[tokenOwner][spender];
182     }
183     
184     
185     // ------------------------------------------------------------------------
186     // Increase the amount of tokens that an owner allowed to a spender.
187     //
188     // approve should be called when allowed[_spender] == 0. To increment
189     // allowed value is better to use this function to avoid 2 calls (and wait until
190     // the first transaction is mined)
191     // _spender The address which will spend the funds.
192     // _addedValue The amount of tokens to increase the allowance by.
193     // ------------------------------------------------------------------------
194     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195         require(_spender != address(0));
196         
197         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199         return true;
200     }
201     
202     
203     // ------------------------------------------------------------------------
204     // Decrease the amount of tokens that an owner allowed to a spender.
205     //
206     // approve should be called when allowed[_spender] == 0. To decrement
207     // allowed value is better to use this function to avoid 2 calls (and wait until
208     // the first transaction is mined)
209     // From MonolithDAO Token.sol
210     // _spender The address which will spend the funds.
211     // _subtractedValue The amount of tokens to decrease the allowance by.
212     // ------------------------------------------------------------------------
213     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
214         require(_spender != address(0));
215         
216         uint oldValue = allowed[msg.sender][_spender];
217         if (_subtractedValue > oldValue) {
218             allowed[msg.sender][_spender] = 0;
219         } else {
220             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221         }
222         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225     
226     
227     // ------------------------------------------------------------------------
228     // Function to mint tokens
229     // _to The address that will receive the minted tokens.
230     // _value The amount of tokens to mint.
231     // A boolean that indicates if the operation was successful.
232     // ------------------------------------------------------------------------
233     function mint(address _to, uint256 _value) onlyOwner public returns (bool) {
234         require(_to != address(0));
235         require(_value > 0);
236         
237         _totalSupply = _totalSupply.add(_value);
238         balances[_to] = balances[_to].add(_value);
239         emit Mint(_to, _value);
240         emit Transfer(address(0), _to, _value);
241         return true;
242     }
243     
244     
245     // ------------------------------------------------------------------------
246     // Function to burn tokens
247     // _value The amount of tokens to burn.
248     // A boolean that indicates if the operation was successful.
249     // ------------------------------------------------------------------------
250     function burn(uint256 _value) onlyOwner public {
251       require(_value > 0);
252       require(_value <= balances[msg.sender]);
253       
254       address burner = msg.sender;
255       balances[burner] = balances[burner].sub(_value);
256       _totalSupply = _totalSupply.sub(_value);
257       emit Burn(burner, _value);
258       emit Transfer(burner, address(0), _value);
259     }
260 
261 }