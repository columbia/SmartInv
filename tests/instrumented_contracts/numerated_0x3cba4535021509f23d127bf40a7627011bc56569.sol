1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, March 28, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.25;
6 
7 // ----------------------------------------------------------------------------
8 //  MCAN Token contract
9 //
10 // Symbol      : MCAN
11 // Name        : MCAN Token
12 // Total supply: 5000000000
13 // Decimals    : 18
14 //
15 
16 
17 // -------------------------------------------`---------------------------------
18 // Safe maths
19 // -----------------------------------------------------------------------------
20 contract SafeMath {
21 
22     /**
23      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
24      */
25     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b <= a);
27         uint256 c = a - b;
28 
29         return c;
30     }
31 
32     /**
33      * @dev Adds two unsigned integers, reverts on overflow.
34      */
35     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a);
38         return c;
39     }
40 
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // ERC Token Standard #20 Interface
46 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
47 // ----------------------------------------------------------------------------
48 contract IERC20 {
49     function totalSupply() public constant returns (uint);
50     function balanceOf(address tokenOwner) public constant returns (uint balance);
51     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
52     function transfer(address to, uint tokens) public returns (bool success);
53     function approve(address spender, uint tokens) public returns (bool success);
54     function transferFrom(address from, address to, uint tokens) public returns (bool success);
55 
56     event Transfer(address indexed from, address indexed to, uint tokens);
57     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58 }
59 
60 
61 
62 contract Ownable {
63     address public _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69      * account.
70      */
71     constructor () internal {
72         _owner = msg.sender;
73         emit OwnershipTransferred(address(0), _owner);
74     }
75 
76     /**
77      * @return the address of the owner.
78      */
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if called by any account other than the owner.
85      */
86     modifier onlyOwner() {
87         require(isOwner());
88         _;
89     }
90 
91     /**
92      * @return true if `msg.sender` is the owner of the contract.
93      */
94     function isOwner() public view returns (bool) {
95         return msg.sender == _owner;
96     }
97 
98     /**
99      * @dev Allows the current owner to relinquish control of the contract.
100      * @notice Renouncing to ownership will leave the contract without an owner.
101      * It will not be possible to call the functions with the `onlyOwner`
102      * modifier anymore.
103      */
104     function renounceOwnership() public onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = address(0);
107     }
108 
109     /**
110      * @dev Allows the current owner to transfer control of the contract to a newOwner.
111      * @param newOwner The address to transfer ownership to.
112      */
113     function transferOwnership(address newOwner) public onlyOwner {
114         _transferOwnership(newOwner);
115     }
116 
117     /**
118      * @dev Transfers control of the contract to a newOwner.
119      * @param newOwner The address to transfer ownership to.
120      */
121     function _transferOwnership(address newOwner) internal {
122         require(newOwner != address(0));
123         emit OwnershipTransferred(_owner, newOwner);
124         _owner = newOwner;
125     }
126 }
127 
128 // ----------------------------------------------------------------------------
129 // ERC20 Token, with the addition of symbol, name and decimals and assisted
130 // token transfers
131 // ----------------------------------------------------------------------------
132 contract MCAN_Token is IERC20, Ownable, SafeMath {
133     string public symbol;
134     string public  name;
135     uint public decimals;
136     uint public _totalSupply;
137 
138     mapping(address => uint) balances;
139     mapping(address => mapping(address => uint)) allowed;
140    
141     constructor() public{
142         symbol = 'MCAN';
143         name = 'MCAN_Token';
144         decimals = 18;
145         _totalSupply = 5000000000000000000000000000;
146         balances[_owner] = _totalSupply;
147     }
148 
149     // ------------------------------------------------------------------------
150     // Total supply
151     // ------------------------------------------------------------------------
152     function totalSupply() public constant returns (uint) {
153         return _totalSupply  - balances[address(0)];
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Get the token balance for account tokenOwner
159     // ------------------------------------------------------------------------
160     function balanceOf(address tokenOwner) public constant returns (uint balance) {
161         return balances[tokenOwner];
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Transfer the balance from token owner's account to to account
167     // - Owner's account must have sufficient balance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transfer(address to, uint tokens) public returns (bool success) {
171         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
172         balances[to] = safeAdd(balances[to], tokens);
173         emit Transfer(msg.sender, to, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Token owner can approve for spender to transferFrom(...) tokens
180     // from the token owner's account
181     //
182     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
183     // recommends that there are no checks for the approval double-spend attack
184     // as this should be implemented in user interfaces 
185     // ------------------------------------------------------------------------
186     function approve(address spender, uint tokens) public returns (bool success) {
187         allowed[msg.sender][spender] = tokens;
188         emit Approval(msg.sender, spender, tokens);
189         return true;
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Transfer tokens from the from account to the to account
195     // 
196     // The calling account must already have sufficient tokens approve(...)-d
197     // for spending from the from account and
198     // - From account must have sufficient balance to transfer
199     // - Spender must have sufficient allowance to transfer
200     // - 0 value transfers are allowed
201     // ------------------------------------------------------------------------
202     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
203         balances[from] = safeSub(balances[from], tokens);
204         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
205         balances[to] = safeAdd(balances[to], tokens);
206         emit Transfer(from, to, tokens);
207         return true;
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Returns the amount of tokens approved by the owner that can be
213     // transferred to the spender's account
214     // ------------------------------------------------------------------------
215     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
216         return allowed[tokenOwner][spender];
217     }
218 
219     function burn(address account, uint256 value) public onlyOwner {
220         require(account != address(0));
221 
222         _totalSupply = safeSub(_totalSupply,value);
223         balances[account] = safeSub(balances[account],value);
224     }
225     
226 	function mint(uint256 value) public onlyOwner {
227         _totalSupply = safeAdd(_totalSupply,value);
228         balances[msg.sender] = safeAdd(balances[msg.sender],value);
229     }
230     
231 
232     // ------------------------------------------------------------------------
233     // Don't accept ETH
234     // ------------------------------------------------------------------------
235     function () public payable {
236         revert();
237     }
238     
239     // ------------------------------------------------------------------------
240     // Owner can transfer out any accidentally sent ERC20 tokens
241     // ------------------------------------------------------------------------
242     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
243         return IERC20(tokenAddress).transfer(owner(), tokens);
244     }
245 
246 }