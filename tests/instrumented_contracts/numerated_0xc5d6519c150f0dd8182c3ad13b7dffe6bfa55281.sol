1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
5 }
6 
7 contract TokenERC20 {
8     string public name = 'Telex';
9     string public symbol = 'TLX';
10     uint8 public decimals = 8;
11     uint256 public initialSupply = 1960345581969288;
12     uint256 public totalSupply = initialSupply;
13 
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Burn(address indexed from, uint256 value);
19 
20     function TokenERC20() public {
21         balanceOf[msg.sender] = totalSupply;
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
46     function approve(address _spender, uint256 _value) public
47         returns (bool success) {
48         allowance[msg.sender][_spender] = _value;
49         return true;
50     }
51 
52     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
53         public
54         returns (bool success) {
55         tokenRecipient spender = tokenRecipient(_spender);
56         if (approve(_spender, _value)) {
57             spender.receiveApproval(msg.sender, _value, this, _extraData);
58             return true;
59         }
60     }
61 
62     function burn(uint256 _value) public returns (bool success) {
63         require(balanceOf[msg.sender] >= _value);
64         balanceOf[msg.sender] -= _value;
65         totalSupply -= _value;
66         Burn(msg.sender, _value);
67         return true;
68     }
69 
70     function burnFrom(address _from, uint256 _value) public returns (bool success) {
71         require(balanceOf[_from] >= _value);
72         require(_value <= allowance[_from][msg.sender]);
73         balanceOf[_from] -= _value;
74         allowance[_from][msg.sender] -= _value;
75         totalSupply -= _value;
76         Burn(_from, _value);
77         return true;
78     }
79 }