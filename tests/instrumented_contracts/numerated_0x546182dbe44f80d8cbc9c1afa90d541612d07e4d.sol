1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract owned {
6     address public owner;
7 
8     function owned() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     
18     function transferOwnership(address newOwner) onlyOwner {
19         owner = newOwner;
20     }
21 }
22 
23 
24 contract iCarChain is owned {
25     string public name;
26     string public symbol;
27     uint8 public decimals = 18;  
28     uint256 public totalSupply;
29 
30     mapping (address => uint256) public balanceOf;   
31     mapping (address => mapping (address => uint256)) public allowance;
32     mapping (address => bool) public frozenAccount;
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Burn(address indexed from, uint256 value);
37 
38     event FrozenFunds(address target, bool frozen);
39 	
40 	event Approval(address indexed owner, address indexed spender, uint256 value);
41 
42     function iCarChain(uint256 initialSupply, string tokenName, string tokenSymbol) public {
43         totalSupply = initialSupply * 10 ** uint256(decimals);
44         balanceOf[msg.sender] = totalSupply;
45         name = tokenName;
46         symbol = tokenSymbol;
47         
48     }
49 
50     function _transfer(address _from, address _to, uint _value) internal {
51         require(_to != 0x0);
52         require(balanceOf[_from] >= _value);
53         require(balanceOf[_to] + _value > balanceOf[_to]);
54         uint previousBalances = balanceOf[_from] + balanceOf[_to];
55         balanceOf[_from] -= _value;
56         balanceOf[_to] += _value;
57         Transfer(_from, _to, _value);
58         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
59     }
60 
61     function transfer(address _to, uint256 _value) public returns (bool success) {
62         require(!frozenAccount[msg.sender]);
63         _transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
68         require(_value <= allowance[_from][msg.sender]);     // Check allowance
69         allowance[_from][msg.sender] -= _value;
70         _transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function approve(address _spender, uint256 _value) onlyOwner
75         returns (bool success) {
76         require(!frozenAccount[msg.sender]);
77         allowance[msg.sender][_spender] = _value;
78         Approval(msg.sender,_spender,_value);
79         return true;
80     }
81 
82     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
83         tokenRecipient spender = tokenRecipient(_spender);
84         if (approve(_spender, _value)) {
85             spender.receiveApproval(msg.sender, _value, this, _extraData);
86             return true;
87         }
88     }
89 
90     function burn(uint256 _value) onlyOwner returns (bool success) {
91         require(balanceOf[msg.sender] >= _value);
92         balanceOf[msg.sender] -= _value;
93         totalSupply -= _value;
94         Burn(msg.sender, _value);
95         return true;
96     }
97 
98     function burnFrom(address _from, uint256 _value) returns (bool success) {
99         require(balanceOf[_from] >= _value);
100         require(_value <= allowance[_from][msg.sender]);
101         balanceOf[_from] -= _value;
102         allowance[_from][msg.sender] -= _value;
103         totalSupply -= _value;
104         Burn(_from, _value);
105         return true;
106     }
107     
108     function freezeAccount(address target, bool freeze) onlyOwner {
109     frozenAccount[target] = freeze;
110     FrozenFunds(target, freeze);
111     }
112 
113 }