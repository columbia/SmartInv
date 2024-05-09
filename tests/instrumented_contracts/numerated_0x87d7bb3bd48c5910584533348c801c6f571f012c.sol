1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'FIXED' 'Example Fixed Supply Token' token contract
5 //
6 // Symbol      : FIXED
7 // Name        : Example Fixed Supply Token
8 // Total supply: 250,000,000.000
9 // Decimals    : 3
10 //
11 // Enjoy.
12 //
13 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 library SafeMath {
21     function add(uint a, uint b) internal pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function mul(uint a, uint b) internal pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function div(uint a, uint b) internal pure returns (uint c) {
34         require(b > 0);
35         c = a / b;
36     }
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63 
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 
66     constructor() public {
67         owner = msg.sender;
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
91 contract winecoin is ERC20Interface, Owned {
92     using SafeMath for uint;
93 
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint _totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101     mapping (address => bool) public frozenAccount;
102 
103     event FrozenFunds(address target, bool frozen);
104     event Burn(address indexed from, uint256 value);
105 
106 
107     // ------------------------------------------------------------------------
108     // Constructor
109     // ------------------------------------------------------------------------
110     constructor() public {
111         symbol = "WINE";
112         name = "Winecoin";
113         decimals = 3;
114         _totalSupply = 250000000 * 10**uint(decimals);
115         balances[owner] = _totalSupply;
116         emit Transfer(address(0), owner, _totalSupply);
117     }
118 
119 
120     // ------------------------------------------------------------------------
121     // Total supply
122     // ------------------------------------------------------------------------
123     function totalSupply() public view returns (uint) {
124         return _totalSupply.sub(balances[address(0)]);
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Get the token balance for account `tokenOwner`
130     // ------------------------------------------------------------------------
131     function balanceOf(address tokenOwner) public view returns (uint balance) {
132         return balances[tokenOwner];
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Transfer the balance from token owner's account to `to` account
138     // - Owner's account must have sufficient balance to transfer
139     // - 0 value transfers are allowed
140     // ------------------------------------------------------------------------
141     function transfer(address to, uint tokens) public returns (bool success) {
142         if( frozenAccount[to] == false ){
143             balances[msg.sender] = balances[msg.sender].sub(tokens);
144             balances[to] = balances[to].add(tokens);
145             emit Transfer(msg.sender, to, tokens);
146             return true;
147         }else{
148             revert();
149         }
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Token owner can approve for `spender` to transferFrom(...) `tokens`
155     // from the token owner's account
156     //
157     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
158     // recommends that there are no checks for the approval double-spend attack
159     // as this should be implemented in user interfaces 
160     // ------------------------------------------------------------------------
161     function approve(address spender, uint tokens) public returns (bool success) {
162         allowed[msg.sender][spender] = tokens;
163         emit Approval(msg.sender, spender, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Transfer `tokens` from the `from` account to the `to` account
170     // 
171     // The calling account must already have sufficient tokens approve(...)-d
172     // for spending from the `from` account and
173     // - From account must have sufficient balance to transfer
174     // - Spender must have sufficient allowance to transfer
175     // - 0 value transfers are allowed
176     // ------------------------------------------------------------------------
177     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
178         balances[from] = balances[from].sub(tokens);
179         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
180         balances[to] = balances[to].add(tokens);
181         emit Transfer(from, to, tokens);
182         return true;
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Returns the amount of tokens approved by the owner that can be
188     // transferred to the spender's account
189     // ------------------------------------------------------------------------
190     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
191         return allowed[tokenOwner][spender];
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Don't accept ETH
197     // ------------------------------------------------------------------------
198     function () public payable {
199         revert();
200     }
201     
202     
203     /**
204      * Destroy tokens
205      *
206      * Remove `_value` tokens from the system irreversibly
207      *
208      * @param _value the amount of money to burn
209      */
210     function burn(uint256 _value) public returns (bool success) {
211         require(balances[msg.sender] >= _value);   // Check if the sender has enough
212         balances[msg.sender] -= _value;            // Subtract from the sender
213         _totalSupply -= _value;                      // Updates totalSupply
214         emit Burn(msg.sender, _value);
215         return true;
216     }
217     
218     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
219     /// @param target Address to be frozen
220     /// @param freeze either to freeze it or not
221     function freezeAccount(address target, bool freeze) onlyOwner public {
222         frozenAccount[target] = freeze;
223         emit FrozenFunds(target, freeze);
224     }
225 }