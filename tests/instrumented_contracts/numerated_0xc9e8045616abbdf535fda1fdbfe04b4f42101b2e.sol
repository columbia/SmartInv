1 pragma solidity ^0.4.18;
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
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 
48 
49 /**
50  * @title KYC
51  * @dev KYC contract handles the white list for ASTCrowdsale contract
52  * Only accounts registered in KYC contract can buy AST token.
53  * Admins can register account, and the reason why
54  */
55 contract KYC is Ownable {
56   // check the address is registered for token sale
57   // first boolean is true if presale else false
58   // second boolean is true if registered else false
59   mapping (address => mapping (bool => bool)) public registeredAddress;
60 
61   // check the address is admin of kyc contract
62   mapping (address => bool) public admin;
63 
64   event Registered(address indexed _addr);
65   event Unregistered(address indexed _addr);
66   event SetAdmin(address indexed _addr);
67 
68   /**
69    * @dev check whether the address is registered for token sale or not.
70    * @param _addr address
71    * @param _isPresale bool Whether the address is registered to presale or mainsale
72    */
73   modifier onlyRegistered(address _addr, bool _isPresale) {
74     require(registeredAddress[_addr][_isPresale]);
75     _;
76   }
77 
78   /**
79    * @dev check whether the msg.sender is admin or not
80    */
81   modifier onlyAdmin() {
82     require(admin[msg.sender]);
83     _;
84   }
85 
86   function KYC() public {
87     admin[msg.sender] = true;
88   }
89 
90   /**
91    * @dev set new admin as admin of KYC contract
92    * @param _addr address The address to set as admin of KYC contract
93    */
94   function setAdmin(address _addr, bool _value)
95     public
96     onlyOwner
97     returns (bool)
98   {
99     require(_addr != address(0));
100     require(admin[_addr] == !_value);
101 
102     admin[_addr] = _value;
103 
104     SetAdmin(_addr);
105 
106     return true;
107   }
108 
109   /**
110    * @dev check the address is register
111    * @param _addr address The address to check
112    * @param _isPresale bool Whether the address is registered to presale or mainsale
113    */
114   function isRegistered(address _addr, bool _isPresale)
115     public
116     view
117     returns (bool)
118   {
119     return registeredAddress[_addr][_isPresale];
120   }
121 
122   /**
123    * @dev register the address for token sale
124    * @param _addr address The address to register for token sale
125    * @param _isPresale bool Whether register to presale or mainsale
126    */
127   function register(address _addr, bool _isPresale)
128     public
129     onlyAdmin
130   {
131     require(_addr != address(0) && registeredAddress[_addr][_isPresale] == false);
132 
133     registeredAddress[_addr][_isPresale] = true;
134 
135     Registered(_addr);
136   }
137 
138   /**
139    * @dev register the addresses for token sale
140    * @param _addrs address[] The addresses to register for token sale
141    * @param _isPresale bool Whether register to presale or mainsale
142    */
143   function registerByList(address[] _addrs, bool _isPresale)
144     public
145     onlyAdmin
146   {
147     for(uint256 i = 0; i < _addrs.length; i++) {
148       register(_addrs[i], _isPresale);
149     }
150   }
151 
152   /**
153    * @dev unregister the registered address
154    * @param _addr address The address to unregister for token sale
155    * @param _isPresale bool Whether unregister to presale or mainsale
156    */
157   function unregister(address _addr, bool _isPresale)
158     public
159     onlyAdmin
160     onlyRegistered(_addr, _isPresale)
161   {
162     registeredAddress[_addr][_isPresale] = false;
163 
164     Unregistered(_addr);
165   }
166 
167   /**
168    * @dev unregister the registered addresses
169    * @param _addrs address[] The addresses to unregister for token sale
170    * @param _isPresale bool Whether unregister to presale or mainsale
171    */
172   function unregisterByList(address[] _addrs, bool _isPresale)
173     public
174     onlyAdmin
175   {
176     for(uint256 i = 0; i < _addrs.length; i++) {
177       unregister(_addrs[i], _isPresale);
178     }
179   }
180 }