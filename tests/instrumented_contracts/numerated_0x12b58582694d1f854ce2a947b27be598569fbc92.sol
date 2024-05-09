1 pragma solidity ^0.4.0;
2 
3  
4 contract Token {
5  
6     /// @return total amount of tokens
7     function totalSupply() public constant returns (uint256 supply) {}
8  
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) public constant returns (uint256 balance) {}
12  
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) public returns (bool success) {}
18  
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
25  
26     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of wei to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) public returns (bool success) {}
31  
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
36  
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39    
40 }
41  
42  
43  
44 contract StandardToken is Token {
45  
46     function transfer(address _to, uint256 _value) public returns (bool success) {
47         //Default assumes totalSupply can't be over max (2^256 - 1).
48         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
49         //Replace the if with this one instead.
50         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
51         if (balances[msg.sender] >= _value && _value > 0) {
52             balances[msg.sender] -= _value;
53             balances[_to] += _value;
54             Transfer(msg.sender, _to, _value);
55             return true;
56         } else { return false; }
57     }
58  
59     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
60         //same as above. Replace this line with the following if you want to protect against wrapping uints.
61         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
62         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
63             balances[_to] += _value;
64             balances[_from] -= _value;
65             allowed[_from][msg.sender] -= _value;
66             Transfer(_from, _to, _value);
67             return true;
68         } else { return false; }
69     }
70  
71     function balanceOf(address _owner) public constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74  
75     function approve(address _spender, uint256 _value) public returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80  
81     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
82       return allowed[_owner][_spender];
83     }
84  
85     mapping (address => uint256) balances;
86     mapping (address => mapping (address => uint256)) allowed;
87     uint256 public totalSupply;
88 }
89  
90  
91 contract SeneroToken is StandardToken {
92  
93     function () public {
94         //if ether is sent to this address, send it back.
95         revert();
96     }
97  
98     /* Public variables of the token */
99  
100     /*
101     NOTE:
102     The following variables are OPTIONAL vanities. One does not have to include them.
103     They allow one to customise the token contract & in no way influences the core functionality.
104     Some wallets/interfaces might not even bother to look at this information.
105     */
106     string public name;                   //Token name
107     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 token = 980 base units. It's like comparing 1 wei to 1 ether.
108     string public symbol;                 //An identifier
109     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
110  
111    
112     function SeneroToken(
113         ) public {
114        
115         balances[0xAf468Bcc3B923C6d5588b9f3032a042Eb4ca4F60] = 259600; // A
116         balances[0x6ddD1c854EbAfFdb4bFf8CF8334871612A314285] = 178200; // sendev
117         balances[0x1B355DEB18bE4B579E4F1272cFc9958b2B0C5d49] = 209000; // twochain
118         balances[0xD0cc81a97737E02F9466eF51E4DDEf6D02D30a75] = 259600; // stackmoon
119         // balances[] = 198000; // Radman29
120         balances[0x96fa4CBb4869eFdFEC0C97f1178CA02da4CFe084] = 209000; // steak_e
121         balances[0x143efe51524f53274fE120e69C761774a3e5d570] = 169400; // RanxShin
122         // balances[] = 110000; // xchain
123         balances[0x0b1ae337a9d0f62c9026effcfdcee442e3ce31e6] = 178200; // marihang
124         balances[0xc62f738afab6fbce2cbc7f0fd274858cdc4a1448] = 158400; // jimbojones3000
125         balances[0xa510184cB3C83021253d7DD48FD28035ccEB4af4] = 270600; // Smoxer
126        
127        
128         balances[msg.sender] = 17800000;           // Rest of the coins
129         totalSupply = 20000000;                    // Update total supply (100000 for example)
130         name = "Senero";                           // Set the name for display purposes
131         decimals = 18;                             // Amount of decimals for display purposes
132         symbol = "SEN";                            // Set the symbol for display purposes
133     }
134  
135     /* Approves and then calls the receiving contract */
136     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
137         allowed[msg.sender][_spender] = _value;
138         Approval(msg.sender, _spender, _value);
139  
140         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
141         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
142         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
143         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
144         return true;
145     }
146 }