1 pragma solidity ^0.5.7;
2 
3 
4 // Batch transfer Ether and Wesion
5 
6 /**
7  * @title SafeMath for uint256
8  * @dev Unsigned math operations with safety checks that revert on error.
9  */
10 library SafeMath256 {
11     /**
12      * @dev Multiplies two unsigned integers, reverts on overflow.
13      */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         if (a == 0) {
16             return 0;
17         }
18         c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 }
23 
24 
25 /**
26  * @title Ownable
27  */
28 contract Ownable {
29     address private _owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     /**
34      * @dev The Ownable constructor sets the original `owner` of the contract
35      * to the sender account.
36      */
37     constructor () internal {
38         _owner = msg.sender;
39     }
40 
41     /**
42      * @return The address of the owner.
43      */
44     function owner() public view returns (address) {
45         return _owner;
46     }
47 
48     /**
49      * @dev Throws if called by any account other than the owner.
50      */
51     modifier onlyOwner() {
52         require(msg.sender == _owner);
53         _;
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) external onlyOwner {
61         require(newOwner != address(0));
62         address __previousOwner = _owner;
63         _owner = newOwner;
64         emit OwnershipTransferred(__previousOwner, newOwner);
65     }
66 
67     /**
68      * @dev Rescue compatible ERC20 Token
69      *
70      * @param tokenAddr ERC20 The address of the ERC20 token contract
71      * @param receiver The address of the receiver
72      * @param amount uint256
73      */
74     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
75         IERC20 __token = IERC20(tokenAddr);
76         require(receiver != address(0));
77         uint256 __balance = __token.balanceOf(address(this));
78 
79         require(__balance >= amount);
80         assert(__token.transfer(receiver, amount));
81     }
82 }
83 
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://eips.ethereum.org/EIPS/eip-20
88  */
89 interface IERC20{
90     function balanceOf(address owner) external view returns (uint256);
91     function transfer(address to, uint256 value) external returns (bool);
92     function transferFrom(address from, address to, uint256 value) external returns (bool);
93     function allowance(address owner, address spender) external view returns (uint256);
94 }
95 
96 
97 /**
98  * @title Batch Transfer Ether And Wesion
99  */
100 contract BatchTransferEtherAndWesion is Ownable{
101     using SafeMath256 for uint256;
102 
103     IERC20 VOKEN = IERC20(0xF0921CF26f6BA21739530ccA9ba2548bB34308f1);
104 
105     /**
106      * @dev Batch transfer both.
107      */
108     function batchTransfer(address payable[] memory accounts, uint256 etherValue, uint256 vokenValue) public payable {
109         uint256 __etherBalance = address(this).balance;
110         uint256 __vokenAllowance = VOKEN.allowance(msg.sender, address(this));
111 
112         require(__etherBalance >= etherValue.mul(accounts.length));
113         require(__vokenAllowance >= vokenValue.mul(accounts.length));
114 
115         for (uint256 i = 0; i < accounts.length; i++) {
116             accounts[i].transfer(etherValue);
117             assert(VOKEN.transferFrom(msg.sender, accounts[i], vokenValue));
118         }
119     }
120 
121     /**
122      * @dev Batch transfer Ether.
123      */
124     function batchTtransferEther(address payable[] memory accounts, uint256 etherValue) public payable {
125         uint256 __etherBalance = address(this).balance;
126 
127         require(__etherBalance >= etherValue.mul(accounts.length));
128 
129         for (uint256 i = 0; i < accounts.length; i++) {
130             accounts[i].transfer(etherValue);
131         }
132     }
133 
134     /**
135      * @dev Batch transfer Wesion.
136      */
137     function batchTransferWesion(address[] memory accounts, uint256 vokenValue) public {
138         uint256 __vokenAllowance = VOKEN.allowance(msg.sender, address(this));
139 
140         require(__vokenAllowance >= vokenValue.mul(accounts.length));
141 
142         for (uint256 i = 0; i < accounts.length; i++) {
143             assert(VOKEN.transferFrom(msg.sender, accounts[i], vokenValue));
144         }
145     }
146 }