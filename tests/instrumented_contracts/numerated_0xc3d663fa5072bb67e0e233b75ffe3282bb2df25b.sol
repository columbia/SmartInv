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
110 contract BoLuoPay is ERC20,Ownable{
111 	using SafeMath for uint256;
112 
113 	string public name="BoLuoPay";
114 	string public symbol="boluo";
115 	string public constant version = "1.0";
116 	uint256 public constant decimals = 18;
117 	//总已经发行量
118 	uint256 public totalSupply;
119 	//已经空投量
120 	uint256 public airdropSupply;
121 	//已经直投量
122 	uint256 public directSellSupply;
123 	uint256 public directSellRate;
124 
125 	uint256 public  MAX_SUPPLY;
126 
127 	
128     mapping(address => uint256) balances;
129 	mapping (address => mapping (address => uint256)) allowed;
130     event Wasted(address to, uint256 value, uint256 date);
131 
132 	function BoLuoPay(){
133 		name = "BoLuoPay";
134 		symbol = "boluo";
135 		totalSupply = 0;
136 		airdropSupply = 0;
137 		directSellSupply = 0;
138 		directSellRate = 9000;
139 		MAX_SUPPLY = 90000000000000000000000000;
140 	}
141 
142 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
143 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
144 		_;
145 	}
146 
147 
148 	function addIssue(uint256 _supply) external
149 		onlyOwner
150 	{
151 		MAX_SUPPLY = MAX_SUPPLY.add(_supply);
152 	}
153 
154 	/**
155 	 * 更新直投参数
156 	 */
157 	function refreshDirectSellParameter(uint256 _directSellRate) external
158 		onlyOwner
159 	{
160 		directSellRate = _directSellRate;
161 	}
162 
163 	//提取代币，用于代投
164     function withdrawCoinToOwner(uint256 _value) external
165 		onlyOwner
166 	{
167 		processFunding(msg.sender,_value,1);
168 	}
169 
170 	//空投
171     function airdrop(address [] _holders,uint256 paySize) external
172     	onlyOwner 
173 	{
174         uint256 count = _holders.length;
175         assert(paySize.mul(count) <= balanceOf(msg.sender));
176         for (uint256 i = 0; i < count; i++) {
177             transfer(_holders [i], paySize);
178 			airdropSupply = airdropSupply.add(paySize);
179         }
180         Wasted(owner, airdropSupply, now);
181     }
182 
183 	//直投
184 	function () payable external
185 	{
186 		processFunding(msg.sender,msg.value,directSellRate);
187 		uint256 amount = msg.value.mul(directSellRate);
188 		directSellSupply = directSellSupply.add(amount);		
189 	}
190 
191 
192 	//代币分发函数，内部使用
193 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
194 		notReachTotalSupply(_value,_rate)
195 	{
196 		uint256 amount=_value.mul(_rate);
197 		totalSupply=totalSupply.add(amount);
198 		balances[receiver] +=amount;
199 		Transfer(0x0, receiver, amount);
200 	}
201 
202 	//提取直投eth
203 	function etherProceeds() external
204 		onlyOwner
205 	{
206 		if(!msg.sender.send(this.balance)) revert();
207 	}
208 
209   	function transfer(address _to, uint256 _value) public  returns (bool)
210  	{
211 		require(_to != address(0));
212 		// SafeMath.sub will throw if there is not enough balance.
213 		balances[msg.sender] = balances[msg.sender].sub(_value);
214 		balances[_to] = balances[_to].add(_value);
215 		Transfer(msg.sender, _to, _value);
216 		return true;
217   	}
218 
219   	function balanceOf(address _owner) public constant returns (uint256 balance) 
220   	{
221 		return balances[_owner];
222   	}
223 
224   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
225   	{
226 		require(_to != address(0));
227 		uint256 _allowance = allowed[_from][msg.sender];
228 
229 		balances[_from] = balances[_from].sub(_value);
230 		balances[_to] = balances[_to].add(_value);
231 		allowed[_from][msg.sender] = _allowance.sub(_value);
232 		Transfer(_from, _to, _value);
233 		return true;
234   	}
235 
236   	function approve(address _spender, uint256 _value) public returns (bool) 
237   	{
238 		allowed[msg.sender][_spender] = _value;
239 		Approval(msg.sender, _spender, _value);
240 		return true;
241   	}
242 
243   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
244   	{
245 		return allowed[_owner][_spender];
246   	}
247 
248 }