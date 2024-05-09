1 pragma solidity ^0.4.11;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract SuretlyToken {
6 
7   string public constant standard = 'Token 0.1';
8   string public constant name = "Suretly";
9   string public constant symbol = "SUR";
10   uint8 public constant decimals = 8;
11   uint256 public totalSupply = 237614 * 100000000;
12 
13   address public owner;
14 
15   mapping (address => uint256) public balanceOf;
16   mapping (address => mapping (address => uint256)) public allowance;
17 
18   event Transfer(address indexed _from, address indexed _to, uint256 _value);
19   event NewOwner(address _newOwner);
20   event Burn(address indexed _from, uint256 _value);
21 
22   function SuretlyToken() {
23     owner = msg.sender;
24     balanceOf[owner] = totalSupply;
25   }
26 
27   function replaceOwner(address _newOwner) returns (bool success) {
28     assert(msg.sender == owner);
29     owner = _newOwner;
30     NewOwner(_newOwner);
31     return true;
32   }
33 
34   function transfer(address _to, uint256 _value) {
35     require(_to != 0x0);
36     require(_to != address(this));
37     assert(!(balanceOf[msg.sender] < _value));
38     assert(!(balanceOf[_to] + _value < balanceOf[_to]));
39     balanceOf[msg.sender] -= _value;
40     balanceOf[_to] += _value;
41     Transfer(msg.sender, _to, _value);
42   }
43 
44   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
45     require(_to != 0x0);
46     require(_to != address(this));
47     assert(!(balanceOf[_from] < _value));
48     assert(!(balanceOf[_to] + _value < balanceOf[_to]));
49     assert(!(_value > allowance[_from][msg.sender]));
50     balanceOf[_from] -= _value;
51     balanceOf[_to] += _value;
52     allowance[_from][msg.sender] -= _value;
53     Transfer(_from, _to, _value);
54     return true;
55   }
56 
57   function approve(address _spender, uint256 _value) returns (bool success) {
58     allowance[msg.sender][_spender] = _value;
59     return true;
60   }
61 
62   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
63     tokenRecipient spender = tokenRecipient(_spender);
64     if (approve(_spender, _value)) {
65       spender.receiveApproval(msg.sender, _value, this, _extraData);
66       return true;
67     }
68   }
69 
70   function burn(uint256 _value) returns (bool success) {
71     assert(!(balanceOf[msg.sender] < _value));
72     balanceOf[msg.sender] -= _value;
73     totalSupply -= _value;
74     Burn(msg.sender, _value);
75     return true;
76   }
77 
78   function burnFrom(address _from, uint256 _value) returns (bool success) {
79     assert(!(balanceOf[_from] < _value));
80     assert(!(_value > allowance[_from][msg.sender]));
81     balanceOf[_from] -= _value;
82     totalSupply -= _value;
83     Burn(_from, _value);
84     return true;
85  }
86 }