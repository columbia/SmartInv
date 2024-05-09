1 pragma solidity ^0.4.16;
2 contract owned{
3     address public owner;
4     
5     constructor()public{
6         owner = msg.sender;
7     }
8     modifier onlyOwner{
9         require (msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner)onlyOwner public{
13         if(newOwner != address(0)){
14             owner = newOwner;
15         }
16     }
17 }
18 
19 contract Token{
20     uint256 public totalSupply;
21 
22     function balanceOf(address _owner) public constant returns (uint256 balance);
23     function transfer(address _to, uint256 _value) public returns (bool success);
24     function transferFrom(address _from, address _to, uint256 _value) public returns   
25     (bool success);
26     
27     function approve(address _spender, uint256 _value) public returns (bool success);
28     
29     function allowance(address _owner, address _spender) public constant returns 
30     (uint256 remaining);
31 
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 
34     _value);
35 }
36 
37 contract TokenDemo is Token,owned {
38     
39     string public name;                  
40     uint8 public decimals;              
41     string public symbol;            
42     mapping (address => uint256) balances;
43     mapping (address => mapping (address => uint256)) allowed;
44     
45     constructor(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
46     totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);        
47     balances[owner] = totalSupply; 
48         
49         name = _tokenName;                   
50         decimals = _decimalUnits;          
51         symbol = _tokenSymbol;
52     }
53     
54     function transfer(address _to, uint256 _value) public returns (bool success) {
55         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
56         require(_to != 0x0);
57         uint previousBalances = balances[msg.sender] + balances[_to];
58         balances[msg.sender] -= _value;
59         balances[_to] += _value;
60         emit Transfer(msg.sender, _to, _value);
61         assert(balances[msg.sender] + balances[_to] == previousBalances);
62         return true;
63     }
64 
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns 
67     (bool success) {
68         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
69         balances[_to] += _value;
70         balances[_from] -= _value; 
71         allowed[_from][msg.sender] -= _value;
72         emit Transfer(_from, _to, _value);
73         return true;
74     }
75     function balanceOf(address _owner) public constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79 
80     function approve(address _spender, uint256 _value) public returns (bool success)   
81     { 
82         allowed[msg.sender][_spender] = _value;
83         emit Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
88         return allowed[_owner][_spender];
89     }
90 
91 }
92 
93 
94 contract STTC is TokenDemo{
95     mapping (address => bool) public frozenAccount;
96     
97     event FrozenFunds(address target, bool frozen);
98     event Burn(address indexed from, uint256 value);
99     
100     constructor(
101       uint256 initialSupply,
102       string tokenName,
103       uint8 decimalUnits,
104       string tokenSymbol
105     ) TokenDemo (initialSupply, tokenName, decimalUnits,tokenSymbol) public {}
106     function transfer(address _to, uint256 _value) public returns (bool success) {
107         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
108         require(_to != 0x0);
109         require(!frozenAccount[msg.sender]);
110         require(!frozenAccount[_to]);
111         uint previousBalances = balances[msg.sender] + balances[_to];
112         balances[msg.sender] -= _value;
113         balances[_to] += _value;
114         emit Transfer(msg.sender, _to, _value);
115         assert(balances[msg.sender] + balances[_to] == previousBalances);
116         return true;
117     }
118     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
119 
120         balances[target] += mintedAmount;
121         totalSupply += mintedAmount;
122 
123         emit Transfer(0, this, mintedAmount);
124         emit Transfer(this, target, mintedAmount);
125     }
126 
127     function freezeAccount(address target, bool freeze) onlyOwner public {
128         frozenAccount[target] = freeze;
129         emit FrozenFunds(target, freeze);
130     }
131 
132 }