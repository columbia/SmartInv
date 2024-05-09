1 pragma solidity 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 contract PrivateSale {
35   using SafeMath for uint256;
36 
37   // Address of owner
38   address public owner;
39 
40   // Address where funds are collected
41   address public wallet;
42 
43   // Amount of wei raised
44   uint256 public weiRaised;
45 
46   // Flag to accept or reject payments
47   bool public isAcceptingPayments;
48 
49   // List of admins who can edit the whitelist
50   mapping (address => bool) public whitelistAdmins;
51 
52   // List of addresses that are whitelisted for private sale
53   mapping (address => bool) public whitelist;
54   uint256 public whitelistCount;
55 
56   // List of addresses that have made payments
57   mapping (address => uint256) public weiPaid;
58 
59   uint256 public HARD_CAP = 6666 ether;
60 
61   // modifier to check owner
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67   // modifier to check whitelist admin status
68   modifier onlyWhitelistAdmin() {
69     require(whitelistAdmins[msg.sender]);
70     _;
71   }
72 
73   // modifier to check if whitelisted address
74   modifier isWhitelisted() {
75     require(whitelist[msg.sender]);
76     _;
77   }
78 
79   // modifier to check if payments being accepted
80   modifier acceptingPayments() {
81     require(isAcceptingPayments);
82     _;
83   }
84 
85   /**
86    * Constructor
87    * @param _wallet Address where collected funds will be forwarded to
88    */
89   function PrivateSale(address _wallet) public {
90     require(_wallet != address(0));
91     owner = msg.sender;
92     wallet = _wallet;
93     whitelistAdmins[msg.sender] = true;
94   }
95 
96   /**
97    * @dev fallback function
98    */
99   function () isWhitelisted acceptingPayments payable public {
100     require(msg.value >= 0.2 ether);
101     require(msg.value <= 500 ether);
102     require(msg.sender != address(0));
103     
104     uint256 contribution = msg.value;
105     // add to sender's weiPaid record
106     weiPaid[msg.sender] += msg.value;
107 
108     // add to amount raised
109     weiRaised = weiRaised.add(msg.value);
110 
111     if (weiRaised > HARD_CAP) {
112       uint256 refundAmount = weiRaised.sub(HARD_CAP);
113       msg.sender.transfer(refundAmount);
114       contribution = contribution.sub(refundAmount);
115       refundAmount = 0;
116       weiRaised = HARD_CAP;
117       isAcceptingPayments = false;
118     }
119 
120     // transfer funds to external wallet
121     wallet.transfer(contribution);
122   }
123 
124   /**
125    * @dev Start accepting payments
126    */
127   function acceptPayments() onlyOwner public  {
128     isAcceptingPayments = true;
129   }
130 
131   /**
132    * @dev Stop accepting payments
133    */
134   function rejectPayments() onlyOwner public  {
135     isAcceptingPayments = false;
136   }
137 
138   /**
139    *  @dev Add a user to the whitelist admins
140    */
141   function addWhitelistAdmin(address _admin) onlyOwner public {
142     whitelistAdmins[_admin] = true;
143   }
144 
145   /**
146    *  @dev Remove a user from the whitelist admins
147    */
148   function removeWhitelistAdmin(address _admin) onlyOwner public {
149     whitelistAdmins[_admin] = false;
150   }
151 
152   /**
153    * @dev Add an address to the whitelist
154    * @param _user The address of the contributor
155    */
156   function whitelistAddress(address _user) onlyWhitelistAdmin public  {
157     whitelist[_user] = true;
158   }
159 
160   /**
161    * @dev Add multiple addresses to the whitelist
162    * @param _users The addresses of the contributor
163    */
164   function whitelistAddresses(address[] _users) onlyWhitelistAdmin public {
165     for (uint256 i = 0; i < _users.length; i++) {
166       whitelist[_users[i]] = true;
167     }
168   }
169 
170   /**
171    * @dev Remove an addresses from the whitelist
172    * @param _user The addresses of the contributor
173    */
174   function unWhitelistAddress(address _user) onlyWhitelistAdmin public  {
175     whitelist[_user] = false;
176   }
177 
178   /**
179    * @dev Remove multiple addresses from the whitelist
180    * @param _users The addresses of the contributor
181    */
182   function unWhitelistAddresses(address[] _users) onlyWhitelistAdmin public {
183     for (uint256 i = 0; i < _users.length; i++) {
184       whitelist[_users[i]] = false;
185     }
186   }
187 }