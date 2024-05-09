1 pragma solidity 0.4.24;
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
108      * @dev called by the owner to lock, triggers locked state
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
128     function transferFrom(address from_, address to_, uint value_) external returns (bool);
129     function transfer(address to_, uint value_) external returns (bool);
130     function balanceOf(address owner_) external returns (uint);
131 }
132 
133 // File: contracts/base/BaseAirdrop.sol
134 
135 contract BaseAirdrop is Lockable {
136     using SafeMath for uint;
137 
138     ERC20Token public token;
139 
140     address public tokenHolder;
141 
142     mapping(address => bool) public users;
143 
144     event AirdropToken(address indexed to, uint amount);
145 
146     constructor(address _token, address _tokenHolder) public {
147         require(_token != address(0) && _tokenHolder != address(0));
148         token = ERC20Token(_token);
149         tokenHolder = _tokenHolder;
150     }
151 
152     function airdrop(uint8 v, bytes32 r, bytes32 s, uint amount) public whenNotLocked {
153         if (users[msg.sender] || ecrecover(prefixedHash(amount), v, r, s) != owner) {
154             revert();
155         }
156         users[msg.sender] = true;
157         token.transferFrom(tokenHolder, msg.sender, amount);
158         emit AirdropToken(msg.sender, amount);
159     }
160 
161     function getAirdropStatus(address user) public constant returns (bool success) {
162         return users[user];
163     }
164 
165     function originalHash(uint amount) internal view returns (bytes32) {
166         return keccak256(abi.encodePacked(
167                 "Signed for Airdrop",
168                 address(this),
169                 address(token),
170                 msg.sender,
171                 amount
172             ));
173     }
174 
175     function prefixedHash(uint amount) internal view returns (bytes32) {
176         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
177         return keccak256(abi.encodePacked(prefix, originalHash(amount)));
178     }
179 }
180 
181 // File: contracts/BITOXAirdrop.sol
182 
183 /**
184  * @title BITOX token airdrop contract.
185  */
186 contract BITOXAirdrop is BaseAirdrop {
187 
188     constructor(address _token, address _tokenHolder) public BaseAirdrop(_token, _tokenHolder) {
189         locked = true;
190     }
191 
192     // Disable direct payments
193     function() external payable {
194         revert();
195     }
196 
197     // withdraw funds only for owner
198     function withdraw() public onlyOwner {
199         owner.transfer(address(this).balance);
200     }
201 
202     // withdraw stuck tokens only for owner
203     function withdrawTokens(address _someToken) public onlyOwner {
204         ERC20Token someToken = ERC20Token(_someToken);
205         uint balance = someToken.balanceOf(this);
206         someToken.transfer(owner, balance);
207     }
208 }