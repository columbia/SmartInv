1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'AGRI' - AgriChain Utility Token Contract
5 //
6 // Symbol      : AGRI
7 // Name        : AgriChain Utility Token
8 // Total supply: 1,000,000,000.000000000000000000 (1 billion)
9 // Decimals    : 18
10 //
11 // Author      : Martin Halford
12 // Company     : AgriChain Pty Ltd 
13 // Version     : 1.0
14 // Published   : 29 June 2018
15 //
16 // ----------------------------------------------------------------------------
17 
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
22 library SafeMath {
23     function add(uint a, uint b) internal pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27     function sub(uint a, uint b) internal pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31     function mul(uint a, uint b) internal pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35     function div(uint a, uint b) internal pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 // ERC Token Standard #20 Interface
44 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
45 // ----------------------------------------------------------------------------
46 contract ERC20Interface {
47     function totalSupply() public view returns (uint);
48     function balanceOf(address tokenOwner) public view returns (uint balance);
49     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
50     function transfer(address to, uint tokens) public returns (bool success);
51     function approve(address spender, uint tokens) public returns (bool success);
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Contract function to receive approval and execute function in one call
61 //
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     constructor() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         emit OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // Agri Token, with the addition of symbol, name and decimals and a
100 // fixed supply
101 // ----------------------------------------------------------------------------
102 contract AgriToken is ERC20Interface, Owned {
103     using SafeMath for uint;
104 
105     string public symbol;
106     string public  name;
107     uint8 public decimals;
108     uint _totalSupply;
109 
110     mapping(address => uint) balances;
111     mapping(address => mapping(address => uint)) allowed;
112 
113     // This notifies clients about the amount burnt , only owner is able to burn tokens
114     event Burn(address from, uint256 value); 
115 
116     // ------------------------------------------------------------------------
117     // Constructor
118     // ------------------------------------------------------------------------
119     constructor() public {
120         symbol = "AGRI";
121         name = "AgriChain Utility Token";
122         decimals = 18;
123         _totalSupply = 1000000000 * 10**uint(decimals);
124         balances[owner] = _totalSupply;
125         emit Transfer(address(0), owner, _totalSupply);
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Total supply
131     // ------------------------------------------------------------------------
132     function totalSupply() public view returns (uint) {
133         return _totalSupply.sub(balances[address(0)]);
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Get the token balance for account `tokenOwner`
139     // ------------------------------------------------------------------------
140     function balanceOf(address tokenOwner) public view returns (uint balance) {
141         return balances[tokenOwner];
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Transfer the balance from token owner's account to `to` account
147     // - Owner's account must have sufficient balance to transfer
148     // - 0 value transfers are allowed
149     // ------------------------------------------------------------------------
150     function transfer(address to, uint tokens) public returns (bool success) {
151         balances[msg.sender] = balances[msg.sender].sub(tokens);
152         balances[to] = balances[to].add(tokens);
153         emit Transfer(msg.sender, to, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Token owner can approve for `spender` to transferFrom(...) `tokens`
160     // from the token owner's account
161     //
162     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
163     // recommends that there are no checks for the approval double-spend attack
164     // as this should be implemented in user interfaces 
165     // ------------------------------------------------------------------------
166     function approve(address spender, uint tokens) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         emit Approval(msg.sender, spender, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Transfer `tokens` from the `from` account to the `to` account
175     // 
176     // The calling account must already have sufficient tokens approve(...)-d
177     // for spending from the `from` account and
178     // - From account must have sufficient balance to transfer
179     // - Spender must have sufficient allowance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
183         balances[from] = balances[from].sub(tokens);
184         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
185         balances[to] = balances[to].add(tokens);
186         emit Transfer(from, to, tokens);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Returns the amount of tokens approved by the owner that can be
193     // transferred to the spender's account
194     // ------------------------------------------------------------------------
195     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
196         return allowed[tokenOwner][spender];
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Token owner can approve for `spender` to transferFrom(...) `tokens`
202     // from the token owner's account. The `spender` contract function
203     // `receiveApproval(...)` is then executed
204     // ------------------------------------------------------------------------
205     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
206         allowed[msg.sender][spender] = tokens;
207         emit Approval(msg.sender, spender, tokens);
208         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
209         return true;
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Don't accept ETH
215     // ------------------------------------------------------------------------
216     function () public payable {
217         revert();
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // Owner can transfer out any accidentally sent ERC20 tokens
223     // ------------------------------------------------------------------------
224     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
225         return ERC20Interface(tokenAddress).transfer(owner, tokens);
226     }
227 
228     // ------------------------------------------------------------------------
229     // Owner can mint additional tokens
230     // ------------------------------------------------------------------------
231     function mintTokens(uint256 _mintedAmount) public onlyOwner {
232         balances[owner] = balances[owner].add(_mintedAmount);
233         _totalSupply = _totalSupply.add(_mintedAmount);
234         emit Transfer(0, owner, _mintedAmount);      
235     }    
236 
237     // ------------------------------------------------------------------------
238     // Owner can burn tokens
239     // ------------------------------------------------------------------------
240     function burn(uint256 _value) public onlyOwner {
241         require(_value <= balances[msg.sender]);
242         address burner = msg.sender;
243         balances[burner] = balances[burner].sub(_value);
244         _totalSupply = _totalSupply.sub(_value);
245         emit Burn(burner, _value);
246     }
247 }