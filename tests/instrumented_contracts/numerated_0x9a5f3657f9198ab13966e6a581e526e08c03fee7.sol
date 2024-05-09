1 pragma solidity ^0.4.23;
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
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 contract Token{
43   function transfer(address to, uint value) returns (bool);
44 }
45 
46 contract Indorser is Ownable {
47     function multisend(address _tokenAddr, address[] _to, uint256[] _value)
48     returns (bool _success) {
49         assert(_to.length == _value.length);
50         assert(_to.length <= 150);
51         // loop through to addresses and send value
52         for (uint8 i = 0; i < _to.length; i++) {
53                 assert((Token(_tokenAddr).transfer(_to[i], _value[i])) == true);
54             }
55             return true;
56         }
57 }