1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract CanReclaimToken is Ownable {
81   using SafeERC20 for ERC20Basic;
82 
83   /**
84    * @dev Reclaim all ERC20Basic compatible tokens
85    * @param token ERC20Basic The address of the token contract
86    */
87   function reclaimToken(ERC20Basic token) external onlyOwner {
88     uint256 balance = token.balanceOf(this);
89     token.safeTransfer(owner, balance);
90   }
91 
92 }
93 
94 contract Claimable is Ownable {
95   address public pendingOwner;
96 
97   /**
98    * @dev Modifier throws if called by any account other than the pendingOwner.
99    */
100   modifier onlyPendingOwner() {
101     require(msg.sender == pendingOwner);
102     _;
103   }
104 
105   /**
106    * @dev Allows the current owner to set the pendingOwner address.
107    * @param newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address newOwner) onlyOwner public {
110     pendingOwner = newOwner;
111   }
112 
113   /**
114    * @dev Allows the pendingOwner address to finalize the transfer.
115    */
116   function claimOwnership() onlyPendingOwner public {
117     emit OwnershipTransferred(owner, pendingOwner);
118     owner = pendingOwner;
119     pendingOwner = address(0);
120   }
121 }
122 
123 contract Whitelist is Ownable {
124   mapping(address => bool) public whitelist;
125 
126   event WhitelistedAddressAdded(address addr);
127   event WhitelistedAddressRemoved(address addr);
128 
129   /**
130    * @dev Throws if called by any account that's not whitelisted.
131    */
132   modifier onlyWhitelisted() {
133     require(whitelist[msg.sender]);
134     _;
135   }
136 
137   /**
138    * @dev add an address to the whitelist
139    * @param addr address
140    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
141    */
142   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
143     if (!whitelist[addr]) {
144       whitelist[addr] = true;
145       emit WhitelistedAddressAdded(addr);
146       success = true;
147     }
148   }
149 
150   /**
151    * @dev add addresses to the whitelist
152    * @param addrs addresses
153    * @return true if at least one address was added to the whitelist,
154    * false if all addresses were already in the whitelist
155    */
156   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
157     for (uint256 i = 0; i < addrs.length; i++) {
158       if (addAddressToWhitelist(addrs[i])) {
159         success = true;
160       }
161     }
162   }
163 
164   /**
165    * @dev remove an address from the whitelist
166    * @param addr address
167    * @return true if the address was removed from the whitelist,
168    * false if the address wasn't in the whitelist in the first place
169    */
170   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
171     if (whitelist[addr]) {
172       whitelist[addr] = false;
173       emit WhitelistedAddressRemoved(addr);
174       success = true;
175     }
176   }
177 
178   /**
179    * @dev remove addresses from the whitelist
180    * @param addrs addresses
181    * @return true if at least one address was removed from the whitelist,
182    * false if all addresses weren't in the whitelist in the first place
183    */
184   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
185     for (uint256 i = 0; i < addrs.length; i++) {
186       if (removeAddressFromWhitelist(addrs[i])) {
187         success = true;
188       }
189     }
190   }
191 
192 }
193 
194 contract ERC20Basic {
195   function totalSupply() public view returns (uint256);
196   function balanceOf(address who) public view returns (uint256);
197   function transfer(address to, uint256 value) public returns (bool);
198   event Transfer(address indexed from, address indexed to, uint256 value);
199 }
200 
201 contract ERC20 is ERC20Basic {
202   function allowance(address owner, address spender) public view returns (uint256);
203   function transferFrom(address from, address to, uint256 value) public returns (bool);
204   function approve(address spender, uint256 value) public returns (bool);
205   event Approval(address indexed owner, address indexed spender, uint256 value);
206 }
207 
208 library SafeERC20 {
209   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
210     assert(token.transfer(to, value));
211   }
212 
213   function safeTransferFrom(
214     ERC20 token,
215     address from,
216     address to,
217     uint256 value
218   )
219     internal
220   {
221     assert(token.transferFrom(from, to, value));
222   }
223 
224   function safeApprove(ERC20 token, address spender, uint256 value) internal {
225     assert(token.approve(spender, value));
226   }
227 }
228 
229 contract Distribution is CanReclaimToken, Claimable, Whitelist {
230 
231     using SafeERC20 for ERC20Basic;
232     using SafeMath for uint256;
233 
234     event Distributed(uint numberOfTransfer, uint256 amountInQKC);
235 
236     ERC20Basic public token;
237 
238     constructor(ERC20Basic _token) public {
239         token = _token;
240     }
241 
242     function batchDistribute(
243         address[] batchReceivers,
244         uint256[] amountsInQKC
245     ) external onlyWhitelisted
246     {
247         require(batchReceivers.length > 0, "should have non-zero receivers");
248         require(amountsInQKC.length == batchReceivers.length, "shoud match receiver and amount");
249         uint256 totalInQKC = 0;
250         for (uint256 i = 0; i < batchReceivers.length; ++i) {
251             address beneficiary = batchReceivers[i];
252             totalInQKC = totalInQKC.add(amountsInQKC[i]);
253             uint256 amountInWei = amountsInQKC[i].mul(1 ether);
254             token.safeTransfer(beneficiary, amountInWei);
255         }
256         emit Distributed(batchReceivers.length, totalInQKC);
257     }
258 }