1 pragma solidity ^0.4.18;
2 
3 // https://github.com/ethereum/EIPs/issues/20
4 
5 contract ERC20 {
6     function totalSupply() public constant returns (uint256 supply);
7     function balanceOf(address _owner) public constant returns (uint256 balance);
8     function transfer(address _to, uint256 _value) public returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
10     function approve(address _spender, uint256 _value) public returns (bool success);
11     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
12     
13     // These generate a public event on the blockchain that will notify clients
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 
17 }
18 
19 contract Owned {
20     address public owner;
21 
22     function Owned() public {
23         owner = msg.sender;
24     }
25 
26     modifier onlyOwner {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     function transferOwnership(address newOwner) public onlyOwner {
32         owner = newOwner;
33     }
34 }
35 
36 contract MNTToken is ERC20, Owned {
37     // Public variables of the token
38     string public name = "Media Network Token";
39     string public symbol = "MNT";
40     uint8 public decimals = 18;
41     uint256 public totalSupply = 0; // 125 * 10**6 * 10**18;
42     uint256 public maxSupply = 125 * 10**6 * 10**18;
43     address public cjTeamWallet = 0x9887c2da3aC5449F3d62d4A04372a4724c21f54C;
44 
45     // This creates an array with all balances
46     mapping (address => uint256) public balanceOf;
47 
48     // This creates an array with all allowances
49     mapping (address => mapping (address => uint256)) public allowance;
50 
51 
52     /**
53      * Constructor function
54      *
55      * Gives ownership of all initial tokens to the Coin Joker Team. Sets ownership of contract
56      */
57     function MNTToken(
58         address cjTeam
59     ) public {
60         //balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
61         totalEthRaised = 0;
62         /*if (cjTeam != 0) {
63             owner = cjTeam;
64         }*/
65         cjTeamWallet = cjTeam;
66     }
67 	
68     function changeCJTeamWallet(address newWallet) public onlyOwner {
69         cjTeamWallet = newWallet;
70     }
71 
72     /**
73      * Internal transfer, only can be called by this contract
74      */
75     function _transfer(address _from, address _to, uint256 _value) internal {
76         require(_to != 0x0);                               // Prevent transfer to 0x0 address
77         require(balanceOf[_from] >= _value);                // Check if the sender has enough
78         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
79         balanceOf[_from] -= _value;                         // Subtract from the sender
80         balanceOf[_to] += _value;                           // Add the same to the recipient
81         Transfer(_from, _to, _value);
82     }
83 
84     /**
85      * Transfer tokens
86      *
87      * Send `_value` tokens to `_to` from your account
88      *
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transfer(address _to, uint256 _value) public returns (bool success) {
93         _transfer(msg.sender, _to, _value);
94         return true;
95     }
96 
97     /**
98      * Transfer tokens from other address
99      *
100      * Send `_value` tokens to `_to` in behalf of `_from`
101      *
102      * @param _from The address of the sender
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transferFrom(
107         address _from, 
108         address _to, 
109         uint256 _value
110     ) public returns (bool success) 
111     {
112         require(_value <= allowance[_from][msg.sender]);     // Check allowance
113         allowance[_from][msg.sender] -= _value;
114         _transfer(_from, _to, _value);
115         return true;
116     }
117 
118     /**
119      * Set allowance for other address
120      *
121      * Allows `_spender` to spend no more than `_value` tokens in your behalf
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      */
126     function approve(
127         address _spender, 
128         uint256 _value
129     ) public returns (bool success)
130     {
131         allowance[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     /**
137      * Get current balance of account _owner
138      *
139      * @param _owner The owner of the account
140      */
141     function balanceOf(address _owner) public constant returns (uint256 balance) {
142         return balanceOf[_owner];
143     }
144 
145     /**
146      * Get allowance from _owner to _spender
147      *
148      * @param _owner The address that authorizes to spend
149      * @param _spender The address authorized to spend
150      */
151     function allowance(
152         address _owner, 
153         address _spender
154     ) public constant returns (uint256 remaining)
155     {
156         return allowance[_owner][_spender];
157     }
158 
159     /**
160      * Get total supply of all tokens
161      */
162     function totalSupply() public constant returns (uint256 supply) {
163         return totalSupply;
164     }
165 
166     // --------------------------------
167     // Token sale variables and methods
168     // --------------------------------
169 
170     bool saleHasStarted = false;
171     bool saleHasEnded = false;
172     uint256 public saleEndTime   = 1518649200; // 15.2.2018, 0:00:00, GMT+1
173     uint256 public saleStartTime = 1513435000; // 16.12.2017, 15:36:40, GMT+1
174     uint256 public maxEthToRaise = 7500 * 10**18;
175     uint256 public totalEthRaised;
176     uint256 public ethAvailable;
177     uint256 public eth2mnt = 10000; // number of MNTs you get for 1 ETH - actually for 1/10**18 of ETH
178 
179     /* Issue new tokens - internal function */     
180     function _mintTokens (address _to, uint256 _amount) internal {             
181         require(balanceOf[_to] + _amount >= balanceOf[_to]); // check for overflows
182         require(totalSupply + _amount <= maxSupply);
183         totalSupply += _amount;                                      // Update total supply
184         balanceOf[_to] += _amount;                               // Set minted coins to target
185         Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
186     }
187 
188 
189     /* Users send ETH and enter the token sale*/  
190     function () public payable {
191         require(msg.value != 0);
192         require(!(saleHasEnded || now > saleEndTime)); // Throw if the token sale has ended
193         if (!saleHasStarted) {                                                // Check if this is the first token sale transaction   
194             if (now >= saleStartTime) {                             // Check if the token sale should start        
195                 saleHasStarted = true;                                           // Set that the token sale has started         
196             } else {
197                 require(false);
198             }
199         }     
200      
201         if (maxEthToRaise > (totalEthRaised + msg.value)) {                 // Check if the user sent too much ETH         
202             totalEthRaised += msg.value;                                    // Add to total eth Raised
203             ethAvailable += msg.value;
204             _mintTokens(msg.sender, msg.value * eth2mnt);
205             cjTeamWallet.transfer(msg.value); 
206         } else {                                                              // If user sent to much eth       
207             uint maxContribution = maxEthToRaise - totalEthRaised;            // Calculate maximum contribution       
208             totalEthRaised += maxContribution;  
209             ethAvailable += maxContribution;
210             _mintTokens(msg.sender, maxContribution * eth2mnt);
211             uint toReturn = msg.value - maxContribution;                       // Calculate how much should be returned       
212             saleHasEnded = true;
213             msg.sender.transfer(toReturn);                                  // Refund the balance that is over the cap   
214             cjTeamWallet.transfer(msg.value-toReturn);       
215         }
216     } 
217 
218     /**
219      * Withdraw the funds
220      *
221      * Sends the raised amount to the CJ Team. Mints 40% of tokens to send to the CJ team.
222      */
223     function endOfSaleFullWithdrawal() public onlyOwner {
224         if (saleHasEnded || now > saleEndTime) {
225             //if (owner.send(ethAvailable)) {
226             cjTeamWallet.transfer(this.balance);
227             ethAvailable = 0;
228             //_mintTokens (owner, totalSupply * 2 / 3);
229             _mintTokens (cjTeamWallet, 50 * 10**6 * 10**18); // CJ team gets 40% of token supply
230         }
231     }
232 
233     /**
234      * Withdraw the funds
235      *
236      * Sends partial amount to the CJ Team
237      */
238     function partialWithdrawal(uint256 toWithdraw) public onlyOwner {
239         cjTeamWallet.transfer(toWithdraw);
240         ethAvailable -= toWithdraw;
241     }
242 }