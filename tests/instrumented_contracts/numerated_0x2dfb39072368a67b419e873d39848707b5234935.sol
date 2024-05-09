1 pragma solidity ^0.4.21;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: openzeppelin-solidity/contracts/ownership/Whitelist.sol
46 
47 /**
48  * @title Whitelist
49  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
50  * @dev This simplifies the implementation of "user permissions".
51  */
52 contract Whitelist is Ownable {
53   mapping(address => bool) public whitelist;
54 
55   event WhitelistedAddressAdded(address addr);
56   event WhitelistedAddressRemoved(address addr);
57 
58   /**
59    * @dev Throws if called by any account that's not whitelisted.
60    */
61   modifier onlyWhitelisted() {
62     require(whitelist[msg.sender]);
63     _;
64   }
65 
66   /**
67    * @dev add an address to the whitelist
68    * @param addr address
69    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
70    */
71   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
72     if (!whitelist[addr]) {
73       whitelist[addr] = true;
74       emit WhitelistedAddressAdded(addr);
75       success = true;
76     }
77   }
78 
79   /**
80    * @dev add addresses to the whitelist
81    * @param addrs addresses
82    * @return true if at least one address was added to the whitelist,
83    * false if all addresses were already in the whitelist
84    */
85   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
86     for (uint256 i = 0; i < addrs.length; i++) {
87       if (addAddressToWhitelist(addrs[i])) {
88         success = true;
89       }
90     }
91   }
92 
93   /**
94    * @dev remove an address from the whitelist
95    * @param addr address
96    * @return true if the address was removed from the whitelist,
97    * false if the address wasn't in the whitelist in the first place
98    */
99   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
100     if (whitelist[addr]) {
101       whitelist[addr] = false;
102       emit WhitelistedAddressRemoved(addr);
103       success = true;
104     }
105   }
106 
107   /**
108    * @dev remove addresses from the whitelist
109    * @param addrs addresses
110    * @return true if at least one address was removed from the whitelist,
111    * false if all addresses weren't in the whitelist in the first place
112    */
113   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
114     for (uint256 i = 0; i < addrs.length; i++) {
115       if (removeAddressFromWhitelist(addrs[i])) {
116         success = true;
117       }
118     }
119   }
120 
121 }
122 
123 // File: contracts/SEEDWhitelist.sol
124 
125 contract SEEDWhitelist is Whitelist {
126 
127   // check the address is admin of kyc contract
128   mapping (address => bool) public admin;
129 
130   /**
131    * @dev check whether the msg.sender is admin or not
132    */
133   modifier onlyAdmin() {
134     require(admin[msg.sender]);
135     _;
136   }
137 
138   event SetAdmin(address indexed _addr, bool _value);
139 
140   function SEEDWhitelist() public {
141     admin[msg.sender] = true;
142   }
143 
144   /**
145    * @dev set new admin as admin of SEEDWhitelist contract
146    * @param _addr address The address to set as admin of SEEDWhitelist contract
147    */
148   function setAdmin(address _addr, bool _value)
149     public
150     onlyAdmin
151     returns (bool)
152   {
153     require(_addr != address(0));
154     require(admin[_addr] == !_value);
155 
156     admin[_addr] = _value;
157 
158     emit SetAdmin(_addr, _value);
159 
160     return true;
161   }
162 
163   /**
164    * @dev add an address to the whitelist
165    * @param addr address
166    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
167    */
168   function addAddressToWhitelist(address addr) onlyAdmin public returns(bool success) {
169     if (!whitelist[addr]) {
170       whitelist[addr] = true;
171       emit WhitelistedAddressAdded(addr);
172       success = true;
173     }
174   }
175 
176   /**
177    * @dev add addresses to the whitelist
178    * @param addrs addresses
179    * @return true if at least one address was added to the whitelist,
180    * false if all addresses were already in the whitelist
181    */
182   function addAddressesToWhitelist(address[] addrs) onlyAdmin public returns(bool success) {
183     for (uint256 i = 0; i < addrs.length; i++) {
184       if (addAddressToWhitelist(addrs[i])) {
185         success = true;
186       }
187     }
188   }
189 
190   /**
191    * @dev remove an address from the whitelist
192    * @param addr address
193    * @return true if the address was removed from the whitelist,
194    * false if the address wasn't in the whitelist in the first place
195    */
196   function removeAddressFromWhitelist(address addr) onlyAdmin public returns(bool success) {
197     if (whitelist[addr]) {
198       whitelist[addr] = false;
199       emit WhitelistedAddressRemoved(addr);
200       success = true;
201     }
202   }
203 
204   /**
205    * @dev remove addresses from the whitelist
206    * @param addrs addresses
207    * @return true if at least one address was removed from the whitelist,
208    * false if all addresses weren't in the whitelist in the first place
209    */
210   function removeAddressesFromWhitelist(address[] addrs) onlyAdmin public returns(bool success) {
211     for (uint256 i = 0; i < addrs.length; i++) {
212       if (removeAddressFromWhitelist(addrs[i])) {
213         success = true;
214       }
215     }
216   }
217 }