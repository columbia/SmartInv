1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract OKK {
8     string public name;
9     string public symbol;
10     uint8 public decimals = 18;
11     uint256 public totalSupply;
12 
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20     event Burn(address indexed from, uint256 value);
21 
22 
23     constructor(
24         uint256 initialSupply,
25         string memory tokenName,
26         string memory tokenSymbol
27     ) public {
28         totalSupply = initialSupply * 10 ** uint256(decimals);  
29         balanceOf[msg.sender] = totalSupply;                
30         name = tokenName;                                   
31         symbol = tokenSymbol;                               
32     }
33 
34 
35     function _transfer(address _from, address _to, uint _value) internal {
36         
37         require(_to != address(0x0));
38         require(balanceOf[_from] >= _value);
39         require(balanceOf[_to] + _value >= balanceOf[_to]);
40         uint previousBalances = balanceOf[_from] + balanceOf[_to];
41         balanceOf[_from] -= _value;
42         balanceOf[_to] += _value;
43         emit Transfer(_from, _to, _value);
44         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
45     }
46 
47 
48     function transfer(address _to, uint256 _value) public returns (bool success) {
49         _transfer(msg.sender, _to, _value);
50         return true;
51     }
52 
53 
54     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
55         require(_value <= allowance[_from][msg.sender]);    
56         allowance[_from][msg.sender] -= _value;
57         _transfer(_from, _to, _value);
58         return true;
59     }
60 
61     function approve(address _spender, uint256 _value) public
62         returns (bool success) {
63         allowance[msg.sender][_spender] = _value;
64         emit Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68 
69     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
70         public
71         returns (bool success) {
72         tokenRecipient spender = tokenRecipient(_spender);
73         if (approve(_spender, _value)) {
74             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
75             return true;
76         }
77     }
78 
79 
80     function burn(uint256 _value) public returns (bool success) {
81         require(balanceOf[msg.sender] >= _value);   
82         balanceOf[msg.sender] -= _value;           
83         totalSupply -= _value;                     
84         emit Burn(msg.sender, _value);
85         return true;
86     }
87 
88 
89     function burnFrom(address _from, uint256 _value) public returns (bool success) {
90         require(balanceOf[_from] >= _value);                
91         require(_value <= allowance[_from][msg.sender]);    
92         balanceOf[_from] -= _value;                         
93         allowance[_from][msg.sender] -= _value;            
94         totalSupply -= _value;                            
95         emit Burn(_from, _value);
96         return true;
97     }
98 }