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
84 contract JCB is ERC20,Ownable{
85 	using SafeMath for uint256;
86 
87 	//the base info of the token
88 	string public constant name="JIUCAIBI";
89 	string public constant symbol="JCB";
90 	string public constant version = "1.0";
91 	uint256 public constant decimals = 18;
92 
93     mapping(address => uint256) balances;
94 	mapping (address => mapping (address => uint256)) allowed;
95 	uint256 public constant MAX_SUPPLY=100000000*10**decimals;
96 	uint256 public constant INIT_SUPPLY=50000000*10**decimals;
97 
98 	uint256 public constant autoAirdropAmount=10*10**decimals;
99     uint256 public constant MAX_AUTO_AIRDROP_AMOUNT=10000*10**decimals;
100 
101     uint256 public constant MAX_FUNDING_SUPPLY=49990000*10**decimals;
102 
103 	uint256 public totalFundingSupply;
104     //rate
105     uint256 public rate=1;
106 
107 
108 	uint256 public alreadyAutoAirdropAmount;
109 
110 	mapping(address => bool) touched;
111 
112 
113     struct epoch  {
114         uint256 endTime;
115         uint256 amount;
116     }
117 
118 	mapping(address=>epoch[]) public lockEpochsMap;
119 
120 
121 
122 	function JCB()public{
123         totalFundingSupply=0;
124         alreadyAutoAirdropAmount=0;
125 		totalSupply = INIT_SUPPLY;
126 		balances[msg.sender] = INIT_SUPPLY;
127 		Transfer(0x0, msg.sender, INIT_SUPPLY);
128 	}
129 
130 	modifier totalSupplyNotReached(uint256 _ethContribution,uint rate){
131 		assert(totalSupply.add(_ethContribution.mul(rate)) <= MAX_SUPPLY);
132 		_;
133 	}
134 
135 	modifier notReachFundingSupply(uint256 _value,uint256 _rate){
136 		assert(MAX_FUNDING_SUPPLY>=totalFundingSupply.add(_value.mul(_rate)));
137 		_;
138 	}
139 
140 	function lockBalance(address user, uint256 amount,uint256 endTime) external
141 		onlyOwner
142 	{
143 		 epoch[] storage epochs = lockEpochsMap[user];
144 		 epochs.push(epoch(endTime,amount));
145 	}
146 
147 	function () payable external
148         notReachFundingSupply(msg.value,rate)
149 	{
150 		processFunding(msg.sender,msg.value,rate);
151 		uint256 amount=msg.value.mul(rate);
152 		totalFundingSupply = totalFundingSupply.add(amount);
153 	}
154 
155     function withdrawCoin(uint256 _value)external
156         onlyOwner
157         notReachFundingSupply(_value,1)
158     {
159         processFunding(msg.sender,_value,1);
160 		uint256 amount=_value;
161 		totalFundingSupply = totalFundingSupply.add(amount);
162     }
163 
164 	function etherProceeds() external
165 		onlyOwner
166 
167 	{
168 		if(!msg.sender.send(this.balance)) revert();
169 	}
170 
171 	function processFunding(address receiver,uint256 _value,uint256 fundingRate) internal
172 		totalSupplyNotReached(_value,fundingRate)
173 
174 	{
175 		uint256 tokenAmount = _value.mul(fundingRate);
176 		totalSupply=totalSupply.add(tokenAmount);
177 		balances[receiver] += tokenAmount;  // safeAdd not needed; bad semantics to use here
178 		Transfer(0x0, receiver, tokenAmount);
179 	}
180 
181   	function transfer(address _to, uint256 _value) public  returns (bool)
182  	{
183 		require(_to != address(0));
184 
185         if( !touched[msg.sender] && totalSupply.add(autoAirdropAmount) <= MAX_SUPPLY &&alreadyAutoAirdropAmount.add(autoAirdropAmount)<=MAX_AUTO_AIRDROP_AMOUNT){
186             touched[msg.sender] = true;
187             balances[msg.sender] = balances[msg.sender].add( autoAirdropAmount );
188             totalSupply = totalSupply.add( autoAirdropAmount );
189             alreadyAutoAirdropAmount=alreadyAutoAirdropAmount.add(autoAirdropAmount);
190 
191         }
192         
193 		epoch[] epochs = lockEpochsMap[msg.sender];
194 		uint256 needLockBalance = 0;
195 		for(uint256 i;i<epochs.length;i++)
196 		{
197 			if( now < epochs[i].endTime )
198 			{
199 				needLockBalance=needLockBalance.add(epochs[i].amount);
200 			}
201 		}
202 
203 		require(balances[msg.sender].sub(_value)>=needLockBalance);
204 
205         require(_value <= balances[msg.sender]);
206 
207 		// SafeMath.sub will throw if there is not enough balance.
208 		balances[msg.sender] = balances[msg.sender].sub(_value);
209 		balances[_to] = balances[_to].add(_value);
210 		Transfer(msg.sender, _to, _value);
211 		return true;
212   	}
213 
214   	function balanceOf(address _owner) public constant returns (uint256 balance) 
215   	{
216         if( totalSupply.add(autoAirdropAmount) <= MAX_SUPPLY &&alreadyAutoAirdropAmount.add(autoAirdropAmount)<=MAX_AUTO_AIRDROP_AMOUNT){
217             if( touched[_owner] ){
218                 return balances[_owner];
219             }
220             else{
221                 return balances[_owner].add(autoAirdropAmount);
222             }
223         } else {
224             return balances[_owner];
225         }
226   	}
227 
228   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
229   	{
230 		require(_to != address(0));
231         
232         if( !touched[_from] && totalSupply.add(autoAirdropAmount) <= MAX_SUPPLY &&alreadyAutoAirdropAmount.add(autoAirdropAmount)<=MAX_AUTO_AIRDROP_AMOUNT){
233             touched[_from] = true;
234             balances[_from] = balances[_from].add( autoAirdropAmount );
235             totalSupply = totalSupply.add( autoAirdropAmount );
236             alreadyAutoAirdropAmount=alreadyAutoAirdropAmount.add(autoAirdropAmount);
237         }
238 
239 		epoch[] epochs = lockEpochsMap[_from];
240 		uint256 needLockBalance = 0;
241 		for(uint256 i;i<epochs.length;i++)
242 		{
243 			if( now < epochs[i].endTime )
244 			{
245 				needLockBalance = needLockBalance.add(epochs[i].amount);
246 			}
247 		}
248 
249 		require(balances[_from].sub(_value)>=needLockBalance);  
250 
251         require(_value <= balances[_from]);
252 
253 
254 		uint256 _allowance = allowed[_from][msg.sender];
255 		balances[_from] = balances[_from].sub(_value);
256 		balances[_to] = balances[_to].add(_value);
257 		allowed[_from][msg.sender] = _allowance.sub(_value);
258 		Transfer(_from, _to, _value);
259 		return true;
260   	}
261 
262   	function approve(address _spender, uint256 _value) public returns (bool) 
263   	{
264 		allowed[msg.sender][_spender] = _value;
265 		Approval(msg.sender, _spender, _value);
266 		return true;
267   	}
268 
269   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
270   	{
271 		return allowed[_owner][_spender];
272   	}
273 
274     function setRate(uint256 _rate) external 
275         onlyOwner
276       {
277           rate=_rate;
278       }
279 }