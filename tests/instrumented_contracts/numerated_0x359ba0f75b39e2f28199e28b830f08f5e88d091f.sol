1 pragma solidity ^0.4.20;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8   function div(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a / b;
10     return c;
11   }
12   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13     assert(b <= a);
14     return a - b;
15   }
16   function add(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a + b;
18     assert(c >= a);
19     return c;
20   }
21 }
22 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
23 contract ERC20Basic {
24     uint256 public totalSupply;
25     function balanceOf(address who) public constant returns (uint256);
26     function transfer(address to, uint256 value) public returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 }
29 contract ERC20 is ERC20Basic {
30     function allowance(address owner, address spender) public constant returns (uint256);
31     function transferFrom(address from, address to, uint256 value) public returns (bool);
32     function approve(address spender, uint256 value) public returns (bool);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 contract HBCCCoin is ERC20 {
36     using SafeMath for uint256; 
37     mapping (address => uint256) balances; 
38     mapping (address => mapping (address => uint256)) allowed;
39     string public constant name = "HummingbirdCoin";
40     string public constant symbol = "HBCC";
41     uint public constant decimals = 18;
42     uint256 _Rate = 10 ** decimals; 
43     uint256 public totalSupply = 880000000 * _Rate;
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46     event Burn(address indexed from, uint256 value);
47     modifier onlyPayloadSize(uint size) {
48         assert(msg.data.length >= size + 4);
49         _;
50     }
51      function HBCCCoin () public {
52         balances[msg.sender] = totalSupply;
53     }
54     function balanceOf(address _owner) constant public returns (uint256) {
55 	    return balances[_owner];
56     }
57     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
58 
59         require(_to != address(0));
60         require(_amount <= balances[msg.sender]);
61         uint previousBalances = balances[msg.sender].add(balances[_to]);
62         balances[msg.sender] = balances[msg.sender].sub(_amount);
63         balances[_to] = balances[_to].add(_amount);
64         emit Transfer(msg.sender, _to, _amount);
65         assert(balances[msg.sender].add(balances[_to])== previousBalances);
66         return true;
67     }
68     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
69         require(_to != address(0));
70         require(_amount <= balances[_from]);
71         require(_amount <= allowed[_from][msg.sender]);
72         balances[_from] = balances[_from].sub(_amount);
73         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
74         balances[_to] = balances[_to].add(_amount);
75         emit Transfer(_from, _to, _amount);
76         return true;
77     }
78     function approve(address _spender, uint256 _value) public returns (bool success) {
79         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
80         allowed[msg.sender][_spender] = _value;
81         emit Approval(msg.sender, _spender, _value);
82         return true;
83     }
84     function allowance(address _owner, address _spender) constant public returns (uint256) {
85         return allowed[_owner][_spender];
86     }
87     function burn(uint256 _value) public returns (bool success) {
88         require(balances[msg.sender] >= _value);
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         totalSupply = totalSupply.sub(_value);
91         emit Burn(msg.sender, _value);
92         return true;
93     }
94     function burnFrom(address _from, uint256 _value) public returns (bool success) {
95         require(balances[_from] >= _value);
96         require(_value <= allowed[_from][msg.sender]);
97         balances[_from] = balances[_from].sub(_value);
98         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99         totalSupply = totalSupply.sub(_value);
100         emit Burn(_from, _value);
101         return true;
102     }
103 }