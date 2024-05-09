1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Frank {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 10;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     function Frank(uint256 initialSupply, string tokenSymbol, string tokenName)public{
17         totalSupply = initialSupply * 10 ** uint256(decimals);  
18         balanceOf[msg.sender] = totalSupply;                
19         name = tokenName;                                   
20         symbol = tokenSymbol;                              
21     }
22 
23     function _transfer(address _from, address _to, uint _value) internal {
24         require(_to != 0x0);
25         require(balanceOf[_from] >= _value);
26         require(balanceOf[_to] + _value > balanceOf[_to]);
27         uint previousBalances = balanceOf[_from] + balanceOf[_to];
28         balanceOf[_from] -= _value;
29         balanceOf[_to] += _value;
30         Transfer(_from, _to, _value);
31         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
32     }
33 
34     function transfer(address _to, uint256 _value) public {
35         _transfer(msg.sender, _to, _value);
36     }
37 
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
39         require(_value <= allowance[_from][msg.sender]);  
40         allowance[_from][msg.sender] -= _value;
41         _transfer(_from, _to, _value);
42         return true;
43     }
44 
45     function approve(address _spender, uint256 _value) public
46         returns (bool success){
47         allowance[msg.sender][_spender] = _value;
48         return true;
49     }
50 
51     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
52         public
53         returns (bool success) {
54         tokenRecipient spender = tokenRecipient(_spender);
55         if (approve(_spender, _value)){
56             spender.receiveApproval(msg.sender, _value, this, _extraData);
57             return true;
58         }
59     }
60 }