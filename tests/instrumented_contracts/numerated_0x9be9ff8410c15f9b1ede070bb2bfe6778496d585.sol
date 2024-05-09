1 pragma solidity ^0.4.24;
2 
3 // File: zos-lib/contracts/migrations/Migratable.sol
4 
5 /**
6  * @title Migratable
7  * Helper contract to support intialization and migration schemes between
8  * different implementations of a contract in the context of upgradeability.
9  * To use it, replace the constructor with a function that has the
10  * `isInitializer` modifier starting with `"0"` as `migrationId`.
11  * When you want to apply some migration code during an upgrade, increase
12  * the `migrationId`. Or, if the migration code must be applied only after
13  * another migration has been already applied, use the `isMigration` modifier.
14  * This helper supports multiple inheritance.
15  * WARNING: It is the developer's responsibility to ensure that migrations are
16  * applied in a correct order, or that they are run at all.
17  * See `Initializable` for a simpler version.
18  */
19 contract Migratable {
20   /**
21    * @dev Emitted when the contract applies a migration.
22    * @param contractName Name of the Contract.
23    * @param migrationId Identifier of the migration applied.
24    */
25   event Migrated(string contractName, string migrationId);
26 
27   /**
28    * @dev Mapping of the already applied migrations.
29    * (contractName => (migrationId => bool))
30    */
31   mapping (string => mapping (string => bool)) internal migrated;
32 
33   /**
34    * @dev Internal migration id used to specify that a contract has already been initialized.
35    */
36   string constant private INITIALIZED_ID = "initialized";
37 
38 
39   /**
40    * @dev Modifier to use in the initialization function of a contract.
41    * @param contractName Name of the contract.
42    * @param migrationId Identifier of the migration.
43    */
44   modifier isInitializer(string contractName, string migrationId) {
45     validateMigrationIsPending(contractName, INITIALIZED_ID);
46     validateMigrationIsPending(contractName, migrationId);
47     _;
48     emit Migrated(contractName, migrationId);
49     migrated[contractName][migrationId] = true;
50     migrated[contractName][INITIALIZED_ID] = true;
51   }
52 
53   /**
54    * @dev Modifier to use in the migration of a contract.
55    * @param contractName Name of the contract.
56    * @param requiredMigrationId Identifier of the previous migration, required
57    * to apply new one.
58    * @param newMigrationId Identifier of the new migration to be applied.
59    */
60   modifier isMigration(string contractName, string requiredMigrationId, string newMigrationId) {
61     require(isMigrated(contractName, requiredMigrationId), "Prerequisite migration ID has not been run yet");
62     validateMigrationIsPending(contractName, newMigrationId);
63     _;
64     emit Migrated(contractName, newMigrationId);
65     migrated[contractName][newMigrationId] = true;
66   }
67 
68   /**
69    * @dev Returns true if the contract migration was applied.
70    * @param contractName Name of the contract.
71    * @param migrationId Identifier of the migration.
72    * @return true if the contract migration was applied, false otherwise.
73    */
74   function isMigrated(string contractName, string migrationId) public view returns(bool) {
75     return migrated[contractName][migrationId];
76   }
77 
78   /**
79    * @dev Initializer that marks the contract as initialized.
80 
81    * For more information see https://github.com/zeppelinos/zos-lib/issues/158.
82    */
83   function initialize() isInitializer("Migratable", "1.2.1") public {
84   }
85 
86   /**
87    * @dev Reverts if the requested migration was already executed.
88    * @param contractName Name of the contract.
89    * @param migrationId Identifier of the migration.
90    */
91   function validateMigrationIsPending(string contractName, string migrationId) private view {
92     require(!isMigrated(contractName, migrationId), "Requested target migration ID has already been run");
93   }
94 }
95 
96 // File: openzeppelin-zos/contracts/ownership/Ownable.sol
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable is Migratable {
104   address public owner;
105 
106 
107   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109   /**
110    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
111    * account.
112    */
113   function initialize(address _sender) public isInitializer("Ownable", "1.9.0") {
114     owner = _sender;
115   }
116 
117   /**
118    * @dev Throws if called by any account other than the owner.
119    */
120   modifier onlyOwner() {
121     require(msg.sender == owner);
122     _;
123   }
124 
125   /**
126    * @dev Allows the current owner to transfer control of the contract to a newOwner.
127    * @param newOwner The address to transfer ownership to.
128    */
129   function transferOwnership(address newOwner) public onlyOwner {
130     require(newOwner != address(0));
131     emit OwnershipTransferred(owner, newOwner);
132     owner = newOwner;
133   }
134 
135 }
136 
137 // File: openzeppelin-zos/contracts/token/ERC20/ERC20Basic.sol
138 
139 /**
140  * @title ERC20Basic
141  * @dev Simpler version of ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/179
143  */
144 contract ERC20Basic {
145   function totalSupply() public view returns (uint256);
146   function balanceOf(address who) public view returns (uint256);
147   function transfer(address to, uint256 value) public returns (bool);
148   event Transfer(address indexed from, address indexed to, uint256 value);
149 }
150 
151 // File: contracts/NaviTokenBurner.sol
152 
153 /**
154  * @title NaviTokenBurner contract
155  */
156 contract NaviTokenBurner is Ownable {
157 
158   event TokensBurned (uint256 amount);
159 
160   ERC20Basic public token;
161 
162   constructor(ERC20Basic _token) public {
163     token = _token;
164   }
165 
166   function tokenDestroy() public onlyOwner{
167     require(token.balanceOf(this) > 0);
168     selfdestruct(owner);
169 
170     emit TokensBurned(token.balanceOf(this));
171   }
172 
173   function () public payable {
174     revert();
175   }
176 
177 }