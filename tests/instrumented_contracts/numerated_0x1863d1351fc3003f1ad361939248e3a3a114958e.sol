1 /*
2 Implements a rate oracle (for EUR/ETH)
3 Operated by Capacity Blockchain Solutions GmbH.
4 No warranties.
5 */
6 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
7 
8 pragma solidity ^0.5.2;
9 
10 /**
11  * @title ERC20 interface
12  * @dev see https://eips.ethereum.org/EIPS/eip-20
13  */
14 interface IERC20 {
15     function transfer(address to, uint256 value) external returns (bool);
16 
17     function approve(address spender, uint256 value) external returns (bool);
18 
19     function transferFrom(address from, address to, uint256 value) external returns (bool);
20 
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address who) external view returns (uint256);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
33 
34 pragma solidity ^0.5.2;
35 
36 /**
37  * @title SafeMath
38  * @dev Unsigned math operations with safety checks that revert on error
39  */
40 library SafeMath {
41     /**
42      * @dev Multiplies two unsigned integers, reverts on overflow.
43      */
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46         // benefit is lost if 'b' is also tested.
47         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48         if (a == 0) {
49             return 0;
50         }
51 
52         uint256 c = a * b;
53         require(c / a == b);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
60      */
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         // Solidity only automatically asserts when dividing by 0
63         require(b > 0);
64         uint256 c = a / b;
65         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67         return c;
68     }
69 
70     /**
71      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72      */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         require(b <= a);
75         uint256 c = a - b;
76 
77         return c;
78     }
79 
80     /**
81      * @dev Adds two unsigned integers, reverts on overflow.
82      */
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a);
86 
87         return c;
88     }
89 
90     /**
91      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
92      * reverts when dividing by zero.
93      */
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b != 0);
96         return a % b;
97     }
98 }
99 
100 // File: contracts\OracleRequest.sol
101 
102 /*
103 Interface for requests to the rate oracle (for EUR/ETH)
104 Copy this to projects that need to access the oracle.
105 See rate-oracle project for implementation.
106 */
107 pragma solidity ^0.5.0;
108 
109 
110 contract OracleRequest {
111 
112     uint256 public EUR_WEI; //number of wei per EUR
113 
114     uint256 public lastUpdate; //timestamp of when the last update occurred
115 
116     function ETH_EUR() public view returns (uint256); //number of EUR per ETH (rounded down!)
117 
118     function ETH_EURCENT() public view returns (uint256); //number of EUR cent per ETH (rounded down!)
119 
120 }
121 
122 // File: contracts\Oracle.sol
123 
124 /*
125 Implements a rate oracle (for EUR/ETH)
126 */
127 pragma solidity ^0.5.0;
128 
129 
130 
131 
132 contract Oracle is OracleRequest {
133     using SafeMath for uint256;
134 
135     address public rateControl;
136 
137     address public tokenAssignmentControl;
138 
139     constructor(address _rateControl, address _tokenAssignmentControl)
140     public
141     {
142         lastUpdate = 0;
143         rateControl = _rateControl;
144         tokenAssignmentControl = _tokenAssignmentControl;
145     }
146 
147     modifier onlyRateControl()
148     {
149         require(msg.sender == rateControl, "rateControl key required for this function.");
150         _;
151     }
152 
153     modifier onlyTokenAssignmentControl() {
154         require(msg.sender == tokenAssignmentControl, "tokenAssignmentControl key required for this function.");
155         _;
156     }
157 
158     function setRate(uint256 _new_EUR_WEI)
159     public
160     onlyRateControl
161     {
162         lastUpdate = now;
163         require(_new_EUR_WEI > 0, "Please assign a valid rate.");
164         EUR_WEI = _new_EUR_WEI;
165     }
166 
167     function ETH_EUR()
168     public view
169     returns (uint256)
170     {
171         return uint256(1 ether).div(EUR_WEI);
172     }
173 
174     function ETH_EURCENT()
175     public view
176     returns (uint256)
177     {
178         return uint256(100 ether).div(EUR_WEI);
179     }
180 
181     /*** Make sure currency doesn't get stranded in this contract ***/
182 
183     // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.
184     function rescueToken(IERC20 _foreignToken, address _to)
185     public
186     onlyTokenAssignmentControl
187     {
188         _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));
189     }
190 
191     // Make sure this contract cannot receive ETH.
192     function() external
193     payable
194     {
195         revert("The contract cannot receive ETH payments.");
196     }
197 }