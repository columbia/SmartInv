1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42    function kill() public onlyOwner{
43       
44           selfdestruct(owner); // 销毁合约
45        
46     }
47 
48 }
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
90   }
91 }
92 
93 library SafeMath {
94   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95     if (a == 0) {
96       return 0;
97     }
98     uint256 c = a * b;
99     assert(c / a == b);
100     return c;
101   }
102 
103   function div(uint256 a, uint256 b) internal pure returns (uint256) {
104     // assert(b > 0); // Solidity automatically throws when dividing by 0
105     uint256 c = a / b;
106     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107     return c;
108   }
109 
110   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111     assert(b <= a);
112     return a - b;
113   }
114 
115   function add(uint256 a, uint256 b) internal pure returns (uint256) {
116     uint256 c = a + b;
117     assert(c >= a);
118     return c;
119   }
120 }
121 contract ERC20 {
122   uint256 public totalSupply;
123   function balanceOf(address who) public view returns (uint256);
124   function transfer(address to, uint256 value) public returns (bool);
125   event Transfer(address indexed from, address indexed to, uint256 value);
126   function allowance(address owner, address spender) public view returns (uint256);
127   function transferFrom(address from, address to, uint256 value) public returns (bool);
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 contract DetailedERC20 is ERC20 {
133   string public name;
134   string public symbol;
135   uint8 public decimals;
136 
137   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
138     name = _name;
139     symbol = _symbol;
140     decimals = _decimals;
141   }
142 }
143 
144 contract UNC is Pausable, DetailedERC20 {
145   using SafeMath for uint256;
146 
147   mapping(address => uint256) balances;
148   mapping (address => mapping (address => uint256)) internal allowed;
149 
150   function UNC() DetailedERC20("Unicorn Investments", "UNC", 18) public {
151     totalSupply = 50000000 * 10 ** uint256(decimals);
152     balances[msg.sender] = totalSupply;
153   }
154 
155 
156   function transfer(address _to, uint256 _value)  whenNotPaused public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[msg.sender]);
159 
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166 
167   function balanceOf(address _owner) public view returns (uint256 balance) {
168     return balances[_owner];
169   }
170 
171 
172   function transferFrom(address _from, address _to, uint256 _value) public  whenNotPaused returns (bool) {
173     require(_to != address(0));
174     require(_value <= balances[_from]);
175     require(_value <= allowed[_from][msg.sender]);
176 
177     balances[_from] = balances[_from].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180     Transfer(_from, _to, _value);
181     return true;
182   }
183 
184   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   function allowance(address _owner, address _spender) public view returns (uint256) {
191     return allowed[_owner][_spender];
192   }
193 
194   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199  
200 
201   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 }