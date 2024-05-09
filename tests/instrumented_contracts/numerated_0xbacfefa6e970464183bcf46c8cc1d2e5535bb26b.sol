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
83 contract TG is ERC20,Ownable{
84 	using SafeMath for uint256;
85 
86 	//the base info of the token
87 	string public constant name="TG CITY";
88 	string public constant symbol="TG";
89 	string public constant version = "1.0";
90 	uint256 public constant decimals = 18;
91     uint256 public airdropSupply;
92 
93 	uint256 public constant MAX_SUPPLY=100000000*10**decimals;
94 
95 
96     struct epoch  {
97         uint256 endTime;
98         uint256 amount;
99     }
100 
101 
102 	mapping(address=>epoch[]) public lockEpochsMap;
103 
104 
105 	 
106     mapping(address => uint256) balances;
107 	mapping (address => mapping (address => uint256)) allowed;
108 	
109 
110 	function TG(){
111         airdropSupply=0;
112 		totalSupply = MAX_SUPPLY;
113 		balances[msg.sender] = MAX_SUPPLY;
114 		Transfer(0x0, msg.sender, MAX_SUPPLY);
115 	}
116 
117     function airdrop(address [] _holders,uint256 paySize) external
118     	onlyOwner 
119 	{
120         uint256 count = _holders.length;
121         assert(paySize.mul(count) <= balanceOf(msg.sender));
122         for (uint256 i = 0; i < count; i++) {
123             transfer(_holders [i], paySize);
124 			airdropSupply = airdropSupply.add(paySize);
125         }
126     }
127 
128     function addIssue(uint256 amount) external
129 	    onlyOwner
130     {
131 		balances[msg.sender] = balances[msg.sender].add(amount);
132 		Transfer(0x0, msg.sender, amount);
133 	}
134 
135 
136 	function () payable external
137 	{
138 	}
139 
140 
141 	function etherProceeds() external
142 		onlyOwner
143 
144 	{
145 		if(!msg.sender.send(this.balance)) revert();
146 	}
147 
148 
149 	function lockBalance(address user, uint256 amount,uint256 endTime) external
150 		onlyOwner
151 	{
152 		 epoch[] storage epochs = lockEpochsMap[user];
153 		 epochs.push(epoch(endTime,amount));
154 	}
155 
156 
157   
158   	function transfer(address _to, uint256 _value) public  returns (bool)
159  	{
160 		require(_to != address(0));
161 
162 		epoch[] epochs = lockEpochsMap[msg.sender];
163 		uint256 needLockBalance = 0;
164 		for(uint256 i;i<epochs.length;i++)
165 		{
166 		
167 			if( now < epochs[i].endTime )
168 			{
169 				needLockBalance=needLockBalance.add(epochs[i].amount);
170 			}
171 		}
172 
173 		require(balances[msg.sender].sub(_value)>=needLockBalance);
174 		// SafeMath.sub will throw if there is not enough balance.
175 		balances[msg.sender] = balances[msg.sender].sub(_value);
176 		balances[_to] = balances[_to].add(_value);
177 		Transfer(msg.sender, _to, _value);
178 		return true;
179   	}
180 
181   	function balanceOf(address _owner) public constant returns (uint256 balance) 
182   	{
183 		return balances[_owner];
184   	}
185 
186 
187   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
188   	{
189 		require(_to != address(0));
190 
191 		epoch[] epochs = lockEpochsMap[_from];
192 		uint256 needLockBalance = 0;
193 		for(uint256 i;i<epochs.length;i++)
194 		{
195 			if( now < epochs[i].endTime )
196 			{
197 				needLockBalance = needLockBalance.add(epochs[i].amount);
198 			}
199 		}
200 
201 		require(balances[_from].sub(_value)>=needLockBalance);
202 		uint256 _allowance = allowed[_from][msg.sender];
203 
204 		balances[_from] = balances[_from].sub(_value);
205 		balances[_to] = balances[_to].add(_value);
206 		allowed[_from][msg.sender] = _allowance.sub(_value);
207 		Transfer(_from, _to, _value);
208 		return true;
209   	}
210 
211   	function approve(address _spender, uint256 _value) public returns (bool) 
212   	{
213 		allowed[msg.sender][_spender] = _value;
214 		Approval(msg.sender, _spender, _value);
215 		return true;
216   	}
217 
218   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
219   	{
220 		return allowed[_owner][_spender];
221   	}
222 
223 	  
224 }