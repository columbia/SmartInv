1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract NewDogg {
8     
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12   
13     uint256 public totalSupply;
14 
15     
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19   
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     
22    
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 
25    
26     event Burn(address indexed from, uint256 value);
27 
28    
29     constructor(
30         uint256 initialSupply,
31         string memory tokenName,
32         string memory tokenSymbol
33     ) public {
34         totalSupply = initialSupply * 10 ** uint256(decimals);  
35         balanceOf[msg.sender] = totalSupply;                
36         name = tokenName;                                  
37         symbol = tokenSymbol;                               
38     }
39 
40    
41     function _transfer(address _from, address _to, uint _value) internal {
42         
43         require(_to != address(0x0));
44        
45         require(balanceOf[_from] >= _value);
46        
47         require(balanceOf[_to] + _value >= balanceOf[_to]);
48         
49         uint previousBalances = balanceOf[_from] + balanceOf[_to];
50        
51         balanceOf[_from] -= _value;
52         
53         balanceOf[_to] += _value;
54         emit Transfer(_from, _to, _value);
55         
56         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
57     }
58 
59   
60     function transfer(address _to, uint256 _value) public returns (bool success) {
61         _transfer(msg.sender, _to, _value);
62         return true;
63     }
64 
65     
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
67         require(_value <= allowance[_from][msg.sender]);     
68         allowance[_from][msg.sender] -= _value;
69         _transfer(_from, _to, _value);
70         return true;
71     }
72 
73    
74     function approve(address _spender, uint256 _value) public
75         returns (bool success) {
76         allowance[msg.sender][_spender] = _value;
77         emit Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81    
82     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
83         public
84         returns (bool success) {
85         tokenRecipient spender = tokenRecipient(_spender);
86         if (approve(_spender, _value)) {
87             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
88             return true;
89         }
90     }
91 
92    
93     function burn(uint256 _value) public returns (bool success) {
94         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
95         balanceOf[msg.sender] -= _value;            // Subtract from the sender
96         totalSupply -= _value;                      // Updates totalSupply
97         emit Burn(msg.sender, _value);
98         return true;
99     }
100 
101    
102     function burnFrom(address _from, uint256 _value) public returns (bool success) {
103         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
104         require(_value <= allowance[_from][msg.sender]);    // Check allowance
105         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
106         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
107         totalSupply -= _value;                              // Update totalSupply
108         emit Burn(_from, _value);
109         return true;
110     }
111 }