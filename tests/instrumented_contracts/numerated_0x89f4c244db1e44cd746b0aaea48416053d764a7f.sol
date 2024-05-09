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
54     mapping (address => bool) public isMonethaAddress;
55 
56     /**
57      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
58      */
59     modifier onlyMonetha() {
60         require(isMonethaAddress[msg.sender]);
61         _;
62     }
63 
64     /**
65      *  Allows owner to set new monetha address
66      */
67     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
68         isMonethaAddress[_address] = _isMonethaAddress;
69     }
70 
71 }
72 
73 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
74 
75 /**
76  * @title Contactable token
77  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
78  * contact information.
79  */
80 contract Contactable is Ownable{
81 
82     string public contactInformation;
83 
84     /**
85      * @dev Allows the owner to set a string with their contact information.
86      * @param info The contact information to attach to the contract.
87      */
88     function setContactInformation(string info) onlyOwner public {
89          contactInformation = info;
90      }
91 }
92 
93 // File: contracts/MerchantDealsHistory.sol
94 
95 /**
96  *  @title MerchantDealsHistory
97  *  Contract stores hash of Deals conditions together with parties reputation for each deal
98  *  This history enables to see evolution of trust rating for both parties
99  */
100 contract MerchantDealsHistory is Contactable, Restricted {
101 
102     string constant VERSION = "0.3";
103 
104     ///  Merchant identifier hash
105     bytes32 public merchantIdHash;
106     
107     //Deal event
108     event DealCompleted(
109         uint orderId,
110         address clientAddress,
111         uint32 clientReputation,
112         uint32 merchantReputation,
113         bool successful,
114         uint dealHash
115     );
116 
117     //Deal cancellation event
118     event DealCancelationReason(
119         uint orderId,
120         address clientAddress,
121         uint32 clientReputation,
122         uint32 merchantReputation,
123         uint dealHash,
124         string cancelReason
125     );
126 
127     //Deal refund event
128     event DealRefundReason(
129         uint orderId,
130         address clientAddress,
131         uint32 clientReputation,
132         uint32 merchantReputation,
133         uint dealHash,
134         string refundReason
135     );
136 
137     /**
138      *  @param _merchantId Merchant of the acceptor
139      */
140     function MerchantDealsHistory(string _merchantId) public {
141         require(bytes(_merchantId).length > 0);
142         merchantIdHash = keccak256(_merchantId);
143     }
144 
145     /**
146      *  recordDeal creates an event of completed deal
147      *  @param _orderId Identifier of deal's order
148      *  @param _clientAddress Address of client's account
149      *  @param _clientReputation Updated reputation of the client
150      *  @param _merchantReputation Updated reputation of the merchant
151      *  @param _isSuccess Identifies whether deal was successful or not
152      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
153      */
154     function recordDeal(
155         uint _orderId,
156         address _clientAddress,
157         uint32 _clientReputation,
158         uint32 _merchantReputation,
159         bool _isSuccess,
160         uint _dealHash)
161         external onlyMonetha
162     {
163         DealCompleted(
164             _orderId,
165             _clientAddress,
166             _clientReputation,
167             _merchantReputation,
168             _isSuccess,
169             _dealHash
170         );
171     }
172 
173     /**
174      *  recordDealCancelReason creates an event of not paid deal that was cancelled 
175      *  @param _orderId Identifier of deal's order
176      *  @param _clientAddress Address of client's account
177      *  @param _clientReputation Updated reputation of the client
178      *  @param _merchantReputation Updated reputation of the merchant
179      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
180      *  @param _cancelReason deal cancelation reason (text)
181      */
182     function recordDealCancelReason(
183         uint _orderId,
184         address _clientAddress,
185         uint32 _clientReputation,
186         uint32 _merchantReputation,
187         uint _dealHash,
188         string _cancelReason)
189         external onlyMonetha
190     {
191         DealCancelationReason(
192             _orderId,
193             _clientAddress,
194             _clientReputation,
195             _merchantReputation,
196             _dealHash,
197             _cancelReason
198         );
199     }
200 
201 /**
202      *  recordDealRefundReason creates an event of not paid deal that was cancelled 
203      *  @param _orderId Identifier of deal's order
204      *  @param _clientAddress Address of client's account
205      *  @param _clientReputation Updated reputation of the client
206      *  @param _merchantReputation Updated reputation of the merchant
207      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
208      *  @param _refundReason deal refund reason (text)
209      */
210     function recordDealRefundReason(
211         uint _orderId,
212         address _clientAddress,
213         uint32 _clientReputation,
214         uint32 _merchantReputation,
215         uint _dealHash,
216         string _refundReason)
217         external onlyMonetha
218     {
219         DealRefundReason(
220             _orderId,
221             _clientAddress,
222             _clientReputation,
223             _merchantReputation,
224             _dealHash,
225             _refundReason
226         );
227     }
228 }