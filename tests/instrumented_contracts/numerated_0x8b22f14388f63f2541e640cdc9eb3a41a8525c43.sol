1 pragma solidity ^0.4.24;
2 
3 // import { ERC20 as Token } from "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
4 // import { ExchangeHandler } from "./ExchangeHandler.sol";
5 
6 // pragma solidity ^0.4.24;
7 
8 contract Token {
9     function totalSupply() public constant returns (uint);
10     function balanceOf(address tokenOwner) public constant returns (uint balance);
11     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
12     function transfer(address to, uint tokens) public returns (bool success);
13     function approve(address spender, uint tokens) public returns (bool success);
14     function transferFrom(address from, address to, uint tokens) public returns (bool success);
15 
16     event Transfer(address indexed from, address indexed to, uint tokens);
17     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
18 }
19 
20 /// @title Interface for all exchange handler contracts
21 interface ExchangeHandler {
22 
23     /// @dev Get the available amount left to fill for an order
24     /// @param orderAddresses Array of address values needed for this DEX order
25     /// @param orderValues Array of uint values needed for this DEX order
26     /// @param exchangeFee Value indicating the fee for this DEX order
27     /// @param v ECDSA signature parameter v
28     /// @param r ECDSA signature parameter r
29     /// @param s ECDSA signature parameter s
30     /// @return Available amount left to fill for this order
31     function getAvailableAmount(
32         address[8] orderAddresses,
33         uint256[6] orderValues,
34         uint256 exchangeFee,
35         uint8 v,
36         bytes32 r,
37         bytes32 s
38     ) external returns (uint256);
39 
40     /// @dev Perform a buy order at the exchange
41     /// @param orderAddresses Array of address values needed for each DEX order
42     /// @param orderValues Array of uint values needed for each DEX order
43     /// @param exchangeFee Value indicating the fee for this DEX order
44     /// @param amountToFill Amount to fill in this order
45     /// @param v ECDSA signature parameter v
46     /// @param r ECDSA signature parameter r
47     /// @param s ECDSA signature parameter s
48     /// @return Amount filled in this order
49     function performBuy(
50         address[8] orderAddresses,
51         uint256[6] orderValues,
52         uint256 exchangeFee,
53         uint256 amountToFill,
54         uint8 v,
55         bytes32 r,
56         bytes32 s
57     ) external payable returns (uint256);
58 
59     /// @dev Perform a sell order at the exchange
60     /// @param orderAddresses Array of address values needed for each DEX order
61     /// @param orderValues Array of uint values needed for each DEX order
62     /// @param exchangeFee Value indicating the fee for this DEX order
63     /// @param amountToFill Amount to fill in this order
64     /// @param v ECDSA signature parameter v
65     /// @param r ECDSA signature parameter r
66     /// @param s ECDSA signature parameter s
67     /// @return Amount filled in this order
68     function performSell(
69         address[8] orderAddresses,
70         uint256[6] orderValues,
71         uint256 exchangeFee,
72         uint256 amountToFill,
73         uint8 v,
74         bytes32 r,
75         bytes32 s
76     ) external returns (uint256);
77 }
78 
79 
80 interface BancorConverter {
81     function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
82 }
83 
84 contract BancorHandler is ExchangeHandler {
85 
86     // Public functions
87     function getAvailableAmount(
88         address[8] orderAddresses, // [converterAddress, conversionPath ... ]
89         uint256[6] orderValues, // [amountToGive, minReturn, EMPTY, EMPTY, EMPTY, EMPTY]
90         uint256 exchangeFee, // ignore
91         uint8 v, // ignore
92         bytes32 r, // ignore
93         bytes32 s // ignore
94     ) external returns (uint256) {
95         // Return amountToGive
96         return orderValues[0];
97     }
98 
99     function performBuy(
100         address[8] orderAddresses, // [converterAddress, conversionPath ... ]
101         uint256[6] orderValues, // [amountToGive, minReturn, EMPTY, EMPTY, EMPTY, EMPTY]
102         uint256 exchangeFee, // ignore
103         uint256 amountToFill, // ignore
104         uint8 v, // ignore
105         bytes32 r, // ignore
106         bytes32 s // ignore
107     ) external payable returns (uint256 amountObtained) {
108         address destinationToken;
109         (amountObtained, destinationToken) = trade(orderAddresses, orderValues);
110         transferTokenToSender(destinationToken, amountObtained);
111     }
112 
113     function performSell(
114         address[8] orderAddresses, // [converterAddress, conversionPath ... ]
115         uint256[6] orderValues, // [amountToGive, minReturn, EMPTY, EMPTY, EMPTY, EMPTY]
116         uint256 exchangeFee, // ignore
117         uint256 amountToFill, // ignore
118         uint8 v, // ignore
119         bytes32 r, // ignore
120         bytes32 s // ignore
121     ) external returns (uint256 amountObtained) {
122         approveExchange(orderAddresses[0], orderAddresses[1], orderValues[0]);
123         (amountObtained, ) = trade(orderAddresses, orderValues);
124         transferEtherToSender(amountObtained);
125     }
126 
127     function trade(
128         address[8] orderAddresses, // [converterAddress, conversionPath ... ]
129         uint256[6] orderValues // [amountToGive, minReturn, EMPTY, EMPTY, EMPTY, EMPTY]
130     ) internal returns (uint256 amountObtained, address destinationToken) {
131         // Find the length of the conversion path
132         uint256 len;
133         for(len = 1; len < orderAddresses.length; len++) {
134             if(orderAddresses[len] == 0) {
135                 require(len > 1, "First element in conversion path was 0");
136                 destinationToken = orderAddresses[len - 1];
137                 break;
138             } else if(len == orderAddresses.length - 1) {
139                 destinationToken = orderAddresses[len];
140                 len++;
141             }
142         }
143         len--;
144         // Create an array of that length
145         address[] memory conversionPath = new address[](len);
146 
147         // Move the contents from orderAddresses to conversionPath
148         for(uint256 i = 0; i < len; i++) {
149             conversionPath[i] = orderAddresses[i + 1];
150         }
151 
152         amountObtained = BancorConverter(orderAddresses[0])
153                             .quickConvert.value(msg.value)(conversionPath, orderValues[0], orderValues[1]);
154     }
155 
156     function transferTokenToSender(address token, uint256 amount) internal {
157         Token(token).transfer(msg.sender, amount);
158     }
159 
160     function transferEtherToSender(uint256 amount) internal {
161         msg.sender.transfer(amount);
162     }
163 
164     function approveExchange(address exchange, address token, uint256 amount) internal {
165         Token(token).approve(exchange, amount);
166     }
167 
168     function() public payable {
169     }
170 }