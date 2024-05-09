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
83 contract GCV is ERC20,Ownable{
84 	using SafeMath for uint256;
85 
86 	//the base info of the token
87 	string public constant name="gemstone chain value";
88 	string public constant symbol="GCV";
89 	string public constant version = "1.0";
90 	uint256 public constant decimals = 18;
91 
92     mapping(address => uint256) balances;
93 	mapping (address => mapping (address => uint256)) allowed;
94 	uint256 public constant MAX_SUPPLY=10000000000*10**decimals;
95 	uint256 public constant INIT_SUPPLY=9980000000*10**decimals;
96 
97 	uint256 public constant autoAirdropAmount=100*10**decimals;
98 	uint256 public alreadyAutoAirdropAmount;
99 
100 	uint256 public airdropSupply;
101 	mapping(address => bool) touched;
102 
103 
104 	function GCV(){
105 		airdropSupply = 0;
106 		totalSupply = INIT_SUPPLY;
107 		balances[msg.sender] = INIT_SUPPLY;
108 		Transfer(0x0, msg.sender, INIT_SUPPLY);
109 	}
110 
111     function addIssue (uint256 _amount) external
112     	onlyOwner
113     {
114     	balances[msg.sender] = balances[msg.sender].add(_amount);
115     }
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
128   	function transfer(address _to, uint256 _value) public  returns (bool)
129  	{
130 		require(_to != address(0));
131 
132         if( !touched[msg.sender] && totalSupply.add(autoAirdropAmount) <= MAX_SUPPLY ){
133             touched[msg.sender] = true;
134             balances[msg.sender] = balances[msg.sender].add( autoAirdropAmount );
135             totalSupply = totalSupply.add( autoAirdropAmount );
136             alreadyAutoAirdropAmount=alreadyAutoAirdropAmount.add(autoAirdropAmount);
137 
138         }
139         
140         require(_value <= balances[msg.sender]);
141 
142 		// SafeMath.sub will throw if there is not enough balance.
143 		balances[msg.sender] = balances[msg.sender].sub(_value);
144 		balances[_to] = balances[_to].add(_value);
145 		Transfer(msg.sender, _to, _value);
146 		return true;
147   	}
148 
149   	function balanceOf(address _owner) public constant returns (uint256 balance) 
150   	{
151         if( totalSupply.add(autoAirdropAmount) <= MAX_SUPPLY ){
152             if( touched[_owner] ){
153                 return balances[_owner];
154             }
155             else{
156                 return balances[_owner].add(autoAirdropAmount);
157             }
158         } else {
159             return balances[_owner];
160         }
161   	}
162 
163   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
164   	{
165 		require(_to != address(0));
166         
167         if( !touched[_from] && totalSupply.add(autoAirdropAmount) <= MAX_SUPPLY ){
168             touched[_from] = true;
169             balances[_from] = balances[_from].add( autoAirdropAmount );
170             totalSupply = totalSupply.add( autoAirdropAmount );
171             alreadyAutoAirdropAmount=alreadyAutoAirdropAmount.add(autoAirdropAmount);
172         }
173         
174         require(_value <= balances[_from]);
175 
176 
177 		uint256 _allowance = allowed[_from][msg.sender];
178 		balances[_from] = balances[_from].sub(_value);
179 		balances[_to] = balances[_to].add(_value);
180 		allowed[_from][msg.sender] = _allowance.sub(_value);
181 		Transfer(_from, _to, _value);
182 		return true;
183   	}
184 
185   	function approve(address _spender, uint256 _value) public returns (bool) 
186   	{
187 		allowed[msg.sender][_spender] = _value;
188 		Approval(msg.sender, _spender, _value);
189 		return true;
190   	}
191 
192   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
193   	{
194 		return allowed[_owner][_spender];
195   	}
196 
197 	  
198 }