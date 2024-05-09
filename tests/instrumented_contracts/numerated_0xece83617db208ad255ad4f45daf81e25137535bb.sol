1 pragma solidity ^0.4.23;
2  
3 /*
4    Ⓒ2017 INVACIO
5    INV Coin | Phase 1 ERC20 | Phase 2 Vadgama Chain | Invacio.com 
6    Invacio Coin [INV] is a Cryptocurrency (private digital currency), that has a value based on the current market.
7 
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value) returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15  
16 /*
17    ERC20 interface
18   see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value) returns (bool);
23   function approve(address spender, uint256 value) returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26  
27 /*  SafeMath - the lowest gas library
28   Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37  
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44  
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49  
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55   
56 }
57  
58 /*
59 Basic token
60  Basic version of StandardToken, with no allowances. 
61  */
62 contract BasicToken is ERC20Basic {
63     
64   using SafeMath for uint256;
65  
66   mapping(address => uint256) balances;
67  
68  function transfer(address _to, uint256 _value) returns (bool) {
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74  
75   /*
76   Gets the balance of the specified address.
77    param _owner The address to query the the balance of. 
78    return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) constant returns (uint256 balance) {
81     return balances[_owner];
82   }
83  
84 }
85  
86 /* Implementation of the basic standard token.
87   https://github.com/ethereum/EIPs/issues/20
88  */
89 contract StandardToken is ERC20, BasicToken {
90  
91   mapping (address => mapping (address => uint256)) allowed;
92  
93   /*
94     Transfer tokens from one address to another
95     param _from address The address which you want to send tokens from
96     param _to address The address which you want to transfer to
97     param _value uint256 the amout of tokens to be transfered
98    */
99   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
100     var _allowance = allowed[_from][msg.sender];
101  
102     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
103     // require (_value <= _allowance);
104  
105     balances[_to] = balances[_to].add(_value);
106     balances[_from] = balances[_from].sub(_value);
107     allowed[_from][msg.sender] = _allowance.sub(_value);
108     Transfer(_from, _to, _value);
109     return true;
110   }
111  
112   /*
113   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
114    param _spender The address which will spend the funds.
115    param _value The amount of Roman Lanskoj's tokens to be spent.
116    */
117   function approve(address _spender, uint256 _value) returns (bool) {
118  
119     // To change the approve amount you first have to reduce the addresses`
120     //  allowance to zero by calling `approve(_spender, 0)` if it is not
121     //  already 0 to mitigate the race condition described here:
122     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
124  
125     allowed[msg.sender][_spender] = _value;
126     Approval(msg.sender, _spender, _value);
127     return true;
128   }
129  
130   /*
131   Function to check the amount of tokens that an owner allowed to a spender.
132   param _owner address The address which owns the funds.
133   param _spender address The address which will spend the funds.
134   return A uint256 specifing the amount of tokens still available for the spender.
135    */
136   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
137     return allowed[_owner][_spender];
138   }
139  
140 }
141  
142 /*
143 The Ownable contract has an owner address, and provides basic authorization control
144  functions, this simplifies the implementation of "user permissions".
145  */
146 contract Ownable {
147     
148   address public owner;
149  
150  
151   function Ownable() {
152     owner = 0xD5483f02d8bEd6A1D9deAb9B425aDa80cd1ed645;
153   }
154  
155   /*
156   Throws if called by any account other than the owner.
157    */
158   modifier onlyOwner() {
159     require(msg.sender == owner);
160     _;
161   }
162  
163   /*
164   Allows the current owner to transfer control of the contract to a newOwner.
165   param newOwner The address to transfer ownership to.
166    */
167   function transferOwnership(address newOwner) onlyOwner {
168     require(newOwner != address(0));      
169     owner = newOwner;
170   }
171  
172 }
173  
174 
175     
176 contract Invacio is StandardToken, Ownable {
177   string public constant name = "Invacio Coin";
178   string public constant symbol = "INV";
179   uint public constant decimals = 8;
180   uint256 public initialSupply;
181     
182   function Invacio () { 
183      totalSupply = 60000000 * 10 ** decimals;
184       balances[0xD5483f02d8bEd6A1D9deAb9B425aDa80cd1ed645] = totalSupply;
185       initialSupply = totalSupply; 
186         Transfer(0, this, totalSupply);
187         Transfer(this, 0xD5483f02d8bEd6A1D9deAb9B425aDa80cd1ed645, totalSupply);
188   }
189 }