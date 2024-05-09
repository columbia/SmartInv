1 pragma solidity ^0.4.19;
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
23    
24     string public name;
25     string public symbol;
26     uint8 public decimals = 8;
27     uint256 public totalSupply;
28 
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
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
62         require(_value <= allowance[_from][msg.sender]);     // Check allowance
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
83     function burn(uint256 _value) public returns (bool success) {
84         require(balanceOf[msg.sender] >= _value);   
85         balanceOf[msg.sender] -= _value;            
86         totalSupply -= _value;                      
87         Burn(msg.sender, _value);
88         return true;
89     }
90 
91     function burnFrom(address _from, uint256 _value) public returns (bool success) {
92         require(balanceOf[_from] >= _value);                
93         require(_value <= allowance[_from][msg.sender]);    
94         balanceOf[_from] -= _value;                         
95         allowance[_from][msg.sender] -= _value;             
96         totalSupply -= _value;                              
97         Burn(_from, _value);
98         return true;
99     }
100 }
101 
102 contract OnlineExpoToken is owned, TokenERC20 {
103 
104     mapping (address => bool) public frozenAccount;
105 
106     event FrozenFunds(address target, bool frozen);
107 
108     function OnlineExpoToken(
109         uint256 initialSupply,
110         string tokenName,
111         string tokenSymbol
112     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
113     }
114 
115     function _transfer(address _from, address _to, uint _value) internal {
116         require (_to != 0x0);                               
117         require (balanceOf[_from] >= _value);               
118         require (balanceOf[_to] + _value > balanceOf[_to]); 
119         require(!frozenAccount[_from]);                     
120         require(!frozenAccount[_to]);                       
121         balanceOf[_from] -= _value;                         
122         balanceOf[_to] += _value;                           
123         Transfer(_from, _to, _value);
124     }
125 
126     function freezeAccount(address target, bool freeze) onlyOwner public {
127         frozenAccount[target] = freeze;
128         FrozenFunds(target, freeze);
129     }
130 }