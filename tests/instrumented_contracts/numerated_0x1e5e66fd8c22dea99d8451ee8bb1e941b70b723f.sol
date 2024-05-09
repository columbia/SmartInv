1 pragma solidity ^0.4.24;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assertCheck(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14     assertCheck(b > 0);
15     uint256 c = a / b;
16     assertCheck(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assertCheck(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assertCheck(c>=a && c>=b);
28     return c;
29   }
30 
31   function assertCheck(bool assertion) internal pure {
32     require(assertion == true);
33   }
34 }
35 contract SWAP is SafeMath{
36     string public name;
37     string public symbol;
38     uint256 public decimals;
39     uint256 public totalSupply;
40 	address public owner;
41 
42     modifier onlyOwner(){
43         require(msg.sender == owner);
44         _;
45     }
46     function setName(string _name) onlyOwner public returns (string){
47          name = _name;
48          return name;
49     }
50     function setSymbol(string _symbol) onlyOwner public returns (string){
51          symbol = _symbol;
52          return symbol;
53      }
54     
55      function setDecimals(uint256 _decimals) onlyOwner public returns (uint256){
56          decimals = _decimals;
57          return decimals;
58      }
59     
60     
61      function getOwner() view public returns(address){
62         return owner;
63      }
64     /* This creates an array with all balances */
65     mapping (address => uint256) public balanceOf;
66     mapping (address => mapping (address => uint256)) public allowance;
67 
68     /* This generates a public event on the blockchain that will notify clients */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /* This notifies clients about the amount burnt */
72     event Burn(address indexed from, uint256 value);
73     
74     event Withdraw(address to, uint amount);
75     
76     /* Initializes contract with initial supply tokens to the creator of the contract */
77     constructor() public payable {
78         balanceOf[msg.sender] = 100000000000*10**18;
79         totalSupply = balanceOf[msg.sender];
80         name = 'SWAP'; 
81         symbol = 'SWAP'; 
82         decimals = 18; 
83 		owner = msg.sender;
84     }
85 
86    
87     function _transfer(address _from, address _to, uint _value) internal{
88         require(_to != 0x0); 
89 		require(_value > 0); 
90         require(balanceOf[_from] >= _value);   
91         require(balanceOf[_to] + _value >= balanceOf[_to]);
92         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);    
93         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);               
94         emit Transfer(_from, _to, _value);       
95     }
96 
97 
98     function transfer(address _to, uint256 _value) public payable returns (bool success) {
99         _transfer(msg.sender, _to, _value);
100         return true;
101     }
102     /* Allow another contract to spend some tokens in your behalf */
103     function approve(address _spender, uint256 _value)
104         public
105         returns (bool success) {
106 		require(_value > 0); 
107         allowance[msg.sender][_spender] = _value;
108         return true;
109     }
110        
111 
112     /* A contract attempts to get the coins */
113     function transferFrom(address _from, address _to, uint256 _value) 
114     public
115     payable  {
116         require (_to != 0x0) ;             
117 		require (_value > 0); 
118         require (balanceOf[_from] >= _value) ;       
119         require (balanceOf[_to] + _value >= balanceOf[_to]) ;
120         require (_value <= allowance[_from][msg.sender]) ;   
121         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);               
122         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);  
123         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
124         emit Transfer(_from, _to, _value);
125     }
126 
127     function burn(uint256 _value) public returns (bool success) {
128         require(balanceOf[msg.sender] >= _value);    
129 		require (_value > 0) ; 
130         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
131         totalSupply = SafeMath.safeSub(totalSupply,_value); // Updates totalSupply
132         emit Burn(msg.sender, _value);
133         return true;
134     }
135     function create(uint256 _value) public onlyOwner returns (bool success) {
136         require (_value > 0) ; 
137         totalSupply = SafeMath.safeAdd(totalSupply,_value);
138         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
139         return true;
140     }
141     
142 	// transfer balance to owner
143 	function withdraw() external onlyOwner{
144 		require(msg.sender == owner);
145 		msg.sender.transfer(address(this).balance);
146         emit Withdraw(msg.sender,address(this).balance);
147 	}
148 	
149 	// can accept ether
150 	function() private payable {
151     }
152 }