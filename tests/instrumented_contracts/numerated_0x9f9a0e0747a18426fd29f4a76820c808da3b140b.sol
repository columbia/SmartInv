1 pragma solidity ^0.4.11;
2  /**
3 ***INFORMASI***
4 Editor : firstteacher
5 Website : https://Ethbold.com
6 */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 contract ERC20 is ERC20Basic {
15   function allowance(address owner, address spender) public constant returns (uint256);
16   function transferFrom(address from, address to, uint256 value) public returns (bool);
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52 
53   function transfer(address _to, uint256 _value) public returns (bool) {
54     require(_to != address(0));
55     require(_value <= balances[msg.sender]);
56 
57     // SafeMath.sub will throw if there is not enough balance.
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64   function balanceOf(address _owner) public constant returns (uint256 balance) {
65     return balances[_owner];
66   }
67 
68 }
69 
70 contract StandardToken is ERC20, BasicToken {
71 
72   mapping (address => mapping (address => uint256)) internal allowed;
73 
74   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76     require(_value <= balances[_from]);
77     require(_value <= allowed[_from][msg.sender]);
78 
79     balances[_from] = balances[_from].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82     Transfer(_from, _to, _value);
83     return true;
84   }
85 
86   function approve(address _spender, uint256 _value) public returns (bool) {
87     allowed[msg.sender][_spender] = _value;
88     Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
93     return allowed[_owner][_spender];
94   }
95  
96   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
97     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
98     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99     return true;
100   }
101 
102   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
103     uint oldValue = allowed[msg.sender][_spender];
104     if (_subtractedValue > oldValue) {
105       allowed[msg.sender][_spender] = 0;
106     } else {
107       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
108     }
109     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110     return true;
111   }
112 
113 }
114 
115 contract ETHBOLD is StandardToken
116 {
117     string public constant name = "ETHBOLD"; // nama token yang kalian ingin
118     string public constant symbol = "ETBOLD"; // simbol token
119     uint8 public constant decimals = 18; // desimal unit
120     
121     function ETHBOLD() public 
122     {
123         totalSupply = 90000000 * 10 ** uint256(decimals); // jumlah supply
124         balances[msg.sender] = totalSupply;
125         Transfer(0x0, msg.sender, totalSupply);
126     }
127 }