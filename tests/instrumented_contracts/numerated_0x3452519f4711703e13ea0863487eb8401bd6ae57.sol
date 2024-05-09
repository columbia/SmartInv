1 /**
2  * @title BulkSender by Universa Blockchain.
3  */
4 
5 pragma solidity ^0.4.13;
6 
7 contract Ownable {
8   address public owner;
9 
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() public {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 contract ERC20Basic {
45   uint256 public totalSupply;
46   function balanceOf(address who) public view returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender) public view returns (uint256);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 library SafeERC20 {
59   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
60     assert(token.transfer(to, value));
61   }
62 
63   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
64     assert(token.transferFrom(from, to, value));
65   }
66 
67   function safeApprove(ERC20 token, address spender, uint256 value) internal {
68     assert(token.approve(spender, value));
69   }
70 }
71 
72 contract BulkSender is Ownable {
73     using SafeERC20 for ERC20Basic;
74 
75     /**
76      * @dev Transfer multiple batches for the same token to multiple addresses accordingly,
77      * from the ownership of the sender contract.
78      * Note: only the owner (creator) of this contract may call this.
79      */
80     function bulkTransfer(ERC20Basic token, address[] toAddresses, uint256[] values) public onlyOwner returns (bool) {
81         require((toAddresses.length > 0) && (toAddresses.length == values.length));
82         for (uint i = 0; i < toAddresses.length; i++) {
83             token.safeTransfer(toAddresses[i], values[i]);
84         }
85         return true;
86     }
87 }