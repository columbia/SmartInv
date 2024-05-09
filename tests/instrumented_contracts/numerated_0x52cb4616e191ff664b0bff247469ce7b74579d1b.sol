1 pragma solidity ^0.4.24;
2 
3 interface IOracle {
4 
5     /**
6     * @notice Returns address of oracle currency (0x0 for ETH)
7     */
8     function getCurrencyAddress() external view returns(address);
9 
10     /**
11     * @notice Returns symbol of oracle currency (0x0 for ETH)
12     */
13     function getCurrencySymbol() external view returns(bytes32);
14 
15     /**
16     * @notice Returns denomination of price
17     */
18     function getCurrencyDenominated() external view returns(bytes32);
19 
20     /**
21     * @notice Returns price - should throw if not valid
22     */
23     function getPrice() external view returns(uint256);
24 
25 }
26 
27 /**
28  * @title Interface to MakerDAO Medianizer contract
29  */
30 
31 interface IMedianizer {
32 
33     function peek() constant external returns (bytes32, bool);
34 
35     function read() constant external returns (bytes32);
36 
37     function set(address wat) external;
38 
39     function set(bytes12 pos, address wat) external;
40 
41     function setMin(uint96 min_) external;
42 
43     function setNext(bytes12 next_) external;
44 
45     function unset(bytes12 pos) external;
46 
47     function unset(address wat) external;
48 
49     function poke() external;
50 
51     function poke(bytes32) external;
52 
53     function compute() constant external returns (bytes32, bool);
54 
55     function void() external;
56 
57 }
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65   address public owner;
66 
67 
68   event OwnershipRenounced(address indexed previousOwner);
69   event OwnershipTransferred(
70     address indexed previousOwner,
71     address indexed newOwner
72   );
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   constructor() public {
80     owner = msg.sender;
81   }
82 
83   /**
84    * @dev Throws if called by any account other than the owner.
85    */
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to relinquish control of the contract.
93    */
94   function renounceOwnership() public onlyOwner {
95     emit OwnershipRenounced(owner);
96     owner = address(0);
97   }
98 
99   /**
100    * @dev Allows the current owner to transfer control of the contract to a newOwner.
101    * @param _newOwner The address to transfer ownership to.
102    */
103   function transferOwnership(address _newOwner) public onlyOwner {
104     _transferOwnership(_newOwner);
105   }
106 
107   /**
108    * @dev Transfers control of the contract to a newOwner.
109    * @param _newOwner The address to transfer ownership to.
110    */
111   function _transferOwnership(address _newOwner) internal {
112     require(_newOwner != address(0));
113     emit OwnershipTransferred(owner, _newOwner);
114     owner = _newOwner;
115   }
116 }
117 
118 contract MakerDAOOracle is IOracle, Ownable {
119 
120     address public medianizer;
121     address public currencyAddress;
122     bytes32 public currencySymbol;
123 
124     bool public manualOverride;
125     uint256 public manualPrice;
126 
127     event ChangeMedianizer(address _newMedianizer, address _oldMedianizer, uint256 _now);
128     event SetManualPrice(uint256 _oldPrice, uint256 _newPrice, uint256 _time);
129     event SetManualOverride(bool _override, uint256 _time);
130 
131     /**
132       * @notice Creates a new Maker based oracle
133       * @param _medianizer Address of Maker medianizer
134       * @param _currencyAddress Address of currency (0x0 for ETH)
135       * @param _currencySymbol Symbol of currency
136       */
137     constructor (address _medianizer, address _currencyAddress, bytes32 _currencySymbol) public {
138         medianizer = _medianizer;
139         currencyAddress = _currencyAddress;
140         currencySymbol = _currencySymbol;
141     }
142 
143     /**
144       * @notice Updates medianizer address
145       * @param _medianizer Address of Maker medianizer
146       */
147     function changeMedianier(address _medianizer) public onlyOwner {
148         require(_medianizer != address(0), "0x not allowed");
149         emit ChangeMedianizer(_medianizer, medianizer, now);
150         medianizer = _medianizer;
151     }
152 
153     /**
154     * @notice Returns address of oracle currency (0x0 for ETH)
155     */
156     function getCurrencyAddress() external view returns(address) {
157         return currencyAddress;
158     }
159 
160     /**
161     * @notice Returns symbol of oracle currency (0x0 for ETH)
162     */
163     function getCurrencySymbol() external view returns(bytes32) {
164         return currencySymbol;
165     }
166 
167     /**
168     * @notice Returns denomination of price
169     */
170     function getCurrencyDenominated() external view returns(bytes32) {
171         // All MakerDAO oracles are denominated in USD
172         return bytes32("USD");
173     }
174 
175     /**
176     * @notice Returns price - should throw if not valid
177     */
178     function getPrice() external view returns(uint256) {
179         if (manualOverride) {
180             return manualPrice;
181         }
182         (bytes32 price, bool valid) = IMedianizer(medianizer).peek();
183         require(valid, "MakerDAO Oracle returning invalid value");
184         return uint256(price);
185     }
186 
187     /**
188       * @notice Set a manual price. NA - this will only be used if manualOverride == true
189       * @param _price Price to set
190       */
191     function setManualPrice(uint256 _price) public onlyOwner {
192         emit SetManualPrice(manualPrice, _price, now);
193         manualPrice = _price;
194     }
195 
196     /**
197       * @notice Determine whether manual price is used or not
198       * @param _override Whether to use the manual override price or not
199       */
200     function setManualOverride(bool _override) public onlyOwner {
201         manualOverride = _override;
202         emit SetManualOverride(_override, now);
203     }
204 
205 }