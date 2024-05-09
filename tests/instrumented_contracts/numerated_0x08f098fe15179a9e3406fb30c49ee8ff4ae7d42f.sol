1 pragma solidity ^0.4.13;
2 
3 
4 // Questionnaire Connect
5 // questionnaireconnect.com
6 // By Michael Arbach 
7 
8 
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 contract ERC20Basic {
36   uint256 public totalSupply;
37   function balanceOf(address who) constant returns (uint256);
38   function transfer(address to, uint256 value) returns (bool);
39   
40   // KYBER-NOTE! code changed to comply with ERC20 standard
41   event Transfer(address indexed _from, address indexed _to, uint _value);
42   //event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) onlyOwner {
72     if (newOwner != address(0)) {
73       owner = newOwner;
74     }
75   }
76 
77 }
78 
79 contract ERC20 is ERC20Basic {
80   function allowance(address owner, address spender) constant returns (uint256);
81   function transferFrom(address from, address to, uint256 value) returns (bool);
82   function approve(address spender, uint256 value) returns (bool);
83   
84   // KYBER-NOTE! code changed to comply with ERC20 standard
85   event Approval(address indexed _owner, address indexed _spender, uint _value);
86   //event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) returns (bool) {
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of. 
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) constant returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 contract StandardToken is ERC20, BasicToken {
118 
119   mapping (address => mapping (address => uint256)) allowed;
120 
121 
122   /**
123    * @dev Transfer tokens from one address to another
124    * @param _from address The address which you want to send tokens from
125    * @param _to address The address which you want to transfer to
126    * @param _value uint256 the amout of tokens to be transfered
127    */
128   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
129     var _allowance = allowed[_from][msg.sender];
130 
131     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
132     // require (_value <= _allowance);
133 
134     // KYBER-NOTE! code changed to comply with ERC20 standard
135     balances[_from] = balances[_from].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     //balances[_from] = balances[_from].sub(_value); // this was removed
138     allowed[_from][msg.sender] = _allowance.sub(_value);
139     Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) returns (bool) {
149 
150     // To change the approve amount you first have to reduce the addresses`
151     //  allowance to zero by calling `approve(_spender, 0)` if it is not
152     //  already 0 to mitigate the race condition described here:
153     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
155 
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param _owner address The address which owns the funds.
164    * @param _spender address The address which will spend the funds.
165    * @return A uint256 specifing the amount of tokens still avaible for the spender.
166    */
167   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
168     return allowed[_owner][_spender];
169   }
170 
171 }
172 
173 contract QuestionnaireConnect is StandardToken, Ownable {
174 
175     string  public  constant name = "Questionnaire Connect";
176     string  public  constant symbol = "QC";
177     uint    public  constant decimals = 18;
178 
179     function QuestionnaireConnect( uint tokenTotalAmount){
180 
181         balances[msg.sender] = tokenTotalAmount;
182         totalSupply = tokenTotalAmount;
183         Transfer(address(0x0), msg.sender, tokenTotalAmount);
184     }
185 
186     function transfer(address _to, uint _value)
187         returns (bool) {
188         return super.transfer(_to, _value);
189     }
190 
191     function transferFrom(address _from, address _to, uint _value)
192         returns (bool) {
193         return super.transferFrom(_from, _to, _value);
194     }
195 
196     event Burn(address indexed _burner, uint _value);
197 
198     function burn(uint _value) 
199         returns (bool){
200         balances[msg.sender] = balances[msg.sender].sub(_value);
201         totalSupply = totalSupply.sub(_value);
202         Burn(msg.sender, _value);
203         Transfer(msg.sender, address(0x0), _value);
204         return true;
205     }
206 
207     function burnFrom(address _from, uint256 _value) 
208         returns (bool) {
209         assert( transferFrom( _from, msg.sender, _value ) );
210         return burn(_value);
211     }
212 }