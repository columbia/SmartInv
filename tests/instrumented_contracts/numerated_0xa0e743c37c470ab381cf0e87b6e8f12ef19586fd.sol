1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Burn(address indexed from, uint256 value);
34 
35     function TokenERC20(
36         uint256 initialSupply,
37         string tokenName,
38         string tokenSymbol
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);
41         balanceOf[msg.sender] = totalSupply;                
42         name = tokenName;                                   
43         symbol = tokenSymbol;                               
44     }
45 
46     function _transfer(address _from, address _to, uint _value) internal {
47         require(_to != 0x0);
48         require(balanceOf[_from] >= _value);
49         require(balanceOf[_to] + _value > balanceOf[_to]);
50         uint previousBalances = balanceOf[_from] + balanceOf[_to];
51         balanceOf[_from] -= _value;
52         balanceOf[_to] += _value;
53         Transfer(_from, _to, _value);
54         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
55     }
56 
57     function transfer(address _to, uint256 _value) public {
58         _transfer(msg.sender, _to, _value);
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
62         require(_value <= allowance[_from][msg.sender]);
63         allowance[_from][msg.sender] -= _value;
64         _transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function approve(address _spender, uint256 _value) public
69         returns (bool success) {
70         allowance[msg.sender][_spender] = _value;
71         return true;
72     }
73 
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
75         public
76         returns (bool success) {
77         tokenRecipient spender = tokenRecipient(_spender);
78         if (approve(_spender, _value)) {
79             spender.receiveApproval(msg.sender, _value, this, _extraData);
80             return true;
81         }
82     }
83 
84     function burn(uint256 _value) public returns (bool success) {
85         require(balanceOf[msg.sender] >= _value);   
86         balanceOf[msg.sender] -= _value;            
87         totalSupply -= _value;                      
88         Burn(msg.sender, _value);
89         return true;
90     }
91 
92     function burnFrom(address _from, uint256 _value) public returns (bool success) {
93         require(balanceOf[_from] >= _value);               
94         require(_value <= allowance[_from][msg.sender]);  
95         balanceOf[_from] -= _value;                        
96         allowance[_from][msg.sender] -= _value;           
97         totalSupply -= _value;                             
98         Burn(_from, _value);
99         return true;
100     }
101 }
102 
103 /******************************************/
104 /*              CRYPHER Token             */
105 /******************************************/
106 
107 contract CrypherToken is owned, TokenERC20 {
108 
109     mapping (address => bool) public frozenAccount;
110 
111     event FrozenFunds(address target, bool frozen);
112 
113     function CrypherToken(
114         uint256 initialSupply,
115         string tokenName,
116         string tokenSymbol
117     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
118 
119     function _transfer(address _from, address _to, uint _value) internal {
120         require (_to != 0x0);                               
121         require (balanceOf[_from] > _value);                
122         require (balanceOf[_to] + _value > balanceOf[_to]); 
123         require(!frozenAccount[_from]);                     
124         require(!frozenAccount[_to]);                       
125         balanceOf[_from] -= _value;                         
126         balanceOf[_to] += _value;                           
127         Transfer(_from, _to, _value);
128     }
129 
130     function freezeAccount(address target, bool freeze) onlyOwner public {
131         frozenAccount[target] = freeze;
132         FrozenFunds(target, freeze);
133     }
134 
135     function distributeToken(uint _value, address[] addresses) onlyOwner {
136         for (uint i = 0; i < addresses.length; i++) {
137           require (addresses[i] != 0x0);   
138           require (balanceOf[msg.sender] > _value);              
139           require (balanceOf[addresses[i]] + _value > balanceOf[addresses[i]]);
140           balanceOf[msg.sender] -= _value;
141           balanceOf[addresses[i]] += _value;
142           Transfer(msg.sender, addresses[i], _value);
143         }
144     }
145 }