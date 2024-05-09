1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Product ABBC Foundation
5 //
6 // Symbol      : ABCH 
7 // Name        : ABBC Cash (ABCH)
8 // Total supply: 100,000,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 library SafeMath {
16     function add(uint a, uint b) internal pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function sub(uint a, uint b) internal pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function mul(uint a, uint b) internal pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function div(uint a, uint b) internal pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 contract ERC20Interface {
35     function totalSupply() public constant returns (uint);
36     function balanceOf(address tokenOwner) public constant returns (uint balance);
37     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 contract ApproveAndCallFallBack {
47     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
48 }   
49 
50 
51 contract Owned {
52     address public owner;
53     address public newOwner;
54 
55     event OwnershipTransferred(address indexed _from, address indexed _to);
56 
57     constructor() public {
58         owner = msg.sender;
59     }
60 
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function transferOwnership(address _newOwner) public onlyOwner {
67         newOwner = _newOwner;
68     }
69     function acceptOwnership() public {
70         require(msg.sender == newOwner);
71         emit OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73         newOwner = address(0);
74     }
75 }
76 
77 contract ABBCCashToken is ERC20Interface, Owned {
78     using SafeMath for uint;
79 
80     string public symbol;
81     string public  name;
82     uint8 public decimals;
83     uint _totalSupply;
84 
85     mapping(address => uint) balances;
86     mapping(address => mapping(address => uint)) allowed;
87 
88 
89     // ------------------------------------------------------------------------
90     // Constructor
91     // ------------------------------------------------------------------------
92     constructor() public {
93         symbol = "ABCH";
94         name = "ABBC Cash(ABCH)";
95         decimals = 18;
96         _totalSupply = 100000000000 * 10**uint(decimals);
97         balances[owner] = _totalSupply;
98         emit Transfer(address(0), owner, _totalSupply);
99     }
100 
101 
102     // ------------------------------------------------------------------------
103     // Total supply
104     // ------------------------------------------------------------------------
105     function totalSupply() public view returns (uint) {
106         return _totalSupply.sub(balances[address(0)]);
107     }
108 
109 
110     // ------------------------------------------------------------------------
111     // Get the token balance for account `tokenOwner`
112     // ------------------------------------------------------------------------
113     function balanceOf(address tokenOwner) public view returns (uint balance) {
114         return balances[tokenOwner];
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Transfer the balance from token owner's account to `to` account
120     // - Owner's account must have sufficient balance to transfer
121     // - 0 value transfers are allowed
122     // ------------------------------------------------------------------------
123     function transfer(address to, uint tokens) public returns (bool success) {
124           if (tokens > 0 && 
125             tokens <= balances[msg.sender] &&
126             !isContract(to))
127              {
128                 balances[msg.sender] = balances[msg.sender].sub(tokens);
129                 balances[to] = balances[to].add(tokens);
130                 emit Transfer(msg.sender, to, tokens);
131                 return true;
132             }
133             return false;
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Token owner can approve for `spender` to transferFrom(...) `tokens`
139     // from the token owner's account
140 
141     // ------------------------------------------------------------------------
142     function approve(address spender, uint tokens) public returns (bool success) {
143         allowed[msg.sender][spender] = tokens;
144         emit Approval(msg.sender, spender, tokens);
145         return true;
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
159         balances[from] = balances[from].sub(tokens);
160         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
161         balances[to] = balances[to].add(tokens);
162         emit Transfer(from, to, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Returns the amount of tokens approved by the owner that can be
169     // transferred to the spender's account
170     // ------------------------------------------------------------------------
171     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
172         return allowed[tokenOwner][spender];
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Token owner can approve for `spender` to transferFrom(...) `tokens`
178     // from the token owner's account. The `spender` contract function
179     // `receiveApproval(...)` is then executed
180     // ------------------------------------------------------------------------
181     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
182         allowed[msg.sender][spender] = tokens;
183         emit Approval(msg.sender, spender, tokens);
184         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
185         return true;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Don't accept ETH
191     // ------------------------------------------------------------------------
192     function () public payable {
193         revert();
194     }
195 
196 
197         /**
198      * @dev Increase the amount of tokens that an owner allowed to a spender.
199      *
200      * approve should be called when allowed[_spender] == 0. To increment
201      * allowed value is better to use this function to avoid 2 calls (and wait until
202      * the first transaction is mined)
203      * @param _spender The address which will spend the funds.
204      * @param _addedValue The amount of tokens to increase the allowance by.
205      **/
206     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
207         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209         return true;
210     }
211     
212     /**
213      * @dev Decrease the amount of tokens that an owner allowed to a spender.
214      *
215      * approve should be called when allowed[_spender] == 0. To decrement
216      * allowed value is better to use this function to avoid 2 calls (and wait until
217      * the first transaction is mined)
218      * From MonolithDAO Token.sol
219      * @param _spender The address which will spend the funds.
220      * @param _subtractedValue The amount of tokens to decrease the allowance by.
221      **/
222     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
223         uint oldValue = allowed[msg.sender][_spender];
224         if (_subtractedValue > oldValue) {
225             allowed[msg.sender][_spender] = 0;
226         } else {
227             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
228         }
229         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233 
234 
235     // ------------------------------------------------------------------------
236     // Owner can transfer out any accidentally sent ERC20 tokens
237     // ------------------------------------------------------------------------
238     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
239         return ERC20Interface(tokenAddress).transfer(owner, tokens);
240     }
241 
242       function isContract(address _addr) public view returns (bool) {
243         uint codeSize;
244         assembly {
245             codeSize := extcodesize(_addr)
246         }
247         return codeSize > 0;
248     }
249 }