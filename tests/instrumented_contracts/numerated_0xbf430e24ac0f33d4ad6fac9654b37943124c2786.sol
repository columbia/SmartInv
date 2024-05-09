1 pragma solidity ^0.4.18;
2  
3 /* 
4 
5     eBTG is a tokenized version of Bitcoin Gold on the Ethereum blockchain.
6      ebgold.io 
7      
8  */
9  
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) constant returns (uint256);
13   function transfer(address to, uint256 value) returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) constant returns (uint256);
19   function transferFrom(address from, address to, uint256 value) returns (bool);
20   function approve(address spender, uint256 value) returns (bool);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30  
31   function div(uint256 a, uint256 b) internal constant returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37  
38   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42  
43   function add(uint256 a, uint256 b) internal constant returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49  
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52   mapping(address => uint256) balances;
53  
54  function transfer(address _to, uint256 _value) returns (bool) {
55     balances[msg.sender] = balances[msg.sender].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     Transfer(msg.sender, _to, _value);
58     return true;
59   }
60  
61   function balanceOf(address _owner) constant returns (uint256 balance) {
62     return balances[_owner];
63   }
64 }
65 
66 contract StandardToken is ERC20, BasicToken {
67   mapping (address => mapping (address => uint256)) allowed;
68   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
69     var _allowance = allowed[_from][msg.sender];
70     balances[_to] = balances[_to].add(_value);
71     balances[_from] = balances[_from].sub(_value);
72     allowed[_from][msg.sender] = _allowance.sub(_value);
73     Transfer(_from, _to, _value);
74     return true;
75   }
76  
77   function approve(address _spender, uint256 _value) returns (bool) {
78    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
79     allowed[msg.sender][_spender] = _value;
80     Approval(msg.sender, _spender, _value);
81     return true;
82   }
83  
84   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
85     return allowed[_owner][_spender];
86 }
87 }
88 
89 contract eBitcoinGold is  StandardToken {
90   string public constant name = "eBitcoin Gold";
91   string public constant symbol = "eBTG";
92   uint public constant decimals = 8;
93   uint256 public initialSupply;
94     
95   function eBitcoinGold () { 
96      totalSupply = 21000000 * 10 ** decimals;
97       balances[0x2Df16C35A052c369601307ab26C7E6795B5A9095] = totalSupply;
98       // ebgold.io Ethereum wallet
99       initialSupply = totalSupply; 
100         Transfer(0, this, totalSupply);
101         Transfer(this, msg.sender, totalSupply);
102   }
103 }