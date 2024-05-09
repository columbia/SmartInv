1 pragma solidity 0.4.19;
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
45 contract DataCentre is Ownable {
46     struct Container {
47         mapping(bytes32 => uint256) values;
48         mapping(bytes32 => address) addresses;
49         mapping(bytes32 => bool) switches;
50         mapping(address => uint256) balances;
51         mapping(address => mapping (address => uint)) constraints;
52     }
53 
54     mapping(bytes32 => Container) containers;
55 
56     // Owner Functions
57     function setValue(bytes32 _container, bytes32 _key, uint256 _value) onlyOwner {
58         containers[_container].values[_key] = _value;
59     }
60 
61     function setAddress(bytes32 _container, bytes32 _key, address _value) onlyOwner {
62         containers[_container].addresses[_key] = _value;
63     }
64 
65     function setBool(bytes32 _container, bytes32 _key, bool _value) onlyOwner {
66         containers[_container].switches[_key] = _value;
67     }
68 
69     function setBalanace(bytes32 _container, address _key, uint256 _value) onlyOwner {
70         containers[_container].balances[_key] = _value;
71     }
72 
73 
74     function setConstraint(bytes32 _container, address _source, address _key, uint256 _value) onlyOwner {
75         containers[_container].constraints[_source][_key] = _value;
76     }
77 
78     // Constant Functions
79     function getValue(bytes32 _container, bytes32 _key) constant returns(uint256) {
80         return containers[_container].values[_key];
81     }
82 
83     function getAddress(bytes32 _container, bytes32 _key) constant returns(address) {
84         return containers[_container].addresses[_key];
85     }
86 
87     function getBool(bytes32 _container, bytes32 _key) constant returns(bool) {
88         return containers[_container].switches[_key];
89     }
90 
91     function getBalanace(bytes32 _container, address _key) constant returns(uint256) {
92         return containers[_container].balances[_key];
93     }
94 
95     function getConstraint(bytes32 _container, address _source, address _key) constant returns(uint256) {
96         return containers[_container].constraints[_source][_key];
97     }
98 }