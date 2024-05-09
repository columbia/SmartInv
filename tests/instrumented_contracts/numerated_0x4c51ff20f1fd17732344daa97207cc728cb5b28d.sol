1 pragma solidity ^0.5.0;
2 
3 contract ERC20Basic {
4     
5   function totalSupply() public view returns (uint256);
6   function balanceOf(address any) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9   
10 }
11 
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28 
29     return a / b;
30   }
31 
32 
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43   
44 }
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   uint256 totalSupply_;
52 
53 
54   function totalSupply() public view returns (uint256) {
55     return totalSupply_;
56   }
57 
58 
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61     require(_value <= balances[msg.sender]);
62 
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     emit Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   function balanceOf(address _owner) public view returns (uint256) {
70     return balances[_owner];
71   }
72 }
73 
74 
75 contract StandardToken is BasicToken {
76 }
77 
78 contract Ownable {
79   address public owner;
80 
81 
82   event OwnershipRenounced(address indexed previousOwner);
83   event OwnershipTransferred(
84     address indexed previousOwner,
85     address indexed newOwner
86   );
87 
88 
89   constructor() public {
90     owner = msg.sender;
91   }
92 
93 
94   modifier onlyOwner() {
95     require(msg.sender == owner);
96     _;
97   }
98 
99   function renounceOwnership() public onlyOwner {
100     emit OwnershipRenounced(owner);
101     owner = address(0);
102   }
103 
104 
105   function transferOwnership(address _newOwner) public onlyOwner {
106     _transferOwnership(_newOwner);
107   }
108 
109 
110   function _transferOwnership(address _newOwner) internal {
111     require(_newOwner != address(0));
112     emit OwnershipTransferred(owner, _newOwner);
113     owner = _newOwner;
114   }
115 }
116 
117 contract MintableToken is StandardToken, Ownable {
118   event Mint(address indexed to, uint256 amount);
119   event MintFinished();
120   event Burn(address indexed _from, uint256 amount);
121 
122   bool public mintingFinished = false;
123 
124 
125   modifier canMint() {
126     require(!mintingFinished);
127     _;
128   }
129   
130   modifier canBurn() {
131     require(!mintingFinished);
132     _;
133   }
134 
135   modifier hasMintPermission() {
136     require(msg.sender == owner);
137     _;
138   }
139   
140    modifier hasBurnPermission() {
141     require(msg.sender == owner);
142     _;
143   }
144  
145 
146   function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
147     totalSupply_ = totalSupply_.add(_amount);
148     balances[_to] = balances[_to].add(_amount);
149     emit Mint(_to, _amount);
150     emit Transfer(address(0), _to, _amount);
151     return true;
152   }
153   
154   function finishMinting() onlyOwner canMint public returns (bool) {
155     mintingFinished = true;
156     emit MintFinished();
157     return true;
158   }
159 
160   function burn(uint256 _amount) hasBurnPermission canBurn public returns (bool) {
161     totalSupply_ = totalSupply_.sub(_amount);
162     balances[msg.sender] = balances[msg.sender].sub(_amount);
163     emit Burn(msg.sender, _amount);
164     return true;
165   }
166 }
167 
168 contract Pausable is Ownable {
169   event Pause();
170   event Unpause();
171 
172   bool public paused = false;
173 
174   modifier whenNotPaused() {
175     require(!paused);
176     _;
177   }
178 
179   modifier whenPaused() {
180     require(paused);
181     _;
182   }
183 
184   function pause() onlyOwner whenNotPaused public {
185     paused = true;
186     emit Pause();
187   }
188 
189   function unpause() onlyOwner whenPaused public {
190     paused = false;
191     emit Unpause();
192   }
193 }
194 
195 contract PausableToken is StandardToken, Pausable {
196 
197   function transfer(
198     address _to,
199     uint256 _value
200   )
201     public
202     whenNotPaused
203     returns (bool)
204   {
205     return super.transfer(_to, _value);
206     
207   }
208 
209 }
210 
211 contract TEST365 is MintableToken, PausableToken {
212 
213   string  public name;
214   string  public symbol;
215   uint256 public decimals;
216 
217   constructor() public {
218     name = " Test365 Token";
219     symbol = "TEST365";
220     decimals = 0;
221     
222     
223   }
224 }