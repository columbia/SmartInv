1 pragma solidity ^0.4.16;
2 
3 /**
4  * The Owned contract ensures that only the creator (deployer) of a 
5  * contract can perform certain tasks.
6  */
7 contract Owned {
8     address public owner = msg.sender;
9     event OwnerChanged(address indexed old, address indexed current);
10     modifier only_owner { require(msg.sender == owner); _; }
11     function setOwner(address _newOwner) only_owner public { emit OwnerChanged(owner, _newOwner); owner = _newOwner; }
12 }
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19     
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43   
44 }
45 
46 contract DepositTiken is Owned {
47     
48     using SafeMath for uint;
49     
50     uint public _money = 0;
51 //  uint public _moneySystem = 0;
52     uint public _tokens = 0;
53     uint public _sellprice = 10**18;
54     uint public contractBalance;
55     
56     // сохранить баланс на счетах пользователя
57     
58     mapping (address => uint) balances;
59     
60     event SomeEvent(address indexed from, address indexed to, uint value, bytes32 status);
61     constructor () public {
62         uint s = 10**18;
63         _sellprice = s.mul(95).div(100);
64     }
65     function balanceOf(address addr) public constant returns(uint){
66         return balances[addr];
67     }
68     function balance() public constant returns(uint){
69         return balances[msg.sender];
70     }
71     // OK
72     function buy() external payable {
73         uint _value = msg.value.mul(10**18).div(_sellprice.mul(100).div(95));
74         
75         _money += msg.value.mul(97).div(100);
76         //_moneySystem += msg.value.mul(3).div(100);
77         
78         owner.transfer(msg.value.mul(3).div(100));
79         
80         _tokens += _value;
81         balances[msg.sender] += _value;
82         
83         _sellprice = _money.mul(10**18).mul(99).div(_tokens).div(100);
84         
85         address _this = this;
86         contractBalance = _this.balance;
87         
88         emit SomeEvent(msg.sender, this, _value, "buy");
89     }
90     
91     function sell (uint256 countTokens) public {
92         require(balances[msg.sender] - countTokens >= 0);
93         
94         uint _value = countTokens.mul(_sellprice).div(10**18);
95         
96         _money -= _value;
97         
98         _tokens -= countTokens;
99         balances[msg.sender] -= countTokens;
100         
101         if(_tokens > 0) {
102             _sellprice = _money.mul(10**18).mul(99).div(_tokens).div(100);
103         }
104         
105         address _this = this;
106         contractBalance = _this.balance;
107         
108         msg.sender.transfer(_value);
109         
110         emit SomeEvent(msg.sender, this, _value, "sell");
111     }
112     function getPrice() public constant returns (uint bid, uint ask) {
113         bid = _sellprice.mul(100).div(95);
114         ask = _sellprice;
115     }
116 }