1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract ISToken {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 2;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     function ISToken(
17         
18     ) public {
19         totalSupply = 1000000 * 10 ** uint256(decimals);
20         balanceOf[msg.sender] = totalSupply; 
21         name = "International Socialist Token";      
22         symbol = "IST"; 
23     }
24 
25     function _transfer(address _from, address _to, uint _value) internal {
26         require(_to != 0x0);
27         require(balanceOf[_from] >= _value);
28         require(balanceOf[_to] + _value > balanceOf[_to]);
29         uint previousBalances = balanceOf[_from] + balanceOf[_to];
30         balanceOf[_from] -= _value;
31         balanceOf[_to] += _value;
32         Transfer(_from, _to, _value);
33         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
34     }
35 
36     
37     function transfer(address _to, uint256 _value) public {
38         _transfer(msg.sender, _to, _value);
39     }
40 
41     
42     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
43         require(_value <= allowance[_from][msg.sender]);
44         allowance[_from][msg.sender] -= _value;
45         _transfer(_from, _to, _value);
46         return true;
47     }
48 
49    
50     function approve(address _spender, uint256 _value) public
51         returns (bool success) {
52         allowance[msg.sender][_spender] = _value;
53         return true;
54     }
55 
56     
57     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
58         public
59         returns (bool success) {
60         tokenRecipient spender = tokenRecipient(_spender);
61         if (approve(_spender, _value)) {
62             spender.receiveApproval(msg.sender, _value, this, _extraData);
63             return true;
64         }
65     }
66 }