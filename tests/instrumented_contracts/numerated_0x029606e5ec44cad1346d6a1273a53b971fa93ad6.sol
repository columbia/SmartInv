1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 contract Owned {
52 	address private Owner;
53 	
54 	function Owned() public{
55 	    
56 	    Owner = msg.sender;
57 	}
58     
59 	function IsOwner(address addr) view public returns(bool)
60 	{
61 	    return Owner == addr;
62 	}
63 	
64 	function TransferOwner(address newOwner) public onlyOwner
65 	{
66 	    Owner = newOwner;
67 	}
68 	
69 	function Terminate() public onlyOwner
70 	{
71 	    selfdestruct(Owner);
72 	}
73 	
74 	modifier onlyOwner(){
75         require(msg.sender == Owner);
76         _;
77     }
78 }
79 
80 contract EMPRO is Owned {
81     using SafeMath for uint256;
82     string public constant name = "empowr orange";
83     string public constant symbol = "EMPRO";
84     uint256 public constant decimals = 18;  // 18 is the most common number of decimal places
85     bool private tradeable;
86     uint256 private currentSupply;
87     mapping(address => uint256) private balances;
88     mapping(address => mapping(address=> uint256)) private allowed;
89     mapping(address => bool) private lockedAccounts;  
90 	
91 	/*
92 		Incoming Ether
93 	*/	
94     event ReceivedEth(address indexed _from, uint256 _value);
95 	//this is the fallback
96 	function () payable public {
97 		emit ReceivedEth(msg.sender, msg.value);		
98 	}
99 	
100 	event TransferredEth(address indexed _to, uint256 _value);
101 	function FoundationTransfer(address _to, uint256 amtEth, uint256 amtToken) public onlyOwner
102 	{
103 		require(address(this).balance >= amtEth && balances[this] >= amtToken );
104 		
105 		if(amtEth >0)
106 		{
107 			_to.transfer(amtEth);
108 			emit TransferredEth(_to, amtEth);
109 		}
110 		
111 		if(amtToken > 0)
112 		{
113 			require(balances[_to] + amtToken > balances[_to]);
114 			balances[this] -= amtToken;
115 			balances[_to] += amtToken;
116 			emit Transfer(this, _to, amtToken);
117 		}
118 		
119 		
120 	}	
121 	/*
122 		End Incoming Ether
123 	*/
124 	
125 	
126 	
127     function EMPRO( ) public
128     {
129         uint256 initialTotalSupply = 10;
130         balances[this] = initialTotalSupply * (10**decimals);
131         
132         currentSupply =  initialTotalSupply * (10**decimals);
133 	    emit Transfer(address(0), this, currentSupply);
134         
135     }
136 
137 	function MintToken(uint256 amt) public onlyOwner {
138 	    require(balances[this] + amt >= balances[this]);
139 	    currentSupply += amt;
140 	    balances[this] += amt;
141 	    emit Transfer(address(0), this, amt);
142 	}
143 	
144 	function DestroyToken(uint256 amt) public onlyOwner {
145 	    require ( balances[this] >= amt);
146 	    currentSupply -= amt;
147 	    balances[this] -= amt;
148 	    emit Transfer(this,address(0), amt);
149 	}
150 	
151 	
152 	
153     event SoldToken(address _buyer, uint256 _value, string note);
154     function BuyToken(address _buyer, uint256 _value, string note) public onlyOwner
155     {
156 		require(balances[this] >= _value && balances[_buyer] + _value > balances[_buyer]);
157 		
158         emit SoldToken( _buyer,  _value,  note);
159         balances[this] -= _value;
160         balances[_buyer] += _value;
161         emit Transfer(this, _buyer, _value);
162     }
163     
164     function LockAccount(address toLock) public onlyOwner
165     {
166         lockedAccounts[toLock] = true;
167     }
168     function UnlockAccount(address toUnlock) public onlyOwner
169     {
170         delete lockedAccounts[toUnlock];
171     }
172     
173     function SetTradeable(bool t) public onlyOwner
174     {
175         tradeable = t;
176     }
177     function IsTradeable() public view returns(bool)
178     {
179         return tradeable;
180     }
181     
182     
183     function totalSupply() constant public returns (uint256)
184     {
185         return currentSupply;
186     }
187     function balanceOf(address _owner) constant public returns (uint256 balance)
188     {
189         return balances[_owner];
190     }
191     function transfer(address _to, uint256 _value) public notLocked returns (bool success) {
192         require(tradeable);
193          if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
194              emit Transfer( msg.sender, _to,  _value);
195              balances[msg.sender] -= _value;
196              balances[_to] += _value;
197              return true;
198          } else {
199              return false;
200          }
201      }
202     function transferFrom(address _from, address _to, uint _value)public notLocked returns (bool success) {
203         require(!lockedAccounts[_from] && !lockedAccounts[_to]);
204 		require(tradeable);
205         if (balances[_from] >= _value
206             && allowed[_from][msg.sender] >= _value
207             && balances[_to] + _value > balances[_to]) {
208                 
209             emit Transfer( _from, _to,  _value);
210                 
211             balances[_from] -= _value;
212             allowed[_from][msg.sender] -= _value;
213             balances[_to] += _value;
214             return true;
215         } else {
216             return false;
217         }
218     }
219     
220      /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    *
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     emit Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(address _owner, address _spender) public view returns (uint256) {
243     return allowed[_owner][_spender];
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To increment
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _addedValue The amount of tokens to increase the allowance by.
255    */
256   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
257     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
258     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262   /**
263    * @dev Decrease the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To decrement
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _subtractedValue The amount of tokens to decrease the allowance by.
271    */
272   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
273     uint oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue > oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282     event Transfer(address indexed _from, address indexed _to, uint _value);
283     event Approval(address indexed _owner, address indexed _spender, uint _value);
284    
285    modifier notLocked(){
286        require (!lockedAccounts[msg.sender]);
287        _;
288    }
289 }