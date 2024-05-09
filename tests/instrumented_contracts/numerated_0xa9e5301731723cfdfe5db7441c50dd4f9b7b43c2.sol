1 pragma solidity ^0.4.18;
2 
3 contract token {
4   function balanceOf(address _owner) public constant returns (uint256 balance);
5   function transfer(address _to, uint256 _value) public returns (bool success);
6 }
7 
8 contract Ownable {
9   address public owner;
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public{
16     owner = msg.sender;
17   }
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner public {
30     require(newOwner != address(0));
31     emit OwnershipTransferred(owner, newOwner);
32     owner = newOwner;
33   }
34 }
35 
36 contract TOTOAirdrop is Ownable {
37   uint public numDrops;
38   uint public dropAmount;
39   token myToken;
40 
41   function TOTOAirdrop(address dropper, address tokenContractAddress) public {
42     myToken = token(tokenContractAddress);
43     transferOwnership(dropper);
44   }
45 
46   event TokenDrop( address receiver, uint amount );
47 
48   function airDrop( address[] recipients, uint amount) onlyOwner public{
49     require( amount > 0);
50 
51     for( uint i = 0 ; i < recipients.length ; i++ ) {
52         myToken.transfer( recipients[i], amount);
53         emit TokenDrop( recipients[i], amount );
54     }
55 
56     numDrops += recipients.length;
57     dropAmount += recipients.length * amount;
58   }
59 
60 
61   function emergencyDrain( uint amount ) onlyOwner public{
62       myToken.transfer( owner, amount );
63   }
64 }