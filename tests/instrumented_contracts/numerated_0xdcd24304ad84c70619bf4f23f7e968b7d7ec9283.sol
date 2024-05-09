1 pragma solidity ^0.4.19;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 contract Owned {
54 	address private Owner;
55 	
56 	function Owned() public{
57 	    
58 	    Owner = msg.sender;
59 	}
60     
61 	function IsOwner(address addr) view public returns(bool)
62 	{
63 	    return Owner == addr;
64 	}
65 	
66 	function TransferOwner(address newOwner) public onlyOwner
67 	{
68 	    Owner = newOwner;
69 	}
70 	
71 	function Terminate() public onlyOwner
72 	{
73 	    selfdestruct(Owner);
74 	}
75 	
76 	modifier onlyOwner(){
77         require(msg.sender == Owner);
78         _;
79     }
80 }
81 
82 contract EB is Owned {
83     using SafeMath for uint256;
84     string public constant name = "e-balance coin (EBCoin)";
85     string public constant symbol = "EB";
86     uint256 public constant decimals = 18;  // 18 is the most common number of decimal places
87     bool private tradeable;
88     uint256 private currentSupply;
89     mapping(address => uint256) private balances;
90     mapping(address => mapping(address=> uint256)) private allowed;
91     mapping(address => bool) private lockedAccounts;  
92 	
93 	/*
94 		Incoming Ether
95 	*/	
96     event ReceivedEth(address indexed _from, uint256 _value);
97 	//this is the fallback
98 	function () payable public {
99 		emit ReceivedEth(msg.sender, msg.value);		
100 	}
101 	
102 	event TransferredEth(address indexed _to, uint256 _value);
103 	function FoundationTransfer(address _to, uint256 amtEth, uint256 amtToken) public onlyOwner
104 	{
105 		require(address(this).balance >= amtEth && balances[this] >= amtToken );
106 		
107 		if(amtEth >0)
108 		{
109 			_to.transfer(amtEth);
110 			emit TransferredEth(_to, amtEth);
111 		}
112 		
113 		if(amtToken > 0)
114 		{
115 			require(balances[_to] + amtToken > balances[_to]);
116 			balances[this] -= amtToken;
117 			balances[_to] += amtToken;
118 			emit Transfer(this, _to, amtToken);
119 		}
120 		
121 		
122 	}	
123 	/*
124 		End Incoming Ether
125 	*/
126 	
127 	
128 	
129     function EB( ) public
130     {
131         uint256 initialTotalSupply = 40000000;
132         balances[this] = initialTotalSupply * (10**decimals);
133         
134         currentSupply =  initialTotalSupply * (10**decimals);
135 	    emit Transfer(address(0), this, currentSupply);
136         
137     }
138   
139 	uint256 constant startTime = 1556928000; // Date.UTC(20198, 5, 4) as seconds
140 	uint256 constant startAmt = 95000000;
141 	uint256 _lastDayPaid = 0;
142 	uint256 _currentMonth = 0;
143 	uint256 factor = 10000000;
144 	
145     event DayMinted(uint256 day,uint256 val, uint256 now);
146     function DailyMint() public {
147         uint256 day = (now-startTime)/(60*60*24);
148         require(startTime <= now);
149         require(day >= _lastDayPaid);
150         uint256 month = _lastDayPaid/30;
151         if(month > _currentMonth){
152             _currentMonth += 1;
153             factor = (factor * 99)/100;
154         }
155         uint256 todaysPayout = (((factor * startAmt )/10000000)/30)* (10**decimals);
156         balances[this] +=todaysPayout;
157         currentSupply += todaysPayout;
158         emit Transfer(address(0), this, todaysPayout);
159         emit DayMinted(_lastDayPaid, todaysPayout, now);
160         _lastDayPaid+=1;
161 	
162     }
163     function lastDayPaid() public view returns(uint256){
164         return _lastDayPaid;
165     }
166     
167 
168     
169     
170 	function MintToken(uint256 amt) public onlyOwner {
171 	    currentSupply += amt;
172 	    balances[this] += amt;
173 	    emit Transfer(address(0), this, amt);
174 	}
175 	
176 	function DestroyToken(uint256 amt) public onlyOwner {
177 	    require ( balances[this] >= amt);
178 	    currentSupply -= amt;
179 	    balances[this] -= amt;
180 	    emit Transfer(this,address(0), amt);
181 	}
182 	
183 	
184 	
185     event SoldToken(address _buyer, uint256 _value, string note);
186     function BuyToken(address _buyer, uint256 _value, string note) public onlyOwner
187     {
188 		require(balances[this] >= _value && balances[_buyer] + _value > balances[_buyer]);
189 		
190         emit SoldToken( _buyer,  _value,  note);
191         balances[this] -= _value;
192         balances[_buyer] += _value;
193         emit Transfer(this, _buyer, _value);
194     }
195     
196     function LockAccount(address toLock) public onlyOwner
197     {
198         lockedAccounts[toLock] = true;
199     }
200     function UnlockAccount(address toUnlock) public onlyOwner
201     {
202         delete lockedAccounts[toUnlock];
203     }
204     
205     function SetTradeable(bool t) public onlyOwner
206     {
207         tradeable = t;
208     }
209     function IsTradeable() public view returns(bool)
210     {
211         return tradeable;
212     }
213     
214     
215     function totalSupply() constant public returns (uint256)
216     {
217         return currentSupply;
218     }
219     function balanceOf(address _owner) constant public returns (uint256 balance)
220     {
221         return balances[_owner];
222     }
223     function transfer(address _to, uint256 _value) public notLocked returns (bool success) {
224         require(tradeable);
225          if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
226              emit Transfer( msg.sender, _to,  _value);
227              balances[msg.sender] -= _value;
228              balances[_to] += _value;
229              return true;
230          } else {
231              return false;
232          }
233      }
234     function transferFrom(address _from, address _to, uint _value)public notLocked returns (bool success) {
235         require(!lockedAccounts[_from] && !lockedAccounts[_to]);
236 		require(tradeable);
237         if (balances[_from] >= _value
238             && allowed[_from][msg.sender] >= _value
239             && balances[_to] + _value > balances[_to]) {
240                 
241             emit Transfer( _from, _to,  _value);
242                 
243             balances[_from] -= _value;
244             allowed[_from][msg.sender] -= _value;
245             balances[_to] += _value;
246             return true;
247         } else {
248             return false;
249         }
250     }
251     
252      /**
253    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
254    *
255    * Beware that changing an allowance with this method brings the risk that someone may use both the old
256    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
257    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
258    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259    * @param _spender The address which will spend the funds.
260    * @param _value The amount of tokens to be spent.
261    */
262   function approve(address _spender, uint256 _value) public returns (bool) {
263     allowed[msg.sender][_spender] = _value;
264     emit Approval(msg.sender, _spender, _value);
265     return true;
266   }
267 
268   /**
269    * @dev Function to check the amount of tokens that an owner allowed to a spender.
270    * @param _owner address The address which owns the funds.
271    * @param _spender address The address which will spend the funds.
272    * @return A uint256 specifying the amount of tokens still available for the spender.
273    */
274   function allowance(address _owner, address _spender) public view returns (uint256) {
275     return allowed[_owner][_spender];
276   }
277 
278   /**
279    * @dev Increase the amount of tokens that an owner allowed to a spender.
280    *
281    * approve should be called when allowed[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
289     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   /**
295    * @dev Decrease the amount of tokens that an owner allowed to a spender.
296    *
297    * approve should be called when allowed[_spender] == 0. To decrement
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    * @param _spender The address which will spend the funds.
302    * @param _subtractedValue The amount of tokens to decrease the allowance by.
303    */
304   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
305     uint oldValue = allowed[msg.sender][_spender];
306     if (_subtractedValue > oldValue) {
307       allowed[msg.sender][_spender] = 0;
308     } else {
309       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
310     }
311     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
312     return true;
313   }
314     event Transfer(address indexed _from, address indexed _to, uint _value);
315     event Approval(address indexed _owner, address indexed _spender, uint _value);
316    
317    modifier notLocked(){
318        require (!lockedAccounts[msg.sender]);
319        _;
320    }
321 }