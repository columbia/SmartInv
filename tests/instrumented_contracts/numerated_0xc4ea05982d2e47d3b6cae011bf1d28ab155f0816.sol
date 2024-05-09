1 pragma solidity ^0.4.13;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 library SafeMath {
55   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     if (a == 0) {
57       return 0;
58     }
59     uint256 c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 
84 contract Pausable is Ownable {
85   event Pause();
86   event Unpause();
87 
88   bool public paused = false;
89 
90 
91   /**
92    * @dev Modifier to make a function callable only when the contract is not paused.
93    */
94   modifier whenNotPaused() {
95     require(!paused);
96     _;
97   }
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is paused.
101    */
102   modifier whenPaused() {
103     require(paused);
104     _;
105   }
106 
107   /**
108    * @dev called by the owner to pause, triggers stopped state
109    */
110   function pause() onlyOwner whenNotPaused public {
111     paused = true;
112     Pause();
113   }
114 
115   /**
116    * @dev called by the owner to unpause, returns to normal state
117    */
118   function unpause() onlyOwner whenPaused public {
119     paused = false;
120     Unpause();
121   }
122 }
123 
124 
125 contract QKL is ERC20,Pausable{
126 	using SafeMath for uint256;
127 
128 	string public constant name="QKL";
129 	string public symbol="QKL";
130 	string public constant version = "1.0";
131 	uint256 public constant decimals = 18;
132 	uint256 public totalSupply;
133 
134 	uint256 public constant INIT_SUPPLY=10000000000*10**decimals;
135 
136 	//锁仓期数
137     struct epoch  {
138         uint256 lockEndTime;
139         uint256 lockAmount;
140     }
141 
142     mapping(address=>epoch[]) public lockEpochsMap;
143 
144 	
145     mapping(address => uint256) balances;
146 	mapping (address => mapping (address => uint256)) allowed;
147 	event GetETH(address indexed _from, uint256 _value);
148 	event Burn(address indexed burner, uint256 value);
149 
150 	//owner一次性获取代币
151 	function QKL(){
152 		totalSupply=INIT_SUPPLY;
153 		balances[msg.sender] = INIT_SUPPLY;
154 		Transfer(0x0, msg.sender, INIT_SUPPLY);
155 	}
156     /**
157     *销毁代币,用户只能自己销毁自己的
158      */
159     function burn(uint256 _value) public {
160         require(_value > 0);
161 
162         address burner = msg.sender;
163         balances[burner] = balances[burner].sub(_value);
164         totalSupply = totalSupply.sub(_value);
165         Burn(burner, _value);
166     }
167 
168   	//锁仓接口，可分多期锁仓，多期锁仓金额可累加，这里的锁仓是指限制转账
169 	function lockBalance(address user, uint256 lockAmount,uint256 lockEndTime) external
170 		onlyOwner
171 	{
172 		 epoch[] storage epochs = lockEpochsMap[user];
173 		 epochs.push(epoch(lockEndTime,lockAmount));
174 	}
175 
176 	//允许用户往合约账户打币
177 	function () payable external
178 	{
179 		GetETH(msg.sender,msg.value);
180 	}
181 
182 	function etherProceeds() external
183 		onlyOwner
184 	{
185 		if(!msg.sender.send(this.balance)) revert();
186 	}
187 
188   	function transfer(address _to, uint256 _value) whenNotPaused  public  returns (bool)
189  	{
190 		require(_to != address(0));
191 
192 		//计算锁仓份额
193 		epoch[] epochs = lockEpochsMap[msg.sender];
194 		uint256 needLockBalance = 0;
195 		for(uint256 i = 0;i<epochs.length;i++)
196 		{
197 			//如果当前时间小于当期结束时间,则此期有效
198 			if( now < epochs[i].lockEndTime )
199 			{
200 				needLockBalance=needLockBalance.add(epochs[i].lockAmount);
201 			}
202 		}
203 
204 		require(balances[msg.sender].sub(_value)>=needLockBalance);
205 
206 		// SafeMath.sub will throw if there is not enough balance.
207 		balances[msg.sender] = balances[msg.sender].sub(_value);
208 		balances[_to] = balances[_to].add(_value);
209 		Transfer(msg.sender, _to, _value);
210 		return true;
211   	}
212 
213   	function balanceOf(address _owner) public constant returns (uint256 balance) 
214   	{
215 		return balances[_owner];
216   	}
217 
218   	function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) 
219   	{
220 		require(_to != address(0));
221 
222 		//计算锁仓份额
223 		epoch[] epochs = lockEpochsMap[_from];
224 		uint256 needLockBalance = 0;
225 		for(uint256 i = 0;i<epochs.length;i++)
226 		{
227 			//如果当前时间小于当期结束时间,则此期有效
228 			if( now < epochs[i].lockEndTime )
229 			{
230 				needLockBalance = needLockBalance.add(epochs[i].lockAmount);
231 			}
232 		}
233 
234 		require(balances[_from].sub(_value)>=needLockBalance);
235 
236 		uint256 _allowance = allowed[_from][msg.sender];
237 
238 		balances[_from] = balances[_from].sub(_value);
239 		balances[_to] = balances[_to].add(_value);
240 		allowed[_from][msg.sender] = _allowance.sub(_value);
241 		Transfer(_from, _to, _value);
242 		return true;
243   	}
244 
245   	function approve(address _spender, uint256 _value) public returns (bool) 
246   	{
247 		allowed[msg.sender][_spender] = _value;
248 		Approval(msg.sender, _spender, _value);
249 		return true;
250   	}
251 
252   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
253   	{
254 		return allowed[_owner][_spender];
255   	}
256 
257 	  
258 }