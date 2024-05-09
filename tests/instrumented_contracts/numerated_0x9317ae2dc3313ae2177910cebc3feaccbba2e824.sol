1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenERC20 {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 6;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12     address owner=msg.sender;
13 
14     // This creates an array with all balances, allowances, frozen, master and admin accounts
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17     mapping (address => bool) public frozenAccount;
18     mapping(address => bool) public master;
19     mapping(address => bool) public admin;
20     
21     // This generates a public event on the blockchain that will notify clients
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Burn(address indexed from, uint256 value);
24     event FrozenFunds(address target, bool frozen);
25     event unFrozenFunds(address target, bool unfrozen);
26     event AdminAddressAdded(address addr);
27     event AdminAddressRemoved(address addr);
28     event MasterAddressAdded(address addr);
29     event MasterAddressRemoved(address addr);
30 
31 
32     /**
33      * Constructor function
34      *
35      * Initializes contract with initial supply tokens to the creator of the contract
36      */
37     function TokenERC20(
38         uint256 initialSupply,
39         string tokenName,
40         string tokenSymbol
41     ) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
43         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
44         name = tokenName;                                   // Set the name for display purposes
45         symbol = tokenSymbol;                               // Set the symbol for display purposes
46     }
47 
48     // Setting the ownership function of this contract
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address newOwner) onlyOwner public {
55         owner = newOwner;
56     }
57     
58     // setting the master function of this contract
59      modifier onlyMaster() {
60      require(master[msg.sender]);
61     _;
62     }
63     
64     // setting the addition / removal of master addresses
65      function addAddressToMaster(address addr) onlyOwner public returns(bool success) {
66      if (!master[addr]) {
67        master[addr] = true;
68        MasterAddressAdded(addr);
69        success = true; 
70      }
71      }
72     
73      function removeAddressFromMaster(address addr) onlyOwner public returns(bool success) {
74      if (master[addr]) {
75        master[addr] = false;
76        MasterAddressRemoved(addr);
77        success = true;
78      }
79      }
80     
81     // setting the admin function of this contract
82      modifier onlyAdmin() {
83      require(admin[msg.sender]);
84     _;
85     }
86     
87     // setting the addition / removal of admin addresses
88      function addAddressToAdmin(address addr) onlyMaster public returns(bool success) {
89      if (!admin[addr]) {
90        admin[addr] = true;
91        AdminAddressAdded(addr);
92        success = true; 
93      }
94      }
95     
96      function removeAddressFromAdmin(address addr) onlyMaster public returns(bool success) {
97      if (admin[addr]) {
98        admin[addr] = false;
99        AdminAddressRemoved(addr);
100        success = true;
101      }
102      }
103      
104     /**
105      * Internal transfer, only can be called by this contract
106      */
107     function _transfer(address _from, address _to, uint _value) internal {
108         // Prevent transfer to 0x0 address. Use burn() instead
109         require(_to != 0x0);
110         // Check if the sender has enough
111         require(balanceOf[_from] >= _value);
112         // Check for overflows
113         require(balanceOf[_to] + _value >= balanceOf[_to]);
114         // Save this for an assertion in the future
115         uint previousBalances = balanceOf[_from] + balanceOf[_to];
116         // Subtract from the sender
117         balanceOf[_from] -= _value;
118         // Add the same to the recipient
119         balanceOf[_to] += _value;
120         emit Transfer(_from, _to, _value);
121         // Asserts are used to use static analysis to find bugs in your code. They should never fail
122         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
123         // Check for frozen accounts
124         require(!frozenAccount[_from]);         // Check if sender is frozen
125         require(!frozenAccount[_to]);           // Check if recipient is frozen
126 
127     }
128 
129     /**
130      * Transfer tokens
131      *
132      * Send `_value` tokens to `_to` from your account
133      *
134      * @param _to The address of the recipient
135      * @param _value the amount to send
136      */
137     function transfer(address _to, uint256 _value) public {
138         _transfer(msg.sender, _to, _value);
139     }
140 
141     /**
142      * Transfer tokens from other address
143      *
144      * Send `_value` tokens to `_to` on behalf of `_from`
145      *
146      * @param _from The address of the sender
147      * @param _to The address of the recipient
148      * @param _value the amount to send
149      */
150     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
151         require(_value <= allowance[_from][msg.sender]);     // Check allowance
152         allowance[_from][msg.sender] -= _value;
153         _transfer(_from, _to, _value);
154         return true;
155     }
156 
157     /**
158      * Set allowance for other address
159      *
160      * Allows `_spender` to spend no more than `_value` tokens on your behalf
161      *
162      * @param _spender The address authorized to spend
163      * @param _value the max amount they can spend
164      */
165     function approve(address _spender, uint256 _value) public
166         returns (bool success) {
167         allowance[msg.sender][_spender] = _value;
168         return true;
169     }
170 
171     /**
172      * Set allowance for other address and notify
173      *
174      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
175      *
176      * @param _spender The address authorized to spend
177      * @param _value the max amount they can spend
178      * @param _extraData some extra information to send to the approved contract
179      */
180     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
181         public
182         returns (bool success) {
183         tokenRecipient spender = tokenRecipient(_spender);
184         if (approve(_spender, _value)) {
185             spender.receiveApproval(msg.sender, _value, this, _extraData);
186             return true;
187         }
188     }
189 
190     /**
191      * Destroy tokens
192      *
193      * Remove `_value` tokens from the system irreversibly
194      *
195      * @param _value the amount of money to burn
196      */
197     function burn(uint256 _value) public returns (bool success) {
198         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
199         balanceOf[msg.sender] -= _value;            // Subtract from the sender
200         totalSupply -= _value;                      // Updates totalSupply
201         emit Burn(msg.sender, _value);
202         return true;
203     }
204 
205     /**
206      * Destroy tokens from other account
207      *
208      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
209      *
210      * @param _from the address of the sender
211      * @param _value the amount of money to burn
212      */
213     function burnFrom(address _from, uint256 _value) public returns (bool success) {
214         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
215         require(_value <= allowance[_from][msg.sender]);    // Check allowance
216         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
217         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
218         totalSupply -= _value;                              // Update totalSupply
219         emit Burn(_from, _value);
220         return true;
221     }
222     
223     // This part is for Token Pricing and advanced portions
224     /// @notice Create `mintedAmount` tokens and send it to `target`
225     /// @param target Address to receive the tokens
226     /// @param mintedAmount the amount of tokens it will receive
227     function mintToken(address target, uint256 mintedAmount) onlyMaster public {
228         require(balanceOf[msg.sender]<= totalSupply/10);
229         balanceOf[target] += mintedAmount;
230         totalSupply += mintedAmount;
231         Transfer(0, this, mintedAmount);
232         Transfer(this, target, mintedAmount);
233     }
234     
235     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
236     /// @param target Address to be frozen
237     /// @param freeze either to freeze it or not
238     function freezeAccount(address target, bool freeze) onlyAdmin public {
239         frozenAccount[target] = freeze;
240         FrozenFunds(target, freeze);
241     }
242      
243     function unfreezeAccount(address target, bool freeze) onlyAdmin public {
244         frozenAccount[target] = !freeze;
245         unFrozenFunds(target, !freeze);
246     }
247 
248     // dividend payout section
249     // when user wants to claim for dividend, they should press this function
250     // which will freeze their account temporarily after diviendend payout is
251     // complete
252     function claimfordividend() public {
253         freezeAccount(msg.sender , true);
254     }
255     
256     // owner will perform this action to payout the dividend and unfreeze the 
257     // frozen accounts
258     function payoutfordividend (address target, uint256 divpercentage) onlyOwner public{
259         _transfer(msg.sender, target, ((divpercentage*balanceOf[target]/100 + 5 - 1) / 5)*5);
260         unfreezeAccount(target , true);
261     }
262 }