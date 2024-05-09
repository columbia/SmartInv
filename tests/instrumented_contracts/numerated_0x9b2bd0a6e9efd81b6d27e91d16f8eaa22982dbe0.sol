1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint) {
5         uint c = a + b;
6         assert(c >= a);
7         return c;
8     }
9 
10     function sub(uint a, uint b) internal pure returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function mul(uint a, uint b) internal pure returns (uint) {
16         if (a == 0 || b == 0) {
17             return 0;
18         }
19         uint c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     function div(uint a, uint b) internal pure returns (uint) {
25         require(b > 0);
26         uint c = a / b;
27         return c;
28     }
29 }
30 
31 contract ERC20 {
32     uint public totalSupply;
33 
34     function transferFrom(address _from, address _to, uint _value) public returns (bool);
35     function approve(address _spender, uint _value) public returns (bool);
36     function balanceOf(address _owner) public view returns (uint);
37     function transfer(address _to, uint _value) public returns (bool);
38 
39     event Transfer(address indexed _from, address indexed _to, uint _value);
40     event Burn(address indexed _from, uint _value);
41     event Approval(address indexed _owner, address indexed _spender, uint _value);
42 }
43 
44 contract StandardToken is ERC20 {
45     using SafeMath for uint;
46 
47     mapping(address => mapping(address => uint)) allowed;
48     mapping(address => uint) balances;
49 
50     function balanceOf(address _owner) public view returns (uint) {
51         return balances[_owner];
52     }
53 
54     function transfer(address _to, uint _value) public returns (bool) {
55         require(balances[msg.sender] >= _value);
56         require(balances[_to] + _value > balances[_to]);
57         balances[msg.sender] = balances[msg.sender].sub(_value);
58         balances[_to] = balances[_to].add(_value);
59         Transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
64         var _allowance = allowed[_from][msg.sender];
65 
66         require(_value <= _allowance);
67 
68         balances[_from] = balances[_from].sub(_value);
69         balances[_to] = balances[_to].add(_value);
70 
71         allowed[_from][msg.sender] = _allowance.sub(_value);
72         Transfer(_from, _to, _value);
73         return true;
74     }
75 
76     function approve(address _spender, uint _value) public returns (bool) {
77         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
79 
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) public view returns (uint) {
86         return allowed[_owner][_spender];
87     }
88 }
89 
90 contract Ownable {
91     function Ownable() public {
92         owner = msg.sender;
93     }
94 
95     address public owner;
96 
97     modifier onlyOwner() {
98         require(msg.sender == owner);
99         _;
100     }
101 
102     function transferOwnership(address newOwner) public onlyOwner {
103         if (newOwner != address(0x0)) {
104             owner = newOwner;
105         }
106     }
107 }
108 
109 interface tokenRecipient {
110     function receiveApproval(address _from, uint _value, address _token, bytes _data) public;
111 }
112 
113 contract BurnCoinToken is StandardToken, Ownable {
114     string public constant name = 'Burn Coin';
115     string public constant symbol = 'BRN';
116     uint public constant decimals = 8;
117     uint public totalSupply = 500000000 * 10 ** uint(decimals); //500,000,000
118     mapping (address => bool) public frozenAccounts;
119 
120     event FrozenFunds(address _target, bool frozen);
121 
122     function BurnCoinToken () public {
123         balances[msg.sender] = totalSupply;
124         Transfer(address(0x0), msg.sender, totalSupply);
125     }
126 
127     modifier validateDestination(address _to) {
128         require(_to != address(0x0));
129         require(_to != address(this));
130         _;
131     }
132 
133     function transfer(address _to, uint _value) validateDestination(_to) public returns (bool) {
134         require(!frozenAccounts[msg.sender]);
135         require(!frozenAccounts[_to]);
136         uint previousBalances = balances[msg.sender] + balances[_to];
137         bool transferResult = super.transfer(_to, _value);
138         assert(balances[msg.sender] + balances[_to] == previousBalances);
139         return transferResult;
140     }
141 
142     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
143         require(!frozenAccounts[_from]);
144         require(!frozenAccounts[_to]);
145         bool transferResult = super.transferFrom(_from, _to, _value);
146 
147     }
148 
149     function burn(uint _value) public returns (bool) {
150         require(balances[msg.sender] >= _value);
151         balances[msg.sender] = balances[msg.sender].sub(_value);
152         totalSupply = totalSupply.sub(_value);
153         Burn(msg.sender, _value);
154         return true;
155     }
156 
157     function burnFrom(address _from, uint _value) public returns (bool) {
158         require(balances[_from] >= _value);
159         require(allowed[_from][msg.sender] >= _value);
160         balances[_from] = balances[_from].sub(_value);
161         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162         totalSupply = totalSupply.sub(_value);
163         Burn(_from, _value);
164         return true;
165     }
166 }