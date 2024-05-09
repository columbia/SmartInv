1 pragma solidity ^0.4.11;
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
25     if (msg.sender != owner) {
26       throw;
27     }
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to. 
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     if (newOwner != address(0)) {
38       owner = newOwner;
39     }
40   }
41 
42 }
43 
44 contract Token{
45   function transfer(address to, uint value) returns (bool);
46 }
47 
48 contract Indorser is Ownable {
49     
50     address _tokenAddr = 0xc5594d84B996A68326d89FB35E4B89b3323ef37d;
51     
52     function multisend(address[] _to, uint256[] _value)
53     returns (bool _success) {
54         assert(_to.length == _value.length);
55         assert(_to.length <= 150);
56         // loop through to addresses and send value
57         
58         for (uint8 i = 0; i < _to.length; i++) {
59                 assert((Token(_tokenAddr).transfer(_to[i], _value[i]*10**18)) == true);
60             }
61             return true;
62         }
63 }