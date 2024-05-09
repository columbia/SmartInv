1 pragma solidity ^0.6.12;// This program is free software: you can redistribute it and/or modify
2 // it under the terms of the GNU General Public License as published by
3 // the Free Software Foundation, either version 3 of the License, or
4 // (at your option) any later version.
5 
6 // This program is distributed in the hope that it will be useful,
7 // but WITHOUT ANY WARRANTY; without even the implied warranty of
8 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9 // GNU General Public License for more details.
10 
11 // You should have received a copy of the GNU General Public License
12 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
13 
14 // SPDX-License-Identifier: GPL-3.0-only
15 
16 
17 /**
18  * @title ITokenPriceRegistry
19  * @notice TokenPriceRegistry interface
20  */
21 interface ITokenPriceRegistry {
22     function getTokenPrice(address _token) external view returns (uint184 _price);
23     function isTokenTradable(address _token) external view returns (bool _isTradable);
24 }
25 
26 
27 /**
28  * @title Owned
29  * @notice Basic contract to define an owner.
30  * @author Julien Niset - <julien@argent.xyz>
31  */
32 contract Owned {
33 
34     // The owner
35     address public owner;
36 
37     event OwnerChanged(address indexed _newOwner);
38 
39     /**
40      * @notice Throws if the sender is not the owner.
41      */
42     modifier onlyOwner {
43         require(msg.sender == owner, "Must be owner");
44         _;
45     }
46 
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     /**
52      * @notice Lets the owner transfer ownership of the contract to a new owner.
53      * @param _newOwner The new owner.
54      */
55     function changeOwner(address _newOwner) external onlyOwner {
56         require(_newOwner != address(0), "Address must not be null");
57         owner = _newOwner;
58         emit OwnerChanged(_newOwner);
59     }
60 }
61 
62 
63 /**
64  * @title Managed
65  * @notice Basic contract that defines a set of managers. Only the owner can add/remove managers.
66  * @author Julien Niset - <julien@argent.xyz>
67  */
68 contract Managed is Owned {
69 
70     // The managers
71     mapping (address => bool) public managers;
72 
73     /**
74      * @notice Throws if the sender is not a manager.
75      */
76     modifier onlyManager {
77         require(managers[msg.sender] == true, "M: Must be manager");
78         _;
79     }
80 
81     event ManagerAdded(address indexed _manager);
82     event ManagerRevoked(address indexed _manager);
83 
84     /**
85     * @notice Adds a manager.
86     * @param _manager The address of the manager.
87     */
88     function addManager(address _manager) external onlyOwner {
89         require(_manager != address(0), "M: Address must not be null");
90         if (managers[_manager] == false) {
91             managers[_manager] = true;
92             emit ManagerAdded(_manager);
93         }
94     }
95 
96     /**
97     * @notice Revokes a manager.
98     * @param _manager The address of the manager.
99     */
100     function revokeManager(address _manager) external onlyOwner {
101         require(managers[_manager] == true, "M: Target must be an existing manager");
102         delete managers[_manager];
103         emit ManagerRevoked(_manager);
104     }
105 }
106 
107 
108 
109 /**
110  * @title TokenPriceRegistry
111  * @notice Contract storing the token prices.
112  * @notice Note that prices stored here = price per token * 10^(18-token decimals)
113  * The contract only defines basic setters and getters with no logic.
114  * Only managers of this contract can modify its state.
115  */
116 contract TokenPriceRegistry is ITokenPriceRegistry, Managed {
117     struct TokenInfo {
118         uint184 cachedPrice;
119         uint64 updatedAt;
120         bool isTradable;
121     }
122 
123     // Price info per token
124     mapping(address => TokenInfo) public tokenInfo;
125     // The minimum period between two price updates
126     uint256 public minPriceUpdatePeriod;
127 
128 
129     // Getters
130 
131     function getTokenPrice(address _token) external override view returns (uint184 _price) {
132         _price = tokenInfo[_token].cachedPrice;
133     }
134     function isTokenTradable(address _token) external override view returns (bool _isTradable) {
135         _isTradable = tokenInfo[_token].isTradable;
136     }
137     function getPriceForTokenList(address[] calldata _tokens) external view returns (uint184[] memory _prices) {
138         _prices = new uint184[](_tokens.length);
139         for (uint256 i = 0; i < _tokens.length; i++) {
140             _prices[i] = tokenInfo[_tokens[i]].cachedPrice;
141         }
142     }
143     function getTradableForTokenList(address[] calldata _tokens) external view returns (bool[] memory _tradable) {
144         _tradable = new bool[](_tokens.length);
145         for (uint256 i = 0; i < _tokens.length; i++) {
146             _tradable[i] = tokenInfo[_tokens[i]].isTradable;
147         }
148     }
149 
150     // Setters
151     
152     function setMinPriceUpdatePeriod(uint256 _newPeriod) external onlyOwner {
153         minPriceUpdatePeriod = _newPeriod;
154     }
155     function setPriceForTokenList(address[] calldata _tokens, uint184[] calldata _prices) external onlyManager {
156         require(_tokens.length == _prices.length, "TPS: Array length mismatch");
157         for (uint i = 0; i < _tokens.length; i++) {
158             uint64 updatedAt = tokenInfo[_tokens[i]].updatedAt;
159             require(updatedAt == 0 || block.timestamp >= updatedAt + minPriceUpdatePeriod, "TPS: Price updated too early");
160             tokenInfo[_tokens[i]].cachedPrice = _prices[i];
161             tokenInfo[_tokens[i]].updatedAt = uint64(block.timestamp);
162         }
163     }
164     function setTradableForTokenList(address[] calldata _tokens, bool[] calldata _tradable) external {
165         require(_tokens.length == _tradable.length, "TPS: Array length mismatch");
166         for (uint256 i = 0; i < _tokens.length; i++) {
167             require(msg.sender == owner || (!_tradable[i] && managers[msg.sender]), "TPS: Unauthorised");
168             tokenInfo[_tokens[i]].isTradable = _tradable[i];
169         }
170     }
171 }