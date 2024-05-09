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
49     function Owned() public {
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
80 contract DanatCoin is ERC20Interface, Owned, SafeMath {
81     string public symbol;
82     string public  name;
83     uint8 public decimals;
84     uint public _totalSupply;
85     
86     uint lastBlock;
87     uint circulatedTokens = 0;
88     uint _rewardedTokens = 0;
89     uint _rewardTokenValue = 5;
90     
91     mapping(address => uint) balances;
92     mapping(address => mapping(address => uint)) allowed;
93     
94     mapping (address => bool) public frozenAccount;
95     
96     
97     event FrozenFunds(address target, bool frozen); // notifies clients about the fund frozen
98   
99     // Constructor
100     function DanatCoin() public {
101         symbol = "DNC";
102         name = "Danat Coin";
103         decimals = 18;
104         _totalSupply = 100000000 * 10 ** uint(decimals);    //totalSupply = initialSupply * 10 ** uint(decimals);
105         balances[msg.sender] = _totalSupply;                // Give the creator all initial tokens
106         emit Transfer(address(0), msg.sender, _totalSupply);     // Event for token transfer
107     }
108 
109     // Total supply
110     function totalSupply() public constant returns (uint) {
111         return _totalSupply;
112     }
113 
114     // Get the token balance for account tokenOwner
115     function balanceOf(address tokenOwner) public constant returns (uint balance) {
116         return balances[tokenOwner];
117     }
118 
119     // Internal transfer, only can be called by this contract 
120     function _transfer(address _from, address _to, uint _value) internal {
121         require (_to != 0x0);                               			// Prevent transfer to 0x0 address.
122         require (balances[_from] >= _value);               			    // Check if the sender has enough balance
123         require (balances[_to] + _value > balances[_to]); 			    // Check for overflows
124         require(!frozenAccount[_from]);                     			// Check if sender is frozen
125         require(!frozenAccount[_to]);                       			// Check if recipient is frozen
126         uint previousBalances = balances[_from] + balances[_to];		// Save this for an assertion in the future
127 		balances[_from] = safeSub(balances[_from],_value);    			// Subtract from the sender
128         balances[_to] = safeAdd(balances[_to],_value);        			// Add the same to the recipient
129         emit Transfer(_from, _to, _value);									// raise Event
130 		assert(balances[_from] + balances[_to] == previousBalances);    // Asserts are used to use static analysis to find bugs in your code. They should never fail
131     }
132     
133    
134     // Transfer the balance from token owner's account to user account
135 
136     function transfer(address to, uint tokens) public returns (bool success) {
137        _transfer(msg.sender, to, tokens);
138         return true;
139     }
140 
141     // Transfer tokens from the from account to the to account
142   
143     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
144         
145         require(tokens <= allowed[from][msg.sender]); // The calling account must already have sufficient tokens approved for spending from the from account
146         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);   // substract the send tokens from allowed limit
147         _transfer(from, to, tokens);
148         return true;
149     }
150     
151     /*
152      * Set allowance for other address
153      *
154      * Allows `spender` to spend no more than `_value` tokens in your behalf
155      * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
156      * recommends that there are no checks for the approval double-spend attack
157      * as this should be implemented in user interfaces 
158 
159      */
160      
161     function approve(address spender, uint tokens) public returns (bool success) {
162         // To change the approve amount you first have to reduce the addresses`
163         //  allowance to zero by calling `approve(_spender,0)` if it is not
164         //  already 0 to mitigate the race condition described here:
165         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166         require((tokens == 0) || (allowed[msg.sender][spender] == 0));
167         
168         allowed[msg.sender][spender] = tokens; // allow tokens to spender
169         emit Approval(msg.sender, spender, tokens); // raise Approval Event
170         return true;
171     }
172 
173     // Get the amount of tokens approved by the owner that can be transferred to the spender's account
174 
175     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
176         return allowed[tokenOwner][spender];
177     }
178 
179     // ------------------------------------------------------------------------
180     // Token owner can approve for spender to transferFrom(...) tokens
181     // from the token owner's account. The spender contract function
182     // receiveApproval(...) is then executed
183     ///* Allow another contract to spend some tokens in your behalf */
184     // ------------------------------------------------------------------------
185     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
186         //allowed[msg.sender][spender] = tokens;
187         //Approval(msg.sender, spender, tokens);
188         
189         require(approve(spender, tokens)); // approve function to be called first
190         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
191         return true;
192     }
193 
194     // ------------------------------------------------------------------------
195     // Don't accept ETH
196     // ------------------------------------------------------------------------
197     function () public payable {
198         revert();
199     }
200 
201     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
202 
203     function freezeAccount(address target, bool freeze) onlyOwner public {
204         frozenAccount[target] = freeze;
205         emit FrozenFunds(target, freeze);
206     }
207 
208     // ------------------------------------------------------------------------
209     // Owner can take back  any accidentally sent ERC20 tokens from any address
210     // ------------------------------------------------------------------------
211     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
212         return ERC20Interface(tokenAddress).transfer(owner, tokens);
213     }
214 }