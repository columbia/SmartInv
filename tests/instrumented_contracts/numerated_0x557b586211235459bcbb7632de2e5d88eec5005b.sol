1 pragma solidity ^0.4.18;
2 
3 /*
4   Realty Coin
5   Worldwide real estate coin
6   2017
7 */
8 
9 library SafeMath {
10   function mul(uint a, uint b) internal returns (uint) {
11     uint c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15   function div(uint a, uint b) internal returns (uint) {
16     assert(b > 0);
17     uint c = a / b;
18     assert(a == b * c + a % b);
19     return c;
20   }
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
31     return a >= b ? a : b;
32   }
33   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a < b ? a : b;
35   }
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a < b ? a : b;
41   }
42   function assert(bool assertion) internal {
43     if (!assertion) {
44       throw;
45     }
46   }
47 }
48 
49 contract ERC20Basic {
50   uint public totalSupply;
51   function balanceOf(address who) constant returns (uint);
52   function transfer(address to, uint value);
53   event Transfer(address indexed from, address indexed to, uint value);
54 }
55 contract ERC20 is ERC20Basic {
56   function allowance(address owner, address spender) constant returns (uint);
57   function transferFrom(address from, address to, uint value);
58   function approve(address spender, uint value);
59   event Approval(address indexed owner, address indexed spender, uint value);
60 }
61 
62 contract newToken is ERC20Basic {
63   
64   using SafeMath for uint;
65   
66   mapping(address => uint) balances;
67   
68 
69   modifier onlyPayloadSize(uint size) {
70      if(msg.data.length < size + 4) {
71        throw;
72      }
73      _;
74   }
75   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79   }
80   function balanceOf(address _owner) constant returns (uint balance) {
81     return balances[_owner];
82   }
83 }
84 
85 contract RTC is newToken, ERC20 {
86   mapping (address => mapping (address => uint)) allowed;
87   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
88     var _allowance = allowed[_from][msg.sender];
89     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
90     // if (_value > _allowance) throw;
91     balances[_to] = balances[_to].add(_value);
92     balances[_from] = balances[_from].sub(_value);
93     allowed[_from][msg.sender] = _allowance.sub(_value);
94     Transfer(_from, _to, _value);
95   }
96   function approve(address _spender, uint _value) {
97     // To change the approve amount you first have to reduce the addresses`
98     //  allowance to zero by calling approve(_spender, 0) if it is not
99     //  already 0 to mitigate the race condition described here:
100     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
101     allowed[msg.sender][_spender] = _value;
102     Approval(msg.sender, _spender, _value);
103   }
104   function allowance(address _owner, address _spender) constant returns (uint remaining) {
105     return allowed[_owner][_spender];
106   }
107 }
108 
109 contract RealtyCoin is RTC {
110   string public constant name = "RealtyCoin";
111   string public constant symbol = "RTC";
112   uint public constant decimals = 4;
113   uint256 public initialSupply;
114     
115   function RealtyCoin () { 
116      totalSupply = 500000000 * 10 ** decimals;
117       balances[msg.sender] = totalSupply;
118       initialSupply = totalSupply; 
119         Transfer(0, this, totalSupply);
120         Transfer(this, msg.sender, totalSupply);
121   }
122 }