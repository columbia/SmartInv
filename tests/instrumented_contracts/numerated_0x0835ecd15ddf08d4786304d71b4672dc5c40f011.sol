1 pragma solidity ^0.4.13;
2 
3 /**
4 * @title PlusCoin Contract
5 * @dev The main token contract
6 */
7 
8 
9 
10 contract PlusCoin {
11     address public owner; // Token owner address
12     mapping (address => uint256) public balances; // balanceOf
13     // mapping (address => mapping (address => uint256)) public allowance;
14     mapping (address => mapping (address => uint256)) allowed;
15 
16     string public standard = 'PlusCoin 1.0';
17     string public constant name = "PlusCoin";
18     string public constant symbol = "PLC";
19     uint   public constant decimals = 18;
20     uint public totalSupply;
21     
22     uint public constant fpct_packet_size = 3300;
23     uint public ownerPrice = 40 * fpct_packet_size; //PRESALE_PRICE * 3 * fpct_packet_size;
24 
25     State public current_state; // current token state
26     uint public soldAmount; // current sold amount (for current state)
27 
28     uint public constant owner_MIN_LIMIT = 15000000 * fpct_packet_size * 1000000000000000000;
29 
30     uint public constant TOKEN_PRESALE_LIMIT = 100000 * fpct_packet_size * 1000000000000000000;
31     uint public constant TOKEN_ICO1_LIMIT = 3000000 * fpct_packet_size * 1000000000000000000;
32     uint public constant TOKEN_ICO2_LIMIT = 3000000 * fpct_packet_size * 1000000000000000000;
33     uint public constant TOKEN_ICO3_LIMIT = 3000000 * fpct_packet_size * 1000000000000000000;
34 
35     address public allowed_contract;
36 
37 
38     // States
39     enum State {
40         Created,
41         Presale,
42         ICO1,
43         ICO2,
44         ICO3,
45         Freedom,
46         Paused // only for first stages
47     }
48 
49     //
50     // Events
51     // This generates a publics event on the blockchain that will notify clients
52     
53     event Sent(address from, address to, uint amount);
54     event Buy(address indexed sender, uint eth, uint fbt);
55     event Withdraw(address indexed sender, address to, uint eth);
56     event StateSwitch(State newState);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 
60     //
61     // Modifiers
62 
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68 
69     modifier onlyAllowedContract() {
70         require(msg.sender == allowed_contract);
71         _;
72     }
73 
74 
75     modifier onlyOwnerBeforeFree() {
76         if(current_state != State.Freedom) {
77             require(msg.sender == owner);   
78         }
79         _;
80     }
81 
82 
83     modifier inState(State _state) {
84         require(current_state == _state);
85         _;
86     }
87 
88 
89     //
90     // Functions
91     // 
92 
93     // Constructor
94     function PlusCoin() {
95         owner = msg.sender;
96         totalSupply = 25000000 * fpct_packet_size * 1000000000000000000;
97         balances[owner] = totalSupply;
98         current_state = State.Created;
99         soldAmount = 0;
100     }
101 
102     // fallback function
103     function() payable {
104         require(current_state != State.Paused && current_state != State.Created && current_state != State.Freedom);
105         require(msg.value >= 1);
106         require(msg.sender != owner);
107         buyTokens(msg.sender);
108     }
109 
110     /**
111     * @dev Allows the current owner to transfer control of the contract to a newOwner.
112     * @param newOwner The address to transfer ownership to.
113     */
114     function transferOwnership(address newOwner) onlyOwner {
115       if (newOwner != address(0)) {
116         owner = newOwner;
117       }
118     }
119 
120     function safeMul(uint a, uint b) internal returns (uint) {
121         uint c = a * b;
122         require(a == 0 || c / a == b);
123         return c;
124     }
125 
126     function safeSub(uint a, uint b) internal returns (uint) {
127         require(b <= a);
128         return a - b;
129     }
130 
131     function safeAdd(uint a, uint b) internal returns (uint) {
132         uint c = a + b;
133         require(c>=a && c>=b);
134         return c;
135     }
136 
137     // Buy entry point
138     function buy() public payable {
139         require(current_state != State.Paused && current_state != State.Created && current_state != State.Freedom);
140         require(msg.value >= 1);
141         require(msg.sender != owner);
142         buyTokens(msg.sender);
143     }
144 
145     // Payable function for buy coins from token owner
146     function buyTokens(address _buyer) public payable
147     {
148         require(current_state != State.Paused && current_state != State.Created && current_state != State.Freedom);
149         require(msg.value >= 1);
150         require(_buyer != owner);
151         
152         uint256 wei_value = msg.value;
153 
154         uint256 tokens = safeMul(wei_value, ownerPrice);
155         tokens = tokens;
156         
157         uint256 currentSoldAmount = safeAdd(tokens, soldAmount);
158 
159         if(current_state == State.Presale) {
160             require(currentSoldAmount <= TOKEN_PRESALE_LIMIT);
161         }
162         if(current_state == State.ICO1) {
163             require(currentSoldAmount <= TOKEN_ICO1_LIMIT);
164         }
165         if(current_state == State.ICO2) {
166             require(currentSoldAmount <= TOKEN_ICO2_LIMIT);
167         }
168         if(current_state == State.ICO3) {
169             require(currentSoldAmount <= TOKEN_ICO3_LIMIT);
170         }
171 
172         require( (balances[owner] - tokens) >= owner_MIN_LIMIT );
173         
174         balances[owner] = safeSub(balances[owner], tokens);
175         balances[_buyer] = safeAdd(balances[_buyer], tokens);
176         soldAmount = safeAdd(soldAmount, tokens);
177         
178         owner.transfer(this.balance);
179         
180         Buy(_buyer, msg.value, tokens);
181         
182     }
183 
184 
185     function setOwnerPrice(uint128 _newPrice) public
186         onlyOwner
187         returns (bool success)
188     {
189         ownerPrice = _newPrice;
190         return true;
191     }
192 
193 
194 	function setAllowedContract(address _contract_address) public
195         onlyOwner
196         returns (bool success)
197     {
198         allowed_contract = _contract_address;
199         return true;
200     }
201 
202 
203     // change state of token
204     function setTokenState(State _nextState) public
205         onlyOwner
206         returns (bool success)
207     {
208         bool canSwitchState
209             =  (current_state == State.Created && _nextState == State.Presale)
210             || (current_state == State.Presale && _nextState == State.ICO1)
211             || (current_state == State.ICO1 && _nextState == State.ICO2)
212             || (current_state == State.ICO2 && _nextState == State.ICO3)
213             || (current_state == State.ICO3 && _nextState == State.Freedom)
214             //pause (allowed only 'any state->pause' & 'pause->presale' transition)
215             // || (current_state == State.Presale && _nextState == State.Paused)
216             // || (current_state == State.Paused && _nextState == State.Presale)
217             || (current_state != State.Freedom && _nextState == State.Paused)
218             || (current_state == State.Paused);
219 
220         require(canSwitchState);
221         
222         current_state = _nextState;
223 
224         soldAmount = 0;
225         
226         StateSwitch(_nextState);
227 
228         return true;
229     }
230 
231 
232     function remaining_for_sale() public constant returns (uint256 remaining_coins) {
233         uint256 coins = 0;
234 
235         if (current_state == State.Presale) {
236             coins = TOKEN_PRESALE_LIMIT - soldAmount;
237         }
238         if (current_state == State.ICO1) {
239             coins = TOKEN_PRESALE_LIMIT - soldAmount;
240         }
241         if (current_state == State.ICO2) {
242             coins = TOKEN_PRESALE_LIMIT - soldAmount;
243         }
244         if (current_state == State.ICO3) {
245             coins = TOKEN_PRESALE_LIMIT - soldAmount;
246         }
247         if (current_state == State.Freedom) {
248             coins = balances[owner] - owner_MIN_LIMIT;
249         }
250 
251         return coins;
252     }
253 
254     function get_token_state() public constant returns (State) {
255         return current_state;
256     }
257 
258 
259     function withdrawEther(address _to) public 
260         onlyOwner
261     {
262         _to.transfer(this.balance);
263     }
264 
265 
266 
267     /**
268      * ERC 20 token functions
269      *
270      * https://github.com/ethereum/EIPs/issues/20
271      */
272     
273     function transfer(address _to, uint256 _value) 
274         onlyOwnerBeforeFree
275         returns (bool success) 
276     {
277         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
278             balances[msg.sender] -= _value;
279             balances[_to] += _value;
280             Transfer(msg.sender, _to, _value);
281             return true;
282         } else { return false; }
283     }
284 
285     function transferFrom(address _from, address _to, uint256 _value) 
286         onlyOwnerBeforeFree
287         returns (bool success)
288     {
289         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
290             balances[_to] += _value;
291             balances[_from] -= _value;
292             allowed[_from][msg.sender] -= _value;
293             Transfer(_from, _to, _value);
294             return true;
295         } else { return false; }
296     }
297 
298     function balanceOf(address _owner) constant returns (uint256 balance) {
299         return balances[_owner];
300     }
301 
302     function approve(address _spender, uint256 _value) 
303         onlyOwnerBeforeFree
304         returns (bool success)
305     {
306         allowed[msg.sender][_spender] = _value;
307         Approval(msg.sender, _spender, _value);
308         return true;
309     }
310 
311     function allowance(address _owner, address _spender) 
312         onlyOwnerBeforeFree
313         constant returns (uint256 remaining)
314     {
315       return allowed[_owner][_spender];
316     }
317 
318     
319 
320 
321     ///suicide & send funds to owner
322     function destroy() { 
323         if (msg.sender == owner) {
324           suicide(owner);
325         }
326     }
327 
328     
329 }