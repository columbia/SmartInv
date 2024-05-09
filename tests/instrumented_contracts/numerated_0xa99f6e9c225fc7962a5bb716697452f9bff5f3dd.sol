1 pragma solidity ^0.4.18;
2 
3 /**
4  *  SafeMath  library
5  */
6 library SafeMath {
7     
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b > 0);
16     uint256 c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20   
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25   
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * erc20 token methods
35  */
36 contract Token {
37 
38     function balanceOf(address _owner) public constant returns (uint256 balance);
39 
40     function transfer(address _to, uint256 _value) public returns (bool success);
41 
42     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
43 
44     function approve(address _spender, uint256 _value) public returns (bool success);
45 
46     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49 
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 
54 /* ALLYToken   */
55 contract ALLYToken is Token {
56 
57     /* total tokens */
58     string  public name = "ALLY";
59     string  public symbol = "ALLY";
60     uint8   public decimals = 18;
61     uint256 public totalSupply = 990000000 * 10 ** uint256(decimals);
62     address public owner;
63 
64     /*  balance collections  */
65     mapping (address => uint256)  balances;
66     
67     mapping (address => mapping (address => uint256))  public allowance;
68 
69     function ALLYToken() public {
70         owner = msg.sender;
71         balances[msg.sender] = totalSupply;
72     }
73 
74 
75     /* transfer token to  _to */
76     function transfer(address _to, uint256 _value) public returns (bool) {
77       _transfer(msg.sender, _to, _value);
78       Transfer(msg.sender, _to, _value);
79       return true;
80 
81     }
82 
83     /* transfer token from _from to  _to */
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85         require(allowance[_from][msg.sender] >= _value);
86         _transfer(_from, _to, _value);
87         allowance[_from][msg.sender] -= _value;
88         Transfer(_from, _to, _value);
89         return true;
90     }
91 
92     /**
93      * transfer value token to "_to"
94      */
95     function _transfer(address _from, address _to, uint256 _value) internal {
96        require(_value > 0x0);
97        require(balances[_from] >= _value);
98        require(balances[_to] + _value > balances[_to]);
99        uint previousBalances = SafeMath.add(balances[_from], balances[_to]);
100        balances[_from] = SafeMath.sub(balances[_from], _value);                   
101        balances[_to] = SafeMath.add(balances[_to], _value); 
102        assert(SafeMath.add(balances[_from], balances[_to]) == previousBalances);
103     }
104 
105     /* get balance */
106     function balanceOf(address _owner)  public constant returns (uint256) {
107         return balances[_owner];
108     }
109 
110     /* approve send token */
111     function approve(address _spender, uint256 _value) public returns (bool) {
112         allowance[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     /* approve _spender send token */
118     function allowance(address _owner, address _spender) public constant returns (uint256) {
119         return allowance[_owner][_spender];
120     }
121 }