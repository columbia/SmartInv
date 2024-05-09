1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract BRV {
6     
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     uint256 public totalSupply;
11 
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Burn(address indexed from, uint256 value);
17 
18 
19     function BRV(
20         uint256 initialSupply,
21         string tokenName,
22         string tokenSymbol) 
23         public {
24         totalSupply = initialSupply * 10 ** uint256(decimals); 
25         balanceOf[msg.sender] = totalSupply;           
26         name = tokenName;                           
27         symbol = tokenSymbol; }
28 
29 
30     function _transfer(address _from, address _to, uint _value) internal {
31         require(_to != 0x0);
32         require(balanceOf[_from] >= _value);
33         require(balanceOf[_to] + _value > balanceOf[_to]);
34         uint previousBalances = balanceOf[_from] + balanceOf[_to];
35         balanceOf[_from] -= _value;
36         balanceOf[_to] += _value;
37         Transfer(_from, _to, _value);
38         assert(balanceOf[_from] + balanceOf[_to] == previousBalances); }
39 
40 
41     function transfer(address _to, uint256 _value) public {
42         _transfer(msg.sender, _to, _value); }
43 
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
46         require(_value <= allowance[_from][msg.sender]);  
47         allowance[_from][msg.sender] -= _value;
48         _transfer(_from, _to, _value);
49         return true; }
50 
51 
52     function approve(address _spender, uint256 _value) public
53         returns (bool success) {
54         allowance[msg.sender][_spender] = _value;
55         return true; }
56 
57     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
58         public
59         returns (bool success) {
60         tokenRecipient spender = tokenRecipient(_spender);
61         if (approve(_spender, _value)) {
62             spender.receiveApproval(msg.sender, _value, this, _extraData);
63             return true; } }
64 
65 
66     function burn(uint256 _value) public returns (bool success) {
67         require(balanceOf[msg.sender] >= _value);
68         balanceOf[msg.sender] -= _value;            
69         totalSupply -= _value;                  
70         Burn(msg.sender, _value);
71         return true; }
72 
73 
74     function burnFrom(address _from, uint256 _value) public returns (bool success) {
75         require(balanceOf[_from] >= _value);
76         require(_value <= allowance[_from][msg.sender]);  
77         balanceOf[_from] -= _value;                         
78         allowance[_from][msg.sender] -= _value;         
79         totalSupply -= _value;                              
80         Burn(_from, _value);
81         return true; }
82 }