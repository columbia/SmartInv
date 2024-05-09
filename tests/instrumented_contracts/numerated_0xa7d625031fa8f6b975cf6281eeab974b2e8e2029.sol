1 pragma solidity ^0.4.11;
2 
3 	//	HUNT Crowdsale Token Contract 
4 	//	Aqua Commerce LTD Company #194644 (Republic of Seychelles)
5 	//	The MIT Licence .
6 
7 
8 contract SafeMath {
9 	
10     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
11         assert((z = x - y) <= x);
12     }
13 
14     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
15         assert((z = x + y) >= x);
16     }
17 	
18 	function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
19         z = x / y;
20     }
21 	
22 	function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
23         z = x <= y ? x : y;
24     }
25 }
26 
27 
28 contract Owned {
29     
30 	address public owner;
31     address public newOwner;
32 	
33     event OwnershipTransferred(address indexed _from, address indexed _to);
34 
35     function Owned() {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         assert (msg.sender == owner);
41         _;
42     }
43 
44     function transferOwnership(address _newOwner) onlyOwner {
45         newOwner = _newOwner;
46     }
47  
48     function acceptOwnership() {
49         if (msg.sender == newOwner) {
50             OwnershipTransferred(owner, newOwner);
51             owner = newOwner;
52         }
53     }
54 }
55 
56 
57 //	ERC20 interface
58 //	see https://github.com/ethereum/EIPs/issues/20
59 contract ERC20 {
60 	
61 	function totalSupply() constant returns (uint totalSupply);
62 	function balanceOf(address who) constant returns (uint);
63 	function allowance(address owner, address spender) constant returns (uint);
64 	
65 	function transfer(address to, uint value) returns (bool ok);
66 	function transferFrom(address from, address to, uint value) returns (bool ok);
67 	function approve(address spender, uint value) returns (bool ok);
68   
69 	event Transfer(address indexed from, address indexed to, uint value);
70 	event Approval(address indexed owner, address indexed spender, uint value);
71 }
72 
73 
74 contract StandardToken is ERC20, SafeMath {
75 	
76 	uint256                                            _totalSupply;
77     mapping (address => uint256)                       _balances;
78     mapping (address => mapping (address => uint256))  _approvals;
79     
80     modifier onlyPayloadSize(uint numwords) {
81 		assert(msg.data.length == numwords * 32 + 4);
82         _;
83    }
84    
85     function totalSupply() constant returns (uint256) {
86         return _totalSupply;
87     }
88     function balanceOf(address _who) constant returns (uint256) {
89         return _balances[_who];
90     }
91     function allowance(address _owner, address _spender) constant returns (uint256) {
92         return _approvals[_owner][_spender];
93     }
94     
95     function transfer(address _to, uint _value) onlyPayloadSize(2) returns (bool success) {
96         assert(_balances[msg.sender] >= _value);
97         
98         _balances[msg.sender] = sub(_balances[msg.sender], _value);
99         _balances[_to] = add(_balances[_to], _value);
100         
101         Transfer(msg.sender, _to, _value);
102         
103         return true;
104     }
105     
106     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3) returns (bool success) {
107         assert(_balances[_from] >= _value);
108         assert(_approvals[_from][msg.sender] >= _value);
109         
110         _approvals[_from][msg.sender] = sub(_approvals[_from][msg.sender], _value);
111         _balances[_from] = sub(_balances[_from], _value);
112         _balances[_to] = add(_balances[_to], _value);
113         
114         Transfer(_from, _to, _value);
115         
116         return true;
117     }
118     
119     function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success) {
120         _approvals[msg.sender][_spender] = _value;
121         
122         Approval(msg.sender, _spender, _value);
123         
124         return true;
125     }
126 
127 }
128 
129 contract HUNT is StandardToken, Owned {
130 
131     // Token information
132 	string public constant name = "HUNT";
133     string public constant symbol = "HT";
134     uint8 public constant decimals = 18;
135 	
136     // Initial contract data
137 	uint256 public capTokens;
138     uint256 public startDate;
139     uint256 public endDate;
140     uint public curs;
141 	
142 	address addrcnt;
143 	uint256 public totalTokens;
144 	uint256 public totalEthers;
145 	mapping (address => uint256) _userBonus;
146 	
147     event BoughtTokens(address indexed buyer, uint256 ethers,uint256 newEtherBalance, uint256 tokens, uint _buyPrice);
148 	event Collect(address indexed addrcnt,uint256 amount);
149 	
150     function HUNT(uint256 _start, uint256 _end, uint256 _capTokens, uint _curs, address _addrcnt) {
151         startDate	= _start;
152 		endDate		= _end;
153         capTokens   = _capTokens;
154         addrcnt  	= _addrcnt;
155 		curs		= _curs;
156     }
157 
158 	function time() internal constant returns (uint) {
159         return block.timestamp;
160     }
161 	
162     // Cost of one token
163     // Day  1-2  : 1 USD = 1 HUNT
164     // Days 3–5  : 1.2 USD = 1 HUNT
165     // Days 6–10 : 1.3 USD = 1 HUNT
166     // Days 11–15: 1.4 USD = 1 HUNT
167     // Days 16–22: 1.5 USD = 1 HUNT
168     
169     
170     function buyPrice() constant returns (uint256) {
171         return buyPriceAt(time());
172     }
173 
174 	function buyPriceAt(uint256 at) constant returns (uint256) {
175         if (at < startDate) {
176             return 0;
177         } else if (at < (startDate + 2 days)) {
178             return div(curs,100);
179         } else if (at < (startDate + 5 days)) {
180             return div(curs,120);
181         } else if (at < (startDate + 10 days)) {
182             return div(curs,130);
183         } else if (at < (startDate + 15 days)) {
184             return div(curs,140);
185         } else if (at <= endDate) {
186             return div(curs,150);
187         } else {
188             return 0;
189         }
190     }
191 
192     // Buy tokens from the contract
193     function () payable {
194         buyTokens(msg.sender);
195     }
196 
197     // Exchanges can buy on behalf of participant
198     function buyTokens(address participant) payable {
199         
200 		// No contributions before the start of the crowdsale
201         require(time() >= startDate);
202         
203 		// No contributions after the end of the crowdsale
204         require(time() <= endDate);
205         
206 		// No 0 contributions
207         require(msg.value > 0);
208 
209         // Add ETH raised to total
210         totalEthers = add(totalEthers, msg.value);
211         
212 		// What is the HUNT to ETH rate
213         uint256 _buyPrice = buyPrice();
214 		
215         // Calculate #HUNT - this is safe as _buyPrice is known
216         // and msg.value is restricted to valid values
217         uint tokens = msg.value * _buyPrice;
218 
219         // Check tokens > 0
220         require(tokens > 0);
221 
222 		if ((time() >= (startDate + 15 days)) && (time() <= endDate)){
223 			uint leftTokens=sub(capTokens,add(totalTokens, tokens));
224 			leftTokens = (leftTokens>0)? leftTokens:0;
225 			uint bonusTokens = min(_userBonus[participant],min(tokens,leftTokens));
226 			
227 			// Check bonusTokens >= 0
228 			require(bonusTokens >= 0);
229 			
230 			tokens = add(tokens,bonusTokens);
231         }
232 		
233 		// Cannot exceed capTokens
234 		totalTokens = add(totalTokens, tokens);
235         require(totalTokens <= capTokens);
236 
237 		// Compute tokens for foundation 38%
238         // Number of tokens restricted so maths is safe
239         uint ownerTokens = div(tokens,50)*19;
240 
241 		// Add to total supply
242         _totalSupply = add(_totalSupply, tokens);
243 		_totalSupply = add(_totalSupply, ownerTokens);
244 		
245         // Add to balances
246         _balances[participant] = add(_balances[participant], tokens);
247 		_balances[owner] = add(_balances[owner], ownerTokens);
248 
249 		// Add to user bonus
250 		if (time() < (startDate + 2 days)){
251 			uint bonus = div(tokens,2);
252 			_userBonus[participant] = add(_userBonus[participant], bonus);
253         }
254 		
255 		// Log events
256         BoughtTokens(participant, msg.value, totalEthers, tokens, _buyPrice);
257         Transfer(0x0, participant, tokens);
258 		Transfer(0x0, owner, ownerTokens);
259 
260     }
261 
262     // Transfer the balance from owner's account to another account, with a
263     // check that the crowdsale is finalised 
264     function transfer(address _to, uint _amount) returns (bool success) {
265         // Cannot transfer before crowdsale ends + 7 days
266         require((time() > endDate + 7 days ));
267         // Standard transfer
268         return super.transfer(_to, _amount);
269     }
270 
271     // Spender of tokens transfer an amount of tokens from the token owner's
272     // balance to another account, with a check that the crowdsale is
273     // finalised 
274     function transferFrom(address _from, address _to, uint _amount) returns (bool success) {
275         // Cannot transfer before crowdsale ends + 7 days
276         require((time() > endDate + 7 days ));
277         // Standard transferFrom
278         return super.transferFrom(_from, _to, _amount);
279     }
280 
281     function mint(uint256 _amount) onlyOwner {
282         require((time() > endDate + 7 days ));
283         require(_amount > 0);
284         _balances[owner] = add(_balances[owner], _amount);
285         _totalSupply = add(_totalSupply, _amount);
286         Transfer(0x0, owner, _amount);
287     }
288 
289     function burn(uint256 _amount) onlyOwner {
290 		require((time() > endDate + 7 days ));
291         require(_amount > 0);
292         _balances[owner] = sub(_balances[owner],_amount);
293         _totalSupply = sub(_totalSupply,_amount);
294 		Transfer(owner, 0x0 , _amount);
295     }
296     
297 	function setCurs(uint _curs) onlyOwner {
298         require(_curs > 0);
299         curs = _curs;
300     }
301 
302   	// Crowdsale owners can collect ETH any number of times
303     function collect() onlyOwner {
304 		require(addrcnt.call.value(this.balance)(0));
305 		Collect(addrcnt,this.balance);
306 	}
307 }