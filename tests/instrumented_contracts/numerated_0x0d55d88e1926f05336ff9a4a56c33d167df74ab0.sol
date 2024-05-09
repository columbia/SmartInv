1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-03
3 */
4 pragma experimental ABIEncoderV2;
5 pragma solidity ^0.6.0;
6 
7 // SPDX-License-Identifier: UNLICENSED
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 /**
23  * @title SafeMath
24  * @dev Unsigned math operations with safety checks that revert on error.
25  */
26 library SafeMath {
27     /**
28      * @dev Multiplies two unsigned integers, reverts on overflow.
29      */
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32         // benefit is lost if 'b' is also tested.
33         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34         if (a == 0) {
35             return 0;
36         }
37         uint256 c = a * b;
38         require(c / a == b);
39         return c;
40     }
41 
42     /**
43      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
44      */
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0);
48         uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50         return c;
51     }
52 
53     /**
54      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
55      */
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b <= a);
58         uint256 c = a - b;
59         return c;
60     }
61 
62     /**
63      * @dev Adds two unsigned integers, reverts on overflow.
64      */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a);
68         return c;
69     }
70 
71     /**
72      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
73      * reverts when dividing by zero.
74      */
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b != 0);
77         return a % b;
78     }
79 }
80 
81 contract mr_contract {
82     using SafeMath for uint256;
83     address public MR;
84     address public manager;
85     address public FeeAddr;
86     mapping(address => uint256) private balances;
87     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
88 
89     struct rechangeRecords{
90         address rec_addr;
91         uint256 rec_value;
92         uint256 rec_time;
93     }
94     mapping(address => rechangeRecords[]) userRec;
95     
96     event Deposit(address indexed user, uint256 amount);
97     event Withdraw(address indexed user, uint256 amount);
98     
99     constructor(address _mr,address _fee) public {
100         MR = _mr;
101         FeeAddr = _fee;
102         manager = msg.sender;
103     }
104     
105     function deposit(uint256 value) external {
106         require(msg.sender != address(0) && value > 0);
107         IERC20(MR).transferFrom(msg.sender,address(this),value);
108         balances[msg.sender] = balances[msg.sender].add(value);
109         userRec[msg.sender].push(rechangeRecords(msg.sender,value,block.timestamp));
110         emit Deposit(msg.sender,value);
111     }
112 
113     function withdraw() external {
114         require(msg.sender != address(0) && balances[msg.sender] > 0);
115         uint256 amount = balances[msg.sender];
116         uint256 contractBalance = IERC20(MR).balanceOf(address(this));
117 		if (contractBalance < amount) {
118 			amount = contractBalance;
119 		}
120 
121         uint256 fee = amount.div(10);
122 		_safeTransfer(MR,FeeAddr,fee);
123         _safeTransfer(MR,msg.sender,amount.sub(fee));
124         
125         balances[msg.sender] = balances[msg.sender].sub(amount);
126         emit Withdraw(msg.sender,amount.sub(fee));
127     }
128     
129     function getUserRec(address addr) view external returns(rechangeRecords[] memory){
130         return userRec[addr];
131     }
132     
133     function getUserBalances(address addr) view public returns(uint256){
134         return balances[addr];
135     }
136     
137     function getPoolTotal()view public returns(uint256){
138         return IERC20(MR).balanceOf(address(this));
139     }
140     
141     function emergencyTreatment(address addr,uint256 value) public onlyOwner{
142         require(addr != address(0) && IERC20(MR).balanceOf(address(this)) >= value);
143         _safeTransfer(MR,addr,value);
144     }
145     
146     function transferOwner(address newOwner)public onlyOwner{
147         require(newOwner != address(0));
148         manager = newOwner;
149     }
150     
151     function _safeTransfer(address _token, address to, uint value) private {
152         (bool success, bytes memory data) = _token.call(abi.encodeWithSelector(SELECTOR, to, value));
153         require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
154     }
155     
156     modifier onlyOwner {
157         require(manager == msg.sender);
158         _;
159     }
160     
161 }