1 pragma solidity ^0.4.24;
2 
3 /**
4  * HeapX.io Smart Contract
5  * /
6 
7 /** @title SafeMath */
8 library SafeMath {
9   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) { if (_a == 0) { return 0; } uint256 c = _a * _b; assert(c / _a == _b); return c; }
10   function div(uint256 _a, uint256 _b) internal pure returns (uint256) { uint256 c = _a / _b; return c; }
11   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) { assert(_b <= _a); uint256 c = _a - _b; return c;}
12   function add(uint256 _a, uint256 _b) internal pure returns (uint256) { uint256 c = _a + _b; assert(c >= _a); return c;}
13 }
14 
15 /** @title ERC20 interface */
16 contract ERC20 {
17     function totalSupply() public view returns (uint256);
18     function balanceOf(address _who) public view returns (uint256);
19     function allowance(address _owner, address _spender) public view returns (uint256);
20     function transfer(address _to, uint256 _value) public returns (bool);
21     function approve(address _spender, uint256 _value) public returns (bool);
22     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
23 }
24 
25 /** @title Owner */
26 contract OwnerHeapX {
27     address public owner;
28     constructor() public { owner = msg.sender; }
29     modifier onlyOwner { require(msg.sender == owner); _;}
30     function transferOwnership(address newOwner) onlyOwner public { owner = newOwner; }
31 }
32 
33 /** @title HeapX */
34 contract HeapX is OwnerHeapX, ERC20 {
35 
36     string  public name;
37     string  public symbol;
38     uint8   public decimals;
39     uint256 public totalSupply_;
40     address public owner;
41 
42     constructor() public {
43         name = "HeapX";
44         symbol = "HEAP";
45         decimals = 9;
46         totalSupply_ = 500000000000000000;
47         owner = msg.sender;
48         balances[msg.sender] = totalSupply_;
49         emit Transfer(address(0), msg.sender, totalSupply_);
50     }
51 
52     using SafeMath for uint256;
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) internal allowed;
55     mapping (address => bool) public frozenAccount;
56     mapping (address => mapping (address => uint256)) public allowance;
57 
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner,address indexed spender,uint256 value);
60     event Burn(address indexed from, uint256 value);
61     event FrozenFunds(address target, bool frozen);
62 
63     function totalSupply() public view returns (uint256) {
64         return totalSupply_;
65     }
66 
67     function balanceOf(address _owner) public view returns (uint256) {
68         return balances[_owner];
69     }
70 
71     function allowance(address _owner, address _spender) public view returns (uint256){
72         return allowed[_owner][_spender];
73     }
74 
75     function transfer(address _to, uint256 _value) public returns (bool) {
76         require(_value <= balances[msg.sender]);
77         require(_to != address(0));
78         require(!frozenAccount[_to]);
79         require(!frozenAccount[msg.sender]);
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         emit Transfer(msg.sender, _to, _value);
83         return true;
84     }
85     
86     function approve(address _spender, uint256 _value) public returns (bool) {
87         allowed[msg.sender][_spender] = _value;
88         emit Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function transferFrom( address _from, address _to, uint256 _value) public returns (bool){
93         require(_value <= allowed[_from][msg.sender]);
94         require(_to != address(0));
95         require(!frozenAccount[_to]);
96         require(!frozenAccount[_from]);
97         balances[_from] = balances[_from].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
100         emit Transfer(_from, _to, _value);
101         return true;
102     }
103     
104     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool){
105         allowed[msg.sender][_spender] = (
106             allowed[msg.sender][_spender].add(_addedValue));
107         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
108         return true;
109     }
110 
111     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool){
112         uint256 oldValue = allowed[msg.sender][_spender];
113         if (_subtractedValue >= oldValue) {
114             allowed[msg.sender][_spender] = 0;
115         } else {
116             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
117         }
118         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
119             return true;
120     }
121 
122     function freezeAccount(address target, bool freeze) onlyOwner public {
123         frozenAccount[target] = freeze;
124         emit FrozenFunds(target, freeze);
125     }
126 
127     function burn(uint256 _value) public returns (bool success) {
128         require(balances[msg.sender] >= _value);
129         balances[msg.sender] -= _value;
130         totalSupply_ -= _value;
131         emit Burn(msg.sender, _value);
132         return true;
133     }
134     
135 }