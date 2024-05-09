1 pragma solidity ^0.4.24;
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
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 /**
46  * @title KYC
47  * @dev KYC contract handles the white list for PLCCrowdsale contract
48  * Only accounts registered in KYC contract can buy PLC token.
49  * Admins can register account, and the reason why
50  */
51 contract KYC is Ownable {
52   // check the address is registered for token sale
53   mapping (address => bool) public registeredAddress;
54 
55   // check the address is admin of kyc contract
56   mapping (address => bool) public admin;
57 
58   event Registered(address indexed _addr);
59   event Unregistered(address indexed _addr);
60   event SetAdmin(address indexed _addr, bool indexed _isAdmin);
61 
62   /**
63    * @dev check whether the msg.sender is admin or not
64    */
65   modifier onlyAdmin() {
66     require(admin[msg.sender]);
67     _;
68   }
69 
70   function KYC() public {
71     admin[msg.sender] = true;
72   }
73 
74   /**
75    * @dev set new admin as admin of KYC contract
76    * @param _addr address The address to set as admin of KYC contract
77    */
78   function setAdmin(address _addr, bool _isAdmin)
79     public
80     onlyOwner
81   {
82     require(_addr != address(0));
83     admin[_addr] = _isAdmin;
84 
85     emit SetAdmin(_addr, _isAdmin);
86   }
87 
88   /**
89    * @dev register the address for token sale
90    * @param _addr address The address to register for token sale
91    */
92   function register(address _addr)
93     public
94     onlyAdmin
95   {
96     require(_addr != address(0));
97 
98     registeredAddress[_addr] = true;
99 
100     emit Registered(_addr);
101   }
102 
103   /**
104    * @dev register the addresses for token sale
105    * @param _addrs address[] The addresses to register for token sale
106    */
107   function registerByList(address[] _addrs)
108     public
109     onlyAdmin
110   {
111     for(uint256 i = 0; i < _addrs.length; i++) {
112       require(_addrs[i] != address(0));
113 
114       registeredAddress[_addrs[i]] = true;
115 
116       emit Registered(_addrs[i]);
117     }
118   }
119 
120   /**
121    * @dev unregister the registered address
122    * @param _addr address The address to unregister for token sale
123    */
124   function unregister(address _addr)
125     public
126     onlyAdmin
127   {
128     registeredAddress[_addr] = false;
129 
130     emit Unregistered(_addr);
131   }
132 
133   /**
134    * @dev unregister the registered addresses
135    * @param _addrs address[] The addresses to unregister for token sale
136    */
137   function unregisterByList(address[] _addrs)
138     public
139     onlyAdmin
140   {
141     for(uint256 i = 0; i < _addrs.length; i++) {
142       registeredAddress[_addrs[i]] = false;
143 
144       emit Unregistered(_addrs[i]);
145     }
146   }
147 }