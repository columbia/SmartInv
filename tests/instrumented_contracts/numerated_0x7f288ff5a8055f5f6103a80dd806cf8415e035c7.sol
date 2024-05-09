1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) public constant returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 
19 
20 
21 contract Ownable {
22   address public owner;
23 
24 
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   function Ownable() {
33     owner = msg.sender;
34   }
35 
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) onlyOwner public {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 library SafeMath {
61   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
62     uint256 c = a * b;
63     assert(a == 0 || c / a == b);
64     return c;
65   }
66 
67   function div(uint256 a, uint256 b) internal constant returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return c;
72   }
73 
74   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   function add(uint256 a, uint256 b) internal constant returns (uint256) {
80     uint256 c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 contract CFC is ERC20,Ownable{
86 	using SafeMath for uint256;
87 
88 	//the base info of the token
89 	string public constant name="Chain Finance";
90 	string public constant symbol="CFC";
91 	string public constant version = "1.0";
92 	uint256 public constant decimals = 18;
93 
94 	//初始发行10亿
95 	uint256 public constant MAX_SUPPLY=1000000000*10**decimals;
96 
97 	//期数
98     struct epoch  {
99         uint256 endTime;
100         uint256 amount;
101     }
102 
103 	//各个用户的锁仓金额
104 	mapping(address=>epoch[]) public lockEpochsMap;
105 
106 
107 	 
108 	//ERC20的余额
109     mapping(address => uint256) balances;
110 	mapping (address => mapping (address => uint256)) allowed;
111 	
112 
113 	function CFC(){
114 		totalSupply = MAX_SUPPLY;
115 		balances[msg.sender] = MAX_SUPPLY;
116 		Transfer(0x0, msg.sender, MAX_SUPPLY);
117 	}
118 
119 
120     function addIssue(uint256 amount) external
121 	    onlyOwner
122     {
123 		balances[msg.sender] = balances[msg.sender].add(amount);
124 		Transfer(0x0, msg.sender, amount);
125 	}
126 
127 	//允许用户往合约账户打币
128 	function () payable external
129 	{
130 	}
131 
132 	//owner有权限提取账户中的eth
133 	function etherProceeds() external
134 		onlyOwner
135 
136 	{
137 		if(!msg.sender.send(this.balance)) revert();
138 	}
139 
140 	//设置锁仓
141 	function lockBalance(address user, uint256 amount,uint256 endTime) external
142 		onlyOwner
143 	{
144 		 epoch[] storage epochs = lockEpochsMap[user];
145 		 epochs.push(epoch(endTime,amount));
146 	}
147 
148 
149 
150 
151   //转账前，先校验减去转出份额后，是否大于等于锁仓份额
152   	function transfer(address _to, uint256 _value) public  returns (bool)
153  	{
154 		require(_to != address(0));
155 		//计算锁仓份额
156 		epoch[] epochs = lockEpochsMap[msg.sender];
157 		uint256 needLockBalance = 0;
158 		for(uint256 i;i<epochs.length;i++)
159 		{
160 			//如果当前时间小于当期结束时间,则此期有效
161 			if( now < epochs[i].endTime )
162 			{
163 				needLockBalance=needLockBalance.add(epochs[i].amount);
164 			}
165 		}
166 
167 		require(balances[msg.sender].sub(_value)>=needLockBalance);
168 		// SafeMath.sub will throw if there is not enough balance.
169 		balances[msg.sender] = balances[msg.sender].sub(_value);
170 		balances[_to] = balances[_to].add(_value);
171 		Transfer(msg.sender, _to, _value);
172 		return true;
173   	}
174 
175   	function balanceOf(address _owner) public constant returns (uint256 balance) 
176   	{
177 		return balances[_owner];
178   	}
179 
180 
181   //从委托人账上转出份额时，还要判断委托人的余额-转出份额是否大于等于锁仓份额
182   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
183   	{
184 		require(_to != address(0));
185 
186 		//计算锁仓份额
187 		epoch[] epochs = lockEpochsMap[_from];
188 		uint256 needLockBalance = 0;
189 		for(uint256 i;i<epochs.length;i++)
190 		{
191 			//如果当前时间小于当期结束时间,则此期有效
192 			if( now < epochs[i].endTime )
193 			{
194 				needLockBalance = needLockBalance.add(epochs[i].amount);
195 			}
196 		}
197 
198 		require(balances[_from].sub(_value)>=needLockBalance);
199 		uint256 _allowance = allowed[_from][msg.sender];
200 
201 		balances[_from] = balances[_from].sub(_value);
202 		balances[_to] = balances[_to].add(_value);
203 		allowed[_from][msg.sender] = _allowance.sub(_value);
204 		Transfer(_from, _to, _value);
205 		return true;
206   	}
207 
208   	function approve(address _spender, uint256 _value) public returns (bool) 
209   	{
210 		allowed[msg.sender][_spender] = _value;
211 		Approval(msg.sender, _spender, _value);
212 		return true;
213   	}
214 
215   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
216   	{
217 		return allowed[_owner][_spender];
218   	}
219 
220 	  
221 }