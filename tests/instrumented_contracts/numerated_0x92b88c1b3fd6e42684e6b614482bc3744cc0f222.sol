1 /**
2  * Source Code first verified at https://etherscan.io on Saturday, May 26, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.18;
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract Ownable {
35   address public owner;
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37   function Ownable() public {
38     owner = msg.sender;
39   }
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46 
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 contract Pausable is Ownable {
56   event Pause();
57   event Unpause();
58 
59   bool public paused = false;
60 
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   function pause() onlyOwner whenNotPaused public {
72     paused = true;
73     Pause();
74   }
75 
76   function unpause() onlyOwner whenPaused public {
77     paused = false;
78     Unpause();
79   }
80 }
81 
82 contract ERC20Basic {
83   uint256 public totalSupply;
84   function balanceOf(address who) public view returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public view returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100   
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[msg.sender]);
104 
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 contract StandardToken is ERC20, BasicToken {
118 
119   mapping (address => mapping (address => uint256)) internal allowed;
120 
121   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[_from]);
124     require(_value <= allowed[_from][msg.sender]);
125 
126     balances[_from] = balances[_from].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129     Transfer(_from, _to, _value);
130     return true;
131   }
132 
133   function approve(address _spender, uint256 _value) public returns (bool) {
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   function allowance(address _owner, address _spender) public view returns (uint256) {
140     return allowed[_owner][_spender];
141   }
142 
143   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
144     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
145     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146     return true;
147   }
148 
149   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
150     uint oldValue = allowed[msg.sender][_spender];
151     if (_subtractedValue > oldValue) {
152       allowed[msg.sender][_spender] = 0;
153     } else {
154       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
155     }
156     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160 }
161 
162 contract PausableToken is StandardToken, Pausable {
163 
164   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
165     return super.transfer(_to, _value);
166   }
167 
168   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
169     return super.transferFrom(_from, _to, _value);
170   }
171 
172   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
173     return super.approve(_spender, _value);
174   }
175 
176   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
177     return super.increaseApproval(_spender, _addedValue);
178   }
179 
180   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
181     return super.decreaseApproval(_spender, _subtractedValue);
182   }
183 }
184 
185 contract SinmaToken is PausableToken {
186     string public name = "Sinma";
187     string public symbol = "Sinma";
188     uint public decimals = 18;
189     uint public INITIAL_SUPPLY = 90000000000000000000000000;
190 
191     function SinmaToken() public {
192         totalSupply = INITIAL_SUPPLY;
193         balances[msg.sender] = INITIAL_SUPPLY;
194     }
195 }