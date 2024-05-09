1 pragma solidity ^0.4.16;
2 
3 // ----------------------------------------------------------------------------
4 // 'Airdroop' token contract
5 //
6 // Deployed to : 0xa6029cd93aaf9115db0360c748adf3b77f42d1b6
7 // Symbol      : ADOP
8 // Name        : Airdroop
9 // Total supply: 1000000000
10 // Decimals    : 2
11 // Copyto      :1000000000,"Airdroop","ADOP"
12 // Enjoy.
13 //
14 // (c) Airdroop 2018. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
19 
20 contract TokenERC20 {
21     string public name;
22     string public symbol;
23     uint8 public decimals = 2;  // 18 as default
24     uint256 public totalSupply;
25 
26     mapping (address => uint256) public balanceOf;  // 
27     mapping (address => mapping (address => uint256)) public allowance;
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     event Burn(address indexed from, uint256 value);
32 
33 
34     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
35         totalSupply = initialSupply * 10 ** uint256(decimals);
36         balanceOf[msg.sender] = totalSupply;
37         name = tokenName;
38         symbol = tokenSymbol;
39     }
40 
41 
42     function _transfer(address _from, address _to, uint _value) internal {
43         require(_to != 0x0);
44         require(balanceOf[_from] >= _value);
45         require(balanceOf[_to] + _value > balanceOf[_to]);
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         balanceOf[_from] -= _value;
48         balanceOf[_to] += _value;
49         Transfer(_from, _to, _value);
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52 
53     function transfer(address _to, uint256 _value) public {
54         _transfer(msg.sender, _to, _value);
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(_value <= allowance[_from][msg.sender]);     // Check allowance
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function approve(address _spender, uint256 _value) public
65         returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         return true;
68     }
69 
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
71         tokenRecipient spender = tokenRecipient(_spender);
72         if (approve(_spender, _value)) {
73             spender.receiveApproval(msg.sender, _value, this, _extraData);
74             return true;
75         }
76     }
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
95 }