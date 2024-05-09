1 pragma solidity ^0.4.8;
2 contract tokenRecipient { 
3 	//获得批准
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
5 }
6 
7 contract QZG001TOKEN{
8    
9     string public standard = 'QZG001TOKEN 0.1';
10     string public name;
11     string public symbol;
12     uint8 public decimals;
13     uint256 public totalSupply;
14 
15    
16     mapping (address => uint256) public balanceOf;
17   
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23    
24     event Burn(address indexed from, uint256 value);
25 
26     
27     function QZG001TOKEN() public {
28         balanceOf[msg.sender] = 1000000 * 1000000000000000000;             
29         totalSupply =  1000000 * 1000000000000000000;                       
30         name = "QZC001";                                   // Set the name 	for display purposes
31         symbol = "QZGC";                               // Set the symbol for display 	purposes
32         decimals = 18;                            // Amount of decimals for display 	purposes
33     }
34 
35     /* Send coins */
36     function transfer(address _to, uint256 _value) public {
37        
38          require (_to != 0x0);
39          require(balanceOf[msg.sender] >= _value);
40          require(balanceOf[_to] + _value > balanceOf[_to]);
41     
42         balanceOf[msg.sender] -= _value;                    
43         balanceOf[_to] += _value;                           
44         Transfer(msg.sender, _to, _value);            
45     }
46 
47     /* Allow another contract to spend some tokens in your behalf  */
48     function approve(address _spender, uint256 _value) public returns (bool success) {
49         
50      
51         allowance[msg.sender][_spender] = _value;
52         return true;
53     }
54 
55     /* Approve and then communicate the approved contract in a single tx  */
56     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public 
57         returns (bool success) {
58         tokenRecipient spender = tokenRecipient(_spender);
59         if (approve(_spender, _value)) {
60             spender.receiveApproval(msg.sender, _value, this, _extraData);
61             return true;
62         }
63     }
64 
65     /* A contract attempts to get the coins  */
66     function transferFrom(address _from, address _to, uint256 _value) public
67     returns (bool success) {
68        
69     
70         require (_to != 0x0);
71          require(balanceOf[_from] >= _value);
72          require(balanceOf[_to] + _value > balanceOf[_to]);
73          require(_value <= allowance[_from][msg.sender]);
74         balanceOf[_from] -= _value;                           // Subtract from the sender
75         balanceOf[_to] += _value;                             // Add the same to the recipient
76         allowance[_from][msg.sender] -= _value;
77         Transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function burn(uint256 _value) public returns (bool success) {
82        
83        require(balanceOf[msg.sender] >= _value);
84         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
85         totalSupply -= _value;                                // Updates totalSupply
86         Burn(msg.sender, _value);
87         return true;
88     }
89 
90     function burnFrom(address _from, uint256 _value) public returns (bool success) {
91        
92      
93         require(balanceOf[_from] >= _value);
94         require(_value <= allowance[_from][msg.sender]);
95         balanceOf[_from] -= _value;                          // Subtract from the sender
96         totalSupply -= _value;                               // Updates totalSupply
97         Burn(_from, _value);
98         return true;
99     }
100 }