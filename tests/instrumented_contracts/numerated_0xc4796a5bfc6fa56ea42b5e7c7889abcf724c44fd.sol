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
12   address public creator;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24     creator = msg.sender;
25   }
26 
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner || msg.sender == creator);
33     _;
34   }
35 
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 
50 // File: zeppelin-solidity/contracts/math/SafeMath.sol
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 contract SafeMath {
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     if (a == 0) {
59       return 0;
60     }
61     uint256 c = a * b;
62     assert(c / a == b);
63     return c;
64   }
65 
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 
85 contract ERC20{
86   uint public totalSupply;
87   function balanceOf(address who) constant public returns (uint);
88   function allowance(address owner, address spender) constant public returns (uint);
89 
90   function transfer(address to, uint value) public returns (bool ok);
91   function transferFrom(address from, address to, uint value) public returns (bool ok);
92   function approve(address spender, uint value) public returns (bool ok);
93   event Transfer(address indexed from, address indexed to, uint value);
94   event Approval(address indexed owner, address indexed spender, uint value);
95 }
96 
97 contract TokenSpender {
98     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
99 }
100 
101 contract HYD is ERC20, SafeMath, Ownable{
102     string public name;      
103     string public symbol;
104     uint8 public decimals;    
105     uint public initialSupply;
106     uint public totalSupply;
107     bool public locked;
108 
109     mapping(address => uint) balances;
110     mapping (address => mapping (address => uint)) allowed;
111 
112   // lock transfer during the ICO
113     modifier onlyUnlocked() {
114         require(msg.sender == owner || msg.sender == creator || locked==false);
115         _;
116     }
117 
118   /*
119    *  The RLC Token created with the time at which the crowdsale end
120    */
121 
122   function HYD() public{
123     locked = true;
124     initialSupply = 50000000000000;
125     totalSupply = initialSupply;
126     balances[msg.sender] = initialSupply;// Give the creator all initial tokens                    
127     name = 'Hyde & Co. Token';        // Set the name for display purposes     
128     symbol = 'HYD';                       // Set the symbol for display purposes  
129     decimals = 6;                        // Amount of decimals for display purposes
130   }
131 
132   function unlock() public onlyOwner {
133     locked = false;
134   }
135 
136   function burn(uint256 _value) public onlyOwner returns (bool){
137     balances[msg.sender] = sub(balances[msg.sender], _value) ;
138     totalSupply = sub(totalSupply, _value);
139     Transfer(msg.sender, 0x0, _value);
140     return true;
141   }
142 
143   function transfer(address _to, uint _value) public onlyUnlocked returns (bool) {
144     uint fromBalance = balances[msg.sender];
145     require((_value > 0) && (_value <= fromBalance));
146     balances[msg.sender] = sub(balances[msg.sender], _value);
147     balances[_to] = add(balances[_to], _value);
148     Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   function transferFrom(address _from, address _to, uint _value) public onlyUnlocked returns (bool) {
153     uint _allowance = allowed[_from][msg.sender];
154     uint fromBalance = balances[_from];
155     require(_value <= _allowance && _value <= fromBalance && _value > 0);
156     balances[_to] = add(balances[_to], _value);
157     balances[_from] = sub(balances[_from], _value);
158     allowed[_from][msg.sender] = sub(_allowance, _value);
159     Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   function balanceOf(address _owner) public constant returns (uint balance) {
164     return balances[_owner];
165   }
166 
167   function approve(address _spender, uint _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173     /* Approve and then comunicate the approved contract in a single tx */
174   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public {    
175       TokenSpender spender = TokenSpender(_spender);
176       if (approve(_spender, _value)) {
177           spender.receiveApproval(msg.sender, _value, this, _extraData);
178       }
179   }
180 
181   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
182     return allowed[_owner][_spender];
183   }
184   
185 }