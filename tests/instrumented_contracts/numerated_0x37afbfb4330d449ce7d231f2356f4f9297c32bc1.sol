1 pragma solidity ^0.4.18;
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
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 }
43 
44 
45 contract DistributeETH is Ownable {
46   
47 
48   function distribute(address[] _addrs, uint[] _bals) onlyOwner public{
49     for(uint i = 0; i < _addrs.length; ++i){
50       if(!_addrs[i].send(_bals[i])) throw;
51     }
52   }
53   
54   function multiSendEth(address[] addresses) public onlyOwner{
55     for(uint i = 0; i < addresses.length; i++) {
56       addresses[i].transfer(msg.value / addresses.length);
57     }
58     msg.sender.transfer(this.balance);
59   }
60 }