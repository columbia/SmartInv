1 /**
2  * MPSSaleConfig.sol
3  * Configuration for the MPS token sale private phase.
4 
5  * More info about MPS : https://github.com/MtPelerin/MtPelerin-share-MPS
6 
7  * The unflattened code is available through this github tag:
8  * https://github.com/MtPelerin/MtPelerin-protocol/tree/etherscan-verify-batch-1
9 
10  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
11 
12  * @notice All matters regarding the intellectual property of this code 
13  * @notice or software are subject to Swiss Law without reference to its 
14  * @notice conflicts of law rules.
15 
16  * @notice License for each contract is available in the respective file
17  * @notice or in the LICENSE.md file.
18  * @notice https://github.com/MtPelerin/
19 
20  * @notice Code by OpenZeppelin is copyrighted and licensed on their repository:
21  * @notice https://github.com/OpenZeppelin/openzeppelin-solidity
22  */
23 
24 pragma solidity ^0.4.24;
25 
26 // File: contracts/interface/ISaleConfig.sol
27 
28 /**
29  * @title ISaleConfig interface
30  *
31  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
32  *
33  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
34  * @notice Please refer to the top of this file for the license.
35  */
36 contract ISaleConfig {
37 
38   struct Tokensale {
39     uint256 lotId;
40     uint256 tokenPriceCHFCent;
41   }
42 
43   function tokenSupply() public pure returns (uint256);
44   function tokensaleLotSupplies() public view returns (uint256[]);
45 
46   function tokenizedSharePercent() public pure returns (uint256); 
47   function tokenPriceCHF() public pure returns (uint256);
48 
49   function minimalCHFInvestment() public pure returns (uint256);
50   function maximalCHFInvestment() public pure returns (uint256);
51 
52   function tokensalesCount() public view returns (uint256);
53   function lotId(uint256 _tokensaleId) public view returns (uint256);
54   function tokenPriceCHFCent(uint256 _tokensaleId)
55     public view returns (uint256);
56 }
57 
58 // File: contracts/zeppelin/ownership/Ownable.sol
59 
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract Ownable {
66   address public owner;
67 
68 
69   event OwnershipRenounced(address indexed previousOwner);
70   event OwnershipTransferred(
71     address indexed previousOwner,
72     address indexed newOwner
73   );
74 
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   constructor() public {
81     owner = msg.sender;
82   }
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92   /**
93    * @dev Allows the current owner to relinquish control of the contract.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: contracts/mps/MPSSaleConfig.sol
120 
121 /**
122  * @title MPSSaleConfig
123  * @dev MPSSaleConfig contract
124  * The contract configure the sale for the MPS token
125  *
126  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
127  *
128  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
129  * @notice Please refer to the top of this file for the license.
130  */
131 contract MPSSaleConfig is ISaleConfig, Ownable {
132 
133   // Token supply cap: 10M
134   uint256 constant public TOKEN_SUPPLY = 10 ** 7;
135  
136   // 100% of Mt Pelerin's shares are tokenized
137   uint256 constant public TOKENSALE_LOT1_SHARE_PERCENT = 5;
138   uint256 constant public TOKENSALE_LOT2_SHARE_PERCENT = 95;
139   uint256 constant public TOKENIZED_SHARE_PERCENT
140   = TOKENSALE_LOT1_SHARE_PERCENT + TOKENSALE_LOT2_SHARE_PERCENT;
141 
142   uint256 constant public TOKENSALE_LOT1_SUPPLY
143   = TOKEN_SUPPLY * TOKENSALE_LOT1_SHARE_PERCENT / 100;
144   uint256 constant public TOKENSALE_LOT2_SUPPLY
145   = TOKEN_SUPPLY * TOKENSALE_LOT2_SHARE_PERCENT / 100;
146 
147   uint256[] private tokensaleLotSuppliesArray
148   = [ TOKENSALE_LOT1_SUPPLY, TOKENSALE_LOT2_SUPPLY ];
149 
150   // Tokens amount per CHF Cents
151   uint256 constant public TOKEN_PRICE_CHF_CENT = 500;
152 
153   // Minimal CHF Cents investment
154   uint256 constant public MINIMAL_CHF_CENT_INVESTMENT = 10 ** 4;
155 
156   // Maximal CHF Cents investment
157   uint256 constant public MAXIMAL_CHF_CENT_INVESTMENT = 10 ** 10;
158 
159   Tokensale[] public tokensales;
160 
161   /**
162    * @dev constructor
163    */
164   constructor() public {
165     tokensales.push(Tokensale(
166       0,
167       TOKEN_PRICE_CHF_CENT * 80 / 100
168     ));
169 
170     tokensales.push(Tokensale(
171       0,
172       TOKEN_PRICE_CHF_CENT
173     ));
174   }
175 
176   /**
177    * @dev getter need to be declared to comply with ISaleConfig interface
178    */
179   function tokenSupply() public pure returns (uint256) {
180     return TOKEN_SUPPLY;
181   }
182 
183   /**
184    * @dev getter need to be declared to comply with ISaleConfig interface
185    */
186   function tokensaleLotSupplies() public view returns (uint256[]) {
187     return tokensaleLotSuppliesArray;
188   }
189 
190   /**
191    * @dev getter need to be declared to comply with ISaleConfig interface
192    */
193   function tokenizedSharePercent() public pure returns (uint256) {
194     return TOKENIZED_SHARE_PERCENT;
195   }
196 
197   /**
198    * @dev getter need to be declared to comply with ISaleConfig interface
199    */
200   function tokenPriceCHF() public pure returns (uint256) {
201     return TOKEN_PRICE_CHF_CENT;
202   }
203 
204   /**
205    * @dev getter need to be declared to comply with ISaleConfig interface
206    */
207   function minimalCHFInvestment() public pure returns (uint256) {
208     return MINIMAL_CHF_CENT_INVESTMENT;
209   }
210 
211   /**
212    * @dev getter need to be declared to comply with ISaleConfig interface
213    */
214   function maximalCHFInvestment() public pure returns (uint256) {
215     return MAXIMAL_CHF_CENT_INVESTMENT;
216   }
217 
218   /**
219    * @dev tokensale count
220    */
221   function tokensalesCount() public view returns (uint256) {
222     return tokensales.length;
223   }
224 
225   /**
226    * @dev getter need to be declared to comply with ISaleConfig interface
227    */
228   function lotId(uint256 _tokensaleId) public view returns (uint256) {
229     return tokensales[_tokensaleId].lotId;
230   }
231 
232   /**
233    * @dev getter need to be declared to comply with ISaleConfig interface
234    */
235   function tokenPriceCHFCent(uint256 _tokensaleId)
236     public view returns (uint256)
237   {
238     return tokensales[_tokensaleId].tokenPriceCHFCent;
239   }
240 }