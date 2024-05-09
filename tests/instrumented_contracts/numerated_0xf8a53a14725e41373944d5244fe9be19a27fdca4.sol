1 pragma solidity 0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'IST' 'istanbul' contract
5 // ----------------------------------------------------------------------------
6 // Symbol      : IST
7 // Name        : Istanbul
8 // Total supply: 50.020.000.000000000000000000
9 // Decimals    : 18
10 // ----------------------------------------------------------------------------
11 
12 
13 
14 // ----------------------------------------------------------------------------
15 // Math operations with safety checks
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         require(b > 0);
25         c = a / b;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
29         require(b <= a);
30         c = a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34         c = a + b;
35         require(c >= a);
36   }
37 
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46 
47     function totalSupply() public constant returns (uint);
48     function balanceOf(address tokenOwner) public constant returns (uint balance);
49     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
50     function transfer(address to, uint tokens) public returns (bool success);
51     function approve(address spender, uint tokens) public returns (bool success);
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53     function burn(uint256 tokens) public returns (bool success);
54     function freeze(uint256 tokens) public returns (bool success);
55     function unfreeze(uint256 tokens) public returns (bool success);
56 
57 
58     /* This generates a public event on the blockchain that will notify clients */
59     event Transfer(address indexed from, address indexed to, uint tokens);
60 
61     /* This approve the allowance for the spender  */
62     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
63 
64     /* This notifies clients about the amount burnt */
65     event Burn(address indexed from, uint256 tokens);
66 
67     /* This notifies clients about the amount frozen */
68     event Freeze(address indexed from, uint256 tokens);
69 
70     /* This notifies clients about the amount unfrozen */
71     event Unfreeze(address indexed from, uint256 tokens);
72  }
73 
74 // ----------------------------------------------------------------------------
75 // Owned contract
76 // ----------------------------------------------------------------------------
77 contract Owned {
78     address public owner;
79     address public newOwner;
80 
81     event OwnershipTransferred(address indexed _from, address indexed _to);
82 //constructor
83     constructor () public {
84         owner = msg.sender;
85     }
86 
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function transferOwnership(address _newOwner) public onlyOwner {
93         newOwner = _newOwner;
94     }
95     function acceptOwnership() public {
96         require(msg.sender == newOwner);
97         emit OwnershipTransferred(owner, newOwner);
98         owner = newOwner;
99     }
100 }
101 
102 
103 // ----------------------------------------------------------------------------
104 // ERC20 Token, with the addition of symbol, name and decimals and an
105 // initial supply
106 // ----------------------------------------------------------------------------
107 
108 contract istanbul is ERC20Interface, Owned {
109     using SafeMath for uint;
110     string public name;
111     string public symbol;
112     uint8 public decimals;
113     uint256 public _totalSupply;
114     address public owner;
115 
116     /* This creates an array with all balances */
117     mapping (address => uint256) public balances;
118     mapping(address => mapping(address => uint256)) allowed;
119     mapping (address => uint256) public freezeOf;
120 
121 
122     /* Initializes contract with initial supply tokens to the creator of the contract */
123     constructor() public {
124         symbol = "IST";
125         name = "istanbul";
126         decimals = 18;
127         _totalSupply = 50020000 * 10**uint(decimals);
128         balances[owner] = _totalSupply;
129         emit Transfer(address(0), owner, _totalSupply);
130     }
131 
132     // ------------------------------------------------------------------------
133     // Total supply
134     // ------------------------------------------------------------------------
135     function totalSupply() public constant returns (uint) {
136         return _totalSupply;
137     }
138 
139     // ------------------------------------------------------------------------
140     // Get the token balance for account `tokenOwner`
141     // ------------------------------------------------------------------------
142     function balanceOf(address tokenOwner) public constant returns (uint balance) {
143         return balances[tokenOwner];
144     }
145 
146     // ------------------------------------------------------------------------
147     // Transfer the balance from token owner's account to `to` account
148     // Owner's account must have sufficient balance to transfer
149     // ------------------------------------------------------------------------
150     function transfer(address to, uint tokens) public returns (bool success) {
151         require( tokens > 0 && to != 0x0 );
152         balances[msg.sender] = balances[msg.sender].sub(tokens);
153         balances[to] = balances[to].add(tokens);
154         emit Transfer(msg.sender, to, tokens);
155         return true;
156     }
157 
158     // ------------------------------------------------------------------------
159     // Token owner can approve for `spender` to transferFrom(...) `tokens`
160     // from the token owner's account
161     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
162     // recommends that there are no checks for the approval double-spend attack
163     // as this should be implemented in user interfaces
164     // ------------------------------------------------------------------------
165     function approve(address spender, uint tokens) public onlyOwner returns (bool success) {
166         allowed[msg.sender][spender] = tokens;
167         emit Approval(msg.sender, spender, tokens);
168         return true;
169     }
170 
171     // ------------------------------------------------------------------------
172     // Transfer `tokens` from the `from` account to the `to` account
173     //
174     // The calling account must already have sufficient tokens approve(...)-d
175     // for spending from the `from` account and
176     // - From account must have sufficient balance to transfer
177     // - Spender must have sufficient allowance to transfer
178     // ------------------------------------------------------------------------
179     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
180         require( tokens > 0 && to != 0x0 && from != 0x0 );
181         balances[from] = balances[from].sub(tokens);
182         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
183         balances[to] = balances[to].add(tokens);
184         emit Transfer(from, to, tokens);
185         return true;
186     }
187 
188     // ------------------------------------------------------------------------
189     // Returns the amount of tokens approved by the owner that can be
190     // transferred to the spender's account
191     // ------------------------------------------------------------------------
192     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
193         return allowed[tokenOwner][spender];
194     }
195 
196     // ------------------------------------------------------------------------
197     // Burns the amount of tokens by the owner
198     // ------------------------------------------------------------------------
199     function burn(uint256 tokens) public  onlyOwner returns (bool success) {
200        require (balances[msg.sender] >= tokens) ;                        // Check if the sender has enough
201        require (tokens > 0) ;
202        balances[msg.sender] = balances[msg.sender].sub(tokens);         // Subtract from the sender
203        _totalSupply = _totalSupply.sub(tokens);                         // Updates totalSupply
204        emit Burn(msg.sender, tokens);
205        return true;
206     }
207 
208     // ------------------------------------------------------------------------
209     // Freeze the amount of tokens by the owner
210     // ------------------------------------------------------------------------
211     function freeze(uint256 tokens) public onlyOwner returns (bool success) {
212        require (balances[msg.sender] >= tokens) ;                   // Check if the sender has enough
213        require (tokens > 0) ;
214        balances[msg.sender] = balances[msg.sender].sub(tokens);    // Subtract from the sender
215        freezeOf[msg.sender] = freezeOf[msg.sender].add(tokens);     // Updates totalSupply
216        emit Freeze(msg.sender, tokens);
217        return true;
218     }
219 
220     // ------------------------------------------------------------------------
221     // Unfreeze the amount of tokens by the owner
222     // ------------------------------------------------------------------------
223     function unfreeze(uint256 tokens) public onlyOwner returns (bool success) {
224        require (freezeOf[msg.sender] >= tokens) ;                    // Check if the sender has enough
225        require (tokens > 0) ;
226        freezeOf[msg.sender] = freezeOf[msg.sender].sub(tokens);    // Subtract from the sender
227        balances[msg.sender] = balances[msg.sender].add(tokens);
228        emit Unfreeze(msg.sender, tokens);
229        return true;
230     }
231 
232 
233    // ------------------------------------------------------------------------
234    // Don't accept ETH
235    // ------------------------------------------------------------------------
236    function () public payable {
237       revert();
238    }
239 
240 
241 }
242 
243 
244 
245 // ----------------------------------------------------------------------------
246 // Psp (sha1) = c1323412799ee711e7e5a6a1ac655bbd18d75980
247 // ----------------------------------------------------------------------------