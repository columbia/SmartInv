1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenMACHU is owned {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Burn(address indexed from, uint256 value);
33 
34     function TokenMACHU(
35         uint256 initialSupply,
36         string tokenName,
37         string tokenSymbol
38     ) public {
39         totalSupply = initialSupply * 10 ** uint256(decimals);
40         balanceOf[msg.sender] = totalSupply;
41         name = tokenName;
42         symbol = tokenSymbol;
43     }
44 
45     function _transfer(address _from, address _to, uint _value) internal {
46         require(_to != 0x0);
47         require(balanceOf[_from] >= _value);
48         require(balanceOf[_to] + _value > balanceOf[_to]);
49         uint previousBalances = balanceOf[_from] + balanceOf[_to];
50         balanceOf[_from] -= _value;
51         balanceOf[_to] += _value;
52         Transfer(_from, _to, _value);
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55 
56     function transfer(address _to, uint256 _value) public {
57         _transfer(msg.sender, _to, _value);
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61         require(_value <= allowance[_from][msg.sender]);
62         allowance[_from][msg.sender] -= _value;
63         _transfer(_from, _to, _value);
64         return true;
65     }
66 
67     function approve(address _spender, uint256 _value) public
68         returns (bool success) {
69         allowance[msg.sender][_spender] = _value;
70         return true;
71     }
72 
73     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
74         public
75         returns (bool success) {
76         tokenRecipient spender = tokenRecipient(_spender);
77         if (approve(_spender, _value)) {
78             spender.receiveApproval(msg.sender, _value, this, _extraData);
79             return true;
80         }
81     }
82 
83     function burn(uint256 _value) public returns (bool success) {
84         require(balanceOf[msg.sender] >= _value);
85         balanceOf[msg.sender] -= _value;
86         totalSupply -= _value;
87         Burn(msg.sender, _value);
88         return true;
89     }
90 
91     function burnFrom(address _from, uint256 _value) public returns (bool success) {
92         require(balanceOf[_from] >= _value);
93         require(_value <= allowance[_from][msg.sender]);
94         balanceOf[_from] -= _value;
95         allowance[_from][msg.sender] -= _value;
96         totalSupply -= _value;
97         Burn(_from, _value);
98         return true;
99     }
100 
101     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
102         balanceOf[target] += mintedAmount;
103         totalSupply += mintedAmount;
104         Transfer(0, owner, mintedAmount);
105         Transfer(owner, target, mintedAmount);
106     }
107 
108     function () public payable {
109         revert();
110     }
111 }