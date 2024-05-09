1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   function Ownable() {
14     owner = msg.sender;
15   }
16 
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 
22   function transferOwnership(address newOwner) onlyOwner public {
23     require(newOwner != address(0));
24     OwnershipTransferred(owner, newOwner);
25     owner = newOwner;
26   }
27 
28 }
29 
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal constant returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal constant returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 contract ERC20Basic {
57   uint256 public totalSupply;
58   function balanceOf(address who) constant returns (uint256);
59   function transfer(address to, uint256 value) returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   function transfer(address _to, uint256 _value) returns (bool) {
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   function balanceOf(address _owner) constant returns (uint256 balance) {
76     return balances[_owner];
77   }
78 }
79 
80 contract ERC20 is ERC20Basic {
81   function allowance(address owner, address spender) constant returns (uint256);
82   function transferFrom(address from, address to, uint256 value) returns (bool);
83   function approve(address spender, uint256 value) returns (bool);
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 contract StandardToken is ERC20, BasicToken {
88 
89   mapping (address => mapping (address => uint256)) allowed;
90 
91   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
92 
93     var _allowance = allowed[_from][msg.sender];
94 
95     balances[_from] = balances[_from].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     allowed[_from][msg.sender] = _allowance.sub(_value);
98     Transfer(_from, _to, _value);
99     return true;
100   }
101 
102   function approve(address _spender, uint256 _value) returns (bool) {
103     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
104 
105     allowed[msg.sender][_spender] = _value;
106     Approval(msg.sender, _spender, _value);
107     return true;
108   }
109 
110   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
111     return allowed[_owner][_spender];
112   }
113 
114   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
115     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
116     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
117     return true;
118   }
119 
120   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
121     uint oldValue = allowed[msg.sender][_spender];
122     if (_subtractedValue > oldValue) {
123       allowed[msg.sender][_spender] = 0;
124     } else {
125       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
126     }
127     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131 }
132 
133 contract EtherArk is StandardToken, Ownable {
134 
135   string public constant name = "eARK";
136   string public constant symbol = "EARK";
137   uint8 public constant decimals = 8;
138 
139   uint256 public constant INITIAL_SUPPLY = 125 * 10**6 * 10**8;
140 
141   function EtherArk() {
142     totalSupply = INITIAL_SUPPLY;
143     balances[msg.sender] = INITIAL_SUPPLY;
144   }
145 
146   function airdrop(uint256 amount, address[] addresses) onlyOwner {
147     for (uint i = 0; i < addresses.length; i++) {
148       balances[owner].sub(amount);
149       balances[addresses[i]].add(amount);
150       Transfer(owner, addresses[i], amount);
151     }
152   }
153 }