1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7  
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract Ryancoin {
38     using SafeMath for uint256;
39     
40     uint256 public constant _initialSupply = 15000000 * (10 ** uint256(decimals));
41     uint256 _totalSupply = 0;
42     uint256 _totalSold = 0;
43     
44     string public constant symbol = "RYC";
45     string public constant name = "Ryancoin";
46     uint8 public constant decimals = 6;
47     uint256 public rate = 1 ether / (500 * (10 ** uint256(decimals)));
48     address public owner;
49     
50     bool public _contractStatus = true;
51     
52     mapping(address => uint256) balances;
53     mapping (address => mapping (address => uint256)) internal allowed; //control allow to spend
54     mapping (address => bool)  _frozenAccount;
55     mapping (address => bool)  _tokenAccount;
56 
57     address[] tokenHolders;
58     
59     //Event
60     event Transfer(address indexed _from, address indexed _to, uint256 _value);
61     event UpdateStatus(string newStatus);
62     event Burn(address target, uint256 _value);
63     event MintedToken(address target, uint256 _value);
64     event FrozenFunds(address target, bool _value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66     
67     function Ryancoin()  {
68         owner = msg.sender;
69         _totalSupply = _initialSupply;
70         balances[owner] = _totalSupply;
71         setTokenHolders(owner);
72     }
73     
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address newOwner) onlyOwner public {
80         require(newOwner != 0x0);
81         owner = newOwner;
82     }
83     
84     function stopContract() public onlyOwner {
85         _contractStatus = false;
86         UpdateStatus("Contract is stop");
87     }
88     
89     function enableContract() public onlyOwner {
90         _contractStatus = true;
91         UpdateStatus("Contract is enable");
92     }
93     
94     function totalSupply() public constant returns (uint256){
95         return _totalSupply;
96     }
97     
98     function totalSold() public constant returns (uint256){
99         return _totalSold;
100     }
101     
102     function totalRate() public constant returns (uint256){
103         return rate;
104     }
105     
106    
107     function updateRate(uint256 _value) onlyOwner public returns (bool success){
108         require(_value > 0);
109         rate = 1 ether / (_value * (10 ** uint256(decimals)));
110         return true;
111     }
112     
113     function () payable public {
114         createTokens(); //send money to contract owner
115     }
116     
117     function createTokens() public payable{
118         require(msg.value > 0 && msg.value > rate && _contractStatus);
119         
120         uint256 tokens = msg.value.div(rate);
121         
122         require(tokens + _totalSold < _totalSupply);
123         
124         require(
125             balances[owner]  >= tokens
126             && tokens > 0
127         );
128         
129         _transfer(owner, msg.sender, tokens);
130         Transfer(owner, msg.sender, tokens);
131         _totalSold = _totalSold.add(tokens);
132         
133         owner.transfer(msg.value); //transfer ether to contract ower
134     }
135     
136     function balanceOf(address _owner) public constant returns (uint256 balance){
137         return balances[_owner];
138     }
139     
140     function transfer(address _to, uint256 _value) public returns (bool success){
141         //Check contract is stop
142         require(_contractStatus);
143         require(!_frozenAccount[msg.sender]);
144         _transfer(msg.sender, _to, _value);
145         return true;
146     }
147     
148     function _transfer(address _from, address _to, uint256 _value) internal {
149         // Prevent transfer to 0x0 address. Use burn() instead
150         require(_to != 0x0);
151         // Check value more than 0
152         require(_value > 0);
153         // Check if the sender has enough
154         require(balances[_from] >= _value);
155         // Check for overflows
156         require(balances[_to] + _value > balances[_to]);
157         // Save this for an assertion in the future
158         uint256 previousBalances = balances[_from] + balances[_to];
159         // Subtract from the sender
160         balances[_from] -= _value;
161         // Set token holder list
162         setTokenHolders(_to);
163         // Add the same to the recipient
164         balances[_to] += _value;
165         Transfer(_from, _to, _value);
166         // Asserts are used to use static analysis to find bugs in your code. They should never fail
167         assert(balances[_from] + balances[_to] == previousBalances);
168     }
169     
170     function transferFromOwner(address _from, address _to, uint256 _value) onlyOwner public returns (bool success){
171         _transfer(_from, _to, _value);
172         return true;
173     }
174     
175     function setTokenHolders(address _holder) internal {
176         if (_tokenAccount[_holder]) return;
177         tokenHolders.push(_holder) -1;
178         _tokenAccount[_holder] = true;
179     }
180     
181     function getTokenHolders() view public returns (address[]) {
182         return tokenHolders;
183     }
184     
185     function countTokenHolders() view public returns (uint) {
186         return tokenHolders.length;
187     }
188     
189     function burn(uint256 _value) public returns (bool success) {
190         require(_value > 0);
191         require(balances[msg.sender] >= _value);    // Check if the sender has enough
192         balances[msg.sender] -= _value;             // Subtract from the sender
193         _totalSupply -= _value;                     // Updates totalSupply
194         Burn(msg.sender, _value);
195         return true;
196     }
197     
198     function burnFromOwner(address _from, uint256 _value) onlyOwner public returns (bool success) {
199         require(_from != address(0));
200         require(_value > 0);
201         require(balances[_from] >= _value);                // Check if the targeted balance is enough
202         balances[_from] -= _value;                         // Subtract from the targeted balance
203         _totalSupply -= _value;                              // Update totalSupply
204         Burn(_from, _value);
205         return true;
206     }
207     
208     function mintToken(address _target, uint256 _mintedAmount) onlyOwner public {
209         require(_target != address(0));
210         require(_mintedAmount > 0);
211         balances[_target] += _mintedAmount;
212         _totalSupply += _mintedAmount;
213         setTokenHolders(_target);
214         Transfer(0, owner, _mintedAmount);
215         Transfer(owner, _target, _mintedAmount);
216         MintedToken(_target, _mintedAmount);
217     }
218     
219     function getfreezeAccount(address _target) public constant returns (bool freeze) {
220         require(_target != 0x0);
221         return _frozenAccount[_target];
222     }
223     
224     function freezeAccount(address _target, bool freeze) onlyOwner public {
225         require(_target != 0x0);
226         _frozenAccount[_target] = freeze;
227         FrozenFunds(_target, freeze);
228     }
229     
230      /**
231    * @dev Transfer tokens from one address to another
232    * @param _from address The address which you want to send tokens from
233    * @param _to address The address which you want to transfer to
234    * @param _value uint256 the amount of tokens to be transferred
235    */
236     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
237         require(_from != address(0));
238         require(_to != address(0));
239         require(_value <= allowed[_from][msg.sender]);
240         _transfer(_from, _to, _value);
241         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242         return true;
243     }
244   
245   /**
246    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247    *
248    * Beware that changing an allowance with this method brings the risk that someone may use both the old
249    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251    * @param _spender The address which will spend the funds.
252    * @param _value The amount of tokens to be spent.
253    */
254     function approve(address _spender, uint256 _value) public returns (bool) {
255         require(_spender != address(0));
256         allowed[msg.sender][_spender] = _value;
257         Approval(msg.sender, _spender, _value);
258         return true;
259      }
260   /**
261    * @dev Function to check the amount of tokens that an owner allowed to a spender.
262    * @param _owner address The address which owns the funds.
263    * @param _spender address The address which will spend the funds.
264    * @return A uint256 specifying the amount of tokens still available for the spender.
265    */
266     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
267         require(_owner != address(0));
268         require(_spender != address(0));
269         return allowed[_owner][_spender];
270     }
271     
272     /**
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    */
277   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
278         require(_spender != address(0));
279         require(_addedValue > 0);
280         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
281         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282         return true;
283   }
284 
285   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
286         require(_spender != address(0));
287         require(_subtractedValue > 0);
288         uint oldValue = allowed[msg.sender][_spender];
289         if (_subtractedValue > oldValue) {
290         allowed[msg.sender][_spender] = 0;
291         } else {
292         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293         }
294         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295         return true;
296   }
297     
298 }