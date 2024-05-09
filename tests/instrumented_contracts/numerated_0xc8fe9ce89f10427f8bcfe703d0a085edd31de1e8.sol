1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipRenounced(address indexed previousOwner);
22   event OwnershipTransferred(
23     address indexed previousOwner,
24     address indexed newOwner
25   );
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   constructor() public {
33     owner = msg.sender;
34   }
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   /**
45    * @dev Allows the current owner to relinquish control of the contract.
46    * @notice Renouncing to ownership will leave the contract without an owner.
47    * It will not be possible to call the functions with the `onlyOwner`
48    * modifier anymore.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address _newOwner) public onlyOwner {
60     _transferOwnership(_newOwner);
61   }
62 
63   /**
64    * @dev Transfers control of the contract to a newOwner.
65    * @param _newOwner The address to transfer ownership to.
66    */
67   function _transferOwnership(address _newOwner) internal {
68     require(_newOwner != address(0));
69     emit OwnershipTransferred(owner, _newOwner);
70     owner = _newOwner;
71   }
72 }
73 
74 contract Pausable is Ownable {
75   event Pause();
76   event Unpause();
77 
78   bool public paused = false;
79 
80 
81   /**
82    * @dev Modifier to make a function callable only when the contract is not paused.
83    */
84   modifier whenNotPaused() {
85     require(!paused);
86     _;
87   }
88 
89   /**
90    * @dev Modifier to make a function callable only when the contract is paused.
91    */
92   modifier whenPaused() {
93     require(paused);
94     _;
95   }
96 
97   /**
98    * @dev called by the owner to pause, triggers stopped state
99    */
100   function pause() onlyOwner whenNotPaused public {
101     paused = true;
102     emit Pause();
103   }
104 
105   /**
106    * @dev called by the owner to unpause, returns to normal state
107    */
108   function unpause() onlyOwner whenPaused public {
109     paused = false;
110     emit Unpause();
111   }
112 }
113 library SafeMath {
114   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115     if (a == 0) {
116       return 0;
117     }
118     uint256 c = a * b;
119     assert(c / a == b);
120     return c;
121   }
122 
123   function div(uint256 a, uint256 b) internal pure returns (uint256) {
124     // assert(b > 0); // Solidity automatically throws when dividing by 0
125     uint256 c = a / b;
126     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127     return c;
128   }
129 
130   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131     assert(b <= a);
132     return a - b;
133   }
134 
135   function add(uint256 a, uint256 b) internal pure returns (uint256) {
136     uint256 c = a + b;
137     assert(c >= a);
138     return c;
139   }
140 }
141 
142 contract AEC is ERC20,Pausable{
143 	using SafeMath for uint256;
144 
145 	//the base info of the token
146 	string public constant name="Air Ethereum Club";
147 	string public constant symbol="AEC";
148 	string public constant version = "1.0";
149 	uint256 public constant decimals = 18;
150 
151 
152 
153     uint256 public constant MAX_SUPPLY=1000000000*10**decimals;
154 	 
155 	//ERC20的余额
156     mapping(address => uint256) balances;
157 	mapping (address => mapping (address => uint256)) allowed;
158 	
159 
160      constructor() public{
161 		totalSupply = MAX_SUPPLY ;
162 		balances[msg.sender]=MAX_SUPPLY;
163 
164 	}
165 
166 
167   	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool)
168  	{
169 		require(_to != address(0));
170 
171 		// SafeMath.sub will throw if there is not enough balance.
172 		balances[msg.sender] = balances[msg.sender].sub(_value);
173 		balances[_to] = balances[_to].add(_value);
174 		emit Transfer(msg.sender, _to, _value);
175 		return true;
176   	}
177 
178   	function balanceOf(address _owner) public constant returns (uint256 balance) 
179   	{
180 		return balances[_owner];
181   	}
182 
183 
184   	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) 
185   	{
186 		require(_to != address(0));
187 
188 		uint256 _allowance = allowed[_from][msg.sender];
189 
190 		balances[_from] = balances[_from].sub(_value);
191 		balances[_to] = balances[_to].add(_value);
192 		allowed[_from][msg.sender] = _allowance.sub(_value);
193 		emit Transfer(_from, _to, _value);
194 		return true;
195   	}
196 
197   	function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) 
198   	{
199 		allowed[msg.sender][_spender] = _value;
200 		emit Approval(msg.sender, _spender, _value);
201 		return true;
202   	}
203 
204   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
205   	{
206 		return allowed[_owner][_spender];
207   	}
208 	  
209 }