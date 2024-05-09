1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /** 
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     if (msg.sender != owner) {
26       throw;
27     }
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to. 
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     if (newOwner != address(0)) {
38       owner = newOwner;
39     }
40   }
41 
42 }
43 
44 /**
45  * Math operations with safety checks
46  */
47 contract SafeMath {
48   function safeMul(uint a, uint b) internal returns (uint) {
49     uint c = a * b;
50     assert(a == 0 || c / a == b);
51     return c;
52   }
53 
54   function safeSub(uint a, uint b) internal returns (uint) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   function safeAdd(uint a, uint b) internal returns (uint) {
60     uint c = a + b;
61     assert(c>=a && c>=b);
62     return c;
63   }
64 
65   function assert(bool assertion) internal {
66     if (!assertion) throw;
67   }
68 }
69 
70 contract ERC20 {
71     string public symbol;
72     string public name;
73     uint8 public decimals;
74     uint256 _totalSupply;
75     
76     mapping(address => uint256) balances;
77     mapping(address => mapping (address => uint256)) allowed;
78     
79     function totalSupply() constant returns (uint256 totalSupply);
80     function balanceOf(address _owner) constant returns (uint256 balance);
81     function transfer(address _to, uint256 _value) returns (bool success);
82     
83     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
84     function approve(address _spender, uint256 _value) returns (bool success);
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
86     
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89 }
90 
91  
92 contract Redvolution is Ownable, SafeMath, ERC20 {
93     // ERC20 constants
94     string public symbol = "REDV";
95     string public name = "Redvolution";
96     uint8 public constant decimals = 8;
97     uint256 _totalSupply = 21000000*(10**8);
98     
99     // Constants
100     uint public pricePerMessage = 5*(10**8);
101     uint public priceCreatingChannel = 5000*(10**8);
102     uint public maxCharacters = 300;
103     uint public metadataSize = 1000;
104     uint public channelMaxSize = 25;
105     
106     // Channels
107     mapping(string => address) channelOwner;
108     mapping(string => uint256) channelsOnSale;
109     mapping(string => string) metadataChannel;
110     mapping(address => string) metadataUser;
111     mapping(address => uint256) ranks;
112     
113     // Events
114     event MessageSent(address from, address to, uint256 bonus, string messageContent, string messageTitle, uint256 timestamp);
115     event MessageSentToChannel(address from, string channel, string messageContent, uint256 timestamp);
116     event pricePerMessageChanged(uint256 lastOne, uint256 newOne);
117     event priceCreatingChannelChanged(uint256 lastOne, uint256 newOne);
118     event ChannelBought(string channelName, address buyer, address seller);
119     event ChannelCreated(string channelName, address creator);
120     
121     function Redvolution() {
122         owner = msg.sender;
123         balances[msg.sender] = _totalSupply;
124         channelOwner["general"] = owner;
125         channelOwner["General"] = owner;
126         channelOwner["redvolution"] = owner;
127         channelOwner["Redvolution"] = owner;
128         channelOwner["REDV"] = owner;
129     }
130     
131     function sendMessage(address to, string messageContent, string messageTitle, uint256 amountBonusToken){
132         assert(bytes(messageContent).length <= maxCharacters);
133         transfer(to,amountBonusToken+pricePerMessage);
134         MessageSent(msg.sender,to,amountBonusToken,messageContent,messageTitle,block.timestamp);
135     }
136     
137     function sendMultipleMessages(address[] to, string messageContent, string messageTitle, uint256 amountBonusToken){
138         for(uint i=0;i<to.length;i++){
139             sendMessage(to[i],messageContent,messageTitle,amountBonusToken);
140         }
141     }
142     
143     function sendMessageToChannel(string channelName, string messageContent){ // only owners can send messages to channels
144         assert(bytes(messageContent).length <= maxCharacters);
145         assert(bytes(channelName).length <= channelMaxSize);
146         assert(msg.sender == channelOwner[channelName]);
147         
148         MessageSentToChannel(msg.sender,channelName,messageContent, block.timestamp);
149     }
150     
151     /**
152      * Sales of Channels 
153      */
154      
155     function sellChannel(string channelName, uint256 price){
156         assert(bytes(channelName).length <= channelMaxSize);
157         assert(channelOwner[channelName] != 0);
158         assert(msg.sender == channelOwner[channelName]);
159         
160         channelsOnSale[channelName] = price;
161     } 
162     
163     function buyChannel(string channelName){
164         assert(bytes(channelName).length <= channelMaxSize);
165         assert(channelsOnSale[channelName] > 0);
166         assert(channelOwner[channelName] != 0);
167         
168         transfer(channelOwner[channelName],channelsOnSale[channelName]);
169         
170         ChannelBought(channelName,msg.sender,channelOwner[channelName]);
171         channelOwner[channelName] = msg.sender;
172         channelsOnSale[channelName] = 0;
173     }
174     
175     function createChannel(string channelName){
176         assert(channelOwner[channelName] == 0);
177         assert(bytes(channelName).length <= channelMaxSize);
178         
179         burn(priceCreatingChannel);
180         channelOwner[channelName] = msg.sender;
181         ChannelCreated(channelName,msg.sender);
182     }
183     
184     /**
185      * General setters
186      */
187      
188     function setMetadataUser(string metadata) {
189         assert(bytes(metadata).length <= metadataSize);
190         metadataUser[msg.sender] = metadata;    
191     }
192     
193     function setMetadataChannels(string channelName, string metadata){ // metadata can be used for a lot of things such as redirection or displaying an image
194         assert(msg.sender == channelOwner[channelName]);
195         assert(bytes(metadata).length <= metadataSize);
196         
197         metadataChannel[channelName] = metadata;
198     }
199     
200     /**
201      * General getters
202      */
203     
204     function getOwner(string channel) constant returns(address ownerOfChannel){
205         return channelOwner[channel];
206     }
207     
208     function getPriceChannel(string channel) constant returns(uint256 price){
209         return channelsOnSale[channel];
210     }
211     
212     function getMetadataChannel(string channel) constant returns(string metadataOfChannel){
213         return metadataChannel[channel];
214     }
215     
216     function getMetadataUser(address user) constant returns(string metadataOfUser){
217         return metadataUser[user];
218     }
219     
220     function getRank(address user) constant returns(uint256){
221         return ranks[user];
222     }
223     
224     /**
225      * Update the constants of the network if necessary
226      */
227     
228     function setPricePerMessage(uint256 newPrice) onlyOwner {
229         pricePerMessageChanged(pricePerMessage,newPrice);
230         pricePerMessage = newPrice;
231     }
232     
233     function setPriceCreatingChannel(uint256 newPrice) onlyOwner {
234         priceCreatingChannelChanged(priceCreatingChannel,newPrice);
235         priceCreatingChannel = newPrice;
236     }
237     
238     function setPriceChannelMaxSize(uint256 newSize) onlyOwner {
239         channelMaxSize = newSize;
240     }
241     
242     function setMetadataSize(uint256 newSize) onlyOwner {
243         metadataSize = newSize;
244     }
245     
246     function setMaxCharacters(uint256 newMax) onlyOwner {
247         maxCharacters = newMax;
248     }
249     
250     function setSymbol(string newSymbol) onlyOwner {
251         symbol = newSymbol;
252     }
253     
254     function setName(string newName) onlyOwner {
255         name = newName;
256     }
257     
258     function setRank(address user, uint256 newRank) onlyOwner {
259         ranks[user] = newRank;
260     }
261     
262     /**
263      * Others
264      */
265      
266     function burn(uint256 amount){
267         balances[msg.sender] = safeSub(balances[msg.sender],amount);
268         _totalSupply = safeSub(_totalSupply,amount);
269     }
270     
271     /**
272      * ERC20 functions
273      */
274     
275     function totalSupply() constant returns (uint256 totalSupply) {
276         totalSupply = _totalSupply;
277     }
278   
279     function balanceOf(address _owner) constant returns (uint256 balance) {
280         return balances[_owner];
281     }
282  
283     function transfer(address _to, uint256 _amount) returns (bool success) {
284         balances[msg.sender] = safeSub(balances[msg.sender],_amount);
285         balances[_to] = safeAdd(balances[_to],_amount);
286         Transfer(msg.sender, _to, _amount);
287         return true;
288     }
289      
290     function transferFrom(
291         address _from,
292         address _to,
293         uint256 _amount
294     ) returns (bool success) {
295         
296         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_amount);
297         balances[_from] = safeSub(balances[_from],_amount);
298         balances[_to] = safeAdd(balances[_to],_amount);
299         Transfer(_from, _to, _amount);
300         return true;
301     }
302  
303     function approve(address _spender, uint256 _amount) returns (bool success) {
304         allowed[msg.sender][_spender] = _amount;
305         Approval(msg.sender, _spender, _amount);
306         return true;
307     }
308   
309     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
310         return allowed[_owner][_spender];
311     }
312     
313     /**
314     * @dev Transfer an _amount to multiple addresses, used for airdrop
315     * @param _amount The amount to be transfered
316     * @param addresses The array of addresses to which the tokens will be sent
317     */
318     function transferMultiple(uint256 _amount, address[] addresses) onlyOwner {
319         for (uint i = 0; i < addresses.length; i++) {
320             transfer(addresses[i],_amount);
321         }
322     }
323     
324     function transferMultipleDifferentValues(uint256[] amounts, address[] addresses) onlyOwner {
325         assert(amounts.length == addresses.length);
326         for (uint i = 0; i < addresses.length; i++) {
327             transfer(addresses[i],amounts[i]);
328         }
329     }
330 }