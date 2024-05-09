1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   function Ownable() public {
28     owner = msg.sender;
29   }
30 
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) public onlyOwner {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 contract YGO is ERC20,Ownable{
83 	using SafeMath for uint256;
84 
85 	//the base info of the token
86 	string public constant name="Yu Gi Oh";
87 	string public constant symbol="YGO";
88 	string public constant version = "1.0";
89 	uint256 public constant decimals = 18;
90 
91     mapping(address => uint256) balances;
92 	mapping (address => mapping (address => uint256)) allowed;
93 	uint256 public constant MAX_SUPPLY=500000000*10**decimals;
94 	uint256 public constant INIT_SUPPLY=450000000*10**decimals;
95 
96 	uint256 public constant autoAirdropAmount=200*10**decimals;
97 	uint256 public alreadyAutoAirdropAmount;
98 
99 	uint256 public airdropSupply;
100 	mapping(address => bool) touched;
101 
102 
103 	function YGO(){
104 		airdropSupply = 0;
105 		totalSupply = INIT_SUPPLY;
106 		balances[msg.sender] = INIT_SUPPLY;
107 		Transfer(0x0, msg.sender, INIT_SUPPLY);
108 	}
109 
110 	modifier totalSupplyNotReached(uint256 _ethContribution,uint rate){
111 		assert(totalSupply.add(_ethContribution.mul(rate)) <= MAX_SUPPLY);
112 		_;
113 	}
114 
115     function airdrop(address [] _holders,uint256 paySize) external
116     	onlyOwner 
117 	{
118         uint256 count = _holders.length;
119         assert(paySize.mul(count) <= balanceOf(msg.sender));
120         for (uint256 i = 0; i < count; i++) {
121             transfer(_holders [i], paySize);
122 			airdropSupply = airdropSupply.add(paySize);
123         }
124     }
125 
126 	function () payable external
127 	{
128 	}
129 
130 	function etherProceeds() external
131 		onlyOwner
132 
133 	{
134 		if(!msg.sender.send(this.balance)) revert();
135 	}
136 
137 	function processFunding(address receiver,uint256 _value,uint256 fundingRate) internal
138 		totalSupplyNotReached(_value,fundingRate)
139 
140 	{
141 		uint256 tokenAmount = _value.mul(fundingRate);
142 		totalSupply=totalSupply.add(tokenAmount);
143 		balances[receiver] += tokenAmount;  // safeAdd not needed; bad semantics to use here
144 		Transfer(0x0, receiver, tokenAmount);
145 	}
146 
147   	function transfer(address _to, uint256 _value) public  returns (bool)
148  	{
149 		require(_to != address(0));
150 
151         if( !touched[msg.sender] && totalSupply.add(autoAirdropAmount) <= MAX_SUPPLY ){
152             touched[msg.sender] = true;
153             balances[msg.sender] = balances[msg.sender].add( autoAirdropAmount );
154             totalSupply = totalSupply.add( autoAirdropAmount );
155             alreadyAutoAirdropAmount=alreadyAutoAirdropAmount.add(autoAirdropAmount);
156 
157         }
158         
159         require(_value <= balances[msg.sender]);
160 
161 		// SafeMath.sub will throw if there is not enough balance.
162 		balances[msg.sender] = balances[msg.sender].sub(_value);
163 		balances[_to] = balances[_to].add(_value);
164 		Transfer(msg.sender, _to, _value);
165 		return true;
166   	}
167 
168   	function balanceOf(address _owner) public constant returns (uint256 balance) 
169   	{
170         if( totalSupply.add(autoAirdropAmount) <= MAX_SUPPLY ){
171             if( touched[_owner] ){
172                 return balances[_owner];
173             }
174             else{
175                 return balances[_owner].add(autoAirdropAmount);
176             }
177         } else {
178             return balances[_owner];
179         }
180   	}
181 
182   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
183   	{
184 		require(_to != address(0));
185         
186         if( !touched[_from] && totalSupply.add(autoAirdropAmount) <= MAX_SUPPLY ){
187             touched[_from] = true;
188             balances[_from] = balances[_from].add( autoAirdropAmount );
189             totalSupply = totalSupply.add( autoAirdropAmount );
190             alreadyAutoAirdropAmount=alreadyAutoAirdropAmount.add(autoAirdropAmount);
191         }
192         
193         require(_value <= balances[_from]);
194 
195 
196 		uint256 _allowance = allowed[_from][msg.sender];
197 		balances[_from] = balances[_from].sub(_value);
198 		balances[_to] = balances[_to].add(_value);
199 		allowed[_from][msg.sender] = _allowance.sub(_value);
200 		Transfer(_from, _to, _value);
201 		return true;
202   	}
203 
204   	function approve(address _spender, uint256 _value) public returns (bool) 
205   	{
206 		allowed[msg.sender][_spender] = _value;
207 		Approval(msg.sender, _spender, _value);
208 		return true;
209   	}
210 
211   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
212   	{
213 		return allowed[_owner][_spender];
214   	}
215 
216 	  
217 }