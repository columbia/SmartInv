1 pragma solidity ^0.4.20;
2 
3 contract SafeMath {
4   function mul2(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6        return 0;
7      }
8      uint256 c = a * b;
9      assert(c / a == b);
10      return c;
11    }
12 
13   function div2(uint256 a, uint256 b) internal pure returns (uint256) {
14      uint256 c = a / b;
15      return c;
16   }
17 
18   function sub2(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20      return a - b;
21    }
22 
23   function add2(uint256 a, uint256 b) internal pure returns (uint256) {
24      uint256 c = a + b;
25     assert(c >= a);
26      return c;
27    }
28 }
29 
30 contract ERC20 {
31    uint256 public totalSupply;
32    function balanceOf(address who) public view returns (uint256);
33    function transfer(address to, uint256 value) public returns (bool);
34    event Transfer(address indexed from, address indexed to, uint256 value);
35    function allowance(address owner, address spender) public view returns (uint256);
36    function transferFrom(address from, address to, uint256 value) public returns (bool);
37    function approve(address spender, uint256 value) public returns (bool);
38    event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract ERC223 {
42     function transfer(address to, uint value, bytes data) public;
43     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
44 }
45 
46 contract ERC223ReceivingContract { 
47     function tokenFallback(address _from, uint _value, bytes _data) public;
48 }
49 
50 contract StandardToken is ERC20, ERC223, SafeMath {
51 
52    mapping(address => uint256) balances;
53    mapping (address => mapping (address => uint256)) internal allowed;
54 
55    function transfer(address _to, uint256 _value) public returns (bool) {
56      require(_to != address(0));
57      require(_value <= balances[msg.sender]);
58      balances[msg.sender] = sub2(balances[msg.sender], _value);
59      balances[_to] = add2(balances[_to], _value);
60      Transfer(msg.sender, _to, _value);
61      return true;
62    }
63 
64   function balanceOf(address _owner) public view returns (uint256 balance) {
65     return balances[_owner];
66    }
67 
68   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70      require(_value <= balances[_from]);
71      require(_value <= allowed[_from][msg.sender]);
72 
73     balances[_from] = sub2(balances[_from], _value);
74      balances[_to] = add2(balances[_to], _value);
75      allowed[_from][msg.sender] = sub2(allowed[_from][msg.sender], _value);
76     Transfer(_from, _to, _value);
77      return true;
78    }
79 
80    function approve(address _spender, uint256 _value) public returns (bool) {
81      allowed[msg.sender][_spender] = _value;
82      Approval(msg.sender, _spender, _value);
83      return true;
84    }
85 
86   function allowance(address _owner, address _spender) public view returns (uint256) {
87      return allowed[_owner][_spender];
88    }
89 
90    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
91      allowed[msg.sender][_spender] = add2(allowed[msg.sender][_spender], _addedValue);
92      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
93      return true;
94    }
95 
96   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
97      uint oldValue = allowed[msg.sender][_spender];
98      if (_subtractedValue > oldValue) {
99        allowed[msg.sender][_spender] = 0;
100      } else {
101        allowed[msg.sender][_spender] = sub2(oldValue, _subtractedValue);
102     }
103      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104      return true;
105    }
106    
107     function transfer(address _to, uint _value, bytes _data) public {
108         require(_value > 0 );
109         if(isContract(_to)) {
110             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
111             receiver.tokenFallback(msg.sender, _value, _data);
112         }
113         balances[msg.sender] = sub2(balances[msg.sender], _value);
114         balances[_to] = add2(balances[_to], _value);
115         Transfer(msg.sender, _to, _value, _data);
116     }
117 
118     function isContract(address _addr) private view returns (bool is_contract) {
119       uint length;
120       assembly {
121             //retrieve the size of the code on target address, this needs assembly
122             length := extcodesize(_addr)
123       }
124       return (length>0);
125     }
126     
127 }
128 
129 contract CmoudCoin is StandardToken {
130    string public name = 'CmoudCoin';
131    string public symbol = 'CMD';
132    uint public decimals = 0;
133    uint public INITIAL_SUPPLY = 1000000000000;
134 
135    function CmoudCoin() public {
136      totalSupply = INITIAL_SUPPLY;
137      balances[msg.sender] = INITIAL_SUPPLY;
138    }
139 }