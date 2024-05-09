1 pragma solidity ^0.4.25;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     string public name="Vital Index Trace Chain";
7     string public symbol="VIC";
8     uint8 public decimals = 4;
9     uint256 public initialSupply = 84000000;
10     uint256 public totalSupply;
11     
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Burn(address indexed from, uint256 value);
16 
17     function TokenERC20() public {
18         totalSupply = initialSupply * 10 ** uint256(decimals);
19         balanceOf[msg.sender] = totalSupply;
20         name = name;
21         symbol = symbol;
22     }
23 
24     function _transfer(address _from, address _to, uint _value) internal {
25         require(_to != 0x0);
26         require(balanceOf[_from] >= _value);
27         require(balanceOf[_to] + _value > balanceOf[_to]);
28         uint previousBalances = balanceOf[_from] + balanceOf[_to];
29         balanceOf[_from] -= _value;
30         balanceOf[_to] += _value;
31         Transfer(_from, _to, _value);
32         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
33     }
34     
35     function transfer(address _to, uint256 _value) public {
36         _transfer(msg.sender, _to, _value);
37     }
38 
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
40         require(_value <= allowance[_from][msg.sender]);
41         allowance[_from][msg.sender] -= _value;
42         _transfer(_from, _to, _value);
43         return true;
44     }
45 
46     function approve(address _spender, uint256 _value) public returns (bool success) {
47         allowance[msg.sender][_spender] = _value;
48         return true;
49     }
50 
51     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
52         tokenRecipient spender = tokenRecipient(_spender);
53         if (approve(_spender, _value)) {
54             spender.receiveApproval(msg.sender, _value, this, _extraData);
55             return true;
56         }
57     }
58 
59     function burn(uint256 _value) public returns (bool success) {
60         require(balanceOf[msg.sender] >= _value);
61         balanceOf[msg.sender] -= _value;
62         totalSupply -= _value;
63         Burn(msg.sender, _value);
64         return true;
65     }
66 
67     function burnFrom(address _from, uint256 _value) public returns (bool success) {
68         require(balanceOf[_from] >= _value);
69         require(_value <= allowance[_from][msg.sender]);
70         balanceOf[_from] -= _value;
71         allowance[_from][msg.sender] -= _value;
72         totalSupply -= _value;
73         Burn(_from, _value);
74         return true;
75     }
76 }