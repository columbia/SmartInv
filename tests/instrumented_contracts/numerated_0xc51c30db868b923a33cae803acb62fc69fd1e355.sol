1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract TransferToken {
8   
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12    
13     uint256 public totalSupply;
14 
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21 
22     event Burn(address indexed from, uint256 value);
23 
24    
25     constructor(
26         uint256 initialSupply,
27         string memory tokenName,
28         string memory tokenSymbol
29     ) public {
30         totalSupply = initialSupply * 10 ** uint256(decimals);  
31         balanceOf[msg.sender] = totalSupply;  
32         name = tokenName;                       
33         symbol = tokenSymbol;                     
34     }
35 
36     
37     function _transfer(address _from, address _to, uint _value) internal {
38        
39         require(_to != address(0x0));
40        
41         require(balanceOf[_from] >= _value);
42        
43         require(balanceOf[_to] + _value >= balanceOf[_to]);
44         
45         uint previousBalances = balanceOf[_from] + balanceOf[_to];
46        
47         balanceOf[_from] -= _value;
48       
49         balanceOf[_to] += _value;
50         emit Transfer(_from, _to, _value);
51        
52         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
53     }
54 
55     
56     function transfer(address _to, uint256 _value) public returns (bool success) {
57         _transfer(msg.sender, _to, _value);
58         return true;
59     }
60 
61    
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
63         require(_value <= allowance[_from][msg.sender]);  
64         allowance[_from][msg.sender] -= _value;
65         _transfer(_from, _to, _value);
66         return true;
67     }
68 
69     
70     function approve(address _spender, uint256 _value) public
71         returns (bool success) {
72         allowance[msg.sender][_spender] = _value;
73         emit Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
78         public
79         returns (bool success) {
80         tokenRecipient spender = tokenRecipient(_spender);
81         if (approve(_spender, _value)) {
82             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
83             return true;
84         }
85     }
86 
87    
88     function burn(uint256 _value) public returns (bool success) {
89         require(balanceOf[msg.sender] >= _value);   
90         balanceOf[msg.sender] -= _value;        
91         totalSupply -= _value;                
92         emit Burn(msg.sender, _value);
93         return true;
94     }
95 
96     function burnFrom(address _from, uint256 _value) public returns (bool success) {
97         require(balanceOf[_from] >= _value);              
98         require(_value <= allowance[_from][msg.sender]);  
99         balanceOf[_from] -= _value;                       
100         allowance[_from][msg.sender] -= _value;         
101         totalSupply -= _value;                         
102         emit Burn(_from, _value);
103         return true;
104     }
105 }