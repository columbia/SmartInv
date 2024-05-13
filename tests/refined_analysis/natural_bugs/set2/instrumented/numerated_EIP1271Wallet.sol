1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 pragma abicoder v2;
4 
5 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
6 import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
7 import {WETH9} from "interfaces/WETH9.sol";
8 import {AggregatorV2V3Interface} from "interfaces/chainlink/AggregatorV2V3Interface.sol";
9 
10 contract EIP1271Wallet {
11     // 0x order encoding is implemented in _encodeEIP1271OrderWithHash
12     // https://github.com/0xProject/0x-monorepo/blob/development/contracts/exchange/contracts/src/MixinSignatureValidator.sol
13     uint256 internal constant ORDER_HASH_OFFSET = 36;
14     uint256 internal constant FEE_RECIPIENT_OFFSET = 144;
15     uint256 internal constant MAKER_AMOUNT_OFFSET = 196;
16     uint256 internal constant TAKER_AMOUNT_OFFSET = 228;
17     uint256 internal constant MAKER_TOKEN_OFFSET = 564;
18     uint256 internal constant TAKER_TOKEN_OFFSET = 660;
19     uint256 internal constant SLIPPAGE_LIMIT_PRECISION = 1e8;
20     uint256 internal constant ETH_PRECISION = 1e18;
21 
22     bytes4 internal constant EIP1271_MAGIC_NUM = 0x20c13b0b;
23     bytes4 internal constant EIP1271_INVALID_SIG = 0xffffffff;
24     WETH9 public immutable WETH;
25     mapping(address => address) public priceOracles;
26     mapping(address => uint256) public slippageLimits;
27 
28     event PriceOracleUpdated(address tokenAddress, address oracleAddress);
29     event SlippageLimitUpdated(address tokenAddress, uint256 slippageLimit);
30 
31     constructor(WETH9 _weth) {
32         WETH = _weth;
33     }
34 
35     function _toAddress(bytes memory _bytes, uint256 _start)
36         private
37         pure
38         returns (address)
39     {
40         // _bytes.length checked by the caller
41         address tempAddress;
42 
43         assembly {
44             tempAddress := div(
45                 mload(add(add(_bytes, 0x20), _start)),
46                 0x1000000000000000000000000
47             )
48         }
49 
50         return tempAddress;
51     }
52 
53     function _toUint256(bytes memory _bytes, uint256 _start)
54         private
55         pure
56         returns (uint256)
57     {
58         // _bytes.length checked by the caller
59         uint256 tempUint;
60 
61         assembly {
62             tempUint := mload(add(add(_bytes, 0x20), _start))
63         }
64 
65         return tempUint;
66     }
67 
68     function _toBytes32(bytes memory _bytes, uint256 _start)
69         private
70         pure
71         returns (bytes32)
72     {
73         // _bytes.length checked by the caller
74         bytes32 tempBytes32;
75 
76         assembly {
77             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
78         }
79 
80         return tempBytes32;
81     }
82 
83     function _toUint(int256 x) private pure returns (uint256) {
84         require(x >= 0);
85         return uint256(x);
86     }
87 
88     /// @notice extracts order information from the encoded 0x order object
89     function _extractOrderInfo(bytes memory encoded)
90         private
91         pure
92         returns (
93             address makerToken,
94             address takerToken,
95             address feeRecipient,
96             uint256 makerAmount,
97             uint256 takerAmount
98         )
99     {
100         require(
101             encoded.length >= TAKER_TOKEN_OFFSET + 32,
102             "encoded: invalid length"
103         );
104         feeRecipient = _toAddress(encoded, FEE_RECIPIENT_OFFSET);
105         makerAmount = _toUint256(encoded, MAKER_AMOUNT_OFFSET);
106         takerAmount = _toUint256(encoded, TAKER_AMOUNT_OFFSET);
107         makerToken = _toAddress(encoded, MAKER_TOKEN_OFFSET);
108         takerToken = _toAddress(encoded, TAKER_TOKEN_OFFSET);
109     }
110 
111     /// @notice extracts the order hash from the encoded 0x order object
112     function _extractOrderHash(bytes memory encoded)
113         private
114         pure
115         returns (bytes32)
116     {
117         require(
118             encoded.length >= ORDER_HASH_OFFSET + 32,
119             "encoded: invalid length"
120         );
121 
122         return _toBytes32(encoded, ORDER_HASH_OFFSET);
123     }
124 
125     /// @notice sets the price oracle for a given token
126     function _setPriceOracle(address tokenAddress, address oracleAddress)
127         internal
128     {
129         priceOracles[tokenAddress] = oracleAddress;
130         emit PriceOracleUpdated(tokenAddress, oracleAddress);
131     }
132 
133     /// @notice slippage limit sets the price floor of the maker token based on the oracle price
134     /// SLIPPAGE_LIMIT_PRECISION = 1e8 = 100% of the current oracle price
135     function _setSlippageLimit(address tokenAddress, uint256 slippageLimit)
136         internal
137     {
138         require(
139             slippageLimit <= SLIPPAGE_LIMIT_PRECISION,
140             "invalid slippage limit"
141         );
142         slippageLimits[tokenAddress] = slippageLimit;
143         emit SlippageLimitUpdated(tokenAddress, slippageLimit);
144     }
145 
146     /// @notice make sure the order satisfies some pre-defined constraints
147     function _validateOrder(bytes memory order) private view {
148         (
149             address makerToken,
150             address takerToken,
151             address feeRecipient,
152             uint256 makerAmount,
153             uint256 takerAmount
154         ) = _extractOrderInfo(order);
155 
156         // No fee recipient allowed
157         require(feeRecipient == address(0), "no fee recipient allowed");
158 
159         // MakerToken should never be WETH
160         require(makerToken != address(WETH), "maker token must not be WETH");
161 
162         // TakerToken (proceeds) should always be WETH
163         require(takerToken == address(WETH), "taker token must be WETH");
164 
165         address priceOracle = priceOracles[makerToken];
166 
167         // Price oracle not defined
168         require(priceOracle != address(0), "price oracle not defined");
169 
170         uint256 slippageLimit = slippageLimits[makerToken];
171 
172         // Slippage limit not defined
173         require(slippageLimit != 0, "slippage limit not defined");
174 
175         uint256 oraclePrice = _toUint(
176             AggregatorV2V3Interface(priceOracle).latestAnswer()
177         );
178 
179         uint256 priceFloor = (oraclePrice * slippageLimit) /
180             SLIPPAGE_LIMIT_PRECISION;
181 
182         uint256 makerDecimals = 10**ERC20(makerToken).decimals();
183 
184         // makerPrice = takerAmount / makerAmount
185         uint256 makerPrice = (takerAmount * makerDecimals) / makerAmount;
186 
187         require(makerPrice >= priceFloor, "slippage is too high");
188     }
189 
190     /**
191      * @notice Verifies that the signer is the owner of the signing contract.
192      */
193     function _isValidSignature(
194         bytes calldata data,
195         bytes calldata signature,
196         address signer
197     ) internal view returns (bytes4) {
198         _validateOrder(data);
199 
200         (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(
201             keccak256(
202                 abi.encodePacked(
203                     "\x19Ethereum Signed Message:\n32",
204                     _extractOrderHash(data)
205                 )
206             ),
207             signature
208         );
209 
210         if (error == ECDSA.RecoverError.NoError && recovered == signer) {
211             return EIP1271_MAGIC_NUM;
212         }
213 
214         return EIP1271_INVALID_SIG;
215     }
216 }
