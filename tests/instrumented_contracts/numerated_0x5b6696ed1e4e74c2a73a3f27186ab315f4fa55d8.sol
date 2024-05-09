1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 /// @title Whitelist for TKO token sale.
92 /// @author Takeoff Technology OU - <info@takeoff.ws>
93 /// @dev Based on code by OpenZeppelin's WhitelistedCrowdsale.sol
94 contract TkoWhitelist is Ownable{
95 
96     using SafeMath for uint256;
97 
98     // Manage whitelist account address.
99     address public admin;
100 
101     mapping(address => uint256) internal totalIndividualWeiAmount;
102     mapping(address => bool) internal whitelist;
103 
104     event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
105 
106 
107     /**
108      * TkoWhitelist
109      * @dev TkoWhitelist is the storage for whitelist and total amount by contributor's address.
110      * @param _admin Address of managing whitelist.
111      */
112     function TkoWhitelist (address _admin) public {
113         require(_admin != address(0));
114         admin = _admin;
115     }
116 
117     /**
118      * @dev Throws if called by any account other than the owner or the admin.
119      */
120     modifier onlyOwnerOrAdmin() {
121         require(msg.sender == owner || msg.sender == admin);
122         _;
123     }
124 
125     /**
126      * @dev Allows the current owner to change administrator account of the contract to a newAdmin.
127      * @param newAdmin The address to transfer ownership to.
128      */
129     function changeAdmin(address newAdmin) public onlyOwner {
130         require(newAdmin != address(0));
131         emit AdminChanged(admin, newAdmin);
132         admin = newAdmin;
133     }
134 
135 
136     /**
137       * @dev Returen whether the beneficiary is whitelisted.
138       */
139     function isWhitelisted(address _beneficiary) external view onlyOwnerOrAdmin returns (bool) {
140         return whitelist[_beneficiary];
141     }
142 
143     /**
144      * @dev Adds single address to whitelist.
145      * @param _beneficiary Address to be added to the whitelist
146      */
147     function addToWhitelist(address _beneficiary) external onlyOwnerOrAdmin {
148         whitelist[_beneficiary] = true;
149     }
150 
151     /**
152      * @dev Adds list of addresses to whitelist.
153      * @param _beneficiaries Addresses to be added to the whitelist
154      */
155     function addManyToWhitelist(address[] _beneficiaries) external onlyOwnerOrAdmin {
156         for (uint256 i = 0; i < _beneficiaries.length; i++) {
157             whitelist[_beneficiaries[i]] = true;
158         }
159     }
160 
161     /**
162      * @dev Removes single address from whitelist.
163      * @param _beneficiary Address to be removed to the whitelist
164      */
165     function removeFromWhitelist(address _beneficiary) external onlyOwnerOrAdmin {
166         whitelist[_beneficiary] = false;
167     }
168 
169     /**
170      * @dev Return total individual wei amount.
171      * @param _beneficiary Addresses to get total wei amount .
172      * @return Total wei amount for the address.
173      */
174     function getTotalIndividualWeiAmount(address _beneficiary) external view onlyOwnerOrAdmin returns (uint256) {
175         return totalIndividualWeiAmount[_beneficiary];
176     }
177 
178     /**
179      * @dev Set total individual wei amount.
180      * @param _beneficiary Addresses to set total wei amount.
181      * @param _totalWeiAmount Total wei amount for the address.
182      */
183     function setTotalIndividualWeiAmount(address _beneficiary,uint256 _totalWeiAmount) external onlyOwner {
184         totalIndividualWeiAmount[_beneficiary] = _totalWeiAmount;
185     }
186 
187     /**
188      * @dev Add total individual wei amount.
189      * @param _beneficiary Addresses to add total wei amount.
190      * @param _weiAmount Total wei amount to be added for the address.
191      */
192     function addTotalIndividualWeiAmount(address _beneficiary,uint256 _weiAmount) external onlyOwner {
193         totalIndividualWeiAmount[_beneficiary] = totalIndividualWeiAmount[_beneficiary].add(_weiAmount);
194     }
195 
196 }