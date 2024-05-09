1 // SPDX-License-Identifier: MIT
2 
3 /**
4 //
5 // $OHMI
6 // ONE HUNDRED MILLION INU
7 //
8 // https://ohminu.com
9 // https://twitter.com/OHMInuERC
10 //
11 // One goal. $100m market cap.
12 // The top 100 holders will receive an INSANE reward
13 // when the market cap goal is reached -- a reward
14 // that has never been seen in crypto.
15 //
16 */
17 
18 pragma solidity ^0.4.23;
19 
20 contract ERC20Basic {
21   function totalSupply() public view returns (uint256);
22   function balanceOf(address who) public view returns (uint256);
23   function transfer(address to, uint256 value) public returns (bool);
24   event Transfer(address indexed from, address indexed to, uint256 value);
25 }
26 
27 library SafeMath {
28 
29   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
30     if (a == 0) {
31       return 0;
32     }
33     c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     // uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return a / b;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51     c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   uint256 totalSupply_;
63 
64   function totalSupply() public view returns (uint256) {
65     return totalSupply_;
66   }
67 
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[msg.sender]);
71 
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     emit Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   function balanceOf(address _owner) public view returns (uint256) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender)
86     public view returns (uint256);
87 
88   function transferFrom(address from, address to, uint256 value)
89     public returns (bool);
90 
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(
93     address indexed owner,
94     address indexed spender,
95     uint256 value
96   );
97 }
98 
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103   function transferFrom(
104     address _from,
105     address _to,
106     uint256 _value
107   )
108     public
109     returns (bool)
110   {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     emit Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   function approve(address _spender, uint256 _value) public returns (bool) {
123     allowed[msg.sender][_spender] = _value;
124     emit Approval(msg.sender, _spender, _value);
125     return true;
126   }
127 
128   function allowance(
129     address _owner,
130     address _spender
131    )
132     public
133     view
134     returns (uint256)
135   {
136     return allowed[_owner][_spender];
137   }
138 
139   function increaseApproval(
140     address _spender,
141     uint _addedValue
142   )
143     public
144     returns (bool)
145   {
146     allowed[msg.sender][_spender] = (
147       allowed[msg.sender][_spender].add(_addedValue));
148     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152   function decreaseApproval(
153     address _spender,
154     uint _subtractedValue
155   )
156     public
157     returns (bool)
158   {
159     uint oldValue = allowed[msg.sender][_spender];
160     if (_subtractedValue > oldValue) {
161       allowed[msg.sender][_spender] = 0;
162     } else {
163       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
164     }
165     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169 }
170 
171 contract OHMI is StandardToken {
172 
173   string public constant name = "One Hundred Million Inu"; // solium-disable-line uppercase
174   string public constant symbol = "OHMI"; // solium-disable-line uppercase
175   uint8 public constant decimals = 18; // solium-disable-line uppercase
176 
177   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
178 
179   constructor() public {
180     totalSupply_ = INITIAL_SUPPLY;
181     balances[msg.sender] = INITIAL_SUPPLY;
182     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
183   }
184 
185 }