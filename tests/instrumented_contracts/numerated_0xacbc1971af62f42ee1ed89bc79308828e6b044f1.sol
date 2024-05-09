1 pragma solidity ^0.5.2;
2 
3 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts\Donations.sol
70 
71 contract ERC20Interface {
72     function balanceOf(address _owner) external returns (uint256);
73     function transfer(address _to, uint256 _value) external;
74 }
75 
76 contract Donations {
77     using SafeMath for uint256;
78 
79     struct Knight
80     {
81         address ethAddress;
82         ///@dev amount in % of ETH and HORSE to distribute from this contract
83         uint256 equity;
84     }
85 
86     /// @dev list of all knights by name
87     mapping(string => Knight) knights;
88 
89     /// @dev handle to access HORSE token contract to make transfers
90     ERC20Interface constant horseToken = ERC20Interface(0x5B0751713b2527d7f002c0c4e2a37e1219610A6B);
91 
92     ///@dev true for HORSE, false for ETH
93     mapping(bool => uint256) private _toDistribute;
94     ///@dev true for HORSE, false for ETH
95     mapping(bool => mapping(address => uint256)) private _balances;
96 
97     /// @dev helpers to make code look better
98     bool constant ETH = false;
99     bool constant HORSE = true;
100    
101     /**
102         @dev Initialize the contract with the correct knights and their equities and addresses
103         All spoils are to be shared by Five Knights, the distribution of which is decided by God almighty
104     */
105     constructor() public {
106         knights["Safir"].equity = 27;
107         knights["Safir"].ethAddress = 0x61F646be9E40F3C83Ae6C74e8b33f2708396D08C;
108         knights["Lucan"].equity = 27;
109         knights["Lucan"].ethAddress = 0x445D779acfE04C717cc6B0071D3713D7E405Dc99;
110         knights["Lancelot"].equity = 27;
111         knights["Lancelot"].ethAddress = 0x5873d3875274753f6680a2256aCb02F2e42Be1A6;
112         knights["Hoel"].equity = 11;
113         knights["Hoel"].ethAddress = 0x85a4F876A007649048a7D44470ec1d328895B8bb;
114         knights["YwainTheBastard"].equity = 8;
115         knights["YwainTheBastard"].ethAddress = 0x2AB8D865Db8b9455F4a77C70B9D8d953E314De28;
116     }
117     
118     /**
119         @dev The empty fallback function allows for ETH payments on this contract
120     */
121     function () external payable {
122        //fallback function just accept the funds
123     }
124     
125     /**
126         @dev Called by anyone willing to pay the fees for the distribution computation and withdrawal of HIS due
127         This checks for changes in the amounts of ETH and HORSE owned by the contract and updates the balances
128         of all knights acordingly
129     */
130     function withdraw() external {
131         //update the balances of all knights
132         _distribute(ETH);
133         _distribute(HORSE);
134 
135         // check how much the caller is due of HORSE and ETH
136         uint256 toSendHORSE = _balances[HORSE][msg.sender];
137         uint256 toSendETH = _balances[ETH][msg.sender];
138 
139         //if the caller is due HORSE, send it to him
140         if(toSendHORSE > 0) {
141             _balances[HORSE][msg.sender] = 0;
142             horseToken.transfer.gas(40000)(msg.sender,toSendHORSE);
143         }
144 
145         //if the caller is due ETH, send it to him
146         if(toSendETH > 0) {
147             _balances[ETH][msg.sender] = 0;
148             msg.sender.transfer(toSendETH);
149         }
150     }
151     
152     /**
153         @dev Allows a knight to check the amount of ETH and HORSE he can withdraw
154         !!! During withdraw call, the amount is updated before being sent to the knight, so these values may increase
155         @return (ETH balance, HORSE balance)
156     */
157     function checkBalance() external view returns (uint256,uint256) {
158         return (_balances[ETH][msg.sender],_balances[HORSE][msg.sender]);
159     }
160 
161     /**
162         @dev Updates the amounts of ETH and HORSE to distribute
163         @param isHorse [false => ETH distribution, true => HORSE distribution]
164     */
165     function _update(bool isHorse) internal {
166         //get either ETH or HORSE balance
167         uint256 balance = isHorse ? horseToken.balanceOf.gas(40000)(address(this)) : address(this).balance;
168         //if there is something on the contract, compute the difference between knight balances and the contract total amount
169         if(balance > 0) {
170             _toDistribute[isHorse] = balance
171             .sub(_balances[isHorse][knights["Safir"].ethAddress])
172             .sub(_balances[isHorse][knights["Lucan"].ethAddress])
173             .sub(_balances[isHorse][knights["Lancelot"].ethAddress])
174             .sub(_balances[isHorse][knights["YwainTheBastard"].ethAddress])
175             .sub(_balances[isHorse][knights["Hoel"].ethAddress]);
176 
177             //if _toDistribute[isHorse] is 0, then there is nothing to update
178         } else {
179             //just to make sure, but can be removed
180             _toDistribute[isHorse] = 0;
181         }
182     }
183     
184     /**
185         @dev Handles distribution of non distributed ETH or HORSE
186         @param isHorse [false => ETH distribution, true => HORSE distribution]
187     */
188     function _distribute(bool isHorse) private {
189         //check the difference between current balances levels and the contracts levels
190         //this will provide the _toDistribute amount
191         _update(isHorse);
192         //if the contract balance is more than knights balances combined, we need a distribution
193         if(_toDistribute[isHorse] > 0) {
194             //we divide the amount to distribute by 100 to know how much each % represents
195             uint256 parts = _toDistribute[isHorse].div(100);
196             //the due of each knight is the % value * equity (27 equity = 27 * 1% => 27% of the amount to distribute)
197             uint256 dueSafir = knights["Safir"].equity.mul(parts);
198             uint256 dueLucan = knights["Lucan"].equity.mul(parts);
199             uint256 dueLancelot = knights["Lancelot"].equity.mul(parts);
200             uint256 dueYwainTheBastard = knights["YwainTheBastard"].equity.mul(parts);
201 
202             //all balances are augmented by the computed due
203             _balances[isHorse][knights["Safir"].ethAddress] = _balances[isHorse][knights["Safir"].ethAddress].add(dueSafir);
204             _balances[isHorse][knights["Lucan"].ethAddress] = _balances[isHorse][knights["Lucan"].ethAddress].add(dueLucan);
205             _balances[isHorse][knights["Lancelot"].ethAddress] = _balances[isHorse][knights["Lancelot"].ethAddress].add(dueLancelot);
206             _balances[isHorse][knights["YwainTheBastard"].ethAddress] = _balances[isHorse][knights["YwainTheBastard"].ethAddress].add(dueYwainTheBastard);
207             //the 5th knight due is computed by substraction of the others to avoid dust error due to division
208             _balances[isHorse][knights["Hoel"].ethAddress] = _balances[isHorse][knights["Hoel"].ethAddress]
209             .add(_toDistribute[isHorse] - dueSafir - dueLucan - dueLancelot - dueYwainTheBastard);
210             
211             //the amount to distribute is set to zero
212             _toDistribute[isHorse] = 0;
213         }
214     }
215 }