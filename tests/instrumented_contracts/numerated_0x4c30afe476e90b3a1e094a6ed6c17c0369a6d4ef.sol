1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract Owned {
51 	address private Owner;
52 	
53 	function Owned() public{
54 	    
55 	    Owner = msg.sender;
56 	}
57     
58 	function IsOwner(address addr) view public returns(bool)
59 	{
60 	    return Owner == addr;
61 	}
62 	
63 	function TransferOwner(address newOwner) public onlyOwner
64 	{
65 	    Owner = newOwner;
66 	}
67 	
68 	function Terminate() public onlyOwner
69 	{
70 	    selfdestruct(Owner);
71 	}
72 	
73 	modifier onlyOwner(){
74         require(msg.sender == Owner);
75         _;
76     }
77 }
78 
79 contract EBCoin is Owned {
80     using SafeMath for uint256;
81     string public constant name = "EBCoin";
82     string public constant symbol = "EB";
83     uint256 public constant decimals = 18;  // 18 is the most common number of decimal places
84     bool private tradeable;
85     uint256 private currentSupply;
86     mapping(address => uint256) private balances;
87     mapping(address => mapping(address=> uint256)) private allowed;
88     mapping(address => bool) private lockedAccounts;  
89 	
90 	/*
91 		Incoming Ether
92 	*/	
93     event ReceivedEth(address indexed _from, uint256 _value);
94 	//this is the fallback
95 	function () payable public {
96 		emit ReceivedEth(msg.sender, msg.value);		
97 	}
98 	
99 	event TransferredEth(address indexed _to, uint256 _value);
100 	function FoundationTransfer(address _to, uint256 amtEth, uint256 amtToken) public onlyOwner
101 	{
102 		require(address(this).balance >= amtEth && balances[this] >= amtToken );
103 		
104 		if(amtEth >0)
105 		{
106 			_to.transfer(amtEth);
107 			emit TransferredEth(_to, amtEth);
108 		}
109 		
110 		if(amtToken > 0)
111 		{
112 			require(balances[_to] + amtToken > balances[_to]);
113 			balances[this] -= amtToken;
114 			balances[_to] += amtToken;
115 			emit Transfer(this, _to, amtToken);
116 		}
117 		
118 		
119 	}	
120 	/*
121 		End Incoming Ether
122 	*/
123 	
124 	
125 	
126     function EB( ) public
127     {
128         uint256 initialTotalSupply = 400000000;
129         balances[this] = initialTotalSupply * (10**decimals);
130         
131         currentSupply =  initialTotalSupply * (10**decimals);
132 	    emit Transfer(address(0), this, currentSupply);
133         
134     }
135   
136 	uint256 constant startTime = 1554714420; // Date.UTC(2019, 04, 08) as seconds
137 	uint256 constant startAmt = 40000000;
138 	uint256 _lastDayPaid = 0;
139 	uint256 _currentMonth = 0;
140 	uint256 factor = 10000000;
141 	
142     event DayMinted(uint256 day,uint256 val, uint256 now);
143     function DailyMint() public {
144         uint256 day = (now-startTime)/(60*60*24);
145         require(startTime <= now);
146         require(day >= _lastDayPaid);
147         uint256 month = _lastDayPaid/30;
148         if(month > _currentMonth){
149             _currentMonth += 1;
150             factor = (factor * 99)/100;
151         }
152         uint256 todaysPayout = (((factor * startAmt )/10000000)/30)* (10**decimals);
153         balances[this] +=todaysPayout;
154         currentSupply += todaysPayout;
155         emit Transfer(address(0), this, todaysPayout);
156         emit DayMinted(_lastDayPaid, todaysPayout, now);
157         _lastDayPaid+=1;
158 	
159     }
160     function lastDayPaid() public view returns(uint256){
161         return _lastDayPaid;
162     }
163     
164 
165     
166     
167 	function MintToken(uint256 amt) public onlyOwner {
168 	    currentSupply += amt;
169 	    balances[this] += amt;
170 	    emit Transfer(address(0), this, amt);
171 	}
172 	
173 	function DestroyToken(uint256 amt) public onlyOwner {
174 	    require ( balances[this] >= amt);
175 	    currentSupply -= amt;
176 	    balances[this] -= amt;
177 	    emit Transfer(this,address(0), amt);
178 	}
179 	
180 	
181 	
182     event SoldToken(address _buyer, uint256 _value, string note);
183     function BuyToken(address _buyer, uint256 _value, string note) public onlyOwner
184     {
185 		require(balances[this] >= _value && balances[_buyer] + _value > balances[_buyer]);
186 		
187         emit SoldToken( _buyer,  _value,  note);
188         balances[this] -= _value;
189         balances[_buyer] += _value;
190         emit Transfer(this, _buyer, _value);
191     }
192     
193     function LockAccount(address toLock) public onlyOwner
194     {
195         lockedAccounts[toLock] = true;
196     }
197     function UnlockAccount(address toUnlock) public onlyOwner
198     {
199         delete lockedAccounts[toUnlock];
200     }
201     
202     function SetTradeable(bool t) public onlyOwner
203     {
204         tradeable = t;
205     }
206     function IsTradeable() public view returns(bool)
207     {
208         return tradeable;
209     }
210     
211     
212     function totalSupply() constant public returns (uint256)
213     {
214         return currentSupply;
215     }
216     function balanceOf(address _owner) constant public returns (uint256 balance)
217     {
218         return balances[_owner];
219     }
220     function transfer(address _to, uint256 _value) public notLocked returns (bool success) {
221         require(tradeable);
222          if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
223              emit Transfer( msg.sender, _to,  _value);
224              balances[msg.sender] -= _value;
225              balances[_to] += _value;
226              return true;
227          } else {
228              return false;
229          }
230      }
231     function transferFrom(address _from, address _to, uint _value)public notLocked returns (bool success) {
232         require(!lockedAccounts[_from] && !lockedAccounts[_to]);
233 		require(tradeable);
234         if (balances[_from] >= _value
235             && allowed[_from][msg.sender] >= _value
236             && balances[_to] + _value > balances[_to]) {
237                 
238             emit Transfer( _from, _to,  _value);
239                 
240             balances[_from] -= _value;
241             allowed[_from][msg.sender] -= _value;
242             balances[_to] += _value;
243             return true;
244         } else {
245             return false;
246         }
247     }
248     
249      /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    *
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     emit Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(address _owner, address _spender) public view returns (uint256) {
272     return allowed[_owner][_spender];
273   }
274 
275   /**
276    * @dev Increase the amount of tokens that an owner allowed to a spender.
277    *
278    * approve should be called when allowed[_spender] == 0. To increment
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _addedValue The amount of tokens to increase the allowance by.
284    */
285   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
286     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
287     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291   /**
292    * @dev Decrease the amount of tokens that an owner allowed to a spender.
293    *
294    * approve should be called when allowed[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
302     uint oldValue = allowed[msg.sender][_spender];
303     if (_subtractedValue > oldValue) {
304       allowed[msg.sender][_spender] = 0;
305     } else {
306       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
307     }
308     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311     event Transfer(address indexed _from, address indexed _to, uint _value);
312     event Approval(address indexed _owner, address indexed _spender, uint _value);
313    
314    modifier notLocked(){
315        require (!lockedAccounts[msg.sender]);
316        _;
317    }
318 }