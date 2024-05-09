1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function sub(uint a, uint b) internal returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function add(uint a, uint b) internal returns (uint) {
16     uint c = a + b;
17     assert(c >= a);
18     return c;
19   }
20 
21   function assert(bool assertion) internal {
22     if (!assertion) {
23       throw;
24     }
25   }
26 }
27 
28 contract ShitToken {
29   using SafeMath for uint256;
30 
31   string public constant name = "Shit";
32   string public constant symbol = "SHT";
33   uint8 public constant decimals = 18;
34   uint256 public totalSupply;
35   mapping (address => uint) balances;
36   mapping (address => mapping (address => uint)) allowed;
37   address crowdsaleWallet;
38   address owner;
39 
40   // Christmas!
41   uint256 saleEndDate = 1498348800;
42 
43   // Hopefully this is enough, we might run a second and third sale if not!
44   uint256 public beerAndHookersCap = 500000 ether;
45   uint256 public shitRate = 419;
46   uint256 public totalEtherReceived;
47   
48   event Transfer(address indexed from, address indexed to, uint value);
49   event Approval(address indexed owner, address indexed spender, uint value);
50   event Created(address indexed donor, uint256 amount, uint256 tokens);
51 
52   function () payable {
53     require(now < saleEndDate);
54     require(msg.value > 0);
55     require(totalEtherReceived.add(msg.value) <= beerAndHookersCap);
56     uint256 tokens = msg.value.mul(shitRate);
57     balances[msg.sender] = balances[msg.sender].add(tokens);
58     totalEtherReceived = totalEtherReceived.add(msg.value);
59     totalSupply = totalSupply.add(tokens);
60     Created(msg.sender, msg.value, tokens);
61     crowdsaleWallet.transfer(msg.value);
62   }
63 
64   function ShitToken(address _crowdsaleWallet) {
65     require(_crowdsaleWallet != 0x0);
66     owner = msg.sender;
67     crowdsaleWallet = _crowdsaleWallet;
68   }
69 
70   function transfer(address _to, uint _value) returns (bool success) {
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
78     var _allowance = allowed[_from][msg.sender];
79 
80     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
81     // if (_value > _allowance) throw;
82 
83     balances[_to] = balances[_to].add(_value);
84     balances[_from] = balances[_from].sub(_value);
85     allowed[_from][msg.sender] = _allowance.sub(_value);
86     Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   function balanceOf(address _owner) constant returns (uint balance) {
91     return balances[_owner];
92   }
93 
94   function approve(address _spender, uint _value) returns (bool success) {
95     allowed[msg.sender][_spender] = _value;
96     Approval(msg.sender, _spender, _value);
97     return true;
98   }
99 
100   function allowance(address _owner, address _spender) constant returns (uint remaining) {
101     return allowed[_owner][_spender];
102   }
103 
104   function suicide() {
105     require(msg.sender == owner);
106     selfdestruct(owner);
107   }
108 }