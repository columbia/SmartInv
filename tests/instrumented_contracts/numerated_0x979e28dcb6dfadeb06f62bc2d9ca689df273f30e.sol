1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10 
11     address public owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17     * account.
18     */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     /**
24     * @dev Throws if called by any account other than the owner.
25     */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32     * @dev Allows the current owner to transfer control of the contract to a newOwner.
33     * @param newOwner The address to transfer ownership to.
34     */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 
44 contract Allow is Ownable {
45     mapping(address => bool) public allowedMap;
46     address[] public allowedArray;
47 
48     event AddressAllowed(address _handler, address _address);
49     event AddressDenied(address _handler, address _address);
50 
51     constructor() public {
52 
53     }
54 
55     modifier allow() {
56         require(allowedMap[msg.sender] == true);
57         _;
58     }
59 
60     function allowAccess(address _address) onlyOwner public {
61         allowedMap[_address] = true;
62         bool exists = false;
63         for(uint i = 0; i < allowedArray.length; i++) {
64             if(allowedArray[i] == _address) {
65                 exists = true;
66                 break;
67             }
68         }
69         if(!exists) {
70             allowedArray.push(_address);
71         }
72         emit AddressAllowed(msg.sender, _address);
73     }
74 
75     function denyAccess(address _address) onlyOwner public {
76         allowedMap[_address] = false;
77         emit AddressDenied(msg.sender, _address);
78     }
79 }
80 
81 
82 contract Copyright is Allow {
83     bytes32[] public list;
84 
85     event SetLog(bytes32 hash, uint256 id);
86 
87     constructor() public  {
88     }
89 
90     function save(bytes32 _hash) allow public {
91         list.push(_hash);
92 
93         emit SetLog(_hash, list.length-1);
94     }
95 
96     function count() public view returns(uint256) {
97         return list.length;
98     }
99 }