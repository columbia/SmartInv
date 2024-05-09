1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 contract ERC20Extended is ERC20 {
35     uint256 public decimals;
36     string public name;
37     string public symbol;
38 
39 }
40 
41 contract ComponentInterface {
42     string public name;
43     string public description;
44     string public category;
45     string public version;
46 }
47 
48 contract ExchangeInterface is ComponentInterface {
49     /*
50      * @dev Checks if a trading pair is available
51      * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
52      * @param address _sourceAddress The token to sell for the destAddress.
53      * @param address _destAddress The token to buy with the source token.
54      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
55      * @return boolean whether or not the trading pair is supported by this exchange provider
56      */
57     function supportsTradingPair(address _srcAddress, address _destAddress, bytes32 _exchangeId)
58         external view returns(bool supported);
59 
60     /*
61      * @dev Buy a single token with ETH.
62      * @param ERC20Extended _token The token to buy, should be an ERC20Extended address.
63      * @param uint _amount Amount of ETH used to buy this token. Make sure the value sent to this function is the same as the _amount.
64      * @param uint _minimumRate The minimum amount of tokens to receive for 1 ETH.
65      * @param address _depositAddress The address to send the bought tokens to.
66      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
67      * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here.
68      * @return boolean whether or not the trade succeeded.
69      */
70     function buyToken
71         (
72         ERC20Extended _token, uint _amount, uint _minimumRate,
73         address _depositAddress, bytes32 _exchangeId, address _partnerId
74         ) external payable returns(bool success);
75 
76     /*
77      * @dev Sell a single token for ETH. Make sure the token is approved beforehand.
78      * @param ERC20Extended _token The token to sell, should be an ERC20Extended address.
79      * @param uint _amount Amount of tokens to sell.
80      * @param uint _minimumRate The minimum amount of ETH to receive for 1 ERC20Extended token.
81      * @param address _depositAddress The address to send the bought tokens to.
82      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
83      * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here
84      * @return boolean boolean whether or not the trade succeeded.
85      */
86     function sellToken
87         (
88         ERC20Extended _token, uint _amount, uint _minimumRate,
89         address _depositAddress, bytes32 _exchangeId, address _partnerId
90         ) external returns(bool success);
91 }
92 
93 contract KyberNetworkInterface {
94 
95     function getExpectedRate(ERC20Extended src, ERC20Extended dest, uint srcQty)
96         external view returns (uint expectedRate, uint slippageRate);
97 
98     function trade(
99         ERC20Extended source,
100         uint srcAmount,
101         ERC20Extended dest,
102         address destAddress,
103         uint maxDestAmount,
104         uint minConversionRate,
105         address walletId)
106         external payable returns(uint);
107 }
108 
109 /**
110  * @title Ownable
111  * @dev The Ownable contract has an owner address, and provides basic authorization control
112  * functions, this simplifies the implementation of "user permissions".
113  */
114 contract Ownable {
115   address public owner;
116 
117 
118   event OwnershipRenounced(address indexed previousOwner);
119   event OwnershipTransferred(
120     address indexed previousOwner,
121     address indexed newOwner
122   );
123 
124 
125   /**
126    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
127    * account.
128    */
129   constructor() public {
130     owner = msg.sender;
131   }
132 
133   /**
134    * @dev Throws if called by any account other than the owner.
135    */
136   modifier onlyOwner() {
137     require(msg.sender == owner);
138     _;
139   }
140 
141   /**
142    * @dev Allows the current owner to relinquish control of the contract.
143    */
144   function renounceOwnership() public onlyOwner {
145     emit OwnershipRenounced(owner);
146     owner = address(0);
147   }
148 
149   /**
150    * @dev Allows the current owner to transfer control of the contract to a newOwner.
151    * @param _newOwner The address to transfer ownership to.
152    */
153   function transferOwnership(address _newOwner) public onlyOwner {
154     _transferOwnership(_newOwner);
155   }
156 
157   /**
158    * @dev Transfers control of the contract to a newOwner.
159    * @param _newOwner The address to transfer ownership to.
160    */
161   function _transferOwnership(address _newOwner) internal {
162     require(_newOwner != address(0));
163     emit OwnershipTransferred(owner, _newOwner);
164     owner = _newOwner;
165   }
166 }
167 
168 contract OlympusExchangeAdapterInterface is Ownable {
169 
170     function supportsTradingPair(address _srcAddress, address _destAddress)
171         external view returns(bool supported);
172 
173     function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount)
174         external view returns(uint expectedRate, uint slippageRate);
175 
176     function sellToken
177         (
178         ERC20Extended _token, uint _amount, uint _minimumRate,
179         address _depositAddress
180         ) external returns(bool success);
181 
182     function buyToken
183         (
184         ERC20Extended _token, uint _amount, uint _minimumRate,
185         address _depositAddress
186         ) external payable returns(bool success);
187 
188     function enable() external returns(bool);
189     function disable() external returns(bool);
190     function isEnabled() external view returns (bool success);
191 
192     function setExchangeDetails(bytes32 _id, bytes32 _name) external returns(bool success);
193     function getExchangeDetails() external view returns(bytes32 _name, bool _enabled);
194 
195 }
196 
197 contract OlympusExchangeAdapterManagerInterface is Ownable {
198     function pickExchange(ERC20Extended _token, uint _amount, uint _rate, bool _isBuying) public view returns (bytes32 exchangeId);
199     function supportsTradingPair(address _srcAddress, address _destAddress, bytes32 _exchangeId) external view returns(bool supported);
200     function getExchangeAdapter(bytes32 _exchangeId) external view returns(address);
201     function isValidAdapter(address _adapter) external view returns(bool);
202     function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount, bytes32 _exchangeId)
203         external view returns(uint expectedRate, uint slippageRate);
204 }
205 
206 contract ExchangeAdapterManager is OlympusExchangeAdapterManagerInterface {
207 
208     mapping(bytes32 => OlympusExchangeAdapterInterface) public exchangeAdapters;
209     bytes32[] public exchanges;
210     uint private genExchangeId = 1000;
211     mapping(address=>uint) private adapters;
212     ERC20Extended private constant ETH_TOKEN_ADDRESS = ERC20Extended(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
213 
214 
215     event AddedExchange(bytes32 id);
216 
217     function addExchange(bytes32 _name, address _adapter)
218     external onlyOwner returns(bool) {
219         require(_adapter != 0x0);
220         bytes32 id = keccak256(abi.encodePacked(_adapter, genExchangeId++));
221         require(OlympusExchangeAdapterInterface(_adapter).setExchangeDetails(id, _name));
222         exchanges.push(id);
223         exchangeAdapters[id] = OlympusExchangeAdapterInterface(_adapter);
224         adapters[_adapter]++;
225 
226         emit AddedExchange(id);
227         return true;
228     }
229 
230     function getExchanges() external view returns(bytes32[]) {
231         return exchanges;
232     }
233 
234     function getExchangeInfo(bytes32 _id)
235     external view returns(bytes32 name, bool status) {
236         OlympusExchangeAdapterInterface adapter = exchangeAdapters[_id];
237         require(address(adapter) != 0x0);
238 
239         return adapter.getExchangeDetails();
240     }
241 
242     function getExchangeAdapter(bytes32 _id)
243     external view returns(address)
244     {
245         return address(exchangeAdapters[_id]);
246     }
247 
248     function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount, bytes32 _exchangeId)
249         external view returns(uint expectedRate, uint slippageRate) {
250 
251         if(_exchangeId != 0x0) {
252             return exchangeAdapters[_exchangeId].getPrice(_sourceAddress, _destAddress, _amount);
253         }
254         bytes32 exchangeId = _sourceAddress == ETH_TOKEN_ADDRESS ?
255         pickExchange(_destAddress, _amount, 0, true) :
256         pickExchange(_sourceAddress, _amount, 0, false);
257         if(exchangeId != 0x0) {
258             OlympusExchangeAdapterInterface adapter = exchangeAdapters[exchangeId];
259             return adapter.getPrice(_sourceAddress, _destAddress, _amount);
260         }
261         return(0, 0);
262     }
263 
264     /// >0  : found exchangeId
265     /// ==0 : not found
266     function pickExchange(ERC20Extended _token, uint _amount, uint _rate, bool _isBuying) public view returns (bytes32 exchangeId) {
267 
268         int maxRate = -1;
269         for (uint i = 0; i < exchanges.length; i++) {
270 
271             bytes32 id = exchanges[i];
272             OlympusExchangeAdapterInterface adapter = exchangeAdapters[id];
273             if (!adapter.isEnabled()) {
274                 continue;
275             }
276             uint adapterResultRate;
277             uint adapterResultSlippage;
278             if (_isBuying){
279                 (adapterResultRate,adapterResultSlippage) = adapter.getPrice(ETH_TOKEN_ADDRESS, _token, _amount);
280             } else {
281                 (adapterResultRate,adapterResultSlippage) = adapter.getPrice(_token, ETH_TOKEN_ADDRESS, _amount);
282             }
283             int resultRate = int(adapterResultSlippage);
284 
285 
286             if (adapterResultRate == 0) { // not support
287                 continue;
288             }
289 
290             if (resultRate < int(_rate)) {
291                 continue;
292             }
293 
294             if (resultRate >= maxRate) {
295                 maxRate = resultRate;
296                 return id;
297             }
298         }
299         return 0x0;
300     }
301 
302     function supportsTradingPair(address _srcAddress, address _destAddress, bytes32 _exchangeId) external view returns (bool) {
303         OlympusExchangeAdapterInterface adapter;
304         if(_exchangeId != ""){
305             adapter = exchangeAdapters[id];
306             if(!adapter.isEnabled()){
307                 return false;
308             }
309             if (adapter.supportsTradingPair(_srcAddress, _destAddress)) {
310                 return true;
311             }
312             return false;
313         }
314         for (uint i = 0; i < exchanges.length; i++) {
315             bytes32 id = exchanges[i];
316             adapter = exchangeAdapters[id];
317             if (!adapter.isEnabled()) {
318                 continue;
319             }
320             if (adapter.supportsTradingPair(_srcAddress, _destAddress)) {
321                 return true;
322             }
323         }
324 
325         return false;
326     }
327 
328     function isValidAdapter(address _adapter) external view returns (bool) {
329         return adapters[_adapter] > 0;
330     }
331 }