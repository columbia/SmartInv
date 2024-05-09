1 pragma solidity ^0.4.20;
2 //Author: Alexander Shevtsov 
3 //email: randomlogin76@gmail.com
4 //date published: 14 November 2018
5 //https://github.com/randomlogin/hkk-crowdsale
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal  pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal  pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure  returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract Owned {
32 
33     address public owner;
34     address newOwner;
35 
36     modifier only(address _allowed) {
37         require(msg.sender == _allowed);
38         _;
39     }
40 
41     constructor() public {
42         owner = msg.sender;
43     }
44 
45     function transferOwnership(address _newOwner) only(owner) public {
46         newOwner = _newOwner;
47     }
48 
49     function acceptOwnership() only(newOwner) public {
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52     }
53 
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56 }
57 
58 contract Token is Owned {
59     using SafeMath for uint;
60 
61     mapping (address => uint) balances;
62     mapping (address => mapping (address => uint)) allowed;
63     string public name;
64     string public symbol;
65     uint8 public decimals;
66     uint public totalSupply;
67     address public crowdsale;
68 
69     bool public mintable = true; //transferrable if not mintable
70 
71     event Transfer(address indexed _from, address indexed _to, uint _value);
72     event Approval(address indexed _owner, address indexed _spender, uint _value);
73 
74 
75     constructor(string _name, string _symbol, uint8 _decimals) public {
76         name = _name;
77         symbol = _symbol;
78         decimals = _decimals;
79     }
80 
81     function setCrowdsale(address _crowdsale) public {
82         require(crowdsale == 0);
83         crowdsale = _crowdsale;
84     }
85 
86     function transfer(address _to, uint _value) public returns (bool success) {
87         require(!mintable);
88         require(_to != address(0));
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         emit Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
96         require(!mintable);
97         require(_to != address(0));
98         balances[_from] = balances[_from].sub(_value);
99         balances[_to] = balances[_to].add(_value);
100         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101         emit Transfer(_from, _to, _value);
102         return true;
103     }
104 
105     function multiTransfer(address[] dests, uint[] values) public  returns (bool result) {
106         uint i = 0;
107         while (i < dests.length) {
108            result  = result || transfer(dests[i], values[i]);
109            i += 1;
110         }
111         return result;
112     }
113 
114     function balanceOf(address _owner) public view returns (uint balance) {
115         return balances[_owner];
116     }
117 
118     function approve_fixed(address _spender, uint _currentValue, uint _value) public returns (bool success) {
119         if(allowed[msg.sender][_spender] == _currentValue){
120             allowed[msg.sender][_spender] = _value;
121             emit Approval(msg.sender, _spender, _value);
122             return true;
123         } else {
124             return false;
125         }
126     }
127 
128     function approve(address _spender, uint _value) public returns (bool success) {
129         allowed[msg.sender][_spender] = _value;
130         emit Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     function allowance(address _owner, address _spender) public view returns (uint remaining) {
135         return allowed[_owner][_spender];
136     }
137 
138     function mint(address _to, uint _amount) public returns(bool) {
139         require(msg.sender == owner || msg.sender == crowdsale);
140         require(mintable);
141         totalSupply = totalSupply.add(_amount);
142         balances[_to] = balances[_to].add(_amount);
143         emit Transfer(msg.sender, _to, _amount);
144         return true;
145     }
146 
147     function multimint(address[] dests, uint[] values) public returns (uint) {
148         require(msg.sender == owner || msg.sender == crowdsale);
149         uint i = 0;
150         while (i < dests.length) {
151            mint(dests[i], values[i]);
152            i += 1;
153         }
154         return(i);
155     }
156 
157     function deactivateMint() only(owner) public {
158         require(mintable);
159         mintable = false;
160     }
161 
162     function unMint(address _who) public {
163         require(balances[_who] > 0);
164         require(mintable);
165         require(msg.sender == owner || msg.sender == crowdsale);
166         totalSupply = totalSupply.sub(balances[_who]);
167         balances[_who] = 0;
168         emit Transfer(_who, 0x0, balances[_who]);
169     }
170 
171 
172 }
173 
174 contract Crowdsale is Owned {
175 
176     mapping(address => uint) contributions;
177     mapping(address => uint) contributionsUSD;
178 
179     Token public token; //the token to be distributed
180     uint public ETHUSD; //pulled from exchange
181 
182     uint public hardCap = 1000000000000000000000000; //in usd*10**18
183     uint public softCap = 200000000000000000000000; //in usd*10**18
184     bool public active = false;
185 
186     bool public softCapReached;
187     bool public hardCapReached;
188 
189     uint public totalUSD; //total USD contributed, via the rate at the moment it was contributed
190     uint public totalETH; //total ETH contributed (may be redudnant)
191 
192     address[] public beneficiaries; //hardcoded beneficiaries, they recieve half of all contributed amount
193     address public updater; //the address who is eligible to update the ETH/USD price
194 
195     uint[] public timestamps = [1544313600, 1545523200, 1546819200, 1547942400, 1549238400, 1550361600, 1551398400];
196     uint[] public prices = [1000, 1428, 1666, 1739, 1818, 1904, 2000];
197 
198     modifier only(address _address) {
199         require(msg.sender == _address);
200         _;
201     }
202 
203     constructor(address _tokenAddress, address _owner, address _updater) public {
204         token = Token(_tokenAddress);
205         require(prices.length == timestamps.length);
206         owner = _owner;
207         updater = _updater;
208         beneficiaries.push(0x8A0Dee4fB57041Da7104372004a9Fd80A5aC9716); //a bit of hardcode
209         beneficiaries.push(0x049d1EC8Af5e1C5E2b79983dAdb68Ca3C7eb37F4);
210     }
211 
212 
213     //Fallback function to receive Ether. Ether contributed is recalculated into USD.
214     function() payable public {
215         require(active);
216         require(!hardCapReached);
217 
218         contributions[msg.sender] += msg.value;
219         contributionsUSD[msg.sender] += msg.value*ETHUSD / 10**(uint(18));
220 
221         uint amount = calculateTokens(msg.value);
222 
223         totalETH += msg.value;
224         totalUSD += msg.value*ETHUSD / 10**(uint(18));
225 
226         token.mint(msg.sender, amount);
227         if (totalUSD >= softCap ) {
228             softCapReached = true;
229         }
230         if (totalUSD >= hardCap ) {
231             active = false;
232             hardCapReached = true;
233         }
234     }
235 
236     //Takes amount of wei sent by investor and calculates how many tokens he must receive (according to the current
237     //ETH price and token price.
238     //function calculateTokens(uint val) view internal returns(uint) {
239     function calculateTokens(uint val) view public returns(uint) {
240         uint amount = val * ETHUSD / currentPrice();
241         return amount;
242     }
243 
244     //Calculates current price of token in USD.
245     function currentPrice() constant public returns(uint) {
246         for (uint i = 0; i < prices.length; i++ ) {
247             if (now < timestamps[i]) {
248                 return prices[i]*10**uint(17);
249             }
250         }
251         return prices[prices.length-1]*10**uint(17);
252     }
253 
254     //Update current ETHUSD price.
255     function updatePrice(uint _newPrice) only(updater) public {
256         require(msg.sender == updater);
257         require(_newPrice != 0);
258         ETHUSD = _newPrice;
259     }
260 
261     //Activates the ICO. It means tokens can be purchased only when ICO is active.
262     function activate() only(owner) public {
263         require(now < timestamps[timestamps.length-1]);
264         require(!active);
265         active = true;
266     }
267 
268     //Deactivates the ICO;
269     function deactivate() only(owner) public {
270         require(active);
271         active = false;
272     }
273 
274     //Only full amount of Ether can be sent back to the contributor
275     function returnEther(address _contributor) only(owner) public payable {
276         require(_contributor.send(contributions[_contributor]));
277         totalETH -= contributions[_contributor];
278         totalUSD -= contributionsUSD[_contributor];
279         contributions[_contributor] = 0;
280         contributionsUSD[_contributor] = 0;
281         token.unMint(_contributor);
282     }
283 
284     function withdrawContributed() only(owner) public {
285         require(softCapReached);
286         require(beneficiaries[0].send(address(this).balance/2));
287         require(beneficiaries[1].send(address(this).balance));
288     }
289 
290 
291 }