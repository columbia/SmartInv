1 pragma solidity ^0.5.0;
2 
3 // MM token contract
4 // Shivam
5 // Symbol      : MM
6 // Name        : Moon Money Chain
7 // Total supply: 2400000000000000000000000000
8 // Decimals    : 18
9 //
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
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
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
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
51     // This notifies clients about the amount burnt
52     event Burn(address indexed from, uint256 value);
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Owned contract
58 // ----------------------------------------------------------------------------
59 contract Owned {
60     address public owner;
61     address public newOwner;
62 
63     event OwnershipTransferred(address indexed _from, address indexed _to);
64 
65     constructor() public {
66         //owner = msg.sender;
67         owner = 0xEdD992a90729a2Ba7c14b37562730E64D4DA8988;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 // ERC20 Token, with the addition of symbol, name and decimals and a
89 // fixed supply
90 // ----------------------------------------------------------------------------
91 contract MMChain is ERC20Interface, Owned {
92     using SafeMath for uint;
93 
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint _totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     constructor() public {
107         symbol = "MM";
108         name = "Moon Money Chain";
109         decimals = 18;
110         _totalSupply = 2400000000 * 10**uint(decimals);
111         balances[owner] = _totalSupply;
112         emit Transfer(address(0), owner, _totalSupply);
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Total supply
118     // ------------------------------------------------------------------------
119     function totalSupply() public view returns (uint) {
120         return _totalSupply.sub(balances[address(0)]);
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Get the token balance for account `tokenOwner`
126     // ------------------------------------------------------------------------
127     function balanceOf(address tokenOwner) public view returns (uint balance) {
128         return balances[tokenOwner];
129     }
130 
131     /**
132      * Internal transfer, only can be called by this contract
133      */
134     function _transfer(address _from, address _to, uint _value) internal {
135         // Prevent transfer to 0x0 address. Use burn() instead
136         require(_to != address(0x0));
137         // Check if the sender has enough
138         require(balanceOf(_from) >= _value);
139         // Check for overflows
140         require(balanceOf(_to) + _value >= balanceOf(_to));
141         // Save this for an assertion in the future
142         uint previousBalances = balanceOf(_from) + balanceOf(_to);
143         // Subtract from the sender
144         balances[_from] = balances[_from].sub(_value);
145         // Add the same to the recipient
146         balances[_to] = balances[_to].add(_value);
147         // Now emit the event
148         emit Transfer(_from, _to, _value);
149         // Asserts are used to use static analysis to find bugs in your code. They should never fail
150         assert(balanceOf(_from) + balanceOf(_to) == previousBalances);
151     }
152 
153     // ------------------------------------------------------------------------
154     // Transfer the balance from token owner's account to `to` account
155     // - Owner's account must have sufficient balance to transfer
156     // - 0 value transfers are allowed
157     // ------------------------------------------------------------------------
158     function transfer(address _to, uint256 _value) public returns (bool success) {
159         _transfer(msg.sender, _to, _value);
160         return true;
161     }
162 
163     // ------------------------------------------------------------------------
164     // Token owner can approve for `spender` to transferFrom(...) `tokens`
165     // from the token owner's account
166     //
167     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
168     // recommends that there are no checks for the approval double-spend attack
169     // as this should be implemented in user interfaces
170     // ------------------------------------------------------------------------
171     function approve(address spender, uint tokens) public returns (bool success) {
172         allowed[msg.sender][spender] = tokens;
173         emit Approval(msg.sender, spender, tokens);
174         return true;
175     }
176 
177     // ------------------------------------------------------------------------
178     // Transfer `tokens` from the `from` account to the `to` account
179     //
180     // The calling account must already have sufficient tokens approve(...)-d
181     // for spending from the `from` account and
182     // - From account must have sufficient balance to transfer
183     // - Spender must have sufficient allowance to transfer
184     // - 0 value transfers are allowed
185     // ------------------------------------------------------------------------
186 
187 
188     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
189         require(_value <= allowance(_from, msg.sender));     // Check allowance
190         allowed[_from][msg.sender] -= _value;
191         _transfer(_from, _to, _value);
192         return true;
193     }
194 
195     // ------------------------------------------------------------------------
196     // Returns the amount of tokens approved by the owner that can be
197     // transferred to the spender's account
198     // ------------------------------------------------------------------------
199     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
200         return allowed[tokenOwner][spender];
201     }
202 
203 
204     /**
205      * Destroy tokens
206      *
207      * Remove `_value` tokens from the system irreversibly
208      *
209      * @param _value the amount of money to burn
210      */
211     function burn(uint256 _value) public returns (bool success) {
212         require(balanceOf(msg.sender) >= _value);   // Check if the sender has enough
213         balances[msg.sender] -= _value;            // Subtract from the sender
214         _totalSupply -= _value;                      // Updates totalSupply
215         emit Burn(msg.sender, _value);
216         return true;
217     }
218 
219 
220 
221     // ------------------------------------------------------------------------
222     // Don't accept ETH
223     // ------------------------------------------------------------------------
224     //function () external payable {
225     //  revert();
226     //}
227 
228 
229     // ------------------------------------------------------------------------
230     // Owner can transfer out any accidentally sent ERC20 tokens
231     // ------------------------------------------------------------------------
232     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
233         return ERC20Interface(tokenAddress).transfer(owner, tokens);
234     }
235 }