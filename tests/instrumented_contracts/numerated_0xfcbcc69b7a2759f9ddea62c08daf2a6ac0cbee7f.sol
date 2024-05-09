1 pragma solidity ^0.4.17;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract ERC223ReceivingContract {
21 
22     function tokenFallback(address _from, uint256 _value, bytes _data) public;
23 }
24 
25 contract Token {
26 
27     uint256 public totalSupply;
28 
29 
30     //ERC 20
31     function balanceOf(address _owner) public constant returns (uint256 balance);
32     function transfer(address _to, uint256 _value) public returns (bool success);
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34     function approve(address _spender, uint256 _value) public returns (bool success);
35     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
36 
37     // ERC 223
38     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 
43 }
44 
45 
46 contract StandardToken is Token {
47 
48     mapping (address => uint256) balances;
49     mapping (address => mapping (address => uint256)) allowed;
50 
51     function transfer(address _to, uint256 _value) public returns (bool) {
52         require(_to != 0x0);
53         require(_to != address(this));
54         require(balances[msg.sender] >= _value);
55         require(balances[_to] + _value >= balances[_to]);
56 
57         balances[msg.sender] -= _value;
58         balances[_to] += _value;
59 
60         Transfer(msg.sender, _to, _value);
61 
62         return true;
63     }
64 
65     function transfer(
66         address _to,
67         uint256 _value,
68         bytes _data)
69         public
70         returns (bool)
71     {
72         require(transfer(_to, _value));
73 
74         uint codeLength;
75 
76         assembly {
77             // Retrieve the size of the code on target address, this needs assembly.
78             codeLength := extcodesize(_to)
79         }
80 
81         if (codeLength > 0) {
82             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
83             receiver.tokenFallback(msg.sender, _value, _data);
84         }
85 
86         return true;
87     }
88 
89     function transferFrom(address _from, address _to, uint256 _value)
90         public
91         returns (bool)
92     {
93         require(_from != 0x0);
94         require(_to != 0x0);
95         require(_to != address(this));
96         require(balances[_from] >= _value);
97         require(allowed[_from][msg.sender] >= _value);
98         require(balances[_to] + _value >= balances[_to]);
99 
100         balances[_to] += _value;
101         balances[_from] -= _value;
102         allowed[_from][msg.sender] -= _value;
103 
104         Transfer(_from, _to, _value);
105 
106         return true;
107     }
108 
109     function approve(address _spender, uint256 _value) public returns (bool) {
110         require(_spender != 0x0);
111 
112         require(_value == 0 || allowed[msg.sender][_spender] == 0);
113 
114         allowed[msg.sender][_spender] = _value;
115         Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     function allowance(address _owner, address _spender)
120         constant
121         public
122         returns (uint256)
123     {
124         return allowed[_owner][_spender];
125     }
126 
127     function balanceOf(address _owner) constant public returns (uint256) {
128         return balances[_owner];
129     }
130 }
131 
132 
133 contract NewPazCoin is owned, StandardToken {
134 
135     string constant public name = "PazCoin";
136     string constant public symbol = "PAZ";
137     uint8 constant public decimals = 18;
138     uint constant multiplier = 1000000000000000000;
139 
140 
141     mapping (address => bool) public frozenAccount;
142 
143     event FrozenFunds(address target, bool frozen);
144     event Deployed(uint indexed _total_supply);
145     event Burnt(
146         address indexed _receiver,
147         uint indexed _num,
148         uint indexed _total_supply
149     );
150 
151     function NewPazCoin(
152         address wallet_address,
153         uint initial_supply)
154         public
155     {
156         require(wallet_address != 0x0);
157 
158         totalSupply = initial_supply;
159 
160         balances[wallet_address] = initial_supply;
161 
162         Transfer(0x0, wallet_address, balances[wallet_address]);
163 
164         Deployed(totalSupply);
165 
166         assert(totalSupply == balances[wallet_address]);
167     }
168 
169     function burn(uint num) public {
170         require(num > 0);
171         require(balances[msg.sender] >= num);
172         require(totalSupply >= num);
173 
174         uint pre_balance = balances[msg.sender];
175 
176         balances[msg.sender] -= num;
177         totalSupply -= num;
178         Burnt(msg.sender, num, totalSupply);
179         Transfer(msg.sender, 0x0, num);
180 
181         assert(balances[msg.sender] == pre_balance - num);
182     }
183     
184         function freezeAccount(address target, bool freeze) onlyOwner public {
185         frozenAccount[target] = freeze;
186         FrozenFunds(target, freeze);
187     }
188     
189     
190 
191 }