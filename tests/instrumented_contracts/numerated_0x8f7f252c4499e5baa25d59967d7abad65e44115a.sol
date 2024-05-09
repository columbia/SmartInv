1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     emit OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 contract CanReclaimToken is Ownable {
39   using SafeERC20 for ERC20Basic;
40 
41   /**
42    * @dev Reclaim all ERC20Basic compatible tokens
43    * @param token ERC20Basic The address of the token contract
44    */
45   function reclaimToken(ERC20Basic token) external onlyOwner {
46     uint256 balance = token.balanceOf(this);
47     token.safeTransfer(owner, balance);
48   }
49 
50 }
51 
52 contract Claimable is Ownable {
53   address public pendingOwner;
54 
55   /**
56    * @dev Modifier throws if called by any account other than the pendingOwner.
57    */
58   modifier onlyPendingOwner() {
59     require(msg.sender == pendingOwner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to set the pendingOwner address.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     pendingOwner = newOwner;
69   }
70 
71   /**
72    * @dev Allows the pendingOwner address to finalize the transfer.
73    */
74   function claimOwnership() onlyPendingOwner public {
75     emit OwnershipTransferred(owner, pendingOwner);
76     owner = pendingOwner;
77     pendingOwner = address(0);
78   }
79 }
80 
81 contract Whitelist is Ownable {
82   mapping(address => bool) public whitelist;
83 
84   event WhitelistedAddressAdded(address addr);
85   event WhitelistedAddressRemoved(address addr);
86 
87   /**
88    * @dev Throws if called by any account that's not whitelisted.
89    */
90   modifier onlyWhitelisted() {
91     require(whitelist[msg.sender]);
92     _;
93   }
94 
95   /**
96    * @dev add an address to the whitelist
97    * @param addr address
98    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
99    */
100   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
101     if (!whitelist[addr]) {
102       whitelist[addr] = true;
103       emit WhitelistedAddressAdded(addr);
104       success = true;
105     }
106   }
107 
108   /**
109    * @dev add addresses to the whitelist
110    * @param addrs addresses
111    * @return true if at least one address was added to the whitelist,
112    * false if all addresses were already in the whitelist
113    */
114   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
115     for (uint256 i = 0; i < addrs.length; i++) {
116       if (addAddressToWhitelist(addrs[i])) {
117         success = true;
118       }
119     }
120   }
121 
122   /**
123    * @dev remove an address from the whitelist
124    * @param addr address
125    * @return true if the address was removed from the whitelist,
126    * false if the address wasn't in the whitelist in the first place
127    */
128   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
129     if (whitelist[addr]) {
130       whitelist[addr] = false;
131       emit WhitelistedAddressRemoved(addr);
132       success = true;
133     }
134   }
135 
136   /**
137    * @dev remove addresses from the whitelist
138    * @param addrs addresses
139    * @return true if at least one address was removed from the whitelist,
140    * false if all addresses weren't in the whitelist in the first place
141    */
142   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
143     for (uint256 i = 0; i < addrs.length; i++) {
144       if (removeAddressFromWhitelist(addrs[i])) {
145         success = true;
146       }
147     }
148   }
149 
150 }
151 
152 contract ERC20Basic {
153   function totalSupply() public view returns (uint256);
154   function balanceOf(address who) public view returns (uint256);
155   function transfer(address to, uint256 value) public returns (bool);
156   event Transfer(address indexed from, address indexed to, uint256 value);
157 }
158 
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 library SafeERC20 {
167   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
168     assert(token.transfer(to, value));
169   }
170 
171   function safeTransferFrom(
172     ERC20 token,
173     address from,
174     address to,
175     uint256 value
176   )
177     internal
178   {
179     assert(token.transferFrom(from, to, value));
180   }
181 
182   function safeApprove(ERC20 token, address spender, uint256 value) internal {
183     assert(token.approve(spender, value));
184   }
185 }
186 
187 contract Distribution is CanReclaimToken, Claimable, Whitelist {
188 
189     using SafeERC20 for ERC20Basic;
190 
191     event Distributed(address beneficiary, uint256 amount);
192 
193     address[] public receivers;
194     // Also used to indicate the distribution state.
195     uint256 public amount = 0;
196     ERC20Basic public token;
197 
198     constructor(ERC20Basic _token) public {
199         token = _token;
200     }
201 
202     function setReceivers(address[] _receivers, uint256 _amount) onlyWhitelisted external {
203         // Be conservative about the size.
204         require(_receivers.length <= 80);
205         require(_amount > 0);
206 
207         receivers = _receivers;
208         amount = _amount;
209     }
210 
211     function distribute() onlyWhitelisted external {
212         require(receivers.length > 0);
213         require(amount > 0);
214         for (uint256 i = 0; i < receivers.length; ++i) {
215             address beneficiary = receivers[i];
216             token.safeTransfer(beneficiary, amount);
217             emit Distributed(beneficiary, amount);
218         }
219         // Clear.
220         amount = 0;
221         delete receivers;
222     }
223 
224     function batchDistribute(
225         address[] batchReceivers,
226         uint256 batchAmount
227     ) onlyWhitelisted external
228     {
229         require(batchReceivers.length > 0);
230         require(batchAmount > 0);
231         for (uint256 i = 0; i < batchReceivers.length; ++i) {
232             address beneficiary = batchReceivers[i];
233             token.safeTransfer(beneficiary, batchAmount);
234             emit Distributed(beneficiary, batchAmount);
235         }
236     }
237     
238     function batchDistributeWithAmount(
239         address[] batchReceivers,
240         uint256[] batchAmounts
241     ) onlyWhitelisted external
242     {
243         require(batchReceivers.length > 0);
244         require(batchAmounts.length == batchReceivers.length);
245         for (uint256 i = 0; i < batchReceivers.length; ++i) {
246             address beneficiary = batchReceivers[i];
247             uint256 v = batchAmounts[i] * 1 ether;
248             token.safeTransfer(beneficiary, v);
249             emit Distributed(beneficiary, v);
250         }
251     }
252     
253 
254     function finished() public view returns (bool) {
255         return amount == 0;
256     }
257 }