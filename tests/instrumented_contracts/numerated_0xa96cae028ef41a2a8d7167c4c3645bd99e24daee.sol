1 pragma solidity ^0.4.18;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() {
25     owner = msg.sender;
26   }
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner {
39     require(newOwner != address(0));
40     owner = newOwner;
41   }
42 }
43 /**
44  * @title KYC
45  * @dev KYC contract handles the white list for ASTCrowdsale contract
46  * Only accounts registered in KYC contract can buy AST token.
47  * Admins can register account, and the reason why
48  */
49 contract KYC is Ownable {
50   // check the address is registered for token sale
51   mapping (address => bool) public registeredAddress;
52   // check the address is admin of kyc contract
53   mapping (address => bool) public admin;
54   event Registered(address indexed _addr);
55   event Unregistered(address indexed _addr);
56   event NewAdmin(address indexed _addr);
57   event ClaimedTokens(address _token, address owner, uint256 balance);
58   /**
59    * @dev check whether the address is registered for token sale or not.
60    * @param _addr address
61    */
62   modifier onlyRegistered(address _addr) {
63     require(registeredAddress[_addr]);
64     _;
65   }
66   /**
67    * @dev check whether the msg.sender is admin or not
68    */
69   modifier onlyAdmin() {
70     require(admin[msg.sender]);
71     _;
72   }
73   function KYC() {
74     admin[msg.sender] = true;
75   }
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
86     NewAdmin(_addr);
87   }
88   /**
89    * @dev register the address for token sale
90    * @param _addr address The address to register for token sale
91    */
92   function register(address _addr)
93     public
94     onlyAdmin
95   {
96     require(_addr != address(0) && registeredAddress[_addr] == false);
97     registeredAddress[_addr] = true;
98     Registered(_addr);
99   }
100   /**
101    * @dev register the addresses for token sale
102    * @param _addrs address[] The addresses to register for token sale
103    */
104   function registerByList(address[] _addrs)
105     public
106     onlyAdmin
107   {
108     for(uint256 i = 0; i < _addrs.length; i++) {
109       require(_addrs[i] != address(0) && registeredAddress[_addrs[i]] == false);
110       registeredAddress[_addrs[i]] = true;
111       Registered(_addrs[i]);
112     }
113   }
114   /**
115    * @dev unregister the registered address
116    * @param _addr address The address to unregister for token sale
117    */
118   function unregister(address _addr)
119     public
120     onlyAdmin
121     onlyRegistered(_addr)
122   {
123     registeredAddress[_addr] = false;
124     Unregistered(_addr);
125   }
126   /**
127    * @dev unregister the registered addresses
128    * @param _addrs address[] The addresses to unregister for token sale
129    */
130   function unregisterByList(address[] _addrs)
131     public
132     onlyAdmin
133   {
134     for(uint256 i = 0; i < _addrs.length; i++) {
135       require(registeredAddress[_addrs[i]]);
136       registeredAddress[_addrs[i]] = false;
137       Unregistered(_addrs[i]);
138     }
139   }
140   function claimTokens(address _token) public onlyOwner {
141     if (_token == 0x0) {
142         owner.transfer(this.balance);
143         return;
144     }
145     ERC20Basic token = ERC20Basic(_token);
146     uint256 balance = token.balanceOf(this);
147     token.transfer(owner, balance);
148     ClaimedTokens(_token, owner, balance);
149   }
150 }