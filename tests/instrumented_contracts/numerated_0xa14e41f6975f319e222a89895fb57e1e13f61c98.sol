1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * It will not be possible to call the functions with the `onlyOwner`
47      * modifier anymore.
48      * @notice Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
76 
77 pragma solidity ^0.5.2;
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://eips.ethereum.org/EIPS/eip-20
82  */
83 interface IERC20 {
84     function transfer(address to, uint256 value) external returns (bool);
85 
86     function approve(address spender, uint256 value) external returns (bool);
87 
88     function transferFrom(address from, address to, uint256 value) external returns (bool);
89 
90     function totalSupply() external view returns (uint256);
91 
92     function balanceOf(address who) external view returns (uint256);
93 
94     function allowance(address owner, address spender) external view returns (uint256);
95 
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
102 
103 pragma solidity ^0.5.2;
104 
105 /**
106  * @title SafeMath
107  * @dev Unsigned math operations with safety checks that revert on error
108  */
109 library SafeMath {
110     /**
111      * @dev Multiplies two unsigned integers, reverts on overflow.
112      */
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115         // benefit is lost if 'b' is also tested.
116         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
117         if (a == 0) {
118             return 0;
119         }
120 
121         uint256 c = a * b;
122         require(c / a == b);
123 
124         return c;
125     }
126 
127     /**
128      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
129      */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         // Solidity only automatically asserts when dividing by 0
132         require(b > 0);
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135 
136         return c;
137     }
138 
139     /**
140      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
141      */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         require(b <= a);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Adds two unsigned integers, reverts on overflow.
151      */
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a);
155 
156         return c;
157     }
158 
159     /**
160      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
161      * reverts when dividing by zero.
162      */
163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b != 0);
165         return a % b;
166     }
167 }
168 
169 // File: contracts/Airdrop.sol
170 
171 pragma solidity 0.5.4;
172 
173 
174 
175 
176 contract Airdrop is Ownable {
177     
178     using SafeMath for uint256;
179     
180     IERC20 public token;
181     
182     constructor(address _tokenAddress)public {
183         require(_tokenAddress != address(0));
184         
185         token = IERC20(_tokenAddress);
186     }
187     
188     function multisend(
189         address[] calldata dests, 
190         uint256[] calldata values
191     ) 
192         external 
193         onlyOwner 
194     {
195         require(
196             dests.length == values.length, 
197             "Number of addresses and values should be same"
198         );
199                 
200         for(uint256 i = 0; i<dests.length; i = i.add(1)) {
201             require(
202                 token.transferFrom(msg.sender, dests[i], values[i])
203             );
204         }
205     }
206 }