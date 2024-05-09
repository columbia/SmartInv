1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7   function Ownable() public {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function transferOwnership(address newOwner) public onlyOwner {
17     require(newOwner != address(0));
18     OwnershipTransferred(owner, newOwner);
19     owner = newOwner;
20   }
21 
22 }
23 
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     if (a == 0) {
27       return 0;
28     }
29     uint256 c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a / b;
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 contract ERC20Basic {
53   uint256 public totalSupply;
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67     require(_value <= balances[msg.sender]);
68 
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   function balanceOf(address _owner) public view returns (uint256 balance) {
76     return balances[_owner];
77   }
78 
79 }
80 
81 
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) public view returns (uint256);
84   function transferFrom(address from, address to, uint256 value) public returns (bool);
85   function approve(address spender, uint256 value) public returns (bool);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 contract StandardToken is ERC20, BasicToken {
91   event ChangeBalance (address from, uint256 fromBalance, address to, uint256 toBalance, uint256 seq);
92 
93   mapping (address => mapping (address => uint256)) internal allowed;
94 
95   uint256 internal seq = 0;
96 
97   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[_from]);
100     require(_value <= allowed[_from][msg.sender]);
101 
102     balances[_from] = balances[_from].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105     Transfer(_from, _to, _value);
106     ChangeBalance (_from, balances[_from], _to, balances[_to], ++seq);
107     return true;
108   }
109 
110   function approve(address _spender, uint256 _value) public returns (bool) {
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   function allowance(address _owner, address _spender) public view returns (uint256) {
117     return allowed[_owner][_spender];
118   }
119 
120   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
121     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
122     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
123     return true;
124   }
125 
126   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
127     uint oldValue = allowed[msg.sender][_spender];
128     if (_subtractedValue > oldValue) {
129       allowed[msg.sender][_spender] = 0;
130     } else {
131       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
132     }
133     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
134     return true;
135   }
136 
137 }
138 
139 
140 contract MintableToken is StandardToken, Ownable {
141   event Mint(address indexed to, uint256 amount);
142 
143   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
144     totalSupply = totalSupply.add(_amount);
145     balances[_to] = balances[_to].add(_amount);
146     Mint(_to, _amount);
147     Transfer(address(0), _to, _amount);
148     ChangeBalance (address(0), 0, _to, balances[_to], ++seq);
149     return true; 
150   }
151 }
152 
153 
154 contract OMXToken is MintableToken {
155     string public constant name = "OMEX";
156     string public constant symbol = "OMX";
157     uint8 public constant decimals = 18;
158 
159     function OMXToken () public MintableToken () {
160     }
161 
162 
163 }