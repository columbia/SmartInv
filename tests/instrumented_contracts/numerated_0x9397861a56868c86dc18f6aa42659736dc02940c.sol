1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
5 }
6 
7 contract GlobalNetworkToken {
8 
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12     uint256 public totalSupply;
13 
14 
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     
21 
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 
24 
25     event Burn(address indexed from, uint256 value);
26 
27    
28     constructor(
29         uint256 initialSupply,
30         string memory tokenName,
31         string memory tokenSymbol
32     ) public {
33         totalSupply = initialSupply * 10 ** uint256(decimals);  
34         balanceOf[msg.sender] = totalSupply;                
35         name = tokenName;                                   
36         symbol = tokenSymbol;                               
37     }
38 
39    
40     function _transfer(address _from, address _to, uint _value) internal {
41        
42         require(_to != address(0x0));
43    
44         require(balanceOf[_from] >= _value);
45 
46         require(balanceOf[_to] + _value >= balanceOf[_to]);
47 
48         uint previousBalances = balanceOf[_from] + balanceOf[_to];
49     
50         balanceOf[_from] -= _value;
51     
52         balanceOf[_to] += _value;
53         emit Transfer(_from, _to, _value);
54        
55         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
56     }
57 
58     
59     function transfer(address _to, uint256 _value) public returns (bool success) {
60         _transfer(msg.sender, _to, _value);
61         return true;
62     }
63 
64     
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         require(_value <= allowance[_from][msg.sender]);     
67         allowance[_from][msg.sender] -= _value;
68         _transfer(_from, _to, _value);
69         return true;
70     }
71 
72    
73     function approve(address _spender, uint256 _value) public
74         returns (bool success) {
75         allowance[msg.sender][_spender] = _value;
76         emit Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     
81     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
82         public
83         returns (bool success) {
84         tokenRecipient spender = tokenRecipient(_spender);
85         if (approve(_spender, _value)) {
86             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
87             return true;
88         }
89     }
90 
91     
92     function burn(uint256 _value) public returns (bool success) {
93         require(balanceOf[msg.sender] >= _value);   
94         balanceOf[msg.sender] -= _value;            
95         totalSupply -= _value;                     
96         emit Burn(msg.sender, _value);
97         return true;
98     }
99 
100     
101     function burnFrom(address _from, uint256 _value) public returns (bool success) {
102         require(balanceOf[_from] >= _value);                
103         require(_value <= allowance[_from][msg.sender]);    
104         balanceOf[_from] -= _value;                         
105         allowance[_from][msg.sender] -= _value;             
106         totalSupply -= _value;                             
107         emit Burn(_from, _value);
108         return true;
109     }
110 }