1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23   event OwnershipRenounced(address indexed previousOwner);
24   event OwnershipTransferred(
25     address indexed previousOwner,
26     address indexed newOwner
27   );
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   constructor() public {
34     owner = msg.sender;
35   }
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   /**
46    * @dev Allows the current owner to relinquish control of the contract.
47    */
48   function renounceOwnership() public onlyOwner {
49     emit OwnershipRenounced(owner);
50     owner = address(0);
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address _newOwner) public onlyOwner {
58     _transferOwnership(_newOwner);
59   }
60 
61   /**
62    * @dev Transfers control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function _transferOwnership(address _newOwner) internal {
66     require(_newOwner != address(0));
67     emit OwnershipTransferred(owner, _newOwner);
68     owner = _newOwner;
69   }
70 }
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender)
78     public view returns (uint256);
79 
80   function transferFrom(address from, address to, uint256 value)
81     public returns (bool);
82 
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 contract Airdropper is Ownable {
92   function multisend(address _tokenAddr, address[] dests, uint256[] values)
93   public
94   onlyOwner
95   returns (uint256) {
96     uint256 i = 0;
97     while (i < dests.length) {
98       ERC20(_tokenAddr).transfer(dests[i], values[i]);
99       i += 1;
100     }
101     return(i);
102   }
103 }