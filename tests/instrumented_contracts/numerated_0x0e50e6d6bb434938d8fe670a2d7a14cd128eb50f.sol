1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenERC20 {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 9;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16     event Burn(address indexed from, uint256 value);
17 
18     constructor(
19         uint256 initialSupply,
20         string tokenName,
21         string tokenSymbol
22     ) public {
23         totalSupply = initialSupply * 10 ** uint256(decimals);
24         balanceOf[msg.sender] = totalSupply;
25         name = tokenName;
26         symbol = tokenSymbol;
27     }
28 
29     function _transfer(address _from, address _to, uint _value) internal {
30         require(_to != 0x0);
31         require(balanceOf[_from] >= _value);
32         require(balanceOf[_to] + _value >= balanceOf[_to]);
33         uint previousBalances = balanceOf[_from] + balanceOf[_to];
34         balanceOf[_from] -= _value;
35         balanceOf[_to] += _value;
36         emit Transfer(_from, _to, _value);
37         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
38     }
39 
40     function transfer(address _to, uint256 _value) public returns (bool success) {
41         _transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
46         require(_value <= allowance[_from][msg.sender]); 
47         allowance[_from][msg.sender] -= _value;
48         _transfer(_from, _to, _value);
49         return true;
50     }
51 
52     function approve(address _spender, uint256 _value) public
53         returns (bool success) {
54         allowance[msg.sender][_spender] = _value;
55         emit Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
60         public
61         returns (bool success) {
62         tokenRecipient spender = tokenRecipient(_spender);
63         if (approve(_spender, _value)) {
64             spender.receiveApproval(msg.sender, _value, this, _extraData);
65             return true;
66         }
67     }
68 
69     function burn(uint256 _value) public returns (bool success) {
70         require(balanceOf[msg.sender] >= _value);
71         balanceOf[msg.sender] -= _value;          
72         totalSupply -= _value;                     
73         emit Burn(msg.sender, _value);
74         return true;
75     }
76 
77     function burnFrom(address _from, uint256 _value) public returns (bool success) {
78         require(balanceOf[_from] >= _value);             
79         require(_value <= allowance[_from][msg.sender]);   
80         balanceOf[_from] -= _value;                        
81         allowance[_from][msg.sender] -= _value;             
82         totalSupply -= _value;                              
83         emit Burn(_from, _value);
84         return true;
85     }
86 }