1 pragma solidity ^0.4.15;
2 
3 
4 
5 contract IPFSEvents {
6   event HashAdded(address PubKey, string IPFSHash, uint ttl);
7   event HashRemoved(address PubKey, string IPFSHash);
8 }
9 
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   function Ownable() public {
28     owner = msg.sender;
29   }
30 
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) onlyOwner public {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 
54 contract Parameters is IPFSEvents,Ownable {
55   mapping (string => string) parameters;
56 
57   event ParameterSet(string name, string value);
58   uint defaultTTL;
59 
60   function Parameters(uint _defaultTTL) public {
61     defaultTTL = _defaultTTL;
62   }
63 
64   function setTTL(uint _ttl) onlyOwner public {
65     defaultTTL = _ttl;
66   }
67 
68   function setParameter(string _name, string _value) onlyOwner public {
69     ParameterSet(_name,_value);
70     parameters[_name] = _value;
71   }
72 
73   function setIPFSParameter(string _name, string _ipfsValue) onlyOwner public {
74     setParameter(_name,_ipfsValue);
75     HashAdded(this,_ipfsValue,defaultTTL);
76   }
77 
78   function getParameter(string _name) public constant returns (string){
79     return parameters[_name];
80   }
81 
82 }