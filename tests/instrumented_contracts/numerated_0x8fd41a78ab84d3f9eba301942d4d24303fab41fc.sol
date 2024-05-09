1 pragma solidity ^0.4.18;
2     
3     library SafeMath {
4     
5       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7           return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12       }
13 
14       function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a / b;
16         return c;
17       }
18     
19 
20       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23       }
24     
25       function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29       }
30     }
31     
32     contract ERC20Basic {
33       function totalSupply() public view returns (uint256);
34       function balanceOf(address who) public view returns (uint256);
35       function transfer(address to, uint256 value) public returns (bool);
36       event Transfer(address indexed from, address indexed to, uint256 value);
37     }
38     contract ERC20 is ERC20Basic {
39       function allowance(address owner, address spender) public view returns (uint256);
40       function transferFrom(address from, address to, uint256 value) public returns (bool);
41       function approve(address spender, uint256 value) public returns (bool);
42       event Approval(address indexed owner, address indexed spender, uint256 value);
43     }
44     contract BasicToken is ERC20Basic {
45       using SafeMath for uint256;
46     
47       mapping(address => uint256) balances;
48     
49       uint256 totalSupply_;
50     
51       function totalSupply() public view returns (uint256) {
52         return totalSupply_;
53       }
54     
55       function transfer(address _to, uint256 _value) public returns (bool) {
56         require(_to != address(0));
57         require(_value <= balances[msg.sender]);
58     
59         // SafeMath.sub will throw if there is not enough balance.
60         balances[msg.sender] = balances[msg.sender].sub(_value);
61         balances[_to] = balances[_to].add(_value);
62         Transfer(msg.sender, _to, _value);
63         return true;
64       }
65     
66       function balanceOf(address _owner) public view returns (uint256 balance) {
67         return balances[_owner];
68       }
69     }
70     contract StandardToken is ERC20, BasicToken {
71       mapping (address => mapping (address => uint256)) internal allowed;
72    
73       function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
74         require(_to != address(0));
75         require(_value <= balances[_from]);
76         require(_value <= allowed[_from][msg.sender]);
77     
78         balances[_from] = balances[_from].sub(_value);
79         balances[_to] = balances[_to].add(_value);
80         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81         Transfer(_from, _to, _value);
82         return true;
83       }
84    
85       function approve(address _spender, uint256 _value) public returns (bool) {
86         allowed[msg.sender][_spender] = _value;
87        Approval(msg.sender, _spender, _value);
88         return true;
89       }
90     
91       function allowance(address _owner, address _spender) public view returns (uint256) {
92         return allowed[_owner][_spender];
93       }
94     
95       function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
96         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
97        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98         return true;
99       }
100     
101       function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
102         uint oldValue = allowed[msg.sender][_spender];
103         if (_subtractedValue > oldValue) {
104           allowed[msg.sender][_spender] = 0;
105         } else {
106           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
107         }
108        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109         return true;
110       }
111     
112     }
113     contract TripBitToken is StandardToken {
114     
115       string public constant name = "TripBit"; // solium-disable-line uppercase
116       string public constant symbol = "TBT"; // solium-disable-line uppercase
117       uint8 public constant decimals = 18; // solium-disable-line uppercase
118       uint256 public constant INITIAL_SUPPLY = 700000000 * (10 ** uint256(decimals));
119     
120       function TripBitToken() public {
121         totalSupply_ = INITIAL_SUPPLY;
122         balances[msg.sender] = INITIAL_SUPPLY;
123        Transfer(0x0, msg.sender, INITIAL_SUPPLY);
124 	   }
125     }