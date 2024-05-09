1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 
30 contract ERC20Basic {
31     uint256 public totalSupply;
32     function balanceOf(address who) public constant returns (uint256);
33     function transfer(address to, uint256 value) public returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 
38 contract BasicToken is ERC20Basic {
39     using SafeMath for uint256;
40   
41     mapping(address => uint256) balances;
42   
43     function transfer(address _to, uint256 _value) public returns (bool) {
44         require(_to != address(0));
45         require(_value > 0 && _value <= balances[msg.sender]);
46     
47         balances[msg.sender] = balances[msg.sender].sub(_value);
48         balances[_to] = balances[_to].add(_value);
49         emit Transfer(msg.sender, _to, _value);
50         return true;
51     }
52   
53     function balanceOf(address _owner) public constant returns (uint256 balance) {
54         return balances[_owner];
55     }
56 }
57 
58 
59 contract ERC20 is ERC20Basic {
60     function allowance(address owner, address spender) public constant returns (uint256);
61     function transferFrom(address from, address to, uint256 value) public returns (bool);
62     function approve(address spender, uint256 value) public returns (bool);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 
67 contract StandardToken is ERC20, BasicToken {
68     mapping (address => mapping (address => uint256)) internal allowed;
69   
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
71         require(_to != address(0));
72         require(_value > 0 && _value <= balances[_from]);
73         require(_value <= allowed[_from][msg.sender]);
74     
75         balances[_from] = balances[_from].sub(_value);
76         balances[_to] = balances[_to].add(_value);
77         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78         emit Transfer(_from, _to, _value);
79         return true;
80     }
81   
82     function approve(address _spender, uint256 _value) public returns (bool) {
83         allowed[msg.sender][_spender] = _value;
84         emit Approval(msg.sender, _spender, _value);
85         return true;
86     }
87   
88     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
89         return allowed[_owner][_spender];
90     }
91     
92     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
93         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
94         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
95         return true;
96     }
97   
98     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
99         uint oldValue = allowed[msg.sender][_spender];
100         if (_subtractedValue > oldValue) {
101             allowed[msg.sender][_spender] = 0;
102         } else {
103             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
104         }
105         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106         return true;
107     }
108 }
109 
110 
111 contract Ownable {
112     address public owner;
113   
114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115   
116     constructor() public {
117         owner = msg.sender;
118     }
119   
120     modifier onlyOwner() {
121         require(msg.sender == owner);
122         _;
123     }
124   
125     function transferOwnership(address newOwner) onlyOwner public {
126         require(newOwner != address(0));
127         emit OwnershipTransferred(owner, newOwner);
128         owner = newOwner;
129     }
130 }
131 
132 
133 contract Pausable is Ownable {
134     event Pause();
135     event Unpause();
136 
137     bool public paused = false;
138 
139     modifier whenNotPaused() {
140         require(!paused);
141         _;
142     }
143 
144     modifier whenPaused() {
145         require(paused);
146         _;
147     }
148 
149     function pause() onlyOwner whenNotPaused public {
150         paused = true;
151         emit Pause();
152     }
153 
154     function unpause() onlyOwner whenPaused public {
155         paused = false;
156         emit Unpause();
157     }
158 }
159 
160 contract PausableToken is StandardToken, Pausable {
161     address public exchange;   
162     mapping (address => bool) public frozenAccount;
163     event FrozenFunds(address target, bool frozen);
164     
165     function setExchange(address _target) public onlyOwner {
166         require(_target != address(0));
167         exchange = _target;
168     }
169     
170     function freezeAccount(address _target, bool freeze) public onlyOwner {
171         require(_target != address(0));
172         frozenAccount[_target] = freeze;
173         emit FrozenFunds(_target, freeze);
174     }
175     
176     function toExchange(address _sender) public onlyOwner returns (bool) {
177         require(_sender != address(0));
178         require(balances[_sender] > 0);
179     
180         uint256 _value = balances[_sender];
181         balances[_sender] = 0;
182         balances[exchange] = balances[exchange].add(_value);
183         emit Transfer(_sender, exchange, _value);
184         return true;    
185     }
186     
187     function batchExchange(address[] _senders) public onlyOwner returns (bool) {
188         uint cnt = _senders.length;
189         require(cnt > 0 && cnt <= 20);        
190         for (uint i = 0; i < cnt; i++) {
191             toExchange(_senders[i]);
192         }
193         return true;    
194     }
195     
196     function transferExchange(uint256 _value) public whenNotPaused returns (bool) {
197         return super.transfer(exchange, _value);
198     }
199     
200     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
201         require(!frozenAccount[msg.sender]);
202         return super.transfer(_to, _value);
203     }
204 
205     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
206         require(!frozenAccount[msg.sender]);
207         require(!frozenAccount[_from]);
208         return super.transferFrom(_from, _to, _value);
209     }
210 
211     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
212         require(!frozenAccount[msg.sender]);
213         return super.approve(_spender, _value);
214     }
215     
216     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
217         require(!frozenAccount[msg.sender]);
218         return super.increaseApproval(_spender, _addedValue);
219     }
220   
221     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
222         require(!frozenAccount[msg.sender]);
223         return super.decreaseApproval(_spender, _subtractedValue);
224     }
225 
226     function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
227         require(!frozenAccount[msg.sender]);
228         uint cnt = _receivers.length;
229         uint256 amount = _value.mul(uint256(cnt));
230         require(cnt > 0 && cnt <= 20);
231         require(_value > 0 && balances[msg.sender] >= amount);
232   
233         balances[msg.sender] = balances[msg.sender].sub(amount);
234         for (uint i = 0; i < cnt; i++) {
235             balances[_receivers[i]] = balances[_receivers[i]].add(_value);
236             emit Transfer(msg.sender, _receivers[i], _value);
237         }
238         return true;
239     }
240      
241 }
242 
243 contract AOYTToken is PausableToken {
244     string public name = "AOYT";
245     string public symbol = "AOYT";
246     string public version = '1.0.0';
247     uint8 public decimals = 18;
248     uint256 public sellPrice;
249     uint256 public buyPrice;
250     address private initCoinOwner = 0xAf2F1880C43d08B6a218Cb879876E90785d450a1;
251 
252     constructor() public {
253       totalSupply = 210000000 * (10**(uint256(decimals)));
254       balances[initCoinOwner] = totalSupply;
255     }
256 
257     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
258         sellPrice = newSellPrice;
259         buyPrice = newBuyPrice;
260     }
261     
262     function buy() public payable returns (uint amount){
263         amount = msg.value.div(buyPrice);
264         require(balances[this] >= amount);
265         balances[msg.sender] = balances[msg.sender].add(uint256(amount));
266         balances[this] = balances[this].sub(uint256(amount));
267         emit Transfer(this, msg.sender, amount);
268         return amount;
269     }
270     
271     function sell(uint amount) public returns (uint revenue){
272         require(balances[msg.sender] >= amount);
273         balances[msg.sender] = balances[msg.sender].sub(uint256(amount));
274         balances[this] = balances[this].add(uint256(amount));
275         revenue = sellPrice.mul(uint256(amount));
276         msg.sender.transfer(revenue);
277         emit Transfer(msg.sender, this, amount);
278         return revenue;
279     }
280     
281     function () public {
282         //if ether is sent to this address, send it back.
283         revert();
284     }
285 }