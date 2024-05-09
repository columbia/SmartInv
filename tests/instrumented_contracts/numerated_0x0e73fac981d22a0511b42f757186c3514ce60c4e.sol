1 pragma solidity ^0.4.23;
2 
3 contract Htlc {
4 
5     // ENUMS
6 
7     enum State { Created, Refunded, Redeemed }
8 
9     // TYPES
10 
11     struct Channel { // Locks ETH in a channel by secret (redeemChannel) or time (refundChannels).
12         address initiator; // Initiated this channel.
13         address beneficiary; // Beneficiary of this channel.
14         uint amount; // If zero then channel not active anymore.
15         uint commission; // Commission amount to be paid to multisig authority.
16         uint createdAt; // Channel creation timestamp in seconds.
17         uint expiresAt; // Channel expiration timestamp in seconds.
18         bytes32 hashedSecret; // sha256(secret), hashed secret of channel initiator.
19         State state; // The state in which this channel is in.
20     }
21 
22     // FIELDS
23 
24     uint constant MAX_BATCH_ITERATIONS = 20; // Assuming 8mn gaslimit and >0.4mn gas usage for most expensive batch function
25     mapping (bytes32 => Channel) public channels; // Mapping of channel hashes to channel structs.
26     mapping (bytes32 => bool) public isAntecedentHashedSecret; // Mapping of secrets to whether they have been used already or not.
27     address public EXCHANGE_OPERATOR; // Can change the COMMISSION_RECIPIENT address.
28     bool public IS_EXCHANGE_OPERATIONAL; // Can change the COMMISSION_RECIPIENT address.
29     address public COMMISSION_RECIPIENT; // Recipient of exchange commissions.
30 
31     // EVENTS
32 
33     event ChannelCreated(bytes32 channelId);
34     event ChannelRedeemed(bytes32 channelId);
35     event ChannelRefunded(bytes32 channelId);
36 
37     // MODIFIER
38 
39     modifier only_exchange_operator {
40         require(msg.sender == EXCHANGE_OPERATOR, "PERMISSION_DENIED");
41         _;
42     }
43 
44     // METHODS
45 
46     // PRIVATE METHODS
47 
48     /**
49     @notice Sets up a Channel to initiate or participate in.
50     @dev Whether right amount has been sent is handled at higher level functions.
51     */
52     function _setupChannel(address beneficiary, uint amount, uint commission, uint expiresAt, bytes32 hashedSecret)
53         private
54         returns (bytes32 channelId)
55     {
56         require(IS_EXCHANGE_OPERATIONAL, "EXCHANGE_NOT_OPERATIONAL");
57         require(now <= expiresAt, "TIMELOCK_TOO_EARLY");
58         require(amount > 0, "AMOUNT_IS_ZERO");
59         require(!isAntecedentHashedSecret[hashedSecret], "SECRET_CAN_BE_DISCOVERED");
60         isAntecedentHashedSecret[hashedSecret] = true;
61         // Create channel identifier
62         channelId = createChannelId(
63             msg.sender,
64             beneficiary,
65             amount,
66             commission,
67             now,
68             expiresAt,
69             hashedSecret
70         );
71         // Create channel
72         Channel storage channel = channels[channelId];
73         channel.initiator = msg.sender;
74         channel.beneficiary = beneficiary;
75         channel.amount = amount;
76         channel.commission = commission;
77         channel.createdAt = now;
78         channel.expiresAt = expiresAt;
79         channel.hashedSecret = hashedSecret;
80         channel.state = State.Created;
81         // Transfer commission to commission recipient
82         COMMISSION_RECIPIENT.transfer(commission);
83         emit ChannelCreated(channelId);
84     }
85 
86     // PUBLIC METHODS
87 
88     /**
89     @notice Constructor function.
90     */
91     function Htlc(
92         address ofExchangeOperator,
93         address ofCommissionRecipient
94     )
95         public
96     {
97         EXCHANGE_OPERATOR = ofExchangeOperator;
98         IS_EXCHANGE_OPERATIONAL = true;
99         COMMISSION_RECIPIENT = ofCommissionRecipient;
100     }
101 
102     /**
103     @notice Changes the exchange operator.
104     */
105     function changeExchangeOperator(address newExchangeOperator)
106         public
107         only_exchange_operator
108     {
109         EXCHANGE_OPERATOR = newExchangeOperator;
110     }
111 
112     /**
113     @notice Changes the operational status of the exchange.
114     */
115     function changeExchangeStatus(bool newExchangeState)
116         public
117         only_exchange_operator
118     {
119         IS_EXCHANGE_OPERATIONAL = newExchangeState;
120     }
121 
122     /**
123     @notice Changes the recipient of the commission.
124     */
125     function changeCommissionRecipient(address newCommissionRecipient)
126         public
127         only_exchange_operator
128     {
129         COMMISSION_RECIPIENT = newCommissionRecipient;
130     }
131 
132     /**
133     @notice Hashes the channel specific values to create a unique identifier.
134     @dev Helper function to create channelIds
135     */
136     function createChannelId(
137         address initiator,
138         address beneficiary,
139         uint amount,
140         uint commission,
141         uint createdAt,
142         uint expiresAt,
143         bytes32 hashedSecret
144     )
145         public
146         pure
147         returns (bytes32 channelId)
148     {
149         channelId = keccak256(abi.encodePacked(
150             initiator,
151             beneficiary,
152             amount,
153             commission,
154             createdAt,
155             expiresAt,
156             hashedSecret
157         ));
158     }
159 
160     /**
161     @notice Creates a Channel to initiate or participate in.
162     @dev If too little commission sent, channel wont be displayed in exchange frontend.
163     @dev Does check if right amount (msg.value) has been sent.
164     @param beneficiary Beneficiary of this channels amount.
165     @param amount Amount to be stored in this channel.
166     @param commission Commission amount to be paid to commission recipient.
167     @param expiresAt Channel expiration timestamp in seconds.
168     @param hashedSecret sha256(secret), hashed secret of channel initiator
169     @return channelId Unique channel identifier
170     */
171     function createChannel(
172         address beneficiary,
173         uint amount,
174         uint commission,
175         uint expiresAt,
176         bytes32 hashedSecret
177     )
178         public
179         payable
180         returns (bytes32 channelId)
181     {
182         // Require accurate msg.value sent
183         require(amount + commission >= amount, "UINT256_OVERFLOW");
184         require(msg.value == amount + commission, "INACCURATE_MSG_VALUE_SENT");
185         // Setup channel
186         _setupChannel(
187             beneficiary,
188             amount,
189             commission,
190             expiresAt,
191             hashedSecret
192         );
193     }
194 
195     /**
196     @notice Creates a batch of channels
197     */
198     function batchCreateChannel(
199         address[] beneficiaries,
200         uint[] amounts,
201         uint[] commissions,
202         uint[] expiresAts,
203         bytes32[] hashedSecrets
204     )
205         public
206         payable
207         returns (bytes32[] channelId)
208     {
209         require(beneficiaries.length <= MAX_BATCH_ITERATIONS, "TOO_MANY_CHANNELS");
210         // Require accurate msg.value sent
211         uint valueToBeSent;
212         for (uint i = 0; i < beneficiaries.length; ++i) {
213             require(amounts[i] + commissions[i] >= amounts[i], "UINT256_OVERFLOW");
214             require(valueToBeSent + amounts[i] + commissions[i] >= valueToBeSent, "UINT256_OVERFLOW");
215             valueToBeSent += amounts[i] + commissions[i];
216         }
217         require(msg.value == valueToBeSent, "INACCURATE_MSG_VALUE_SENT");
218         // Setup channel
219         for (i = 0; i < beneficiaries.length; ++i)
220             _setupChannel(
221                 beneficiaries[i],
222                 amounts[i],
223                 commissions[i],
224                 expiresAts[i],
225                 hashedSecrets[i]
226             );
227     }
228 
229     /**
230     @notice Redeem ETH to channel beneficiary and and set channel state as redeemed.
231     */
232     function redeemChannel(bytes32 channelId, bytes32 secret)
233         public
234     {
235         // Require secret to open channels hashlock
236         require(sha256(abi.encodePacked(secret)) == channels[channelId].hashedSecret, "WRONG_SECRET");
237         require(channels[channelId].state == State.Created, "WRONG_STATE");
238         uint amount = channels[channelId].amount;
239         address beneficiary = channels[channelId].beneficiary;
240         channels[channelId].state = State.Redeemed;
241         // Execute channel
242         beneficiary.transfer(amount);
243         emit ChannelRedeemed(channelId);
244     }
245 
246     /**
247     @notice Redeems a batch of channels.
248     */
249     function batchRedeemChannel(bytes32[] channelIds, bytes32[] secrets)
250         public
251     {
252         require(channelIds.length <= MAX_BATCH_ITERATIONS, "TOO_MANY_CHANNELS");
253         for (uint i = 0; i < channelIds.length; ++i)
254             redeemChannel(channelIds[i], secrets[i]);
255     }
256 
257     /**
258     @notice Refund ETH to the channel initiator and set channel state as refuned.
259     */
260     function refundChannel(bytes32 channelId)
261         public
262     {
263         // Require enough time has passed to open channels timelock.
264         require(now >= channels[channelId].expiresAt, "TOO_EARLY");
265         require(channels[channelId].state == State.Created, "WRONG_STATE");
266         uint amount = channels[channelId].amount;
267         address initiator = channels[channelId].initiator;
268         channels[channelId].state = State.Refunded;
269         // Refund channel
270         initiator.transfer(amount);
271         emit ChannelRefunded(channelId);
272     }
273 
274     /**
275     @notice Refunds a batch of channels.
276     */
277     function batchRefundChannel(bytes32[] channelIds)
278         public
279     {
280         require(channelIds.length <= MAX_BATCH_ITERATIONS, "TOO_MANY_CHANNELS");
281         for (uint i = 0; i < channelIds.length; ++i)
282             refundChannel(channelIds[i]);
283     }
284 }