1 pragma solidity ^0.4.18;
2 //Stder A.M.
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 //variables publicas
5 contract astorgame {
6     string public name;
7     string public symbol;
8 //cantidad de decimales 3
9     uint8 public decimals = 3;
10     uint256 public totalSupply;
11 //creamos un array con todos los balances
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     function astorgame() public {
18         uint256 initialSupply=100000000;
19         totalSupply =  initialSupply * 10 ** uint256(decimals);    
20         balanceOf[msg.sender] = totalSupply;                
21         name = "astorgame";                                  
22         symbol = "ASTOR";                               
23     }
24 //funciones transferencias
25     function _transfer(address _from, address _to, uint _value) internal {
26 
27         require(_to != 0x0);
28         require(balanceOf[_from] >= _value);
29         require(balanceOf[_to] + _value > balanceOf[_to]);
30         uint previousBalances = balanceOf[_from] + balanceOf[_to];
31         balanceOf[_from] -= _value;
32         balanceOf[_to] += _value;
33         Transfer(_from, _to, _value);
34         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
35     }
36 
37     function transfer(address _to, uint256 _value) public {
38         _transfer(msg.sender, _to, _value);
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
42         require(_value <= allowance[_from][msg.sender]);    
43         allowance[_from][msg.sender] -= _value;
44         _transfer(_from, _to, _value);
45         return true;
46     }
47 //funciones basicas para aprobaciones
48     function approve(address _spender, uint256 _value) public
49         returns (bool success) {
50         allowance[msg.sender][_spender] = _value;
51         return true;
52     }
53 
54     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
55         public
56         returns (bool success) {
57         tokenRecipient spender = tokenRecipient(_spender);
58         if (approve(_spender, _value)) {
59             spender.receiveApproval(msg.sender, _value, this, _extraData);
60             return true;
61         }
62     }
63 
64 }