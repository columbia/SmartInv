1 pragma solidity ^0.4.24;
2 
3 /**
4  * ERC20 contract interface.
5  */
6 contract ERC20 {
7     function totalSupply() public view returns (uint);
8     function decimals() public view returns (uint);
9     function balanceOf(address tokenOwner) public view returns (uint balance);
10     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 }
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22     /**
23     * @dev Multiplies two numbers, reverts on overflow.
24     */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27         // benefit is lost if 'b' is also tested.
28         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b);
35 
36         return c;
37     }
38 
39     /**
40     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
41     */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b > 0); // Solidity only automatically asserts when dividing by 0
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47         return c;
48     }
49 
50     /**
51     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
52     */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         require(b <= a);
55         uint256 c = a - b;
56 
57         return c;
58     }
59 
60     /**
61     * @dev Adds two numbers, reverts on overflow.
62     */
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a);
66 
67         return c;
68     }
69 
70     /**
71     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
72     * reverts when dividing by zero.
73     */
74     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b != 0);
76         return a % b;
77     }
78 
79     /**
80     * @dev Returns ceil(a / b).
81     */
82     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a / b;
84         if(a % b == 0) {
85             return c;
86         }
87         else {
88             return c + 1;
89         }
90     }
91 }
92 
93 /**
94  * @title KyberNetwork
95  * @dev Interface for KyberNetwork main contract.
96  */
97 contract KyberNetwork {
98 
99     function getExpectedRate(
100         ERC20 src,
101         ERC20 dest,
102         uint srcQty
103     )
104         public
105         view
106         returns (uint expectedRate, uint slippageRate);
107 
108     function trade(
109         ERC20 src,
110         uint srcAmount,
111         ERC20 dest,
112         address destAddress,
113         uint maxDestAmount,
114         uint minConversionRate,
115         address walletId
116     )
117         public
118         payable
119         returns(uint);
120 }
121 
122 /**
123  * @title TokenPriceProvider
124  * @dev Simple contract returning the price in ETH for ERC20 tokens listed on KyberNetworks. 
125  * @author Olivier Van Den Biggelaar - <olivier@argent.xyz>
126  */
127 contract TokenPriceProvider {
128 
129     using SafeMath for uint256;
130 
131     // Mock token address for ETH
132     address constant internal ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
133     // Address of Kyber's trading contract
134     address constant internal KYBER_NETWORK_ADDRESS = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
135 
136     mapping(address => uint256) public cachedPrices;
137 
138     function syncPrice(ERC20 token) public {
139         uint256 expectedRate;
140         (expectedRate,) = kyberNetwork().getExpectedRate(token, ERC20(ETH_TOKEN_ADDRESS), 10000);
141         cachedPrices[token] = expectedRate;
142     }
143 
144     //
145     // Convenience functions
146     //
147 
148     function syncPriceForTokenList(ERC20[] tokens) public {
149         for(uint16 i = 0; i < tokens.length; i++) {
150             syncPrice(tokens[i]);
151         }
152     }
153 
154     /**
155      * @dev Converts the value of _amount tokens in ether.
156      * @param _amount the amount of tokens to convert (in 'token wei' twei)
157      * @param _token the ERC20 token contract
158      * @return the ether value (in wei) of _amount tokens with contract _token
159      */
160     function getEtherValue(uint256 _amount, address _token) public view returns (uint256) {
161         uint256 decimals = ERC20(_token).decimals();
162         uint256 price = cachedPrices[_token];
163         return price.mul(_amount).div(10**decimals);
164     }
165 
166     //
167     // Internal
168     //
169 
170     function kyberNetwork() internal view returns (KyberNetwork) {
171         return KyberNetwork(KYBER_NETWORK_ADDRESS);
172     }
173 }