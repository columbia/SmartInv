1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-26
3 */
4 
5 pragma solidity ^0.4.16;
6  
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
8  
9 contract PIGX {
10     string public name;
11     string public symbol;
12     uint8 public decimals = 18;  // 18 是建议的默认值
13     uint256 public totalSupply;
14  
15     mapping (address => uint256) public balanceOf;  // 
16     mapping (address => mapping (address => uint256)) public allowance;
17  
18     event Transfer(address indexed from, address indexed to, uint256 value);
19  
20     event Burn(address indexed from, uint256 value);
21  
22  
23     function PIGX(uint256 initialSupply, string tokenName, string tokenSymbol) public {
24         totalSupply = initialSupply * 10 ** uint256(decimals);
25         balanceOf[msg.sender] = totalSupply;
26         name = tokenName;
27         symbol = tokenSymbol;
28     }
29  
30  
31     function _transfer(address _from, address _to, uint _value) internal {
32         require(_to != 0x0);
33         require(balanceOf[_from] >= _value);
34         require(balanceOf[_to] + _value > balanceOf[_to]);
35         uint previousBalances = balanceOf[_from] + balanceOf[_to];
36         balanceOf[_from] -= _value;
37         balanceOf[_to] += _value;
38         Transfer(_from, _to, _value);
39         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
40     }
41  
42     function transfer(address _to, uint256 _value) public {
43         _transfer(msg.sender, _to, _value);
44     }
45  
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
47         require(_value <= allowance[_from][msg.sender]);     // Check allowance
48         allowance[_from][msg.sender] -= _value;
49         _transfer(_from, _to, _value);
50         return true;
51     }
52  
53     function approve(address _spender, uint256 _value) public
54         returns (bool success) {
55         allowance[msg.sender][_spender] = _value;
56         return true;
57     }
58  
59     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
60         tokenRecipient spender = tokenRecipient(_spender);
61         if (approve(_spender, _value)) {
62             spender.receiveApproval(msg.sender, _value, this, _extraData);
63             return true;
64         }
65     }
66  
67     function burn(uint256 _value) public returns (bool success) {
68         require(balanceOf[msg.sender] >= _value);
69         balanceOf[msg.sender] -= _value;
70         totalSupply -= _value;
71         Burn(msg.sender, _value);
72         return true;
73     }
74  
75     function burnFrom(address _from, uint256 _value) public returns (bool success) {
76         require(balanceOf[_from] >= _value);
77         require(_value <= allowance[_from][msg.sender]);
78         balanceOf[_from] -= _value;
79         allowance[_from][msg.sender] -= _value;
80         totalSupply -= _value;
81         Burn(_from, _value);
82         return true;
83     }
84 }