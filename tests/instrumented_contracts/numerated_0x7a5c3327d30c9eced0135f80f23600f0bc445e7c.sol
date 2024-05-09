1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // OWNI Token contract
5 //
6 // Symbol      : OWNI
7 // Name        : OWNI Token
8 // Total supply: 2000000000
9 // Decimals    : 10
10 //
11 
12 
13 // ----------------------------------------------------------------------------
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
60     address private _owner;
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
129 contract OWNI_Contract is IERC20, Ownable, SafeMath {
130     string public symbol;
131     string public  name;
132     uint public decimals;
133     uint public _totalSupply;
134 
135     mapping(address => uint) balances;
136     mapping(address => mapping(address => uint)) allowed;
137 
138 
139     // ------------------------------------------------------------------------
140     // Constructor
141     // ------------------------------------------------------------------------
142     constructor(string _symbol,string _name,uint _decimals,uint totalSupply) public {
143        symbol = _symbol;
144        name = _name;
145        decimals = _decimals;
146        _totalSupply = totalSupply * 10 ** decimals;
147        balances[msg.sender] = _totalSupply;
148        emit Transfer(address(0), msg.sender, _totalSupply);
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Total supply
154     // ------------------------------------------------------------------------
155     function totalSupply() public constant returns (uint) {
156         return _totalSupply  - balances[address(0)];
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Get the token balance for account tokenOwner
162     // ------------------------------------------------------------------------
163     function balanceOf(address tokenOwner) public constant returns (uint balance) {
164         return balances[tokenOwner];
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Transfer the balance from token owner's account to to account
170     // - Owner's account must have sufficient balance to transfer
171     // - 0 value transfers are allowed
172     // ------------------------------------------------------------------------
173     function transfer(address to, uint tokens) public returns (bool success) {
174         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
175         balances[to] = safeAdd(balances[to], tokens);
176         emit Transfer(msg.sender, to, tokens);
177         return true;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Token owner can approve for spender to transferFrom(...) tokens
183     // from the token owner's account
184     //
185     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
186     // recommends that there are no checks for the approval double-spend attack
187     // as this should be implemented in user interfaces 
188     // ------------------------------------------------------------------------
189     function approve(address spender, uint tokens) public returns (bool success) {
190         allowed[msg.sender][spender] = tokens;
191         emit Approval(msg.sender, spender, tokens);
192         return true;
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Transfer tokens from the from account to the to account
198     // 
199     // The calling account must already have sufficient tokens approve(...)-d
200     // for spending from the from account and
201     // - From account must have sufficient balance to transfer
202     // - Spender must have sufficient allowance to transfer
203     // - 0 value transfers are allowed
204     // ------------------------------------------------------------------------
205     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
206         balances[from] = safeSub(balances[from], tokens);
207         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
208         balances[to] = safeAdd(balances[to], tokens);
209         emit Transfer(from, to, tokens);
210         return true;
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Returns the amount of tokens approved by the owner that can be
216     // transferred to the spender's account
217     // ------------------------------------------------------------------------
218     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
219         return allowed[tokenOwner][spender];
220     }
221 
222 
223     // ------------------------------------------------------------------------
224     // Don't accept ETH
225     // ------------------------------------------------------------------------
226     function () public payable {
227         revert();
228     }
229     
230     // ------------------------------------------------------------------------
231     // Owner can transfer out any accidentally sent ERC20 tokens
232     // ------------------------------------------------------------------------
233     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
234         return IERC20(tokenAddress).transfer(owner(), tokens);
235     }
236 
237 }