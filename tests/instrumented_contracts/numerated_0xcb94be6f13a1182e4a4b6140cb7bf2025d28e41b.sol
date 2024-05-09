1 /**
2  *  TRST Trustcoin contract, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
3  *
4  *  Code is based on multiple sources:
5  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20.sol
6  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/StandardToken.sol
7  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/HumanStandardToken.sol
8  */
9 
10 // Abstract contract for the full ERC 20 Token standard
11 // https://github.com/ethereum/EIPs/issues/20
12 
13 // Based on https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/Token.sol
14 pragma solidity 0.4.8;
15 
16 contract ERC20TokenInterface {
17 
18     /// @return The total amount of tokens
19     function totalSupply() constant returns (uint256 supply);
20 
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) constant public returns (uint256 balance);
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 
38     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of tokens to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) public returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 contract Trustcoin is ERC20TokenInterface {
54 
55   //// Constants ////
56   string public constant name = 'Trustcoin';
57   uint256 public constant decimals = 6;
58   string public constant symbol = 'TRST';
59   string public constant version = 'TRST1.0';
60 
61   // One hundred million coins, each divided to up to 10^decimals units.
62   uint256 private constant totalTokens = 100000000 * (10 ** decimals);
63 
64   mapping (address => uint256) public balances; // (ERC20)
65   // A mapping from an account owner to a map from approved spender to their allowances.
66   // (see ERC20 for details about allowances).
67   mapping (address => mapping (address => uint256)) public allowed; // (ERC20)
68 
69   //// Events ////
70   event MigrationInfoSet(string newMigrationInfo);
71 
72   // This is to be used when migration to a new contract starts.
73   // This string can be used for any authorative information re the migration
74   // (e.g. address to use for migration, or URL to explain where to find more info)
75   string public migrationInfo = "";
76 
77   // The only address that can set migrationContractAddress, a secure multisig.
78   address public migrationInfoSetter;
79 
80   //// Modifiers ////
81   modifier onlyFromMigrationInfoSetter {
82     if (msg.sender != migrationInfoSetter) {
83       throw;
84     }
85     _;
86   }
87 
88   //// Public functions ////
89   function Trustcoin(address _migrationInfoSetter) {
90     if (_migrationInfoSetter == 0) throw;
91     migrationInfoSetter = _migrationInfoSetter;
92     // Upon creation, all tokens belong to the deployer.
93     balances[msg.sender] = totalTokens;
94   }
95 
96   // See ERC20
97   function totalSupply() constant returns (uint256) {
98     return totalTokens;
99   }
100 
101   // See ERC20
102   // WARNING: If you call this with the address of a contract, the contract will receive the
103   // funds, but will have no idea where they came from. Furthermore, if the contract is
104   // not aware of TRST, the tokens will remain locked away in the contract forever.
105   // It is always recommended to call instead compareAndApprove() (or approve()) and have the
106   // receiving contract withdraw the money using transferFrom().
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     if (balances[msg.sender] >= _value) {
109       balances[msg.sender] -= _value;
110       balances[_to] += _value;
111       Transfer(msg.sender, _to, _value);
112       return true;
113     }
114     return false;
115   }
116 
117   // See ERC20
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
120       balances[_from] -= _value;
121       allowed[_from][msg.sender] -= _value;
122       balances[_to] += _value;
123       Transfer(_from, _to, _value);
124       return true;
125     }
126     return false;
127   }
128 
129   // See ERC20
130   function balanceOf(address _owner) constant public returns (uint256) {
131     return balances[_owner];
132   }
133 
134   // See ERC20
135   // NOTE: this method is vulnerable and is placed here only to follow the ERC20 standard.
136   // Before using, please take a look at the better compareAndApprove below.
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   // A vulernability of the approve method in the ERC20 standard was identified by
144   // Mikhail Vladimirov and Dmitry Khovratovich here:
145   // https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM
146   // It's better to use this method which is not susceptible to over-withdrawing by the approvee.
147   /// @param _spender The address to approve
148   /// @param _currentValue The previous value approved, which can be retrieved with allowance(msg.sender, _spender)
149   /// @param _newValue The new value to approve, this will replace the _currentValue
150   /// @return bool Whether the approval was a success (see ERC20's `approve`)
151   function compareAndApprove(address _spender, uint256 _currentValue, uint256 _newValue) public returns(bool) {
152     if (allowed[msg.sender][_spender] != _currentValue) {
153       return false;
154     }
155     return approve(_spender, _newValue);
156   }
157 
158   // See ERC20
159   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163   // Allows setting a descriptive string, which will aid any users in migrating their token
164   // to a newer version of the contract. This field provides a kind of 'double-layer' of
165   // authentication for any migration announcement, as it can only be set by WeTrust.
166   /// @param _migrationInfo The information string to be stored on the contract
167   function setMigrationInfo(string _migrationInfo) onlyFromMigrationInfoSetter public {
168     migrationInfo = _migrationInfo;
169     MigrationInfoSet(_migrationInfo);
170   }
171 
172   // To be used if the migrationInfoSetter wishes to transfer the migrationInfoSetter
173   // permission to a new account, e.g. because of change in personnel, a concern that account
174   // may have been compromised etc.
175   /// @param _newMigrationInfoSetter The address of the new Migration Info Setter
176   function changeMigrationInfoSetter(address _newMigrationInfoSetter) onlyFromMigrationInfoSetter public {
177     migrationInfoSetter = _newMigrationInfoSetter;
178   }
179 }