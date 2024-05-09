1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   constructor() public {
16     owner = msg.sender;
17   }
18 
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 }
28 /**
29  * @title Pausable
30  * @dev Base contract which allows children to implement an emergency stop mechanism.
31  */
32 contract Pausable is Ownable {
33   event Pause();
34   event Unpause();
35 
36   bool public paused = false;
37 
38 
39   /**
40    * @dev Modifier to make a function callable only when the contract is not paused.
41    */
42   modifier whenNotPaused() {
43     require(!paused);
44     _;
45   }
46 
47   /**
48    * @dev Modifier to make a function callable only when the contract is paused.
49    */
50   modifier whenPaused() {
51     require(paused);
52     _;
53   }
54 
55   /**
56    * @dev called by the owner to pause, triggers stopped state
57    */
58   function pause() onlyOwner whenNotPaused public {
59     paused = true;
60     emit Pause();
61   }
62 
63   /**
64    * @dev called by the owner to unpause, returns to normal state
65    */
66   function unpause() onlyOwner whenPaused public {
67     paused = false;
68     emit Unpause();
69   }
70 }
71 
72 library SafeMath {
73   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74     if (a == 0) {
75       return 0;
76     }
77     uint256 c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return c;
87   }
88 
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 contract ERC20 {
101   uint256 public totalSupply;
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105   function allowance(address owner, address spender) public view returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 contract GlobalSharingEconomyCoin is Pausable, ERC20 {
112   using SafeMath for uint256;
113 
114   string public name;
115   string public symbol;
116   uint8 public decimals;
117 
118   mapping(address => uint256) balances;
119   mapping (address => mapping (address => uint256)) internal allowed;
120 
121   constructor() public {
122     name = "GlobalSharingEconomyCoin";
123     symbol = "GSE";
124     decimals = 8;
125     totalSupply = 10000000000 * 10 ** uint256(decimals);
126     balances[msg.sender] = totalSupply;
127   }
128 
129   function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
130     require(_to != address(0));
131     require(_value <= balances[msg.sender]);
132 
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     emit Transfer(msg.sender, _to, _value);
136     return true;
137   }
138 
139   function balanceOf(address _owner) public view returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[_from]);
146     require(_value <= allowed[_from][msg.sender]);
147 
148     balances[_from] = balances[_from].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151     emit Transfer(_from, _to, _value);
152     return true;
153   }
154 
155   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     emit Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   function allowance(address _owner, address _spender) public view returns (uint256) {
162     return allowed[_owner][_spender];
163   }
164 }