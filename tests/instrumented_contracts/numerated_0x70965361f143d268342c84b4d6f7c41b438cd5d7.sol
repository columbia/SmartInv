1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address public owner;
5     modifier onlyOwner() {
6         require(msg.sender == owner);
7         _;
8     }
9     
10     function Owned() public{
11         owner = msg.sender;
12     }
13     
14     function changeOwner(address _newOwner) public onlyOwner {
15         owner = _newOwner;
16     }
17 }
18 
19 
20 contract tokenRecipient { 
21   function receiveApproval (address _from, uint256 _value, address _token, bytes _extraData) public;
22 }
23 
24 contract ERC20Token {
25     /* This is a slight change to the ERC20 base standard.
26     function totalSupply() constant returns (uint256 supply);
27     is replaced with:
28     uint256 public totalSupply;
29     This automatically creates a getter function for the totalSupply.
30     This is moved to the base contract since public getter functions are not
31     currently recognised as an implementation of the matching abstract
32     function by the compiler.
33     */
34     /// total amount of tokens
35     uint256 public totalSupply;
36 
37     /// @param _owner The address from which the balance will be retrieved
38     /// @return The balance
39     function balanceOf(address _owner) public constant returns (uint256 balance);
40 
41     /// @notice send `_value` token to `_to` from `msg.sender`
42     /// @param _to The address of the recipient
43     /// @param _value The amount of token to be transferred
44     /// @return Whether the transfer was successful or not
45     function transfer(address _to, uint256 _value) public returns (bool success);
46 
47     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
48     /// @param _from The address of the sender
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
53 
54     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
55     /// @param _spender The address of the account able to transfer the tokens
56     /// @param _value The amount of tokens to be approved for transfer
57     /// @return Whether the approval was successful or not
58     function approve(address _spender, uint256 _value) public returns (bool success);
59 
60     /// @param _owner The address of the account owning tokens
61     /// @param _spender The address of the account able to transfer the tokens
62     /// @return Amount of remaining tokens allowed to spent
63     function allowance(address _owner, address _spender) public constant  returns (uint256 remaining);
64 
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67 }
68 
69 contract LuckcoinContract is ERC20Token, Owned{
70 
71     /* Public variables of the token */
72     string  public constant standard = "Luckcoin V1.0";
73     string  public constant name = "Luckcoin";
74     string  public constant symbol = "LKC";
75     uint256 public constant decimals = 6;
76     uint256 private constant etherChange = 10**18;
77     
78     /* Variables of the token */
79     uint256 public totalSupply;
80     uint256 public totalRemainSupply;
81     uint256 public LKCExchangeRate;
82     bool    public crowdsaleIsOpen;
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowances;
85     address public multisigAddress;
86     /* Events */
87     event mintToken(address indexed _to, uint256 _value);
88     event burnToken(address indexed _from, uint256 _value);
89     
90     function () payable public {
91         require (crowdsaleIsOpen == true);
92         require(msg.value != 0);
93         mintLKCToken(msg.sender, (msg.value * LKCExchangeRate * 10**decimals) / etherChange);
94     }
95     /* Initializes contract and  sets restricted addresses */
96     function LuckcoinContract(uint256 _totalSupply, uint256 __LKCExchangeRate) public {
97         owner = msg.sender;
98         totalSupply = _totalSupply * 10**decimals;
99         LKCExchangeRate = __LKCExchangeRate;
100         totalRemainSupply = totalSupply;
101         crowdsaleIsOpen = true;
102     }
103     
104     function setLKCExchangeRate(uint256 _LKCExchangeRate) public onlyOwner {
105         LKCExchangeRate = _LKCExchangeRate;
106     }
107     
108     function crowdsaleOpen(bool _crowdsaleIsOpen) public {
109         crowdsaleIsOpen = _crowdsaleIsOpen;
110     }
111     /* Returns total supply of issued tokens */
112     function LKCTotalSupply() public constant returns (uint256)  {   
113         return totalSupply - totalRemainSupply ;
114     }
115 
116     /* Returns balance of address */
117     function balanceOf(address _owner) public constant returns (uint256 balance) {
118         return balances[_owner];
119     }
120 
121     /* Transfers tokens from your address to other */
122     function transfer(address _to, uint256 _value) public returns (bool success) {
123         require (balances[msg.sender] > _value);            // Throw if sender has insufficient balance
124         require (balances[_to] + _value > balances[_to]);   // Throw if owerflow detected
125         balances[msg.sender] -= _value;                     // Deduct senders balance
126         balances[_to] += _value;                            // Add recivers blaance 
127         Transfer(msg.sender, _to, _value);                  // Raise Transfer event
128         return true;
129     }
130 
131     /* Approve other address to spend tokens on your account */
132     function approve(address _spender, uint256 _value) public returns (bool success) {
133         allowances[msg.sender][_spender] = _value;          // Set allowance         
134         Approval(msg.sender, _spender, _value);             // Raise Approval event         
135         return true;
136     }
137 
138     /* Approve and then communicate the approved contract in a single tx */ 
139     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {            
140         tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract         
141         approve(_spender, _value);                                      // Set approval to contract for _value         
142         spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract         
143         return true;     
144     }     
145 
146     /* A contract attempts to get the coins */
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {      
148         require (balances[_from] > _value);                // Throw if sender does not have enough balance     
149         require (balances[_to] + _value > balances[_to]);  // Throw if overflow detected    
150         require (_value > allowances[_from][msg.sender]);  // Throw if you do not have allowance       
151         balances[_from] -= _value;                          // Deduct senders balance    
152         balances[_to] += _value;                            // Add recipient blaance         
153         allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address         
154         Transfer(_from, _to, _value);                       // Raise Transfer event
155         return true;     
156     }         
157 
158     /* Get the amount of allowed tokens to spend */     
159     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {         
160         return allowances[_owner][_spender];
161     }     
162         
163     /*withdraw Ether to a multisig address*/
164     function withdraw(address _multisigAddress) public onlyOwner {    
165         require(_multisigAddress != 0x0);
166         multisigAddress = _multisigAddress;
167         multisigAddress.transfer(this.balance);
168     }  
169     
170     /* Issue new tokens */     
171     function mintLKCToken(address _to, uint256 _amount) internal { 
172         require (balances[_to] + _amount > balances[_to]);      // Check for overflows
173         require (totalRemainSupply > _amount);
174         totalRemainSupply -= _amount;                           // Update total supply
175         balances[_to] += _amount;                               // Set minted coins to target
176         mintToken(_to, _amount);                                // Create Mint event       
177         Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
178     }  
179     
180     function mintTokens(address _sendTo, uint256 _sendAmount)public onlyOwner {
181         mintLKCToken(_sendTo, _sendAmount);
182     }
183     
184     /* Destroy tokens from owners account */
185     function burnTokens(address _addr, uint256 _amount)public onlyOwner {
186         require (balances[msg.sender] < _amount);               // Throw if you do not have enough balance
187         totalRemainSupply += _amount;                           // Deduct totalSupply
188         balances[_addr] -= _amount;                             // Destroy coins on senders wallet
189         burnToken(_addr, _amount);                              // Raise Burn event
190         Transfer(_addr, 0x0, _amount);                          // Raise transfer to 0x0
191     }
192 }