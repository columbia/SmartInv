1 pragma solidity ^0.4.23;
2 
3 contract ERC20TokenInterface {
4 
5     /// @return The total amount of tokens
6     function totalSupply() public constant returns (uint256 supply);
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
40 contract BitCar is ERC20TokenInterface {
41 	
42   function () public {
43     //if ether is sent to this address, send it back.
44     revert();
45   }
46 
47   //// Constants ////
48   string public constant name = 'BitCar';
49   uint256 public constant decimals = 8;
50   string public constant symbol = 'BITCAR';
51   string public constant version = '1.0';
52   string public constant note = 'If you can dream it, you can do it. Enzo Ferrari';
53 
54   // 500 million coins, each divided to up to 10^decimals units.
55   uint256 private constant totalTokens = 500000000 * (10 ** decimals);
56 
57   mapping (address => uint256) public balances; // (ERC20)
58   // A mapping from an account owner to a map from approved spender to their allowances.
59   // (see ERC20 for details about allowances).
60   mapping (address => mapping (address => uint256)) public allowed; // (ERC20)
61 
62   //// Events ////
63   event MigrationInfoSet(string newMigrationInfo);
64 
65   // This is to be used when migration to a new contract starts.
66   // This string can be used for any authorative information re the migration
67   // (e.g. address to use for migration, or URL to explain where to find more info)
68   string public migrationInfo = "";
69 
70   // The only address that can set migrationContractAddress, a secure multisig.
71   address public migrationInfoSetter;
72 
73   //// Modifiers ////
74   modifier onlyFromMigrationInfoSetter {
75     if (msg.sender != migrationInfoSetter) {
76       revert();
77     }
78     _;
79   }
80 
81   //// Public functions ////
82   constructor(address _migrationInfoSetter) public {
83     if (_migrationInfoSetter == 0) revert();
84     migrationInfoSetter = _migrationInfoSetter;
85     // Upon creation, all tokens belong to the deployer.
86     balances[msg.sender] = totalTokens;
87   }
88 
89   // See ERC20
90   function totalSupply() public constant returns (uint256) {
91     return totalTokens;
92   }
93 
94   // See ERC20
95   // WARNING: If you call this with the address of a contract, the contract will receive the
96   // funds, but will have no idea where they came from. Furthermore, if the contract is
97   // not aware of POWR, the tokens will remain locked away in the contract forever.
98   // It is always recommended to call instead compareAndApprove() (or approve()) and have the
99   // receiving contract withdraw the money using transferFrom().
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     if (balances[msg.sender] >= _value) {
102       balances[msg.sender] -= _value;
103       balances[_to] += _value;
104       emit Transfer(msg.sender, _to, _value);
105       return true;
106     }
107     return false;
108   }
109 
110   // See ERC20
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
113       balances[_from] -= _value;
114       allowed[_from][msg.sender] -= _value;
115       balances[_to] += _value;
116       emit Transfer(_from, _to, _value);
117       return true;
118     }
119     return false;
120   }
121 
122   // See ERC20
123   function balanceOf(address _owner) constant public returns (uint256) {
124     return balances[_owner];
125   }
126 
127   // See ERC20
128   // NOTE: this method is vulnerable and is placed here only to follow the ERC20 standard.
129   // Before using, please take a look at the better compareAndApprove below.
130   function approve(address _spender, uint256 _value) public returns (bool) {
131     allowed[msg.sender][_spender] = _value;
132     emit Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136   // A vulernability of the approve method in the ERC20 standard was identified by
137   // Mikhail Vladimirov and Dmitry Khovratovich here:
138   // https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM
139   // It's better to use this method which is not susceptible to over-withdrawing by the approvee.
140   /// @param _spender The address to approve
141   /// @param _currentValue The previous value approved, which can be retrieved with allowance(msg.sender, _spender)
142   /// @param _newValue The new value to approve, this will replace the _currentValue
143   /// @return bool Whether the approval was a success (see ERC20's `approve`)
144   function compareAndApprove(address _spender, uint256 _currentValue, uint256 _newValue) public returns(bool) {
145     if (allowed[msg.sender][_spender] != _currentValue) {
146       return false;
147     }
148     return approve(_spender, _newValue);
149   }
150 
151   // See ERC20
152   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
153     return allowed[_owner][_spender];
154   }
155 
156   // Allows setting a descriptive string, which will aid any users in migrating their token
157   // to a newer version of the contract. This field provides a kind of 'double-layer' of
158   // authentication for any migration announcement, as it can only be set by BitCar.
159   /// @param _migrationInfo The information string to be stored on the contract
160   function setMigrationInfo(string _migrationInfo) onlyFromMigrationInfoSetter public {
161     migrationInfo = _migrationInfo;
162     emit MigrationInfoSet(_migrationInfo);
163   }
164 
165   // To be used if the migrationInfoSetter wishes to transfer the migrationInfoSetter
166   // permission to a new account, e.g. because of change in personnel, a concern that account
167   // may have been compromised etc.
168   /// @param _newMigrationInfoSetter The address of the new Migration Info Setter
169   function changeMigrationInfoSetter(address _newMigrationInfoSetter) onlyFromMigrationInfoSetter public {
170     migrationInfoSetter = _newMigrationInfoSetter;
171   }
172 }