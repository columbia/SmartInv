1 pragma solidity 0.4.24;
2 
3  contract Math {
4     function add(uint256 x, uint256 y) pure internal returns(uint256) {
5       uint256 z = x + y;
6       assert((z >= x) && (z >= y));
7       return z;
8     }
9 
10     function subtract(uint256 x, uint256 y) pure internal returns(uint256) {
11       assert(x >= y);
12       uint256 z = x - y;
13       return z;
14     }
15 }
16 
17 contract Auth {
18     address owner = 0x0;
19     address admin = 0x0;
20 
21     modifier isOwner {
22         require(owner == msg.sender);
23         _;
24     }
25 
26     modifier isAdmin {
27         require(owner == msg.sender || admin == msg.sender);
28         _;
29     }
30     
31     function setOwner(address _owner) isOwner public {
32         owner = _owner;
33     }
34     
35     function setAdmin(address _admin) isOwner public {
36         admin = _admin;
37     }
38     
39     function getManagers() public view returns (address _owner, address _admin) {
40         return (owner, admin);
41     }
42 }
43 
44 contract Manage is Auth {
45     
46     /**
47      *  0 : init, 1 : limited, 2 : running, 3 : finishing
48      */
49     uint8 public status = 0;
50 
51     modifier isRunning {
52         require(status == 2 || owner == msg.sender || admin == msg.sender || (status == 1 && (owner == msg.sender || admin == msg.sender)));
53         _;
54     }
55 
56     function limit() isAdmin public {
57     	require(status != 1);
58         status = 1;
59     }
60     
61     function start() isAdmin public {
62     	require(status != 2);
63         status = 2;
64     }
65     
66     function close() isAdmin public {
67     	require(status != 3);
68         status = 3;
69     }
70 }
71 
72 contract EIP20Interface {
73     uint256 public totalSupply;
74     function balanceOf(address _owner) public view returns (uint256 balance);
75     function transfer(address _to, uint256 _value) public returns (bool success);
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
77     function approve(address _spender, uint256 _value) public returns (bool success);
78     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
79     
80     event Transfer(address indexed _from, address indexed _to, uint256 _value);
81     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
82 }
83 
84 contract TokenBase is EIP20Interface, Manage, Math {
85     string public name;
86     string public symbol;
87     uint8 public decimals;
88     
89     event Burn(address indexed from, uint256 value);
90 
91     mapping (address => uint256) public balances;
92     mapping (address => mapping (address => uint256)) public allowed;
93     
94     constructor() public {
95         owner = msg.sender;
96         admin = msg.sender;
97     }
98     
99     function init(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 tokenDecimals) internal {
100         require(status == 0);
101         totalSupply = initialSupply * 10 ** uint256(tokenDecimals);
102         balances[msg.sender] = totalSupply;
103         name = tokenName;
104         symbol = tokenSymbol;
105         decimals = tokenDecimals;
106         status = 1;
107     }
108     
109     function _transfer(address _from, address _to, uint256 _value) isRunning internal {
110     	require(0x0 != _to);
111         require(balances[_from] >= _value);
112         require(balances[_to] + _value >= balances[_to]);
113         uint previousBalances = balances[_from] + balances[_to];
114         balances[_from] = Math.subtract(balances[_from], _value);
115         balances[_to] = Math.add(balances[_to], _value);
116         emit Transfer(_from, _to, _value);
117         assert(balances[_from] + balances[_to] == previousBalances);
118     }
119     
120     function transfer(address _to, uint256 _value) public returns (bool success) {
121         _transfer(msg.sender, _to, _value);
122         return true;
123     }
124     
125     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
126         require(_value <= allowed[_from][msg.sender]);
127         allowed[_from][msg.sender] -= _value;
128         _transfer(_from, _to, _value);
129         return true;
130     }
131     
132     function approve(address _spender, uint256 _value) isRunning public returns (bool success) {
133         require(_value == 0 || allowed[msg.sender][_spender] == 0);
134         allowed[msg.sender][_spender] = _value;
135         emit Approval(msg.sender, _spender, _value);
136         return true;
137     }
138     
139     function increaseApproval(address _spender, uint256 _value) isRunning public returns (bool success) {
140    		allowed[msg.sender][_spender] = Math.add(allowed[msg.sender][_spender], _value);
141    		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142    		return true;
143 	}
144 
145 	function decreaseApproval(address _spender, uint _value) isRunning public returns (bool success) {
146 	   	uint256 oldValue = allowed[msg.sender][_spender];
147 	   	if (_value >= oldValue) {
148 	       allowed[msg.sender][_spender] = 0;
149 	   	} else {
150 	       allowed[msg.sender][_spender] = Math.subtract(oldValue, _value);
151 	   	}
152 	   	emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153 	   	return true;
154 	}
155     
156     function burn(uint256 _value) public returns (bool success) {
157         require(balances[msg.sender] >= _value);   // Check if the sender has enough
158         balances[msg.sender] -= _value;            // Subtract from the sender
159         totalSupply -= _value;                      // Updates totalSupply
160         emit Burn(msg.sender, _value);
161         return true;
162     }
163     
164     function burnFrom(address _from, uint256 _value) public returns (bool success) {
165         require(balances[_from] >= _value);                // Check if the targeted balance is enough
166         require(_value <= allowed[_from][msg.sender]);    // Check allowance
167         balances[_from] -= _value;                         // Subtract from the targeted balance
168         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
169         totalSupply -= _value;                              // Update totalSupply
170         emit Burn(_from, _value);
171         return true;
172     }
173     
174     function balanceOf(address _owner) public view returns (uint256 balance) {
175         return balances[_owner];
176     }
177     
178     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
179         return allowed[_owner][_spender];
180     }
181     
182     function destruct() isOwner public {
183         selfdestruct(owner);
184     }
185 }
186 
187 contract AutoBit is TokenBase {
188     uint256 public sellPrice;
189     uint256 public buyPrice;
190     uint8 freezePercent;
191     address[] private frozenAddresses;
192     mapping (address => uint256) public frozenBalances;
193     mapping (address => mapping (uint256 => uint256)) public payedBalances;
194     
195     event FrozenBalance(address indexed target, uint256 balance);
196     event Price(uint256 newSellPrice, uint256 newBuyPrice);
197     
198     constructor() TokenBase() public {
199         init(10000000000, "AutoBit", "ATB", 18);
200         freezePercent = 100;
201         
202         emit Transfer(address(0), msg.sender, totalSupply);
203     }
204     
205     function _transfer(address _from, address _to, uint256 _value) isRunning internal {
206         require(frozenBalances[_from] <= balances[_from] - _value);
207         
208         super._transfer(_from, _to, _value);
209         
210         if(status == 1) 
211         	freeze(_to, freezePercent);
212     }
213     
214     function increaseFrozenBalances(address target, uint256 _value) isAdmin public {
215         require(_value > 0);
216         if(frozenBalances[target] == 0)
217         	frozenAddresses.push(target);
218         	
219         frozenBalances[target] += _value;
220         emit FrozenBalance(target, frozenBalances[target]);
221     }
222     
223     function decreaseFrozenBalances(address target, uint256 _value) isAdmin public {
224         require(_value > 0 && frozenBalances[target] >= _value);
225         frozenBalances[target] -= _value;
226         
227         if(frozenBalances[target] == 0)
228         	deleteFrozenAddresses(target);
229         	
230         emit FrozenBalance(target, frozenBalances[target]);
231     }
232     
233     function freeze(address target, uint8 percent) isAdmin public {
234         require(percent > 0 && percent <= 100);
235         if(frozenBalances[target] == 0)
236         	frozenAddresses.push(target);
237         
238         uint256 frozenBalance = balances[target] * percent / 100;
239         frozenBalances[target] = frozenBalance;
240         
241         emit FrozenBalance(target, frozenBalance);
242     }
243     
244     function changeFrozenBalanceAll(uint8 percent) isAdmin public {
245         uint arrayLength = frozenAddresses.length;
246 		for (uint i=0; i<arrayLength; i++) {
247 			uint256 frozenBalance = balances[frozenAddresses[i]] * percent / 100;
248         	frozenBalances[frozenAddresses[i]] = frozenBalance;
249 		}
250     }
251     
252     function unfreeze(address target) isAdmin public {
253     	deleteFrozenAddresses(target);
254     
255         delete frozenBalances[target];
256     }
257     
258     function deleteFrozenAddresses(address target) private {
259     	uint arrayLength = frozenAddresses.length;
260     	uint indexToBeDeleted;
261 		for (uint i=0; i<arrayLength; i++) {
262   			if (frozenAddresses[i] == target) {
263     			indexToBeDeleted = i;
264     			break;
265   			}
266 		}
267 		
268 		address lastAddress = frozenAddresses[frozenAddresses.length-1];
269         frozenAddresses[indexToBeDeleted] = lastAddress;
270         frozenAddresses.length--;
271     }
272     
273     function unfreezeAll() isAdmin public {
274     	uint arrayLength = frozenAddresses.length;
275 		for (uint i=0; i<arrayLength; i++) {
276 			delete frozenBalances[frozenAddresses[i]];
277 		}
278         
279         delete frozenAddresses;
280         frozenAddresses.length = 0;
281     }
282     
283     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) isAdmin public {
284         sellPrice = newSellPrice;
285         buyPrice = newBuyPrice;
286         emit Price(sellPrice, buyPrice);
287     }
288     
289     function pay(address _to, uint256 _value, uint256 no) public returns (bool success) {
290         _transfer(msg.sender, _to, _value);
291         payedBalances[msg.sender][no] = _value;
292         return true;
293     }
294     
295     function payedBalancesOf(address target, uint256 no) public view returns (uint256 balance) {
296         return payedBalances[target][no];
297     }
298     
299     function buy() payable public {
300         require(buyPrice > 0);
301         uint amount = msg.value / buyPrice;
302         _transfer(this, msg.sender, amount);
303     }
304     
305     function sell(uint256 amount) public {
306         require(sellPrice > 0);
307         address myAddress = this;
308         require(myAddress.balance >= amount * sellPrice);
309         _transfer(msg.sender, this, amount);
310         msg.sender.transfer(amount * sellPrice);
311     }
312     
313     function setFreezePercent(uint8 percent) isAdmin public {
314     	freezePercent = percent;
315     }
316     
317     function frozenBalancesOf(address target) public view returns (uint256 balance) {
318          return frozenBalances[target];
319     }
320 }