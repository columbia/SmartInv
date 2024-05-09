1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20 {
5   function transfer(address _recipient, uint256 _value) public returns (bool success);
6   function balanceOf(address _owner) external view returns (uint256);
7 }
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipRenounced(address indexed previousOwner);
19   event OwnershipTransferred(
20     address indexed previousOwner,
21     address indexed newOwner
22   );
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   constructor() public {
30     owner = msg.sender;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to relinquish control of the contract.
43    * @notice Renouncing to ownership will leave the contract without an owner.
44    * It will not be possible to call the functions with the `onlyOwner`
45    * modifier anymore.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address _newOwner) public onlyOwner {
57     _transferOwnership(_newOwner);
58   }
59 
60   /**
61    * @dev Transfers control of the contract to a newOwner.
62    * @param _newOwner The address to transfer ownership to.
63    */
64   function _transferOwnership(address _newOwner) internal {
65     require(_newOwner != address(0));
66     emit OwnershipTransferred(owner, _newOwner);
67     owner = _newOwner;
68   }
69 }
70 
71 contract MultiSend is Ownable {
72   function transferMultiple(address _tokenAddress, address[] recipients, uint256[] values) public onlyOwner returns (uint256) {
73     ERC20 token = ERC20(_tokenAddress);
74     for (uint256 i = 0; i < recipients.length; i++) {
75       token.transfer(recipients[i], values[i]);
76     }
77     return i;
78   }
79 
80   function emergencyERC20Drain(address _tokenAddress, address recipient) external onlyOwner returns (bool) {
81     require(recipient != address(0));
82     ERC20 token = ERC20(_tokenAddress);
83     require(token.balanceOf(this) > 0);
84     return token.transfer(recipient, token.balanceOf(this));
85   }
86 }