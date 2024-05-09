1 pragma solidity ^0.4.21;
2 
3 contract Partner {
4     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens);
5 }
6 
7 contract Target {
8     function transfer(address _to, uint _value);
9 }
10 
11 contract MNY {
12 
13     string public name = "MNY by Monkey Capital";
14     uint8 public decimals = 18;
15     string public symbol = "MNY";
16 
17     address public owner;
18     address public exchangeAdmin;
19 
20     uint256[] tierTokens = [
21         5.33696E18,
22         7.69493333E18,
23         4.75684324E18,
24         6.30846753E18,
25         6.21620513E18,
26         5.63157219E18,
27         5.80023669E18,
28         5.04458667E18,
29         4.58042767E18,
30         5E18
31     ];
32 
33     uint256[] costPerToken = [
34         9E16,
35         9E16,
36         8E16,
37         7E16,
38         8E16,
39         5E16,
40         6E16,
41         5E16,
42         5E16,
43         6E16
44     ];
45 
46     // used to store list of contracts MNY holds tokens in
47     address[] contracts = [0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0];
48 
49     uint tierLevel = 0;
50     uint maxTier = 9;
51     uint256 totalSupply = 21000000000000000000000000;
52     uint256 circulatingSupply = 0;
53     uint contractCount = 1;
54 
55     // flags
56     bool public receiveEth = true;
57     bool swap = false;
58     bool allSwapped = false;
59     bool distributionCalculated = false;
60 
61     // Storage
62     mapping (address => uint256) public balances;
63     mapping (address => uint256) public tokenBalances;
64     mapping (address => uint256) public tokenShare;
65     mapping (address => uint256) public exchangeRates; // balance and rate in cents (where $1 = 1*10^18)
66 
67     // events
68     event Transfer(address indexed _from, address indexed _to, uint _value);
69 
70     function MNY() {
71         owner = msg.sender;
72     }
73 
74     function transfer(address _to, uint _value, bytes _data) public {
75         // sender must have enough tokens to transfer
76         require(balances[msg.sender] >= _value);
77 
78         if(_to == address(this)) {
79             if(swap == false) {
80                 // WARNING: if you transfer tokens back to the contract outside of the swap you will lose them
81                 // use the exchange function to exchange for tokens with approved partner contracts
82                 totalSupply = add(totalSupply, _value);
83                 circulatingSupply = sub(circulatingSupply, _value);
84                 if(circulatingSupply == 0) allSwapped = true;
85                 tierTokens[maxTier] = add(tierTokens[maxTier], _value);
86                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
87                 Transfer(msg.sender, _to, _value);
88             }
89             else {
90                 require(div(_value, 1 ether) > 0);   // whole tokens only in for swap
91                 if(distributionCalculated = false) {
92                     calculateHeldTokenDistribution();
93                 }
94                 balances[msg.sender] = sub(balances[msg.sender], _value);
95                 shareStoredTokens(msg.sender, div(_value, 1 ether));
96             }
97         }
98         else {
99             // WARNING: if you transfer tokens to a contract address they will be lost unless the contract
100             // has been designed to handle incoming/holding tokens in other contracts
101             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
102             balances[_to] = add(balances[_to], _value);
103 
104             Transfer(msg.sender, _to, _value);
105         }
106     }
107 
108     function transfer(address _to, uint _value) public {
109         // sender must have enough tokens to transfer
110         require(balances[msg.sender] >= _value);
111 
112         if(_to == address(this)) {
113             if(swap == false) {
114                 // WARNING: if you transfer tokens back to the contract outside of the swap you will lose them
115                 // use the exchange function to exchange for tokens with approved partner contracts
116                 totalSupply = add(totalSupply, _value);
117                 circulatingSupply = sub(circulatingSupply, _value);
118                 if(circulatingSupply == 0) allSwapped = true;
119                 tierTokens[maxTier] = add(tierTokens[maxTier], _value);
120                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
121                 Transfer(msg.sender, _to, _value);
122             }
123             else {
124                 if(distributionCalculated = false) {
125                     calculateHeldTokenDistribution();
126                 }
127                 balances[msg.sender] = sub(balances[msg.sender], _value);
128                 shareStoredTokens(msg.sender, div(_value, 1 ether));
129             }
130         }
131         else {
132             // WARNING: if you transfer tokens to a contract address they will be lost unless the contract
133             // has been designed to handle incoming/holding tokens in other contracts
134             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
135             balances[_to] = add(balances[_to], _value);
136 
137             Transfer(msg.sender, _to, _value);
138         }
139     }
140 
141     function allocateTokens(uint256 _submitted, address _recipient) internal {
142         uint256 _availableInTier = mul(tierTokens[tierLevel], costPerToken[tierLevel]);
143         uint256 _allocation = 0;
144 
145         if(_submitted >= _availableInTier) {
146             _allocation = tierTokens[tierLevel];
147             tierTokens[tierLevel] = 0;
148             tierLevel++;
149             if(tierLevel > maxTier) {
150                 swap = true;
151             }
152             _submitted = sub(_submitted, _availableInTier);
153         }
154         else {
155             uint256 stepOne = mul(_submitted, 1 ether);
156             uint256 stepTwo = div(stepOne, costPerToken[tierLevel]);
157             uint256 _tokens = stepTwo;
158             _allocation = add(_allocation, _tokens);
159             tierTokens[tierLevel] = sub(tierTokens[tierLevel], _tokens);
160             _submitted = sub(_submitted, _availableInTier);
161         }
162 
163         // transfer tokens allocated so far to wallet address from contract
164         balances[_recipient] = add(balances[_recipient],_allocation);
165         circulatingSupply = add(circulatingSupply, _allocation);
166         totalSupply = sub(totalSupply, _allocation);
167 
168         if((_submitted != 0) && (tierLevel <= maxTier)) {
169             allocateTokens(_submitted, _recipient);
170         }
171         else {
172             // emit transfer event
173             Transfer(this, _recipient, balances[_recipient]);
174         }
175     }
176 
177     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _sentTokens) public {
178 
179         require(exchangeRates[msg.sender] > 0);
180         uint256 _exchanged = mul(_sentTokens, exchangeRates[_source]);
181 
182         require(_exchanged <= mul(totalSupply, 1 ether));
183         allocateTokens(_exchanged, _recipient);
184     }
185 
186     function addExchangePartnerAddressAndRate(address _partner, uint256 _rate) {
187         require(msg.sender == owner);
188         // check that _partner is a contract address
189         uint codeLength;
190         assembly {
191             codeLength := extcodesize(_partner)
192         }
193         require(codeLength > 0);
194         exchangeRates[_partner] = _rate;
195 
196         bool isContract = existingContract(_partner);
197         if(isContract == false) {
198             contractCount++;
199             contracts[contractCount] = _partner;
200         }
201     }
202 
203     // public data retrieval funcs
204     function getTotalSupply() public constant returns (uint256) {
205         return totalSupply;
206     }
207 
208     function getCirculatingSupply() public constant returns (uint256) {
209         return circulatingSupply;
210     }
211 
212     function balanceOf(address _receiver) public constant returns (uint256) {
213         return balances[_receiver];
214     }
215 
216     function balanceInTier() public constant returns (uint256) {
217         return tierTokens[tierLevel];
218     }
219 
220     function balanceInSpecificTier(uint tier) public constant returns (uint256) {
221         return tierTokens[tier];
222     }
223 
224     function currentTier() public constant returns (uint256) {
225         return tierLevel;
226     }
227 
228     // admin functions
229     function convertTransferredTokensToMny(uint256 _value, address _recipient, address _source, uint256 _originalAmount) public {
230         // allows tokens transferred in for exchange to be converted to MNY and distributed
231         // COE is able to interact directly with contract - other exchange partners cannot
232         require((msg.sender == owner) || (msg.sender == exchangeAdmin));
233         require(exchangeRates[_source] > 0);
234         maintainExternalContractTokenBalance(_source, _originalAmount);
235         allocateTokens(_value, _recipient);
236     }
237 
238     function changeOwner(address _newOwner) public {
239         require(msg.sender == owner);
240         owner = _newOwner;
241     }
242 
243     function changeExchangeAdmin(address _newAdmin) public {
244         require(msg.sender == owner);
245         exchangeAdmin = _newAdmin;
246     }
247 
248     function maintainExternalContractTokenBalance(address _contract, uint256 _tokens) internal {
249         tokenBalances[_contract] = add(tokenBalances[_contract], _tokens);
250     }
251 
252     function getTokenBalance(address _contract) public constant returns (uint256) {
253         return tokenBalances[_contract];
254     }
255 
256     function calculateHeldTokenDistribution() public {
257         require(swap = true);
258         for(uint i=0; i<contractCount; i++) {
259 //            tokenShare[contracts[i]] = div(tokenBalances[contracts[i]], div(add(totalSupply, circulatingSupply), 1 ether));
260             tokenShare[contracts[i]] = div(tokenBalances[contracts[i]], circulatingSupply);
261         }
262         distributionCalculated = true;
263     }
264 
265     function tokenShare(address _contract) public constant returns (uint256) {
266         return tokenShare[_contract];
267     }
268 
269     function shareStoredTokens(address _recipient, uint256 mny) internal {
270         Target t;
271         uint256 share = 0;
272         for(uint i=0; i<contractCount; i++) {
273             share = mul(mny, tokenShare[contracts[i]]);
274 
275             t = Target(contracts[i]);
276             t.transfer(_recipient, share);
277         }
278     }
279 
280     function distributeMnyAfterSwap(address _recipient, uint256 _tokens) public {
281         require(msg.sender == owner);
282         require(totalSupply <= _tokens);
283         balances[_recipient] = add(balances[_recipient], _tokens);
284         Transfer(this, _recipient, _tokens);
285         totalSupply = sub(totalSupply, _tokens);
286         circulatingSupply = add(circulatingSupply, _tokens);
287     }
288 
289     function existingContract(address _contract) internal returns (bool) {
290         for(uint i=0; i<contractCount; i++) {
291             if(contracts[i] == _contract) return true;
292         }
293         return false;
294     }
295 
296     function contractExchangeRate(address _contract) public constant returns (uint256) {
297         return exchangeRates[_contract];
298     }
299 
300     function mul(uint a, uint b) internal pure returns (uint) {
301         uint c = a * b;
302         require(a == 0 || c / a == b);
303         return c;
304     }
305 
306     function div(uint a, uint b) internal pure returns (uint) {
307         // assert(b > 0); // Solidity automatically throws when dividing by 0
308         uint c = a / b;
309         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
310         return c;
311     }
312 
313     function sub(uint a, uint b) internal pure returns (uint) {
314         require(b <= a);
315         return a - b;
316     }
317 
318     function add(uint a, uint b) internal pure returns (uint) {
319         uint c = a + b;
320         require(c >= a);
321         return c;
322     }
323 }