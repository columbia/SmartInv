1 pragma solidity ^0.4.19;
2 
3 //safeMath Library for Arithmetic operations
4 contract SafeMath {
5     function safeAdd(uint a, uint b) public pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) public pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) public pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) public pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 // ----------------------------------------------------------------------------
24 // ERC Token Standard #20 Interface
25 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
26 // ----------------------------------------------------------------------------
27 contract ERC20Interface {
28     function totalSupply() public constant returns (uint);
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // Owned contract
42 // ----------------------------------------------------------------------------
43 contract Owned {
44     address public owner;
45     address public newOwner;
46 
47     event OwnershipTransferred(address indexed _from, address indexed _to);
48 
49     constructor () public {
50         owner = msg.sender;
51     }
52 
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         newOwner = _newOwner;
60     }
61     
62     function acceptOwnership() public {
63         require(msg.sender == newOwner);
64         emit OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66         newOwner = address(0);
67     }
68 }
69 
70 // ----------------------------------------------------------------------------
71 // Contract function to receive approval and execute function in one call
72 // Borrowed from MiniMeToken
73 // ----------------------------------------------------------------------------
74 
75 contract ApproveAndCallFallBack {
76     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
77 }
78 
79 
80 contract LCXCoin is ERC20Interface, Owned, SafeMath {
81     string public symbol;
82     string public  name;
83     uint256 public decimals;
84     uint256 public _totalSupply;
85     uint256 public burnt;
86     address public charityFund = 0x1F53b1E1E9771A38eDA9d144eF4877341e47CF51;
87     address public bountyFund = 0xfF311F52ddCC4E9Ba94d2559975efE3eb1Ea3bc6;
88     address public tradingFund = 0xf609127b10DaB6e53B7c489899B265c46Cee1E9d;
89     
90     mapping(address => uint) balances;
91     mapping(address => mapping(address => uint)) allowed;
92     
93     mapping (address => bool) public frozenAccount;
94     
95     
96     event FrozenFunds(address target, bool frozen); // notifies clients about the fund frozen
97     event Burn(address indexed burner, uint256 value);
98     event Burnfrom(address indexed _from, uint256 value);
99   
100     // Constructor
101     constructor () public {
102         symbol = "LCX";
103         name = "London Crypto Exchange";
104         decimals = 18;
105         _totalSupply = 113000000 * 10 ** uint(decimals);    //totalSupply = initialSupply * 10 ** uint(decimals);
106         balances[charityFund] = safeAdd(balances[charityFund], 13000000 * (10 ** decimals)); // 13M to charityFund
107         emit Transfer(address(0), charityFund, 13000000 * (10 ** decimals));     // Event for token transfer
108         balances[bountyFund] = safeAdd(balances[bountyFund], 25000000 * (10 ** decimals)); // 25M to bountyFund
109         emit Transfer(address(0), bountyFund, 25000000 * (10 ** decimals));     // Event for token transfer
110         balances[tradingFund] = safeAdd(balances[tradingFund], 75000000 * (10 ** decimals)); // 75M to tradingFund
111         emit Transfer(address(0), tradingFund, 75000000 * (10 ** decimals));     // Event for token transfer
112     }
113 
114     // Total supply
115     function totalSupply() public view returns (uint) {
116         return _totalSupply;
117     }
118 
119     // Get the token balance for account tokenOwner
120     function balanceOf(address tokenOwner) public view returns (uint balance) {
121         return balances[tokenOwner];
122     }
123 
124     // Internal transfer, only can be called by this contract 
125     function _transfer(address _from, address _to, uint _value) internal {
126         require (_to != 0x0);                               			// Prevent transfer to 0x0 address.
127         require (balances[_from] >= _value);               			    // Check if the sender has enough balance
128         require (balances[_to] + _value > balances[_to]); 			    // Check for overflows
129         require(!frozenAccount[_from]);                     			// Check if sender is frozen
130         require(!frozenAccount[_to]);                       			// Check if recipient is frozen
131         uint previousBalances = balances[_from] + balances[_to];		// Save this for an assertion in the future
132         balances[_from] = safeSub(balances[_from],_value);    			// Subtract from the sender
133         balances[_to] = safeAdd(balances[_to],_value);        			// Add the same to the recipient
134         emit Transfer(_from, _to, _value);									// raise Event
135         assert(balances[_from] + balances[_to] == previousBalances); 
136     }
137     
138    
139     // Transfer the balance from token owner's account to user account
140 
141     function transfer(address to, uint tokens) public returns (bool success) {
142         _transfer(msg.sender, to, tokens);
143         return true;
144     }
145 
146     // Transfer tokens from the from account to the to account
147   
148     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
149         
150         require(tokens <= allowed[from][msg.sender]); 
151         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens); 
152         _transfer(from, to, tokens);
153         return true;
154     }
155     
156     /*
157      * Set allowance for other address
158      *
159      * Allows `spender` to spend no more than `_value` tokens in your behalf
160      * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
161      * recommends that there are no checks for the approval double-spend attack
162      * as this should be implemented in user interfaces 
163 
164      */
165      
166     function approve(address spender, uint tokens) public returns (bool success) {
167         // To change the approve amount you first have to reduce the addresses`
168         //  allowance to zero by calling `approve(_spender,0)` if it is not
169         //  already 0 to mitigate the race condition described here:
170         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171         require((tokens == 0) || (allowed[msg.sender][spender] == 0));
172         
173         allowed[msg.sender][spender] = tokens; // allow tokens to spender
174         emit Approval(msg.sender, spender, tokens); // raise Approval Event
175         return true;
176     }
177 
178     // Get the amount of tokens approved by the owner that can be transferred to the spender's account
179 
180     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
181         return allowed[tokenOwner][spender];
182     }
183 
184     // ------------------------------------------------------------------------
185     // Token owner can approve for spender to transferFrom(...) tokens
186     // from the token owner's account. The spender contract function
187     // receiveApproval(...) is then executed
188     ///* Allow another contract to spend some tokens in your behalf */
189     // ------------------------------------------------------------------------
190     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
191         //allowed[msg.sender][spender] = tokens;
192         //Approval(msg.sender, spender, tokens);
193         
194         require(approve(spender, tokens)); // approve function to be called first
195         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
196         return true;
197     }
198 
199     // ------------------------------------------------------------------------
200     // Don't accept ETH
201     // ------------------------------------------------------------------------
202     function () public payable {
203         revert();
204     }
205 
206     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
207 
208     function freezeAccount(address target, bool freeze) onlyOwner public {
209         frozenAccount[target] = freeze;
210         emit FrozenFunds(target, freeze);
211     }
212     
213     function burn(uint256 _value) public {
214         require(_value <= balances[msg.sender]);
215         address burner = msg.sender;
216         balances[burner] = safeSub(balances[burner],_value);
217         _totalSupply = safeSub(_totalSupply,_value);
218         burnt = safeAdd(burnt,_value);
219         emit Burn(burner, _value);
220         emit Transfer(burner, address(0), _value);
221     }
222   
223     function burnFrom(address _from, uint256 _value) public onlyOwner returns  (bool success) {
224         require (balances[_from] >= _value);            
225         require (msg.sender == owner);   
226         _totalSupply = safeSub(_totalSupply,_value);
227         burnt = safeAdd(burnt,_value);
228         balances[_from] = safeSub(balances[_from],_value);                      
229         emit Burnfrom(_from, _value);
230         return true;
231     }
232 
233     // ------------------------------------------------------------------------
234     // Owner can take back  any accidentally sent ERC20 tokens from any address
235     // ------------------------------------------------------------------------
236     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
237         return ERC20Interface(tokenAddress).transfer(owner, tokens);
238     }
239 }