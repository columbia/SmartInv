1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4 
5     address public owner;
6 
7     function Owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function setOwner(address _newOwner) onlyOwner {
17 	 if(_newOwner == 0x0)revert();
18         owner = _newOwner;
19     }
20    
21 }
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a * b;
30     assert(a == 0 || c / a == b);
31     return c;
32   }
33 
34   function div(uint256 a, uint256 b) internal constant returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40 
41   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function add(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 
52   function toUINT112(uint256 a) internal constant returns(uint112) {
53     assert(uint112(a) == a);
54     return uint112(a);
55   }
56 
57   function toUINT120(uint256 a) internal constant returns(uint120) {
58     assert(uint120(a) == a);
59     return uint120(a);
60   }
61 
62   function toUINT128(uint256 a) internal constant returns(uint128) {
63     assert(uint128(a) == a);
64     return uint128(a);
65   }
66 }
67 
68 
69 // Abstract contract for the full ERC 20 Token standard
70 // https://github.com/ethereum/EIPs/issues/20
71 
72 contract Token {
73  
74     function totalSupply() public  returns (uint256 supply);
75 	 
76     function transfer(address _to, uint256 _value) returns (bool success);
77 
78     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
79 
80     function approve(address _spender, uint256 _value) returns (bool success);
81   
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
83      
84     function burn( uint256 _value) public returns (bool success);
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87   
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89   
90     event Burn(address indexed from, uint256 value);
91   
92   
93   
94 }
95 
96 contract Biokkoin is Token, Owned {
97     using SafeMath for uint256;
98   
99     uint public  _totalSupply;
100   
101     string public   name;         //The Token's name
102   
103     uint8 public constant decimals = 8;    //Number of decimals of the smallest unit
104   
105     string public  symbol;    //The Token's symbol 
106   
107     uint256 public mintCount;
108   
109     uint256 public deleteToken;
110   
111     uint256 public soldToken;
112 
113    
114     mapping (address => uint256) public balanceOf;
115 
116     // Owner of account approves the transfer of an amount to another account
117     mapping(address => mapping(address => uint256)) allowed;
118 
119   
120 
121     // Constructor
122     function Biokkoin(string coinName,string coinSymbol,uint initialSupply) {
123         _totalSupply = initialSupply *10**uint256(decimals);                        // Update total supply
124         balanceOf[msg.sender] = _totalSupply; 
125         name = coinName;                                   // Set the name for display purposes
126         symbol =coinSymbol;   
127         
128     }
129 
130    function totalSupply()  public  returns (uint256 totalSupply) {
131         return _totalSupply;
132     }
133 	
134     // Send back ether sent to me
135     function () {
136         revert();
137     }
138   
139   
140     // Transfer the balance from owner's account to another account
141     function transfer(address _to, uint256 _amount) returns (bool success) {
142         // according to AssetToken's total supply, never overflow here
143         if (balanceOf[msg.sender] >= _amount
144             && _amount > 0) {            
145             balanceOf[msg.sender] -= uint112(_amount);
146             balanceOf[_to] = _amount.add(balanceOf[_to]).toUINT112();
147             soldToken = _amount.add(soldToken).toUINT112();
148             Transfer(msg.sender, _to, _amount);
149             return true;
150         } else {
151             return false;
152         }
153     }
154 
155    
156     function transferFrom(
157         address _from,
158         address _to,
159         uint256 _amount
160     ) returns (bool success) {
161         // according to AssetToken's total supply, never overflow here
162         if (balanceOf[_from] >= _amount
163             && allowed[_from][msg.sender] >= _amount
164             && _amount > 0) {
165             balanceOf[_from] = balanceOf[_from].sub(_amount).toUINT112();
166             allowed[_from][msg.sender] -= _amount;
167             balanceOf[_to] = _amount.add(balanceOf[_to]).toUINT112();
168             Transfer(_from, _to, _amount);
169             return true;
170         } else {
171             return false;
172         }
173     }
174 
175    
176     function approve(address _spender, uint256 _amount) returns (bool success) {
177         allowed[msg.sender][_spender] = _amount;
178         Approval(msg.sender, _spender, _amount);
179         return true;
180     }
181 
182 
183 
184     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
185         return allowed[_owner][_spender];
186     }
187 
188     //Mint tokens and assign to some one
189     function mint(address _owner, uint256 _amount) onlyOwner{
190      
191             balanceOf[_owner] = _amount.add(balanceOf[_owner]).toUINT112();
192             mintCount =  _amount.add(mintCount).toUINT112();
193             _totalSupply = _totalSupply.add(_amount).toUINT112();
194     }
195   //Burn tokens from owner account
196   function burn(uint256 _count) public returns (bool success)
197   {
198           balanceOf[msg.sender] -=uint112( _count);
199           deleteToken = _count.add(deleteToken).toUINT112();
200          _totalSupply = _totalSupply.sub(_count).toUINT112();
201           Burn(msg.sender, _count);
202 		  return true;
203     }
204     
205   }