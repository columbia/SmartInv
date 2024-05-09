1 pragma solidity 0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract EasyCoin {
6     
7     string public name;
8     string public symbol;
9     string public version = "1.0";
10     uint8 public decimals = 18;
11     uint256 public totalSupply;
12 
13     
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Burn(address indexed from, uint256 value);
20     event Mint(address indexed from, uint256 value);
21     
22     function EasyCoin(
23         uint256 initialSupply,
24         string tokenName,
25         string tokenSymbol
26     ) public {
27         totalSupply = initialSupply * 10 ** uint256(decimals);
28         balanceOf[msg.sender] = totalSupply;
29         name = tokenName;
30         symbol = tokenSymbol;
31     }
32 
33    
34     function _transfer(address _from, address _to, uint _value) internal {
35        
36         require(_to != 0x0);
37         require(balanceOf[_from] >= _value);
38         require(balanceOf[_to] + _value > balanceOf[_to]);
39         uint previousBalances = balanceOf[_from] + balanceOf[_to];
40         balanceOf[_from] -= _value;
41         balanceOf[_to] += _value;
42         Transfer(_from, _to, _value);
43         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
44     }
45 
46 
47     function transfer(address _to, uint256 _value) public {
48         _transfer(msg.sender, _to, _value);
49     }
50 
51 
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
53         require(_value <= allowance[_from][msg.sender]);
54         allowance[_from][msg.sender] -= _value;
55         _transfer(_from, _to, _value);
56         return true;
57     }
58 
59 
60     function approve(address _spender, uint256 _value) public
61         returns (bool success) {
62         allowance[msg.sender][_spender] = _value;
63         return true;
64     }
65 
66 
67     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
68         public
69         returns (bool success) {
70         tokenRecipient spender = tokenRecipient(_spender);
71         if (approve(_spender, _value)) {
72             spender.receiveApproval(msg.sender, _value, this, _extraData);
73             return true;
74         }
75     }
76 
77 
78     function burn(uint256 _value) public returns (bool success) {
79         require(balanceOf[msg.sender] >= _value);
80         balanceOf[msg.sender] -= _value;
81         totalSupply -= _value;
82         Burn(msg.sender, _value);
83         return true;
84     }
85 
86     function burnFrom(address _from, uint256 _value) public returns (bool success) {
87         require(balanceOf[_from] >= _value);
88         require(_value <= allowance[_from][msg.sender]);
89         balanceOf[_from] -= _value;
90         allowance[_from][msg.sender] -= _value;
91         totalSupply -= _value;
92         Burn(_from, _value);
93         return true;
94     }
95     
96     function mint (uint256 _value) public returns (bool success) {
97         require(balanceOf[msg.sender] >= _value);
98         balanceOf[msg.sender] +=_value;
99         totalSupply+=_value;
100         Mint(msg.sender, _value);
101         return true;
102     }
103 }