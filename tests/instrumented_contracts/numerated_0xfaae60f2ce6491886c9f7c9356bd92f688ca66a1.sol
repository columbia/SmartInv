1 pragma solidity ^0.4.24;
2 //Spielleys Profit Allocation Share Module
3 //In an effort to crowdfund myself to go fulltime dapp development,
4 //I hereby created this contract to sell +/- 90% of future games dev fees 
5 // Future P3D contract games made will have a P3D masternode setup for the uint
6 // builder. Dev fee will consist of 1% of P3D divs gained in those contracts.
7 // contract will mint shares/tokens as you buy them
8 // Shares connot be destroyed, only traded.
9 // use function buyshares to buy Shares
10 // use function fetchdivs to get divs outstanding
11 // read dividendsOwing(your addres) to see how many divs you have outstanding
12 // Thank you for playing Spielleys contract creations.
13 // speilley is not liable for any contract bugs known and unknown.
14 //
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 library SafeMath {
20     function add(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function sub(uint a, uint b) internal pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function mul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function div(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 // ----------------------------------------------------------------------------
39 // Owned contract
40 // ----------------------------------------------------------------------------
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     constructor() public {
48         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         newOwner = _newOwner;
58     }
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 // ----------------------------------------------------------------------------
67 // ERC Token Standard #20 Interface
68 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
69 // ----------------------------------------------------------------------------
70 contract ERC20Interface {
71     function totalSupply() public constant returns (uint);
72     function balanceOf(address tokenOwner) public constant returns (uint balance);
73     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
74     function transfer(address to, uint tokens) public returns (bool success);
75     function approve(address spender, uint tokens) public returns (bool success);
76     function transferFrom(address from, address to, uint tokens) public returns (bool success);
77 
78     event Transfer(address indexed from, address indexed to, uint tokens);
79     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
80 }
81 
82 
83 // ----------------------------------------------------------------------------
84 // Contract function to receive approval and execute function in one call
85 //
86 // Borrowed from MiniMeToken
87 // ----------------------------------------------------------------------------
88 contract ApproveAndCallFallBack {
89     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
90 }
91 
92 // ----------------------------------------------------------------------------
93 // ERC20 Token, with the addition of symbol, name and decimals and a
94 // fixed supply
95 // ----------------------------------------------------------------------------
96 contract FixedSupplyToken is ERC20Interface, Owned {
97     using SafeMath for uint;
98 
99     string public symbol;
100     string public  name;
101     uint8 public decimals;
102     uint _totalSupply;
103 
104     mapping(address => uint) balances;
105     mapping(address => mapping(address => uint)) allowed;
106 
107 
108     // ------------------------------------------------------------------------
109     // Constructor
110     // ------------------------------------------------------------------------
111     constructor() public {
112         symbol = "SPASM";
113         name = "Spielleys Profit Allocation Share Module";
114         decimals = 0;
115         _totalSupply = 1;
116         balances[owner] = _totalSupply;
117         emit Transfer(address(0),owner, _totalSupply);
118         
119     }
120 
121 
122     // ------------------------------------------------------------------------
123     // Total supply
124     // ------------------------------------------------------------------------
125     function totalSupply() public view returns (uint) {
126         return _totalSupply.sub(balances[address(0)]);
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Get the token balance for account `tokenOwner`
132     // ------------------------------------------------------------------------
133     function balanceOf(address tokenOwner) public view returns (uint balance) {
134         return balances[tokenOwner];
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Transfer the balance from token owner's account to `to` account
140     // - Owner's account must have sufficient balance to transfer
141     // - 0 value transfers are allowed
142     // ------------------------------------------------------------------------
143     function transfer(address to, uint tokens) updateAccount(to) updateAccount(msg.sender) public returns (bool success) {
144         balances[msg.sender] = balances[msg.sender].sub(tokens);
145         balances[to] = balances[to].add(tokens);
146         emit Transfer(msg.sender, to, tokens);
147         return true;
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Token owner can approve for `spender` to transferFrom(...) `tokens`
153     // from the token owner's account
154     //
155     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
156     // recommends that there are no checks for the approval double-spend attack
157     // as this should be implemented in user interfaces 
158     // ------------------------------------------------------------------------
159     function approve(address spender, uint tokens) public returns (bool success) {
160         allowed[msg.sender][spender] = tokens;
161         emit Approval(msg.sender, spender, tokens);
162         return true;
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Transfer `tokens` from the `from` account to the `to` account
168     // 
169     // The calling account must already have sufficient tokens approve(...)-d
170     // for spending from the `from` account and
171     // - From account must have sufficient balance to transfer
172     // - Spender must have sufficient allowance to transfer
173     // - 0 value transfers are allowed
174     // ------------------------------------------------------------------------
175     function transferFrom(address from, address to, uint tokens)updateAccount(to) updateAccount(from) public returns (bool success) {
176         balances[from] = balances[from].sub(tokens);
177         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
178         balances[to] = balances[to].add(tokens);
179         emit Transfer(from, to, tokens);
180         return true;
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Returns the amount of tokens approved by the owner that can be
186     // transferred to the spender's account
187     // ------------------------------------------------------------------------
188     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
189         return allowed[tokenOwner][spender];
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Token owner can approve for `spender` to transferFrom(...) `tokens`
195     // from the token owner's account. The `spender` contract function
196     // `receiveApproval(...)` is then executed
197     // ------------------------------------------------------------------------
198     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
199         allowed[msg.sender][spender] = tokens;
200         emit Approval(msg.sender, spender, tokens);
201         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
202         return true;
203     }
204 
205 
206 
207 
208 
209     // ------------------------------------------------------------------------
210     // Owner can transfer out any accidentally sent ERC20 tokens
211     // ------------------------------------------------------------------------
212     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
213         return ERC20Interface(tokenAddress).transfer(owner, tokens);
214     }
215 
216 // divfunctions
217 //divsection
218 uint256 public pointMultiplier = 10e18;
219 struct Account {
220   uint balance;
221   uint lastDividendPoints;
222 }
223 mapping(address=>Account) accounts;
224 uint public ethtotalSupply;
225 uint public totalDividendPoints;
226 uint public unclaimedDividends;
227 
228 function dividendsOwing(address account) public view returns(uint256) {
229   uint256 newDividendPoints = totalDividendPoints.sub(accounts[account].lastDividendPoints);
230   return (balances[account] * newDividendPoints) / pointMultiplier;
231 }
232 modifier updateAccount(address account) {
233   uint256 owing = dividendsOwing(account);
234   if(owing > 0) {
235     unclaimedDividends = unclaimedDividends.sub(owing);
236     
237     account.transfer(owing);
238   }
239   accounts[account].lastDividendPoints = totalDividendPoints;
240   _;
241 }
242 function () external payable{disburse();}
243 function fetchdivs() public updateAccount(msg.sender){}
244 function disburse() public  payable {
245     uint256 amount = msg.value;
246     
247   totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(_totalSupply));
248   //ethtotalSupply = ethtotalSupply.add(amount);
249  unclaimedDividends = unclaimedDividends.add(amount);
250 }
251 function buyshares() public updateAccount(msg.sender) updateAccount(owner)  payable{
252     uint256 amount = msg.value;
253     address sender = msg.sender;
254     uint256 sup = _totalSupply;//totalSupply
255     require(amount >= 10 finney);
256     uint256 size = amount.div( 10 finney);
257     balances[owner] = balances[owner].add(size);
258      emit Transfer(0,owner, size);
259     sup = sup.add(size);
260      size = amount.div( 1 finney);
261     balances[msg.sender] = balances[sender].add(size);
262     emit Transfer(0,sender, size);
263      _totalSupply =  sup.add(size);
264      owner.transfer(amount);
265 }
266 }