1 /*
2 This file is part of WeiFund.
3 */
4 
5 /*
6 A generic issued EC20 standard token, that can be issued by an issuer which the owner
7 of the contract sets. The issuer can only be set once if the onlyOnce option is true.
8 There is a freezePeriod option on transfers, if need be. There is also an date of
9 last issuance setting, if set, no more tokens can be issued past that time.
10 
11 The token uses the a standard token API as much as possible, and overrides the transfer
12 and transferFrom methods. This way, we dont need special API's to issue this token.
13 We can retain the original StandardToken api, but add additional features.
14 
15 Upon construction, initial token holders can be specified with their values.
16 Two arrays must be used. One with the token holer addresses, the other with the token
17 holder balances. They must be aligned by array index.
18 */
19 
20 pragma solidity ^0.4.4;
21 /*
22 This file is part of WeiFund.
23 */
24 
25 /*
26 A common Owned contract that contains properties for contract ownership.
27 */
28 
29 
30 
31 /// @title A single owned campaign contract for instantiating ownership properties.
32 /// @author Nick Dodson <nick.dodson@consensys.net>
33 contract Owned {
34   // only the owner can use this method
35   modifier onlyowner() {
36     if (msg.sender != owner) {
37       throw;
38     }
39 
40     _;
41   }
42 
43   // the owner property
44   address public owner;
45 }
46 
47 /*
48 This file is part of WeiFund.
49 */
50 
51 
52 /*
53 This implements ONLY the standard functions and NOTHING else.
54 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
55 
56 If you deploy this, you won't have anything useful.
57 
58 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
59 .*/
60 /*
61 This file is part of WeiFund.
62 */
63 
64 
65 contract Token {
66 
67     /// @return total amount of tokens
68     function totalSupply() constant returns (uint256 supply) {}
69 
70     /// @param _owner The address from which the balance will be retrieved
71     /// @return The balance
72     function balanceOf(address _owner) constant returns (uint256 balance) {}
73 
74     /// @notice send `_value` token to `_to` from `msg.sender`
75     /// @param _to The address of the recipient
76     /// @param _value The amount of token to be transferred
77     /// @return Whether the transfer was successful or not
78     function transfer(address _to, uint256 _value) returns (bool success) {}
79 
80     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
81     /// @param _from The address of the sender
82     /// @param _to The address of the recipient
83     /// @param _value The amount of token to be transferred
84     /// @return Whether the transfer was successful or not
85     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
86 
87     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
88     /// @param _spender The address of the account able to transfer the tokens
89     /// @param _value The amount of wei to be approved for transfer
90     /// @return Whether the approval was successful or not
91     function approve(address _spender, uint256 _value) returns (bool success) {}
92 
93     /// @param _owner The address of the account owning tokens
94     /// @param _spender The address of the account able to transfer the tokens
95     /// @return Amount of remaining tokens allowed to spent
96     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
97 
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 }
101 
102 
103 contract StandardToken is Token {
104 
105     function transfer(address _to, uint256 _value) returns (bool) {
106         //Default assumes totalSupply can't be over max (2^256 - 1).
107         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
108         //Replace the if with this one instead.
109         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
110         if (balances[msg.sender] >= _value && _value > 0) {
111             balances[msg.sender] -= _value;
112             balances[_to] += _value;
113             Transfer(msg.sender, _to, _value);
114             return true;
115         } else { return false; }
116     }
117 
118     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
119         //same as above. Replace this line with the following if you want to protect against wrapping uints.
120         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
121         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
122             balances[_to] += _value;
123             balances[_from] -= _value;
124             allowed[_from][msg.sender] -= _value;
125             Transfer(_from, _to, _value);
126             return true;
127         } else { return false; }
128     }
129 
130     function balanceOf(address _owner) constant returns (uint256 balance) {
131         return balances[_owner];
132     }
133 
134     function approve(address _spender, uint256 _value) returns (bool success) {
135         allowed[msg.sender][_spender] = _value;
136         Approval(msg.sender, _spender, _value);
137         return true;
138     }
139 
140     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
141       return allowed[_owner][_spender];
142     }
143 
144     mapping (address => uint256) balances;
145     mapping (address => mapping (address => uint256)) allowed;
146     uint256 public totalSupply;
147 }
148 
149 
150 /*
151 This file is part of WeiFund.
152 */
153 
154 /*
155 Used for contracts that have an issuer.
156 */
157 
158 
159 
160 /// @title Issued - interface used for build issued asset contracts
161 /// @author Nick Dodson <nick.dodson@consensys.net>
162 contract Issued {
163   /// @notice will set the asset issuer address
164   /// @param _issuer The address of the issuer
165   function setIssuer(address _issuer) public {}
166 }
167 
168 
169 
170 /// @title Issued token contract allows new tokens to be issued by an issuer.
171 /// @author Nick Dodson <nick.dodson@consensys.net>
172 contract IssuedToken is Owned, Issued, StandardToken {
173   function transfer(address _to, uint256 _value) public returns (bool) {
174     // if the issuer is attempting transfer
175     // then mint new coins to address of transfer
176     // by using transfer, we dont need to switch StandardToken API method
177     if (msg.sender == issuer && (lastIssuance == 0 || block.number < lastIssuance)) {
178       // increase the balance of user by transfer amount
179       balances[_to] += _value;
180 
181       // increase total supply by balance
182       totalSupply += _value;
183 
184       // return required true value for transfer
185       return true;
186     } else {
187       if (freezePeriod == 0 || block.number > freezePeriod) {
188         // continue with a normal transfer
189         return super.transfer(_to, _value);
190       }
191     }
192   }
193 
194   function transferFrom(address _from, address _to, uint256 _value)
195     public
196     returns (bool success) {
197     // if we are passed the free period, then transferFrom
198     if (freezePeriod == 0 || block.number > freezePeriod) {
199       // return transferFrom
200       return super.transferFrom(_from, _to, _value);
201     }
202   }
203 
204   function setIssuer(address _issuer) public onlyowner() {
205     // set the issuer
206     if (issuer == address(0)) {
207       issuer = _issuer;
208     } else {
209       throw;
210     }
211   }
212 
213   function IssuedToken(
214     address[] _addrs,
215     uint256[] _amounts,
216     uint256 _freezePeriod,
217     uint256 _lastIssuance,
218     address _owner,
219     string _name,
220     uint8 _decimals,
221     string _symbol) {
222     // issue the initial tokens, if any
223     for (uint256 i = 0; i < _addrs.length; i ++) {
224       // increase balance of that address
225       balances[_addrs[i]] += _amounts[i];
226 
227       // increase token supply of that address
228       totalSupply += _amounts[i];
229     }
230 
231     // set the transfer freeze period, if any
232     freezePeriod = _freezePeriod;
233 
234     // set the token owner, who can set the issuer
235     owner = _owner;
236 
237     // set the blocknumber of last issuance, if any
238     lastIssuance = _lastIssuance;
239 
240     // set token name
241     name = _name;
242 
243     // set decimals
244     decimals = _decimals;
245 
246     // set sumbol
247     symbol = _symbol;
248   }
249 
250   // the transfer freeze period
251   uint256 public freezePeriod;
252 
253   // the block number of last issuance (set to zero, if none)
254   uint256 public lastIssuance;
255 
256   // the token issuer address, if any
257   address public issuer;
258 
259   // token name
260   string public name;
261 
262   // token decimals
263   uint8 public decimals;
264 
265   // symbol
266   string public symbol;
267 
268   // verison
269   string public version = "WFIT1.0";
270 }
271 
272 
273 /// @title Private Service Registry - used to register generated service contracts.
274 /// @author Nick Dodson <nick.dodson@consensys.net>
275 contract PrivateServiceRegistryInterface {
276   /// @notice register the service '_service' with the private service registry
277   /// @param _service the service contract to be registered
278   /// @return the service ID 'serviceId'
279   function register(address _service) internal returns (uint256 serviceId) {}
280 
281   /// @notice is the service in question '_service' a registered service with this registry
282   /// @param _service the service contract address
283   /// @return either yes (true) the service is registered or no (false) the service is not
284   function isService(address _service) public constant returns (bool) {}
285 
286   /// @notice helps to get service address
287   /// @param _serviceId the service ID
288   /// @return returns the service address of service ID
289   function services(uint256 _serviceId) public constant returns (address _service) {}
290 
291   /// @notice returns the id of a service address, if any
292   /// @param _service the service contract address
293   /// @return the service id of a service
294   function ids(address _service) public constant returns (uint256 serviceId) {}
295 
296   event ServiceRegistered(address _sender, address _service);
297 }
298 
299 contract PrivateServiceRegistry is PrivateServiceRegistryInterface {
300 
301   modifier isRegisteredService(address _service) {
302     // does the service exist in the registry, is the service address not empty
303     if (services.length > 0) {
304       if (services[ids[_service]] == _service && _service != address(0)) {
305         _;
306       }
307     }
308   }
309 
310   modifier isNotRegisteredService(address _service) {
311     // if the service '_service' is not a registered service
312     if (!isService(_service)) {
313       _;
314     }
315   }
316 
317   function register(address _service)
318     internal
319     isNotRegisteredService(_service)
320     returns (uint serviceId) {
321     // create service ID by increasing services length
322     serviceId = services.length++;
323 
324     // set the new service ID to the '_service' address
325     services[serviceId] = _service;
326 
327     // set the ids store to link to the 'serviceId' created
328     ids[_service] = serviceId;
329 
330     // fire the 'ServiceRegistered' event
331     ServiceRegistered(msg.sender, _service);
332   }
333 
334   function isService(address _service)
335     public
336     constant
337     isRegisteredService(_service)
338     returns (bool) {
339     return true;
340   }
341 
342   address[] public services;
343   mapping(address => uint256) public ids;
344 }
345 
346 /// @title Issued Token Factory - used to generate and register IssuedToken contracts
347 /// @author Nick Dodson <nick.dodson@consensys.net>
348 contract IssuedTokenFactory is PrivateServiceRegistry {
349   function createIssuedToken(
350     address[] _addrs,
351     uint256[] _amounts,
352     uint256 _freezePeriod,
353     uint256 _lastIssuance,
354     string _name,
355     uint8 _decimals,
356     string _symbol)
357   public
358   returns (address tokenAddress) {
359     // create a new multi sig wallet
360     tokenAddress = address(new IssuedToken(
361       _addrs,
362       _amounts,
363       _freezePeriod,
364       _lastIssuance,
365       msg.sender,
366       _name,
367       _decimals,
368       _symbol));
369 
370     // register that multisig wallet address as service
371     register(tokenAddress);
372   }
373 }