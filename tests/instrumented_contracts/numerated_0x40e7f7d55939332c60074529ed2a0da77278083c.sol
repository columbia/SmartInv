1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Symbol       : DGM
6 // Short Name   : Dgram Token
7 // Full Name    : Deutsche Gram Token
8 // Inital supply: 1,000,000.000000000000000000
9 // Decimals     : 18
10 // Description  : 100% Gold-backed Token
11 //
12 // ----------------------------------------------------------------------------
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
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 // ----------------------------------------------------------------------------
84 // ERC20 Token, with the addition of symbol, name and decimals and an
85 // initial fixed supply
86 // ----------------------------------------------------------------------------
87 contract TokenCore is ERC20Interface, Owned {
88     using SafeMath for uint;
89 
90     string public symbol;
91     string public  name;
92     uint8 public decimals;
93     uint public _totalSupply;
94 
95     mapping(address => uint) balances;
96     mapping(address => mapping(address => uint)) allowed;
97 
98     // ------------------------------------------------------------------------
99     // Total supply
100     // ------------------------------------------------------------------------
101     function totalSupply() public constant returns (uint) {
102         return _totalSupply  - balances[address(0)];
103     }
104 
105 
106     // ------------------------------------------------------------------------
107     // Get the token balance for account `tokenOwner`
108     // ------------------------------------------------------------------------
109     function balanceOf(address tokenOwner) public constant returns (uint balance) {
110         return balances[tokenOwner];
111     }
112 
113 
114     // ------------------------------------------------------------------------
115     // Transfer the balance from token owner's account to `to` account
116     // - Owner's account must have sufficient balance to transfer
117     // - 0 value transfers are allowed
118     // ------------------------------------------------------------------------
119     function transfer(address to, uint tokens) public returns (bool success) {
120         balances[msg.sender] = balances[msg.sender].sub(tokens);
121         balances[to] = balances[to].add(tokens);
122         emit Transfer(msg.sender, to, tokens);
123         return true;
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Token owner can approve for `spender` to transferFrom(...) `tokens`
129     // from the token owner's account
130     //
131     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
132     // recommends that there are no checks for the approval double-spend attack
133     // as this should be implemented in user interfaces 
134     // ------------------------------------------------------------------------
135     function approve(address spender, uint tokens) public returns (bool success) {
136         allowed[msg.sender][spender] = tokens;
137         emit Approval(msg.sender, spender, tokens);
138         return true;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Transfer `tokens` from the `from` account to the `to` account
144     // 
145     // The calling account must already have sufficient tokens approve(...)-d
146     // for spending from the `from` account and
147     // - From account must have sufficient balance to transfer
148     // - Spender must have sufficient allowance to transfer
149     // - 0 value transfers are allowed
150     // ------------------------------------------------------------------------
151     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
152         balances[from] = balances[from].sub(tokens);
153         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
154         balances[to] = balances[to].add(tokens);
155         emit Transfer(from, to, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Returns the amount of tokens approved by the owner that can be
162     // transferred to the spender's account
163     // ------------------------------------------------------------------------
164     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
165         return allowed[tokenOwner][spender];
166     }
167 
168     // ------------------------------------------------------------------------
169     // Don't accept ETH
170     // ------------------------------------------------------------------------
171     function () public payable {
172         revert();
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Owner can transfer out any accidentally sent ERC20 tokens
178     // ------------------------------------------------------------------------
179     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
180         return ERC20Interface(tokenAddress).transfer(owner, tokens);
181     }
182 }
183 
184 // ------------------------------------------------------------------------
185 // Combined MintableToken and CappedToken contracts with Batch Limit
186 // ------------------------------------------------------------------------
187 contract CappedMintableBurnableToken is TokenCore {
188   event Mint(address indexed to, uint256 amount);
189   event MintFinished();
190   event Burn(address indexed burner, uint256 value);
191   
192   bool public mintingFinished = false;
193   uint256 public cap;
194   uint256 public batchlimits;
195   
196   modifier canMint() {
197     require(!mintingFinished);
198     _;
199   }
200 
201   modifier hasMintPermission() {
202     require(msg.sender == owner);
203     _;
204   }
205 
206   // ------------------------------------------------------------------------
207   // Function to mint tokens within the cap limit
208   // @param _to The address that will receive the minted tokens.
209   // @param _amount The amount of tokens to mint.
210   // @return A boolean that indicates if the operation was successful.
211   // ------------------------------------------------------------------------
212   function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
213     require(_amount <= batchlimits);
214     require(_totalSupply.add(_amount) <= cap);
215     _totalSupply = _totalSupply.add(_amount);
216     balances[_to] = balances[_to].add(_amount);
217     emit Mint(_to, _amount);
218     emit Transfer(address(0), _to, _amount);
219     return true;
220   }
221 
222   // ------------------------------------------------------------------------
223   // @dev Function to stop minting new tokens.
224   // @return True if the operation was successful.
225   // ------------------------------------------------------------------------
226   function finishMinting() onlyOwner canMint public returns (bool) {
227     mintingFinished = true;
228     emit MintFinished();
229     return true;
230   }
231   
232   // ------------------------------------------------------------------------
233   // Burns a specific amount of tokens.
234   // ------------------------------------------------------------------------
235   function burn(uint256 _value) public {
236     _burn(msg.sender, _value);
237   }
238 
239   function _burn(address _who, uint256 _value) internal {
240     require(_value <= balances[_who]);
241     // no need to require value <= totalSupply, since that would imply the
242     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
243 
244     balances[_who] = balances[_who].sub(_value);
245     _totalSupply = _totalSupply.sub(_value);
246     emit Burn(_who, _value);
247     emit Transfer(_who, address(0), _value);
248   }  
249 }
250 
251 contract Dgram is CappedMintableBurnableToken {
252 
253     constructor() public {
254         symbol = "BGM";
255         name = "Dgram Token";
256         decimals = 18;
257         _totalSupply = 1000000 * 10**uint(decimals);
258         cap = 100000000 * 10**uint(decimals);
259         batchlimits = 1000000 * 10**uint(decimals);
260         balances[owner] = _totalSupply;
261         emit Transfer(address(0), owner, _totalSupply);
262     }    
263     
264 }