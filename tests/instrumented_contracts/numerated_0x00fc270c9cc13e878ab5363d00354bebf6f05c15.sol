1 pragma solidity ^0.5.9;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
6 // ----------------------------------------------------------------------------
7 contract ERC20Interface {
8     function totalSupply() public view returns (uint);
9     function balanceOf(address tokenOwner) public view returns (uint balance);
10     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 // ----------------------------------------------------------------------------
20 // Owned contract
21 // ----------------------------------------------------------------------------
22 contract Owned {
23     address public owner;
24     address public newOwner;
25 
26     event OwnershipTransferred(address indexed _from, address indexed _to);
27 
28     constructor() public {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address _newOwner) public onlyOwner {
38         newOwner = _newOwner;
39     }
40     function acceptOwnership() public {
41         require(msg.sender == newOwner);
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44         newOwner = address(0);
45     }
46 }
47 
48 // ----------------------------------------------------------------------------
49 // Safe maths
50 // ----------------------------------------------------------------------------
51 library SafeMath {
52     function add(uint a, uint b) internal pure returns (uint c) {
53         c = a + b;
54         require(c >= a);
55     }
56     function sub(uint a, uint b) internal pure returns (uint c) {
57         require(b <= a);
58         c = a - b;
59     }
60 }
61 
62 // ----------------------------------------------------------------------------
63 // ERC20 Token, with the addition of symbol, name and decimals and a
64 // fixed supply
65 // ----------------------------------------------------------------------------
66 contract VNXLU is ERC20Interface, Owned {
67     using SafeMath for uint;
68 
69     string private _symbol  = "VNXLU";
70     string private _name    = "VNX Exchange";
71     uint8 private _decimals = 18;
72 
73     uint private _totalSupply;
74 
75     mapping(address => uint) balances;
76     mapping(address => mapping(address => uint)) allowed;
77 
78     // ------------------------------------------------------------------------
79     // Constructor
80     // !!! initTotalTokens are in tokens, not in _totalSupply metrics
81     // ------------------------------------------------------------------------
82     constructor(uint initTotalTokens) public {
83         _totalSupply = initTotalTokens * 10**uint(_decimals);
84         balances[owner] = _totalSupply;
85         emit Transfer(address(0), owner, _totalSupply);
86     }
87 
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() public view returns (string memory) {
92         return _name;
93     }
94 
95     /**
96      * @dev Returns the symbol of the token, usually a shorter version of the
97      * name.
98      */
99     function symbol() public view returns (string memory) {
100         return _symbol;
101     }
102 
103     /**
104      * @dev Returns the number of decimals used to get its user representation.
105      * For example, if `decimals` equals `2`, a balance of `505` tokens should
106      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
107      *
108      * Tokens usually opt for a value of 18, imitating the relationship between
109      * Ether and Wei.
110      *
111      * > Note that this information is only used for _display_ purposes: it in
112      * no way affects any of the arithmetic of the contract, including
113      * `IERC20.balanceOf` and `IERC20.transfer`.
114      */
115     function decimals() public view returns (uint8) {
116         return _decimals;
117     }
118 
119     // ------------------------------------------------------------------------
120     // Total supply
121     // ------------------------------------------------------------------------
122     function totalSupply() public view returns (uint res) {
123         return _totalSupply.sub(balances[address(0)]);
124     }
125 
126     // ------------------------------------------------------------------------
127     // Get the token balance for account `tokenOwner`
128     // ------------------------------------------------------------------------
129     function balanceOf(address tokenOwner) public view returns (uint balance) {
130         return balances[tokenOwner];
131     }
132 
133     // ------------------------------------------------------------------------
134     // Transfer the balance from token owner's account to `to` account
135     // - Owner's account must have sufficient balance to transfer
136     // - 0 value transfers are allowed
137   	// ------------------------------------------------------------------------
138     function transfer(address to, uint tokens) public returns (bool success) {
139         balances[msg.sender] = balances[msg.sender].sub(tokens);
140         balances[to] = balances[to].add(tokens);
141         emit Transfer(msg.sender, to, tokens);
142         return true;
143     }
144 
145     // ------------------------------------------------------------------------
146     // Token owner can approve for `spender` to transferFrom(...) `tokens`
147     // from the token owner's account
148     //
149     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
150     // recommends that there are no checks for the approval double-spend attack
151     // as this should be implemented in user interfaces
152     // ------------------------------------------------------------------------
153     function approve(address spender, uint tokens) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         emit Approval(msg.sender, spender, tokens);
156         return true;
157     }
158 
159     // ------------------------------------------------------------------------
160     // Transfer `tokens` from the `from` account to the `to` account
161     //
162     // The calling account must already have sufficient tokens approve(...)-d
163     // for spending from the `from` account and
164     // - From account must have sufficient balance to transfer
165     // - Spender must have sufficient allowance to transfer
166     // - 0 value transfers are allowed
167     // ------------------------------------------------------------------------
168     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
169         balances[from] = balances[from].sub(tokens);
170         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
171         balances[to] = balances[to].add(tokens);
172         emit Transfer(from, to, tokens);
173         return true;
174     }
175 
176     // ------------------------------------------------------------------------
177     // Returns the amount of tokens approved by the owner that can be
178     // transferred to the spender's account
179     // ------------------------------------------------------------------------
180     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
181         return allowed[tokenOwner][spender];
182     }
183 
184     // ------------------------------------------------------------------------
185     // Don't accept ETH
186     // ------------------------------------------------------------------------
187     function () external payable {
188         revert();
189     }
190 
191     // ------------------------------------------------------------------------
192     // Owner can transfer out any accidentally sent ERC20 tokens
193     // ------------------------------------------------------------------------
194     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
195         return ERC20Interface(tokenAddress).transfer(owner, tokens);
196     }
197 
198 }