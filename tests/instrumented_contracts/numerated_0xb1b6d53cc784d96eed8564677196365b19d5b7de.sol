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
22 contract Erc20 {
23 
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     uint256 public totalSupply;
28 
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     event Burn(address indexed from, uint256 value);
35 
36     function Erc20(
37         uint256 initialSupply,
38         string tokenName,
39         string tokenSymbol
40     ) public {
41         totalSupply = initialSupply * 10 ** uint256(decimals);  
42         balanceOf[msg.sender] = totalSupply;                
43         name = tokenName;                                   
44         symbol = tokenSymbol;                               
45     }
46 
47    
48     function _transfer(address _from, address _to, uint _value) internal {
49 
50         require(_to != 0x0);
51         require(balanceOf[_from] >= _value);
52         require(balanceOf[_to] + _value > balanceOf[_to]);
53         uint previousBalances = balanceOf[_from] + balanceOf[_to];
54         balanceOf[_from] -= _value;
55         balanceOf[_to] += _value;
56         Transfer(_from, _to, _value);
57         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
58     }
59 
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
65         require(_value <= allowance[_from][msg.sender]);     // Check allowance
66         allowance[_from][msg.sender] -= _value;
67         _transfer(_from, _to, _value);
68         return true;
69     }
70 
71     function approve(address _spender, uint256 _value) public
72         returns (bool success) {
73         allowance[msg.sender][_spender] = _value;
74         return true;
75     }
76 
77     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
78         public
79         returns (bool success) {
80         tokenRecipient spender = tokenRecipient(_spender);
81         if (approve(_spender, _value)) {
82             spender.receiveApproval(msg.sender, _value, this, _extraData);
83             return true;
84         }
85     }
86 
87     function burn(uint256 _value) public returns (bool success) {
88         require(balanceOf[msg.sender] >= _value);   
89         balanceOf[msg.sender] -= _value;            
90         totalSupply -= _value;                      
91         Burn(msg.sender, _value);
92         return true;
93     }
94 
95     function burnFrom(address _from, uint256 _value) public returns (bool success) {
96         require(balanceOf[_from] >= _value);               
97         require(_value <= allowance[_from][msg.sender]);    
98         balanceOf[_from] -= _value;                         
99         allowance[_from][msg.sender] -= _value;         
100         totalSupply -= _value;                             
101         Burn(_from, _value);
102         return true;
103     }
104 }
105 
106 contract CrypherToken is owned, Erc20 {
107    function CrypherToken(
108         uint256 initialSupply,
109         string tokenName,
110         string tokenSymbol
111     ) Erc20(initialSupply, tokenName, tokenSymbol) public {}
112 
113     function _transfer(address _from, address _to, uint _value) internal {
114         require (_to != 0x0);                               
115         require (balanceOf[_from] > _value);                
116         require (balanceOf[_to] + _value > balanceOf[_to]); 
117         balanceOf[_from] -= _value;                         
118         balanceOf[_to] += _value;                           
119         Transfer(_from, _to, _value);
120     }
121 
122      function distributeToken(uint _value, address[] addresses) onlyOwner {
123         for (uint i = 0; i < addresses.length; i++) {
124           require (addresses[i] != 0x0);   
125           require (balanceOf[msg.sender] > _value);              
126           require (balanceOf[addresses[i]] + _value > balanceOf[addresses[i]]);
127           balanceOf[msg.sender] -= _value;
128           balanceOf[addresses[i]] += _value;
129           Transfer(msg.sender, addresses[i], _value);
130         }
131       }
132 }