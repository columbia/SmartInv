1 pragma solidity ^0.4.11;
2 
3 contract Token {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) constant returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 contract StandardToken is Token {
49 
50     function transfer(address _to, uint256 _value) returns (bool success) {
51         //Default assumes totalSupply can't be over max (2^256 - 1).
52         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
53         //Replace the if with this one instead.
54         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
55         if (balances[msg.sender] >= _value && _value > 0) {
56             balances[msg.sender] -= _value;
57             balances[_to] += _value;
58             Transfer(msg.sender, _to, _value);
59             return true;
60         } else { return false; }
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
64         //same as above. Replace this line with the following if you want to protect against wrapping uints.
65         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
67             balances[_to] += _value;
68             balances[_from] -= _value;
69             allowed[_from][msg.sender] -= _value;
70             Transfer(_from, _to, _value);
71             return true;
72         } else { return false; }
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;
91 }
92 
93 contract Owned {
94     address public owner;
95 
96     function Owned() {
97         owner = msg.sender;
98     }
99 
100     modifier onlyOwner {
101         if (msg.sender != owner) throw;
102         _;
103     }
104 
105     function transferOwnership(address newOwner) onlyOwner returns (address _owner) {
106         owner = newOwner;
107         return owner;
108     }
109 }
110 
111 contract ProsperaToken is StandardToken, Owned {
112 
113     function () {
114         //if ether is sent to this address, send it back.
115         throw;
116     }
117 
118     /* Public variables of the token */
119 
120     /*
121     NOTE:
122     The following variables are OPTIONAL vanities. One does not have to include them.
123     They allow one to customise the token contract & in no way influences the core functionality.
124     Some wallets/interfaces might not even bother to look at this information.
125     */
126     string public name;                   //fancy name: eg Simon Bucks
127     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
128     string public symbol;                 //An identifier: eg SBX
129     string public version = '0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
130 
131 
132     function ProsperaToken(
133         uint256 _initialAmount,
134         string _tokenName,
135         uint8 _decimalUnits,
136         string _tokenSymbol
137         ) {
138         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
139         totalSupply = _initialAmount;                        // Update total supply
140         name = _tokenName;                                   // Set the name for display purposes
141         decimals = _decimalUnits;                            // Amount of decimals for display purposes
142         symbol = _tokenSymbol;                               // Set the symbol for display purposes
143     }
144 
145     /* Approves and then calls the receiving contract */
146     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149 
150         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
151         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
152         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
153         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
154         return true;
155     }
156 
157 
158     /* Batch token transfer. Used by contract creator to distribute initial coins to holders */
159     function batchTransfer(address[] _recipients, uint256[] _values) returns (bool success) {
160       if ((_recipients.length == 0) || (_recipients.length != _values.length)) throw;
161 
162       for(uint8 i = 0; i < _recipients.length; i += 1) {
163         if (!transfer(_recipients[i], _values[i])) throw;
164       }
165       return true;
166     }
167 
168 
169 
170     address minterContract;
171     event Mint(address indexed _account, uint256 _amount);
172 
173     modifier onlyMinter {
174         if (msg.sender != minterContract) throw;
175          _;
176     }
177 
178     function setMinter (address newMinter) onlyOwner returns (bool success) {
179       minterContract = newMinter;
180       return true;
181     }
182 
183     function mintToAccount(address _account, uint256 _amount) onlyMinter returns (bool success) {
184         // Checks for variable overflow
185         if (balances[_account] + _amount < balances[_account]) throw;
186         balances[_account] += _amount;
187         Mint(_account, _amount);
188         return true;
189     }
190 
191     function incrementTotalSupply(uint256 _incrementValue) onlyMinter returns (bool success) {
192         totalSupply += _incrementValue;
193         return true;
194     }
195 }
196 
197 contract Minter is Owned {
198 
199   uint256 public lastMintingTime = 0;
200   uint256 public lastMintingAmount;
201   address public prosperaTokenAddress;
202   ProsperaToken public prosperaToken;
203 
204   modifier allowedMinting() {
205     if (block.timestamp >= lastMintingTime + 30 days) {
206       _;
207     }
208   }
209 
210   function Minter (uint256 _lastMintingAmount, address _ownerContract) {
211     lastMintingAmount = _lastMintingAmount;
212     prosperaTokenAddress = _ownerContract;
213     prosperaToken = ProsperaToken(_ownerContract);
214   }
215 
216   // increases 2.95% from last minting
217   function calculateMintAmount() returns (uint256 amount){
218    return lastMintingAmount * 10295 / 10000;
219   }
220 
221   function updateMintingStatus(uint256 _mintedAmount) internal {
222     lastMintingAmount = _mintedAmount;
223     lastMintingTime = block.timestamp;
224     prosperaToken.incrementTotalSupply(_mintedAmount);
225   }
226 
227   function mint() allowedMinting onlyOwner returns (bool success) {
228     uint256 value = calculateMintAmount();
229     prosperaToken.mintToAccount(msg.sender, value);
230     updateMintingStatus(value);
231     return true;
232   }
233 }