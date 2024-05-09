1 pragma solidity ^0.4.18;
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
47 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
48 
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
93 // File: zeppelin-solidity/contracts/math/SafeMath.sol
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   uint256 public totalSupply;
137   function balanceOf(address who) public view returns (uint256);
138   function transfer(address to, uint256 value) public returns (bool);
139   event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 // File: zeppelin-solidity/contracts/token/ERC20.sol
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public view returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 // File: contracts/PrivateSale.sol
156 
157 contract PrivateSale is Pausable {
158     using SafeMath for uint256;
159 
160     ERC20 public token;
161     uint256 public rate = 1000;
162 
163     function PrivateSale(address _token) public {
164         token = ERC20(_token);
165     }
166 
167     function setToken(address _tokenAddr) public onlyOwner {
168         token = ERC20(_tokenAddr);
169     }
170 
171     function setRate(uint256 _rate) public onlyOwner {
172         rate = _rate;
173     }
174 
175     function transferToken(address _to, uint256 _value) public onlyOwner {
176         token.transfer(_to, _value);
177     }
178 
179     function () public payable whenNotPaused {
180         require(token != address(0));
181         require(msg.value > 0);
182 
183         uint256 amount = msg.value.mul(rate);
184         uint256 currentBal = token.balanceOf(this);
185         if (currentBal >= amount) {
186             owner.transfer(msg.value);
187             token.transfer(msg.sender, amount);
188         } else {
189             uint256 value = currentBal.div(rate);
190             owner.transfer(value);
191             token.transfer(msg.sender, currentBal);
192             msg.sender.transfer(msg.value.sub(value));
193         }
194     }
195 }