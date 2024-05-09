1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         assert(b > 0); 
12         uint256 c = a / b;
13         assert(a == b * c + a % b); 
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract owned {
30     address public owner;
31 
32     constructor() public {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     function transferOwnership(address newOwner) onlyOwner public {
42         owner = newOwner;
43     }
44 }
45 
46 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
47 
48 contract TokenERC20 is owned {
49     using SafeMath for uint256;
50 
51     string public name;
52     string public symbol;
53     uint8 public decimals = 18;
54     uint256 public totalSupply;
55 
56     mapping (address => uint256) public balanceOf;
57     mapping (address => mapping (address => uint256)) public allowance;
58     mapping (address => bool) public frozenAccount;
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 
64     event Burn(address indexed from, uint256 value);
65 
66     event FrozenFunds(address target, bool frozen);
67 
68 
69     constructor(
70         uint256 initialSupply,
71         string tokenName,
72         string tokenSymbol
73     ) public {
74         totalSupply = initialSupply * 10 ** uint256(decimals);  
75         balanceOf[msg.sender] = totalSupply;                
76         name = tokenName;                                   
77         symbol = tokenSymbol;                               
78     }
79 
80    
81      function _transfer(address _from, address _to, uint _value) internal {
82         require(_to != 0x0);
83         require(balanceOf[_from] >= _value);
84         require(balanceOf[_to].add(_value) > balanceOf[_to]);
85         require(!frozenAccount[_from]);                     
86         require(!frozenAccount[_to]);  
87         
88         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
89    
90         balanceOf[_from] = balanceOf[_from].sub(_value);
91         balanceOf[_to] = balanceOf[_to].add(_value);
92         emit Transfer(_from, _to, _value);
93         
94         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
95     }
96 
97 
98     function transfer(address _to, uint256 _value) public returns (bool success) {
99         _transfer(msg.sender, _to, _value);
100         return true;
101     }
102 
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104         require(_value <= allowance[_from][msg.sender]);     
105         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
106         _transfer(_from, _to, _value);
107         return true;
108     }
109 
110 
111     function approve(address _spender, uint256 _value) public
112         returns (bool success) {
113         allowance[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118 
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
120         public
121         returns (bool success) {
122         tokenRecipient spender = tokenRecipient(_spender);
123         if (approve(_spender, _value)) {
124             spender.receiveApproval(msg.sender, _value, this, _extraData);
125             return true;
126         }
127     }
128 
129  
130     function burn(uint256 _value) public returns (bool success) {
131         require(balanceOf[msg.sender] >= _value);   
132         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            
133         totalSupply = totalSupply.sub(_value);                      
134         emit Burn(msg.sender, _value);
135         return true;
136     }
137 
138     function burnFrom(address _from, uint256 _value) public returns (bool success) {
139         require(balanceOf[_from] >= _value);                
140         require(_value <= allowance[_from][msg.sender]);    
141         balanceOf[_from] = balanceOf[_from].sub(_value);                         
142         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             
143         totalSupply = totalSupply.sub(_value);                              
144         emit Burn(_from, _value);
145         return true;
146     }
147     
148     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
149         balanceOf[target] = balanceOf[target].add(mintedAmount);
150         totalSupply = totalSupply.add(mintedAmount);
151         emit Transfer(0, this, mintedAmount);
152         emit Transfer(this, target, mintedAmount);
153     }
154 
155     function freezeAccount(address target, bool freeze) onlyOwner public {
156         frozenAccount[target] = freeze;
157         emit FrozenFunds(target, freeze);
158     }
159 }