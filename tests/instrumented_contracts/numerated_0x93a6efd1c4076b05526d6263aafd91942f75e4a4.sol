1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   /**
29   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 // ERC20 
48 contract ERC20 {
49     
50 	function transfer(address to, uint value) public returns (bool success);
51 	function transferFrom(address from, address to, uint value) public returns (bool success);
52 	 
53    
54 	event Transfer(address indexed from, address indexed to, uint value);
55  
56 }
57  
58 
59 
60 // contract owned
61 contract Owned {
62     address public owner;
63 
64     constructor () internal {
65         owner = msg.sender;
66     }
67 
68     modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     function transferOwnership(address newOwner) onlyOwner public {
74         owner = newOwner;
75     }
76 }
77 
78 
79 
80 //ArtBlockToken
81 contract ArtBlockToken is ERC20, Owned {
82  
83     using SafeMath for uint256;
84     //metadata
85     string  public name="ArtBlock Ecological";
86     string  public symbol="AET";
87     uint256 public decimals = 18;
88     string  public version = "1.0"; 
89     uint public totalSupply = 4500000000  * 10 ** uint(decimals);
90     
91 
92  
93 	mapping(address => uint) public balanceOf;
94     mapping(address => uint256) public lockValues;
95 	mapping(address => mapping(address => uint)) public allowance;
96 	
97 	//event     
98 	event FreezeIn(address[] indexed from, bool value);
99 	event FreezeOut(address[] indexed from, bool value);
100   
101  
102     //constructor
103      constructor ()  public {
104        
105         balanceOf[msg.sender] = totalSupply; 
106     }
107     
108     function internalTransfer(address from, address toaddr, uint value) internal {
109 		require(toaddr!=0);
110 		require(balanceOf[from]>=value); 
111 		
112 		
113 
114 		balanceOf[from]= balanceOf[from].sub(value);// safeSubtract(balanceOf[from], value);
115 		balanceOf[toaddr]= balanceOf[toaddr].add(value);//safeAdd(balanceOf[toaddr], value);
116 
117 		emit Transfer(from, toaddr, value);
118 	}
119 	
120 
121 //
122 function transfer(address _to, uint256 _value) public  returns (bool) {
123       
124   
125     require(_to != address(0));
126     require(_value <= balanceOf[msg.sender]);
127     uint256 transBlalance = balanceOf[msg.sender].sub(lockValues[msg.sender]);
128     require(_value <= transBlalance);
129     
130     // SafeMath.sub will throw if there is not enough balance.
131     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
132     balanceOf[_to] = balanceOf[_to].add(_value);
133     emit Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 	
137 	//transfer from
138 	function transferFrom(address from, address toaddr, uint value) public returns (bool) {
139 		require(allowance[from][msg.sender]>=value);
140 
141 		allowance[from][msg.sender]=allowance[from][msg.sender].sub(value);//  safeSubtract(allowance[from][msg.sender], value);
142 
143 		internalTransfer(from, toaddr, value);
144 
145 		return true;
146 	}
147 	
148     // reset name and symbol
149     function setNameSymbol(string newName, string newSymbol) public onlyOwner {
150 		name=newName;
151 		symbol=newSymbol;
152 	}
153 
154    
155      
156     function addLockValue(address addr,uint256 _value) public onlyOwner{
157         
158        require(addr != address(0));
159         
160       lockValues[addr] = lockValues[addr].add(_value);
161         
162     }
163     
164     function subLockValue(address addr,uint256 _value) public onlyOwner{
165        
166        require(addr != address(0));
167        require(_value <= lockValues[addr]);
168        lockValues[addr] = lockValues[addr].sub(_value);
169         
170     }
171     
172    
173     // buy token
174     function () public payable {
175       
176     }
177 }