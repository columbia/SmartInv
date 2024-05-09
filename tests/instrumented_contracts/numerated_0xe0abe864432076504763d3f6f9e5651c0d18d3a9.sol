1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 contract ERC20Basic {
35   uint256 public totalSupply;
36   function balanceOf(address who) constant returns (uint256);
37   function transfer(address to, uint256 value) returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 
42 contract BasicToken is ERC20Basic {
43   using SafeMath for uint256;
44 
45   mapping(address => uint256) balances;
46 
47 
48   function transfer(address _to, uint256 _value) returns (bool) {
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55 
56   function balanceOf(address _owner) constant returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) constant returns (uint256);
65   function transferFrom(address from, address to, uint256 value) returns (bool);
66   function approve(address spender, uint256 value) returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74 
75 
76   
77   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
78     var _allowance = allowed[_from][msg.sender];
79     balances[_to] = balances[_to].add(_value);
80     balances[_from] = balances[_from].sub(_value);
81     allowed[_from][msg.sender] = _allowance.sub(_value);
82     Transfer(_from, _to, _value);
83     return true;
84   }
85 
86  
87   function approve(address _spender, uint256 _value) returns (bool) {
88 
89     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
90 
91     allowed[msg.sender][_spender] = _value;
92     Approval(msg.sender, _spender, _value);
93     return true;
94   }
95 
96   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
97     return allowed[_owner][_spender];
98   }
99 
100 }
101 
102 contract Ownable {
103   address public owner;
104   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105   /**
106    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
107    * account.
108    */
109    
110     
111   /**
112    * @dev Throws if called by any account other than the owner.
113    */
114   modifier onlyOwner() {
115     require(msg.sender == owner);
116     _;
117   }
118   /**
119    * @dev Allows the current owner to transfer control of the contract to a newOwner.
120    * @param newOwner The address to transfer ownership to.
121    */
122   function transferOwnership(address newOwner) public onlyOwner {
123     require(newOwner != address(0));
124     emit OwnershipTransferred(owner, newOwner);
125     owner = newOwner;
126   }
127 }
128 //////////////////////////////////
129 
130 
131 //////////////////////////////////
132 
133 
134 contract BTB is StandardToken ,Ownable {
135 
136   string public constant name = "Betrabit";
137   string public constant symbol = "BTB";
138   uint256 public constant decimals = 18;
139   
140   uint256 public constant INITIAL_SUPPLY = 100000000 * 10 ** uint256(decimals);
141 
142   
143   function BTB() {
144     totalSupply = INITIAL_SUPPLY;
145     balances[msg.sender] = INITIAL_SUPPLY;
146     owner=msg.sender;
147   }
148   
149 
150   function Airdrop(ERC20 token, address[] _addresses, uint256 amount) public {
151         for (uint256 i = 0; i < _addresses.length; i++) {
152             token.transfer(_addresses[i], amount);
153         }
154     }
155  
156 
157  
158 }