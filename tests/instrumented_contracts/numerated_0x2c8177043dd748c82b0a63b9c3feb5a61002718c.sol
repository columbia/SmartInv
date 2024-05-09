1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-11
3 */
4 
5 pragma solidity ^0.5.7;
6 
7 // Wesion Migration Contract
8 
9 /**
10  * @title Ownable
11  */
12 contract Ownable {
13     address internal _owner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     /**
18      * @dev The Ownable constructor sets the original `owner` of the contract
19      * to the sender account.
20      */
21     constructor () internal {
22         _owner = msg.sender;
23         emit OwnershipTransferred(address(0), _owner);
24     }
25 
26     /**
27      * @return the address of the owner.
28      */
29     function owner() public view returns (address) {
30         return _owner;
31     }
32 
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         require(msg.sender == _owner);
38         _;
39     }
40 
41     /**
42      * @dev Allows the current owner to transfer control of the contract to a newOwner.
43      * @param newOwner The address to transfer ownership to.
44      */
45     function transferOwnership(address newOwner) external onlyOwner {
46         require(newOwner != address(0));
47         _owner = newOwner;
48         emit OwnershipTransferred(_owner, newOwner);
49     }
50 
51     /**
52      * @dev Rescue compatible ERC20 Token
53      *
54      * @param tokenAddr ERC20 The address of the ERC20 token contract
55      * @param receiver The address of the receiver
56      * @param amount uint256
57      */
58     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
59         IERC20 _token = IERC20(tokenAddr);
60         require(receiver != address(0));
61         uint256 balance = _token.balanceOf(address(this));
62 
63         require(balance >= amount);
64         assert(_token.transfer(receiver, amount));
65     }
66 
67     /**
68      * @dev Withdraw Ether
69      */
70     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
71         require(to != address(0));
72 
73         uint256 balance = address(this).balance;
74 
75         require(balance >= amount);
76         to.transfer(amount);
77     }
78 }
79 
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://eips.ethereum.org/EIPS/eip-20
84  */
85 interface IERC20{
86     function balanceOf(address owner) external view returns (uint256);
87     function transfer(address to, uint256 value) external returns (bool);
88 }
89 
90 
91 /**
92  * @title Wesion Migration Contract
93  */
94 contract WesionMigration is Ownable{
95     IERC20 public Wesion;
96 
97     event Donate(address indexed account, uint256 amount);
98 
99     /**
100      * @dev constructor
101      */
102     constructor() public {
103         Wesion = IERC20(0x2c1564A74F07757765642ACef62a583B38d5A213);
104     }
105 
106     /**
107      * @dev donate
108      */
109     function () external payable {
110         emit Donate(msg.sender, msg.value);
111     }
112 
113     /**
114      * @dev transfer Wesion
115      */
116     function transferWesion(address to, uint256 amount) external onlyOwner {
117         assert(Wesion.transfer(to, amount));
118     }
119 
120     /**
121      * @dev batch transfer
122      */
123     function batchTransfer(address[] memory accounts, uint256[] memory values) public onlyOwner {
124         require(accounts.length == values.length);
125         for (uint256 i = 0; i < accounts.length; i++) {
126             assert(Wesion.transfer(accounts[i], values[i]));
127         }
128     }
129 
130     /**
131      * @dev set Wesion Address
132      */
133     function setWesionAddress(address _WesionAddr) public onlyOwner {
134         Wesion = IERC20(_WesionAddr);
135     }
136 }