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
43     function getRateFromBancor(IERC20 from, IERC20 to, uint amount) external view returns (uint expectedRate, uint slippageRate);
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
67 
68 * DSToken mainnet address 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359
69 * Bancor Token mainnet address 0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C
70 **/
71 contract OneInchTrade is IOneInchTrade {
72 
73     uint constant MIN_TRADING_AMOUNT = 0.0001 ether;
74 
75     KyberNetworkProxy public kyberNetworkProxy;
76     BancorConverter public bancorConverter;
77 
78     address public dsTokenAddress;
79     address public bntTokenAddress;
80 
81     address constant public KYBER_ETHER_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
82     address constant public BANCOR_ETHER_ADDRESS = 0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315;
83 
84     constructor(
85         address kyberNetworkProxyAddress,
86         address bancorConverterAddress,
87 
88         address _dsTokenAddress,
89         address _bntTokenAddress
90     ) public {
91 
92         kyberNetworkProxy = KyberNetworkProxy(kyberNetworkProxyAddress);
93         bancorConverter = BancorConverter(bancorConverterAddress);
94 
95         dsTokenAddress = _dsTokenAddress;
96         bntTokenAddress = _bntTokenAddress;
97     }
98 
99     function getRateFromKyber(IERC20 from, IERC20 to, uint amount) public view returns (uint expectedRate, uint slippageRate) {
100 
101         return kyberNetworkProxy.getExpectedRate(
102             from,
103             to,
104             amount
105         );
106     }
107 
108     function getRateFromBancor(IERC20 from, IERC20 to, uint amount) public view returns (uint expectedRate, uint slippageRate) {
109 
110         return bancorConverter.getReturn(
111             from,
112             to,
113             amount
114         );
115     }
116 
117     function() external payable {
118 
119         uint startGas = gasleft();
120 
121         require(msg.value >= MIN_TRADING_AMOUNT, "Min trading amount not reached.");
122 
123         IERC20 bntToken = IERC20(bntTokenAddress);
124         IERC20 dsToken = IERC20(dsTokenAddress);
125 
126         (uint kyberExpectedRate, uint kyberSlippageRate) = getRateFromKyber(
127             IERC20(KYBER_ETHER_ADDRESS),
128             dsToken,
129             msg.value
130         );
131 
132         (uint bancorBNTExpectedRate, uint bancorBNTSlippageRate) = getRateFromBancor(
133             IERC20(BANCOR_ETHER_ADDRESS),
134             bntToken,
135             msg.value
136         );
137 
138         (uint bancorDSExpectedRate, uint bancorDSSlippageRate) = getRateFromBancor(
139             bntToken,
140             dsToken,
141             msg.value
142         );
143 
144         uint kyberRate = kyberExpectedRate * msg.value;
145         uint bancorRate = bancorBNTExpectedRate * msg.value * bancorDSExpectedRate;
146 
147         uint baseTokenAmount = 0;
148         uint tradedResult = 0;
149 
150         if (kyberRate > bancorRate) {
151             // buy from kyber and sell to bancor
152             tradedResult = kyberRate - bancorRate;
153             baseTokenAmount = bancorRate * msg.value;
154 
155         } else {
156             // buy from kyber and sell to bancor
157             tradedResult = bancorRate - kyberRate;
158             baseTokenAmount = kyberRate * msg.value;
159         }
160 
161         require(
162             tradedResult >= baseTokenAmount,
163             "Canceled because of not profitable trade."
164         );
165 
166         //uint gasUsed = startGas - gasleft();
167         // gasUsed * tx.gasprice
168     }
169 }