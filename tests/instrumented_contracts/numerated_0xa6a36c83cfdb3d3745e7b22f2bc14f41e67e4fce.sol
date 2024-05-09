1 pragma solidity ^0.4.25;
2 
3 contract BaseToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 
15     function _transfer(address _from, address _to, uint _value) internal {
16         require(_to != 0x0);
17         require(balanceOf[_from] >= _value);
18         require(balanceOf[_to] + _value > balanceOf[_to]);
19         uint previousBalances = balanceOf[_from] + balanceOf[_to];
20         balanceOf[_from] -= _value;
21         balanceOf[_to] += _value;
22         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
23         emit Transfer(_from, _to, _value);
24     }
25 
26     function transfer(address _to, uint256 _value) public {
27         _transfer(msg.sender, _to, _value);
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
31         require(_value <= allowance[_from][msg.sender]);
32         allowance[_from][msg.sender] -= _value;
33         _transfer(_from, _to, _value);
34         return true;
35     }
36 
37     function approve(address _spender, uint256 _value) public
38         returns (bool success) {
39         allowance[msg.sender][_spender] = _value;
40         emit Approval(msg.sender, _spender, _value);
41         return true;
42     }
43 }
44 
45 contract BurnToken is BaseToken {
46     event Burn(address indexed from, uint256 value);
47 
48     function burn(uint256 _value) public returns (bool success) {
49         require(balanceOf[msg.sender] >= _value);
50         balanceOf[msg.sender] -= _value;
51         totalSupply -= _value;
52         emit Burn(msg.sender, _value);
53         return true;
54     }
55 
56     function burnFrom(address _from, uint256 _value) public returns (bool success) {
57         require(balanceOf[_from] >= _value);
58         require(_value <= allowance[_from][msg.sender]);
59         balanceOf[_from] -= _value;
60         allowance[_from][msg.sender] -= _value;
61         totalSupply -= _value;
62         emit Burn(_from, _value);
63         return true;
64     }
65 }
66 
67 contract ICOToken is BaseToken {
68     // 1 ether = icoRatio token
69     uint256 public icoRatio;
70     uint256 public icoBalance = 500000000000000;
71     address public owner;
72 
73     event ICO(address indexed from, uint256 indexed value, uint256 tokenValue);
74 
75     function() public payable {
76         uint256 tokenValue = (msg.value * icoRatio * 10 ** uint256(decimals)) / (1 ether / 1 wei);
77         if (tokenValue == 0 || icoBalance < tokenValue) {
78             revert();
79         }
80         icoBalance -= tokenValue;
81         _transfer(owner, msg.sender, tokenValue);
82         uint256 balance = address(this).balance;
83         owner.transfer(balance);
84         emit ICO(msg.sender, msg.value, tokenValue);
85     }
86 }
87 
88 contract CustomToken is BaseToken, BurnToken, ICOToken {
89     constructor() public {
90         totalSupply = 1000000000000000000;
91         owner = 0xD96a64a46d7912718a13eA5cccE3222500D8A58f;
92         balanceOf[owner] = totalSupply;
93         name = 'ONEDS';
94         symbol = 'ONEDS';
95         decimals = 8;
96         icoRatio = 25000;
97     }
98 }