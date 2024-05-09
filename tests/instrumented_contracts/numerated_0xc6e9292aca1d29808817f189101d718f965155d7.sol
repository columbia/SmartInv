1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title IERC20
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender)
15         external view returns (uint256);
16 
17     function transfer(address to, uint256 value) external returns (bool);
18 
19     function approve(address spender, uint256 value)
20         external returns (bool);
21 
22     function transferFrom(address from, address to, uint256 value)
23         external returns (bool);
24 
25     event Transfer(
26         address indexed from,
27         address indexed to,
28         uint256 value
29     );
30 
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 value
35     );
36 }
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   constructor() public {
51     owner = msg.sender;
52   }
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) onlyOwner public {
67     if (newOwner != address(0)) {
68       owner = newOwner;
69     }
70   }
71 
72 }
73 
74 contract Airdropper is Ownable {
75 
76     function multisend(address _tokenAddr, address[] dests, uint256[] values)
77     onlyOwner public
78     returns (uint256) {
79         uint256 i = 0;
80         while (i < dests.length) {
81            if (IERC20(_tokenAddr).transfer(dests[i], values[i])) {
82                i += 1;
83            }
84         }
85         return(i);
86     }
87 }