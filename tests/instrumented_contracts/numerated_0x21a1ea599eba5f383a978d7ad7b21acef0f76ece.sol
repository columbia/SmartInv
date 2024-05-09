1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract PouyanCoin {
8     string public name = 'PouyanToken';
9     string public symbol = 'PURC';
10     uint8 public decimals = 0;
11     uint256 public totalSupply;
12 
13 
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 
21     event Burn(address indexed from, uint256 value);
22     constructor(
23         uint256 initialSupply,
24         string memory tokenName,
25         string memory tokenSymbol
26     ) public {
27         totalSupply = initialSupply * 10 ** uint256(decimals);  
28         balanceOf[msg.sender] = 4500000000;                
29         name = tokenName;                                   
30         symbol = tokenSymbol;                           
31     }
32 
33     function _transfer(address _from, address _to, uint _value) internal {
34         require(_to != address(0x0));
35         require(balanceOf[_from] >= _value);
36         require(balanceOf[_to] + _value >= balanceOf[_to]);
37         uint previousBalances = balanceOf[_from] + balanceOf[_to];
38         balanceOf[_from] -= _value;
39         balanceOf[_to] += _value;
40         emit Transfer(_from, _to, _value);
41         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
42     }
43 
44     function transfer(address _to, uint256 _value) public returns (bool success) {
45         _transfer(msg.sender, _to, _value);
46         return true;
47     }
48 
49 
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         require(_value <= allowance[_from][msg.sender]);     // Check allowance
52         allowance[_from][msg.sender] -= _value;
53         _transfer(_from, _to, _value);
54         return true;
55     }
56 
57     function approve(address _spender, uint256 _value) public
58         returns (bool success) {
59         allowance[msg.sender][_spender] = _value;
60         emit Approval(msg.sender, _spender, _value);
61         return true;
62     }
63 
64     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
65         public
66         returns (bool success) {
67         tokenRecipient spender = tokenRecipient(_spender);
68         if (approve(_spender, _value)) {
69             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
70             return true;
71         }
72     }
73 
74     function burn(uint256 _value) public returns (bool success) {
75         require(balanceOf[msg.sender] >= _value);   
76         balanceOf[msg.sender] -= _value;            
77         totalSupply -= _value;                      
78         emit Burn(msg.sender, _value);
79         return true;
80     }
81 
82     function burnFrom(address _from, uint256 _value) public returns (bool success) {
83         require(balanceOf[_from] >= _value);                
84         require(_value <= allowance[_from][msg.sender]);    
85         balanceOf[_from] -= _value;                         
86         allowance[_from][msg.sender] -= _value;             
87         totalSupply -= _value;                              
88         emit Burn(_from, _value);
89         return true;
90     }
91 }