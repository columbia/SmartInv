1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {  return 0;}
6     uint256 c = a * b; assert(c / a == b); return c;
7   }
8   function div(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a / b;return c;
10   }
11   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12     assert(b <= a);return a - b;
13   }
14   function add(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a + b;assert(c >= a);return c;
16   }
17 }
18 contract ERC20Basic {
19   uint256 public totalSupply;
20   function balanceOf(address who) public view returns (uint256);
21   function transfer(address to, uint256 value) public returns (bool);
22   event Transfer(address indexed from, address indexed to, uint256 value);
23 }
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) public view returns (uint256);
26   function transferFrom(address from, address to, uint256 value) public returns (bool);
27   function approve(address spender, uint256 value) public returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 contract BasicToken is ERC20 {
31   using SafeMath for uint256;
32   mapping(address => uint256) balances;
33   function transfer(address _to, uint256 _value) public returns (bool) {
34     require(_to != address(0));
35     require(_value <= balances[msg.sender]);
36     balances[msg.sender] = balances[msg.sender].sub(_value);
37     balances[_to] = balances[_to].add(_value);
38     Transfer(msg.sender, _to, _value);
39     return true;
40   }
41   function balanceOf(address _owner) public view returns (uint256 balance) {
42     return balances[_owner];
43   }
44 }
45 contract ERC20Standard is BasicToken {
46   mapping (address => mapping (address => uint256)) internal allowed;
47   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
48     require(_to != address(0));
49     require(_value <= balances[_from]);
50     require(_value <= allowed[_from][msg.sender]);
51     balances[_from] = balances[_from].sub(_value);
52     balances[_to] = balances[_to].add(_value);
53     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
54     Transfer(_from, _to, _value);
55     return true;
56   }
57   function approve(address _spender, uint256 _value) public returns (bool) {
58     allowed[msg.sender][_spender] = _value;
59     Approval(msg.sender, _spender, _value);
60     return true;
61   }
62   function allowance(address _owner, address _spender) public view returns (uint256) {
63     return allowed[_owner][_spender];
64   }
65   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
66     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
67     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
68     return true;
69   }
70   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
71     uint oldValue = allowed[msg.sender][_spender];
72     if (_subtractedValue > oldValue) {
73       allowed[msg.sender][_spender] = 0;
74     } else {
75       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
76     }
77     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
78     return true;
79   }
80 }
81 contract StrategicToken is ERC20Standard {
82     string public constant name = "StrategicToken";
83     string public constant symbol = "STRT";
84     uint8 public constant decimals = 18;
85     uint256 public constant maxSupply = 300000000 * (10 ** uint256(decimals));
86     uint256 public STRTToEth;
87     uint256 public ethInWei;    
88     address public devWallet;
89     function StrategicToken () public {
90         totalSupply = maxSupply;
91         balances[msg.sender] = maxSupply;
92         STRTToEth = 100000;
93         devWallet = msg.sender;
94       }
95     function() payable{
96         ethInWei = ethInWei + msg.value;
97         uint256 amount = msg.value * STRTToEth;
98         if (balances[devWallet] < amount) {return;}//require
99         balances[devWallet] = balances[devWallet] - amount;
100         balances[msg.sender] = balances[msg.sender] + amount;
101         Transfer(devWallet, msg.sender, amount);
102         devWallet.send(msg.value);
103     }
104   }