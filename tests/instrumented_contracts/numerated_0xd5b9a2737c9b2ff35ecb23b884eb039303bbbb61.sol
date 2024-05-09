1 /**
2  *  Beth token contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
3  *
4  *  Code is based on multiple sources:
5  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20.sol
6  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/Token.sol
7  */
8 
9 pragma solidity ^0.4.8;
10 
11 contract Token {
12     /* This is a slight change to the ERC20 base standard.
13     function totalSupply() constant returns (uint256 supply);
14     is replaced with:
15     uint256 public totalSupply;
16     This automatically creates a getter function for the totalSupply.
17     This is moved to the base contract since public getter functions are not
18     currently recognised as an implementation of the matching abstract
19     function by the compiler.
20     */
21     /// total amount of tokens
22     uint256 public totalSupply;
23 
24     /// @param _owner The address from which the balance will be retrieved
25     /// @return The balance
26     function balanceOf(address _owner) constant returns (uint256 balance);
27 
28     /// @notice send `_value` token to `_to` from `msg.sender`
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transfer(address _to, uint256 _value) returns (bool success);
33 
34     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
35     /// @param _from The address of the sender
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     /// @return Whether the transfer was successful or not
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
40 
41     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @param _value The amount of tokens to be approved for transfer
44     /// @return Whether the approval was successful or not
45     function approve(address _spender, uint256 _value) returns (bool success);
46 
47     /// @param _owner The address of the account owning tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @return Amount of remaining tokens allowed to spent
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 
56 contract Beth is Token {
57 
58     function () {
59         //if ether is sent to this address, send it back.
60         throw;
61     }
62      
63     address public owner;
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;
66     mapping (address => bool) public frozenAccount;
67 
68     //// Events ////
69     event MigrationInfoSet(string newMigrationInfo);
70     event FrozenFunds(address target, bool frozen);
71     
72     // This is to be used when migration to a new contract starts.
73     // This string can be used for any authorative information re the migration
74     // (e.g. address to use for migration, or URL to explain where to find more info)
75     string public migrationInfo = "";
76 
77     modifier onlyOwner{ if (msg.sender != owner) throw; _; }
78 
79     /* Public variables of the token */
80     string public name = "Beth";
81     uint8 public decimals = 18;
82     string public symbol = "BTH";
83     string public version = "1.0";
84 
85     bool private stopped = false;
86     modifier stopInEmergency { if (!stopped) _; }
87 
88     function Beth() {
89         owner = 0xa62dFc3a5bf6ceE820B916d5eF054A29826642e8;
90         balances[0xa62dFc3a5bf6ceE820B916d5eF054A29826642e8] = 2832955 * 1 ether;
91         totalSupply = 2832955* 1 ether;
92     }
93 
94 
95     function transfer(address _to, uint256 _value) stopInEmergency returns (bool success) {
96         if (frozenAccount[msg.sender]) throw;                // Check if frozen
97         if (balances[msg.sender] < _value) throw;
98         if (_value <= 0) throw;
99         balances[msg.sender] -= _value;
100         balances[_to] += _value;
101         Transfer(msg.sender, _to, _value);
102         return true;
103     }
104 
105     function transferFrom(address _from, address _to, uint256 _value) stopInEmergency  returns (bool success) {
106         if (frozenAccount[msg.sender]) throw;                // Check if frozen
107         if (balances[_from] < _value) throw;
108         if (allowed[_from][msg.sender] < _value) throw;
109         if (_value <= 0) throw;
110         balances[_to] += _value;
111         balances[_from] -= _value;
112         allowed[_from][msg.sender] -= _value;
113         Transfer(_from, _to, _value);
114         return true;
115     }
116 
117     function balanceOf(address _owner) constant returns (uint256 balance) {
118         return balances[_owner];
119     }
120 
121     function approve(address _spender, uint256 _value) returns (bool success) {
122         allowed[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
128         return allowed[_owner][_spender];
129     }
130 
131     /* Approves and then calls the receiving contract */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         
136         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
137         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
138             throw; 
139         }
140         return true;
141     }
142 
143     // Allows setting a descriptive string, which will aid any users in migrating their token
144     // to a newer version of the contract. This field provides a kind of 'double-layer' of
145     // authentication for any migration announcement, as it can only be set by WeTrust.
146     /// @param _migrationInfo The information string to be stored on the contract
147     function setMigrationInfo(string _migrationInfo) onlyOwner public {
148         migrationInfo = _migrationInfo;
149         MigrationInfoSet(_migrationInfo);
150     }
151 
152     // Owner can set any account into freeze state. It is helpful in case if account holder has 
153     // lost his key and he want administrator to freeze account until account key is recovered
154     // @param target The account address
155     // @param freeze The state of account
156     function freezeAccount(address target, bool freeze) onlyOwner {
157         frozenAccount[target] = freeze;
158         FrozenFunds(target, freeze);
159     }
160 
161     // It is called Circuit Breakers (Pause contract functionality), it stop execution if certain conditions are met, 
162     // and can be useful when new errors are discovered. For example, most actions may be suspended in a contract if a 
163     // bug is discovered, so the most feasible option to stop and updated migration message about launching an updated version of contract. 
164     // @param _stop Switch the circuite breaker on or off
165     function emergencyStop(bool _stop) onlyOwner {
166         stopped = _stop;
167     }
168 
169     // changeOwner is used to change the administrator of the contract. This can be useful if owner account is suspected to be compromised
170     // and you have luck to update owner.
171     // @param _newOwner Address of new owner
172     function changeOwner(address _newOwner) onlyOwner {
173         balances[_newOwner] = balances[owner];
174         balances[owner] = 0;
175         owner = _newOwner;
176         Transfer(owner, _newOwner,balances[_newOwner]);
177     }
178 
179 }