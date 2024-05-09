1 pragma solidity 0.4.19;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 
48 // File: zeppelin-solidity/contracts/math/SafeMath.sol
49 
50 /**
51  * @title SafeMath
52  * @dev Math operations with safety checks that throw on error
53  */
54 contract SafeMath {
55   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     if (a == 0) {
57       return 0;
58     }
59     uint256 c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 contract ERC20{
84   uint public totalSupply;
85   function balanceOf(address who) constant public returns (uint);
86   function allowance(address owner, address spender) constant public returns (uint);
87 
88   function transfer(address to, uint value) public returns (bool ok);
89   function transferFrom(address from, address to, uint value) public returns (bool ok);
90   function approve(address spender, uint value) public returns (bool ok);
91   event Transfer(address indexed from, address indexed to, uint value);
92   event Approval(address indexed owner, address indexed spender, uint value);
93 }
94 
95 contract TokenSpender {
96     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
97 }
98 
99 contract HYD is ERC20, SafeMath, Ownable{
100     string public name;      
101     string public symbol;
102     uint8 public decimals;    
103     uint public initialSupply;
104     uint public totalSupply;
105     bool public locked;
106 
107     mapping(address => uint) balances;
108     mapping (address => mapping (address => uint)) allowed;
109 
110   // lock transfer during the ICO
111     modifier onlyUnlocked() {
112         require(msg.sender == owner || locked==false);
113         _;
114     }
115 
116   /*
117    *  The RLC Token created with the time at which the crowdsale end
118    */
119 
120   function HYD() public{
121     locked = true;
122     initialSupply = 50000000000000;
123     totalSupply = initialSupply;
124     balances[msg.sender] = initialSupply;// Give the creator all initial tokens                    
125     name = 'Hyde & Co. Token';        // Set the name for display purposes     
126     symbol = 'HYD';                       // Set the symbol for display purposes  
127     decimals = 6;                        // Amount of decimals for display purposes
128   }
129 
130   function unlock() public onlyOwner {
131     locked = false;
132   }
133 
134   function burn(uint256 _value) public returns (bool){
135     balances[msg.sender] = sub(balances[msg.sender], _value) ;
136     totalSupply = sub(totalSupply, _value);
137     Transfer(msg.sender, 0x0, _value);
138     return true;
139   }
140 
141   function transfer(address _to, uint _value) public onlyUnlocked returns (bool) {
142     balances[msg.sender] = sub(balances[msg.sender], _value);
143     balances[_to] = add(balances[_to], _value);
144     Transfer(msg.sender, _to, _value);
145     return true;
146   }
147 
148   function transferFrom(address _from, address _to, uint _value) public onlyUnlocked returns (bool) {
149     var _allowance = allowed[_from][msg.sender];
150     
151     balances[_to] = add(balances[_to], _value);
152     balances[_from] = sub(balances[_from], _value);
153     allowed[_from][msg.sender] = sub(_allowance, _value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   function balanceOf(address _owner) public constant returns (uint balance) {
159     return balances[_owner];
160   }
161 
162   function approve(address _spender, uint _value) public returns (bool) {
163     allowed[msg.sender][_spender] = _value;
164     Approval(msg.sender, _spender, _value);
165     return true;
166   }
167 
168     /* Approve and then comunicate the approved contract in a single tx */
169   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public {    
170       TokenSpender spender = TokenSpender(_spender);
171       if (approve(_spender, _value)) {
172           spender.receiveApproval(msg.sender, _value, this, _extraData);
173       }
174   }
175 
176   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
177     return allowed[_owner][_spender];
178   }
179   
180 }