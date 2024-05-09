1 pragma solidity ^0.5.7;
2 
3 // Voken Business Fund
4 // 
5 // More info:
6 //   https://vision.network
7 //   https://voken.io
8 //
9 // Contact us:
10 //   support@vision.network
11 //   support@voken.io
12 
13 
14 /**
15  * @title Ownable
16  */
17 contract Ownable {
18     address internal _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     /**
23      * @dev The Ownable constructor sets the original `owner` of the contract
24      * to the sender account.
25      */
26     constructor () internal {
27         _owner = msg.sender;
28         emit OwnershipTransferred(address(0), _owner);
29     }
30 
31     /**
32      * @return the address of the owner.
33      */
34     function owner() public view returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(msg.sender == _owner);
43         _;
44     }
45 
46     /**
47      * @dev Allows the current owner to transfer control of the contract to a newOwner.
48      * @param newOwner The address to transfer ownership to.
49      */
50     function transferOwnership(address newOwner) external onlyOwner {
51         require(newOwner != address(0));
52         _owner = newOwner;
53         emit OwnershipTransferred(_owner, newOwner);
54     }
55 
56     /**
57      * @dev Rescue compatible ERC20 Token
58      *
59      * @param tokenAddr ERC20 The address of the ERC20 token contract
60      * @param receiver The address of the receiver
61      * @param amount uint256
62      */
63     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
64         IERC20 _token = IERC20(tokenAddr);
65         require(receiver != address(0));
66         uint256 balance = _token.balanceOf(address(this));
67 
68         require(balance >= amount);
69         assert(_token.transfer(receiver, amount));
70     }
71 
72     /**
73      * @dev Withdraw Ether
74      */
75     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
76         require(to != address(0));
77 
78         uint256 balance = address(this).balance;
79 
80         require(balance >= amount);
81         to.transfer(amount);
82     }
83 }
84 
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://eips.ethereum.org/EIPS/eip-20
89  */
90 interface IERC20{
91     function balanceOf(address owner) external view returns (uint256);
92     function transfer(address to, uint256 value) external returns (bool);
93 }
94 
95 
96 /**
97  * @title Voken Business Fund
98  */
99 contract VokenBusinessFund is Ownable{
100     IERC20 public Voken;
101 
102     event Donate(address indexed account, uint256 amount);
103 
104     /**
105      * @dev constructor
106      */
107     constructor() public {
108         Voken = IERC20(0x82070415FEe803f94Ce5617Be1878503e58F0a6a);
109     }
110 
111     /**
112      * @dev donate
113      */
114     function () external payable {
115         emit Donate(msg.sender, msg.value);
116     }
117 
118     /**
119      * @dev transfer Voken
120      */
121     function transferVoken(address to, uint256 amount) external onlyOwner {
122         assert(Voken.transfer(to, amount));
123     }
124 
125     /**
126      * @dev batch transfer
127      */
128     function batchTransfer(address[] memory accounts, uint256[] memory values) public onlyOwner {
129         require(accounts.length == values.length);
130         for (uint256 i = 0; i < accounts.length; i++) {
131             assert(Voken.transfer(accounts[i], values[i]));
132         }
133     }
134 }