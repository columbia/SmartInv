1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner {
30     if (newOwner != address(0)) {
31       owner = newOwner;
32     }
33   }
34 
35 }
36 
37 contract VAtomOwner is Ownable {
38 
39     mapping (string => string) vatoms;
40 
41     function setVAtomOwner(string vatomID, string ownerID) public onlyOwner {
42         vatoms[vatomID] = ownerID;
43     }
44 
45     function getVatomOwner(string vatomID) public constant returns(string) {
46         return vatoms[vatomID];
47     }
48 }