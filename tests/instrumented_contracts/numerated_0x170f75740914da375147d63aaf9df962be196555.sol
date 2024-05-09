1 pragma solidity 0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 contract Forwarder is Ownable {
44   address destinationAddress;
45   event LogForwarded(address indexed sender, uint amount);
46   event LogFlushed(address indexed sender, uint amount);
47 
48   function Forwarder() public {
49     destinationAddress = msg.sender;
50   }
51 
52   function() payable public {
53     emit LogForwarded(msg.sender, msg.value);
54     destinationAddress.transfer(msg.value);
55   }
56 
57   function flush(address owner) public {
58     emit LogFlushed(destinationAddress, address(this).balance);
59     destinationAddress.transfer(address(this).balance);
60   }
61 
62 }