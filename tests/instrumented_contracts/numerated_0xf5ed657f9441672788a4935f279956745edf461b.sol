1 pragma solidity ^0.5.7;
2 
3 
4 // Batch transfer Ether and Voken
5 // 
6 // More info:
7 //   https://vision.network
8 //   https://voken.io
9 //
10 // Contact us:
11 //   support@vision.network
12 //   support@voken.io
13 
14 
15 /**
16  * @title SafeMath for uint256
17  * @dev Unsigned math operations with safety checks that revert on error.
18  */
19 library SafeMath256 {
20     /**
21      * @dev Multiplies two unsigned integers, reverts on overflow.
22      */
23     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         if (a == 0) {
25             return 0;
26         }
27         c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31 }
32 
33 
34 /**
35  * @title Ownable
36  */
37 contract Ownable {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev The Ownable constructor sets the original `owner` of the contract
44      * to the sender account.
45      */
46     constructor () internal {
47         _owner = msg.sender;
48     }
49 
50     /**
51      * @return The address of the owner.
52      */
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(msg.sender == _owner);
62         _;
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) external onlyOwner {
70         require(newOwner != address(0));
71         address __previousOwner = _owner;
72         _owner = newOwner;
73         emit OwnershipTransferred(__previousOwner, newOwner);
74     }
75 
76     /**
77      * @dev Rescue compatible ERC20 Token
78      *
79      * @param tokenAddr ERC20 The address of the ERC20 token contract
80      * @param receiver The address of the receiver
81      * @param amount uint256
82      */
83     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
84         IERC20 __token = IERC20(tokenAddr);
85         require(receiver != address(0));
86         uint256 __balance = __token.balanceOf(address(this));
87         
88         require(__balance >= amount);
89         assert(__token.transfer(receiver, amount));
90     }
91 }
92 
93 
94 /**
95  * @title ERC20 interface
96  * @dev see https://eips.ethereum.org/EIPS/eip-20
97  */
98 interface IERC20{
99     function balanceOf(address owner) external view returns (uint256);
100     function transfer(address to, uint256 value) external returns (bool);
101     function transferFrom(address from, address to, uint256 value) external returns (bool);
102     function allowance(address owner, address spender) external view returns (uint256);
103 }
104 
105 
106 /**
107  * @title Batch Transfer Ether And Voken
108  */
109 contract BatchTransferEtherAndVoken is Ownable{
110     using SafeMath256 for uint256;
111     
112     IERC20 VOKEN = IERC20(0x82070415FEe803f94Ce5617Be1878503e58F0a6a);
113 
114     /**
115      * @dev Batch transfer both.
116      */
117     function batchTransfer(address payable[] memory accounts, uint256 etherValue, uint256 vokenValue) public payable {
118         uint256 __etherBalance = address(this).balance;
119         uint256 __vokenAllowance = VOKEN.allowance(msg.sender, address(this));
120 
121         require(__etherBalance >= etherValue.mul(accounts.length));
122         require(__vokenAllowance >= vokenValue.mul(accounts.length));
123 
124         for (uint256 i = 0; i < accounts.length; i++) {
125             accounts[i].transfer(etherValue);
126             assert(VOKEN.transferFrom(msg.sender, accounts[i], vokenValue));
127         }
128     }
129 
130     /**
131      * @dev Batch transfer Ether.
132      */
133     function batchTtransferEther(address payable[] memory accounts, uint256 etherValue) public payable {
134         uint256 __etherBalance = address(this).balance;
135 
136         require(__etherBalance >= etherValue.mul(accounts.length));
137 
138         for (uint256 i = 0; i < accounts.length; i++) {
139             accounts[i].transfer(etherValue);
140         }
141     }
142 
143     /**
144      * @dev Batch transfer Voken.
145      */
146     function batchTransferVoken(address[] memory accounts, uint256 vokenValue) public {
147         uint256 __vokenAllowance = VOKEN.allowance(msg.sender, address(this));
148 
149         require(__vokenAllowance >= vokenValue.mul(accounts.length));
150 
151         for (uint256 i = 0; i < accounts.length; i++) {
152             assert(VOKEN.transferFrom(msg.sender, accounts[i], vokenValue));
153         }
154     }
155 }