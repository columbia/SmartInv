1 pragma solidity ^0.4.6;
2  
3 contract admined {
4   address public admin;
5 
6   function admined(){
7     admin = msg.sender;
8   }
9 
10   modifier onlyAdmin(){
11     require(msg.sender == admin) ;
12     _;
13   }
14 
15   function transferAdminship(address newAdmin) onlyAdmin {
16     admin = newAdmin;
17   }
18 
19 }
20 
21 contract ERC223Interface {
22        uint public totalSupply;
23        function totalSupply() constant  returns (uint256 _supply);
24 	   function name() constant  returns (string _name);
25 	   function symbol() constant  returns (string _symbol);
26 	   function decimals() constant  returns (uint8 _decimals);
27 	   function balanceOf(address who) constant returns (uint);
28 	   function transfer(address to, uint value);
29 	   
30 	   event Transfers(address indexed from, address indexed to, uint256 value);  
31         event Transfer(address indexed from, address indexed to, uint value, bytes data);
32     
33 	   event TokenFallback(address from, uint value, bytes _data);
34 
35 }
36 contract ERC223ReceivingContract { 
37 
38     function tokenFallback(address from, uint value, bytes _data);
39     event TokenFallback(address from, uint value, bytes _data);
40 }
41 
42 contract AssetToken is admined,ERC223Interface{
43 
44  mapping (address => uint256) public balanceOf;
45      mapping(address => mapping(address => uint256)) allowed;
46 
47  uint256 public totalSupply;
48  string public name;
49   string public symbol;
50   uint8 public decimal; 
51   uint256 public soldToken;
52   event Transfer(address indexed from, address indexed to, uint256 value);
53    //Trigger when Tokens Burned
54         event Burn(address indexed from, uint256 value);
55 
56  
57 
58   function AssetToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralAdmin) {
59  balanceOf[msg.sender] = initialSupply;
60     totalSupply = initialSupply;
61     decimal = decimalUnits;
62     symbol = tokenSymbol;
63     name = tokenName;
64     soldToken=0;
65     
66     if(centralAdmin != 0)
67       admin = centralAdmin;
68     else
69       admin = msg.sender;
70     balanceOf[admin] = initialSupply;
71     totalSupply = initialSupply;  
72   }
73 
74   function mintToken(address target, uint256 mintedAmount) onlyAdmin{
75     balanceOf[target] += mintedAmount;
76     totalSupply += mintedAmount;
77     Transfer(0, this, mintedAmount);
78     Transfer(this, target, mintedAmount);
79   }
80 
81 
82     function transfer(address _to, uint _value) {
83         uint codeLength;
84         bytes memory empty;
85 
86         assembly {
87             // Retrieve the size of the code on target address, this needs assembly .
88             codeLength := extcodesize(_to)
89         }
90 
91         balanceOf[msg.sender] -= _value;
92     balanceOf[_to] += _value;
93         if(codeLength>0) {
94             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
95 	
96             receiver.tokenFallback(msg.sender, _value, empty);
97 
98 }
99         soldToken+=_value;
100         Transfers(msg.sender, _to, _value);
101     }
102   
103     
104     
105  function balanceOf(address _owner) constant  returns (uint balance) {
106     return balanceOf[_owner];
107   }
108 
109     
110     //Allow the owner to burn the token from their accounts
111 function burn(uint256 _value) public returns (bool success) {
112         require(balanceOf[msg.sender] >= _value);   
113         balanceOf[msg.sender] -= _value;            
114         totalSupply -= _value;                      
115         Burn(msg.sender, _value);
116         return true;
117     }
118 
119 
120   // Function to access name of token .
121   function name() constant  returns (string _name) {
122       return name;
123   }
124   // Function to access symbol of token .
125   function symbol() constant  returns (string _symbol) {
126       return symbol;
127   }
128   // Function to access decimals of token .
129   function decimals() constant  returns (uint8 _decimals) {
130       return decimal;
131   }
132   // Function to access total supply of tokens .
133    function totalSupply() constant returns(uint256 initialSupply) {
134         initialSupply = totalSupply;
135     }
136   
137 
138 
139 }