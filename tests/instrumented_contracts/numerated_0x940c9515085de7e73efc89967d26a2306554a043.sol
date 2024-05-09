1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 contract ERC20Basic {
45   function totalSupply() public view returns (uint256);
46   function balanceOf(address who) public view returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 contract Bounty is Ownable {
52     function Bounty() public {
53         owner = msg.sender;
54     }
55     
56     function sendToMe() public onlyOwner {
57         msg.sender.transfer(this.balance);
58     }
59     
60     function sendTokensToMe(address token, uint amount) public onlyOwner {
61         ERC20Basic(token).transfer(msg.sender, amount);
62     }
63     
64     function () payable {
65     }
66 }