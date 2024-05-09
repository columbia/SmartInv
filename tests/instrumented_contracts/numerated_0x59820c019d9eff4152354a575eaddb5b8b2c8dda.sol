1 pragma solidity ^0.4.15;
2 
3 contract ELTCoinToken {
4   function transfer(address to, uint256 value) public returns (bool);
5   function balanceOf(address who) public constant returns (uint256);
6 }
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14   address public owner;
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 }
44 
45 
46 contract ELTCOINLock is Ownable {
47   ELTCoinToken public token;
48 
49   uint256 public endTime;
50 
51   function ELTCOINLock(address _contractAddress, uint256 _endTime) {
52     token = ELTCoinToken(_contractAddress);
53     endTime = _endTime;
54   }
55 
56   // @return true if crowdsale event has ended
57   function hasEnded() public constant returns (bool) {
58     return now > endTime;
59   }
60 
61   /**
62   * @dev Transfer the unsold tokens to the owner main wallet
63   * @dev Only for owner
64   */
65   function drainRemainingToken () public onlyOwner {
66       require(hasEnded());
67       token.transfer(owner, token.balanceOf(this));
68   }
69 }