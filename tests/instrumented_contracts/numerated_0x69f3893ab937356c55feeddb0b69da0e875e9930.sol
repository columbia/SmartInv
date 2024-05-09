1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: contracts/IOneInchTrade.sol
39 
40 interface IOneInchTrade {
41 
42     function getRateFromKyber(IERC20 from, IERC20 to, uint amount) external view returns (uint expectedRate, uint slippageRate);
43     function getRateFromBancor(IERC20 from, IERC20 to, uint amount) external view returns (uint conversionAmount, uint conversionFee);
44 }
45 
46 // File: contracts/KyberNetworkProxy.sol
47 
48 interface KyberNetworkProxy {
49 
50     function getExpectedRate(IERC20 src, IERC20 dest, uint srcQty)
51     external view
52     returns (uint expectedRate, uint slippageRate);
53 }
54 
55 // File: contracts/BancorConverter.sol
56 
57 interface BancorConverter {
58 
59     function getReturn(IERC20 _fromToken, IERC20 _toToken, uint256 _amount) external view returns (uint256, uint256);
60 }
61 
62 // File: contracts/OneInchTrade.sol
63 
64 /**
65 * KyberNetworkProxy mainnet address 0x818E6FECD516Ecc3849DAf6845e3EC868087B755
66 * BancorConverter mainnet address 0xb89570f6AD742CB1fd440A930D6c2A2eA29c51eE
67 *
68 * DAI mainnet address 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359
69 * DAIBNT mainnet address 0xee01b3AB5F6728adc137Be101d99c678938E6E72
70 * BNT mainnet address 0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C
71 *
72 * "0x818E6FECD516Ecc3849DAf6845e3EC868087B755","0xb89570f6AD742CB1fd440A930D6c2A2eA29c51eE","0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C"
73 *
74 **/
75 contract OneInchTrade is IOneInchTrade {
76 
77     uint constant MIN_TRADING_AMOUNT = 0.0001 ether;
78 
79     KyberNetworkProxy public kyberNetworkProxy;
80     BancorConverter public bancorConverter;
81 
82     address public daiTokenAddress;
83     address public daiBntTokenAddress;
84     address public bntTokenAddress;
85 
86     address constant public KYBER_ETHER_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
87     address constant public BANCOR_ETHER_ADDRESS = 0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315;
88 
89     event Trade(
90         string indexed _type,
91         uint indexed _amount,
92         string indexed _network
93     );
94 
95     constructor(
96         address kyberNetworkProxyAddress,
97         address bancorConverterAddress,
98         address bntAddress
99     ) public {
100 
101         kyberNetworkProxy = KyberNetworkProxy(kyberNetworkProxyAddress);
102         bancorConverter = BancorConverter(bancorConverterAddress);
103         bntTokenAddress = bntAddress;
104     }
105 
106     function getRateFromKyber(IERC20 from, IERC20 to, uint amount) public view returns (uint expectedRate, uint slippageRate) {
107 
108         return kyberNetworkProxy.getExpectedRate(
109             from,
110             to,
111             amount
112         );
113     }
114 
115     function getRateFromBancor(IERC20 from, IERC20 to, uint amount) public view returns (uint expectedRate, uint slippageRate) {
116 
117         return bancorConverter.getReturn(
118             from,
119             to,
120             amount
121         );
122     }
123 
124     function() external payable {
125 
126         uint startGas = gasleft();
127 
128         require(msg.value >= MIN_TRADING_AMOUNT, "Min trading amount not reached.");
129 
130         IERC20 daiToken = IERC20(daiTokenAddress);
131         IERC20 daiBntToken = IERC20(daiBntTokenAddress);
132 
133         (uint kyberExpectedRate, uint kyberSlippageRate) = getRateFromKyber(
134             IERC20(KYBER_ETHER_ADDRESS),
135             IERC20(bntTokenAddress),
136             msg.value
137         );
138 
139         (uint bancorBNTConversionAmount, uint bancorBNTConversionFee) = getRateFromBancor(
140             IERC20(BANCOR_ETHER_ADDRESS),
141             IERC20(bntTokenAddress),
142             msg.value
143         );
144 
145         //        (uint bancorDaiBntConversionAmount, uint bancorDaiBntConversionFee) = getRateFromBancor(
146         //            IERC20(bntTokenAddress),
147         //            daiBntToken,
148         //            bancorBNTConversionAmount
149         //        );
150         //
151         //        (uint bancorDaiConversionAmount, uint bancorDaiConversionFee) = getRateFromBancor(
152         //            daiBntToken,
153         //            daiToken,
154         //            msg.value * bancorBNTExpectedRate * bancorDaiBntExpectedRate
155         //        );
156 
157         uint kyberTradingAmount = kyberExpectedRate * msg.value;
158         uint bancorTradingAmount = bancorBNTConversionAmount + bancorBNTConversionFee;
159 
160         uint tradedResult = 0;
161 
162         if (kyberTradingAmount > bancorTradingAmount) {
163 
164             // buy from kyber and sell to bancor
165             tradedResult = kyberTradingAmount - bancorTradingAmount;
166 
167             emit Trade("buy", bancorTradingAmount, "bancor");
168             emit Trade("sell", kyberTradingAmount, "kyber");
169         } else {
170 
171             // buy from kyber and sell to bancor
172             tradedResult = bancorTradingAmount - kyberTradingAmount;
173 
174             emit Trade("buy", kyberTradingAmount, "kyber");
175             emit Trade("sell", bancorTradingAmount, "bancor");
176         }
177 
178 //        require(
179 //            tradedResult >= baseTokenAmount,
180 //            "Canceled because of not profitable trade."
181 //        );
182 
183         //uint gasUsed = startGas - gasleft();
184         // gasUsed * tx.gasprice
185     }
186 }