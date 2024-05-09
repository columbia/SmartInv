1 /************************************************************************************
2 This is the source code for the XGT token written in Solidity language.				*
3 This token is based on ERC20 specification 											*	
4 								*
5 Version 1.0																			*
6 									
7 Date: 13-Apr-2018																	*
8 ************************************************************************************/
9 
10 
11 pragma solidity ^0.4.21;
12 contract Token {
13     /// @return total amount of tokens
14     function totalSupply() constant public returns (uint256 supply) {}
15     /// @param _owner The address from which the balance will be retrieved
16     /// @return The balance
17     function balanceOf(address _owner) constant public returns (uint256 balance) {}
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) public returns (bool success) {}
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
29     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of wei to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint256 _value) public returns (bool success) {}
34     /// @param _owner The address of the account owning tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @return Amount of remaining tokens allowed to spent
37     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {}
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 contract StandardToken is Token {
42     address public owner; //added for customization
43 	/************************************************************************************
44 	This function transfers the value specified in _value to the specified address _to.	
45 	************************************************************************************/
46     function transfer(address _to, uint256 _value) public returns (bool success) {
47         if (balances[msg.sender] >= _value && _value > 0 
48 			&& balances[_to] + _value > balances[_to]) {  // This condition is to avoid integer overflow - for customization
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             //Transfer(msg.sender, _to, _value);
52             emit Transfer(msg.sender, _to, _value); //Above transfer call is deprecated for customization
53             return true;
54         } else { return false; }
55     }
56 	/************************************************************************************
57 	This function transfers the value specified in _value from the address _from to 
58 	the specified address _to.	
59 	************************************************************************************/
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 
62 			&& balances[_to] + _value > balances[_to]) {  // This condition is to avoid integer overflow - for customization
63             balances[_to] += _value;  
64             balances[_from] -= _value;
65             allowed[_from][msg.sender] -= _value;
66             //Transfer(_from, _to, _value);
67             emit  Transfer(_from, _to, _value); //Above transfer call is deprecated for customization
68             return true;
69         } else { return false; }
70     }
71     //function balanceOf(address _owner) constant returns (uint256 balance) {
72 	function balanceOf(address _owner) public constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75     
76     
77     function totalSupply() constant public returns (uint256 supply) {
78         return _totalSupply;
79     }
80     
81     function approve(address _spender, uint256 _value) onlyOwner public returns (bool success) { //onlyOwner restrcts the token owner to make transactions -- for customization
82         allowed[msg.sender][_spender] = _value;
83         //Approval(msg.sender, _spender, _value);
84         emit Approval(msg.sender, _spender, _value); // Above Approval function is deprecated. for customization
85         return true;
86     }
87     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
88       return allowed[_owner][_spender];
89     }
90     
91     /************************************************************************************
92 	This function will be called from Approve.
93 	************************************************************************************/
94 	modifier onlyOwner
95 	{
96 		require(msg.sender == owner);
97 		_;
98 	}
99 	
100     mapping (address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102     //uint256 public totalSupply;
103 	uint256  _totalSupply;
104 }
105 contract XGTToken is StandardToken { // XGTToken is the name of the contract to be deployed on the blockchain
106     /* Public variables of the token */
107     //string public name;                   // Token Name
108 	string public constant name="XGT";                   // Token Name
109     //uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
110 	uint8 public constant decimals=18;                // How many decimals to show. To be standard complicant keep it 18
111     string public constant symbol="XGT";                 // An identifier: eg SBX, XPR etc..
112     string public version = 'J1.0'; 
113     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
114     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
115     address public fundsWallet;           // Where should the raised ETH go?
116 
117     function XGTToken() public  {
118         balances[msg.sender] 	= 150000000000000000000000000;        
119         _totalSupply          	= 150000000000000000000000000;               
120                                                
121         unitsOneEthCanBuy = 180;                             
122         fundsWallet = msg.sender;   
123 		owner = msg.sender; 
124     }
125     function() public payable{
126         totalEthInWei = totalEthInWei + msg.value;
127         uint256 amount = msg.value * unitsOneEthCanBuy;
128         if (balances[fundsWallet] < amount) {
129             return;
130         }
131         balances[fundsWallet] = balances[fundsWallet] - amount;
132         balances[msg.sender] = balances[msg.sender] + amount;
133         //Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
134         emit Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
135         //Transfer ether to fundsWallet
136         fundsWallet.transfer(msg.value);                               
137     }
138     /* Approves and then calls the receiving contract */
139     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
140         allowed[msg.sender][_spender] = _value;
141         //Approval(msg.sender, _spender, _value);
142         emit Approval(msg.sender, _spender, _value);
143         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
144         return true;
145     }
146 	
147 }