1 pragma solidity ^0.4.18;
2 
3 contract token {
4 
5   function balanceOf(address _owner) public constant returns (uint256 balance);
6   function transfer(address _to, uint256 _value) public returns (bool success);
7 
8 }
9 
10 contract Ownable {
11   address public owner;
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public{
18     owner = msg.sender;
19   }
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) onlyOwner public {
32     require(newOwner != address(0));
33     OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 }
37 
38 contract ClassyCoinAirdrop is Ownable {
39   uint public numDrops;
40   uint public dropAmount;
41   token myToken;
42 
43   function ClassyCoinAirdrop(address dropper, address tokenContractAddress) public {
44     myToken = token(tokenContractAddress);
45     transferOwnership(dropper);
46   }
47 
48   event TokenDrop( address receiver, uint amount );
49 
50   function airDrop( address[] recipients, uint amount) onlyOwner public{
51     require( amount > 0);
52 
53     for( uint i = 0 ; i < recipients.length ; i++ ) {
54         myToken.transfer( recipients[i], amount);
55         TokenDrop( recipients[i], amount );
56     }
57 
58     numDrops += recipients.length;
59     dropAmount += recipients.length * amount;
60   }
61 
62 
63   function emergencyDrain( uint amount ) onlyOwner public{
64       myToken.transfer( owner, amount );
65   }
66 }