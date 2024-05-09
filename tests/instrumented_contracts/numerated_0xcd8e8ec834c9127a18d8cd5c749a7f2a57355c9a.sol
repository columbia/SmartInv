1 pragma solidity ^0.4.24;
2 contract ERC20Interface {
3     string public name;
4     string public symbol;
5     uint8 public decimals;
6     uint public totalSupply;
7 
8 
9 function transfer(address _to, uint256 _value) public returns (bool success);
10 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
11 
12 function approve(address _spender,uint256 _value) public returns (bool success);
13 function allowance(address _owner, address _spender) public view returns (uint256 remaining);
14 
15 event Transfer(address indexed _from,address indexed _to,uint256 _value);
16 event Approval(address indexed _owner,address indexed _spender,uint256 _value);
17 
18 }
19 
20 
21 contract ERC20 is ERC20Interface{
22 
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping(address => uint256)) allowed;
25 
26     constructor (string _name) public {
27         name = _name;
28         symbol = "DSS";
29         decimals = 18;
30         totalSupply = 2000000000000000000000000000;
31         balanceOf[msg.sender] = totalSupply;
32     }
33 
34     function transfer(address _to, uint256 _value) public returns (bool success){
35         require(_to != address(0));
36         require(balanceOf[msg.sender] >= _value);
37         require(balanceOf[ _to] + _value >= balanceOf[ _to]);
38 
39         balanceOf[msg.sender] -= _value;
40         balanceOf[_to] += _value;
41 
42         emit Transfer(msg.sender, _to, _value);
43 
44         return true;
45     }
46 
47     function transferFrom(address _from,address _to,uint256 _value) public returns(bool success){
48         require(_to != address(0));
49         require(allowed[_from][msg.sender] >= _value);
50         require(balanceOf[_from] >= _value);
51         require(balanceOf[_to] + _value >= balanceOf[_to]);
52 
53         balanceOf[_from] -= _value;
54         balanceOf[_to] += _value;
55         allowed[_from][msg.sender] -= _value;
56 
57         emit Transfer(msg.sender, _to, _value);
58 
59         return true;
60     }
61 
62     function approve(address _spender, uint256 _value) public returns (bool success){
63         allowed[msg.sender][_spender] = _value;
64 
65         emit Approval(msg.sender, _spender, _value);
66 
67         return true;
68     }
69 
70     function allowance(address _owner,address _spender) public view returns(uint256 remaining){
71         return allowed[_owner][_spender];
72     }
73 }
74 
75 contract owned{
76     address public owner;
77     constructor () public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner{
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function tOS(address newOwer) public onlyOwner{
87         owner = newOwer;
88     }
89 }
90 
91 contract DSSToken is ERC20,owned{
92 
93     mapping(address =>bool)public frozenAccount;
94 
95     event AddSupply(uint256 amount);
96     event FrozenFunds(address target, bool frozen);
97     event Burn(address target,uint256 amount);
98 
99     constructor(string _name) ERC20(_name) public{
100     }
101 
102     function mine(address target, uint256 amount) public onlyOwner{
103         require(balanceOf[target]+amount >= balanceOf[target]);
104         totalSupply += amount;
105         balanceOf[target] += amount;
106 
107         emit AddSupply(amount);
108         emit Transfer(0,target,amount);
109     }
110 
111     function freezeAccount(address target,bool freeze) public onlyOwner{
112         frozenAccount[target] = freeze;
113         emit FrozenFunds(target, freeze);
114     }
115 
116      function burn(uint256 _value) public returns (bool success){
117         require(balanceOf[msg.sender]>= _value);
118         totalSupply -= _value;
119         balanceOf[msg.sender] -= _value;
120         emit Burn(msg.sender,_value);
121         return true;
122      }
123 
124      function burnFrom(address _from,uint256 _value) public returns (bool success){
125         require(balanceOf[_from] >= _value);
126         require(allowed[_from][msg.sender] >= _value);
127 
128         totalSupply -= _value;
129         balanceOf[msg.sender] -= _value;
130         allowed[_from][msg.sender] -= _value;
131 
132         emit Burn(msg.sender,_value);
133         return true;
134      }
135 }