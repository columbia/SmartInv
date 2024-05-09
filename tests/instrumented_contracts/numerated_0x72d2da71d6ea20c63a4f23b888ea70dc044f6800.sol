1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenERC20 {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18     event Burn(address indexed from, uint256 value);
19 
20 
21     function TokenERC20(
22         uint256 initialSupply,
23         string tokenName,
24         string tokenSymbol
25     ) public {
26         totalSupply = initialSupply * 10 ** uint256(decimals);   
27         balanceOf[msg.sender] = totalSupply;                 
28         name = tokenName;                                    
29         symbol = tokenSymbol;                                
30     }
31 
32 
33     function _transfer(address _from, address _to, uint _value) internal {
34         // Prevent transfer to 0x0 address. Use burn() instead
35         require(_to != 0x0);
36         // Check if the sender has enough
37         require(balanceOf[_from] >= _value);
38         // Check for overflows
39         require(balanceOf[_to] + _value >= balanceOf[_to]);
40         // Save this for an assertion in the future
41         uint previousBalances = balanceOf[_from] + balanceOf[_to];
42         // Subtract from the sender
43         balanceOf[_from] -= _value;
44         // Add the same to the recipient
45         balanceOf[_to] += _value;
46         emit Transfer(_from, _to, _value);
47         // Asserts are used to use static analysis to find bugs in your code. They should never fail
48         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
49     }
50 
51 
52     function transfer(address _to, uint256 _value) public returns (bool success) {
53         _transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57 
58     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
59         require(_value <= allowance[_from][msg.sender]);     // Check allowance
60         allowance[_from][msg.sender] -= _value;
61         _transfer(_from, _to, _value);
62         return true;
63     }
64 
65 
66     function approve(address _spender, uint256 _value) public
67         returns (bool success) {
68         allowance[msg.sender][_spender] = _value;
69         emit Approval(msg.sender, _spender, _value);
70         return true;
71     }
72 
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
84 
85     function burn(uint256 _value) public returns (bool success) {
86         require(balanceOf[msg.sender] >= _value);    
87         balanceOf[msg.sender] -= _value;             
88         totalSupply -= _value;                       
89         emit Burn(msg.sender, _value);
90         return true;
91     }
92 
93     function burnFrom(address _from, uint256 _value) public returns (bool success) {
94         require(balanceOf[_from] >= _value);                 
95         require(_value <= allowance[_from][msg.sender]);     
96         balanceOf[_from] -= _value;                          
97         allowance[_from][msg.sender] -= _value;              
98         totalSupply -= _value;                               
99         emit Burn(_from, _value);
100         return true;
101     }
102 }