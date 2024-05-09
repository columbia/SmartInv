1 pragma solidity ^0.4.18;
2  
3 /* 
4   © foxex.io
5   FOXEX Token
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) constant returns (uint256);
10   function transfer(address to, uint256 value) returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13  
14 /*
15    ERC20 interface
16   see https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender) constant returns (uint256);
20   function transferFrom(address from, address to, uint256 value) returns (bool);
21   function approve(address spender, uint256 value) returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24  
25 /*  SafeMath - the lowest gas library
26   Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29     
30   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35  
36   function div(uint256 a, uint256 b) internal constant returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42  
43   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47  
48   function add(uint256 a, uint256 b) internal constant returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53   
54 }
55  
56 /*
57 Basic token
58  Basic version of StandardToken, with no allowances. 
59  */
60 contract BasicToken is ERC20Basic {
61     
62   using SafeMath for uint256;
63  
64   mapping(address => uint256) balances;
65  
66  function transfer(address _to, uint256 _value) returns (bool) {
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72  
73   /*
74   Gets the balance of the specified address.
75    param _owner The address to query the the balance of. 
76    return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) constant returns (uint256 balance) {
79     return balances[_owner];
80   }
81  
82 }
83  
84 /* Implementation of the basic standard token.
85   https://github.com/ethereum/EIPs/issues/20
86  */
87 contract StandardToken is ERC20, BasicToken {
88  
89   mapping (address => mapping (address => uint256)) allowed;
90  
91   /*
92     Transfer tokens from one address to another
93     param _from address The address which you want to send tokens from
94     param _to address The address which you want to transfer to
95     param _value uint256 the amout of tokens to be transfered
96    */
97   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
98     var _allowance = allowed[_from][msg.sender];
99  
100     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
101     // require (_value <= _allowance);
102  
103     balances[_to] = balances[_to].add(_value);
104     balances[_from] = balances[_from].sub(_value);
105     allowed[_from][msg.sender] = _allowance.sub(_value);
106     Transfer(_from, _to, _value);
107     return true;
108   }
109  
110   /*
111   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
112    param _spender The address which will spend the funds.
113    param _value The amount of Roman Lanskoj's tokens to be spent.
114    */
115   function approve(address _spender, uint256 _value) returns (bool) {
116  
117     // To change the approve amount you first have to reduce the addresses`
118     //  allowance to zero by calling `approve(_spender, 0)` if it is not
119     //  already 0 to mitigate the race condition described here:
120     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
122  
123     allowed[msg.sender][_spender] = _value;
124     Approval(msg.sender, _spender, _value);
125     return true;
126   }
127  
128   /*
129   Function to check the amount of tokens that an owner allowed to a spender.
130   param _owner address The address which owns the funds.
131   param _spender address The address which will spend the funds.
132   return A uint256 specifing the amount of tokens still available for the spender.
133    */
134   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
135     return allowed[_owner][_spender];
136 }
137 }
138  
139 /*
140 The Ownable contract has an owner address, and provides basic authorization control
141  functions, this simplifies the implementation of "user permissions".
142  */
143 contract Ownable {
144     
145   address public owner;
146  
147  
148   function Ownable() {
149     owner = 0x2B58ff794923166197d42E4d79E4Fa7c5746EFbF;
150   }
151  
152   /*
153   Throws if called by any account other than the owner.
154    */
155   modifier onlyOwner() {
156     require(0x2B58ff794923166197d42E4d79E4Fa7c5746EFbF == owner);
157     _;
158   }
159  
160   /*
161   Allows the current owner to transfer control of the contract to a newOwner.
162   param newOwner The address to transfer ownership to.
163    */
164   function transferOwnership(address newOwner) onlyOwner {
165     require(newOwner != address(0));      
166     owner = newOwner;
167   }
168 }
169 
170     
171 contract GIFTtoken is StandardToken, Ownable {
172   string public constant name = "GIFT coin";
173   string public constant symbol = "GIFT";
174   uint public constant decimals = 11;
175   uint256 public initialSupply;
176     
177   function GIFTtoken () { 
178      totalSupply = 100000000 * 10 ** decimals;
179       balances[0x2B58ff794923166197d42E4d79E4Fa7c5746EFbF] = totalSupply;
180       initialSupply = totalSupply; 
181         Transfer(0, this, totalSupply);
182         Transfer(this, 0x2B58ff794923166197d42E4d79E4Fa7c5746EFbF, totalSupply);
183   }
184  function distribute55M(address[] addresses) onlyOwner {
185     // 6986.7886 * (10**11)
186     for (uint i = 0; i < addresses.length; i++) {
187       balances[owner] -= 698678861788617;
188       balances[addresses[i]] += 698678861788617;
189       Transfer(owner, addresses[i], 698678861788617);
190     }
191   }
192 }