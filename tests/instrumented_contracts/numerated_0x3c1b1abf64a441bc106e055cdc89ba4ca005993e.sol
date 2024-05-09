1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4   function mulSafe(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6        return 0;
7      }
8      uint256 c = a * b;
9      assert(c / a == b);
10      return c;
11    }
12 
13   function divSafe(uint256 a, uint256 b) internal pure returns (uint256) {
14      uint256 c = a / b;
15      return c;
16   }
17 
18   function subSafe(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20      return a - b;
21    }
22 
23   function addSafe(uint256 a, uint256 b) internal pure returns (uint256) {
24      uint256 c = a + b;
25     assert(c >= a);
26      return c;
27    }
28 }
29 
30 contract Owned {
31     address public owner;
32     address public newOwner;
33 
34     event OwnershipTransferred(address indexed _from, address indexed _to);
35 
36     function Constructor() public { owner = msg.sender; }
37 
38     modifier onlyOwner {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address _newOwner) public onlyOwner {
44         newOwner = _newOwner;
45     }
46     function acceptOwnership() public {
47         require(msg.sender == newOwner);
48         OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50         newOwner = address(0);
51     }
52 }
53 
54 
55 contract ERC20 {
56    uint256 public totalSupply;
57    function balanceOf(address who) public view returns (uint256);
58    function transfer(address to, uint256 value) public returns (bool);
59    event Transfer(address indexed from, address indexed to, uint256 value);
60    function allowance(address owner, address spender) public view returns (uint256);
61    function transferFrom(address from, address to, uint256 value) public returns (bool);
62    function approve(address spender, uint256 value) public returns (bool);
63    event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract ERC223 {
67     function transfer(address to, uint value, bytes data) public;
68     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
69 }
70 
71 contract ERC223ReceivingContract { 
72     function tokenFallback(address _from, uint _value, bytes _data) public;
73 }
74 
75 contract StandardToken is ERC20, ERC223, SafeMath, Owned {
76 
77    mapping(address => uint256) balances;
78    mapping (address => mapping (address => uint256)) internal allowed;
79 
80    function transfer(address _to, uint256 _value) public returns (bool) {
81      require(_to != address(0));
82      require(_value <= balances[msg.sender]);
83      balances[msg.sender] = subSafe(balances[msg.sender], _value);
84      balances[_to] = addSafe(balances[_to], _value);
85      Transfer(msg.sender, _to, _value);
86      return true;
87    }
88 
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91    }
92 
93   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95      require(_value <= balances[_from]);
96      require(_value <= allowed[_from][msg.sender]);
97 
98     balances[_from] = subSafe(balances[_from], _value);
99      balances[_to] = addSafe(balances[_to], _value);
100      allowed[_from][msg.sender] = subSafe(allowed[_from][msg.sender], _value);
101     Transfer(_from, _to, _value);
102      return true;
103    }
104 
105    function approve(address _spender, uint256 _value) public returns (bool) {
106      allowed[msg.sender][_spender] = _value;
107      Approval(msg.sender, _spender, _value);
108      return true;
109    }
110 
111   function allowance(address _owner, address _spender) public view returns (uint256) {
112      return allowed[_owner][_spender];
113    }
114 
115    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
116      allowed[msg.sender][_spender] = addSafe(allowed[msg.sender][_spender], _addedValue);
117      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118      return true;
119    }
120 
121   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
122      uint oldValue = allowed[msg.sender][_spender];
123      if (_subtractedValue > oldValue) {
124        allowed[msg.sender][_spender] = 0;
125      } else {
126        allowed[msg.sender][_spender] = subSafe(oldValue, _subtractedValue);
127     }
128      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129      return true;
130    }
131 
132     function transfer(address _to, uint _value, bytes _data) public {
133         require(_value > 0 );
134         if(isContract(_to)) {
135             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
136             receiver.tokenFallback(msg.sender, _value, _data);
137         }
138         balances[msg.sender] = subSafe(balances[msg.sender], _value);
139         balances[_to] = addSafe(balances[_to], _value);
140         Transfer(msg.sender, _to, _value, _data);
141     }
142 
143     function isContract(address _addr) private view returns (bool is_contract) {
144       uint length;
145       assembly {
146             //retrieve the size of the code on target address, this needs assembly
147             length := extcodesize(_addr)
148       }
149       return (length>0);
150     }
151 
152 }
153 
154 contract HGToken is StandardToken {
155    string public name = 'HGToken';
156    string public symbol = 'HGT';
157    uint public decimals = 8;
158    uint public INITIAL_SUPPLY = 1000000000;
159 
160    uint public _frozeAmount = 400000000;
161    uint _firstUnlockAmmount = 50000000;
162    uint _secondUnlockAmmount = 50000000;
163    uint _firstUnlockTime;
164    uint _secondUnlockTime;
165 
166    function HGToken() public {
167      totalSupply = 500000000;
168      balances[msg.sender] = 500000000;
169      _firstUnlockTime  = now + 31536000;
170      _secondUnlockTime = now + 63072000;
171    }
172 
173    function releaseFirstUnlock() public onlyOwner returns (bool success){
174         require(now >= _firstUnlockTime);
175         require(_firstUnlockAmmount > 0);
176         balances[msg.sender] = addSafe(balances[msg.sender], _firstUnlockAmmount);
177         _firstUnlockAmmount = 0;
178         Transfer(address(0), msg.sender, _firstUnlockAmmount);
179         return true;
180     }
181 
182     function releaseSecondUnlock() public onlyOwner returns (bool success){
183         require(now >= _secondUnlockTime);
184         require(_secondUnlockAmmount > 0);
185         balances[msg.sender] = addSafe(balances[msg.sender], _secondUnlockAmmount);
186         _secondUnlockAmmount = 0;
187         Transfer(address(0), msg.sender, _secondUnlockAmmount);
188         return true;
189     }
190 }