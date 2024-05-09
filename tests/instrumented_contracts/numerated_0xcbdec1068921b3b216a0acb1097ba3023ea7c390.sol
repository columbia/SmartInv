1 pragma solidity 0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts/Restricted.sol
48 
49 /** @title Restricted
50  *  Exposes onlyMonetha modifier
51  */
52 contract Restricted is Ownable {
53 
54     //MonethaAddress set event
55     event MonethaAddressSet(
56         address _address,
57         bool _isMonethaAddress
58     );
59 
60     mapping (address => bool) public isMonethaAddress;
61 
62     /**
63      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
64      */
65     modifier onlyMonetha() {
66         require(isMonethaAddress[msg.sender]);
67         _;
68     }
69 
70     /**
71      *  Allows owner to set new monetha address
72      */
73     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
74         isMonethaAddress[_address] = _isMonethaAddress;
75 
76         MonethaAddressSet(_address, _isMonethaAddress);
77     }
78 }
79 
80 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
81 
82 /**
83  * @title Contactable token
84  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
85  * contact information.
86  */
87 contract Contactable is Ownable{
88 
89     string public contactInformation;
90 
91     /**
92      * @dev Allows the owner to set a string with their contact information.
93      * @param info The contact information to attach to the contract.
94      */
95     function setContactInformation(string info) onlyOwner public {
96          contactInformation = info;
97      }
98 }
99 
100 // File: contracts/MerchantDealsHistory.sol
101 
102 /**
103  *  @title MerchantDealsHistory
104  *  Contract stores hash of Deals conditions together with parties reputation for each deal
105  *  This history enables to see evolution of trust rating for both parties
106  */
107 contract MerchantDealsHistory is Contactable, Restricted {
108 
109     string constant VERSION = "0.3";
110 
111     ///  Merchant identifier hash
112     bytes32 public merchantIdHash;
113     
114     //Deal event
115     event DealCompleted(
116         uint orderId,
117         address clientAddress,
118         uint32 clientReputation,
119         uint32 merchantReputation,
120         bool successful,
121         uint dealHash
122     );
123 
124     //Deal cancellation event
125     event DealCancelationReason(
126         uint orderId,
127         address clientAddress,
128         uint32 clientReputation,
129         uint32 merchantReputation,
130         uint dealHash,
131         string cancelReason
132     );
133 
134     //Deal refund event
135     event DealRefundReason(
136         uint orderId,
137         address clientAddress,
138         uint32 clientReputation,
139         uint32 merchantReputation,
140         uint dealHash,
141         string refundReason
142     );
143 
144     /**
145      *  @param _merchantId Merchant of the acceptor
146      */
147     function MerchantDealsHistory(string _merchantId) public {
148         require(bytes(_merchantId).length > 0);
149         merchantIdHash = keccak256(_merchantId);
150     }
151 
152     /**
153      *  recordDeal creates an event of completed deal
154      *  @param _orderId Identifier of deal's order
155      *  @param _clientAddress Address of client's account
156      *  @param _clientReputation Updated reputation of the client
157      *  @param _merchantReputation Updated reputation of the merchant
158      *  @param _isSuccess Identifies whether deal was successful or not
159      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
160      */
161     function recordDeal(
162         uint _orderId,
163         address _clientAddress,
164         uint32 _clientReputation,
165         uint32 _merchantReputation,
166         bool _isSuccess,
167         uint _dealHash)
168         external onlyMonetha
169     {
170         DealCompleted(
171             _orderId,
172             _clientAddress,
173             _clientReputation,
174             _merchantReputation,
175             _isSuccess,
176             _dealHash
177         );
178     }
179 
180     /**
181      *  recordDealCancelReason creates an event of not paid deal that was cancelled 
182      *  @param _orderId Identifier of deal's order
183      *  @param _clientAddress Address of client's account
184      *  @param _clientReputation Updated reputation of the client
185      *  @param _merchantReputation Updated reputation of the merchant
186      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
187      *  @param _cancelReason deal cancelation reason (text)
188      */
189     function recordDealCancelReason(
190         uint _orderId,
191         address _clientAddress,
192         uint32 _clientReputation,
193         uint32 _merchantReputation,
194         uint _dealHash,
195         string _cancelReason)
196         external onlyMonetha
197     {
198         DealCancelationReason(
199             _orderId,
200             _clientAddress,
201             _clientReputation,
202             _merchantReputation,
203             _dealHash,
204             _cancelReason
205         );
206     }
207 
208 /**
209      *  recordDealRefundReason creates an event of not paid deal that was cancelled 
210      *  @param _orderId Identifier of deal's order
211      *  @param _clientAddress Address of client's account
212      *  @param _clientReputation Updated reputation of the client
213      *  @param _merchantReputation Updated reputation of the merchant
214      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
215      *  @param _refundReason deal refund reason (text)
216      */
217     function recordDealRefundReason(
218         uint _orderId,
219         address _clientAddress,
220         uint32 _clientReputation,
221         uint32 _merchantReputation,
222         uint _dealHash,
223         string _refundReason)
224         external onlyMonetha
225     {
226         DealRefundReason(
227             _orderId,
228             _clientAddress,
229             _clientReputation,
230             _merchantReputation,
231             _dealHash,
232             _refundReason
233         );
234     }
235 }