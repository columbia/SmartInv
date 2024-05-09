1 pragma solidity ^0.5.2;
2 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 /*
4   Licensed under the Apache License, Version 2.0 (the "License");
5   you may not use this file except in compliance with the License.
6   You may obtain a copy of the License at
7 
8     http://www.apache.org/licenses/LICENSE-2.0
9 
10   Unless required by applicable law or agreed to in writing, software
11   distributed under the License is distributed on an "AS IS" BASIS,
12   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13   See the License for the specific language governing permissions and
14   limitations under the License.
15 */
16 
17 contract ERC20 {
18     //function totalSupply() public view returns (uint supply) {}
19     function balanceOf(address _owner) public view returns (uint balance) {}
20     function transfer(address _to, uint _value) public returns (bool success) {}
21     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {}
22     function approve(address _spender, uint _value) public returns (bool success) {}
23     function allowance(address _owner, address _spender) public view returns (uint remaining) {}
24 
25     event Transfer(address indexed _from, address indexed _to, uint _value);
26     event Approval(address indexed _owner, address indexed _spender, uint _value);
27 }
28 contract ERC223ReceivingContract { 
29     function tokenFallback (address _from, uint _value, bytes memory _data) public;
30 }
31 
32 
33 contract UmbrellaToken is ERC20 {
34     using SafeMath for uint;
35     uint8 constant public decimals = 18;
36     uint public totalSupply = 10**27; // 1 billion tokens, 18 decimal places
37     string constant public name = "UmbrellaToken";
38     string constant public symbol = "RAIN";
39 
40     constructor() public {
41         balances[msg.sender] = totalSupply;
42     }
43     
44     function transfer(address _to, uint _value) public returns (bool success) {
45         uint codeLength;
46         bytes memory empty;
47 
48         assembly {
49             // Retrieve the size of the code on target address, this needs assembly .
50             codeLength := extcodesize(_to)
51         }
52 
53         balances[msg.sender] = balances[msg.sender].sub(_value);
54         balances[_to] = balances[_to].add(_value);
55         if(codeLength>0) {
56             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
57             receiver.tokenFallback(msg.sender, _value, empty);
58         }
59         emit Transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     function transferFrom(address from, address to, uint amount) public returns (bool success) {
64         balances[from] = balances[from].sub(amount);
65         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
66         balances[to] = balances[to].add(amount);
67         emit Transfer(from, to, amount);
68         return true;
69     }
70 
71     function balanceOf(address _owner) public view returns (uint) {
72         return balances[_owner];
73     }
74 
75     function approve(address _spender, uint _value) public returns (bool) {
76         allowed[msg.sender][_spender] = _value;
77         emit Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) public view returns (uint) {
82         return allowed[_owner][_spender];
83     }
84 
85     mapping (address => uint) balances;
86     mapping (address => mapping (address => uint)) allowed;
87     
88     function () external payable {
89         revert();
90     }
91 }
92 
93 
94 
95 //-------------------------==
96 library SafeMath {
97     function mul(uint a, uint b) pure internal returns (uint) {
98         uint c = a * b;
99         assert(a == 0 || c / a == b);
100         return c;
101     }
102 
103     function div(uint a, uint b) pure internal returns (uint) {
104         // assert(b > 0); // Solidity automatically throws when dividing by 0
105         uint c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107         return c;
108     }
109 
110     function sub(uint a, uint b) pure internal returns (uint) {
111         assert(b <= a);
112         return a - b;
113     }
114 
115     function add(uint a, uint b) pure internal returns (uint) {
116         uint c = a + b;
117         assert(c >= a);
118         return c;
119     }
120 
121     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
122         return a >= b ? a : b;
123     }
124 
125     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
126         return a < b ? a : b;
127     }
128 
129     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a >= b ? a : b;
131     }
132 
133     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a < b ? a : b;
135     }
136 
137 }