1 /*
2     Implements AquaToken, which is a test.
3 
4     (Test Version 2.0)
5   
6     Portions of this code fall under the following license from "OpenZepplin"
7 
8     The MIT License (MIT)
9 
10     Copyright (c) 2016 Smart Contract Solutions, Inc.
11 
12     Permission is hereby granted, free of charge, to any person obtaining
13     a copy of this software and associated documentation files (the
14     "Software"), to deal in the Software without restriction, including
15     without limitation the rights to use, copy, modify, merge, publish,
16     distribute, sublicense, and/or sell copies of the Software, and to
17     permit persons to whom the Software is furnished to do so, subject to
18     the following conditions:
19 
20     The above copyright notice and this permission notice shall be included
21     in all copies or substantial portions of the Software.
22 
23     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
24     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
25     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
26     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
27     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
28     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
29     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
30 
31 */
32 
33 
34 pragma solidity 0.4.24;
35 
36 contract ERC20Basic {
37     function totalSupply() public view returns (uint256);
38     function balanceOf(address who) public view returns (uint256);
39     function transfer(address to, uint256 value) public returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 library SafeMath {
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         if (a == 0) {
47         return 0;
48         }
49         c = a * b;
50         assert(c / a == b);
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // assert(b > 0); // Solidity automatically throws when dividing by 0
56         // uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58         return a / b;
59     }
60 
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         assert(b <= a);
63         return a - b;
64     }
65 
66     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67         c = a + b;
68         assert(c >= a);
69         return c;
70     }
71 }
72 
73 contract BasicToken is ERC20Basic {
74     using SafeMath for uint256;
75 
76     mapping(address => uint256) balances;
77 
78     uint256 totalSupply_;
79 
80     function totalSupply() public view returns (uint256) {
81         return totalSupply_;
82     }
83 
84     function transfer(address _to, uint256 _value) public returns (bool) {
85         require(_to != address(0));
86         require(_value <= balances[msg.sender]);
87 
88         balances[msg.sender] = balances[msg.sender].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         emit Transfer(msg.sender, _to, _value);
91         return true;
92     }
93 
94     function balanceOf(address _owner) public view returns (uint256) {
95         return balances[_owner];
96     }
97 
98 }
99 
100 contract ERC20 is ERC20Basic {
101     function allowance(address owner, address spender) public view returns (uint256);
102     function transferFrom(address from, address to, uint256 value) public returns (bool);
103     function approve(address spender, uint256 value) public returns (bool);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 contract StandardToken is ERC20, BasicToken {
108 
109     mapping (address => mapping (address => uint256)) internal allowed;
110 
111 
112     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113         require(_to != address(0));
114         require(_value <= balances[_from]);
115         require(_value <= allowed[_from][msg.sender]);
116 
117         balances[_from] = balances[_from].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120         emit Transfer(_from, _to, _value);
121         return true;
122     }
123 
124     function approve(address _spender, uint256 _value) public returns (bool) {
125         allowed[msg.sender][_spender] = _value;
126         emit Approval(msg.sender, _spender, _value);
127         return true;
128     }
129 
130     function allowance(address _owner, address _spender) public view returns (uint256) {
131         return allowed[_owner][_spender];
132     }
133 
134     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
135         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
136         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137         return true;
138     }
139 
140     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
141         uint oldValue = allowed[msg.sender][_spender];
142         if (_subtractedValue > oldValue) {
143             allowed[msg.sender][_spender] = 0;
144         } else {
145             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146         }
147         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148         return true;
149     }
150 }
151 
152 contract BurnableToken is BasicToken {
153 
154     event Burn(address indexed burner, uint256 value);
155 
156     function burn(uint256 _value) public {
157         _burn(msg.sender, _value);
158     }
159 
160     function _burn(address _who, uint256 _value) internal {
161         require(_value <= balances[_who]);
162 
163         balances[_who] = balances[_who].sub(_value);
164         totalSupply_ = totalSupply_.sub(_value);
165         emit Burn(_who, _value);
166         emit Transfer(_who, address(0), _value);
167     }
168 }
169 
170 contract AquaToken is BurnableToken, StandardToken {
171     string public name = "AquaToken";
172     string public symbol = "AQAU";
173     uint public decimals = 18;
174     uint public INITIAL_SUPPLY = 100000000 * 1 ether;
175     address public owner;
176 
177     constructor() public {
178         totalSupply_ = INITIAL_SUPPLY;
179         balances[msg.sender] = INITIAL_SUPPLY;
180         owner = msg.sender;
181     }
182 
183     modifier onlyOwner() {
184         require(msg.sender == owner);
185         _;
186     }
187 
188     function transferOwnership(address newOwner) public onlyOwner {
189         if(newOwner != address(0)) {
190             owner = newOwner;
191         }
192     }
193 }