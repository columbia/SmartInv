1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10 
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 /**
45   *  Whitelist contract
46   */
47 contract Whitelist is Ownable {
48 
49    mapping (address => bool) public whitelist;
50    event Registered(address indexed _addr);
51    event Unregistered(address indexed _addr);
52 
53    modifier onlyWhitelisted(address _addr) {
54      require(whitelist[_addr]);
55      _;
56    }
57 
58    function isWhitelist(address _addr) public view returns (bool listed) {
59      return whitelist[_addr];
60    }
61 
62    function registerAddress(address _addr) public onlyOwner {
63      require(_addr != address(0) && whitelist[_addr] == false);
64      whitelist[_addr] = true;
65      Registered(_addr);
66    }
67 
68    function registerAddresses(address[] _addrs) public onlyOwner {
69      for(uint256 i = 0; i < _addrs.length; i++) {
70        require(_addrs[i] != address(0) && whitelist[_addrs[i]] == false);
71        whitelist[_addrs[i]] = true;
72        Registered(_addrs[i]);
73      }
74    }
75 
76    function unregisterAddress(address _addr) public onlyOwner onlyWhitelisted(_addr) {
77        whitelist[_addr] = false;
78        Unregistered(_addr);
79    }
80 
81    function unregisterAddresses(address[] _addrs) public onlyOwner {
82      for(uint256 i = 0; i < _addrs.length; i++) {
83        require(whitelist[_addrs[i]]);
84        whitelist[_addrs[i]] = false;
85        Unregistered(_addrs[i]);
86      }
87    }
88 
89 }