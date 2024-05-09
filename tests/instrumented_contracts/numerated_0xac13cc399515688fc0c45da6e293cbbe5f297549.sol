1 pragma solidity ^0.4.25;
2 
3 /******************************************/
4 /*     Netkiller Standard safe token      */
5 /******************************************/
6 /* Author netkiller <netkiller@msn.com>   */
7 /* Home http://www.netkiller.cn           */
8 /* Version 2018-09-30                     */
9 /******************************************/
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that revert on error
14  */
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, reverts on overflow.
19   */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
22     // benefit is lost if 'b' is also tested.
23     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24     if (a == 0) {
25       return 0;
26     }
27 
28     uint256 c = a * b;
29     require(c / a == b);
30 
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b > 0); // Solidity only automatically asserts when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 
42     return c;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b <= a);
50     uint256 c = a - b;
51 
52     return c;
53   }
54 
55   /**
56   * @dev Adds two numbers, reverts on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     require(c >= a);
61 
62     return c;
63   }
64 
65   /**
66   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
67   * reverts when dividing by zero.
68   */
69   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b != 0);
71     return a % b;
72   }
73 }
74 
75 contract Ownable {
76     
77     address public owner;
78     
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80     
81     constructor() public {
82         owner = msg.sender;
83     }
84     
85     modifier onlyOwner() {
86         require(msg.sender == owner);
87         _;
88     }
89     
90     function transferOwnership(address newOwner) public onlyOwner {
91         require(newOwner != address(0));
92         emit OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94     }
95 
96 }
97 
98 contract NetkillerToken is Ownable{
99     
100     using SafeMath for uint256;
101     
102     string public name;
103     string public symbol;
104     uint public decimals;
105     uint256 public totalSupply;
106     
107     // This creates an array with all balances
108     mapping (address => uint256) internal balances;
109     mapping (address => mapping (address => uint256)) internal allowed;
110 
111     // This generates a public event on the blockchain that will notify clients
112     event Transfer(address indexed from, address indexed to, uint256 value);
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 
115     constructor(
116         uint256 initialSupply,
117         string tokenName,
118         string tokenSymbol,
119         uint decimalUnits
120     ) public {
121         owner = msg.sender;
122         name = tokenName;                                   // Set the name for display purposes
123         symbol = tokenSymbol; 
124         decimals = decimalUnits;
125         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
126         balances[msg.sender] = totalSupply;                // Give the creator all initial token
127     }
128 
129     function balanceOf(address _address) view public returns (uint256 balance) {
130         return balances[_address];
131     }
132     
133     /* Internal transfer, only can be called by this contract */
134     function _transfer(address _from, address _to, uint256 _value) internal {
135         require (_to != address(0));                        // Prevent transfer to 0x0 address. Use burn() instead
136         require (balances[_from] >= _value);                // Check if the sender has enough
137         require (balances[_to] + _value > balances[_to]);   // Check for overflows
138         balances[_from] = balances[_from].sub(_value);      // Subtract from the sender
139         balances[_to] = balances[_to].add(_value);          // Add the same to the recipient
140         emit Transfer(_from, _to, _value);
141     }
142 
143     function transfer(address _to, uint256 _value) public returns (bool success) {
144         _transfer(msg.sender, _to, _value);
145         return true;
146     }
147 
148     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
149         require(_value <= balances[_from]);
150         require(_value <= allowed[_from][msg.sender]);     // Check allowance
151         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152         _transfer(_from, _to, _value);
153         return true;
154     }
155 
156     function approve(address _spender, uint256 _value) public returns (bool success) {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
162         return allowed[_owner][_spender];
163     }
164 
165     function airdrop(address[] _to, uint256 _value) onlyOwner public returns (bool success) {
166         
167         require(_value > 0 && balanceOf(msg.sender) >= _value.mul(_to.length));
168         
169         for (uint i=0; i<_to.length; i++) {
170             _transfer(msg.sender, _to[i], _value);
171         }
172         return true;
173     }
174     
175     function batchTransfer(address[] _to, uint256[] _value) onlyOwner public returns (bool success) {
176         require(_to.length == _value.length);
177 
178         uint256 amount = 0;
179         for(uint n=0;n<_value.length;n++){
180             amount = amount.add(_value[n]);
181         }
182         
183         require(amount > 0 && balanceOf(msg.sender) >= amount);
184         
185         for (uint i=0; i<_to.length; i++) {
186             transfer(_to[i], _value[i]);
187         }
188         return true;
189     }
190 }