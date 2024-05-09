1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-15
3 */
4 
5 pragma solidity ^0.5.1;
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         if (a == 0) {
9             return 0;
10         }
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a / b;
17     }
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 contract Ownable {
29     address public owner;
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31    constructor() public {
32       owner = msg.sender;
33     }
34     modifier onlyOwner() {
35       require(msg.sender == owner);
36       _;
37     }
38     function transferOwnership(address newOwner) public onlyOwner {
39       require(newOwner != address(0));
40       emit OwnershipTransferred(owner, newOwner);
41       owner = newOwner;
42     }
43 }
44 contract ERC20Basic {
45     function totalSupply() public view returns (uint256);
46     function balanceOf(address who) public view returns (uint256);
47     function transfer(address to, uint256 value) public returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 contract ERC20 is ERC20Basic {
51     function allowance(address owner, address spender) public view returns (uint256);
52     function transferFrom(address from, address to, uint256 value) public returns (bool);
53     function approve(address spender, uint256 value) public returns (bool);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 contract BasicToken is ERC20Basic {
57     using SafeMath for uint256;
58     mapping(address => uint256) balances;
59     uint256 totalSupply_;
60     function totalSupply() public view returns (uint256) {
61         return totalSupply_;
62     }
63     function transfer(address _to, uint256 _value) public returns (bool) {
64         require(_to != address(0));
65         require(_value <= balances[msg.sender]);
66         balances[msg.sender] = balances[msg.sender].sub(_value);
67         balances[_to] = balances[_to].add(_value);
68         emit Transfer(msg.sender, _to, _value);
69         return true;
70     }
71     function balanceOf(address _owner) public view returns (uint256) {
72         return balances[_owner];
73     }
74 }
75 contract StandardToken is ERC20, BasicToken {
76     mapping (address => mapping (address => uint256)) internal allowed;
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79         require(_value <= balances[_from]);
80         require(_value <= allowed[_from][msg.sender]);
81         balances[_from] = balances[_from].sub(_value);
82         balances[_to] = balances[_to].add(_value);
83         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
84         emit Transfer(_from, _to, _value);
85         return true;
86     }
87     function approve(address _spender, uint256 _value) public returns (bool) {
88         allowed[msg.sender][_spender] = _value;
89         emit Approval(msg.sender, _spender, _value);
90         return true;
91     }
92     function allowance(address _owner, address _spender) public view returns (uint256) {
93         return allowed[_owner][_spender];
94     }
95     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
96         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
97         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98         return true;
99     }
100     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
101         uint oldValue = allowed[msg.sender][_spender];
102         if (_subtractedValue > oldValue) {
103             allowed[msg.sender][_spender] = 0;
104         } else {
105             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
106         }
107         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
108         return true;
109     }
110 }
111 contract NULL is StandardToken, Ownable {
112     string public constant name = "null.finance";
113     string public constant symbol = "NULL";
114     uint32 public constant decimals = 18;
115     uint256 public constant tokenSupply = 11000*10**18;
116     constructor() public {
117         balances[owner] = balances[owner].add(tokenSupply);
118         totalSupply_ = totalSupply_.add(tokenSupply);
119         emit Transfer(address(this), owner, tokenSupply);
120     }
121 }