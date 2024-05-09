1 pragma solidity 0.4.21;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         c = a * b;
9         require(a == 0 || c / a == b);
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         require(b > 0);
14         c = a / b;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
18         require(b <= a);
19         c = a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         require(c >= a);
25   }
26 
27 }
28 
29 
30 // ----------------------------------------------------------------------------
31 // ERC Token Standard #20 Interface
32 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
33 // ----------------------------------------------------------------------------
34 contract ERC20Interface {
35   
36     function totalSupply() public constant returns (uint);
37     function balanceOf(address tokenOwner) public constant returns (uint balance);
38     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
39     function transfer(address to, uint tokens) public returns (bool success);
40     function approve(address spender, uint tokens) public returns (bool success);
41     function transferFrom(address from, address to, uint tokens) public returns (bool success);
42     function burn(uint256 tokens) public returns (bool success);
43     function freeze(uint256 tokens) public returns (bool success);
44     function unfreeze(uint256 tokens) public returns (bool success);
45 
46 
47     /* This generates a public event on the blockchain that will notify clients */
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     
50     /* This approve the allowance for the spender  */
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52     
53     /* This notifies clients about the amount burnt */
54     event Burn(address indexed from, uint256 tokens);
55     
56     /* This notifies clients about the amount frozen */
57     event Freeze(address indexed from, uint256 tokens);
58 	
59     /* This notifies clients about the amount unfrozen */
60     event Unfreeze(address indexed from, uint256 tokens);
61  }
62  
63 // ----------------------------------------------------------------------------
64 // Owned contract
65 // ----------------------------------------------------------------------------
66 contract Owned {
67     address public owner;
68     address public newOwner;
69 
70     event OwnershipTransferred(address indexed _from, address indexed _to);
71 
72     function Owned() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function transferOwnership(address _newOwner) public onlyOwner {
82         newOwner = _newOwner;
83     }
84     function acceptOwnership() public {
85         require(msg.sender == newOwner);
86         emit OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88     }
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // ERC20 Token, with the addition of symbol, name and decimals and an
94 // initial CTC supply
95 // ----------------------------------------------------------------------------
96 
97 contract WILLTOKEN is ERC20Interface, Owned {
98     using SafeMath for uint;
99     string public name;
100     string public symbol;
101     uint8 public decimals;
102     uint256 public _totalSupply;
103     address public owner;
104 
105     /* This creates an array with all balances */
106     mapping (address => uint256) public balances;
107     mapping(address => mapping(address => uint256)) allowed;
108     mapping (address => uint256) public freezeOf;
109     
110  
111     /* Initializes contract with initial supply tokens to the creator of the contract */
112     function WILLTOKEN (
113         uint256 initialSupply,
114         string tokenName,
115         uint8 decimalUnits,
116         string tokenSymbol
117         ) public {
118 	
119         decimals = decimalUnits;				// Amount of decimals for display purposes
120         _totalSupply = initialSupply * 10**uint(decimals);      // Update total supply
121         name = tokenName;                                       // Set the name for display purposes
122         symbol = tokenSymbol;                                   // Set the symbol for display purpose
123         owner = msg.sender;                                     // Set the creator as owner
124         balances[owner] = _totalSupply;                         // Give the creator all initial tokens
125 	
126     }
127     
128     // ------------------------------------------------------------------------
129     // Total supply
130     // ------------------------------------------------------------------------
131     function totalSupply() public constant returns (uint) {
132         return _totalSupply;
133     }
134     
135     // ------------------------------------------------------------------------
136     // Get the token balance for account `tokenOwner`
137     // ------------------------------------------------------------------------
138     function balanceOf(address tokenOwner) public constant returns (uint balance) {
139         return balances[tokenOwner];
140     }
141 
142     // ------------------------------------------------------------------------
143     // Transfer the balance from token owner's account to `to` account
144     // - Owner's account must have sufficient balance to transfer
145     // ------------------------------------------------------------------------
146     function transfer(address to, uint tokens) public returns (bool success) {
147         require( tokens > 0 && to != 0x0 );
148         balances[msg.sender] = balances[msg.sender].sub(tokens);
149         balances[to] = balances[to].add(tokens);
150         emit Transfer(msg.sender, to, tokens);
151         return true;
152     }
153 
154     // ------------------------------------------------------------------------
155     // Token owner can approve for `spender` to transferFrom(...) `tokens`
156     // from the token owner's account
157     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md 
158     // recommends that there are no checks for the approval double-spend attack
159     // as this should be implemented in user interfaces 
160     // ------------------------------------------------------------------------
161     function approve(address spender, uint tokens) public onlyOwner returns (bool success) {
162         allowed[msg.sender][spender] = tokens;
163         emit Approval(msg.sender, spender, tokens);
164         return true;
165     }
166 
167     // ------------------------------------------------------------------------
168     // Transfer `tokens` from the `from` account to the `to` account
169     // 
170     // The calling account must already have sufficient tokens approve(...)-d
171     // for spending from the `from` account and
172     // - From account must have sufficient balance to transfer
173     // - Spender must have sufficient allowance to transfer
174     // ------------------------------------------------------------------------
175     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
176         require( tokens > 0 && to != 0x0 && from != 0x0 );
177         balances[from] = balances[from].sub(tokens);
178         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
179         balances[to] = balances[to].add(tokens);
180         emit Transfer(from, to, tokens);
181         return true;
182     }
183 
184     // ------------------------------------------------------------------------
185     // Returns the amount of tokens approved by the owner that can be
186     // transferred to the spender's account
187     // ------------------------------------------------------------------------
188     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
189         return allowed[tokenOwner][spender];
190     }
191     
192     // ------------------------------------------------------------------------
193     // Burns the amount of tokens by the owner
194     // ------------------------------------------------------------------------
195     function burn(uint256 tokens) public  onlyOwner returns (bool success) {
196        require (balances[msg.sender] >= tokens) ;                        // Check if the sender has enough
197        require (tokens > 0) ; 
198        balances[msg.sender] = balances[msg.sender].sub(tokens);         // Subtract from the sender
199        _totalSupply = _totalSupply.sub(tokens);                         // Updates totalSupply
200        emit Burn(msg.sender, tokens);
201        return true;
202     }
203 	
204     // ------------------------------------------------------------------------
205     // Freeze the amount of tokens by the owner
206     // ------------------------------------------------------------------------
207     function freeze(uint256 tokens) public onlyOwner returns (bool success) {
208        require (balances[msg.sender] >= tokens) ;                   // Check if the sender has enough
209        require (tokens > 0) ; 
210        balances[msg.sender] = balances[msg.sender].sub(tokens);    // Subtract from the sender
211        freezeOf[msg.sender] = freezeOf[msg.sender].add(tokens);     // Updates totalSupply
212        emit Freeze(msg.sender, tokens);
213        return true;
214     }
215 	
216     // ------------------------------------------------------------------------
217     // Unfreeze the amount of tokens by the owner
218     // ------------------------------------------------------------------------
219     function unfreeze(uint256 tokens) public onlyOwner returns (bool success) {
220        require (freezeOf[msg.sender] >= tokens) ;                    // Check if the sender has enough
221        require (tokens > 0) ; 
222        freezeOf[msg.sender] = freezeOf[msg.sender].sub(tokens);    // Subtract from the sender
223        balances[msg.sender] = balances[msg.sender].add(tokens);
224        emit Unfreeze(msg.sender, tokens);
225        return true;
226     }
227 
228 
229    // ------------------------------------------------------------------------
230    // Don't accept ETH
231    // ------------------------------------------------------------------------
232    function () public payable {
233       revert();
234    }
235 
236 }