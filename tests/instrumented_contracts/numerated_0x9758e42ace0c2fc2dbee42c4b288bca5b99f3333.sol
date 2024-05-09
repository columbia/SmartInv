1 pragma solidity ^0.4.25;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address who) external view returns (uint256);
6     function allowance(address owner, address spender) external view returns (uint256);
7 
8     function transfer(address to, uint256 value) external returns (bool);
9     function approve(address spender, uint256 value) external returns (bool);
10     function transferFrom(address from, address to, uint256 value) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 /**
17  * @title SafeMath
18  * @dev Unsigned math operations with safety checks that revert on error.
19  */
20 library SafeMath {
21     /**
22       * @dev Multiplies two unsigned integers, reverts on overflow.
23       */
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
26         // benefit is lost if 'b' is also tested.
27         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b);
34 
35         return c;
36     }
37 
38     /**
39       * @dev Integer division of two unsigned integers truncating the quotient,
40       * reverts on division by zero.
41       */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Solidity only automatically asserts when dividing by 0
44         require(b > 0);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51     /**
52       * @dev Subtracts two unsigned integers, reverts on overflow
53       * (i.e. if subtrahend is greater than minuend).
54       */
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b <= a);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63       * @dev Adds two unsigned integers, reverts on overflow.
64       */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a);
68 
69         return c;
70     }
71 
72     /**
73       * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
74       * reverts when dividing by zero.
75       */
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b != 0);
78         return a % b;
79     }
80 }
81 
82 /**
83  * @title Ownable
84  * @dev The Ownable contract has an owner address, and provides basic authorization control
85  * functions, this simplifies the implementation of "user permissions".
86  */
87 contract Ownable {
88     address public owner;
89 
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93 
94     /**
95      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
96      * account.
97      */
98     constructor() public {
99         owner = msg.sender;
100     }
101 
102 
103     /**
104      * @dev Throws if called by any account other than the owner.
105      */
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110 
111 
112     /**
113      * @dev Allows the current owner to transfer control of the contract to a newOwner.
114      * @param newOwner The address to transfer ownership to.
115      */
116     function transferOwnership(address newOwner) onlyOwner public {
117         require(newOwner != address(0));
118         emit OwnershipTransferred(owner, newOwner);
119         owner = newOwner;
120     }
121 
122 }
123 
124 contract FNXDistribution is Ownable {
125 
126     IERC20 public token;
127     
128     uint internal decimal = 18;
129 
130     constructor () public { }
131 
132     function setup(address _token) public onlyOwner {
133         require(_token != address(0));
134         token = IERC20(_token);
135     }
136     
137     function bulkApprovedTransfer(address[] _users, uint256[] _value) public onlyOwner returns (bool) {
138         require(token.balanceOf(address(this)) > 0);
139 
140         for (uint i = 0; i < _users.length; i++) {
141             token.transferFrom(msg.sender, _users[i], _value[i]);
142         }
143     }    
144     
145     function bulkTransfer(address[] _users, uint256[] _value) public onlyOwner returns (bool) {
146         require(token.balanceOf(address(this)) > 0);
147 
148         for (uint i = 0; i < _users.length; i++) {
149             token.transfer(_users[i], _value[i]);
150         }
151     }
152 
153     function tokenWithdrawal() public onlyOwner returns (bool) {
154         return token.transfer(owner, contractTokenBalance());
155     }
156 
157     function contractTokenBalance() view public returns (uint) {
158         return token.balanceOf(address(this));
159     }
160 
161 }