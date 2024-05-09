1 pragma solidity ^0.4.24;
2 
3 contract Gnome {
4 
5     using SafeMath for uint256;
6     
7     uint public constant _totalSupply = 200000000000;
8     string public constant symbol = "LEN";
9     string public constant name = "Gnome";
10     uint8 public constant decimals = 2;
11     
12     mapping(address => uint256) balances;
13     mapping(address => mapping(address => uint256)) allowed;
14     
15     function Gnome() {
16         balances[msg.sender] = _totalSupply;
17     }
18     
19     function totalSupply() constant returns (uint256 totalSupply) {
20         return _totalSupply;
21     }
22     
23     function balanceOf(address _owner) constant returns (uint256 balance) {
24         return balances[_owner];
25     }
26     
27     function transfer(address _to, uint256 _value) returns (bool success) {
28         require(
29             balances[msg.sender] >= _value
30             && _value > 0
31             );
32             balances[msg.sender] -= _value;
33             balances[_to] += _value;
34             Transfer(msg.sender, _to, _value);
35             return true;
36     }
37     
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
39         require(
40             allowed[_from][msg.sender] >= _value
41             && balances[_from] >= _value 
42             && _value > 0
43             );
44             balances[_from] -= _value;
45             balances[_to] += _value;
46             allowed[_from][msg.sender] -= _value;
47             Transfer(_from, _to, _value);
48             return true;
49     }
50     
51     function approve(address _spender, uint256 _value) returns (bool success) {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56     
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
58         return allowed[_owner][_spender];
59     }
60 
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 }
64 
65 interface ERC20 {
66     function totalSupply() constant returns (uint256 totalSupply);
67     function balanceOf(address _owner) constant returns (uint256 balance);
68     function transfer(address _to, uint256 _value) returns (bool success);
69     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
70     function approve(address _spender, uint256 _value) returns (bool success);
71     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 }
75 
76 library SafeMath {
77 
78   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
79     if (a == 0) {
80       return 0;
81     }
82 
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     return a / b;
90   }
91 
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
98     c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }