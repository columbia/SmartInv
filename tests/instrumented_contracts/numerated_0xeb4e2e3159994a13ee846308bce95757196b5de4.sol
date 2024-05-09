1 pragma solidity 0.4.24;
2 contract SafeMath {
3   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
4     assert(b <= a);
5     return a - b;
6   }
7   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a + b;
9     assert(c>=a && c>=b);
10     return c;
11   }
12 }
13 contract owned {
14     address public owner;
15     constructor() public {
16         owner = msg.sender;
17     }
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22     function transferOwnership(address newOwner) onlyOwner public {
23         if (newOwner != address(0)) {
24         owner = newOwner;
25       }
26     }
27 }
28 contract HermesBlockTechToken is SafeMath,owned {
29     string public name;
30     string public symbol;
31     uint8 public decimals = 18;
32     uint256 public totalSupply; 
33     mapping (address => uint256) public balanceOf;
34     mapping (address => mapping (address => uint256)) public allowance;
35     mapping (address => bool) public frozenAccount;
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Freeze(address indexed from, bool frozen);
38     constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
39         totalSupply = initialSupply * 10 ** uint256(decimals);
40         balanceOf[msg.sender] = totalSupply;
41         name = tokenName;
42         symbol = tokenSymbol;
43     }
44     function _transfer(address _from, address _to, uint256 _value) internal {
45       require(_to != 0x0);
46       require(_value > 0);
47       require(balanceOf[_from] >= _value);
48       require(balanceOf[_to] + _value > balanceOf[_to]);
49       require(!frozenAccount[_from]);
50       require(!frozenAccount[_to]);
51       uint previousBalances = SafeMath.safeAdd(balanceOf[_from] , balanceOf[_to]);
52       balanceOf[_from] = SafeMath.safeSub( balanceOf[_from] , _value);
53       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] , _value);
54       emit Transfer(_from, _to, _value);
55       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
56     }
57     function transfer(address _to, uint256 _value) public returns (bool success) {
58         _transfer(msg.sender, _to, _value);
59         return true;
60     }
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
62       require(_to != 0x0);
63       require(_value > 0);
64       require(balanceOf[_from] >= _value);
65       require(balanceOf[_to] + _value > balanceOf[_to]);
66       require(!frozenAccount[_from]);
67       require(!frozenAccount[_to]);
68       require(_value <= allowance[_from][msg.sender]); 
69       uint previousBalances = SafeMath.safeAdd(balanceOf[_from] , balanceOf[_to]);
70       allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender] , _value);
71       balanceOf[_from] = SafeMath.safeSub( balanceOf[_from] , _value);
72       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] , _value);
73       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74       emit Transfer(_from, _to, _value);
75       return true;
76     }
77     function approve(address _spender, uint256 _value) public returns (bool success) {
78         require(_spender != 0x0);
79         require(_value > 0);
80         require(balanceOf[_spender] >= _value);
81         require(!frozenAccount[msg.sender]);
82         require(!frozenAccount[_spender]);
83         allowance[msg.sender][_spender] = _value;
84         return true;
85     }
86     function freezeMethod(address target, bool frozen) onlyOwner public returns (bool success){
87         require(target != 0x0);
88         frozenAccount[target] = frozen;
89         emit Freeze(target, frozen);
90         return true;
91     }
92 }