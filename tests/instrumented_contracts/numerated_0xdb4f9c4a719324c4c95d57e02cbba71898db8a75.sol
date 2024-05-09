1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Owned contract
53 // ----------------------------------------------------------------------------
54 contract Owned {
55     address public owner;
56     address public newOwner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     constructor() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) public onlyOwner {
70         newOwner = _newOwner;
71     }
72     function acceptOwnership() public {
73         require(msg.sender == newOwner);
74         emit OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76         newOwner = address(0);
77     }
78 }
79 
80 contract ERC223 {
81   uint public totalSupply;
82   function balanceOf(address who) constant returns (uint);
83 
84   function name() constant returns (string _name);
85   function symbol() constant returns (string _symbol);
86   function decimals() constant returns (uint8 _decimals);
87   function totalSupply() constant returns (uint256 _supply);
88 
89   function transfer(address to, uint value) returns (bool ok);
90   function transfer(address to, uint value, bytes data) returns (bool ok);
91   event Transfer(address indexed _from, address indexed _to, uint256 _value);
92   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
93 }
94 
95 contract ContractReceiver {
96   function tokenFallback(address _from, uint _value, bytes _data);
97 }
98 
99 contract ERC223Token is ERC223 {
100   using SafeMath for uint;
101 
102   mapping(address => uint) balances;
103 
104   string public name;
105   string public symbol;
106   uint8 public decimals;
107   uint256 public totalSupply;
108 
109 
110   // Function to access name of token .
111   function name() constant returns (string _name) {
112       return name;
113   }
114   // Function to access symbol of token .
115   function symbol() constant returns (string _symbol) {
116       return symbol;
117   }
118   // Function to access decimals of token .
119   function decimals() constant returns (uint8 _decimals) {
120       return decimals;
121   }
122   // Function to access total supply of tokens .
123   function totalSupply() constant returns (uint256 _totalSupply) {
124       return totalSupply;
125   }
126 
127   // Function that is called when a user or another contract wants to transfer funds .
128   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
129     if(isContract(_to)) {
130         return transferToContract(_to, _value, _data);
131     }
132     else {
133         return transferToAddress(_to, _value, _data);
134     }
135 }
136 
137   // Standard function transfer similar to ERC20 transfer with no _data .
138   // Added due to backwards compatibility reasons .
139   function transfer(address _to, uint _value) returns (bool success) {
140 
141     //standard function transfer similar to ERC20 transfer with no _data
142     //added due to backwards compatibility reasons
143     bytes memory empty;
144     if(isContract(_to)) {
145         return transferToContract(_to, _value, empty);
146     }
147     else {
148         return transferToAddress(_to, _value, empty);
149     }
150 }
151 
152 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
153   function isContract(address _addr) private returns (bool is_contract) {
154       uint length;
155       assembly {
156             //retrieve the size of the code on target address, this needs assembly
157             length := extcodesize(_addr)
158         }
159         if(length>0) {
160             return true;
161         }
162         else {
163             return false;
164         }
165     }
166 
167   //function that is called when transaction target is an address
168   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
169     if (balanceOf(msg.sender) < _value) revert();
170     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
171     balances[_to] = balanceOf(_to).add(_value);
172     Transfer(msg.sender, _to, _value);
173     ERC223Transfer(msg.sender, _to, _value, _data);
174     return true;
175   }
176 
177   //function that is called when transaction target is a contract
178   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
179     if (balanceOf(msg.sender) < _value) revert();
180     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
181     balances[_to] = balanceOf(_to).add(_value);
182     ContractReceiver reciever = ContractReceiver(_to);
183     reciever.tokenFallback(msg.sender, _value, _data);
184     Transfer(msg.sender, _to, _value);
185     ERC223Transfer(msg.sender, _to, _value, _data);
186     return true;
187   }
188 
189 
190   function balanceOf(address _owner) constant returns (uint balance) {
191     return balances[_owner];
192   }
193 }
194 
195 contract AllPointPay is ERC223Token, Owned {
196   string public name = "AllPointPay";
197   string public symbol = "APP";
198   uint public decimals = 8;
199   uint public totalSupply = 1000000000 * 10**uint(decimals);
200 
201   function AllPointPay() {
202     balances[owner] = totalSupply;
203     emit Transfer(address(0), owner, totalSupply);
204   }
205 }