1 pragma solidity ^0.4.18;
2  
3 /* 
4     NJES COIN
5   
6  */
7  
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 contract ERC20 is ERC20Basic {
16   function allowance(address owner, address spender) constant returns (uint256);
17   function transferFrom(address from, address to, uint256 value) returns (bool);
18   function approve(address spender, uint256 value) returns (bool);
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28  
29   function div(uint256 a, uint256 b) internal constant returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35  
36   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40  
41   function add(uint256 a, uint256 b) internal constant returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47  
48 contract BasicToken is ERC20Basic {
49   using SafeMath for uint256;
50   mapping(address => uint256) balances;
51  
52  function transfer(address _to, uint256 _value) returns (bool) {
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     Transfer(msg.sender, _to, _value);
56     return true;
57   }
58  
59   function balanceOf(address _owner) constant returns (uint256 balance) {
60     return balances[_owner];
61   }
62 }
63 
64 contract StandardToken is ERC20, BasicToken {
65   mapping (address => mapping (address => uint256)) allowed;
66   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
67     var _allowance = allowed[_from][msg.sender];
68     balances[_to] = balances[_to].add(_value);
69     balances[_from] = balances[_from].sub(_value);
70     allowed[_from][msg.sender] = _allowance.sub(_value);
71     Transfer(_from, _to, _value);
72     return true;
73   }
74  
75   function approve(address _spender, uint256 _value) returns (bool) {
76    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
77     allowed[msg.sender][_spender] = _value;
78     Approval(msg.sender, _spender, _value);
79     return true;
80   }
81  
82   /*
83   Function to check the amount of tokens that an owner allowed to a spender.
84   param _owner address The address which owns the funds.
85   param _spender address The address which will spend the funds.
86   return A uint256 specifing the amount of tokens still available for the spender.
87    */
88   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
89     return allowed[_owner][_spender];
90 }
91 }
92  
93 /*
94 The Ownable contract has an owner address, and provides basic authorization control
95  functions, this simplifies the implementation of "user permissions".
96  */
97 contract Ownable {
98     
99   address public owner;
100  // 0xa18602a78dE929b9e82aA24A5A216DE49e03447c
101  
102   function Ownable() {
103     owner = msg.sender;
104   }
105   /*
106   Throws if called by any account other than the owner.
107    */
108   modifier onlyOwner() {
109     require(msg.sender == owner);
110     _;
111   }
112  
113   /*
114   Allows the current owner to transfer control of the contract to a newOwner.
115   param newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address newOwner) onlyOwner {
118     require(newOwner != address(0));      
119     owner = newOwner;
120   }
121  
122 }
123  
124 contract TheLiquidToken is StandardToken, Ownable {
125     // mint can be finished and token become fixed for forever
126   event Mint(address indexed to, uint256 amount);
127   event MintFinished();
128   bool mintingFinished = false;
129   modifier canMint() {
130     require(!mintingFinished);
131     _;
132   }
133  
134  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
135     totalSupply = totalSupply.add(_amount);
136     balances[_to] = balances[_to].add(_amount);
137     Mint(_to, _amount);
138     return true;
139   }
140  
141   /*
142   Function to stop minting new tokens.
143   return True if the operation was successful.
144    */
145   function finishMinting() onlyOwner returns (bool) {}
146   
147   function burn(uint _value)
148         public
149     {
150         require(_value > 0);
151 
152         address burner = msg.sender;
153         balances[burner] = balances[burner].sub(_value);
154         totalSupply = totalSupply.sub(_value);
155         Burn(burner, _value);
156     }
157 
158     event Burn(address indexed burner, uint indexed value);
159   
160 }
161     
162 contract NJES is TheLiquidToken {
163   string public constant name = "NJES COIN";
164   string public constant symbol = "NJES";
165   uint public constant decimals = 3;
166   uint256 public initialSupply;
167     
168   function NJES () { 
169      totalSupply = 2000000 * 10 ** decimals;
170       balances[msg.sender] = totalSupply;
171       initialSupply = totalSupply; 
172         Transfer(0, this, totalSupply);
173         Transfer(this, msg.sender, totalSupply);
174   }
175 }