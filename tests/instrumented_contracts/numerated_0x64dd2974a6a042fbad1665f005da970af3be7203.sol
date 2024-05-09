1 /*
2 
3   Copyright 2018 WXBET Foundation LTD
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   Unless required by applicable law or agreed to in writing, software
7   distributed under the License is distributed on an "AS IS" BASIS,
8   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
9   See the License for the specific language governing permissions and
10   limitations under the License.
11 
12 */
13 pragma solidity ^0.4.21;
14 
15 library SafeMath {
16 
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ERC20Basic {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract BasicToken is ERC20Basic {
60   using SafeMath for uint256;
61 
62   mapping(address => uint256) balances;
63 
64   uint256 totalSupply_;
65 
66   function totalSupply() public view returns (uint256) {
67     return totalSupply_;
68   }
69 
70 
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     emit Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function balanceOf(address _owner) public view returns (uint256 balance) {
82     return balances[_owner];
83   }
84 
85 }
86 
87 contract StandardToken is ERC20, BasicToken {
88 
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[_from]);
94     require(_value <= allowed[_from][msg.sender]);
95 
96     balances[_from] = balances[_from].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99     emit Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   function approve(address _spender, uint256 _value) public returns (bool) {
104     allowed[msg.sender][_spender] = _value;
105     emit Approval(msg.sender, _spender, _value);
106     return true;
107   }
108 
109   function allowance(address _owner, address _spender) public view returns (uint256) {
110     return allowed[_owner][_spender];
111   }
112 
113   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
114     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
115     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116     return true;
117   }
118 
119   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
120     uint oldValue = allowed[msg.sender][_spender];
121     if (_subtractedValue > oldValue) {
122       allowed[msg.sender][_spender] = 0;
123     } else {
124       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
125     }
126     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
127     return true;
128   }
129 
130 }
131 
132 contract WXBET is StandardToken {
133 
134     uint public totalSupply = 1975*10**24;
135     uint8  public decimals = 18;
136     string public name = "WXBET";
137     string public symbol = "WXB";
138 
139     function WXBET () {
140         balances[msg.sender] = totalSupply;
141         Transfer(address(0), msg.sender, totalSupply);
142     }
143 }