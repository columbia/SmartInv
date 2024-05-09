1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73     address private _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /**
78      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79      * account.
80      */
81     constructor () internal {
82         _owner = msg.sender;
83         emit OwnershipTransferred(address(0), _owner);
84     }
85 
86     /**
87      * @return the address of the owner.
88      */
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     /**
94      * @dev Throws if called by any account other than the owner.
95      */
96     modifier onlyOwner() {
97         require(isOwner());
98         _;
99     }
100 
101     /**
102      * @return true if `msg.sender` is the owner of the contract.
103      */
104     function isOwner() public view returns (bool) {
105         return msg.sender == _owner;
106     }
107 
108     /**
109      * @dev Allows the current owner to relinquish control of the contract.
110      * It will not be possible to call the functions with the `onlyOwner`
111      * modifier anymore.
112      * @notice Renouncing ownership will leave the contract without an owner,
113      * thereby removing any functionality that is only available to the owner.
114      */
115     function renounceOwnership() public onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 
120     /**
121      * @dev Allows the current owner to transfer control of the contract to a newOwner.
122      * @param newOwner The address to transfer ownership to.
123      */
124     function transferOwnership(address newOwner) public onlyOwner {
125         _transferOwnership(newOwner);
126     }
127 
128     /**
129      * @dev Transfers control of the contract to a newOwner.
130      * @param newOwner The address to transfer ownership to.
131      */
132     function _transferOwnership(address newOwner) internal {
133         require(newOwner != address(0));
134         emit OwnershipTransferred(_owner, newOwner);
135         _owner = newOwner;
136     }
137 }
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://eips.ethereum.org/EIPS/eip-20
142  */
143 interface IERC20 {
144     function transfer(address to, uint256 value) external returns (bool);
145 
146     function approve(address spender, uint256 value) external returns (bool);
147 
148     function transferFrom(address from, address to, uint256 value) external returns (bool);
149 
150     function totalSupply() external view returns (uint256);
151 
152     function balanceOf(address who) external view returns (uint256);
153 
154     function allowance(address owner, address spender) external view returns (uint256);
155 
156     event Transfer(address indexed from, address indexed to, uint256 value);
157 
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 contract TokenSwap is Ownable {
162     using SafeMath for uint256;
163 
164     IERC20 private _fromToken;
165     IERC20 private _toToken;
166     uint256 private _rate;
167 
168     event Swap(address indexed sender, uint256 indexed fromTokenAmount, uint256 indexed toTokenAmount);
169     event Deactivate(uint256 indexed amount);
170 
171     constructor(
172         address fromToken,
173         address toToken,
174         uint256 rate
175     ) Ownable() public {
176         require(fromToken != address(0x0) && toToken != address(0x0), "token address can not be 0.");
177         require(rate > 0, "swap rate can not be 0.");
178 
179         _fromToken = IERC20(fromToken);
180         _toToken = IERC20(toToken);
181         _rate = rate;
182     }
183 
184     function swap() external returns (bool) {
185         uint256 allowance = _fromToken.allowance(msg.sender, address(this));
186         require(allowance > 0, "sender need to approve token to swap contract.");
187 
188         if (_fromToken.transferFrom(msg.sender, address(0x0), allowance)) {
189             // It only works correctly when the rate is 1000. 
190             uint256 swappedValue = allowance.add(999);
191             swappedValue = swappedValue.div(_rate);
192 
193             require(_toToken.transferFrom(Ownable.owner(), msg.sender, swappedValue));
194 
195             emit Swap(msg.sender, allowance, swappedValue);
196         }
197 
198         return true;
199     }
200 
201     function deactivate() external onlyOwner {
202         uint256 reserve = _fromToken.balanceOf(address(this));
203         require(_fromToken.transfer(address(0x0), reserve));
204 
205         emit Deactivate(reserve);
206     }
207 }