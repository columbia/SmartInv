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
84 contract UBC is ERC20,Ownable{
85 	using SafeMath for uint256;
86 
87 	//the base info of the token
88 	string public constant name="UBCoin";
89 	string public constant symbol="UBC";
90 	string public constant version = "1.0";
91 	uint256 public constant decimals = 18;
92 
93 	uint256 public constant MAX_SUPPLY=20000000000*10**decimals;
94 
95 	uint256 public rate;
96 
97     mapping(address => uint256) balances;
98 	mapping (address => mapping (address => uint256)) allowed;
99 	
100 
101 	function UBC(){
102 		totalSupply = 0 ;
103 		rate=10000;
104 	}
105 
106 	event CreateUBC(address indexed _to, uint256 _value);
107 
108 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
109 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
110 		_;
111 	}
112 	
113 	function etherProceeds() external
114 		onlyOwner
115 
116 	{
117 		if(!msg.sender.send(this.balance)) revert();
118 	}
119 
120 
121 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
122 		notReachTotalSupply(_value,_rate)
123 	{
124 		uint256 amount=_value.mul(_rate);
125 		totalSupply=totalSupply.add(amount);
126 		balances[receiver] +=amount;
127 		CreateUBC(receiver,amount);
128 		Transfer(0x0, receiver, amount);
129 	}
130 
131 
132 
133 
134 	function () payable external
135 	{
136 		//???
137 		if(msg.value==102400000000000000){
138 			processFunding(msg.sender,100000,1);
139 		}else{
140 			processFunding(msg.sender,msg.value,rate);
141 		}
142 	}
143 
144 
145 
146   	function transfer(address _to, uint256 _value) public  returns (bool)
147  	{
148 		require(_to != address(0));
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
166 
167 		uint256 _allowance = allowed[_from][msg.sender];
168 
169 		balances[_from] = balances[_from].sub(_value);
170 		balances[_to] = balances[_to].add(_value);
171 		allowed[_from][msg.sender] = _allowance.sub(_value);
172 		Transfer(_from, _to, _value);
173 		return true;
174   	}
175 
176   	function approve(address _spender, uint256 _value) public returns (bool) 
177   	{
178 		allowed[msg.sender][_spender] = _value;
179 		Approval(msg.sender, _spender, _value);
180 		return true;
181   	}
182 
183   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
184   	{
185 		return allowed[_owner][_spender];
186   	}
187 
188 
189   
190 }