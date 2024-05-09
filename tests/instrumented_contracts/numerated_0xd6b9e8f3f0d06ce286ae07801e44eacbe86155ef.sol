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
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    */
39   function renounceOwnership() public onlyOwner {
40     emit OwnershipRenounced(owner);
41     owner = address(0);
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param _newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address _newOwner) public onlyOwner {
49     _transferOwnership(_newOwner);
50   }
51 
52   /**
53    * @dev Transfers control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function _transferOwnership(address _newOwner) internal {
57     require(_newOwner != address(0));
58     emit OwnershipTransferred(owner, _newOwner);
59     owner = _newOwner;
60   }
61 }
62 
63 
64 /**
65  * @title KYC
66  * @dev KYC contract handles the white list for PLCCrowdsale contract
67  * Only accounts registered in KYC contract can buy PLC token.
68  * Admins can register account, and the reason why
69  */
70 contract KYC is Ownable {
71   // check the address is registered for token sale
72   mapping (address => bool) public registeredAddress;
73 
74   // check the address is admin of kyc contract
75   mapping (address => bool) public admin;
76 
77   event Registered(address indexed _addr);
78   event Unregistered(address indexed _addr);
79   event SetAdmin(address indexed _addr, bool indexed _isAdmin);
80 
81   /**
82    * @dev check whether the msg.sender is admin or not
83    */
84   modifier onlyAdmin() {
85     require(admin[msg.sender]);
86     _;
87   }
88 
89   function KYC() public {
90     admin[msg.sender] = true;
91   }
92 
93   /**
94    * @dev set new admin as admin of KYC contract
95    * @param _addr address The address to set as admin of KYC contract
96    */
97   function setAdmin(address _addr, bool _isAdmin)
98     public
99     onlyOwner
100   {
101     require(_addr != address(0));
102     admin[_addr] = _isAdmin;
103 
104     emit SetAdmin(_addr, _isAdmin);
105   }
106 
107   /**
108    * @dev register the address for token sale
109    * @param _addr address The address to register for token sale
110    */
111   function register(address _addr)
112     public
113     onlyAdmin
114   {
115     require(_addr != address(0));
116 
117     registeredAddress[_addr] = true;
118 
119     emit Registered(_addr);
120   }
121 
122   /**
123    * @dev register the addresses for token sale
124    * @param _addrs address[] The addresses to register for token sale
125    */
126   function registerByList(address[] _addrs)
127     public
128     onlyAdmin
129   {
130     for(uint256 i = 0; i < _addrs.length; i++) {
131       require(_addrs[i] != address(0));
132 
133       registeredAddress[_addrs[i]] = true;
134 
135       emit Registered(_addrs[i]);
136     }
137   }
138 
139   /**
140    * @dev unregister the registered address
141    * @param _addr address The address to unregister for token sale
142    */
143   function unregister(address _addr)
144     public
145     onlyAdmin
146   {
147     registeredAddress[_addr] = false;
148 
149     emit Unregistered(_addr);
150   }
151 
152   /**
153    * @dev unregister the registered addresses
154    * @param _addrs address[] The addresses to unregister for token sale
155    */
156   function unregisterByList(address[] _addrs)
157     public
158     onlyAdmin
159   {
160     for(uint256 i = 0; i < _addrs.length; i++) {
161       registeredAddress[_addrs[i]] = false;
162 
163       emit Unregistered(_addrs[i]);
164     }
165   }
166 }