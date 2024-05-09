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
42 
43 }
44 
45 /**
46  * @title ModulumInvestorsWhitelist
47  * @dev ModulumInvestorsWhitelist is a smart contract which holds and manages
48  * a list whitelist of investors allowed to participate in Modulum ICO.
49  * 
50 */
51 contract ModulumInvestorsWhitelist is Ownable {
52 
53   mapping (address => bool) public isWhitelisted;
54 
55   /**
56    * @dev Contructor
57    */
58   function ModulumInvestorsWhitelist() {
59   }
60 
61   /**
62    * @dev Add a new investor to the whitelist
63    */
64   function addInvestorToWhitelist(address _address) public onlyOwner {
65     require(_address != 0x0);
66     require(!isWhitelisted[_address]);
67     isWhitelisted[_address] = true;
68   }
69 
70   /**
71    * @dev Remove an investor from the whitelist
72    */
73   function removeInvestorFromWhiteList(address _address) public onlyOwner {
74     require(_address != 0x0);
75     require(isWhitelisted[_address]);
76     isWhitelisted[_address] = false;
77   }
78 
79   /**
80    * @dev Test whether an investor
81    */
82   function isInvestorInWhitelist(address _address) constant public returns (bool result) {
83     return isWhitelisted[_address];
84   }
85 }