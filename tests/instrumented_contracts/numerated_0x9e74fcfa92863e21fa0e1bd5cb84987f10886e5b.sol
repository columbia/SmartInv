1 pragma solidity 0.4.12;
2 
3 contract ERC20TokenInterface {
4 
5     /// @return The total amount of tokens
6     function totalSupply() constant returns (uint256 supply);
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant public returns (uint256 balance);
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) public returns (bool success);
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
24 
25     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of tokens to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) public returns (bool success);
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 contract SmartEnergyToken is ERC20TokenInterface {
41 
42   //// Constants ////
43   string public constant name = 'Smart Energy';
44   uint256 public constant decimals = 6;
45   string public constant symbol = 'SET';
46   string public constant version = '1.0';
47   string public constant note = 'Blockchain for Energy';
48 
49   // One billion coins, each divided to up to 10^decimals units.
50   uint256 private constant totalTokens = 1000000000 * (10 ** decimals);
51 
52   mapping (address => uint256) public balances; // (ERC20)
53   // A mapping from an account owner to a map from approved spender to their allowances.
54   // (see ERC20 for details about allowances).
55   mapping (address => mapping (address => uint256)) public allowed; // (ERC20)
56 
57   //// Events ////
58   event MigrationInfoSet(string newMigrationInfo);
59 
60   // This is to be used when migration to a new contract starts.
61   // This string can be used for any authorative information re the migration
62   // (e.g. address to use for migration, or URL to explain where to find more info)
63   string public migrationInfo = "";
64 
65   // The only address that can set migrationContractAddress, a secure multisig.
66   address public migrationInfoSetter;
67 
68   //// Modifiers ////
69   modifier onlyFromMigrationInfoSetter {
70     if (msg.sender != migrationInfoSetter) {
71       throw;
72     }
73     _;
74   }
75 
76   //// Public functions ////
77   function SmartEnergy(address _migrationInfoSetter) {
78     if (_migrationInfoSetter == 0) throw;
79     migrationInfoSetter = _migrationInfoSetter;
80     // Upon creation, all tokens belong to the deployer.
81     balances[msg.sender] = totalTokens;
82   }
83 
84   // See ERC20
85   function totalSupply() constant returns (uint256) {
86     return totalTokens;
87   }
88 
89   // See ERC20
90   // WARNING: If you call this with the address of a contract, the contract will receive the
91   // funds, but will have no idea where they came from. Furthermore, if the contract is
92   // not aware of SET, the tokens will remain locked away in the contract forever.
93   // It is always recommended to call instead compareAndApprove() (or approve()) and have the
94   // receiving contract withdraw the money using transferFrom().
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     if (balances[msg.sender] >= _value) {
97       balances[msg.sender] -= _value;
98       balances[_to] += _value;
99       Transfer(msg.sender, _to, _value);
100       return true;
101     }
102     return false;
103   }
104 
105   // See ERC20
106   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
108       balances[_from] -= _value;
109       allowed[_from][msg.sender] -= _value;
110       balances[_to] += _value;
111       Transfer(_from, _to, _value);
112       return true;
113     }
114     return false;
115   }
116 
117   // See ERC20
118   function balanceOf(address _owner) constant public returns (uint256) {
119     return balances[_owner];
120   }
121 
122   // See ERC20
123   // NOTE: this method is vulnerable and is placed here only to follow the ERC20 standard.
124   // Before using, please take a look at the better compareAndApprove below.
125   function approve(address _spender, uint256 _value) public returns (bool) {
126     allowed[msg.sender][_spender] = _value;
127     Approval(msg.sender, _spender, _value);
128     return true;
129   }
130 
131   // A vulernability of the approve method in the ERC20 standard was identified by
132   // Miko Vainio here:
133   // https://drive.google.com/open?id=1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM
134   // It's better to use this method which is not susceptible to over-withdrawing by the approvee.
135   /// @param _spender The address to approve
136   /// @param _currentValue The previous value approved, which can be retrieved with allowance(msg.sender, _spender)
137   /// @param _newValue The new value to approve, this will replace the _currentValue
138   /// @return bool Whether the approval was a success (see ERC20's `approve`)
139   function compareAndApprove(address _spender, uint256 _currentValue, uint256 _newValue) public returns(bool) {
140     if (allowed[msg.sender][_spender] != _currentValue) {
141       return false;
142     }
143     return approve(_spender, _newValue);
144   }
145 
146   // See ERC20
147   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
148     return allowed[_owner][_spender];
149   }
150 
151   // Allows setting a descriptive string, which will aid any users in migrating their token
152   // to a newer version of the contract. This field provides a kind of 'double-layer' of
153   // authentication for any migration announcement, as it can only be set by PowerLedger.
154   /// @param _migrationInfo The information string to be stored on the contract
155   function setMigrationInfo(string _migrationInfo) onlyFromMigrationInfoSetter public {
156     migrationInfo = _migrationInfo;
157     MigrationInfoSet(_migrationInfo);
158   }
159 
160   // To be used if the migrationInfoSetter wishes to transfer the migrationInfoSetter
161   // permission to a new account, e.g. because of change in personnel, a concern that account
162   // may have been compromised etc.
163   /// @param _newMigrationInfoSetter The address of the new Migration Info Setter
164   function changeMigrationInfoSetter(address _newMigrationInfoSetter) onlyFromMigrationInfoSetter public {
165     migrationInfoSetter = _newMigrationInfoSetter;
166   }
167 }