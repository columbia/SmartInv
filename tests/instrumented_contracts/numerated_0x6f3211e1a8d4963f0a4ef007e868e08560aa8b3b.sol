1 pragma solidity 0.4.23;
2 
3 // File: contracts/commons/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a / b;
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 // File: contracts/flavours/Ownable.sol
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44 
45     address public owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51      * account.
52      */
53     constructor() public {
54         owner = msg.sender;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) public onlyOwner {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73     }
74 }
75 
76 // File: contracts/flavours/Lockable.sol
77 
78 /**
79  * @title Lockable
80  * @dev Base contract which allows children to
81  *      implement main operations locking mechanism.
82  */
83 contract Lockable is Ownable {
84     event Lock();
85     event Unlock();
86 
87     bool public locked = false;
88 
89     /**
90      * @dev Modifier to make a function callable
91     *       only when the contract is not locked.
92      */
93     modifier whenNotLocked() {
94         require(!locked);
95         _;
96     }
97 
98     /**
99      * @dev Modifier to make a function callable
100      *      only when the contract is locked.
101      */
102     modifier whenLocked() {
103         require(locked);
104         _;
105     }
106 
107     /**
108      * @dev called by the owner to locke, triggers locked state
109      */
110     function lock() public onlyOwner whenNotLocked {
111         locked = true;
112         emit Lock();
113     }
114 
115     /**
116      * @dev called by the owner
117      *      to unlock, returns to unlocked state
118      */
119     function unlock() public onlyOwner whenLocked {
120         locked = false;
121         emit Unlock();
122     }
123 }
124 
125 // File: contracts/base/ERC20Token.sol
126 
127 interface ERC20Token {
128     function balanceOf(address owner_) external returns (uint);
129     function transfer(address to_, uint value_) external returns (bool);
130     function transferFrom(address from_, address to_, uint value_) external returns (bool);
131 }
132 
133 // File: contracts/base/BaseAirdrop.sol
134 
135 contract BaseAirdrop is Lockable {
136     using SafeMath for uint;
137 
138     ERC20Token public token;
139 
140     mapping(address => bool) public users;
141 
142     event AirdropToken(address indexed to, uint amount);
143 
144     constructor(address _token) public {
145         require(_token != address(0));
146         token = ERC20Token(_token);
147     }
148 
149     function airdrop(uint8 v, bytes32 r, bytes32 s) public whenNotLocked {
150         if (ecrecover(keccak256("Signed for Airdrop", address(this), address(token), msg.sender), v, r, s) != owner
151             || users[msg.sender]) {
152             revert();
153         }
154         users[msg.sender] = true;
155         uint amount = getAirdropAmount(msg.sender);
156         token.transfer(msg.sender, amount);
157         emit AirdropToken(msg.sender, amount);
158     }
159 
160     function getAirdropStatus(address user) public constant returns (bool success) {
161         return users[user];
162     }
163 
164     function getAirdropAmount(address user) public constant returns (uint amount);
165 
166     function withdrawTokens(address destination) public onlyOwner whenLocked {
167         require(destination != address(0));
168         uint balance = token.balanceOf(address(this));
169         token.transfer(destination, balance);
170     }
171 }
172 
173 // File: contracts/IONCAirdrop.sol
174 
175 /**
176  * @title IONC token airdrop contract.
177  */
178 contract IONCAirdrop is BaseAirdrop {
179 
180     uint public constant PER_USER_AMOUNT = 20023e6;
181 
182     constructor(address _token) public BaseAirdrop(_token) {
183         locked = true;
184     }
185 
186     // Disable direct payments
187     function() external payable {
188         revert();
189     }
190 
191     function getAirdropAmount(address user) public constant returns (uint amount) {
192         require(user != address(0));
193         return PER_USER_AMOUNT;
194     }
195 }