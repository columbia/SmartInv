1 pragma solidity ^0.4.23;
2 
3 // File: contracts/token/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/Ownerable.sol
18 
19 contract Ownerable {
20     /// @notice The address of the owner is the only address that can call
21     ///  a function with this modifier
22     modifier onlyOwner { require(msg.sender == owner); _; }
23 
24     address public owner;
25 
26     constructor() public { owner = msg.sender;}
27 
28     /// @notice Changes the owner of the contract
29     /// @param _newOwner The new owner of the contract
30     function setOwner(address _newOwner) public onlyOwner {
31         owner = _newOwner;
32     }
33 }
34 
35 // File: contracts/KYC.sol
36 
37 /**
38  * @title KYC
39  * @dev KYC contract handles the white list for ASTCrowdsale contract
40  * Only accounts registered in KYC contract can buy AST token.
41  * Admins can register account, and the reason why
42  */
43 contract KYC is Ownerable {
44   // check the address is registered for token sale
45   mapping (address => bool) public registeredAddress;
46 
47   // check the address is admin of kyc contract
48   mapping (address => bool) public admin;
49 
50   event Registered(address indexed _addr);
51   event Unregistered(address indexed _addr);
52   event NewAdmin(address indexed _addr);
53   event ClaimedTokens(address _token, address owner, uint256 balance);
54 
55   /**
56    * @dev check whether the address is registered for token sale or not.
57    * @param _addr address
58    */
59   modifier onlyRegistered(address _addr) {
60     require(registeredAddress[_addr]);
61     _;
62   }
63 
64   /**
65    * @dev check whether the msg.sender is admin or not
66    */
67   modifier onlyAdmin() {
68     require(admin[msg.sender]);
69     _;
70   }
71 
72   constructor () public {
73     admin[msg.sender] = true;
74   }
75 
76   /**
77    * @dev set new admin as admin of KYC contract
78    * @param _addr address The address to set as admin of KYC contract
79    */
80   function setAdmin(address _addr)
81     public
82     onlyOwner
83   {
84     require(_addr != address(0) && admin[_addr] == false);
85     admin[_addr] = true;
86 
87     emit NewAdmin(_addr);
88   }
89 
90   /**
91    * @dev register the address for token sale
92    * @param _addr address The address to register for token sale
93    */
94   function register(address _addr)
95     public
96     onlyAdmin
97   {
98     require(_addr != address(0) && registeredAddress[_addr] == false);
99 
100     registeredAddress[_addr] = true;
101 
102     emit Registered(_addr);
103   }
104 
105   /**
106    * @dev register the addresses for token sale
107    * @param _addrs address[] The addresses to register for token sale
108    */
109   function registerByList(address[] _addrs)
110     public
111     onlyAdmin
112   {
113     for(uint256 i = 0; i < _addrs.length; i++) {
114       require(_addrs[i] != address(0) && registeredAddress[_addrs[i]] == false);
115 
116       registeredAddress[_addrs[i]] = true;
117 
118       emit Registered(_addrs[i]);
119     }
120   }
121 
122   /**
123    * @dev unregister the registered address
124    * @param _addr address The address to unregister for token sale
125    */
126   function unregister(address _addr)
127     public
128     onlyAdmin
129     onlyRegistered(_addr)
130   {
131     registeredAddress[_addr] = false;
132 
133     emit Unregistered(_addr);
134   }
135 
136   /**
137    * @dev unregister the registered addresses
138    * @param _addrs address[] The addresses to unregister for token sale
139    */
140   function unregisterByList(address[] _addrs)
141     public
142     onlyAdmin
143   {
144     for(uint256 i = 0; i < _addrs.length; i++) {
145       require(registeredAddress[_addrs[i]]);
146 
147       registeredAddress[_addrs[i]] = false;
148 
149       emit Unregistered(_addrs[i]);
150     }
151   }
152 
153   function claimTokens(address _token) public onlyOwner {
154 
155     if (_token == 0x0) {
156         owner.transfer( address(this).balance );
157         return;
158     }
159 
160     ERC20Basic token = ERC20Basic(_token);
161     uint256 balance = token.balanceOf(this);
162     token.transfer(owner, balance);
163 
164     emit ClaimedTokens(_token, owner, balance);
165   }
166 }