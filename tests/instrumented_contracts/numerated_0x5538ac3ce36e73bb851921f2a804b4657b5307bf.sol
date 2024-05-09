1 pragma solidity 0.5.17;
2 
3  library SafeMath256 {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if(a==0 || b==0)
6         return 0;  
7     uint256 c = a * b;
8     require(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     require(b>0);
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19    require( b<= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     require(c >= a);
26 
27     return c;
28   }
29   
30 }
31 
32 
33 contract ERC20 {
34 	   event Transfer(address indexed from, address indexed to, uint256 tokens);
35        event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
36 
37    	   function totalSupply() public view returns (uint256);
38        function balanceOf(address tokenOwner) public view returns (uint256 balance);
39        function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
40 
41        function transfer(address to, uint256 tokens) public returns (bool success);
42        
43        function approve(address spender, uint256 tokens) public returns (bool success);
44        function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
45        
46 
47 }
48 
49 contract StandarERC20 is ERC20{
50      using SafeMath256 for uint256; 
51      
52      mapping (address => uint256) balance;
53      mapping (address => mapping (address=>uint256)) allowed;
54 
55 
56       event Transfer(address indexed from,address indexed to,uint256 value);
57       event Approval(address indexed owner,address indexed spender,uint256 value);
58 
59 
60      function balanceOf(address _walletAddress) public view returns (uint256){
61         return balance[_walletAddress]; 
62      }
63 
64 
65      function allowance(address _owner, address _spender) public view returns (uint256){
66           return allowed[_owner][_spender];
67         }
68 
69      function transfer(address _to, uint256 _value) public returns (bool){
70         require(_value <= balance[msg.sender],"In sufficial Balance");
71         require(_to != address(0),"Can't transfer To Address 0");
72 
73         balance[msg.sender] = balance[msg.sender].sub(_value);
74         balance[_to] = balance[_to].add(_value);
75         emit Transfer(msg.sender,_to,_value);
76         
77         return true;
78 
79      }
80 
81      function approve(address _spender, uint256 _value)
82             public returns (bool){
83             allowed[msg.sender][_spender] = _value;
84 
85             emit Approval(msg.sender, _spender, _value);
86             return true;
87             }
88 
89       function transferFrom(address _from, address _to, uint256 _value)
90             public returns (bool){
91                require(_value <= balance[_from]);
92                require(_value <= allowed[_from][msg.sender]); 
93                require(_to != address(0));
94 
95               balance[_from] = balance[_from].sub(_value);
96               balance[_to] = balance[_to].add(_value);
97               allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98               emit Transfer(_from, _to, _value);
99               return true;
100       }
101 }
102 
103 contract SZOWRAPTOKEN is StandarERC20{
104   string public name = "Wrapped SZO";
105   string public symbol = "WSZO"; 
106   uint256 public decimals = 18;
107 
108   ERC20 public szoToken;
109   
110   mapping(address=>bool) public poolsAutoKYC;
111   
112   constructor() public {
113       szoToken = ERC20(0x6086b52Cab4522b4B0E8aF9C3b2c5b8994C36ba6);
114   }
115   
116   function deposit(uint256 _amount) public  {
117         require(szoToken.balanceOf(msg.sender) >= _amount,"Out of fund");
118         szoToken.transferFrom(msg.sender,address(this),_amount);
119         balance[msg.sender] += _amount;
120         emit Transfer(msg.sender,address(this),_amount);
121     }
122     
123   //Please Ensure that you've submitted and your KYC has been approved before you swap to SZO 
124   //ShuttleOne is undergoing regulatory compliance in the Republic of Singapore and we seek your kind understanding. 
125   //Please ignore this advisory if you have successfully passed KYC
126 
127    function withdraw(uint256 _amount) public {
128         require(balance[msg.sender] >= _amount);
129         balance[msg.sender] -= _amount;
130         szoToken.transfer(msg.sender,_amount);
131         emit Transfer(address(this),msg.sender,_amount);
132    }
133     
134    function totalSupply() public view returns (uint256){
135        return szoToken.balanceOf(address(this)); 
136     }
137     
138     
139 
140 }