1 pragma solidity ^0.4.20;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) { 
4     if (a == 0) {
5       return 0;
6     }
7     uint256 c = a * b;
8     require(c / a == b);
9     return c;
10   }
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     require(b > 0); //Solidity only automatically asserts when dividing by 0
13     uint256 c = a / b;
14     return c;
15   }
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     require(b <= a);
18     uint256 c = a - b;
19     return c;
20   }
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     require(c >= a);
24     return c;
25   }
26   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
27     require(b != 0);
28     return a % b;
29   }
30 }
31 contract Ownable {
32   address public owner;
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34   function Ownable() public {
35     owner = msg.sender;
36    }
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 }
47 contract XRES is Ownable {
48     using SafeMath for uint256;
49     string public name = "XRES";
50     string public symbol = "XRES";
51     uint256 public decimals = 6; 
52     uint256 public totalSupply = 1000000000 * (10 ** decimals);
53     address public beneficiary = 0x0ae08aaEa7d0ae91a52990A0A2301E04Fa70F07B;
54     mapping (address => uint256) public balanceOf;
55     mapping (address => mapping (address => uint256)) private allowed;
56     mapping (address => bool) public frozenAccount;
57     event FrozenFunds(address target, bool frozen);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60     event Pause();
61     event Unpause();
62     function XRES() public {
63         balanceOf[beneficiary] = totalSupply; // Give the creator all initial tokens
64     }
65     function _transfer(address _from, address _to, uint256 _value) internal {
66         require(_to != address(0));
67         balanceOf[_from] = balanceOf[_from].sub(_value);
68         balanceOf[_to] = balanceOf[_to].add(_value);
69         Transfer(_from, _to, _value);
70       }
71     function transfer(address _to, uint256 _value) public returns (bool success) {
72         if (frozenAccount[msg.sender]) revert(); 
73         require(_to != address(0));
74         require(_value <= balanceOf[msg.sender]);
75         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
76         balanceOf[_to] = balanceOf[_to].add(_value);
77         Transfer(msg.sender, _to, _value);
78         return true;
79     }
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
81         if (frozenAccount[_from]) revert();
82         require(_to != address(0));
83         require(_value <= balanceOf[_from]);
84         require(_value <= allowed[_from][msg.sender]);
85         balanceOf[_from] = balanceOf[_from].sub(_value);
86         balanceOf[_to] = balanceOf[_to].add(_value);
87         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88         Transfer(_from, _to, _value);
89         return true;
90     }
91     function approve(address _spender, uint256 _value) public returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         return true;
95     }
96     function allowance(address _owner, address _spender) public view returns (uint256) {
97         return allowed[_owner][_spender];
98     }
99     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
100         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
101         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102         return true;
103     }
104     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105         uint oldValue = allowed[msg.sender][_spender];
106         if (_subtractedValue > oldValue) {
107           allowed[msg.sender][_spender] = 0;
108         } else {
109           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110         }
111         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112         return true;
113     }
114    function freezeAccount(address _target, bool freeze) public onlyOwner {
115         frozenAccount[_target] = freeze;
116         FrozenFunds(_target, freeze);
117     }
118     function unFreezeAccount(address _target, bool freeze) public onlyOwner {
119         require(frozenAccount[_target] = freeze);
120         frozenAccount[_target] = !freeze;
121         FrozenFunds(_target, !freeze);
122     }
123 }