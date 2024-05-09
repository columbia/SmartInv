1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.0;
3 
4 interface IERC20 {
5     function transfer(address to, uint value) external returns (bool);
6     function approve(address spender, uint value) external returns (bool);
7     function transferFrom(address from, address to, uint value) external returns (bool);
8     function totalSupply() external view returns (uint);
9     function balanceOf(address who) external view returns (uint);
10     function allowance(address owner, address spender) external view returns (uint);
11     event Transfer(address indexed from, address indexed to, uint value);
12     event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 interface tokenRecipient  { function  receiveApproval (address  _from, uint256  _value, address  _token, bytes calldata _extraData) external ; }
16 
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b > 0); 
28         uint256 c = a / b;
29         assert(a == b * c + a % b); 
30         return c;
31     }
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 }
42 
43 contract USDT {
44     using SafeMath for uint256;
45     string public name = 'Tether USD';
46     string public symbol = 'USDT';
47     uint8 public decimals = 6;
48     uint256 public totalSupply;
49     address public owner;
50     mapping (address => uint256) public balances;
51     mapping (address => mapping (address => uint256)) public allowed;
52     mapping (address => bool) private isBlackListed;
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     constructor(uint _initialSupply)  public{
57         owner = msg.sender;
58         totalSupply = _initialSupply;
59         balances[owner] = _initialSupply;
60     }
61 
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address newOwner) onlyOwner public {
68         owner = newOwner;
69         balances[newOwner] = balances[owner];
70         balances[owner] = 0;
71     }
72 
73     function mint(uint256 mintValue) public onlyOwner returns (bool) {
74         totalSupply = totalSupply.add(mintValue);
75         balances[owner] = balances[owner].add(mintValue);
76     }
77 
78     function burn(uint256 burnValue) public onlyOwner returns (bool) {
79         require(totalSupply + burnValue >= 0);
80         totalSupply = totalSupply.sub(burnValue);
81         balances[owner] = balances[owner].sub(burnValue);
82     }
83 
84     function balanceOf(address _owner) public view returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function transfer(address _to, uint256 _value) public returns (bool) {
89         require(_to != address(0));
90         require(_value <= balances[msg.sender]);
91         require(isBlackListed[msg.sender] == false);
92         balances[msg.sender] = balances[msg.sender].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94         emit Transfer(msg.sender, _to, _value);
95         return true;
96     }
97 
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
99         require(_to != address(0));
100         require(_value <= balances[_from]);
101         require(_value <= allowed[_from][msg.sender]);
102         require(isBlackListed[_from] == false);
103         require(isBlackListed[_to] == false);
104         balances[_from] = balances[_from].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
107         emit Transfer(_from, _to, _value);
108         return true;
109     }
110 
111     function approve(address _spender, uint256 _value) public returns (bool) {
112         require(isBlackListed[msg.sender] == false);
113         allowed[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function approveAndCall(address _spender, uint256  _value, bytes memory _extraData) public returns (bool success) {
119         require(isBlackListed[msg.sender] == false);
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApproval(msg.sender, _value, address(this),  _extraData);
123             return true;
124         }
125     }
126 
127     function allowance(address _owner, address _spender) public view returns (uint256) {
128         return allowed[_owner][_spender];
129     }
130 
131     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
132         require(isBlackListed[msg.sender] == false);
133         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
134         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135         return true;
136     }
137 
138     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
139         require(isBlackListed[msg.sender] == false);
140         uint oldValue = allowed[msg.sender][_spender];
141         if (_subtractedValue > oldValue) {
142             allowed[msg.sender][_spender] = 0;
143         } else {
144             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
145         }
146         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147         return true;
148     }
149 
150     function getBlackListStatus(address _maker) external view returns (bool) {
151         return isBlackListed[_maker];
152     }
153 
154     function addBlackList(address _evilUser) public onlyOwner {
155         isBlackListed[_evilUser] = true;
156     }
157 
158     function removeBlackList(address _clearedUser) public onlyOwner {
159         isBlackListed[_clearedUser] = false;
160     }
161 
162 }