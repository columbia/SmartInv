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
84 contract QCB is ERC20,Ownable{
85 	using SafeMath for uint256;
86 
87 	//the base info of the token
88 	string public constant name="QINGCUNBI";
89 	string public constant symbol="QCB";
90 	string public constant version = "1.0";
91 	uint256 public constant decimals = 18;
92 
93     mapping(address => uint256) balances;
94 	mapping (address => mapping (address => uint256)) allowed;
95 	uint256 public constant MAX_SUPPLY=21000000*10**decimals;
96 	uint256 public constant INIT_SUPPLY=20990000*10**decimals;
97 
98 	uint256 public constant autoAirdropAmount=1*10**decimals;
99     uint256 public constant MAX_AUTO_AIRDROP_AMOUNT=10000*10**decimals;
100 
101     address private admin;
102 
103 	uint256 public alreadyAutoAirdropAmount;
104 
105 	mapping(address => bool) touched;
106 
107 
108     struct epoch  {
109         uint256 endTime;
110         uint256 amount;
111     }
112 
113 	mapping(address=>epoch[]) public lockEpochsMap;
114 
115 
116 
117 	function QCB() public{
118         alreadyAutoAirdropAmount=0;
119 		totalSupply = INIT_SUPPLY;
120 		balances[msg.sender] = INIT_SUPPLY;
121 		emit Transfer(0x0, msg.sender, INIT_SUPPLY);
122 	}
123 
124     function addIssue(uint256 amount) external
125     {
126 		assert(msg.sender == owner||msg.sender == admin);
127 		balances[msg.sender] = balances[msg.sender].add(amount);
128 		Transfer(0x0, msg.sender, amount);
129 	}
130 
131 	function lockBalance(address user, uint256 amount,uint256 endTime) external
132 		onlyOwner
133 	{
134 		 epoch[] storage epochs = lockEpochsMap[user];
135 		 epochs.push(epoch(endTime,amount));
136 	}
137 
138 	function () payable external 
139 	{
140 	}
141 
142 
143 
144 	function etherProceeds() external
145 		onlyOwner
146 
147 	{
148 		if(!msg.sender.send(this.balance)) revert();
149 	}
150 
151   	function transfer(address _to, uint256 _value) public  returns (bool)
152  	{
153 		require(_to != address(0));
154 
155         if( !touched[msg.sender] && totalSupply.add(autoAirdropAmount) <= MAX_SUPPLY &&alreadyAutoAirdropAmount.add(autoAirdropAmount)<=MAX_AUTO_AIRDROP_AMOUNT){
156             touched[msg.sender] = true;
157             balances[msg.sender] = balances[msg.sender].add( autoAirdropAmount );
158             totalSupply = totalSupply.add( autoAirdropAmount );
159             alreadyAutoAirdropAmount=alreadyAutoAirdropAmount.add(autoAirdropAmount);
160 
161         }
162         
163 		epoch[] epochs = lockEpochsMap[msg.sender];
164 		uint256 needLockBalance = 0;
165 		for(uint256 i;i<epochs.length;i++)
166 		{
167 			if( now < epochs[i].endTime )
168 			{
169 				needLockBalance=needLockBalance.add(epochs[i].amount);
170 			}
171 		}
172 
173 		require(balances[msg.sender].sub(_value)>=needLockBalance);
174 
175         require(_value <= balances[msg.sender]);
176 
177 		// SafeMath.sub will throw if there is not enough balance.
178 		balances[msg.sender] = balances[msg.sender].sub(_value);
179 		balances[_to] = balances[_to].add(_value);
180 		emit Transfer(msg.sender, _to, _value);
181 		return true;
182   	}
183 
184   	function balanceOf(address _owner) public constant returns (uint256 balance) 
185   	{
186         if( totalSupply.add(autoAirdropAmount) <= MAX_SUPPLY &&alreadyAutoAirdropAmount.add(autoAirdropAmount)<=MAX_AUTO_AIRDROP_AMOUNT){
187             if( touched[_owner] ){
188                 return balances[_owner];
189             }
190             else{
191                 return balances[_owner].add(autoAirdropAmount);
192             }
193         } else {
194             return balances[_owner];
195         }
196   	}
197 
198   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
199   	{
200 		require(_to != address(0));
201         
202         if( !touched[_from] && totalSupply.add(autoAirdropAmount) <= MAX_SUPPLY &&alreadyAutoAirdropAmount.add(autoAirdropAmount)<=MAX_AUTO_AIRDROP_AMOUNT){
203             touched[_from] = true;
204             balances[_from] = balances[_from].add( autoAirdropAmount );
205             totalSupply = totalSupply.add( autoAirdropAmount );
206             alreadyAutoAirdropAmount=alreadyAutoAirdropAmount.add(autoAirdropAmount);
207         }
208 
209 		epoch[] epochs = lockEpochsMap[_from];
210 		uint256 needLockBalance = 0;
211 		for(uint256 i;i<epochs.length;i++)
212 		{
213 			if( now < epochs[i].endTime )
214 			{
215 				needLockBalance = needLockBalance.add(epochs[i].amount);
216 			}
217 		}
218 
219 		require(balances[_from].sub(_value)>=needLockBalance);  
220 
221         require(_value <= balances[_from]);
222 
223 
224 		uint256 _allowance = allowed[_from][msg.sender];
225 		balances[_from] = balances[_from].sub(_value);
226 		balances[_to] = balances[_to].add(_value);
227 		allowed[_from][msg.sender] = _allowance.sub(_value);
228 		emit Transfer(_from, _to, _value);
229 		return true;
230   	}
231 
232   	function approve(address _spender, uint256 _value) public returns (bool) 
233   	{
234 		allowed[msg.sender][_spender] = _value;
235 		emit Approval(msg.sender, _spender, _value);
236 		return true;
237   	}
238 
239   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
240   	{
241 		return allowed[_owner][_spender];
242   	}
243       
244     function setAdmin(address _admin) public onlyOwner{
245         admin=_admin;
246     }
247 	  
248 }