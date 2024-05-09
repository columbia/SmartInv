1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.4;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint);
7     function balanceOf(address account) external view returns (uint);
8     function transfer(address recipient, uint amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
10     function allowance(address owner, address spender) external view returns (uint);
11     function approve(address spender, uint amount) external returns (bool);
12 
13     event Transfer(address indexed from, address indexed to, uint value);
14     event Approval(address indexed owner, address indexed spender, uint value);
15 }
16 
17 contract Ownable {
18     
19     /// @notice The owner of the contract
20     address public owner;
21     
22     /// @notice Event to notify when the ownership of this contract changed
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25     /// @notice Set the owner of this contract to its creator
26     constructor () {
27         owner = msg.sender;
28         emit OwnershipTransferred(address(0), msg.sender);
29     }
30     
31     modifier onlyOwner() {
32         require(owner == msg.sender, "caller is not the owner");
33         _;
34     }
35 
36     /**
37      * @notice Transfer ownership to `newOwner`
38      * @param newOwner The address to transfer the ownership to
39      */
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0), "new owner is the zero address");
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 
47 contract TokenMigrator is Ownable {
48     
49     /// @notice Token to migrate from
50     IERC20 public fromToken;
51     
52     /// @notice Token to migrate to
53     IERC20 public toToken;
54     
55     /// @notice The address where fromToken should be burned
56     address public constant BURN_ADDRESS = 0x0000000000000000000000000000000000000008;
57     
58     /// @notice Notice period before migration can be closed
59     uint256 public constant endMigrationNoticePeriod = 2 weeks;
60 
61     /// @notice Flag that indicates whether migration is possible
62     bool public migrationEnabled = false;
63     
64     /// @notice The migration end date
65     uint256 public endMigrationDate = type(uint256).max;
66     
67     /// @notice Event to notify when the endMigrationDate is set
68     event CloseMigrationNotice(uint256 epochTime);
69     
70     /**
71      * @notice Construct a Migration contract
72      * @param migrateFromToken The token to migrate from
73      * @param migrateToToken The token to migrate into
74      */
75     constructor(address migrateFromToken, address migrateToToken) {
76         fromToken = IERC20(migrateFromToken);
77         toToken = IERC20(migrateToToken);
78     }
79     
80     modifier whenMigrationEnabled() {
81         require(migrationEnabled, "migration not enabled");
82         _;
83     }
84     
85     /**
86      * @notice Start the migration. Can only be called if this contract has enough balance of toToken
87      */
88     function startMigration() public {
89         uint256 requiredToTokenBalance = fromToken.totalSupply() - fromToken.balanceOf(BURN_ADDRESS);
90         
91         require(toToken.balanceOf(address(this)) >= requiredToTokenBalance, "not enough toToken balance");
92         
93         migrationEnabled = true;
94     }
95     
96     /**
97      * @notice Migrate `amount` of tokens
98      * @param amount How many tokens to migrate
99      */
100     function migrate(uint256 amount) public whenMigrationEnabled returns (bool success) {
101         require(fromToken.transferFrom(msg.sender, BURN_ADDRESS, amount), "burning fromToken failed");
102         require(toToken.transfer(msg.sender, amount), "sending toToken failed");
103         
104         return true;
105     }
106     
107     /**
108      * @notice Announce the migration can be closed after `endMigrationNoticePeriod` 
109      */
110     function announceMigrationEnd() public onlyOwner whenMigrationEnabled {
111         endMigrationDate = block.timestamp + endMigrationNoticePeriod;
112         emit CloseMigrationNotice(endMigrationDate);
113     }
114     
115     /**
116      * @notice End the migration period. Can only be called after `endMigrationDate`
117      *  This also transfers the remainingBalance of toToken back to the owner
118      */
119     function closeMigration() public onlyOwner whenMigrationEnabled {
120         require(block.timestamp > endMigrationDate, "migration cannot be closed yet");
121         migrationEnabled = false;
122         uint256 remainingBalance = toToken.balanceOf(address(this));
123         require(toToken.transfer(owner, remainingBalance), "recovering toToken failed");
124     }
125 }