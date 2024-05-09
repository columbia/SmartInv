1 pragma solidity 0.4.21;
2 
3 // File: contracts/ExchangeHandler.sol
4 
5 /// @title Interface for all exchange handler contracts
6 interface ExchangeHandler {
7 
8     /// @dev Get the available amount left to fill for an order
9     /// @param orderAddresses Array of address values needed for this DEX order
10     /// @param orderValues Array of uint values needed for this DEX order
11     /// @param exchangeFee Value indicating the fee for this DEX order
12     /// @param v ECDSA signature parameter v
13     /// @param r ECDSA signature parameter r
14     /// @param s ECDSA signature parameter s
15     /// @return Available amount left to fill for this order
16     function getAvailableAmount(
17         address[8] orderAddresses,
18         uint256[6] orderValues,
19         uint256 exchangeFee,
20         uint8 v,
21         bytes32 r,
22         bytes32 s
23     ) external returns (uint256);
24 
25     /// @dev Perform a buy order at the exchange
26     /// @param orderAddresses Array of address values needed for each DEX order
27     /// @param orderValues Array of uint values needed for each DEX order
28     /// @param exchangeFee Value indicating the fee for this DEX order
29     /// @param amountToFill Amount to fill in this order
30     /// @param v ECDSA signature parameter v
31     /// @param r ECDSA signature parameter r
32     /// @param s ECDSA signature parameter s
33     /// @return Amount filled in this order
34     function performBuy(
35         address[8] orderAddresses,
36         uint256[6] orderValues,
37         uint256 exchangeFee,
38         uint256 amountToFill,
39         uint8 v,
40         bytes32 r,
41         bytes32 s
42     ) external payable returns (uint256);
43 
44     /// @dev Perform a sell order at the exchange
45     /// @param orderAddresses Array of address values needed for each DEX order
46     /// @param orderValues Array of uint values needed for each DEX order
47     /// @param exchangeFee Value indicating the fee for this DEX order
48     /// @param amountToFill Amount to fill in this order
49     /// @param v ECDSA signature parameter v
50     /// @param r ECDSA signature parameter r
51     /// @param s ECDSA signature parameter s
52     /// @return Amount filled in this order
53     function performSell(
54         address[8] orderAddresses,
55         uint256[6] orderValues,
56         uint256 exchangeFee,
57         uint256 amountToFill,
58         uint8 v,
59         bytes32 r,
60         bytes32 s
61     ) external returns (uint256);
62 }
63 
64 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72   function totalSupply() public view returns (uint256);
73   function balanceOf(address who) public view returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract Token is ERC20Basic {
85   function allowance(address owner, address spender) public view returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 // File: contracts/Bancor.sol
92 
93 interface BancorConverter {
94     function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
95 }
96 
97 contract BancorHandler is ExchangeHandler {
98 
99     // Public functions
100     function getAvailableAmount(
101         address[8] orderAddresses, // [converterAddress, conversionPath ... ]
102         uint256[6] orderValues, // [amountToGive, minReturn, EMPTY, EMPTY, EMPTY, EMPTY]
103         uint256 exchangeFee, // ignore
104         uint8 v, // ignore
105         bytes32 r, // ignore
106         bytes32 s // ignore
107     ) external returns (uint256) {
108         // Return amountToGive
109         return orderValues[0];
110     }
111 
112     function performBuy(
113         address[8] orderAddresses, // [converterAddress, conversionPath ... ]
114         uint256[6] orderValues, // [amountToGive, minReturn, EMPTY, EMPTY, EMPTY, EMPTY]
115         uint256 exchangeFee, // ignore
116         uint256 amountToFill, // ignore
117         uint8 v, // ignore
118         bytes32 r, // ignore
119         bytes32 s // ignore
120     ) external payable returns (uint256 amountObtained) {
121         address destinationToken;
122         (amountObtained, destinationToken) = trade(orderAddresses, orderValues);
123         transferTokenToSender(destinationToken, amountObtained);
124     }
125 
126     function performSell(
127         address[8] orderAddresses, // [converterAddress, conversionPath ... ]
128         uint256[6] orderValues, // [amountToGive, minReturn, EMPTY, EMPTY, EMPTY, EMPTY]
129         uint256 exchangeFee, // ignore
130         uint256 amountToFill, // ignore
131         uint8 v, // ignore
132         bytes32 r, // ignore
133         bytes32 s // ignore
134     ) external returns (uint256 amountObtained) {
135         approveExchange(orderAddresses[0], orderAddresses[1], orderValues[0]);
136         (amountObtained, ) = trade(orderAddresses, orderValues);
137         transferEtherToSender(amountObtained);
138     }
139 
140     function trade(
141         address[8] orderAddresses, // [converterAddress, conversionPath ... ]
142         uint256[6] orderValues // [amountToGive, minReturn, EMPTY, EMPTY, EMPTY, EMPTY]
143     ) internal returns (uint256 amountObtained, address destinationToken) {
144         // Find the length of the conversion path
145         uint256 len;
146         for(len = 1; len < orderAddresses.length; len++) {
147             if(orderAddresses[len] == 0) {
148                 require(len > 1);
149                 destinationToken = orderAddresses[len - 1];
150                 len--;
151                 break;
152             } else if(len == orderAddresses.length - 1) {
153                 destinationToken = orderAddresses[len];
154                 break;
155             }
156         }
157         // Create an array of that length
158         address[] memory conversionPath = new address[](len);
159 
160         // Move the contents from orderAddresses to conversionPath
161         for(uint256 i = 0; i < len; i++) {
162             conversionPath[i] = orderAddresses[i + 1];
163         }
164 
165         amountObtained = BancorConverter(orderAddresses[0])
166                             .quickConvert.value(msg.value)(conversionPath, orderValues[0], orderValues[1]);
167     }
168 
169     function transferTokenToSender(address token, uint256 amount) internal {
170         require(Token(token).transfer(msg.sender, amount));
171     }
172 
173     function transferEtherToSender(uint256 amount) internal {
174         msg.sender.transfer(amount);
175     }
176 
177     function approveExchange(address exchange, address token, uint256 amount) internal {
178         require(Token(token).approve(exchange, amount));
179     }
180 
181     function() public payable {
182     }
183 }