1 pragma solidity ^0.5.0;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18 
19 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20 		uint256 c = a * b;
21 		assert(a == 0 || c / a == b);
22 		return c;
23 	}
24 
25 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
26 		uint256 c = a / b;
27 		return c;
28 	}
29 
30 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31 		assert(b <= a);
32 		return a - b;
33 	}
34 	
35 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
36 		c = a + b;
37 		assert(c >= a);
38 		return c;
39 	}
40 }
41 
42 contract BasicToken is ERC20Basic {
43   using SafeMath for uint256;
44 
45   mapping(address => uint256) balances;
46 
47   uint256 totalSupply_;
48 
49 
50   function totalSupply() public view returns (uint256) {
51     return totalSupply_;
52   }
53 
54   function transfer(address _to, uint256 _value) public returns (bool) {
55     require(_to != address(0));
56     require(_value <= balances[msg.sender]);
57 
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     emit Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64   function balanceOf(address _owner) public view returns (uint256) {
65     return balances[_owner];
66   }
67 
68 }
69 
70 contract StandardToken is ERC20, BasicToken {
71 
72   mapping (address => mapping (address => uint256)) internal allowed;
73 
74   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76     require(_value <= balances[_from]);
77     require(_value <= allowed[_from][msg.sender]);
78 
79     balances[_from] = balances[_from].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82     emit Transfer(_from, _to, _value);
83     return true;
84   }
85 
86 
87   function approve(address _spender, uint256 _value) public returns (bool) {
88     allowed[msg.sender][_spender] = _value;
89     emit Approval(msg.sender, _spender, _value);
90     return true;
91   }
92 
93   function allowance(address _owner, address _spender) public view returns (uint256) {
94     return allowed[_owner][_spender];
95   }
96 
97   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
98     allowed[msg.sender][_spender] = (
99       allowed[msg.sender][_spender].add(_addedValue));
100     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
101     return true;
102   }
103 
104   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105     uint oldValue = allowed[msg.sender][_spender];
106     
107     if (_subtractedValue > oldValue) {
108       allowed[msg.sender][_spender] = 0;
109     } else {
110       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
111     }
112     
113     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114     return true;
115   }
116 
117 }
118 
119 contract Ownable {
120   address public owner;
121 
122 
123   event OwnershipRenounced(address indexed previousOwner);
124   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126 
127   constructor() public {
128     owner = msg.sender;
129   }
130 
131   modifier onlyOwner() {
132     require(msg.sender == owner);
133     _;
134   }
135 
136   function transferOwnership(address newOwner) public onlyOwner {
137     require(newOwner != address(0));
138     emit OwnershipTransferred(owner, newOwner);
139     owner = newOwner;
140   }
141 
142   function renounceOwnership() public onlyOwner {
143     emit OwnershipRenounced(owner);
144     owner = address(0);
145   }
146 }
147 
148 contract Pausable is Ownable {
149   event Pause();
150   event Unpause();
151   event NotPausable();
152 
153   bool public paused = false;
154   bool public canPause = true;
155 
156   modifier whenNotPaused() {
157     require(!paused || msg.sender == owner);
158     _;
159   }
160 
161   modifier whenPaused() {
162     require(paused);
163     _;
164   }
165 
166     function pause() onlyOwner whenNotPaused public {
167         require(canPause == true);
168         paused = true;
169         emit Pause();
170     }
171 
172   function unpause() onlyOwner whenPaused public {
173     require(paused == true);
174     paused = false;
175     emit Unpause();
176   }
177   
178     function notPausable() onlyOwner public{
179         paused = false;
180         canPause = false;
181         emit NotPausable();
182     }
183 }
184 
185 contract sdcoin is StandardToken, Pausable {
186     string public constant NAME = "SDCOIN";
187     string public constant SYMBOL = "SDC";
188     uint256 public constant DECIMALS = 18;
189     uint256 public constant INITIAL_SUPPLY = 3500000000 * 10**18;
190 
191     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
192         return super.transfer(_to, _value);
193     }
194     
195     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
196         return super.transferFrom(_from, _to, _value);
197     }
198     
199     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
200         return super.approve(_spender, _value);
201     }
202     
203     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
204         return super.increaseApproval(_spender, _addedValue);
205     }
206     
207     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
208         return super.decreaseApproval(_spender, _subtractedValue);
209     }
210     
211   constructor() public {
212     totalSupply_ = INITIAL_SUPPLY;
213     balances[msg.sender] = INITIAL_SUPPLY;
214   } 
215 }