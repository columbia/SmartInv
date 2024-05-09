1 // Created using ICO Wizard https://github.com/poanetwork/ico-wizard by POA Network 
2 pragma solidity ^0.4.11;
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 
48 
49 
50 /**
51  * Registry of contracts deployed from ICO Wizard.
52  */
53 contract Registry is Ownable {
54   mapping (address => address[]) public deployedContracts;
55 
56   event Added(address indexed sender, address indexed deployAddress);
57 
58   function add(address deployAddress) public {
59     deployedContracts[msg.sender].push(deployAddress);
60     Added(msg.sender, deployAddress);
61   }
62 
63   function count(address deployer) constant returns (uint) {
64     return deployedContracts[deployer].length;
65   }
66 }