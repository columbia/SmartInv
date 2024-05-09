1 pragma solidity ^0.4.4;
2 contract Token {
3     /// @return total amount of tokens
4     function totalSupply() public constant returns (uint256 supply) {}
5     /// @param _owner The address from which the balance will be retrieved
6     /// @return The balance
7     function balanceOf(address _owner) public constant returns (uint256 balance) {}
8     /// @notice send `_value` token to `_to` from `msg.sender`
9     /// @param _to The address of the recipient
10     /// @param _value The amount of token to be transferred
11     /// @return Whether the transfer was successful or not
12     function transfer(address _to, uint256 _value) public returns (bool success) {}
13     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
14     /// @param _from The address of the sender
15     /// @param _to The address of the recipient
16     /// @param _value The amount of token to be transferred
17     /// @return Whether the transfer was successful or not
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
19     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
20     /// @param _spender The address of the account able to transfer the tokens
21     /// @param _value The amount of wei to be approved for transfer
22     /// @return Whether the approval was successful or not
23     function approve(address _spender, uint256 _value) public returns (bool success) {}
24     /// @param _owner The address of the account owning tokens
25     /// @param _spender The address of the account able to transfer the tokens
26     /// @return Amount of remaining tokens allowed to spent
27     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 }
31 contract StandardToken is Token {
32     function transfer(address _to, uint256 _value) public returns (bool success) {
33         //Default assumes totalSupply can't be over max (2^256 - 1).
34         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
35         //Replace the if with this one instead.
36         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
37         if (balances[msg.sender] >= _value && _value > 0) {
38             balances[msg.sender] -= _value;
39             balances[_to] += _value;
40             Transfer(msg.sender, _to, _value);
41             return true;
42         } else { return false; }
43     }
44     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
45         //same as above. Replace this line with the following if you want to protect against wrapping uints.
46         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
47         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
48             balances[_to] += _value;
49             balances[_from] -= _value;
50             allowed[_from][msg.sender] -= _value;
51             Transfer(_from, _to, _value);
52             return true;
53         } else { return false; }
54     }
55     function balanceOf(address _owner) constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58     function approve(address _spender, uint256 _value) returns (bool success) {
59         allowed[msg.sender][_spender] = _value;
60         Approval(msg.sender, _spender, _value);
61         return true;
62     }
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
64       return allowed[_owner][_spender];
65     }
66     mapping (address => uint256) balances;
67     mapping (address => mapping (address => uint256)) allowed;
68     uint256 public totalSupply;
69 }
70 contract DividendCryptoFundToken is StandardToken { 
71     /* Public variables of the token */
72     /*
73     NOTE:
74     The following variables are OPTIONAL vanities. One does not have to include them.
75     They allow one to customise the token contract & in no way influences the core functionality.
76     Some wallets/interfaces might not even bother to look at this information.
77     */
78     string public name;                   // Token Name
79     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
80     string public symbol;                 // An identifier: eg SBX, XPR etc..
81     string public version = 'H1.0'; 
82     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
83     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
84     address public fundsWallet;           // Where should the raised ETH go?
85     // This is a constructor function 
86     // which means the following function name has to match the contract name declared above
87     function DividendCryptoFundToken() {
88         balances[msg.sender] = 100000;               
89         totalSupply = 100000;                        
90         name = "Dividend Crypto Fund Token";                                   
91         decimals = 1;                                               
92         symbol = "DCRF";                                             
93         unitsOneEthCanBuy = 1;                                      
94         fundsWallet = msg.sender;                                    
95     }
96     function() payable{
97         totalEthInWei = totalEthInWei + msg.value;
98         uint256 amount = msg.value * unitsOneEthCanBuy;
99         if (balances[fundsWallet] < amount) {
100             return;
101         }
102         balances[fundsWallet] = balances[fundsWallet] - amount;
103         balances[msg.sender] = balances[msg.sender] + amount;
104         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
105         //Transfer ether to fundsWallet
106         fundsWallet.transfer(msg.value);                               
107     }
108     /* Approves and then calls the receiving contract */
109     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
110         allowed[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
113         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
114         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
115         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
116         return true;
117     }
118 }