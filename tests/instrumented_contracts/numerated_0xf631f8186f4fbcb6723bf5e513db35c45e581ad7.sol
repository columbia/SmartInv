1 pragma solidity ^0.4.25;
2 
3 contract ERC20Interface {
4 
5     string public constant name = "CWC-ER";
6     string public constant symbol = "CWC-ER";
7     uint8 public constant decimals = 18;
8 
9     function totalSupply() public constant returns (uint);
10     function balanceOf(address tokenOwner) public constant returns (uint balance);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
15 
16     event Transfer(address indexed from, address indexed to, uint tokens);
17     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
18 }
19 
20 contract SafeMath {
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         if (a == 0) {
24             return 0;
25         }
26         c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30 
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         return a / b;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41         c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 
48 contract CWCToken is ERC20Interface, SafeMath {
49 
50   string public name;
51   string public symbol;
52   uint8 public decimals;
53   uint256 public totalSupply;
54 
55 
56   mapping (address => uint256) public balanceOf;
57 
58   mapping (address => mapping (address => uint256)) public allowanceOf;
59 
60    constructor() public {
61       name = "CWC-ER";
62       symbol = "CWC-ER";
63       decimals = 18;
64       totalSupply = 100000000 * 10 ** uint256(decimals);
65       balanceOf[msg.sender] = totalSupply;
66    }
67 
68     function _transfer(address _from, address _to, uint _value) internal {
69        require(_to != 0x0);
70        require(balanceOf[_from] >= _value);
71        require(balanceOf[_to] + _value > balanceOf[_to]);
72        uint previousBalances = balanceOf[_from] + balanceOf[_to];
73        balanceOf[_from] -= _value;
74        balanceOf[_to] += _value;
75       emit Transfer(_from, _to, _value);
76        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
77     }
78 
79     function transfer(address _to, uint256 _value) public returns (bool success) {
80        _transfer(msg.sender, _to, _value);
81        return true;
82    }
83 
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85        require(allowanceOf[_from][msg.sender] >= _value);
86        allowanceOf[_from][msg.sender] -= _value;
87        _transfer(_from, _to, _value);
88        return true;
89    }
90 
91     function approve(address _spender, uint256 _value) public returns (bool success) {
92        allowanceOf[msg.sender][_spender] = _value;
93       emit Approval(msg.sender, _spender, _value);
94        return true;
95    }
96 
97    function allowance(address _owner, address _spender) view public returns (uint remaining){
98      return allowanceOf[_owner][_spender];
99    }
100 
101   function totalSupply() public constant returns (uint totalsupply){
102       return totalSupply;
103   }
104 
105   function balanceOf(address tokenOwner) public constant returns(uint balance){
106       return balanceOf[tokenOwner];
107   }
108 
109 }