1 pragma solidity ^0.4.4;
2 
3 contract Broodt {
4     // hallo dit is een cryptovaluta munt token genaamt: BROODT
5     // als je BROODT wil stuur dan helemaal niks naar het contract adress en je krijgt 1 BROODT gratis
6     // als je meer wilt dan moet je eth sturen of gewoon heel kut zijn en heel vaak niks sturen.
7     // 0.0001 eth = 1 BROODT
8     // alle ETH gaat naar mij en niet arno hahaha
9     // fb arno: https://www.facebook.com/Arnosplaatjevoorjou
10     // fijne dag gewenst grt.
11     
12     /// @return total amount of tokens
13     function totalSupply() constant returns (uint256 supply) {}
14 
15     /// @param _owner The address from which the balance will be retrieved
16     /// @return The balance
17     function balanceOf(address _owner) constant returns (uint256 balance) {}
18 
19     /// @notice send `_value` token to `_to` from `msg.sender`
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transfer(address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26     /// @param _from The address of the sender
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
31 
32     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @param _value The amount of wei to be approved for transfer
35     /// @return Whether the approval was successful or not
36     function approve(address _spender, uint256 _value) returns (bool success) {}
37 
38     /// @param _owner The address of the account owning tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @return Amount of remaining tokens allowed to spent
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46 }
47 
48 contract StandardToken is Broodt {
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
91     uint256 public totalSupply;
92 }
93 
94 contract ArnosMotiverendeTokensVoorOverdagEnSomsInDeNacht is StandardToken { // CHANGE THIS. Update the contract name.
95 
96     /* Public variables of the token */
97 
98     /*
99     NOTE:
100     The following variables are OPTIONAL vanities. One does not have to include them.
101     They allow one to customise the token contract & in no way influences the core functionality.
102     Some wallets/interfaces might not even bother to look at this information.
103     */
104     string public name;                 // Token Name
105     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
106     string public symbol;                // An identifier: eg SBX, XPR etc..
107     string public version = 'H1.0'; 
108     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
109     address public fundsWallet;           // Where should the raised ETH go?
110     uint256 public creatorReward;
111     address public contractWallet;
112     
113 
114     // This is a constructor function 
115     // which means the following function name has to match the contract name declared above
116     function ArnosMotiverendeTokensVoorOverdagEnSomsInDeNacht() {
117         creatorReward = 420;                                    // deze zijn voor mij
118         totalSupply = 420000;
119         balances[msg.sender] = creatorReward;                   
120         balances[address(this)] = totalSupply - creatorReward;  // store all the tokens in the contract
121         name = "ArnosMotiverendeTokensVoorOverdagEnSomsInDeNacht";// AAAAAA NEEEE GEEF BROODT
122         decimals = 0;                                           // wie wil nou 0.1 broodt zech nou eerlijk haha
123         symbol = "BROODT";                                      // had een bloedgroep B emoji geprobeert maar dat vond etherscan niet chill
124         unitsOneEthCanBuy = 10000;                              // send 1 eth and get 10000 broodt send 0.0001 eth and get 1 broodt
125         fundsWallet = msg.sender;                               // The owner of the contract gets ETH (dat ben ik en niet arno >:) )
126         contractWallet = address(this);                         // address that stores the tokens for ico
127     }
128 
129     function() payable{
130         //calculate how much BROODT the sender gets + 1 for free :)
131         uint256 amount = 1 + msg.value * unitsOneEthCanBuy/10**18;
132         //send eth back if there not enough tokens
133         if (balances[contractWallet] < amount) {
134             balances[msg.sender] = amount;
135             throw;
136             return;
137         }
138 
139         balances[contractWallet] -=  amount ;
140         balances[msg.sender] += amount;
141 
142         Transfer(contractWallet, msg.sender, amount); // Broadcast a message to the blockchain
143 
144         //Transfer ether to fundsWallet
145         fundsWallet.transfer(msg.value);                               
146     }
147 
148     /* Approves and then calls the receiving contract */
149     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
150         allowed[msg.sender][_spender] = _value;
151         Approval(msg.sender, _spender, _value);
152 
153         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
154         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
155         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
156         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
157         return true;
158     }
159 }