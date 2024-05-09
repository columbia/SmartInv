1 pragma solidity 0.4.21;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;}
4 
5 contract LifeChain {
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
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Burn(address indexed from, uint256 value);
19     
20     function LifeChain(
21         uint256 initialSupply,
22         string tokenName,
23         string tokenSymbol
24     ) public {
25         totalSupply = initialSupply * 10 ** uint256(decimals);
26         balanceOf[msg.sender] = totalSupply;
27         name = tokenName;
28         symbol = tokenSymbol;
29     }
30 
31    
32     function _transfer(address _from, address _to, uint _value) internal {
33        
34         require(_to != 0x0);
35         require(balanceOf[_from] >= _value);
36         require(balanceOf[_to] + _value > balanceOf[_to]);
37         uint previousBalances = balanceOf[_from] + balanceOf[_to];
38         balanceOf[_from] -= _value;
39         balanceOf[_to] += _value;
40         emit Transfer(_from, _to, _value);
41         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
42     }
43 
44 
45     function transfer(address _to, uint256 _value) public {
46         _transfer(msg.sender, _to, _value);
47     }
48 
49 
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         require(_value <= allowance[_from][msg.sender]);
52         allowance[_from][msg.sender] -= _value;
53         _transfer(_from, _to, _value);
54         return true;
55     }
56 
57 
58     function approve(address _spender, uint256 _value) public
59         returns (bool success) {
60         allowance[msg.sender][_spender] = _value;
61         return true;
62     }
63 
64 
65     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
66         public
67         returns (bool success) {
68         tokenRecipient spender = tokenRecipient(_spender);
69         if (approve(_spender, _value)) {
70             spender.receiveApproval(msg.sender, _value, this, _extraData);
71             return true;
72         }
73     }
74 
75 
76     function burn(uint256 _value) public returns (bool success) {
77         require(balanceOf[msg.sender] >= _value);
78         balanceOf[msg.sender] -= _value;
79         totalSupply -= _value;
80         emit Burn(msg.sender, _value);
81         return true;
82     }
83 
84     function burnFrom(address _from, uint256 _value) public returns (bool success) {
85         require(balanceOf[_from] >= _value);
86         require(_value <= allowance[_from][msg.sender]);
87         balanceOf[_from] -= _value;
88         allowance[_from][msg.sender] -= _value;
89         totalSupply -= _value;
90         emit Burn(_from, _value);
91         return true;
92     }
93     
94 }