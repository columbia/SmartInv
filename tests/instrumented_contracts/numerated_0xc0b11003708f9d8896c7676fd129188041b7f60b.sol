1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor() public {
18         owner = msg.sender;
19     }
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30      * @dev Allows the current owner to transfer control of the contract to a newOwner.
31      * @param _newOwner The address to transfer ownership to.
32      */
33     function transferOwnership(address _newOwner) public onlyOwner {
34         require(_newOwner != address(0));
35         emit OwnershipTransferred(owner, _newOwner);
36         owner = _newOwner;
37     }
38 }
39 
40 contract Whitelist is Ownable {
41 
42   address public opsAddress;
43   mapping(address => uint8) public whitelist;
44 
45   event WhitelistUpdated(address indexed _account, uint8 _phase);
46 
47   function isWhitelisted(address _account) public constant returns (bool) {
48       return whitelist[_account] == 1;
49   }
50 
51   /**
52  *  @notice function to whitelist an address which can be called only by the ops address.
53  *
54  *  @param _account account address to be whitelisted
55  *  @param _phase 0: unwhitelisted, 1: whitelisted
56 
57  *
58  *  @return bool address is successfully whitelisted/unwhitelisted.
59  */
60 function updateWhitelist(
61     address _account,
62     uint8 _phase) public
63     returns (bool)
64 {
65     require(_account != address(0));
66     require(_phase <= 1);
67     require(isOps(msg.sender));
68 
69     whitelist[_account] = _phase;
70 
71     emit WhitelistUpdated(_account, _phase);
72 
73     return true;
74 }
75 
76 
77   /** Internal Functions */
78   /**
79    *  @notice checks If the sender is the owner of the contract.
80    *
81    *  @param _address address to be checked if valid owner or not.
82    *
83    *  @return bool valid owner or not.
84    */
85   function isOwner(
86       address _address)
87       internal
88       view
89       returns (bool)
90   {
91       return (_address == owner);
92   }
93   /**
94    *  @notice check If the sender is the ops address.
95    *
96    *  @param _address address to be checked for ops.
97    *
98    *  @return bool valid ops or not.
99    */
100   function isOps(
101       address _address)
102       internal
103       view
104       returns (bool)
105   {
106       return (opsAddress != address(0) && _address == opsAddress) || isOwner(_address);
107   }
108 
109   /** External Functions */
110 
111   /**
112    *  @notice Owner can change the verified operator address.
113    *
114    *  @param _opsAddress address to be set as ops.
115    *
116    *  @return bool address is successfully set as ops or not.
117    */
118   function setOpsAddress(
119       address _opsAddress)
120       external
121       onlyOwner
122       returns (bool)
123   {
124       require(_opsAddress != owner);
125       require(_opsAddress != address(this));
126       require(_opsAddress != address(0));
127 
128       opsAddress = _opsAddress;
129 
130       return true;
131   }
132 
133 }