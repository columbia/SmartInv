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
20 }
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal constant returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 
51   function toUINT112(uint256 a) internal constant returns(uint112) {
52     assert(uint112(a) == a);
53     return uint112(a);
54   }
55 
56   function toUINT120(uint256 a) internal constant returns(uint120) {
57     assert(uint120(a) == a);
58     return uint120(a);
59   }
60 
61   function toUINT128(uint256 a) internal constant returns(uint128) {
62     assert(uint128(a) == a);
63     return uint128(a);
64   }
65 }
66 
67 
68 // Abstract contract for the full ERC 20 Token standard
69 // https://github.com/ethereum/EIPs/issues/20
70 
71 contract Token {
72  
73     function totalSupply() public  returns (uint256 supply);
74 	 
75     function transfer(address _to, uint256 _value) returns (bool success);
76 
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
78 
79     function approve(address _spender, uint256 _value) returns (bool success);
80   
81     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
82   
83     function burn( uint256 _value) public returns (bool success);
84 
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86   
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88   
89     event Burn(address indexed from, uint256 value);
90 }
91 
92 
93 
94 contract RemcoToken is Token, Owned {
95     using SafeMath for uint256;
96   
97     uint public  _totalSupply;
98   
99     string public   name;         //The Token's name
100   
101     uint8 public constant decimals = 8;    //Number of decimals of the smallest unit
102   
103     string public  symbol;    //The Token's symbol 
104   
105     uint256 public mintCount;
106   
107     uint256 public deleteToken;
108   
109     uint256 public soldToken;
110 
111    
112     mapping (address => uint256) public balanceOf;
113 
114     // Owner of account approves the transfer of an amount to another account
115     mapping(address => mapping(address => uint256)) allowed;
116 
117   
118 
119     // Constructor
120     function RemcoToken(string coinName,string coinSymbol,uint initialSupply) {
121         _totalSupply = initialSupply *10**uint256(decimals);                        // Update total supply
122         balanceOf[msg.sender] = _totalSupply; 
123         name = coinName;                                   // Set the name for display purposes
124         symbol =coinSymbol;   
125         
126     }
127 
128    function totalSupply()  public  returns (uint256 totalSupply) {
129         return _totalSupply;
130     }
131 	
132     // Send back ether sent to me
133     function () {
134         revert();
135     }
136 
137     // Transfer the balance from owner's account to another account
138     function transfer(address _to, uint256 _amount) returns (bool success) {
139         // according to AssetToken's total supply, never overflow here
140         if (balanceOf[msg.sender] >= _amount
141             && _amount > 0) {            
142             balanceOf[msg.sender] -= uint112(_amount);
143             balanceOf[_to] = _amount.add(balanceOf[_to]).toUINT112();
144             soldToken = _amount.add(soldToken).toUINT112();
145             Transfer(msg.sender, _to, _amount);
146             return true;
147         } else {
148             return false;
149         }
150     }
151 
152    
153     function transferFrom(
154         address _from,
155         address _to,
156         uint256 _amount
157     ) returns (bool success) {
158         // according to AssetToken's total supply, never overflow here
159         if (balanceOf[_from] >= _amount
160             && allowed[_from][msg.sender] >= _amount
161             && _amount > 0) {
162             balanceOf[_from] = balanceOf[_from].sub(_amount).toUINT112();
163             allowed[_from][msg.sender] -= _amount;
164             balanceOf[_to] = _amount.add(balanceOf[_to]).toUINT112();
165             Transfer(_from, _to, _amount);
166             return true;
167         } else {
168             return false;
169         }
170     }
171 
172    
173     function approve(address _spender, uint256 _amount) returns (bool success) {
174         allowed[msg.sender][_spender] = _amount;
175         Approval(msg.sender, _spender, _amount);
176         return true;
177     }
178 
179 
180 
181     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
182         return allowed[_owner][_spender];
183     }
184 
185     //Mint tokens and assign to some one
186     function mint(address _owner, uint256 _amount) onlyOwner{
187      
188             balanceOf[_owner] = _amount.add(balanceOf[_owner]).toUINT112();
189             mintCount =  _amount.add(mintCount).toUINT112();
190             _totalSupply = _totalSupply.add(_amount).toUINT112();
191     }
192   //Burn tokens from owner account
193   function burn(uint256 _count) public returns (bool success)
194   {
195           balanceOf[msg.sender] -=uint112( _count);
196           deleteToken = _count.add(deleteToken).toUINT112();
197          _totalSupply = _totalSupply.sub(_count).toUINT112();
198           Burn(msg.sender, _count);
199 		  return true;
200     }
201     
202   }