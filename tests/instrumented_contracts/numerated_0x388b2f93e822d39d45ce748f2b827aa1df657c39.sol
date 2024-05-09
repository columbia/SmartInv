1 pragma solidity ^0.4.6;
2 
3 
4 library SafeMathLib {
5   function times(uint a, uint b) returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function minus(uint a, uint b) returns (uint) {
12     assert(b <= a);
13     return a - b;
14   }
15 
16   function plus(uint a, uint b) returns (uint) {
17     uint c = a + b;
18     assert(c>=a && c>=b);
19     return c;
20   }
21 
22   function assert(bool assertion) private {
23     if (!assertion) throw;
24   }
25 }
26 
27 
28 library ERC20Lib {
29   using SafeMathLib for uint;
30 
31   struct TokenStorage {
32     mapping (address => uint) balances;
33     mapping (address => mapping (address => uint)) allowed;
34     uint totalSupply;
35   }
36 
37   event Transfer(address indexed from, address indexed to, uint value);
38   event Approval(address indexed owner, address indexed spender, uint value);
39 
40   function init(TokenStorage storage self, uint _initial_supply) {
41     self.totalSupply = _initial_supply;
42     self.balances[msg.sender] = _initial_supply;
43   }
44 
45   function transfer(TokenStorage storage self, address _to, uint _value) returns (bool success) {
46     self.balances[msg.sender] = self.balances[msg.sender].minus(_value);
47     self.balances[_to] = self.balances[_to].plus(_value);
48     Transfer(msg.sender, _to, _value);
49     return true;
50   }
51 
52   function transferFrom(TokenStorage storage self, address _from, address _to, uint _value) returns (bool success) {
53     var _allowance = self.allowed[_from][msg.sender];
54 
55     self.balances[_to] = self.balances[_to].plus(_value);
56     self.balances[_from] = self.balances[_from].minus(_value);
57     self.allowed[_from][msg.sender] = _allowance.minus(_value);
58     Transfer(_from, _to, _value);
59     return true;
60   }
61 
62   function balanceOf(TokenStorage storage self, address _owner) constant returns (uint balance) {
63     return self.balances[_owner];
64   }
65 
66   function approve(TokenStorage storage self, address _spender, uint _value) returns (bool success) {
67     self.allowed[msg.sender][_spender] = _value;
68     Approval(msg.sender, _spender, _value);
69     return true;
70   }
71 
72   function allowance(TokenStorage storage self, address _owner, address _spender) constant returns (uint remaining) {
73     return self.allowed[_owner][_spender];
74   }
75 }
76 
77 /**
78  * Standard ERC20 token
79  *
80  * https://github.com/ethereum/EIPs/issues/20
81  * Based on code by FirstBlood:
82  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
83  */
84 
85  contract FQCoin {
86    using ERC20Lib for ERC20Lib.TokenStorage;
87 
88    ERC20Lib.TokenStorage token;
89 
90    string public name = "JOJOCoin";
91    string public symbol = "JJC";
92    uint public decimals = 18;
93    uint public INITIAL_SUPPLY = 10000000000;
94    uint256 public totalSupply;
95 
96    function FQCoin() {
97       totalSupply = INITIAL_SUPPLY * 10 ** uint256(decimals);
98      token.init(totalSupply);
99    }
100 
101    function totalSupply() constant returns (uint) {
102      return token.totalSupply;
103    }
104 
105    function balanceOf(address who) constant returns (uint) {
106      return token.balanceOf(who);
107    }
108 
109    function allowance(address owner, address spender) constant returns (uint) {
110      return token.allowance(owner, spender);
111    }
112 
113    function transfer(address to, uint value) returns (bool ok) {
114      return token.transfer(to, value);
115    }
116 
117    function transferFrom(address from, address to, uint value) returns (bool ok) {
118      return token.transferFrom(from, to, value);
119    }
120 
121    function approve(address spender, uint value) returns (bool ok) {
122      return token.approve(spender, value);
123    }
124 
125    event Transfer(address indexed from, address indexed to, uint value);
126    event Approval(address indexed owner, address indexed spender, uint value);
127  }