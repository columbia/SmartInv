1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title Ownable
27  * @dev The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  */
30 contract Ownable {
31     address private _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37      * account.
38      */
39     constructor () internal {
40         _owner = msg.sender;
41         emit OwnershipTransferred(address(0), _owner);
42     }
43 
44     /**
45      * @return the address of the owner.
46      */
47     function owner() public view returns (address) {
48         return _owner;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(isOwner());
56         _;
57     }
58 
59     /**
60      * @return true if `msg.sender` is the owner of the contract.
61      */
62     function isOwner() public view returns (bool) {
63         return msg.sender == _owner;
64     }
65 
66     /**
67      * @dev Allows the current owner to relinquish control of the contract.
68      * @notice Renouncing to ownership will leave the contract without an owner.
69      * It will not be possible to call the functions with the `onlyOwner`
70      * modifier anymore.
71      */
72     function renounceOwnership() public onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76 
77     /**
78      * @dev Allows the current owner to transfer control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers control of the contract to a newOwner.
87      * @param newOwner The address to transfer ownership to.
88      */
89     function _transferOwnership(address newOwner) internal {
90         require(newOwner != address(0));
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 /**
97  * @title SafeMath
98  * @dev Unsigned math operations with safety checks that revert on error
99  */
100 library SafeMath {
101     /**
102     * @dev Multiplies two unsigned integers, reverts on overflow.
103     */
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106         // benefit is lost if 'b' is also tested.
107         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b);
114 
115         return c;
116     }
117 
118     /**
119     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
120     */
121     function div(uint256 a, uint256 b) internal pure returns (uint256) {
122         // Solidity only automatically asserts when dividing by 0
123         require(b > 0);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
132     */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b <= a);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141     * @dev Adds two unsigned integers, reverts on overflow.
142     */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a);
146 
147         return c;
148     }
149 
150     /**
151     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
152     * reverts when dividing by zero.
153     */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b != 0);
156         return a % b;
157     }
158 }
159 
160 // This interface allows derivative contracts to pay Oracle fees for their use of the system.
161 interface StoreInterface {
162 
163     // Pays Oracle fees in ETH to the store. To be used by contracts whose margin currency is ETH.
164     function payOracleFees() external payable;
165 
166     // Pays Oracle fees in the margin currency, erc20Address, to the store. To be used if the margin currency is an
167     // ERC20 token rather than ETH. All approved tokens are transfered.
168     function payOracleFeesErc20(address erc20Address) external; 
169 
170     // Computes the Oracle fees that a contract should pay for a period. `pfc` is the "profit from corruption", or the
171     // maximum amount of margin currency that a token sponsor could extract from the contract through corrupting the
172     // price feed in their favor.
173     function computeOracleFees(uint startTime, uint endTime, uint pfc) external view returns (uint feeAmount);
174 }
175 
176 contract Withdrawable is Ownable {
177     // Withdraws ETH from the contract.
178     function withdraw(uint amount) external onlyOwner {
179         msg.sender.transfer(amount);
180     }
181 
182     // Withdraws ERC20 tokens from the contract.
183     function withdrawErc20(address erc20Address, uint amount) external onlyOwner {
184         IERC20 erc20 = IERC20(erc20Address);
185         require(erc20.transfer(msg.sender, amount));
186     }
187 }
188 
189 // An implementation of StoreInterface that can accept Oracle fees in ETH or any arbitrary ERC20 token.
190 contract CentralizedStore is StoreInterface, Withdrawable {
191 
192     using SafeMath for uint;
193 
194     uint private fixedOracleFeePerSecond; // Percentage of 10^18. E.g., 1e18 is 100% Oracle fee.
195     uint private constant FP_SCALING_FACTOR = 10**18;
196 
197     function payOracleFees() external payable {
198         require(msg.value > 0);
199     }
200 
201     function payOracleFeesErc20(address erc20Address) external {
202         IERC20 erc20 = IERC20(erc20Address);
203         uint authorizedAmount = erc20.allowance(msg.sender, address(this));
204         require(authorizedAmount > 0);
205         require(erc20.transferFrom(msg.sender, address(this), authorizedAmount));
206     }
207 
208     // Sets a new Oracle fee per second.
209     function setFixedOracleFeePerSecond(uint newOracleFee) external onlyOwner {
210         // Oracle fees at or over 100% don't make sense.
211         require(newOracleFee < FP_SCALING_FACTOR);
212         fixedOracleFeePerSecond = newOracleFee;
213         emit SetFixedOracleFeePerSecond(newOracleFee);
214     }
215 
216     function computeOracleFees(uint startTime, uint endTime, uint pfc) external view returns (uint oracleFeeAmount) {
217         uint timeRange = endTime.sub(startTime);
218 
219         // The oracle fees before being divided by the FP_SCALING_FACTOR.
220         uint oracleFeesPreDivision = pfc.mul(fixedOracleFeePerSecond).mul(timeRange);
221         oracleFeeAmount = oracleFeesPreDivision.div(FP_SCALING_FACTOR);
222 
223         // If there is any remainder, add 1. This causes the division to ceil rather than floor the result.
224         if (oracleFeesPreDivision.mod(FP_SCALING_FACTOR) != 0) {
225             oracleFeeAmount = oracleFeeAmount.add(1);
226         }
227     }
228 
229     event SetFixedOracleFeePerSecond(uint newOracleFee);
230 }