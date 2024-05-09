1 pragma solidity ^0.4.20;
2 
3 
4 // ----------------------------------------------------------------------------
5 // CREST token contract
6 //
7 // Symbol           : CSTT
8 // Name             : Crest Token
9 // Total Supply     : 12,500,000
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
57 contract CrestToken is ERC20Interface {
58     
59     using SafeMath for uint;
60 
61     string public symbol;
62     string public  name;
63     uint8 public decimals;
64     uint public _totalSupply;
65     address public owner;
66 
67     mapping(address => uint) balances;
68     mapping(address => mapping(address => uint)) allowed;
69     
70     event Burn(address indexed burner, uint256 value);
71     
72     
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77     
78     
79     // ------------------------------------------------------------------------
80     // Constructor
81     // ------------------------------------------------------------------------
82     function CrestToken() public {
83         symbol = "CSTT";
84         name = "Crest Token";
85         decimals = 18;
86         _totalSupply = 12500000 * 10**uint(decimals);
87         owner = 0x4a17ccd1f0bb40c64919404851e3c5a33c4c3c58;
88         balances[owner] = _totalSupply;
89         emit Transfer(address(0), owner, _totalSupply);
90     }
91     
92     
93     // ------------------------------------------------------------------------
94     // Reject when someone sends ethers to this contract
95     // ------------------------------------------------------------------------
96     function() public payable {
97         revert();
98     }
99     
100     
101     // ------------------------------------------------------------------------
102     // Total supply
103     // ------------------------------------------------------------------------
104     function totalSupply() public view returns (uint) {
105         return _totalSupply;
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Get the token balance for account `tokenOwner`
111     // ------------------------------------------------------------------------
112     function balanceOf(address tokenOwner) public view returns (uint balance) {
113         return balances[tokenOwner];
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Transfer the balance from token owner's account to `to` account
119     // - Owner's account must have sufficient balance to transfer
120     // - 0 value transfers are allowed
121     // ------------------------------------------------------------------------
122     function transfer(address to, uint tokens) public returns (bool success) {
123         if(balances[msg.sender] >= tokens && tokens > 0 && to != address(0)) {
124             balances[msg.sender] = balances[msg.sender].sub(tokens);
125             balances[to] = balances[to].add(tokens);
126             emit Transfer(msg.sender, to, tokens);
127             return true;
128         } else { return false; }
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Token owner can approve for `spender` to transferFrom(...) `tokens`
134     // from the token owner's account
135     //
136     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
137     // recommends that there are no checks for the approval double-spend attack
138     // as this should be implemented in user interfaces 
139     // ------------------------------------------------------------------------
140     function approve(address spender, uint tokens) public returns (bool success) {
141         if(tokens > 0 && spender != address(0)) {
142             allowed[msg.sender][spender] = tokens;
143             emit Approval(msg.sender, spender, tokens);
144             return true;
145         } else { return false; }
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
156     // - 0 value transfers are allowed
157     // ------------------------------------------------------------------------
158     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
159         if (balances[from] >= tokens && allowed[from][msg.sender] >= tokens && tokens > 0) {
160             balances[from] = balances[from].sub(tokens);
161             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
162             balances[to] = balances[to].add(tokens);
163             emit Transfer(from, to, tokens);
164             return true;
165         } else { return false; }
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Returns the amount of tokens approved by the owner that can be
171     // transferred to the spender's account
172     // ------------------------------------------------------------------------
173     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
174         return allowed[tokenOwner][spender];
175     }
176     
177     
178     // ------------------------------------------------------------------------
179     // Increase the amount of tokens that an owner allowed to a spender.
180     //
181     // approve should be called when allowed[_spender] == 0. To increment
182     // allowed value is better to use this function to avoid 2 calls (and wait until
183     // the first transaction is mined)
184     // From MonolithDAO Token.sol
185     // _spender The address which will spend the funds.
186     // _addedValue The amount of tokens to increase the allowance by.
187     // ------------------------------------------------------------------------
188     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
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
216     
217     function burn(uint256 _value) onlyOwner public {
218       require(_value > 0);
219       require(_value <= balances[msg.sender]);
220       address burner = msg.sender;
221       balances[burner] = balances[burner].sub(_value);
222       _totalSupply = _totalSupply.sub(_value);
223       emit Burn(burner, _value);
224       emit Transfer(burner, address(0), _value);
225     }
226 
227 }