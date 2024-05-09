1 pragma solidity 0.4.25;
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
187 contract ShinHoDeung is TokenBase {
188     uint256 public sellPrice;
189     uint256 public buyPrice;
190     uint8 freezePercent;
191     address[] private frozenAddresses;
192     mapping (address => uint256) public frozenBalances;
193     
194     event FrozenBalance(address indexed target, uint256 balance);
195     event Price(uint256 newSellPrice, uint256 newBuyPrice);
196     
197     constructor() TokenBase() public {
198         init(10000000000, "ShinHoDeung", "SHD", 18);
199         freezePercent = 100;
200         
201         emit Transfer(address(0), msg.sender, totalSupply);
202     }
203     
204     function _transfer(address _from, address _to, uint256 _value) isRunning internal {
205         require(frozenBalances[_from] <= balances[_from] - _value);
206         
207         super._transfer(_from, _to, _value);
208         
209         if(status == 1) 
210         	freeze(_to, freezePercent);
211     }
212     
213     function increaseFrozenBalances(address target, uint256 _value) isAdmin public {
214         require(_value > 0);
215         if(frozenBalances[target] == 0)
216         	frozenAddresses.push(target);
217         	
218         frozenBalances[target] += _value;
219         emit FrozenBalance(target, frozenBalances[target]);
220     }
221     
222     function decreaseFrozenBalances(address target, uint256 _value) isAdmin public {
223         require(_value > 0 && frozenBalances[target] >= _value);
224         frozenBalances[target] -= _value;
225         
226         if(frozenBalances[target] == 0)
227         	deleteFrozenAddresses(target);
228         	
229         emit FrozenBalance(target, frozenBalances[target]);
230     }
231     
232     function freeze(address target, uint8 percent) isAdmin public {
233         require(percent > 0 && percent <= 100);
234         if(frozenBalances[target] == 0)
235         	frozenAddresses.push(target);
236         
237         uint256 frozenBalance = balances[target] * percent / 100;
238         frozenBalances[target] = frozenBalance;
239         
240         emit FrozenBalance(target, frozenBalance);
241     }
242     
243     function changeFrozenBalanceAll(uint8 percent) isAdmin public {
244         uint arrayLength = frozenAddresses.length;
245 		for (uint i=0; i<arrayLength; i++) {
246 			uint256 frozenBalance = balances[frozenAddresses[i]] * percent / 100;
247         	frozenBalances[frozenAddresses[i]] = frozenBalance;
248 		}
249     }
250     
251     function unfreeze(address target) isAdmin public {
252     	deleteFrozenAddresses(target);
253     
254         delete frozenBalances[target];
255     }
256     
257     function deleteFrozenAddresses(address target) private {
258     	uint arrayLength = frozenAddresses.length;
259     	uint indexToBeDeleted;
260 		for (uint i=0; i<arrayLength; i++) {
261   			if (frozenAddresses[i] == target) {
262     			indexToBeDeleted = i;
263     			break;
264   			}
265 		}
266 		
267 		address lastAddress = frozenAddresses[frozenAddresses.length-1];
268         frozenAddresses[indexToBeDeleted] = lastAddress;
269         frozenAddresses.length--;
270     }
271     
272     function unfreezeAll() isAdmin public {
273     	uint arrayLength = frozenAddresses.length;
274 		for (uint i=0; i<arrayLength; i++) {
275 			delete frozenBalances[frozenAddresses[i]];
276 		}
277         
278         delete frozenAddresses;
279         frozenAddresses.length = 0;
280     }
281     
282     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) isAdmin public {
283         sellPrice = newSellPrice;
284         buyPrice = newBuyPrice;
285         emit Price(sellPrice, buyPrice);
286     }
287     
288     function buy() payable public {
289         require(buyPrice > 0);
290         uint amount = msg.value / buyPrice;
291         _transfer(this, msg.sender, amount);
292     }
293     
294     function sell(uint256 amount) public {
295         require(sellPrice > 0);
296         address myAddress = this;
297         require(myAddress.balance >= amount * sellPrice);
298         _transfer(msg.sender, this, amount);
299         msg.sender.transfer(amount * sellPrice);
300     }
301     
302     function setFreezePercent(uint8 percent) isAdmin public {
303     	freezePercent = percent;
304     }
305     
306     function frozenBalancesOf(address target) public view returns (uint256 balance) {
307          return frozenBalances[target];
308     }
309 }