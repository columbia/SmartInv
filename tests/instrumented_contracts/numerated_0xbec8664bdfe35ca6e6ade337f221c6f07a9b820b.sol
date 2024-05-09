1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address private _owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     constructor () internal {
19         _owner = msg.sender;
20         emit OwnershipTransferred(address(0), _owner);
21     }
22 
23     /**
24      * @return the address of the owner.
25      */
26     function owner() public view returns (address) {
27         return _owner;
28     }
29 
30     /**
31      * @dev Throws if called by any account other than the owner.
32      */
33     modifier onlyOwner() {
34         require(isOwner());
35         _;
36     }
37 
38     /**
39      * @return true if `msg.sender` is the owner of the contract.
40      */
41     function isOwner() public view returns (bool) {
42         return msg.sender == _owner;
43     }
44 
45     /**
46      * @dev Allows the current owner to relinquish control of the contract.
47      * @notice Renouncing to ownership will leave the contract without an owner.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 interface DSFeed {
76     function read()
77     external
78     view
79     returns (bytes32);
80 }
81 
82 contract OracleRegistry is Ownable {
83 
84 
85     address payable private _networkWallet;
86     address private _networkExecutor;
87 
88     // 0.005 ETH as Wei(.5%)
89     uint256 public baseFee = uint256(0x0000000000000000000000000000000000000000000000000011c37937e08000);
90 
91     mapping(address => bool) public isWhitelisted;
92     mapping(uint256 => address) public oracles;
93     mapping(address => mapping(address => uint256)) public splitterToFee;
94 
95 
96     event OracleActivated(address oracleFeed, uint256 currencyPair);
97     event FeeChanged(address merchantModule, address asset, uint256 newFee);
98 
99     /// @dev Setup function sets initial storage of contract.
100     /// @param _oracles List of whitelisted oracles.
101     function setup(
102         address[] memory _oracles,
103         uint256[] memory _currencyPair,
104         address payable[] memory _networkSettings
105     )
106     public
107     onlyOwner
108     {
109         require(_oracles.length == _currencyPair.length);
110 
111         for (uint256 i = 0; i < _oracles.length; i++) {
112             addToWhitelist(_oracles[i], _currencyPair[i]);
113         }
114 
115         require(_networkSettings.length == 2, "OracleResigstry::setup INVALID_DATA: NETWORK_SETTINGS_LENGTH");
116 
117         require(_networkWallet == address(0), "OracleResigstry::setup INVALID_STATE: NETWORK_WALLET_SET");
118 
119         _networkWallet = _networkSettings[0];
120 
121         require(_networkExecutor == address(0), "OracleResigstry::setup INVALID_STATE: NETWORK_EXECUTOR_SET");
122 
123         _networkExecutor = _networkSettings[1];
124     }
125 
126     function setFee(
127         address[] memory merchantModule,
128         address[] memory assetOfExchange,
129         uint256[] memory newFee
130     )
131     public
132     onlyOwner
133     returns
134     (bool) {
135 
136         for (uint256 i = 0; i < merchantModule.length; i++) {
137             address merchant = merchantModule[i];
138             address asset = assetOfExchange[i];
139             uint256 assetFee = newFee[i];
140             require(merchant != address(0), "OracleRegistry::setup INVALID_DATA: MERCHANT_MODULE_ADDR");
141             require(asset != address(0), "OracleRegistry::setup INVALID_DATA: ASSET_ADDR");
142 
143             splitterToFee[merchant][asset] = assetFee;
144 
145             emit FeeChanged(merchant, asset, assetFee);
146         }
147     }
148 
149     function read(
150         uint256 currencyPair
151     ) public view returns (bytes32) {
152         address orl = oracles[currencyPair];
153         require(isWhitelisted[orl], "INVALID_DATA: CURRENCY_PAIR");
154         return DSFeed(orl).read();
155     }
156 
157     /// @dev Allows to add destination to whitelist. This can only be done via a Safe transaction.
158     /// @param oracle Destination address.
159     function addToWhitelist(address oracle, uint256 currencyPair)
160     public
161     onlyOwner
162     {
163         require(!isWhitelisted[oracle], "OracleResigstry::addToWhitelist INVALID_STATE: ORACLE_WHITELIST");
164         require(oracle != address(0), "OracleResigstry::addToWhitelist INVALID_DATA: ORACLE_ADDRESS");
165         require(currencyPair != uint256(0), "OracleResigstry::addToWhitelist INVALID_DATA: ORACLE_CURRENCY_PAIR");
166         oracles[currencyPair] = oracle;
167         isWhitelisted[oracle] = true;
168         emit OracleActivated(oracle, currencyPair);
169     }
170 
171     /// @dev Allows to remove destination from whitelist. This can only be done via a Safe transaction.
172     /// @param oracle Destination address.
173     function removeFromWhitelist(address oracle)
174     public
175     onlyOwner
176     {
177         require(isWhitelisted[oracle], "Address is not whitelisted");
178         isWhitelisted[oracle] = false;
179     }
180 
181     function getNetworkExecutor()
182     public
183     returns (address) {
184         return _networkExecutor;
185     }
186 
187     function getNetworkWallet()
188     public
189     returns (address payable) {
190         return _networkWallet;
191     }
192 
193     function getNetworkFee(address asset)
194     public
195     returns (uint256 fee) {
196         fee = splitterToFee[msg.sender][asset];
197         if (fee == uint256(0)) {
198             fee = baseFee;
199         }
200     }
201 
202 }