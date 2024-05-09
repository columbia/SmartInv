1 pragma solidity ^0.4.20;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe math
6 // ----------------------------------------------------------------------------
7 library SafeMath {
8     function add(uint a, uint b) internal pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function sub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function mul(uint a, uint b) internal pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function div(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 contract Token {
28 
29     /// @return total amount of tokens
30     function totalSupply() public view returns (uint);
31 
32     /// @param tokenOwner The address from which the balance will be retrieved
33     /// @return The balance
34     function balanceOf(address tokenOwner) public view returns (uint balance);
35 
36     /// @notice send `tokens` token to `to` from `msg.sender`
37     /// @param to The address of the recipient
38     /// @param tokens The amount of token to be transferred
39     /// @return Whether the transfer was successful or not
40     /// reverts/fails the transaction if conditions are not met
41     function transfer(address to, uint tokens) public returns (bool success);
42 
43     /// @notice send `tokens` token to `to` from `from` on the condition it is approved by `from`
44     /// @param from The address of the sender
45     /// @param to The address of the recipient
46     /// @param tokens The amount of token to be transferred
47     /// @return Whether the transfer was successful or not
48     /// reverts/fails the transaction if conditions are not met
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     /// @notice `msg.sender` approves `spender` to spend `tokens` tokens
52     /// @param spender The address of the account able to transfer the tokens
53     /// @param tokens The amount of wei to be approved for transfer
54     /// @return Whether the approval was successful or not
55     /// reverts/fails the transaction if conditions are not met
56     function approve(address spender, uint tokens) public returns (bool success);
57 
58     /// @param tokenOwner The address of the account owning tokens
59     /// @param spender The address of the account able to transfer the tokens
60     /// @return Amount of remaining tokens allowed to spent
61     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
62     
63   
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 
67 }
68 
69 contract StandardToken is Token {
70     
71     using SafeMath for uint;
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75     uint256 public totalSupply;
76     
77     
78     // ------------------------------------------------------------------------
79     // Transfer the balance from token owner's account to `to` account
80     // - Owner's account must have sufficient balance to transfer
81     // ------------------------------------------------------------------------
82     function transfer(address to, uint tokens) public returns (bool success) {
83         require(to != address(0));
84         require(tokens > 0);
85         require(balances[msg.sender] >= tokens); 
86         
87         balances[msg.sender] = balances[msg.sender].sub(tokens);
88         balances[to] = balances[to].add(tokens);
89         emit Transfer(msg.sender, to, tokens);
90         return true;
91     }
92 
93 
94     // ------------------------------------------------------------------------
95     // Token owner can approve for `spender` to transferFrom(...) `tokens`
96     // from the token owner's account
97     //
98     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
99     // recommends that there are no checks for the approval double-spend attack
100     // as this should be implemented in user interfaces 
101     // ------------------------------------------------------------------------
102     function approve(address spender, uint tokens) public returns (bool success) {
103         require(spender != address(0));
104         require(tokens > 0);
105         
106         allowed[msg.sender][spender] = tokens;
107         emit Approval(msg.sender, spender, tokens);
108         return true;
109     }
110 
111 
112     // ------------------------------------------------------------------------
113     // Transfer `tokens` from the `from` account to the `to` account
114     // 
115     // The calling account must already have sufficient tokens approve(...)-d
116     // for spending from the `from` account and
117     // - From account must have sufficient balance to transfer
118     // - Spender must have sufficient allowance to transfer
119     // ------------------------------------------------------------------------
120     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
121         require(from != address(0));
122         require(to != address(0));
123         require(tokens > 0);
124         require(balances[from] >= tokens);
125         require(allowed[from][msg.sender] >= tokens);
126         
127         balances[from] = balances[from].sub(tokens);
128         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
129         balances[to] = balances[to].add(tokens);
130         emit Transfer(from, to, tokens);
131         return true;
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Get the token balance for account `tokenOwner`
137     // ------------------------------------------------------------------------
138     function balanceOf(address tokenOwner) public view returns (uint balance) {
139         return balances[tokenOwner];
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Get the totalSupply
145     // ------------------------------------------------------------------------
146     function totalSupply() public view returns (uint) {
147         return totalSupply;
148     }
149 
150     // ------------------------------------------------------------------------
151     // Returns the amount of tokens approved by the owner that can be
152     // transferred to the spender's account
153     // ------------------------------------------------------------------------
154     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
155         return allowed[tokenOwner][spender];
156     }
157 
158 }
159 
160 contract KillerWhale is StandardToken { // CHANGE THIS. Update the contract name.
161 
162     /* Public variables of the token */
163 
164     /*
165     NOTE:
166     The following variables are OPTIONAL vanities. One does not have to include them.
167     They allow one to customise the token contract & in no way influences the core functionality.
168     Some wallets/interfaces might not even bother to look at this information.
169     */
170     string public name;                   // Token Name
171     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
172     string public symbol;                 // An identifier: eg SBX, XPR etc..
173     string public version = 'H1.0'; 
174     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
175     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
176     address public fundsWallet;           // Where should the raised ETH go?
177 
178     // This is a constructor function 
179     // which means the following function name has to match the contract name declared above
180     function KillerWhale() {
181         name = "KillerWhale";                                          // Set the name for display purposes (CHANGE THIS)
182         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
183         symbol = "KWT";                                             // Set the symbol for display purposes (CHANGE THIS)
184         unitsOneEthCanBuy = 100;                                      // Set the price of your token for the ICO (CHANGE THIS)
185         fundsWallet = 0x3f17dE50F2D1CA4209c2028677B328E34581d4Dc;                                    // The owner of the contract gets ETH
186         totalSupply = 888000000 * 10 ** uint256(decimals);                        // Update total supply (1000 for example) (CHANGE THIS)
187         balances[0x3f17dE50F2D1CA4209c2028677B328E34581d4Dc] = totalSupply;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
188         
189         emit Transfer(address(0),0x3f17dE50F2D1CA4209c2028677B328E34581d4Dc,totalSupply);
190     }
191 
192 
193     function() public payable{
194         totalEthInWei = totalEthInWei + msg.value;
195         uint256 amount = msg.value * unitsOneEthCanBuy;
196 
197         // wallet should have enough tokens to fund
198         require(balances[fundsWallet] >= amount);
199 
200         balances[fundsWallet] = balances[fundsWallet].sub(amount);
201         balances[msg.sender] = balances[msg.sender].add(amount);
202 
203         emit Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
204 
205         //Transfer ether to fundsWallet
206         fundsWallet.transfer(msg.value);                               
207     }
208 
209 
210     /* Approves and then calls the receiving contract */
211     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
212         allowed[msg.sender][_spender] = _value;
213         emit Approval(msg.sender, _spender, _value);
214 
215         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
216         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
217         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
218         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
219         return true;
220     }
221 }