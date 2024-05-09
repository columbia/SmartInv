1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9   constructor() public {
10     owner = msg.sender;
11   }
12 
13   modifier onlyOwner() {
14     require(msg.sender == owner);
15     _;
16   }
17 
18   function transferOwnership(address newOwner) public onlyOwner {
19     require(newOwner != address(0));
20     emit OwnershipTransferred(owner, newOwner);
21     owner = newOwner;
22   }
23 
24 }
25 
26 library SafeMath {
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34     c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 contract ERC20Basic {
41   function totalSupply() public view returns (uint256);
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   uint256 totalSupply_;
53 
54   function totalSupply() public view returns (uint256) {
55     return totalSupply_;
56   }
57 
58   function transfer(address _to, uint256 _value) public returns (bool) {
59     require(_to != address(0));
60     require(_to != address(this));
61     require(_value <= balances[msg.sender]);
62     
63 
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     emit Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   function balanceOf(address _owner) public view returns (uint256) {
71     return balances[_owner];
72   }
73 }
74 
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender) public view returns (uint256);
77   function transferFrom(address from, address to, uint256 value) public returns (bool);
78   function approve(address spender, uint256 value) public returns (bool);
79   event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 contract StandardToken is ERC20, BasicToken {
83 
84   mapping (address => mapping (address => uint256)) internal allowed;
85 
86   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_to != address(this));
89     require(_value <= balances[_from]);
90     require(_value <= allowed[_from][msg.sender]);
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
95     emit Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   function approve(address _spender, uint256 _value) public returns (bool) {
100     allowed[msg.sender][_spender] = _value;
101     emit Approval(msg.sender, _spender, _value);
102     return true;
103   }
104 
105   function allowance(address _owner, address _spender) public view returns (uint256) {
106     return allowed[_owner][_spender];
107   }
108 }
109 
110 contract MachiXToken is StandardToken, Ownable {
111     string public constant name = "FuckX Token";
112     string public constant symbol = "FCXT";
113     uint8 public constant decimals = 18;
114     uint256 public totalSupply = 1000000000 ether;
115 
116     constructor() public {
117         balances[msg.sender] = totalSupply;
118     }
119     
120     function () payable public {
121         owner.transfer(msg.value);
122     }
123 }