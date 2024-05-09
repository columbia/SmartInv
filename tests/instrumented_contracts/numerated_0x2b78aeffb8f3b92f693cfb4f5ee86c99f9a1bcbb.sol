1 pragma solidity ^0.4.23;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39 }
40 
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         //Default assumes totalSupply can't be over max (2^256 - 1).
45         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
46         //Replace the if with this one instead.
47         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
48         if (balances[msg.sender] >= _value && _value > 0) {
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else { return false; }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         //same as above. Replace this line with the following if you want to protect against wrapping uints.
58         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84     uint256 public totalSupply;
85 }
86 
87 contract Ownable {
88   address public owner;
89 
90 
91   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93   function Ownable() public {
94     owner = msg.sender;
95   }
96 
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   function transferOwnership(address newOwner) public onlyOwner {
103     require(newOwner != address(0));
104     OwnershipTransferred(owner, newOwner);
105     owner = newOwner;
106   }
107   
108   function getOwner() view public returns (address){
109     return owner;
110   }
111   
112 
113 }
114 
115 contract Kodobit is StandardToken, Ownable{ // CHANGE THIS. Update the contract name.
116 
117     /* Public variables of the token */
118 
119     /*
120     NOTE:
121     The following variables are OPTIONAL vanities. One does not have to include them.
122     They allow one to customise the token contract & in no way influences the core functionality.
123     Some wallets/interfaces might not even bother to look at this information.
124     */
125     string public name;                   // Token Name
126     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
127     string public symbol;                 // An identifier: eg SBX, XPR etc..
128     string public version = 'H1.0';
129     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
130     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.
131     address public fundsWallet;           // Where should the raised ETH go?
132     uint256 public _totalSupply = 350000000e18; 
133     uint256 public _initialSupply = 240000000e18; 
134     uint256 public _totalTokenSold = 0; 
135     bool private reserve_activated = false;
136 
137     // This is a constructor function
138     // which means the following function name has to match the contract name declared above
139     function Kodobit() {
140         balances[owner] = _initialSupply;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
141         totalSupply = _totalSupply;                        // Update total supply (1000 for example) (CHANGE THIS)
142         name = "Kodobit";                                   // Set the name for display purposes (CHANGE THIS)
143         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
144         symbol = "KODO";                                             // Set the symbol for display purposes (CHANGE THIS)
145         unitsOneEthCanBuy = 500000;                                      // Set the price of your token for the ICO (CHANGE THIS)
146         fundsWallet = owner;                                    // The owner of the contract gets ETH
147     }
148 
149     function() public payable{
150         totalEthInWei = totalEthInWei + msg.value;
151         uint256 amount = msg.value * unitsOneEthCanBuy;
152         require(balances[fundsWallet] >= amount);
153         require(_totalTokenSold <= _initialSupply);
154 
155 
156         balances[fundsWallet] = balances[fundsWallet] - amount;
157         balances[msg.sender] = balances[msg.sender] + amount;
158         _totalTokenSold = _totalTokenSold + amount;
159 
160         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
161 
162         //Transfer ether to fundsWallet
163         fundsWallet.transfer(msg.value);                             
164     }
165 
166     /* Approves and then calls the receiving contract */
167     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
168         allowed[msg.sender][_spender] = _value;
169         Approval(msg.sender, _spender, _value);
170 
171         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
172         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
173         //it is assumed that when does this that the call should succeed, otherwise one would use vanilla approve instead.
174         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
175         return true;
176     }
177 
178     function activate_reserve() public onlyOwner{
179       require(!reserve_activated );
180       balances[owner] = balances[owner] + (_totalSupply - _initialSupply);  
181       reserve_activated = true;
182     }
183 }