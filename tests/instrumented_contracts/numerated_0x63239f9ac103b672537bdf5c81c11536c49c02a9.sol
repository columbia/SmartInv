1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
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
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
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
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/piggyBank.sol
70 
71 pragma solidity ^0.5.0;
72 
73 
74 contract PiggyBank {
75     using SafeMath for uint256;
76 
77     struct Deposit {
78         uint256 period;
79         uint256 amount;
80         bool withdrawed;
81     }
82 
83     address[] public users;
84     mapping(address => mapping(uint256 => Deposit)) public userToDeposit;
85     mapping(address => uint256[]) public userAllDeposit;
86 
87     function deposit(uint256 _period) public payable {
88         if(!isUserExist(msg.sender)) {
89             users.push(msg.sender);
90         }
91         userAllDeposit[msg.sender].push(1);
92         uint256 newId = userTotalDeposit(msg.sender);
93         userToDeposit[msg.sender][newId] = Deposit(block.timestamp.add(_period), msg.value, false);
94     }
95 
96     function extendPeriod(uint256 _secondsToExtend, uint256 _id) public {
97         userToDeposit[msg.sender][_id].period += _secondsToExtend;
98     }
99 
100     function withdraw(uint256 _id) public {
101         require(_id > 0);
102         require(userToDeposit[msg.sender][_id].amount > 0);
103         require(block.timestamp > userToDeposit[msg.sender][_id].period);
104         uint256 transferValue = userToDeposit[msg.sender][_id].amount;
105         userToDeposit[msg.sender][_id].amount = 0;
106         userToDeposit[msg.sender][_id].withdrawed = true;
107         msg.sender.transfer(transferValue);
108     }
109 
110     function isUserExist(address _user) public view returns(bool) {
111         for(uint i = 0; i < users.length; i++) {
112             if(users[i] == _user) {
113                 return true;
114             }
115         }
116         return false;
117     }
118 
119     function userTotalDeposit(address _user) public view returns(uint256) {
120         return userAllDeposit[_user].length;
121     }
122 
123 }