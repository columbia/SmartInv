1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() public constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) public constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) public returns (bool success) {}
17 
18 
19     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
20     /// @param _spender The address of the account able to transfer the tokens
21     /// @param _value The amount of wei to be approved for transfer
22     /// @return Whether the approval was successful or not
23     function approve(address _spender, uint256 _value) returns (bool success) {}
24 
25     /// @param _owner The address of the account owning tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @return Amount of remaining tokens allowed to spent
28     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
29 
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33 }
34 
35 contract StandardToken is Token {
36 
37     function transfer(address _to, uint256 _value) returns (bool success) {
38         //Default assumes totalSupply can't be over max (2^256 - 1).
39         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
40         //Replace the if with this one instead.
41         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
42         if (balances[msg.sender] >= _value && _value > 0) {
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             emit Transfer(msg.sender, _to, _value);
46             return true;
47         } else { return false; }
48     }
49 
50 
51     function balanceOf(address _owner) constant returns (uint256 balance) {
52         return balances[_owner];
53     }
54 
55     function approve(address _spender, uint256 _value) returns (bool success) {
56         allowed[msg.sender][_spender] = _value;
57         emit Approval(msg.sender, _spender, _value);
58         return true;
59     }
60 
61     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
62       return allowed[_owner][_spender];
63     }
64 
65     mapping (address => uint256) balances;
66     mapping (address => mapping (address => uint256)) allowed;
67     uint256 public totalSupply;
68 }
69 
70 contract USDCCoin is StandardToken { // CHANGE THIS. Update the contract name.
71 
72     /* Public variables of the token */
73 
74     /*
75     NOTE:
76     The following variables are OPTIONAL vanities. One does not have to include them.
77     They allow one to customize the token contract & in no way influences the core functionality.
78     Some wallets/interfaces might not even bother to look at this information.
79     */
80     string public name;                   // Token Name
81     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
82     string public symbol;                 // An identifier: eg SBX, XPR etc..
83     string public version = 'V1.0'; 
84     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
85     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
86     address public fundsWallet;           // Where should the raised ETH go?
87 
88     // This is a constructor function 
89     // which means the following function name has to match the contract name declared above
90     constructor() {
91 		totalSupply = 10000000000 * 100000000000000000; // Update total supply (1000 for example) (CHANGE THIS)
92         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
93                                
94         name = "USDC Coin";                                   // Set the name for display purposes (CHANGE THIS)
95         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
96         symbol = "USDC";                                             // Set the symbol for display purposes (CHANGE THIS)
97         unitsOneEthCanBuy = 10000;                                      // Set the price of your token for the ICO (CHANGE THIS)
98         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
99     }
100 
101     function() payable{
102         
103         require( false );
104         
105     }
106 
107     /* Approves and then calls the receiving contract */
108     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
109         allowed[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111 
112         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
113         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
114         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
115         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
116         return true;
117     }
118 	
119 	
120 	function _transfer(address _from, address _to, uint _value) internal {
121         // Prevent transfer to 0x0 address. Use burn() instead
122         require(_to != 0x0);
123         // Check if the sender has enough
124         require(balances[_from] >= _value);
125         // Check for overflows
126         require(balances[_to] + _value > balances[_to]);
127         // Subtract from the sender
128         balances[_from] -= _value;
129         // Add the same to the recipient
130         balances[_to] += _value;
131         emit Transfer(_from, _to, _value);
132     }
133 
134 
135     
136     // @dev if someone wants to transfer tokens to other account.
137     function transferTokens(address _to, uint256 _tokens) lockTokenTransferBeforeIco public {
138 		// _token in wei
139         _transfer(msg.sender, _to, _tokens);
140     }
141     
142     
143     modifier lockTokenTransferBeforeIco{
144         if(msg.sender != fundsWallet){
145            require(now > 1544184000); // Locking till starting date (ICO).
146         }
147         _;
148     }
149 }