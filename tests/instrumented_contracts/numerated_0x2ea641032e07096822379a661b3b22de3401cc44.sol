1 pragma solidity 0.4.19;
2 
3 // File: contracts/SaleInterfaceForAllocations.sol
4 
5 contract SaleInterfaceForAllocations {
6 
7     //function from Sale.sol
8     function allocateTokens(address _contributor) external;
9 
10 }
11 
12 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
13 
14 /**
15  * @title Ownable
16  * @dev The Ownable contract has an owner address, and provides basic authorization control
17  * functions, this simplifies the implementation of "user permissions".
18  */
19 contract Ownable {
20   address public owner;
21 
22 
23   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25 
26   /**
27    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28    * account.
29    */
30   function Ownable() public {
31     owner = msg.sender;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 // File: contracts/TokenAllocator.sol
55 
56 contract TokenAllocator is Ownable {
57 
58     SaleInterfaceForAllocations public sale;
59 
60     //constructor
61     function TokenAllocator(SaleInterfaceForAllocations _sale) public {
62         sale = _sale;
63     }
64 
65     //allow the sale to be changed for single deployment
66     function updateSale(SaleInterfaceForAllocations _sale) external onlyOwner {
67         sale = _sale;
68     }
69 
70     //function to allocate tokens for a set of contributors
71     function allocateTokens(address[] _contributors) external {
72         for (uint256 i = 0; i < _contributors.length; i++) {
73             sale.allocateTokens(_contributors[i]);
74         }
75     }
76 
77 }