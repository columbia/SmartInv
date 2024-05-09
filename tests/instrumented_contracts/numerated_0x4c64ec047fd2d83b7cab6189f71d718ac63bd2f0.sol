1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36   address public owner;
37 
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     require(newOwner != address(0));
66     OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 
70 }
71 
72 
73 
74 
75 /**
76  * @title SafeMath
77  * @dev Math operations with safety checks that throw on error
78  */
79 library SafeMath {
80   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81     if (a == 0) {
82       return 0;
83     }
84     uint256 c = a * b;
85     assert(c / a == b);
86     return c;
87   }
88 
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return c;
94   }
95 
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   function add(uint256 a, uint256 b) internal pure returns (uint256) {
102     uint256 c = a + b;
103     assert(c >= a);
104     return c;
105   }
106 }
107 
108 
109 
110 contract HLWCOIN is ERC20,Ownable{
111 	using SafeMath for uint256;
112 
113 	//the base info of the token
114 	string public constant name="HLWCOIN";
115 	string public constant symbol="HLW";
116 	string public constant version = "1.0";
117 	uint256 public constant decimals = 18;
118 
119 	uint256 public rate;
120 	uint256 public totalFundingSupply;
121 	//the max supply
122 	uint256 public MAX_SUPPLY;
123 
124 	//user's locked balance
125 	mapping(address=>epoch[]) public lockEpochsMap;
126 
127     mapping(address => uint256) balances;
128 	mapping (address => mapping (address => uint256)) allowed;
129 	struct epoch  {
130         uint256 endTime;
131         uint256 amount;
132     }
133 
134 	function HLWCOIN(){
135 		MAX_SUPPLY = 200000000*10**decimals;
136 		rate = 0;
137 		totalFundingSupply = 0;
138 		totalSupply = 0;
139 	}
140 
141 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
142 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
143 		_;
144 	}
145 
146     function addIssue(uint256 amount) external
147 	    onlyOwner
148     {
149 		MAX_SUPPLY = MAX_SUPPLY.add(amount);
150 	}
151 
152 	function lockBalance(address user, uint256 amount,uint256 endTime) external
153 		onlyOwner
154 	{
155 		 epoch[] storage epochs = lockEpochsMap[user];
156 		 epochs.push(epoch(endTime,amount));
157 	}
158 	
159 	function () payable external
160 	{
161 			processFunding(msg.sender,msg.value,rate);
162 			uint256 amount=msg.value.mul(rate);
163 			totalFundingSupply = totalFundingSupply.add(amount);
164 	}
165 
166 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
167 		notReachTotalSupply(_value,_rate)
168 	{
169 		uint256 amount=_value.mul(_rate);
170 		totalSupply=totalSupply.add(amount);
171 		balances[receiver] +=amount;
172 		Transfer(0x0, receiver, amount);
173 	}
174 
175     function withdrawCoinToOwner(uint256 _value) external
176 		onlyOwner
177 	{
178 		processFunding(msg.sender,_value,1);
179 	}
180 	
181 	function etherProceeds() external
182 		onlyOwner
183 
184 	{
185 		if(!msg.sender.send(this.balance)) revert();
186 	}
187 
188 
189 
190 	function setRate(uint256 _rate) external
191 		onlyOwner
192 	{
193 		rate=_rate;
194 	}
195 
196   	function transfer(address _to, uint256 _value) public  returns (bool)
197  	{
198 		require(_to != address(0));
199 		epoch[] epochs = lockEpochsMap[msg.sender];
200 		uint256 needLockBalance = 0;
201 		for(uint256 i;i<epochs.length;i++)
202 		{
203 			if( now < epochs[i].endTime )
204 			{
205 				needLockBalance=needLockBalance.add(epochs[i].amount);
206 			}
207 		}
208 
209 		require(balances[msg.sender].sub(_value)>=needLockBalance);
210 		// SafeMath.sub will throw if there is not enough balance.
211 		balances[msg.sender] = balances[msg.sender].sub(_value);
212 		balances[_to] = balances[_to].add(_value);
213 		Transfer(msg.sender, _to, _value);
214 		return true;
215   	}
216 
217   	function balanceOf(address _owner) public constant returns (uint256 balance) 
218   	{
219 		return balances[_owner];
220   	}
221 
222 
223   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
224   	{
225 		require(_to != address(0));
226 
227 		epoch[] epochs = lockEpochsMap[_from];
228 		uint256 needLockBalance = 0;
229 		for(uint256 i;i<epochs.length;i++)
230 		{
231 			if( now < epochs[i].endTime )
232 			{
233 				needLockBalance = needLockBalance.add(epochs[i].amount);
234 			}
235 		}
236 
237 		require(balances[_from].sub(_value)>=needLockBalance);
238 		uint256 _allowance = allowed[_from][msg.sender];
239 
240 		balances[_from] = balances[_from].sub(_value);
241 		balances[_to] = balances[_to].add(_value);
242 		allowed[_from][msg.sender] = _allowance.sub(_value);
243 		Transfer(_from, _to, _value);
244 		return true;
245   	}
246 
247   	function approve(address _spender, uint256 _value) public returns (bool) 
248   	{
249 		allowed[msg.sender][_spender] = _value;
250 		Approval(msg.sender, _spender, _value);
251 		return true;
252   	}
253 
254   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
255   	{
256 		return allowed[_owner][_spender];
257   	}
258 
259 	  
260 }