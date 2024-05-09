1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract XSD {
8     string public name;
9     string public symbol;
10     uint8 public decimals = 18;
11     uint256 public totalSupply;
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18     event Burn(address indexed from, uint256 value);
19 
20     constructor(
21         uint256 initialSupply,
22         string memory tokenName,
23         string memory tokenSymbol
24     ) public {
25         totalSupply = initialSupply * 10 ** uint256(decimals);  
26         balanceOf[msg.sender] = totalSupply;                
27         name = tokenName;                                   
28         symbol = tokenSymbol;                              
29     }
30 
31     function _transfer(address _from, address _to, uint _value) internal {
32         require(_to != address(0x0));
33         require(balanceOf[_from] >= _value);
34         require(balanceOf[_to] + _value >= balanceOf[_to]);
35         uint previousBalances = balanceOf[_from] + balanceOf[_to];
36         balanceOf[_from] -= _value;
37         balanceOf[_to] += _value;
38         emit Transfer(_from, _to, _value);
39         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
40     }
41 
42 
43     function transfer(address _to, uint256 _value) public returns (bool success) {
44         _transfer(msg.sender, _to, _value);
45         return true;
46     }
47 
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
49         require(_value <= allowance[_from][msg.sender]);     
50         allowance[_from][msg.sender] -= _value;
51         _transfer(_from, _to, _value);
52         return true;
53     }
54 
55     function approve(address _spender, uint256 _value) public
56         returns (bool success) {
57         allowance[msg.sender][_spender] = _value;
58         emit Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
63         public
64         returns (bool success) {
65         tokenRecipient spender = tokenRecipient(_spender);
66         if (approve(_spender, _value)) {
67             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
68             return true;
69         }
70     }
71 
72     function burn(uint256 _value) public returns (bool success) {
73         require(balanceOf[msg.sender] >= _value);   
74         balanceOf[msg.sender] -= _value;            
75         totalSupply -= _value;                      
76         emit Burn(msg.sender, _value);
77         return true;
78     }
79 
80     function burnFrom(address _from, uint256 _value) public returns (bool success) {
81         require(balanceOf[_from] >= _value);                
82         require(_value <= allowance[_from][msg.sender]);    
83         balanceOf[_from] -= _value;                         
84         allowance[_from][msg.sender] -= _value;             
85         totalSupply -= _value;                              
86         emit Burn(_from, _value);
87         return true;
88     }
89 }