1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4     //Безопасное умножение.
5 	//Safe multiplication.
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 	//Безопасное деление.
12 	//Safe division.
13   function div(uint256 a, uint256 b) internal constant returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 	//Безопасное вычитание.
20 	//Safe subtraction.
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 	//Безопасное сложение.
26 	//Safe addition.
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract Ownable {
35   
36   address public owner;
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() {
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner {
59     require(newOwner != address(0));      
60     owner = newOwner;
61   }
62 
63 }
64 
65 contract COIN is Ownable {
66     
67     using SafeMath for uint256;
68 	
69 	string public constant name = "daoToken";
70     string public constant symbol = "dao";
71     uint8 constant decimals = 18;
72     
73     bytes32 constant password = keccak256("...And Justice For All!");
74 	bytes32 constant fin = keccak256("...I Saw The Throne Of Gods...");
75     
76     mapping (address => uint256) balances;
77     uint256 public totalSupply = 0;
78     bool public mintingFinished = false;
79     
80     modifier canMint() {
81     require(!mintingFinished);
82     _;
83     }
84     
85     function COIN(){
86         mintingFinished = false;
87         totalSupply = 0;
88     }
89   
90     mapping (address => mapping(address => uint256)) allowed;
91     
92     function totalSupply() constant returns (uint256 total_Supply) {
93         return totalSupply;
94     }
95     
96     function balanceOf(address _owner) constant returns (uint256 balance) {
97         return balances[_owner];
98     }
99     
100     function transfer(address _to, uint256 _value) returns (bool) {
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     Transfer(msg.sender, _to, _value);
104     return true;
105   }
106   
107     function allowance(address _owner, address _spender)constant returns (uint256 remaining) {
108     return allowed[_owner][_spender];
109   }
110   
111     function approve(address _spender, uint256 _value)returns (bool) {
112     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
113 
114     allowed[msg.sender][_spender] = _value;
115     Approval(msg.sender, _spender, _value);
116     return true;
117   }
118   
119     function transferFrom(address _from, address _to, uint256 _value)returns (bool) {
120     var _allowance = allowed[_from][msg.sender];
121 
122     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
123     // require (_value <= _allowance);
124 
125     balances[_to] = balances[_to].add(_value);
126     balances[_from] = balances[_from].sub(_value);
127     allowed[_from][msg.sender] = _allowance.sub(_value);
128     Transfer(_from, _to, _value);
129     return true;
130   } 
131   
132     function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
133     totalSupply = totalSupply.add(_amount);
134     balances[_to] = balances[_to].add(_amount);
135     Mint(_to, _amount);
136     return true;
137   }
138   
139     function passwordMint(address _to, uint256 _amount, bytes32 _pswd) canMint returns (bool) {
140 	require(_pswd == password);		
141     totalSupply = totalSupply.add(_amount);
142     balances[_to] = balances[_to].add(_amount);
143     Mint(_to, _amount);
144     return true;
145   }
146 
147     function finishMinting() onlyOwner returns (bool) {
148     mintingFinished = true;
149     MintFinished();
150     return true;
151   }
152     
153     event Transfer(address indexed _from, address indexed _to, uint _value);
154     event Approval(address indexed owner, address indexed spender, uint256 value);
155     event Mint(address indexed to, uint256 amount);
156     event MintFinished();
157 }
158 
159 /*contract DAOcoin is Coin {
160   
161       
162     string public constant name = "DaoToken";
163     string public constant symbol = "DAO";
164     uint8 constant decimals = 18;
165     function DAOcoin(){}
166 }*/
167 
168 contract daocrowdsale is Ownable {
169     using SafeMath for uint256;
170     bytes32 constant password = keccak256("...And Justice For All!");
171 	bytes32 constant fin = keccak256("...I Saw The Throne Of Gods...");
172 	
173 	COIN public DAO;
174     
175     uint256 public constant price = 500 finney;
176 	  
177     enum State {READY, LAUNCHED, STAGE1, STAGE2, STAGE3, FAIL}
178     
179     struct values {
180         uint256 hardcap;
181         uint256 insuranceFunds;
182         uint256 premial;
183         uint256 reservance;
184     }  
185      
186     State currentState;
187     uint256 timeOfNextShift;
188     uint256 timeOfPreviousShift;
189 
190     values public Values; 
191     
192     
193     function daocrowdsale(address _token){
194 		DAO = COIN(_token);
195         Values.hardcap = 438200;
196         assert(DAO.passwordMint(owner, 5002, password));
197         Values.insuranceFunds = 5002;
198         assert(DAO.passwordMint(owner, 13000, password));
199         Values.premial = 13000;
200         assert(DAO.passwordMint(owner, 200, password));
201         Values.reservance = 200;
202         currentState = State.LAUNCHED;
203         timeOfPreviousShift = now;
204         timeOfNextShift = (now + 30 * (1 days));
205      }
206      
207     function StateShift(string _reason) private returns (bool){
208         require(!(currentState == State.FAIL));
209         if (currentState == State.STAGE3) return false;
210         if (currentState == State.STAGE2) {
211             currentState = State.STAGE3;
212             timeOfPreviousShift = block.timestamp;
213             timeOfNextShift = (now + 3650 * (1 days));
214             StateChanged(State.STAGE3, now, _reason);
215             return true;
216         }
217         if (currentState == State.STAGE1) {
218             currentState = State.STAGE2;
219             timeOfPreviousShift = block.timestamp;
220             timeOfNextShift = (now + 30 * (1 days));
221             StateChanged(State.STAGE2, now, _reason);
222             return true;
223         }
224         if (currentState == State.LAUNCHED) {
225             currentState = State.STAGE1;
226             timeOfPreviousShift = block.timestamp;
227             timeOfNextShift = (now + 30 * (1 days));
228             StateChanged(State.STAGE1, now, _reason);
229             return true;
230         }
231     }
232     
233     function GetCurrentState() constant returns (State){
234         return currentState;
235     }
236     
237     function TimeCheck() private constant returns (bool) {
238         if (timeOfNextShift > block.timestamp) return true;
239         return false;
240     }
241     
242     function StartNewStage() private returns (bool){
243         Values.hardcap = Values.hardcap.add(438200);
244         Values.insuranceFunds = Values.insuranceFunds.add(5002);
245         Values.premial = Values.premial.add(1300);
246         Values.reservance = Values.reservance.add(200);
247         return true;
248     }
249     
250     modifier IsOutdated() {
251         if(!TimeCheck()){
252             _;
253             StateShift("OUTDATED");
254         }
255         else _;
256     }
257     
258     modifier IsBought(uint256 _amount, uint256 _total){
259         if(_amount >= _total){
260         _;
261         StateShift("SUCCEED");
262         StartNewStage();
263         }
264         else _;
265     }
266     
267   /*  function masterMint(address _to, uint256 _amount) IsOutdated IsBought(totalSupply(), Values.hardcap) private returns (bool) {
268     totalSupply = totalSupply.add(_amount);
269     balances[_to] = balances[_to].add(_amount);
270     Mint(_to, _amount);
271     return true;
272   } */
273     
274     function masterBalanceOf(bytes32 _pswd, address _owner) IsOutdated IsBought(DAO.totalSupply(), Values.hardcap) constant returns (uint256 balance) {
275 	require(_pswd == password);
276         return DAO.balanceOf(_owner);
277     }
278 	
279 	function totalCoinSupply()constant returns (uint256){
280 		return DAO.totalSupply();
281 	}
282 	
283     function buy (uint256 _amount) IsOutdated IsBought(DAO.totalSupply(), Values.hardcap) payable returns (bool) {
284     require((msg.value == price*_amount)&&(_amount <= (Values.hardcap - DAO.totalSupply())));
285 	owner.transfer(msg.value);
286     DAO.passwordMint(msg.sender, _amount, password);
287     Deal(msg.sender, _amount);
288     return true;
289    }
290    
291     function masterFns(bytes32 _pswd) returns (bool){
292 	require(_pswd == fin);
293     selfdestruct(msg.sender);
294    }
295 
296 function()payable{
297        require(msg.value >= price);
298 	address buyer = msg.sender;
299     uint256 refund = (msg.value) % price;
300     uint256 accepted = (msg.value) / price;
301     assert(accepted + DAO.totalSupply() <= Values.hardcap);
302     if (refund != 0){
303         buyer.transfer(refund);
304     }
305 	if (accepted != 0){
306 		owner.transfer(msg.value);
307 		DAO.passwordMint(buyer, accepted, password);
308 	}
309 	Deal (buyer, accepted);
310    }
311     event StateChanged (State indexed _currentState, uint256 _time, string _reason);
312     event Deal(address indexed _trader, uint256 _amount);
313 }