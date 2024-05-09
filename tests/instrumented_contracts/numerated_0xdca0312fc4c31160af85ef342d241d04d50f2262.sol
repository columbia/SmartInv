1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns(uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns(uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29 
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32     modifier onlyOwner() { require(msg.sender == owner); _; }
33 
34     function Ownable() {
35         owner = msg.sender;
36     }
37 
38     function transferOwnership(address newOwner) onlyOwner {
39         require(newOwner != address(0));
40         OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 }
44 
45 contract ERC20 {
46     uint256 public totalSupply;
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 
51     function balanceOf(address who) constant returns (uint256);
52     function transfer(address to, uint256 value) returns (bool);
53     function transferFrom(address from, address to, uint256 value) returns (bool);
54     function allowance(address owner, address spender) constant returns (uint256);
55     function approve(address spender, uint256 value) returns (bool);
56 }
57 
58 contract StandardToken is ERC20 {
59     using SafeMath for uint256;
60 
61     mapping(address => uint256) balances;
62     mapping(address => mapping(address => uint256)) allowed;
63 
64     function balanceOf(address _owner) constant returns(uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function transfer(address _to, uint256 _value) returns(bool success) {
69         require(_to != address(0));
70 
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73 
74         Transfer(msg.sender, _to, _value);
75 
76         return true;
77     }
78 
79     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
80         require(_to != address(0));
81 
82         var _allowance = allowed[_from][msg.sender];
83 
84         balances[_from] = balances[_from].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         allowed[_from][msg.sender] = _allowance.sub(_value);
87 
88         Transfer(_from, _to, _value);
89 
90         return true;
91     }
92 
93     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
94         return allowed[_owner][_spender];
95     }
96 
97     function approve(address _spender, uint256 _value) returns(bool success) {
98         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
99 
100         allowed[msg.sender][_spender] = _value;
101 
102         Approval(msg.sender, _spender, _value);
103 
104         return true;
105     }
106 
107     function increaseApproval(address _spender, uint _addedValue) returns(bool success) {
108         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
109 
110         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111 
112         return true;
113     }
114 
115     function decreaseApproval(address _spender, uint _subtractedValue) returns(bool success) {
116         uint oldValue = allowed[msg.sender][_spender];
117 
118         if(_subtractedValue > oldValue) {
119             allowed[msg.sender][_spender] = 0;
120         } else {
121             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
122         }
123 
124         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125         
126         return true;
127     }
128 }
129 
130 contract BurnableToken is StandardToken {
131     event Burn(address indexed burner, uint256 value);
132 
133     function burn(uint256 _value) public {
134         require(_value > 0);
135 
136         address burner = msg.sender;
137 
138         balances[burner] = balances[burner].sub(_value);
139         totalSupply = totalSupply.sub(_value);
140 
141         Burn(burner, _value);
142     }
143 }
144 
145 /*
146     ICO Алтын
147     - Эмиссия токенов ограничена (всего 100 000 000 токенов)
148 */
149 contract Token is BurnableToken, Ownable {
150     string public name = "Altyn Token";
151     string public symbol = "ALT";
152     uint256 public decimals = 18;
153     
154     uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;                                        // Amount tokens
155 
156     function Token() {
157         totalSupply = INITIAL_SUPPLY;
158         balances[msg.sender] = INITIAL_SUPPLY;
159     }
160 
161     function multiTransfer(address[] _to, uint256[] _value) returns(bool success) {
162         require(_to.length == _value.length);
163 
164         for(uint i = 0; i < _to.length; i++) {
165             balances[msg.sender] = balances[msg.sender].sub(_value[i] * 1 ether);
166             balances[_to[i]] = balances[_to[i]].add(_value[i] * 1 ether);
167 
168             Transfer(msg.sender, _to[i], _value[i] * 1 ether);
169         }
170 
171         return true;
172     }
173 }