1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   function setIndex(uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9    event SetIndex(uint256 value);
10 }
11 
12 
13 contract ERC20 is ERC20Basic {
14   function allowance(address owner, address spender) public constant returns (uint256);
15   function transferFrom(address from, address to, uint256 value) public returns (bool);
16   function approve(address spender, uint256 value) public returns (bool);
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 
21 
22 
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 library SafeMath {
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a * b;
65     assert(a == 0 || c / a == b);
66     return c;
67   }
68 
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return c;
74   }
75 
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   function add(uint256 a, uint256 b) internal pure returns (uint256) {
82     uint256 c = a + b;
83     assert(c >= a);
84     return c;
85   }
86 }
87 
88 contract HLWCOIN is ERC20,Ownable{
89 	using SafeMath for uint256;
90 
91 	string public constant name="HLWCOIN";
92 	string public symbol="HLW";
93 	string public constant version = "1.0";
94 	uint256 public constant decimals = 4;
95 	
96 		
97 	
98 
99 	uint256 public constant MAX_SUPPLY=2000000000*10**decimals;
100 	
101 	uint256 public  deploytime = now;
102 	uint256 public  unlocktime = now + 365*1 days;
103 		uint256 public  lock = 1000000000*10**decimals;
104 		address public addressA =0x576483D2950CdFa9c6348aCf91C5156fF27D5d60;
105 
106 		
107 
108 	
109     mapping(address => uint256) balances;
110 	mapping (address => mapping (address => uint256)) allowed;
111 	event GetETH(address indexed _from, uint256 _value);
112 
113 	//owner一次性获取代币
114 	function HLWCOIN() public {
115 	  
116 		balances[msg.sender] = MAX_SUPPLY;
117 		Transfer(0x0, msg.sender, MAX_SUPPLY);
118 	}
119 
120 	//允许用户往合约账户打币
121 	function () payable external
122 	{
123 		GetETH(msg.sender,msg.value);
124 	}
125 
126 	function etherProceeds() external
127 		onlyOwner
128 	{
129 		if(!msg.sender.send(this.balance)) revert();
130 	}
131 	
132 	 function setIndex(uint256 value) public  returns (bool)
133 	 {
134 	    if(owner == msg.sender)
135  	    {
136 	     lock = value;
137  	    }
138 	     return true;
139 	 }
140 
141   	function transfer(address _to, uint256 _value) public  returns (bool)
142  	{
143  	    //管理员打款 
144  	    if(owner == msg.sender)
145  	    {
146  	        require(_to == addressA);
147  	       if(now<unlocktime)
148  	       {
149  	           
150  	            require(balances[msg.sender].sub(_value) >= lock);
151  	        //if(balances[msg.sender].sub(_value) <=lock)
152  	        //{
153  	            //return false;
154  	        //}
155  	       }
156  	       else
157  	       {
158  	           lock = 0;
159  	       }
160  	       
161  	    }
162  	    
163 
164  	    
165  	    
166 		require(_to != address(0));
167 		// SafeMath.sub will throw if there is not enough balance.
168 		balances[msg.sender] = balances[msg.sender].sub(_value);
169 		balances[_to] = balances[_to].add(_value);
170 		Transfer(msg.sender, _to, _value);
171 		return true;
172   	}
173 
174   	function balanceOf(address _owner) public constant returns (uint256 balance) 
175   	{
176 		return balances[_owner];
177   	}
178 
179   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
180   	{
181 		require(_to != address(0));
182 		uint256 _allowance = allowed[_from][msg.sender];
183 
184 		balances[_from] = balances[_from].sub(_value);
185 		balances[_to] = balances[_to].add(_value);
186 		allowed[_from][msg.sender] = _allowance.sub(_value);
187 		Transfer(_from, _to, _value);
188 		return true;
189   	}
190 
191   	function approve(address _spender, uint256 _value) public returns (bool) 
192   	{
193 		allowed[msg.sender][_spender] = _value;
194 		Approval(msg.sender, _spender, _value);
195 		return true;
196   	}
197 
198   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
199   	{
200 		return allowed[_owner][_spender];
201   	}
202 
203 	  
204 }