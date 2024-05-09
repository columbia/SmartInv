1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
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
20 contract TokenERC20 {
21     string public name;
22     string public symbol;
23     uint8 public decimals = 18;
24     uint256 public totalSupply;
25 
26     mapping (address => uint256) public balanceOf;
27     mapping (address => mapping (address => uint256)) public allowance;
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint value);
31 	
32     constructor (
33         uint256 initialSupply,
34         string tokenName,
35         string tokenSymbol
36     ) public {
37         totalSupply = initialSupply * 10 ** uint256(decimals);
38         balanceOf[msg.sender] = totalSupply;
39         name = tokenName;
40         symbol = tokenSymbol;
41     }
42 
43     function _transfer(address _from, address _to, uint _value) internal {
44         require(_to != 0x0);
45         require(balanceOf[_from] >= _value);
46         require(balanceOf[_to] + _value > balanceOf[_to]);
47         uint previousBalances = balanceOf[_from] + balanceOf[_to];
48         balanceOf[_from] -= _value;
49         balanceOf[_to] += _value;
50         emit Transfer(_from, _to, _value);
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53     function transfer(address _to, uint256 _value) public returns (bool success) {
54         _transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
59         require(_value <= allowance[_from][msg.sender]);     // Check allowance
60         allowance[_from][msg.sender] -= _value;
61         _transfer(_from, _to, _value);
62         return true;
63     }
64 	
65     function approve(address _spender, uint256 _value) public
66         returns (bool success) {
67         allowance[msg.sender][_spender] = _value;
68 		emit Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 }
72 
73 contract BFXToken is owned, TokenERC20 {
74 
75     mapping (address => bool) public frozenAccount;
76 
77     event FrozenFunds(address target, bool frozen);
78 
79     constructor (
80         uint256 initialSupply,
81         string tokenName,
82         string tokenSymbol
83     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
84 
85     function _transfer(address _from, address _to, uint _value) internal {
86         require(_to != 0x0);
87         require(balanceOf[_from] >= _value);
88         require(balanceOf[_to] + _value >= balanceOf[_to]);
89         require(!frozenAccount[_from]);
90         require(!frozenAccount[_to]);
91         balanceOf[_from] -= _value;
92         balanceOf[_to] += _value;
93         emit Transfer(_from, _to, _value);
94     }
95 
96     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
97         balanceOf[target] += mintedAmount;
98         totalSupply += mintedAmount;
99         emit Transfer(0, this, mintedAmount);
100         emit Transfer(this, target, mintedAmount);
101     }
102 
103     function freezeAccount(address target, bool freeze) onlyOwner public {
104         frozenAccount[target] = freeze;
105         emit FrozenFunds(target, freeze);
106     }
107 }