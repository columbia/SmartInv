1 pragma solidity ^0.5.7;
2 
3 // Wesion Service Nodes Fund
4 
5 /**
6  * @title Ownable
7  */
8 contract Ownable {
9     address internal _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract
15      * to the sender account.
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
33         require(msg.sender == _owner);
34         _;
35     }
36 
37     /**
38      * @dev Allows the current owner to transfer control of the contract to a newOwner.
39      * @param newOwner The address to transfer ownership to.
40      */
41     function transferOwnership(address newOwner) external onlyOwner {
42         require(newOwner != address(0));
43         _owner = newOwner;
44         emit OwnershipTransferred(_owner, newOwner);
45     }
46 
47     /**
48      * @dev Rescue compatible ERC20 Token
49      *
50      * @param tokenAddr ERC20 The address of the ERC20 token contract
51      * @param receiver The address of the receiver
52      * @param amount uint256
53      */
54     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
55         IERC20 _token = IERC20(tokenAddr);
56         require(receiver != address(0));
57         uint256 balance = _token.balanceOf(address(this));
58 
59         require(balance >= amount);
60         assert(_token.transfer(receiver, amount));
61     }
62 
63     /**
64      * @dev Withdraw Ether
65      */
66     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
67         require(to != address(0));
68 
69         uint256 balance = address(this).balance;
70 
71         require(balance >= amount);
72         to.transfer(amount);
73     }
74 }
75 
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://eips.ethereum.org/EIPS/eip-20
80  */
81 interface IERC20{
82     function balanceOf(address owner) external view returns (uint256);
83     function transfer(address to, uint256 value) external returns (bool);
84 }
85 
86 
87 /**
88  * @title Wesion Service Nodes Fund
89  */
90 contract WesionServiceNodesFund is Ownable{
91     IERC20 public Wesion;
92 
93     event Donate(address indexed account, uint256 amount);
94 
95     /**
96      * @dev constructor
97      */
98     constructor() public {
99         Wesion = IERC20(0x2c1564A74F07757765642ACef62a583B38d5A213);
100     }
101 
102     /**
103      * @dev donate
104      */
105     function () external payable {
106         emit Donate(msg.sender, msg.value);
107     }
108 
109     /**
110      * @dev transfer Wesion
111      */
112     function transferWesion(address to, uint256 amount) external onlyOwner {
113         assert(Wesion.transfer(to, amount));
114     }
115 
116     /**
117      * @dev batch transfer
118      */
119     function batchTransfer(address[] memory accounts, uint256[] memory values) public onlyOwner {
120         require(accounts.length == values.length);
121         for (uint256 i = 0; i < accounts.length; i++) {
122             assert(Wesion.transfer(accounts[i], values[i]));
123         }
124     }
125 
126     /**
127      * @dev set Wesion Address
128      */
129     function setWesionAddress(address _WesionAddr) public onlyOwner {
130         Wesion = IERC20(_WesionAddr);
131     }
132 }