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
82 contract CGE is ERC20,Ownable{
83 	using SafeMath for uint256;
84 
85 	//the base info of the token
86 	string public constant name="CoinGold Exchange Of Taiwan";
87 	string public constant symbol="CGE";
88 	string public constant version = "1.0";
89 	uint256 public constant decimals = 18;
90 
91 	uint256 public constant MAX_SUPPLY=1000000000*10**decimals;
92 
93     struct epoch  {
94         uint256 endTime;
95         uint256 amount;
96     }
97 
98 	mapping(address=>epoch[]) public lockEpochsMap;
99 
100 
101 	 
102     mapping(address => uint256) balances;
103 	mapping (address => mapping (address => uint256)) allowed;
104 	
105 
106 	function CGE(){
107 		totalSupply = MAX_SUPPLY;
108 		balances[msg.sender] = MAX_SUPPLY;
109 		Transfer(0x0, msg.sender, MAX_SUPPLY);
110 	}
111 
112 
113 
114 	function () payable external
115 	{
116 	}
117 
118 	function etherProceeds() external
119 		onlyOwner
120 
121 	{
122 		if(!msg.sender.send(this.balance)) revert();
123 	}
124 
125 	function lockBalance(address user, uint256 amount,uint256 endTime) external
126 		onlyOwner
127 	{
128 		 epoch[] storage epochs = lockEpochsMap[user];
129 		 epochs.push(epoch(endTime,amount));
130 	}
131 
132 
133 
134 
135   	function transfer(address _to, uint256 _value) public  returns (bool)
136  	{
137 		require(_to != address(0));
138 		epoch[] epochs = lockEpochsMap[msg.sender];
139 		uint256 needLockBalance = 0;
140 		for(uint256 i=0;i<epochs.length;i++)
141 		{
142 			if( now < epochs[i].endTime )
143 			{
144 				needLockBalance=needLockBalance.add(epochs[i].amount);
145 			}
146 		}
147 
148 		require(balances[msg.sender].sub(_value)>=needLockBalance);
149 		// SafeMath.sub will throw if there is not enough balance.
150 		balances[msg.sender] = balances[msg.sender].sub(_value);
151 		balances[_to] = balances[_to].add(_value);
152 		Transfer(msg.sender, _to, _value);
153 		return true;
154   	}
155 
156   	function balanceOf(address _owner) public constant returns (uint256 balance) 
157   	{
158 		return balances[_owner];
159   	}
160 
161 
162   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
163   	{
164 		require(_to != address(0));
165 
166 		epoch[] epochs = lockEpochsMap[_from];
167 		uint256 needLockBalance = 0;
168 		for(uint256 i=0;i<epochs.length;i++)
169 		{
170 			if( now < epochs[i].endTime )
171 			{
172 				needLockBalance = needLockBalance.add(epochs[i].amount);
173 			}
174 		}
175 
176 		require(balances[_from].sub(_value)>=needLockBalance);
177 		uint256 _allowance = allowed[_from][msg.sender];
178 
179 		balances[_from] = balances[_from].sub(_value);
180 		balances[_to] = balances[_to].add(_value);
181 		allowed[_from][msg.sender] = _allowance.sub(_value);
182 		Transfer(_from, _to, _value);
183 		return true;
184   	}
185 
186   	function approve(address _spender, uint256 _value) public returns (bool) 
187   	{
188 		allowed[msg.sender][_spender] = _value;
189 		Approval(msg.sender, _spender, _value);
190 		return true;
191   	}
192 
193   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
194   	{
195 		return allowed[_owner][_spender];
196   	}
197 
198 	  
199 }