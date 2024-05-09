1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Galaxycoin {
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public initialSupply;
10     uint256 public totalSupply;
11 
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Burn(address indexed from, uint256 value);
16 
17     function Galaxycoin(
18     ) public {
19         name = "Galaxycoin";
20         symbol = "GLX";
21         decimals = 8;
22         initialSupply = 1000000000;
23         totalSupply = initialSupply * 10 ** uint256(decimals);  
24         balanceOf[msg.sender] = totalSupply;                
25     }
26 
27     function _transfer(address _from, address _to, uint _value) internal {
28         require(_to != 0x0);
29         require(balanceOf[_from] >= _value);
30         require(balanceOf[_to] + _value > balanceOf[_to]);
31         uint previousBalances = balanceOf[_from] + balanceOf[_to];
32         balanceOf[_from] -= _value;
33         balanceOf[_to] += _value;
34         Transfer(_from, _to, _value);
35         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
36     }
37 
38     /**
39      * @param _to The address of the recipient
40      * @param _value the amount to send
41      */
42     function transfer(address _to, uint256 _value) public {
43         _transfer(msg.sender, _to, _value);
44     }
45 
46     /**
47      * @param _from The address of the sender
48      * @param _to The address of the recipient
49      * @param _value the amount to send
50      */
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52         require(_value <= allowance[_from][msg.sender]);     
53         allowance[_from][msg.sender] -= _value;
54         _transfer(_from, _to, _value);
55         return true;
56     }
57 
58     /**
59      * @param _spender The address authorized to spend
60      * @param _value the max amount they can spend
61      */
62     function approve(address _spender, uint256 _value) public
63         returns (bool success) {
64         allowance[msg.sender][_spender] = _value;
65         return true;
66     }
67 
68     /**
69      * @param _spender The address authorized to spend
70      * @param _value the max amount they can spend
71      * @param _extraData some extra information to send to the approved contract
72      */
73     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
74         public
75         returns (bool success) {
76         tokenRecipient spender = tokenRecipient(_spender);
77         if (approve(_spender, _value)) {
78             spender.receiveApproval(msg.sender, _value, this, _extraData);
79             return true;
80         }
81     }
82 
83     /**
84      * @param _value the amount of money to burn
85      */
86     function burn(uint256 _value) public returns (bool success) {
87         require(balanceOf[msg.sender] >= _value);   
88         balanceOf[msg.sender] -= _value;            
89         totalSupply -= _value;                      
90         Burn(msg.sender, _value);
91         return true;
92     }
93 
94     /**
95      * @param _from the address of the sender
96      * @param _value the amount of money to burn
97      */
98     function burnFrom(address _from, uint256 _value) public returns (bool success) {
99         require(balanceOf[_from] >= _value);                
100         require(_value <= allowance[_from][msg.sender]);   
101         balanceOf[_from] -= _value;                         
102         allowance[_from][msg.sender] -= _value;             
103         totalSupply -= _value;                              
104         Burn(_from, _value);
105         return true;
106     }
107 }