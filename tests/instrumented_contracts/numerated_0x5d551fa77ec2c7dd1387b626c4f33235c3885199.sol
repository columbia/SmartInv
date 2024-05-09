1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {   
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipRenounced(address indexed previousOwner);
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37 
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     emit OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipRenounced(owner);
55     owner = address(0);
56   }
57 }
58 
59 contract Pausable is Ownable {
60   event Pause();
61   event Unpause();
62 
63   bool public paused = false;
64 
65 
66   modifier whenNotPaused() {
67     require(!paused);
68     _;
69   }
70 
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   function pause() onlyOwner whenNotPaused public {
77     paused = true;
78     emit Pause();
79   }
80 
81   function unpause() onlyOwner whenPaused public {
82     paused = false;
83     emit Unpause();
84   }
85 }
86 
87 contract ERC20Basic {
88   function totalSupply() public view returns (uint256);
89   function balanceOf(address who) public view returns (uint256);
90   function transfer(address to, uint256 value) public returns (bool);
91   event Transfer(address indexed from, address indexed to, uint256 value);
92 }
93 
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public view returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) balances;
105 
106   uint256 totalSupply_;
107 
108 
109   function totalSupply() public view returns (uint256) {
110     return totalSupply_;
111   }
112 
113 
114   function transfer(address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value <= balances[msg.sender]);
117 
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     emit Transfer(msg.sender, _to, _value);
121     return true;
122   }
123 
124 
125   function balanceOf(address _owner) public view returns (uint256) {
126     return balances[_owner];
127   }
128 
129 }
130 
131 contract StandardToken is ERC20, BasicToken {
132 
133   mapping (address => mapping (address => uint256)) internal allowed;
134 
135 
136   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[_from]);
139     require(_value <= allowed[_from][msg.sender]);
140 
141     balances[_from] = balances[_from].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144     emit Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   function approve(address _spender, uint256 _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     emit Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154 
155   function allowance(address _owner, address _spender) public view returns (uint256) {
156     return allowed[_owner][_spender];
157   }
158 
159 
160   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177 }
178 
179 contract PausableToken is StandardToken, Pausable {
180 
181   function transfer(
182     address _to,
183     uint256 _value
184   )
185     public
186     whenNotPaused
187     returns (bool)
188   {
189     return super.transfer(_to, _value);
190   }
191 
192   function transferFrom(
193     address _from,
194     address _to,
195     uint256 _value
196   )
197     public
198     whenNotPaused
199     returns (bool)
200   {
201     return super.transferFrom(_from, _to, _value);
202   }
203 
204   function approve(
205     address _spender,
206     uint256 _value
207   )
208     public
209     whenNotPaused
210     returns (bool)
211   {
212     return super.approve(_spender, _value);
213   }
214 
215   function increaseApproval(
216     address _spender,
217     uint _addedValue
218   )
219     public
220     whenNotPaused
221     returns (bool success)
222   {
223     return super.increaseApproval(_spender, _addedValue);
224   }
225 
226   function decreaseApproval(
227     address _spender,
228     uint _subtractedValue
229   )
230     public
231     whenNotPaused
232     returns (bool success)
233   {
234     return super.decreaseApproval(_spender, _subtractedValue);
235   }
236 }
237 
238 contract BlockSports is PausableToken {
239     
240     string public name = "BlockSports";
241     string public symbol = "BSP";
242     uint8 public decimals = 18;
243     
244     constructor () public {
245         totalSupply_=2100000000*(10**(uint256(decimals)));
246         balances[msg.sender] = totalSupply_;
247     }
248     
249 	function withdrawEther(uint256 amount) onlyOwner public {
250 		owner.transfer(amount);
251 	}
252 	
253 	function() payable public {
254     }
255     
256 }