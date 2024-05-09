1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6           return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         assert(b <= a);
14         return a - b;
15     }
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         assert(c >= a);
19         return c;
20     }
21 }
22 contract ERC20Basic {
23   function totalSupply() public view returns (uint256);
24   function balanceOf(address who) public view returns (uint256);
25   function transfer(address to, uint256 value) public returns (bool);
26   event Transfer(address indexed from, address indexed to, uint256 value);
27 }
28 contract BasicToken is ERC20Basic {
29   using SafeMath for uint256;
30   mapping(address => uint256) balances;
31   uint256 totalSupply_;
32   function totalSupply() public view returns (uint256) {
33     return totalSupply_;
34   }
35   function transfer(address _to, uint256 _value) public returns (bool) {
36     require(_to != address(0));
37     require(_value <= balances[msg.sender]);
38     balances[msg.sender] = balances[msg.sender].sub(_value);
39     balances[_to] = balances[_to].add(_value);
40     Transfer(msg.sender, _to, _value);
41     return true;
42   }
43   function balanceOf(address _owner) public view returns (uint256 balance) {
44     return balances[_owner];
45   }
46 }
47 contract ERC20 is ERC20Basic {
48   function allowance(address owner, address spender) public view returns (uint256);
49   function transferFrom(address from, address to, uint256 value) public returns (bool);
50   function approve(address spender, uint256 value) public returns (bool);
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 contract StandardToken is ERC20, BasicToken {
54   mapping (address => mapping (address => uint256)) internal allowed;
55   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
56     require(_to != address(0));
57     require(_value <= balances[_from]);
58     require(_value <= allowed[_from][msg.sender]);
59     balances[_from] = balances[_from].sub(_value);
60     balances[_to] = balances[_to].add(_value);
61     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
62     Transfer(_from, _to, _value);
63     return true;
64   }
65   function approve(address _spender, uint256 _value) public returns (bool) {
66     allowed[msg.sender][_spender] = _value;
67     Approval(msg.sender, _spender, _value);
68     return true;
69   }
70   function allowance(address _owner, address _spender) public view returns (uint256) {
71     return allowed[_owner][_spender];
72   }
73   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
74     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
75     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
76     return true;
77   }
78   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
79     uint oldValue = allowed[msg.sender][_spender];
80     if (_subtractedValue > oldValue) {
81       allowed[msg.sender][_spender] = 0;
82     } else {
83       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
84     }
85     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
86     return true;
87   }
88 }
89 contract CheckCarToken is StandardToken{
90   string public constant token_description = "This is a first decentralized blockchain platform for the market of diagnostics and selection of cars around the world! More info in http://check-car.io";
91   string public constant name = "Check Car Token Private";
92   string public constant symbol = "CCR-P";
93   uint8 public constant decimals = 18;
94 
95   function CheckCarToken () public {
96       totalSupply_ = 50000000000000000000000000;
97       balances[msg.sender] = 50000000000000000000000000;
98   }
99 }