1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26   
27 contract ManagedToken {
28     using SafeMath for uint256;
29 
30 
31     address public owner = msg.sender;
32     address public crowdsaleContractAddress;
33 
34     string public name;
35     string public symbol;
36 
37     bool public locked = true;
38         
39     uint8 public decimals = 18;
40 
41     modifier unlocked() {
42         require(!locked);
43         _;
44     }
45 
46 
47     // Ownership
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     modifier onlyCrowdsale() {
57         require(msg.sender == crowdsaleContractAddress);
58         _;
59     }
60 
61     modifier ownerOrCrowdsale() {
62         require(msg.sender == owner || msg.sender == crowdsaleContractAddress);
63         _;
64     }
65 
66     function transferOwnership(address newOwner) public onlyOwner returns (bool success) {
67         require(newOwner != address(0));      
68         OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70         return true;
71     }
72 
73 
74     // ERC20 related functions
75 
76     uint256 public totalSupply = 0;
77 
78     mapping(address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;
80 
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84 
85     function transfer(address _to, uint256 _value) unlocked public returns (bool) {
86         require(_to != address(0));
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93     function balanceOf(address _owner) constant public returns (uint256 balance) {
94         return balances[_owner];
95     }
96 
97 
98     function transferFrom(address _from, address _to, uint256 _value) unlocked public returns (bool) {
99         require(_to != address(0));
100         var _allowance = allowed[_from][msg.sender];
101         balances[_from] = balances[_from].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         allowed[_from][msg.sender] = _allowance.sub(_value);
104         Transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function approve(address _spender, uint256 _value) unlocked public returns (bool) {
109         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
110         allowed[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
116         return allowed[_owner][_spender];
117     }
118 
119     function increaseApproval (address _spender, uint _addedValue) unlocked public
120         returns (bool success) {
121             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
122             Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
123             return true;
124     }
125 
126     function decreaseApproval (address _spender, uint _subtractedValue) unlocked public
127         returns (bool success) {
128             uint oldValue = allowed[msg.sender][_spender];
129             if (_subtractedValue > oldValue) {
130             allowed[msg.sender][_spender] = 0;
131             } else {
132             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
133             }
134             Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135             return true;
136     }
137 
138 
139 
140     function ManagedToken (string _name, string _symbol, uint8 _decimals) public {
141         require(bytes(_name).length > 1);
142         require(bytes(_symbol).length > 1);
143         name = _name;
144         symbol = _symbol;
145         decimals = _decimals;
146     }
147 
148 
149     function setNameAndTicker(string _name, string _symbol) onlyOwner public returns (bool success) {
150         require(bytes(_name).length > 1);
151         require(bytes(_symbol).length > 1);
152         name = _name;
153         symbol = _symbol;
154         return true;
155     }
156 
157     function setLock(bool _newLockState) ownerOrCrowdsale public returns (bool success) {
158         require(_newLockState != locked);
159         locked = _newLockState;
160         return true;
161     }
162 
163     function setCrowdsale(address _newCrowdsale) onlyOwner public returns (bool success) {
164         crowdsaleContractAddress = _newCrowdsale;
165         return true;
166     }
167 
168     function mint(address _for, uint256 _amount) onlyCrowdsale public returns (bool success) {
169         balances[_for] = balances[_for].add(_amount);
170         totalSupply = totalSupply.add(_amount);
171         Transfer(0, _for, _amount);
172         return true;
173     }
174 
175     function demint(address _for, uint256 _amount) onlyCrowdsale public returns (bool success) {
176         balances[_for] = balances[_for].sub(_amount);
177         totalSupply = totalSupply.sub(_amount);
178         Transfer(_for, 0, _amount);
179         return true;
180     }
181 
182 }