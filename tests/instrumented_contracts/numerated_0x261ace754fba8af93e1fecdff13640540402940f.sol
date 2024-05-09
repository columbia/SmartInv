1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6 // ----------------------------------------------------------------------------
7 contract ERC20Interface {
8     function totalSupply() public constant returns (uint);
9     function balanceOf(address tokenOwner) public constant returns (uint balance);
10     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 // ----------------------------------------------------------------------------
20 // Owned contract
21 // ----------------------------------------------------------------------------
22 contract Owned {
23     address public owner;
24     address public newOwner;
25 
26     event OwnershipTransferred(address indexed _from, address indexed _to);
27 
28     constructor() public {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address _newOwner) public onlyOwner {
38         newOwner = _newOwner;
39     }
40 
41     function acceptOwnership() public {
42         require(msg.sender == newOwner);
43         emit OwnershipTransferred(owner, newOwner);
44         owner = newOwner;
45         newOwner = address(0);
46     }
47 }
48 
49 // ----------------------------------------------------------------------------
50 // ERC20 Token, with the addition of symbol, name and decimals and an
51 // initial fixed supply
52 // ----------------------------------------------------------------------------
53 contract Phila_Token is ERC20Interface, Owned {
54     string public constant symbol = "φιλα";
55     string public constant name = "φιλανθρωπία";
56     uint8 public constant decimals = 0;
57     uint private constant _totalSupply = 10000000;
58 
59     address public vaultAddress;
60     bool public fundingEnabled;
61     uint public totalCollected;         // In wei
62     uint public tokenPrice;         // In wei
63 
64     mapping(address => uint) balances;
65 
66     // ------------------------------------------------------------------------
67     // Constructor
68     // ------------------------------------------------------------------------
69     constructor() public {
70         balances[this] = _totalSupply;
71         emit Transfer(address(0), this, _totalSupply);
72     }
73 
74     function setVaultAddress(address _vaultAddress) public onlyOwner {
75         vaultAddress = _vaultAddress;
76         return;
77     }
78 
79     function setFundingEnabled(bool _fundingEnabled) public onlyOwner {
80         fundingEnabled = _fundingEnabled;
81         return;
82     }
83 
84     function updateTokenPrice(uint _newTokenPrice) public onlyOwner {
85         require(_newTokenPrice > 0);
86         tokenPrice = _newTokenPrice;
87         return;
88     }
89 
90     // ------------------------------------------------------------------------
91     // Total supply
92     // ------------------------------------------------------------------------
93     function totalSupply() public constant returns (uint) {
94         return _totalSupply  - balances[address(0)];
95     }
96 
97 
98     // ------------------------------------------------------------------------
99     // Get the token balance for account `tokenOwner`
100     // ------------------------------------------------------------------------
101     function balanceOf(address tokenOwner) public constant returns (uint) {
102         return balances[tokenOwner];
103     }
104 
105 
106     // ------------------------------------------------------------------------
107     // Token owner can approve for `spender` to transferFrom(...) `tokens`
108     // from the token owner's account
109     //
110     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
111     // recommends that there are no checks for the approval double-spend attack
112     // as this should be implemented in user interfaces 
113     //
114     // THIS TOKENS ARE NOT TRANSFERRABLE.
115     //
116     // ------------------------------------------------------------------------
117     function approve(address, uint) public returns (bool) {
118         revert();
119         return false;
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Returns the amount of tokens approved by the owner that can be
125     // transferred to the spender's account
126     //
127     // THIS TOKENS ARE NOT TRANSFERRABLE.
128     //
129     // ------------------------------------------------------------------------
130     function allowance(address, address) public constant returns (uint) {
131         return 0;
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Transfer the balance from token owner's account to `to` account
137     //
138     // THIS TOKENS ARE NOT TRANSFERRABLE.
139     //
140     // - 0 value transfers are allowed
141     // ------------------------------------------------------------------------
142     function transfer(address _to, uint _amount) public returns (bool) {
143        if (_amount == 0) {
144            emit Transfer(msg.sender, _to, _amount);    // Follow the spec to louch the event when transfer 0
145            return true;
146        }
147         revert();
148         return false;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Transfer `tokens` from the `from` account to the `to` account
154     //
155     // THIS TOKENS ARE NOT TRANSFERRABLE.
156     //
157     // ------------------------------------------------------------------------
158     function transferFrom(address, address, uint) public returns (bool) {
159         revert();
160         return false;
161     }
162 
163 
164     function () public payable {
165         require (fundingEnabled && (tokenPrice > 0) && (msg.value >= tokenPrice));
166         
167         totalCollected += msg.value;
168 
169         //Send the ether to the vault
170         vaultAddress.transfer(msg.value);
171 
172         uint tokens = msg.value / tokenPrice;
173 
174            // Do not allow transfer to 0x0 or the token contract itself
175            require((msg.sender != 0) && (msg.sender != address(this)));
176 
177            // If the amount being transfered is more than the balance of the
178            //  account the transfer throws
179            uint previousBalanceFrom = balances[this];
180 
181            require(previousBalanceFrom >= tokens);
182 
183            // First update the balance array with the new value for the address
184            //  sending the tokens
185            balances[this] = previousBalanceFrom - tokens;
186 
187            // Then update the balance array with the new value for the address
188            //  receiving the tokens
189            uint previousBalanceTo = balances[msg.sender];
190            require(previousBalanceTo + tokens >= previousBalanceTo); // Check for overflow
191            balances[msg.sender] = previousBalanceTo + tokens;
192 
193            // An event to make the transfer easy to find on the blockchain
194            emit Transfer(this, msg.sender, tokens);
195 
196         return;
197     }
198 
199 
200     /// @notice This method can be used by the owner to extract mistakenly
201     ///  sent tokens to this contract.
202     /// @param _token The address of the token contract that you want to recover
203     ///  set to 0 in case you want to extract ether.
204     //
205     // THIS TOKENS ARE NOT TRANSFERRABLE.
206     //
207     function claimTokens(address _token) public onlyOwner {
208         require(_token != address(this));
209         if (_token == 0x0) {
210             owner.transfer(address(this).balance);
211             return;
212         }
213 
214         ERC20Interface token = ERC20Interface(_token);
215         uint balance = token.balanceOf(this);
216         token.transfer(owner, balance);
217         emit ClaimedTokens(_token, owner, balance);
218     }
219     
220     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
221 }