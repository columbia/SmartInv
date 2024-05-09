1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 // ERC20 Interface
31 contract ERC20 {
32     function totalSupply() public view returns (uint _totalSupply);
33     function balanceOf(address _owner) public view returns (uint balance);
34     function transfer(address _to, uint _value) public returns (bool success);
35     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
36     function approve(address _spender, uint _value) public returns (bool success);
37     function allowance(address _owner, address _spender) public view returns (uint remaining);
38     event Transfer(address indexed _from, address indexed _to, uint _value);
39     event Approval(address indexed _owner, address indexed _spender, uint _value);
40 }
41 
42 contract Owned {
43     address public owner;
44     address public newOwner;
45     modifier onlyOwner {require(msg.sender == owner); _;}
46     event OwnershipTransferred(address _prevOwner, address _newOwner);
47 
48     function Owned() public {
49         owner = msg.sender;
50     }
51 
52     function transferOwnership(address _newOwner) onlyOwner public {
53         require(_newOwner != address(0));
54         OwnershipTransferred(owner, _newOwner);
55         owner = _newOwner;
56     }
57 }
58 
59 // ERC20Token
60 contract ERC20Token is ERC20 {
61     using SafeMath for uint256;
62     mapping(address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64     uint256 public totalToken;
65 
66     function transfer(address _to, uint256 _value) public returns (bool success) {
67         if (balances[msg.sender] >= _value && _value > 0) {
68             balances[msg.sender] = balances[msg.sender].sub(_value);
69             balances[_to] = balances[_to].add(_value);
70             Transfer(msg.sender, _to, _value);
71             return true;
72         } else {
73             return false;
74         }
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
79             balances[_from] = balances[_from].sub(_value);
80             balances[_to] = balances[_to].add(_value);
81             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82             Transfer(_from, _to, _value);
83             return true;
84         } else {
85             return false;
86         }
87     }
88 
89     function totalSupply() public view returns (uint256) {
90         return totalToken;
91     }
92 
93     function balanceOf(address _owner) public view returns (uint256 balance) {
94         return balances[_owner];
95     }
96 
97     function approve(address _spender, uint256 _value) public returns (bool success) {
98         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
105         return allowed[_owner][_spender];
106     }
107 
108 }
109 
110 contract WEETtoken is ERC20Token, Owned {
111 
112     string  public constant name = "Weet Token";
113     string  public constant symbol = "WEET";
114     uint256 public constant decimals = 18;
115     uint256 public tokenDestroyed;
116     event Burn(address indexed _from, uint256 _tokenDestroyed, uint256 _timestamp);
117 
118     function WEETtoken() public {
119         totalToken = 1000000000 * (10**(uint256(decimals)));
120         balances[msg.sender] = totalToken;
121     }
122 
123     function burn (uint256 _burntAmount) public returns (bool success) {
124         require(balances[msg.sender] >= _burntAmount && _burntAmount > 0);
125         balances[msg.sender] = balances[msg.sender].sub(_burntAmount);
126         totalToken = totalToken.sub(_burntAmount);
127         tokenDestroyed = tokenDestroyed.add(_burntAmount);
128         require (tokenDestroyed <= 100000000000000000000000000);
129         Transfer(address(this), 0x0, _burntAmount);
130         Burn(msg.sender, _burntAmount, block.timestamp);
131         return true;
132     }
133 
134     function () public payable {
135         revert();
136     }
137 }