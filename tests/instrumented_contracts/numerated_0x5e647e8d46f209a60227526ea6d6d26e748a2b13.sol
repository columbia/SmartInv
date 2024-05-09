1 pragma solidity ^0.5;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
21 
22 contract TokenERC20 {
23     
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     
28     uint256 public totalSupply;
29 
30     
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     
37     
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     
41     event Burn(address indexed from, uint256 value);
42 
43     constructor(
44         uint256 initialSupply,
45         string memory tokenName,
46         string memory tokenSymbol
47     ) public {
48         totalSupply = initialSupply * 10 ** uint256(decimals);  
49         balanceOf[msg.sender] = totalSupply;                    
50         name = tokenName;                                       
51         symbol = tokenSymbol;                                   
52     }
53 
54     function _transfer(address _from, address _to, uint _value) internal {
55         
56         require(_to != address(0x0));
57         
58         require(balanceOf[_from] >= _value);
59         
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61         
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         
64         balanceOf[_from] -= _value;
65         
66         balanceOf[_to] += _value;
67         emit Transfer(_from, _to, _value);
68         
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71 
72     function transfer(address _to, uint256 _value) public returns (bool success) {
73         _transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         require(_value <= allowance[_from][msg.sender]);     
79         allowance[_from][msg.sender] -= _value;
80         _transfer(_from, _to, _value);
81         return true;
82     }
83 
84     function approve(address _spender, uint256 _value) public
85         returns (bool success) {
86         allowance[msg.sender][_spender] = _value;
87         emit Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
92         public
93         returns (bool success) {
94         tokenRecipient spender = tokenRecipient(_spender);
95         if (approve(_spender, _value)) {
96             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
97             return true;
98         }
99     }
100 
101     function burn(uint256 _value) public returns (bool success) {
102         require(balanceOf[msg.sender] >= _value);   
103         balanceOf[msg.sender] -= _value;            
104         totalSupply -= _value;                      
105         emit Burn(msg.sender, _value);
106         return true;
107     }
108 
109     function burnFrom(address _from, uint256 _value) public returns (bool success) {
110         require(balanceOf[_from] >= _value);                
111         require(_value <= allowance[_from][msg.sender]);    
112         balanceOf[_from] -= _value;                         
113         allowance[_from][msg.sender] -= _value;             
114         totalSupply -= _value;                              
115         emit Burn(_from, _value);
116         return true;
117     }
118 }
119 
120 contract BarToken is owned, TokenERC20 {
121 
122     mapping (address => bool) public frozenAccount;
123 
124     event FrozenFunds(address target, bool frozen);
125 
126     constructor(
127         uint256 initialSupply,
128         string memory tokenName,
129         string memory tokenSymbol
130     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
131 
132     function _transfer(address _from, address _to, uint _value) internal {
133         require (_to != address(0x0));                          
134         require (balanceOf[_from] >= _value);                   
135         require (balanceOf[_to] + _value >= balanceOf[_to]);    
136         require(!frozenAccount[_from]);                         
137         require(!frozenAccount[_to]);                           
138         balanceOf[_from] -= _value;                             
139         balanceOf[_to] += _value;                               
140         emit Transfer(_from, _to, _value);
141     }
142 
143     function freezeAccount(address target, bool freeze) onlyOwner public {
144         frozenAccount[target] = freeze;
145         emit FrozenFunds(target, freeze);
146     }
147 
148 }