1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 //  MCAN Token contract
5 //
6 // Symbol      : MCAN
7 // Name        : MCAN Token
8 // Total supply: 5000000000
9 // Decimals    : 18
10 //
11 
12 
13 // -------------------------------------------`---------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 contract SafeMath {
17 
18     /**
19      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
20      */
21     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b <= a);
23         uint256 c = a - b;
24 
25         return c;
26     }
27 
28     /**
29      * @dev Adds two unsigned integers, reverts on overflow.
30      */
31     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a);
34 
35         return c;
36     }
37 
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44 // ----------------------------------------------------------------------------
45 contract IERC20 {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 
59 contract Ownable {
60     address public _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66      * account.
67      */
68     constructor () internal {
69         _owner = msg.sender;
70         emit OwnershipTransferred(address(0), _owner);
71     }
72 
73     /**
74      * @return the address of the owner.
75      */
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     /**
81      * @dev Throws if called by any account other than the owner.
82      */
83     modifier onlyOwner() {
84         require(isOwner());
85         _;
86     }
87 
88     /**
89      * @return true if `msg.sender` is the owner of the contract.
90      */
91     function isOwner() public view returns (bool) {
92         return msg.sender == _owner;
93     }
94 
95     /**
96      * @dev Allows the current owner to relinquish control of the contract.
97      * @notice Renouncing to ownership will leave the contract without an owner.
98      * It will not be possible to call the functions with the `onlyOwner`
99      * modifier anymore.
100      */
101     function renounceOwnership() public onlyOwner {
102         emit OwnershipTransferred(_owner, address(0));
103         _owner = address(0);
104     }
105 
106     /**
107      * @dev Allows the current owner to transfer control of the contract to a newOwner.
108      * @param newOwner The address to transfer ownership to.
109      */
110     function transferOwnership(address newOwner) public onlyOwner {
111         _transferOwnership(newOwner);
112     }
113 
114     /**
115      * @dev Transfers control of the contract to a newOwner.
116      * @param newOwner The address to transfer ownership to.
117      */
118     function _transferOwnership(address newOwner) internal {
119         require(newOwner != address(0));
120         emit OwnershipTransferred(_owner, newOwner);
121         _owner = newOwner;
122     }
123 }
124 
125 // ----------------------------------------------------------------------------
126 // ERC20 Token, with the addition of symbol, name and decimals and assisted
127 // token transfers
128 // ----------------------------------------------------------------------------
129 contract MCAN_Token is IERC20, Ownable, SafeMath {
130     string public symbol;
131     string public  name;
132     uint public decimals;
133     uint public _totalSupply;
134 
135     mapping(address => uint) balances;
136     mapping(address => mapping(address => uint)) allowed;
137     
138    
139     constructor() public{
140         symbol = 'MCAN';
141         name = 'MCAN_Token';
142         decimals = 18;
143         _totalSupply = 5000000000000000000000000000;
144         balances[_owner] = _totalSupply;
145     }
146 
147     // ------------------------------------------------------------------------
148     // Total supply
149     // ------------------------------------------------------------------------
150     function totalSupply() public constant returns (uint) {
151         return _totalSupply  - balances[address(0)];
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Get the token balance for account tokenOwner
157     // ------------------------------------------------------------------------
158     function balanceOf(address tokenOwner) public constant returns (uint balance) {
159         return balances[tokenOwner];
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Transfer the balance from token owner's account to to account
165     // - Owner's account must have sufficient balance to transfer
166     // - 0 value transfers are allowed
167     // ------------------------------------------------------------------------
168     function transfer(address to, uint tokens) public returns (bool success) {
169         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
170         balances[to] = safeAdd(balances[to], tokens);
171         emit Transfer(msg.sender, to, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Token owner can approve for spender to transferFrom(...) tokens
178     // from the token owner's account
179     //
180     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
181     // recommends that there are no checks for the approval double-spend attack
182     // as this should be implemented in user interfaces 
183     // ------------------------------------------------------------------------
184     function approve(address spender, uint tokens) public returns (bool success) {
185         allowed[msg.sender][spender] = tokens;
186         emit Approval(msg.sender, spender, tokens);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Transfer tokens from the from account to the to account
193     // 
194     // The calling account must already have sufficient tokens approve(...)-d
195     // for spending from the from account and
196     // - From account must have sufficient balance to transfer
197     // - Spender must have sufficient allowance to transfer
198     // - 0 value transfers are allowed
199     // ------------------------------------------------------------------------
200     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
201         balances[from] = safeSub(balances[from], tokens);
202         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
203         balances[to] = safeAdd(balances[to], tokens);
204         emit Transfer(from, to, tokens);
205         return true;
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Returns the amount of tokens approved by the owner that can be
211     // transferred to the spender's account
212     // ------------------------------------------------------------------------
213     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
214         return allowed[tokenOwner][spender];
215     }
216 
217     function _burn(address account, uint256 value) internal {
218         require(account != address(0));
219 
220         _totalSupply = safeSub(_totalSupply,value);
221         balances[account] = safeSub(balances[account],value);
222         emit Transfer(account, address(0), value);
223     }
224     
225     
226     function burn(uint256 value) public onlyOwner {
227         _burn(msg.sender, value);
228     }
229     
230 
231     // ------------------------------------------------------------------------
232     // Don't accept ETH
233     // ------------------------------------------------------------------------
234     function () public payable {
235         revert();
236     }
237     
238     // ------------------------------------------------------------------------
239     // Owner can transfer out any accidentally sent ERC20 tokens
240     // ------------------------------------------------------------------------
241     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
242         return IERC20(tokenAddress).transfer(owner(), tokens);
243     }
244 
245 }