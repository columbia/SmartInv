1 pragma solidity ^0.4.24;
2 
3 contract Bcxss {
4     address public owner;
5     string public name;
6     string public symbol;
7     uint public decimals;
8     uint256 public totalSupply;
9 
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Burn(address indexed from, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16     
17     mapping (address => bool) public frozenAccount;
18     event FrozenFunds(address target, bool frozen);
19 
20     bool lock = false;
21 
22     constructor(
23         uint256 initialSupply,
24         string tokenName,
25         string tokenSymbol,
26         uint decimalUnits
27     ) public {
28         owner = msg.sender;
29         name = tokenName;
30         symbol = tokenSymbol; 
31         decimals = decimalUnits;
32         totalSupply = initialSupply * 10 ** uint256(decimals);
33         balanceOf[msg.sender] = totalSupply;
34     }
35 
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     modifier isLock {
42         require(!lock);
43         _;
44     }
45     
46     function setLock(bool _lock) onlyOwner public{
47         lock = _lock;
48     }
49 
50     function transferOwnership(address newOwner) onlyOwner public {
51         if (newOwner != address(0)) {
52             owner = newOwner;
53         }
54     }
55  
56 
57     function _transfer(address _from, address _to, uint _value) isLock internal {
58         require (_to != 0x0);
59         require (balanceOf[_from] >= _value);
60         require (balanceOf[_to] + _value > balanceOf[_to]);
61         require(!frozenAccount[_from]);
62         require(!frozenAccount[_to]);
63         balanceOf[_from] -= _value;
64         balanceOf[_to] += _value;
65         emit Transfer(_from, _to, _value);
66     }
67 
68     function transfer(address _to, uint256 _value) public returns (bool success) {
69         _transfer(msg.sender, _to, _value);
70         return true;
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         require(_value <= allowance[_from][msg.sender]);
75         allowance[_from][msg.sender] -= _value;
76         _transfer(_from, _to, _value);
77         return true;
78     }
79 
80     function approve(address _spender, uint256 _value) public returns (bool success) {
81         allowance[msg.sender][_spender] = _value;
82         emit Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function burn(uint256 _value) onlyOwner public returns (bool success) {
87         require(balanceOf[msg.sender] >= _value);
88         balanceOf[msg.sender] -= _value;
89         totalSupply -= _value;
90         emit Burn(msg.sender, _value);
91         return true;
92     }
93 
94     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
95         require(balanceOf[_from] >= _value); 
96         require(_value <= allowance[_from][msg.sender]); 
97         balanceOf[_from] -= _value;
98         allowance[_from][msg.sender] -= _value;
99         totalSupply -= _value;
100         emit Burn(_from, _value);
101         return true;
102     }
103 
104     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
105         uint256 _amount = mintedAmount * 10 ** uint256(decimals);
106         balanceOf[target] += _amount;
107         totalSupply += _amount;
108         emit Transfer(this, target, _amount);
109     }
110     
111     function freezeAccount(address target, bool freeze) onlyOwner public {
112         frozenAccount[target] = freeze;
113         emit FrozenFunds(target, freeze);
114     }
115 
116     function transferBatch(address[] _to, uint256 _value) public returns (bool success) {
117         for (uint i=0; i<_to.length; i++) {
118             _transfer(msg.sender, _to[i], _value);
119         }
120         return true;
121     }
122 }