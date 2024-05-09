1 pragma solidity ^0.4.23;
2 
3 
4 contract owned {
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 }
16 
17 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
18 
19 contract Relotto is owned {
20     string public name;
21     string public symbol;
22     uint8 public decimals = 18;    
23     uint256 public totalSupply;
24     bool internal greenlight;
25     address public payer;
26 
27     
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30     mapping (address => bool) public holderpayed;
31 
32     
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 
37     event Payment(address indexed _payer, uint256 values);
38 
39     
40     constructor(
41         uint256 initialSupply,
42         string tokenName,
43         string tokenSymbol
44     ) public {
45         totalSupply = initialSupply * 10 ** uint256(decimals);  
46         balanceOf[msg.sender] = totalSupply;                
47         name = tokenName;                                   
48         symbol = tokenSymbol;
49         greenlight = false;
50         payer = msg.sender;
51     }
52 
53     function _transfer(address _from, address _to, uint _value) internal {
54        
55         require(_to != 0x0);
56         
57         require(balanceOf[_from] >= _value);
58         
59         require(balanceOf[_to] + _value > balanceOf[_to]);               
60         
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];
62         
63         balanceOf[_from] -= _value;
64         
65         balanceOf[_to] += _value;
66 
67         emit Transfer(_from, _to, _value);
68         
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71 
72     
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         _transfer(msg.sender, _to, _value);
75         return true;
76     }
77     
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
79         require(_value <= allowance[_from][msg.sender]);     
80         allowance[_from][msg.sender] -= _value;
81         _transfer(_from, _to, _value);
82         return true;
83     }
84    
85     function approve(address _spender, uint256 _value) public
86         returns (bool success) {
87         allowance[msg.sender][_spender] = _value;
88         emit Approval(msg.sender, _spender, _value);
89         return true;
90     }
91     
92     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
93         public
94         returns (bool success) {
95         tokenRecipient spender = tokenRecipient(_spender);
96         if (approve(_spender, _value)) {
97             spender.receiveApproval(msg.sender, _value, this, _extraData);
98             return true;
99         }
100     }
101 
102     function SetPayerAddress(address _payer) onlyOwner public
103         returns (bool success){
104         payer = _payer;
105         return true;
106     }
107 
108     function ApprovePayment() onlyOwner public
109         returns (bool success) {            
110         require(address(payer).balance > 0); 
111         greenlight = true;
112         emit Payment(payer,address(payer).balance);
113         return true;
114     }
115 
116     function EndofPayment() onlyOwner public
117         returns (bool success) {
118         greenlight = false;
119         return true;
120     }
121 
122     function RequestPayment(address _holder) public {
123         address myAddress = payer;
124         require(greenlight);
125         require(!holderpayed[_holder]);              
126         _holder.transfer(balanceOf[_holder] * myAddress.balance / totalSupply);
127         holderpayed[_holder] = true;          
128     }
129 
130     function ReNew(address _holder) public {
131         require(!greenlight);
132         require(holderpayed[_holder]);
133         holderpayed[_holder] = false;
134     }
135 }