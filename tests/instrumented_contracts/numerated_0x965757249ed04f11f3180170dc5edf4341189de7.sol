1 pragma solidity 0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     require(newOwner != address(0));      
37     owner = newOwner;
38   }
39 
40 }
41 
42 pragma solidity 0.4.11;
43 
44 contract Storage is Ownable {
45     struct Crate {
46         mapping(bytes32 => uint256) uints;
47         mapping(bytes32 => address) addresses;
48         mapping(bytes32 => bool) bools;
49         mapping(address => uint256) bals;
50     }
51 
52     mapping(bytes32 => Crate) crates;
53 
54     function setUInt(bytes32 _crate, bytes32 _key, uint256 _value) onlyOwner {
55         crates[_crate].uints[_key] = _value;
56     }
57 
58     function getUInt(bytes32 _crate, bytes32 _key) constant returns(uint256) {
59         return crates[_crate].uints[_key];
60     }
61 
62     function setAddress(bytes32 _crate, bytes32 _key, address _value) onlyOwner {
63         crates[_crate].addresses[_key] = _value;
64     }
65 
66     function getAddress(bytes32 _crate, bytes32 _key) constant returns(address) {
67         return crates[_crate].addresses[_key];
68     }
69 
70     function setBool(bytes32 _crate, bytes32 _key, bool _value) onlyOwner {
71         crates[_crate].bools[_key] = _value;
72     }
73 
74     function getBool(bytes32 _crate, bytes32 _key) constant returns(bool) {
75         return crates[_crate].bools[_key];
76     }
77 
78     function setBal(bytes32 _crate, address _key, uint256 _value) onlyOwner {
79         crates[_crate].bals[_key] = _value;
80     }
81 
82     function getBal(bytes32 _crate, address _key) constant returns(uint256) {
83         return crates[_crate].bals[_key];
84     }
85 }