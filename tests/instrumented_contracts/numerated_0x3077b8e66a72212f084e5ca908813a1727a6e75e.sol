1 pragma solidity ^0.4.18;
2 
3 /*    Copyright © 2017  -  All Rights Reserved
4 
5      The Lending Exchanging
6 */
7 
8 contract ERC20White {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /*
15    ERC20 interface
16   see https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20 is ERC20White {
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
29   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a * b;
31     assert(a == 0 || c / a == b);
32     return c;
33   }
34   function div(uint256 a, uint256 b) internal constant returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44   function add(uint256 a, uint256 b) internal constant returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 contract SuperToken is ERC20White {
52     
53   using SafeMath for uint256;
54   mapping(address => uint256) balances;
55       modifier onlyPayloadSize(uint size) {
56      if(msg.data.length < size + 4) {
57        throw;
58      }
59      _;
60   }
61  
62  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68  
69   /*
70   Gets the balance of the specified address.
71    param _owner The address to query the the balance of. 
72    return An uint256 representing the amount owned by the passed address.
73   */
74   function balanceOf(address _owner) constant returns (uint256 balance) {
75     return balances[_owner];
76   }
77  
78 }
79  
80 /* Implementation of the basic standard token.
81   https://github.com/ethereum/EIPs/issues/20
82  */
83 contract StandardToken is ERC20, SuperToken {
84  
85   mapping (address => mapping (address => uint256)) allowed;
86  
87   /*
88     Transfer tokens from one address to another
89     param _from address The address which you want to send tokens from
90     param _to address The address which you want to transfer to
91     param _value uint256 the amout of tokens to be transfered
92    */
93   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
94     var _allowance = allowed[_from][msg.sender];
95  
96     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
97     // require (_value <= _allowance);
98  
99     balances[_to] = balances[_to].add(_value);
100     balances[_from] = balances[_from].sub(_value);
101     allowed[_from][msg.sender] = _allowance.sub(_value);
102     Transfer(_from, _to, _value);
103     return true;
104   }
105  
106   /*
107   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
108    param _spender The address which will spend the funds.
109    param _value The amount of Roman Lanskoj's tokens to be spent.
110    */
111   function approve(address _spender, uint256 _value) returns (bool) {
112  
113     // To change the approve amount you first have to reduce the addresses`
114     //  allowance to zero by calling `approve(_spender, 0)` if it is not
115     //  already 0 to mitigate the race condition described here:
116     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
118  
119     allowed[msg.sender][_spender] = _value;
120     Approval(msg.sender, _spender, _value);
121     return true;
122   }
123  
124   /*
125   Function to check the amount of tokens that an owner allowed to a spender.
126   param _owner address The address which owns the funds.
127   param _spender address The address which will spend the funds.
128   return A uint256 specifing the amount of tokens still available for the spender.
129    */
130   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
131     return allowed[_owner][_spender];
132 }
133 }
134  
135 /*
136 The Ownable contract has an owner address, and provides basic authorization control
137  functions, this simplifies the implementation of "user permissions".
138  */
139 contract Ownable {
140   address public owner;
141   function Ownable() {
142     owner = msg.sender;
143   }
144   /*
145   Throws if called by any account other than the owner.
146    */
147   modifier onlyOwner() {
148     require(msg.sender == owner);
149     _;
150   }
151  
152   /*
153   Allows the current owner to transfer control of the contract to a newOwner.
154   param newOwner The address to transfer ownership to.
155    */
156   function transferOwnership(address newOwner) onlyOwner {
157     require(newOwner != address(0));      
158     owner = newOwner;
159   }
160 }
161     
162 contract Chainconnect is StandardToken, Ownable {
163   string public constant name = "Chainconnect";
164   string public constant symbol = "CNN";
165   uint public constant decimals = 16;
166   uint256 public initialSupply;
167     
168   function Chainconnect () { 
169      totalSupply = 40000000 * 10 ** decimals;
170       balances[msg.sender] = totalSupply;
171       initialSupply = totalSupply; 
172         Transfer(0, this, totalSupply);
173         Transfer(this, msg.sender, totalSupply);
174   }
175 }