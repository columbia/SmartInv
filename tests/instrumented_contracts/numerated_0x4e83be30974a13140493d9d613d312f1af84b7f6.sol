1 pragma solidity ^0.4.16;
2 
3 interface token_recipient { function approved(address _from, uint256 _value, address _token, bytes _data) public; }
4 
5 contract ERC20 {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 2;
9     uint256 public totalSupply;
10     address public owner;
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Burn(address indexed from, uint256 value);
17     
18     function ERC20 (string token_name, string token_symbol, uint256 supply) public {
19         name = token_name;
20         symbol = token_symbol;
21         totalSupply = supply * 10 ** uint256(decimals);
22         owner = msg.sender;
23         balanceOf[msg.sender] = totalSupply;
24     }
25     
26     modifier owned {
27         require(msg.sender == owner); 
28         _;
29     }
30 
31     function _transfer (address _from, address _to, uint256 _value) internal {
32         require(_to != 0x0);
33         require(balanceOf[_from] >= _value);
34         require(balanceOf[_to] + _value > balanceOf[_to]);
35         uint prev_balances = balanceOf[_from] + balanceOf[_to];
36         balanceOf[_from] -= _value;
37         balanceOf[_to] += _value;
38         Transfer(_from, _to, _value);
39         assert(balanceOf[_from] + balanceOf[_to] == prev_balances);
40     }
41     
42     function approve (address _spender, uint256 _value, bytes _data) public {
43         allowance[msg.sender][_spender] = _value;
44         token_recipient spender = token_recipient(_spender);
45         spender.approved(msg.sender, _value, this, _data);
46     }
47     
48     function transfer (address _to, uint256 _value) public {
49         _transfer(msg.sender, _to, _value);
50     }
51     
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
53         require(_value <= allowance[_from][msg.sender]);
54         allowance[_from][msg.sender] -= _value;
55         _transfer(_from, _to, _value);
56         return true;
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
76     
77     function mint(address target, uint256 mint_value) public owned {
78         balanceOf[target] += mint_value;
79         totalSupply += mint_value;
80         Transfer(0, this, mint_value);
81         Transfer(this, target, mint_value);
82     }
83 }