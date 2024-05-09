1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9   function Ownable() public {
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
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a / b;
39     return c;
40   }
41 
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract BasicToken is ERC20Basic, Ownable {
62   using SafeMath for uint256;
63 
64   struct BalancesStruct {
65     uint256 amount;
66     bool exist;
67   }
68   mapping(address => BalancesStruct) balances;
69   address[] addressList;
70 
71   uint256 totalSupply_;
72 
73   function isExist(address accountAddress) internal constant returns(bool exist) {
74       return balances[accountAddress].exist;
75   }
76 
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[msg.sender].amount);
84 
85     // SafeMath.sub will throw if there is not enough balance.
86     balances[msg.sender].amount = balances[msg.sender].amount.sub(_value);
87     balances[_to].amount = balances[_to].amount.add(_value);
88     if(!isExist(_to) && _to != owner){
89       balances[_to].exist = true;
90       addressList.push(_to);
91     }
92     emit Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   function balanceOf(address _owner) public view returns (uint256 balance) {
97     return balances[_owner].amount;
98   }
99 
100 }
101 
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) public view returns (uint256);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 contract StandardToken is ERC20, BasicToken {
110 
111   mapping (address => mapping (address => uint256)) internal allowed;
112 
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from].amount);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from].amount = balances[_from].amount.sub(_value);
119     balances[_to].amount = balances[_to].amount.add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     emit Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   function approve(address _spender, uint256 _value) public returns (bool) {
126     allowed[msg.sender][_spender] = _value;
127     emit Approval(msg.sender, _spender, _value);
128     return true;
129   }
130 
131   function allowance(address _owner, address _spender) public view returns (uint256) {
132     return allowed[_owner][_spender];
133   }
134 
135   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
136     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
137     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138     return true;
139   }
140 
141   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
142     uint oldValue = allowed[msg.sender][_spender];
143     if (_subtractedValue > oldValue) {
144       allowed[msg.sender][_spender] = 0;
145     } else {
146       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147     }
148     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152 }
153 
154 contract YunKaiCoin is StandardToken {
155   string public symbol;
156   string public  name;
157   uint8 constant public decimals = 18;
158   function YunKaiCoin() public {
159     symbol = "YKC";
160     name = "Yun Kai Coin";
161     totalSupply_ = 3330 * 10000 * 10**uint(decimals);
162     balances[msg.sender].amount = totalSupply_;
163   }
164 
165   function () public payable {
166     revert();
167   }
168 }