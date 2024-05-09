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
83 contract FOMO is ERC20,Ownable{
84 	using SafeMath for uint256;
85 
86 	//the base info of the token
87 	string public constant name="FOMO";
88 	string public constant symbol="FMC";
89 	string public constant version = "1.0";
90 	uint256 public constant decimals = 18;
91     uint256 public airdropSupply;
92     
93     address public admin;
94 
95 	uint256 public MAX_SUPPLY=20000000*10**decimals;
96 
97 
98     struct epoch  {
99         uint256 endTime;
100         uint256 amount;
101     }
102 
103 
104 	mapping(address=>epoch[]) public lockEpochsMap;
105 
106 
107     mapping(address => uint256) balances;
108 	mapping (address => mapping (address => uint256)) allowed;
109 	
110 
111 	function FOMO(){
112         airdropSupply=0;
113 		totalSupply = MAX_SUPPLY;
114 		balances[msg.sender] = MAX_SUPPLY;
115 		Transfer(0x0, msg.sender, MAX_SUPPLY);
116 	}
117 
118     function airdrop(address [] _holders,uint256 paySize) external
119     	onlyOwner 
120 	{
121         uint256 count = _holders.length;
122         assert(paySize.mul(count) <= balanceOf(msg.sender));
123         for (uint256 i = 0; i < count; i++) {
124             transfer(_holders [i], paySize);
125 			airdropSupply = airdropSupply.add(paySize);
126         }
127     }
128 
129     function addIssue(uint256 amount) external
130     {
131 		assert(msg.sender == owner||msg.sender == admin);
132 		if(msg.sender == owner){
133 			balances[msg.sender] = balances[msg.sender].add(amount);
134 			MAX_SUPPLY=MAX_SUPPLY.add(amount);
135 			Transfer(0x0, msg.sender, amount);
136 		}else if(msg.sender == admin){
137 			balances[msg.sender] = balances[msg.sender].add(amount);
138 			Transfer(0x0, msg.sender, amount);
139 		}
140 	}
141 
142 
143 	function () payable external
144 	{
145 	}
146 
147 
148 	function etherProceeds() external
149 		onlyOwner
150 
151 	{
152 		if(!msg.sender.send(this.balance)) revert();
153 	}
154 
155 
156 
157 	function lockBalance(address user, uint256 amount,uint256 endTime) external
158 		onlyOwner
159 	{
160 		 epoch[] storage epochs = lockEpochsMap[user];
161 		 epochs.push(epoch(endTime,amount));
162 	}
163 
164 
165   	function transfer(address _to, uint256 _value) public  returns (bool)
166  	{
167 		require(_to != address(0));
168 		//计算锁仓份额
169 		epoch[] epochs = lockEpochsMap[msg.sender];
170 		uint256 needLockBalance = 0;
171 		for(uint256 i;i<epochs.length;i++)
172 		{
173 			if( now < epochs[i].endTime )
174 			{
175 				needLockBalance=needLockBalance.add(epochs[i].amount);
176 			}
177 		}
178 
179 		require(balances[msg.sender].sub(_value)>=needLockBalance);
180 		// SafeMath.sub will throw if there is not enough balance.
181 		balances[msg.sender] = balances[msg.sender].sub(_value);
182 		balances[_to] = balances[_to].add(_value);
183 		Transfer(msg.sender, _to, _value);
184 		return true;
185   	}
186 
187   	function balanceOf(address _owner) public constant returns (uint256 balance) 
188   	{
189 		return balances[_owner];
190   	}
191 
192 
193   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
194   	{
195 		require(_to != address(0));
196 
197 
198 		epoch[] epochs = lockEpochsMap[_from];
199 		uint256 needLockBalance = 0;
200 		for(uint256 i;i<epochs.length;i++)
201 		{
202 			if( now < epochs[i].endTime )
203 			{
204 				needLockBalance = needLockBalance.add(epochs[i].amount);
205 			}
206 		}
207 
208 		require(balances[_from].sub(_value)>=needLockBalance);
209 		uint256 _allowance = allowed[_from][msg.sender];
210 
211 		balances[_from] = balances[_from].sub(_value);
212 		balances[_to] = balances[_to].add(_value);
213 		allowed[_from][msg.sender] = _allowance.sub(_value);
214 		Transfer(_from, _to, _value);
215 		return true;
216   	}
217 
218   	function approve(address _spender, uint256 _value) public returns (bool) 
219   	{
220 		allowed[msg.sender][_spender] = _value;
221 		Approval(msg.sender, _spender, _value);
222 		return true;
223   	}
224 
225   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
226   	{
227 		return allowed[_owner][_spender];
228   	}
229 
230     function setAdmin(address _admin) public onlyOwner{
231         admin=_admin;
232     }
233 	  
234 }