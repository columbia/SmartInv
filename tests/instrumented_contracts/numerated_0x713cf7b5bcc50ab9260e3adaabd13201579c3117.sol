1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 abstract contract Ownable is Context {
14     address private _owner;
15     
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor() {
23         _setOwner(_msgSender());
24     }
25 
26     /**
27      * @dev Returns the address of the current owner.
28      */
29     function owner() public view virtual returns (address) {
30         return _owner;
31     }
32 
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         require(owner() == _msgSender(), "Ownable: caller is not the owner");
38         _;
39     }
40 
41     /**
42      * @dev Leaves the contract without owner. It will not be possible to call
43      * `onlyOwner` functions anymore. Can only be called by the current owner.
44      *
45      * NOTE: Renouncing ownership will leave the contract without an owner,
46      * thereby removing any functionality that is only available to the owner.
47      */
48     function renounceOwnership() public virtual onlyOwner {
49         _setOwner(address(0));
50     }
51 
52     /**
53      * @dev Transfers ownership of the contract to a new account (`newOwner`).
54      * Can only be called by the current owner.
55      */
56     function transferOwnership(address newOwner) public virtual onlyOwner {
57         require(newOwner != address(0), "Ownable: new owner is the zero address");
58         _setOwner(newOwner);
59     }
60 
61     function _setOwner(address newOwner) private {
62         address oldOwner = _owner;
63         _owner = newOwner;
64         emit OwnershipTransferred(oldOwner, newOwner);
65     }
66    
67 }
68 interface IERC20 {
69     
70     function totalSupply() external view returns (uint256);
71    
72     function balanceOf(address account) external view returns (uint256);
73    
74     function transfer(address recipient, uint256 amount) external returns (bool);
75    
76     function allowance(address owner, address spender) external view returns (uint256);
77  
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     function transferFrom(address sender,address recipient,uint256 amount) external returns (bool); 
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 contract Migration is Ownable{
87     IERC20 public tokenToMigrateAddress = IERC20(0xa83055eaa689E477e7b2173eD7E3b55654b3A1f0); 
88     IERC20 public newToken = IERC20(0x6bb570C82C493135cc137644b168743Dc1F7eb12);
89     mapping (address => bool) public admins;
90     mapping(address => bool) public isWhitelisted;
91     bool private migrationActive = true;
92     event userAdded(address addedAddress,uint256 timestamp,address author);
93     event tokensMigrated(uint256 tokensMigrated, address userMigrated,uint256 timestamp);
94      function addAdmin(address newAdmin) public onlyOwner{
95         admins[newAdmin]=true;
96     }
97 
98     function addToWhitelistAdmin(address newAddress) external{
99         require(admins[msg.sender]==true,"Only admin function");
100         isWhitelisted[newAddress]=true;
101         emit userAdded(newAddress, block.timestamp, msg.sender);
102 
103     }
104     function addToWhitelistOwner(address newAddress) public onlyOwner{
105     isWhitelisted[newAddress]=true;
106     emit userAdded(newAddress, block.timestamp, msg.sender);
107 
108     }
109     function migrateTokens(uint256 tokenAmount)public{
110         require(migrationActive,"migration not in progress come back soon");
111         require(isWhitelisted[msg.sender],"You are not in the list");
112         require(tokenToMigrateAddress.balanceOf(msg.sender)>0,"Cant migrate not enough funds");
113         tokenToMigrateAddress.transferFrom(msg.sender,address(this),tokenAmount);
114         newToken.transfer(msg.sender,tokenAmount);
115         emit tokensMigrated(tokenAmount, msg.sender, block.timestamp);
116     }
117     function whitelistMultipleAddresses(address [] memory accounts, bool isWhitelist) public onlyOwner{
118         for(uint256 i = 0; i < accounts.length; i++) {
119             isWhitelisted[accounts[i]] = isWhitelist;
120         }
121     }
122     function returnCurrentTokenBalance()public view returns(uint256){
123         return newToken.balanceOf(address(this));
124     }
125     function sendOldTokensToAddress(address payable destination,IERC20 tokenAddress) public onlyOwner{
126         //require(tokenAddress.balanceOf(address(this))>0,"not enough balance here");
127         uint256 currentTokens = tokenAddress.balanceOf(address(this));
128         tokenAddress.transfer(destination,currentTokens);
129     }
130     function checkIfWhitelisted(address newAddress)public view returns (bool){
131         return isWhitelisted[newAddress];
132 
133     }
134     function updateNewToken(IERC20 updateToken) public onlyOwner{
135         newToken = IERC20(updateToken);
136 
137     }
138       function updatetokenToMigrate(IERC20 updateToken) public onlyOwner{
139         tokenToMigrateAddress = IERC20(updateToken);
140 
141     }
142     function pauseMigration(bool _isPaused) public onlyOwner{
143         migrationActive=_isPaused;
144     }
145      function pauseMigrationAdmin(bool _isPaused) public onlyOwner{
146          require(admins[msg.sender],"Only admin function");
147          migrationActive=_isPaused;
148     }
149     function isMigrationActive() public view returns(bool){
150         return migrationActive;
151     }
152 
153 
154 
155 
156 }