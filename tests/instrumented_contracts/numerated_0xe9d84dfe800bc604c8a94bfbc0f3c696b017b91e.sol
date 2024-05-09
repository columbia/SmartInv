1 pragma solidity ^0.4.0;
2 library SafeMath {
3 
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8     if (a == 0) {
9       return 0;
10     }
11     c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   /**
17   * @dev Integer division of two numbers, truncating the quotient.
18   */ 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     // uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return a / b;
24   }
25 
26   /**
27   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28   */
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   /**
35   * @dev Adds two numbers, throws on overflow.
36   */
37   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
38     c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 contract Ownable {
44   address public owner;
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48   constructor() public {
49     owner = msg.sender;
50   }
51   
52     modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56   
57     function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     emit OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 
63 }
64 
65 contract ERC20Basic {
66   function totalSupply() public view returns (uint256);
67   function balanceOf(address who) public view returns (uint256);
68   function transfer(address to, uint256 value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   uint256 totalSupply_;
78 
79   /**
80   * @dev total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 contract MintableToken is BasicToken, Ownable {
113   event Mint(address indexed to, uint256 amount);
114   event MintFinished();
115 
116   bool public mintingFinished = false;
117 
118 
119   modifier canMint() {
120     require(!mintingFinished);
121     _;
122   }
123   
124   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
125     totalSupply_ = totalSupply_.add(_amount);
126     balances[_to] = balances[_to].add(_amount);
127     emit Mint(_to, _amount);
128     emit Transfer(address(0), _to, _amount);
129     return true;
130   }
131   
132   function finishMinting() onlyOwner canMint public returns (bool) {
133     mintingFinished = true;
134     emit MintFinished();
135     return true;
136   }
137 }  
138 
139 
140 contract VoidToken is Ownable, MintableToken {
141   string public constant name = "VOID TOKEN";
142   string public constant symbol = "VOID";
143   uint256 public constant decimals = 8;
144   uint256 public constant fixed_value = 100 * (10 ** uint256(decimals));
145   uint256 public totalAirDropped = 0;
146   address owner_address;
147   mapping (address => bool) air_dropped;
148 
149   uint256 public INITIAL_TOTAL_SUPPLY = 10 ** 8 * (10 ** uint256(decimals));
150 
151   constructor() public {
152     totalSupply_ = INITIAL_TOTAL_SUPPLY;
153     owner_address = msg.sender;
154     balances[owner_address] = totalSupply_;
155     emit Transfer(address(0), owner_address, totalSupply_);
156   }
157 
158   function batch_send(address[] addresses, uint256 value) onlyOwner public{
159     require(addresses.length < 255);
160     for(uint i = 0; i < addresses.length; i++)
161     {
162       require(value <= totalSupply_);
163       transfer(addresses[i], value);
164     }
165   }
166 
167   function airdrop(address[] addresses, uint256 value) onlyOwner public{
168     require(addresses.length < 255);
169     for(uint i = 0; i < addresses.length; i++)
170     {
171       require(value <= totalSupply_);
172       require(air_dropped[addresses[i]] == false);
173       air_dropped[addresses[i]] = true;
174       transfer(addresses[i], value);
175       totalAirDropped = totalAirDropped.add(value);
176     }
177   }
178 
179   function () external payable{
180       airdrop_auto(msg.sender);
181   }
182 
183   function airdrop_auto(address investor_address) public payable returns (bool success){
184     require(investor_address != address(0));
185     require(air_dropped[investor_address] == false);
186     require(fixed_value <= totalSupply_);
187     totalAirDropped = totalAirDropped.add(fixed_value);
188     balances[owner_address] = balances[owner_address].sub(fixed_value);
189     balances[investor_address] = balances[investor_address].add(fixed_value);
190     emit Transfer(owner_address, investor_address, fixed_value);
191     forward_funds(msg.value);
192     return true;
193   }
194  
195   function forward_funds(uint256 funds) internal {
196     if(funds > 0){
197       owner_address.transfer(funds);
198     }
199   }
200 }