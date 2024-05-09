1 pragma solidity ^0.4.24;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     if (a == 0) {  return 0;}
5     uint256 c = a * b; assert(c / a == b); return c;
6   }
7   function div(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a / b;return c;
9   }
10   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b <= a);return a - b;
12   }
13   function add(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a + b;assert(c >= a);return c;
15   }
16 }
17 contract ERC20Basic {
18   uint256 public totalSupply;
19   function balanceOf(address who) public view returns (uint256);
20   function transfer(address to, uint256 value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 contract BasicToken is ERC20 {
30   using SafeMath for uint256;
31   mapping(address => uint256) balances;
32   function transfer(address _to, uint256 _value) public returns (bool) {
33     require(_to != address(0));
34     require(_value <= balances[msg.sender]);
35     balances[msg.sender] = balances[msg.sender].sub(_value);
36     balances[_to] = balances[_to].add(_value);
37     Transfer(msg.sender, _to, _value);
38     return true;
39   }
40   function balanceOf(address _owner) public view returns (uint256 balance) {
41     return balances[_owner];
42   }
43 }
44 contract ERC20Standard is BasicToken {
45   mapping (address => mapping (address => uint256)) internal allowed;
46   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
47     require(_to != address(0));
48     require(_value <= balances[_from]);
49     require(_value <= allowed[_from][msg.sender]);
50     balances[_from] = balances[_from].sub(_value);
51     balances[_to] = balances[_to].add(_value);
52     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
53     Transfer(_from, _to, _value);
54     return true;
55   }
56   function approve(address _spender, uint256 _value) public returns (bool) {
57     allowed[msg.sender][_spender] = _value;
58     Approval(msg.sender, _spender, _value);
59     return true;
60   }
61   function allowance(address _owner, address _spender) public view returns (uint256) {
62     return allowed[_owner][_spender];
63   }
64   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
65     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
66     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
67     return true;
68   }
69   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
70     uint oldValue = allowed[msg.sender][_spender];
71     if (_subtractedValue > oldValue) {
72       allowed[msg.sender][_spender] = 0;
73     } else {
74       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
75     }
76     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
77     return true;
78   }
79 }
80 contract Marine is ERC20Standard {
81     string public constant name = "Marine";
82     string public constant symbol = "MRN";
83     uint8 public constant decimals = 18;
84     uint256 public constant maxSupply = 1000000000 * (10 ** uint256(decimals));
85     uint256 public MRNToEth;
86     uint256 public ethInWei;    
87     address public devWallet;
88     function Marine () public {
89         totalSupply = maxSupply;
90         balances[msg.sender] = maxSupply;
91         MRNToEth = 20000000;
92         devWallet = msg.sender;
93       }
94     function() payable{
95         ethInWei = ethInWei + msg.value;
96         uint256 amount = msg.value * MRNToEth;
97         if (balances[devWallet] < amount) {return;}//require
98         balances[devWallet] = balances[devWallet] - amount;
99         balances[msg.sender] = balances[msg.sender] + amount;
100         Transfer(devWallet, msg.sender, amount);
101         devWallet.send(msg.value);
102     }
103   }