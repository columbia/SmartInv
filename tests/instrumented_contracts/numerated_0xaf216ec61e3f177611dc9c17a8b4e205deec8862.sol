1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4 
5     /// `owner` is the only address that can call a function with this
6     /// modifier
7     modifier onlyOwner() {
8         require(msg.sender == owner);
9         _;
10     }
11 
12     address public owner;
13 
14     /// @notice The Constructor assigns the message sender to be `owner`
15     function Owned() {
16         owner = msg.sender;
17     }
18 
19     address newOwner=0x0;
20 
21     event OwnerUpdate(address _prevOwner, address _newOwner);
22 
23     ///change the owner
24     function changeOwner(address _newOwner) public onlyOwner {
25         require(_newOwner != owner);
26         newOwner = _newOwner;
27     }
28 
29     /// accept the ownership
30     function acceptOwnership() public{
31         require(msg.sender == newOwner);
32         OwnerUpdate(owner, newOwner);
33         owner = newOwner;
34         newOwner = 0x0;
35     }
36 }
37 contract SafeMath {
38     function SafeMath() {
39     }
40 
41     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
42         uint256 z = _x + _y;
43         assert(z >= _x);
44         return z;
45     }
46 
47     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
48         assert(_x >= _y);
49         return _x - _y;
50     }
51 
52     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
53         uint256 z = _x * _y;
54         assert(_x == 0 || z / _x == _y);
55         return z;
56     }
57 }
58 contract ERC20Token {
59 
60     function name() public constant returns (string name) { name; }
61     function symbol() public constant returns (string symbol) { symbol; }
62     function decimals() public constant returns (uint8 decimals) { decimals; }
63     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
64     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
65     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
66 
67     function transfer(address _to, uint256 _value) public returns (bool success);
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
69     function approve(address _spender, uint256 _value) public returns (bool success);
70 
71 }
72 contract TokenHolder is Owned {
73     function TokenHolder() {
74     }
75 
76     // validates an address - currently only checks that it isn't null
77     modifier validAddress(address _address) {
78         require(_address != 0x0);
79         _;
80     }
81 
82     // verifies that the address is different than this contract address
83     modifier notThis(address _address){
84         require(_address != address(this));
85         _;
86     }
87 
88 }
89 contract SmartToken is ERC20Token,TokenHolder{
90     function generateTokens(address _to, uint256 _amount) public;
91 }
92 
93 contract StandardToken is SmartToken,SafeMath {
94     string public name;
95     uint8 public decimals=18;
96     string public symbol;
97     string public version = 'V0.1';
98     uint256 public totalSupply=0;
99 
100     bool public transferEnabled=false;
101     function StandardToken(string _name, string _symbol) {
102         name = _name;
103         symbol = _symbol;
104     }
105     function transfer(address _to, uint256 _value) transferAllowed returns (bool success) {
106         if (balances[msg.sender] >= _value && _value > 0) {
107             balances[msg.sender] -= _value;
108             balances[_to] += _value;
109             Transfer(msg.sender, _to, _value);
110             return true;
111         } else { return false; }
112     }
113 
114     function transferFrom(address _from, address _to, uint256 _value) transferAllowed returns (bool success) {
115         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
116             balances[_to] += _value;
117             balances[_from] -= _value;
118             allowed[_from][msg.sender] -= _value;
119             Transfer(_from, _to, _value);
120             return true;
121         } else { return false; }
122     }
123 
124     function balanceOf(address _owner) constant returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128     function approve(address _spender, uint256 _value) returns (bool success) {
129         allowed[msg.sender][_spender] = _value;
130         Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
135       return allowed[_owner][_spender];
136     }
137 
138     mapping (address => uint256) balances;
139     mapping (address => mapping (address => uint256)) allowed;
140 
141 
142     /**
143         @dev increases the token supply and sends the new tokens to an account
144         can only be called by the contract owner
145 
146         @param _to         account to receive the new amount
147         @param _amount     amount to increase the supply by
148     */
149     function generateTokens(address _to, uint256 _amount)
150         public
151         onlyOwner
152         validAddress(_to)
153         notThis(_to)
154     {
155         totalSupply = safeAdd(totalSupply, _amount);
156         balances[_to] = safeAdd(balances[_to], _amount);
157 
158         Transfer(this, _to, _amount);
159     }
160     //only owner can destroy the token
161     function destroy(address _from, uint256 _amount)
162         public
163         onlyOwner
164     {
165         balances[_from] = safeSub(balances[_from], _amount);
166         totalSupply = safeSub(totalSupply, _amount);
167 
168         Transfer(_from, this, _amount);
169         Destroy(_from,_amount);
170     }
171     function enableTransfer(bool _enable) public onlyOwner{
172         transferEnabled=_enable;
173     }
174     modifier transferAllowed {
175         assert(transferEnabled);
176         _;
177     }
178 
179     event Destroy(address indexed _from,uint256 _amount);
180     event Transfer(address indexed _from, address indexed _to, uint256 _value);
181     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
182 }