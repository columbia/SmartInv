1 pragma solidity ^0.5.0;
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
20 contract ORCToken is owned{
21 
22     string public name;
23     string public symbol;
24     uint8 public decimals = 18;
25     uint256 public totalSupply;
26 
27     mapping (address => uint256) public balanceOf;
28     mapping (address => mapping (address => uint256)) public allowance;
29     mapping (address => bool) public frozenAccount;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 
35     event Burn(address indexed from, uint256 value);
36 
37     event FrozenFunds(address target, bool frozen);
38 
39     constructor(
40         uint256 initialSupply,
41         string memory tokenName,
42         string memory tokenSymbol
43     ) public {
44         totalSupply = initialSupply * 10 ** uint256(decimals);
45         balanceOf[msg.sender] = totalSupply;
46         name = tokenName;
47         symbol = tokenSymbol;
48     }
49 
50     function _transfer(address _from, address _to, uint _value) internal {
51         require(_to != address(0x0));
52         require(balanceOf[_from] >= _value);
53         require(balanceOf[_to] + _value >= balanceOf[_to]);
54         
55         require(!frozenAccount[_from]);
56         require(!frozenAccount[_to]);
57 
58         uint previousBalances = balanceOf[_from] + balanceOf[_to];
59         balanceOf[_from] -= _value;
60         balanceOf[_to] += _value;
61 
62         emit Transfer(_from, _to, _value);
63 
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 
67     function transfer(address _to, uint256 _value) public returns (bool success) {
68         _transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         require(_value <= allowance[_from][msg.sender]);     // Check allowance
74         allowance[_from][msg.sender] -= _value;
75         _transfer(_from, _to, _value);
76         return true;
77     }
78 
79     function approve(address _spender, uint256 _value) public returns (bool success) {
80         allowance[msg.sender][_spender] = _value;
81         emit Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function burn(uint256 _value) public returns (bool success) {
86         require(balanceOf[msg.sender] >= _value);
87         balanceOf[msg.sender] -= _value;
88         totalSupply -= _value;
89         emit Burn(msg.sender, _value);
90         return true;
91     }
92 
93     function burnFrom(address _from, uint256 _value) public returns (bool success) {
94         require(balanceOf[_from] >= _value);
95         require(_value <= allowance[_from][msg.sender]);
96         balanceOf[_from] -= _value;
97         allowance[_from][msg.sender] -= _value;
98         totalSupply -= _value;
99         emit Burn(_from, _value);
100         return true;
101     }
102 
103     function freezeAccount(address target, bool freeze) onlyOwner public {
104         frozenAccount[target] = freeze;
105         emit FrozenFunds(target, freeze);
106     }
107 }