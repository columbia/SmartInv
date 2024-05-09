1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'GPYX' token contract
5 //
6 // Deployed to : 0x6610F23DfC2a3DD959460c8EC04260629F55D28D
7 // Symbol      : GPYX
8 // Name        : PyrexCoin Platform service token
9 // Total supply: 10000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by ILIK. 
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 interface tokenRecipient {function receiveApproval (address _from, uint256 _value, address _token, bytes _extradata) external;}
22 contract owned {
23     address public owner;
24     
25     constructor()public {
26         owner = msg.sender;
27     }
28     
29     modifier onlyOwner {
30         require(msg.sender == owner);
31         _;
32         
33     }
34     function transferOwnership (address newOwner)public onlyOwner {
35         owner = newOwner;
36     }
37     
38 }
39 contract GPYX is owned{
40  string public Name;
41  string public Symbol;
42  uint8 public decimals = 18;  
43  uint256 public totalSupply;
44  mapping (address => uint256) public balanceOf;
45  mapping(address => mapping(address=> uint256)) public allowance;
46  mapping(address => bool) public frozenAccount;
47  
48  
49  event Transfer ( address indexed from, address indexed to, uint256 value);
50  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51  event Burn(address indexed from, uint256 value);
52  event FrozenFunds(address target, bool frozen);
53  
54     constructor (
55         uint256 initialSupply,
56         string tokenName,
57         string tokenSymbol
58         ) public {
59             totalSupply = initialSupply*10**uint256(decimals);
60             balanceOf[msg.sender] = totalSupply;
61             Name = tokenName;
62             Symbol = tokenSymbol;
63             
64         }
65         function _transfer(address _from, address _to, uint _value) internal{
66             require(_to != 0x0);
67             require(balanceOf[_from] >=_value);
68             require(balanceOf[_to] +_value >= balanceOf[_to]);
69             require(!frozenAccount[msg.sender]);
70             
71             uint previousBalances = balanceOf[_from ] + balanceOf[_to];
72             
73             balanceOf[_from] -= _value;
74             balanceOf[_to] += _value;
75             emit Transfer (_from, _to, _value);
76             assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
77             
78         }
79         function transfer(address _to, uint256 _value) public returns (bool success) {
80             _transfer(msg.sender, _to, _value);
81             return true;
82             
83         }
84         
85         function trasferFrom (address _from, address _to, uint256 _value) public returns(bool success)
86         {
87             
88             require(_value <=allowance[_from][msg.sender]);
89             allowance[_from][msg.sender] -=_value;
90             _transfer(_from,_to, _value);
91             return true;
92             
93         }
94         function approve (address _spender, uint256 _value) onlyOwner public
95         returns (bool success){
96             allowance[msg.sender][_spender] = _value;
97             emit Approval(msg.sender, _spender, _value);
98             return true;
99             
100         }
101         
102         function approveAndCall(address _spender, uint256 _value, bytes _extradata) public returns (bool success){
103             tokenRecipient spender = tokenRecipient(_spender);
104             
105             if(approve(_spender,_value)){
106                 spender.receiveApproval(msg.sender, _value, this, _extradata);
107                 return true;
108             }
109             
110         }
111         function burn (uint256 _value) onlyOwner public returns (bool success){
112             require(balanceOf[msg.sender] >= _value);
113             balanceOf[msg.sender] -= _value;
114             totalSupply -= _value;
115             emit Burn(msg.sender, _value);
116             return true;
117         }
118         function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success){
119             
120             require(balanceOf[_from] >= _value);
121 			
122 	require(_value <= allowance[_from][msg.sender]);
123             
124             balanceOf[_from] -= _value;
125             totalSupply -= _value;
126             emit Burn(msg.sender, _value);
127             
128             return true;
129         }
130         
131         function freezeAccount (address target, bool freeze)public onlyOwner {
132             frozenAccount[target] = freeze;
133             emit FrozenFunds (target, freeze);
134             
135             
136         }
137         
138 }